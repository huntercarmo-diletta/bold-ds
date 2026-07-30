# Deploy do catálogo no Cloudflare — Worker de assets + Access

O catálogo do Bold vira um **Worker que serve arquivos estáticos** (sem uma linha de código de Worker),
e o acesso é trancado pelo **Cloudflare Access**. As duas coisas são separadas de propósito: o deploy
publica, o Access decide quem entra.

## Por que o build é LOCAL, e não no Cloudflare

Não é preguiça, é medição. O catálogo depende dos dois pais por `git:` **sobre SSH do Bitbucket**:

```yaml
diletta_catalog_core:
  git:
    url: git@bitbucket.org:diletta/catalogo-diletta.git
    ref: v0.33.1
```

Nenhum contêiner de build (Cloudflare, Vercel, Pages) tem essa chave — o `flutter pub get` falharia
antes de compilar. Somar uma deploy key em cada CI é mais superfície de segredo pra manter do que este
repo precisa hoje.

E tem o precedente do primeiro filho: **o Cloudflare não conecta Bitbucket** (Workers Builds e Pages só
integram GitHub e GitLab), então "git conectado" aqui significaria publicar a partir do espelho no
GitHub — dois caminhos de publicação, e o repo canônico deixando de ser a fonte.

Build local + `wrangler deploy` publica sem credencial nova em lugar nenhum. Quando o build no CI virar
necessário, o caminho é o do CPF Seguro: pipeline com `CLOUDFLARE_API_TOKEN` + deploy key do Bitbucket.

## O que já está no repo

| arquivo | o que faz |
|---|---|
| `wrangler.jsonc` | declara o Worker `conta-bold-ds` servindo `packages/catalog/build/web`, com fallback SPA |
| `build_web.sh` | builda o catálogo (usa o Flutter da máquina; baixa o SDK só se não houver) |
| `packages/catalog/web/robots.txt` | `Disallow: /` — fora de buscador |
| `packages/catalog/web/index.html` | `<meta name="robots" content="noindex, nofollow">` |

O `noindex` não é redundante com o Access: **Access nenhum desfaz um índice que já aconteceu.**

## Passo a passo

### 1 · Rodar os gates (não publique catálogo vermelho)

```bash
(cd packages/conta_bold_design_system && flutter analyze && flutter test)   # 96
(cd packages/catalog && flutter analyze && flutter test)                    # 19
```

### 2 · Buildar

```bash
bash build_web.sh
```

Saída em `packages/catalog/build/web` (~49 MB, quase tudo CanvasKit). Leva 1-2 minutos.

### 3 · Autenticar no Cloudflare — **confira a CONTA antes de publicar**

```bash
npx wrangler login     # interativo
npx wrangler whoami    # e confirme o e-mail e a conta que apareceram
```

**A sessão que decide é a da CLOUDFLARE, não a do Google.** Isso custou três tentativas: o perfil do
Chrome estava logado no Google como `@dilettasolutions.com` e na Cloudflare como a conta pessoal, então o
"Allow" autorizava a pessoal. O perfil escolhe a sessão do Google; a da Cloudflare é independente.

Então a ordem que funciona é **trocar a sessão ANTES de disparar o login** — a URL de autorização expira
em ~2 minutos, e fazer logout/login dentro dessa janela estoura o prazo:

```bash
open -na "Google Chrome" --args --profile-directory="Profile 19" "https://dash.cloudflare.com/logout"
# entra com a conta do trabalho, e SÓ DEPOIS:
```

Pra cair no perfil certo, o `login` aceita não abrir navegador nenhum:

```bash
npx wrangler login --browser=false          # imprime a URL e espera o callback
open -na "Google Chrome" --args --profile-directory="Profile 19" "<a URL impressa>"
```

`Profile 19` é o perfil do Chrome logado em `huntercarmo@dilettasolutions.com` nesta máquina. Os perfis e
seus e-mails saem de `~/Library/Application Support/Google/Chrome/Local State`
(`profile.info_cache`).

**A armadilha, medida em 2026-07-30:** o `wrangler login` usa a sessão do Cloudflare que já está aberta
no navegador. Se você estiver logado na conta PESSOAL, ele autoriza a pessoal sem perguntar nada — e o
`deploy` publica lá, num subdomínio `workers.dev` que não é o do time. Foi o que aconteceu no primeiro
deploy deste catálogo: ele subiu inteiro na conta pessoal, **aberto**, e teve que ser apagado.

Pra trocar de conta:

```bash
npx wrangler logout
```

…**e sair do Cloudflare no navegador** (ou usar uma janela privada) antes do `login` de novo. Sem isso, a
sessão antiga é reaproveitada e você reautoriza a mesma conta errada.

O `whoami` no fim não é zelo: é a única coisa que distingue as duas contas antes de o site existir.

### 4 · Publicar

```bash
npx wrangler deploy
```

No fim ele imprime a URL, no formato `https://conta-bold-ds.<subdomínio-da-conta>.workers.dev`. O
subdomínio é da CONTA — é por ele que se percebe conta errada depois do fato.

No ar desde 2026-07-30, na conta `huntercarmo@dilettasolutions.com`:

