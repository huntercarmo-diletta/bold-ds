# PEDIDO · O texto do campo tem 14 px, e o Safari do iPhone amplia a página a cada campo tocado

- **de**: conta-bold-ds (filho B) · **para**: ds-diletta
- **consome**: ds-diletta `v3.27.0` · `web-v3.27.0`, pela `web-v0.130.0` deste repo, a do Internet Banking `core-flow-ib` na homologação de 12/11 (`562bacbf`)
- **bloqueante?**: em parte. O IB tem a troca dos 76 campos de texto pelo `<diletta-input>` pronta para fazer, e ela não sobe enquanto trouxer o zoom: hoje nenhum campo do IB dá zoom
- **irmão**: `2026-11-12-o-campo-de-data-so-avisa-a-data-completa-e-dentro-do-limite.md`. O campo de data mora num `<diletta-input>` e dá o mesmo zoom

## Falta

O texto digitado no `<diletta-input>` tem menos de 16 px em todo porte, e o Safari do iPhone amplia a página ao focar um campo assim. A pessoa toca no campo, a página cresce, e o campo passa da borda da tela.

## Número

**Os tamanhos, lidos em `diletta-input.js` e nas folhas da `web-v3.27.0`:**

| porte | degrau do texto do campo | tamanho |
|---|---|--:|
| `lg` (o padrão) | `bodyMd` | 14 px |
| `md` | `bodySm` | 12 px |
| `sm` | `labelMd` | 12 px |
| `type="long"` | `button`, com peso 400 | 15 px |

**A medida, em 12/11:** no simulador do iPhone 17 (iOS 26.5), Safari, numa página com `<meta name="viewport" content="width=device-width, initial-scale=1.0">`, o mesmo do IB.

| campo tocado | texto | o que o Safari faz |
|---|--:|---|
| `<diletta-date-field>`, que é um `<diletta-input>` `lg` | 14 px | amplia a página; o campo passa da borda direita e o botão do calendário fica cortado |
| `<input>` comum, na mesma página | 16 px | foca sem ampliar |

A imagem `iphone-teclado-sem-barra-e-zoom.png`, na pasta do pedido irmão, mostra a página ampliada.

**No IB:**
- **Hoje:** os 89 campos são o `BoldTextField` local, com o texto em `bodyLg` (16 px), e nenhum deles dá zoom.
- **Com a troca:** os 76 campos de texto e as 13 datas passariam a dar zoom no iPhone, inclusive o CPF da tela de entrada, que é o primeiro campo que a pessoa toca.

## Já tentei

- **`maximum-scale=1` no `viewport` do IB.** Não testei, e recuso: ele tira a ampliação da página onde o navegador obedece, e a pessoa que precisa ampliar o texto fica sem ela (WCAG 1.4.4). Seria trocar um defeito de toque por um de acessibilidade, na página inteira.
- **Aumentar a letra por fora.** O texto mora no `.campo`, que não tem `part`, e escrever o tamanho por fora seria redesenhar a peça do pai pelo lado de fora.
- **Escolher outro `porte`.** Nenhum dos três chega a 16 px, e o maior é o padrão.
- **Ficar com o `BoldTextField` local.** É o que está no ar, e é o que a adoção existe para apagar.

## Conferi no pai

- **O comentário da peça explica o degrau:** «O degrau do TEXTO DO CAMPO, medido nos dois textStyle do Dart: o campo de uma linha e bodyMd […] O desenho do filho concorda no campo: 14/400/20/0,25 em 21 sitios de Input fields» (sem acento, como no template). O 14 é desenho medido, e não engano. O zoom é da web no iPhone: no aplicativo não existe, e no navegador do computador nada acontece.
- **Na `main` do pai** não houve mudança em `diletta-input.js` depois da `v3.27.0`.
- **Nem o `base.js` nem o `diletta-input.js`** têm regra para tela de toque ou menção a zoom.

## Derivável?

Não. Quem consome não alcança o tamanho do texto do campo, e o porte não chega a 16.

## Se você disser não

- **O IB:** fica com o `BoldTextField` local nos 89 campos, e a tarefa de tirar os campos locais fica aberta.
- **Outro filho com página no celular:** recebe o zoom em todo campo da linguagem sem saber, porque no Chromium do computador nada acontece.

## Não estou pedindo

1. **Uma forma específica.** Pode ser 16 px só em tela de toque (por exemplo, `@media (pointer: coarse)`), 16 px em todo lugar, ou outro caminho que o pai ache. O GOV.UK Design System e o Bootstrap usam 16 px ou mais no texto do campo. A escolha é da linguagem.
2. **Mudar o Dart.** No aplicativo não há zoom, e o desenho de 14 px pode ficar lá.
3. **Mexer no rótulo, na ajuda ou no erro.** O zoom vem do texto do campo focado, e só dele.

## Como o pai vai saber que funcionou

- **No teste do pai:** o tamanho computado do texto do campo em tela de toque é de 16 px ou mais, nos três portes e no `long`.
- **No simulador:** tocar num `<diletta-input>` e num `<diletta-date-field>`, no Safari do iPhone, não amplia a página.

Do lado do IB, a troca dos 76 campos de texto sobe.

## Como cheguei aqui

Medindo o pedido irmão no simulador do iPhone, em 12/11. O zoom apareceu no primeiro toque no campo de data, e o `<input>` comum de 16 px, posto na mesma página para comparar o teclado, não ampliou.
