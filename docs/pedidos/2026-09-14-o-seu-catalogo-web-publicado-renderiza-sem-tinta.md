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