```
https://conta-bold-ds.huntercarmo.workers.dev
```

**Espere uns segundos antes de conferir, e confira MAIS DE UM caminho.** A propagação é irregular: nos
dois deploys deste catálogo, a raiz começou em 404 e virou 200 em segundos, e no segundo deploy
`/main.dart.js` e o fallback SPA ainda respondiam 404 depois de a raiz já estar 200 — normalizaram ~1
minuto depois. Conferir cedo demais, ou conferir só a raiz, faz procurar defeito de configuração onde só
tem tempo.

**Publicar de novo é repetir 2 e 4.** Não há deploy automático no push, e isso é escolha: o catálogo
publica quando alguém decide publicar.

### 5 · Trancar com o Access — é aqui que ninguém entra chutando a URL

No dashboard, e só clicando:

1. **Zero Trust** → **Access** → **Applications** → **Add an application** → **Self-hosted**;
2. **Application name**: `Catálogo Conta BOLD`;
3. **Public hostname**: o host do passo 4 (`conta-bold-ds.<subdomínio>.workers.dev`);
4. **Next** → política:
   - **Policy name**: `time Diletta`
   - **Action**: `Allow`
   - **Include**: `Emails ending in` → `@dilettasolutions.com` (ou `Emails` com a lista nominal);
5. **Next** → em **Authentication**, escolha **One-time PIN** (ver abaixo: ele precisa existir na CONTA
   antes). Quem entra recebe um código por e-mail, sem precisar de conta em lugar nenhum;
6. **Add application**.

#### O One-time PIN é da CONTA, não da aplicação — e não vem ligado

Eu escrevi "deixe o One-time PIN ligado" na primeira versão deste doc e estava errado. A doc da
Cloudflare é explícita: *"OTP is no longer added automatically, but you can set it up at any time."*

Onde ele se liga: **Zero Trust → Integrations → Identity providers → Add new → One-time PIN**. (No
dashboard antigo: Settings → Authentication → Login methods.) É configuração de CONTA — vale pra todas as
aplicações; quem decide por aplicação é a política de e-mails.

No painel **Authentication** da aplicação, então, duas saídas:

- **`Accept all available identity providers` ligado** (o default): o OTP passa a ser aceito assim que
  existir na conta. Funciona, e o custo é que qualquer IdP adicionado à conta depois entra nesta
  aplicação **sem ninguém decidir**;
- **desligar o toggle e escolher `One-time PIN` na lista**: a autenticação deste catálogo fica explícita.
  É o que este repo usa.

E uma ordem que evita ficar de fora do próprio catálogo: **adicione o OTP na conta ANTES de conferir a
aplicação.** Aplicação salva sem nenhum identity provider na conta não deixa ninguém entrar — inclusive
você.

### 5.5 · O que foi medido no primeiro deploy

459 arquivos, 8s de upload. Servindo certo:

| caminho | esperado | medido |
|---|---|---|
| `/` | index | **200** |
| `/main.dart.js` | 2.99 MB | **200** |
| `/flutter.js` · `/flutter_bootstrap.js` | loader | **200** |
| `/rota-que-nao-existe` | index (fallback SPA) | **200** |
| `/robots.txt` | `Disallow: /` | **200** |

O fallback SPA é o que precisava ser conferido, e passou: rota inventada devolve o index em vez de 404,
então recarregar numa subrota do catálogo funciona.

### 6 · Verificar que trancou

```bash
curl -I https://conta-bold-ds.<subdomínio>.workers.dev/
```

Tem que vir **302 pro Access** (`location: .../cdn-cgi/access/login/...`). Se vier **200 com o app, o
Access não pegou** — a aplicação está apontando pro hostname errado, e o catálogo está aberto.

Depois, no navegador: a URL pede e-mail + PIN, e só então carrega o catálogo.

## O que NÃO fazer

- **`_redirects` com `/* /index.html 200`** — o validador do Workers Assets rejeita a regra catch-all
  como loop infinito. O fallback SPA é o `not_found_handling` do `wrangler.jsonc`, e já está lá;
- **conectar o Worker a um repositório Git** enquanto o build for local. Dois caminhos de publicação é
  como um repo velho volta a ser fonte sem ninguém perceber — aconteceu no primeiro filho, e a saída foi
  desconectar;
- **publicar sem rodar os gates.** O catálogo é a ferramenta de quem monta tela: publicado quebrado, ele
  ensina errado.

## Histórico

**2026-07-30 · o primeiro deploy foi na conta ERRADA.** O `wrangler login` pegou a sessão pessoal aberta
no navegador e publicou o catálogo inteiro em `conta-bold-ds.hunter-soares-c.workers.dev`, sem Access.
Consertado na sequência: `wrangler delete --force` na conta pessoal, confirmado por `curl` até a URL
devolver 404, e `wrangler logout`. Por isso o passo 3 agora manda rodar `whoami` **antes** do deploy.

Este repo publicava na **Vercel** até 2026-07-30, e o que ela construía era o app antigo da raiz — um
catálogo que desenhava um fork parado do design system. O app e o fork foram apagados (medição no
README), a config da Vercel saiu com eles, e o Cloudflare passa a ser o caminho único.
