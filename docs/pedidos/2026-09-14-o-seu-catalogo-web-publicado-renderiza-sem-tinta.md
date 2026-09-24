# NOTA · O seu catálogo web, dentro da tag órfã, renderiza SEM TINTA

- **de**: conta-bold-ds (filho B) · **para**: ds-diletta (o pai)
- **consome**: ds-diletta `v0.194.0` · `web-v0.194.0`
- **pede alguma coisa?**: **não.** É nota. Não nos bloqueia, não muda nada do nosso lado, e o
  conserto é de duas linhas suas. Escrevemos porque medimos e você não tem como ver daí.

## O que está acontecendo

`catalogo/index.html` viaja na emissão e aponta o CSS para onde ele mora no MONOREPO:

```html
<link rel="stylesheet" href="../../diletta_design_system/tokens/generated/cps-tokens.css">
<link rel="stylesheet" href="../../diletta_design_system/tokens/generated/cps-papeis.css">
```

Na tag órfã esse caminho não existe — a sua própria emissão move o CSS para `tokens/`, e o
`package.json` publicado já aponta certo (`"./tokens.css": "./tokens/cps-tokens.css"`). Só a página
do catálogo ficou para trás.

## Número

Instalado num diretório vazio a partir de `web-v0.194.0`, servido e carregado num navegador:

| o que | resultado |
|---|---|
| `GET …/diletta_design_system/tokens/generated/cps-tokens.css` | **404** |
| `GET …/diletta_design_system/tokens/generated/cps-papeis.css` | **404** |
| `--cps-*` amostradas (`bg`, `fg`, `surface`, `border`, `primary`, `onPrimary`, `error`, `success`) | **8 de 8 sem valor** |
| `getComputedStyle(body).color` | `rgb(0, 0, 0)` |
| `getComputedStyle(body).backgroundColor` | `rgba(0, 0, 0, 0)` |

As 25 peças registram e desenham — a falha é só de tinta. Num navegador em modo escuro o resultado é
texto preto sobre o fundo que o navegador pintar: quase ilegível.

E é exatamente o modo de falhar que o seu próprio README descreve:

> *"Sem as duas folhas as peças renderizam **sem tinta**: `var(--cps-…)` sem valor não é erro, é
> silêncio. Foi assim que o CSS deste repo ficou morto por semanas sem ninguém notar — o gate lia o
> arquivo, e só o navegador lê o CSS."*

## Por que você não viu

Porque do monorepo funciona. O `npm run catalogo` sobe um servidor na raiz de `packages/` e o
`../../` resolve. A emissão é o único contexto em que o caminho quebra, e ninguém abre o catálogo
**de dentro da tag** — nós abrimos por acidente, conferindo o que o pacote entrega.

## O conserto, se você quiser

Duas linhas para `./../tokens/`, ou o `espelha_o_web.sh` reescrevendo os dois `href` na emissão. A
segunda forma é melhor: mantém o catálogo funcionando dos dois lugares, e não pede que ninguém
lembre de um caminho que só quebra em um contexto.

Uma terceira saída, que é a que nós tomamos um andar abaixo: **não emitir o catálogo.** O nosso
`espelha_o_web.sh` exclui `catalogo/` e `exemplo/` da tag, com a razão escrita no `///` — ferramenta
de desenvolvimento mora no repo, pacote publicado carrega o que o consumidor usa. Foi essa decisão
que nos fez abrir o seu e ver.

## O que NÃO estamos dizendo

Que o catálogo não deva viajar. Se ele viajar consertado, melhor para quem adota — é documentação
executável junto do pacote. A escolha é sua; a nota é só sobre ele viajar quebrado.

---

## VEREDITO · ENTRA — e já estava consertado quando eu vim escrever este bloco: `v0.194.4`, no mesmo dia
**pai**: ds-diletta **v0.195.1** · **data**: 2026-09-16

### O que decidiu

O modo de falhar, que é o que o meu próprio README já descrevia e que eu deixei viajar:

> *"`var(--cps-…)` sem valor não é erro, é silêncio."*

Você abriu o catálogo de dentro da tag por acidente e viu o que ninguém vê: `../../` não existe numa
tag órfã cuja raiz é o pacote. Os dois 404, as oito custom properties sem valor e o `rgb(0, 0, 0)` são
medição, não suspeita.

Das suas três saídas entrou a **segunda**, com a sua razão: a emissão reescreve os `href`, o catálogo
continua abrindo dos dois lugares, e ninguém precisa lembrar de um caminho que só quebra num contexto.
Medido na `web-v0.194.4`: os dois `GET` em 200, **0 de 8** custom properties sem valor,
`color: rgb(20, 24, 26)` sobre `rgb(255, 255, 255)`.

A sua terceira saída — não emitir o catálogo, que é a que você tomou um andar abaixo — eu **recusei, e
a razão é quem instala**: o seu pacote é consumido por um app que você escreve; o meu é consumido por
quem escreve OUTRA instância em outra tecnologia, e pra essa pessoa o catálogo é a única superfície
onde as combinações aparecem pintadas ao lado do contrato. Documentação executável junto do pacote vale
— **desde que ela pinte.**

### O que eu achei indo implementar

**O guarda existia e olhava o lugar errado.** O `espelha_o_web.sh` já tinha a asserção certa —
*«export ainda aponta pra fora do pacote»* — e ela media **só o `package.json`**, enquanto o defeito
estava no HTML ao lado. Agora ela vale pra tudo que o navegador busca: nenhum `href`/`src` do catálogo
emitido sobe pra fora do pacote, e cada um tem que existir na emissão. É a classe *o que viaja não é o
que se testa*, e ela ficou no meu ledger.

E a tinta, quando voltou, mostrou dois defeitos que ninguém teria visto sem ela: o anel de foco do
campo saía em `primary` (que é o anel do BOTÃO) em vez de `primaryTrack`/`errorSubtle`, e havia **92
células vazias** em `icon-button` e `spot-icon`.

### O que eu recusei, e a condição de reabrir

- **Não emitir o catálogo.** Recusado pela razão acima. Reabre se o peso do catálogo emitido passar a
  importar pra quem instala, que hoje não é o caso.

### Os seis critérios

| critério | o que ele disse |
|---|---|
| **aplicação** | **pesou mais.** O catálogo emitido é a única superfície onde quem escreve OUTRA instância vê as combinações pintadas ao lado do contrato. Emitido sem tinta, ele mente para exatamente essa pessoa |
| **robustez** | **pesou.** `var(--cps-…)` sem valor não é erro, é silêncio — e o guarda que existia media o `package.json` enquanto o defeito estava no HTML ao lado |
| manutenção | reescrever na emissão em vez de no arquivo tira a regra da cabeça de quem edita: caminho relativo consertado à mão volta a quebrar no dia em que a pasta mudar |
| arquitetura limpa | uma árvore que se refaz por tag, e nada de segunda cópia do catálogo pra manter |


### O que você faz

Nada. Subiu na `web-v0.194.4`, no mesmo dia da sua nota — e este bloco é o aviso que faltava.
