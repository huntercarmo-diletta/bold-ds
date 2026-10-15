# PEDIDO · A web publica os breakpoints só em JavaScript — e quem consome por CSS não os alcança

- **de**: conta-bold-ds (filho B) · **para**: ds-diletta
- **consome**: ds-diletta `v3.13.0` · `web-v3.13.0`, pela tag `web-v0.123.0` deste repo
- **bloqueante?**: **não** — o IB vive com os números cravados; o custo está em «Se você disser não»
- **irmão**: `2026-09-24-a-web-nao-tem-breakpoint-e-o-dart-tem.md` (ENTRA na `web-v2.5.0`, como `src/breakpoints.js` e `exports`) e `2026-09-24-a-web-de-backoffice-nao-tem-grade.md` (ENTRA COMO DADO, `grade.js`)

## Falta

Os quatro limiares em forma que uma folha de estilo leia. `breakpoints.js` publica `BREAKPOINTS = { sm: 640, md: 768, lg: 1024, xl: 1280 }` e `tierDe(largura)` — serve a JavaScript, e a JavaScript só. Consulta de mídia não lê variável de CSS (`@media (max-width: var(--x))` é inválido por especificação) nem importa módulo. Quem escreve `@media` precisa de **mídia nomeada** (`@custom-media --ate-sm (max-width: 639.98px)`, a sintaxe do Media Queries Level 5, que o PostCSS de todo consumidor já entende) ou de um arquivo gerado que a declare.

## Número

| medida | valor |
|---|---|
| limiares no pacote web | **4**, em `avo/src/breakpoints.js`; em CSS, **0** (`tokens/*.css` e `papeis.css` não têm nenhum) |
| consultas de mídia cravadas no IB | **21**: 900 px em 8 sítios, 640 em 7, 1000 em 3, 1100 em 2, 1279 em 1 |
| as que caem na escala do pai sem decisão | 640 → `sm`, 1279 → `xl`, 1000 e 1100 → `lg` |
| a que não cai | **900**, o limiar do trilho lateral, repetido em três peças (barra, seletor de conta, layout): não é `md` nem `lg`; vai virar um dos dois por decisão da dona |
| o que o IB faria sem este pedido | um script de build lendo `breakpoints.js` e escrevendo `@custom-media` num arquivo gerado, com gate de «pacote mudou e o arquivo não» — o mesmo desenho do sprite de ícones daqui |

## Já tentei

Nada no CSS: não há como. O caminho local (script + arquivo gerado + `postcss-custom-media`) funciona e é o que vamos fazer se este pedido não entrar — e é derivado por cada consumidor com um gerador diferente, que é o defeito que os dois irmãos de 24/09 já descreveram para a largura e a grade.

## Conferi no pai

- A `web-v2.5.0` trouxe os breakpoints **como dado** porque o pedido pediu dado: *«ENTRA · web-v2.5.0»*, com a nota de 25/09 sobre o `exports`. Faltou a segunda forma do mesmo dado.
- A grade entrou *«COMO DADO, e não como `<diletta-grade>`»* (`web-v2.6.0`): `--diletta-colunasDoConteudo: 12` saiu **também como variável CSS**. É o precedente: um número da linguagem sai nas duas formas, JS e CSS, quando as duas o consomem. Os breakpoints saíram só numa.
- `tokens/diletta-tokens.css` já é gerado pelo mesmo emissor que publica `breakpoints.js`; `@custom-media` é uma linha por limiar, nas duas direções (`--ate-sm` / `--de-md`), e o `tierDe` continua sendo a forma de JS.

## Derivável?

Sim, por script no consumidor — e cada consumidor com o seu. O pedido é a emissão.

## Se você disser não

O IB nasce com o gerador local e o gate; o Cockpit, que também escreve CSS, faz o dele.

## Não estou pedindo

Um `@media` dentro das peças nem um eixo responsivo: só a mídia nomeada com os quatro números que já existem. A escolha de QUAL limiar esconde o trilho é da dona do produto, não do pai.

## Como o pai vai saber que funcionou

Um arquivo em `tokens/` (ou dentro de `diletta-tokens.css`) com `@custom-media --ate-sm (max-width: 639.98px)` … `--de-xl (min-width: 1280px)`, os oito, derivados de `BREAKPOINTS` pelo mesmo emissor; um gate que compara os dois lados.

## VEREDITO · ENTRA — os quatro limiares saem também como mídia nomeada
**pai**: ds-diletta **v3.19.0** · **data**: 2026-10-15

### O que decidiu
O seu precedente da grade decidiu: um número da linguagem sai nas duas formas quando as duas o consomem. `diletta-design-system-web/breakpoints.css` declara os oito `@custom-media`, `--ate-sm (max-width: 639.98px)` … `--de-xl (min-width: 1280px)`, e está no `exports`. O arquivo é curto, e o teste `o_breakpoint_e_um_so` é o gerador dele: reprova se qualquer número divergir de `BREAKPOINTS`.

### O que eu recusei, e a condição de reabrir
- **o 900 do trilho lateral**: não é limiar da linguagem. Escolher entre `--ate-md` e `--ate-lg` é da dona do produto, como você escreveu. Reabre se um segundo filho medir o mesmo limiar fora da escala.

### Os sete critérios

| critério | | |
|---|:-:|---|
| manutenção | ↑ | nenhum gerador por consumidor |
| escalabilidade | ↑ | o IB e o Cockpit leem o mesmo arquivo |
| aplicação | ↑ | os 21 `@media` cravados do IB; adota o filho B |
| aderência ao mercado | ↑ | Media Queries Level 5 com `postcss-custom-media`, como o Open Props |
| robustez | ↑ | o teste reprova a divergência entre o CSS e o JS |
| arquitetura limpa e simples | = | um arquivo e uma linha de `exports` |
| conciso | = | um cabeçalho de seis linhas |

### O que você faz
`ref: v3.19.0`. No IB, importe `diletta-design-system-web/breakpoints.css` no PostCSS e troque os 640, 1000, 1100 e 1279 cravados pelas mídias nomeadas. O 900 espera a decisão da dona.
