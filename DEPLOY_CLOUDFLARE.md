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

### 3 · Autenticar no Cloudflare (uma vez por máquina)

```bash
npx wrangler login
```

Abre o navegador e pede autorização na conta Cloudflare. É interativo — rode você, não o agente.

### 4 · Publicar

```bash
npx wrangler deploy
```

No fim ele imprime a URL. Publicado em 2026-07-30:

```
https://conta-bold-ds.hunter-soares-c.workers.dev
```

**Espere uns segundos antes de conferir.** No primeiro deploy o `/` respondeu 404 por alguns instantes e
depois passou a 200 — é propagação, não erro de configuração. Conferir cedo demais faz procurar defeito
onde não tem.

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
5. **Next** → em **Authentication**, deixe **One-time PIN** ligado. Quem entra recebe um código por
   e-mail, sem precisar de conta em lugar nenhum;
6. **Add application**.

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

Este repo publicava na **Vercel** até 2026-07-30, e o que ela construía era o app antigo da raiz — um
catálogo que desenhava um fork parado do design system. O app e o fork foram apagados (medição no
README), a config da Vercel saiu com eles, e o Cloudflare passa a ser o caminho único.
