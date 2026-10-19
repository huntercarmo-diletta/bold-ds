# PEDIDO · A etiqueta no tom de marca escreve o texto em `primary`, e no escuro ele some no contêiner

- **de**: conta-bold-ds (filho B) · **para**: ds-diletta
- **consome**: ds-diletta `v3.24.0` · `web-v3.24.0`, pela tag `web-v0.126.0` deste repo
- **bloqueante?**: não para troca nenhuma — a etiqueta já é a da linguagem no IB. É defeito de leitura em 6 etiquetas do IB, todas no escuro
- **irmão**: `2026-10-13-a-lavagem-da-marca-nao-atravessa-para-a-web.md` (ENTRA DIFERENTE na `v3.11.0`, que fez do `primarySubtle` o contêiner sólido e deu a ele o `onPrimarySubtle`)

## Falta

Que o `design-system-status-tag` no tom `primary` pinte o texto com `onPrimarySubtle`, a tinta do contêiner
onde ele está, como os outros tons coloridos já fazem. Hoje a pintura do tom é `bg: primarySubtle`,
`border: primary`, `color: primary`.

## Número

**Os sete tons da etiqueta**, texto contra o fundo dela, medidos em 19/10 no Chrome 155 com a `web-v0.126.0`
(avô `3.24.0`), sobre `surface`. A etiqueta escreve em `caption`, 12 px, e o piso é 4,5:1.

| tom | Bold claro | Bold escuro | Norte Benk claro | Norte Benk escuro |
|---|--:|--:|--:|--:|
| **primary** | 7,13 | **2,94** | 6,23 | **2,40** |
| success | 5,19 | 5,11 | 5,52 | 5,22 |
| warning | 6,09 | 4,77 | 8,33 | 5,68 |
| danger | 6,05 | 4,82 | 7,73 | 5,10 |
| neutral | 5,53 | 9,47 | 15,31 | 7,93 |
| secure | 8,48 | 7,90 | 10,22 | 9,35 |
| pending | 5,53 | 9,47 | 15,31 | 7,93 |

Só o `primary` reprova, e só no escuro. No claro ele passa porque `primary` e `onPrimarySubtle` coincidem
nas duas marcas: o Bold declara o `primary` claro como `#9e1241`, e a Norte Benk usa `#2a57a5` nos dois papéis.

**A pintura de cada tom**, lida em `pintura.g.js`:

| tom | `bg` | `color` |
|---|---|---|
| success | `successSubtle` | `onSuccessSubtle` |
| warning | `warningSubtle` | `onWarningSubtle` |
| error / danger | `errorSubtle` | `onErrorSubtle` |
| secure | `secureSubtle` | `onSecureSubtle` |
| **primary** | `primarySubtle` | **`primary`** |

**A troca proposta**, `color: onPrimarySubtle`, medida pelos valores das folhas:

| | `primary` sobre `primarySubtle` | `onPrimarySubtle` sobre `primarySubtle` |
|---|--:|--:|
| Bold claro | 7,13 | 7,13 (mesmo valor, zero pixel) |
| Bold escuro | 2,94 | **4,89** |
| Norte Benk claro | 6,23 | 6,23 (mesmo valor, zero pixel) |
| Norte Benk escuro | 2,40 | **4,58** |

**No IB:** 6 etiquetas usam o tom: «Principal» na linha da chave Pix e na janela «Receber em qual chave?»
(Cobrar com Pix e Cobrar com boleto), duas em Segurança, uma em Chaves Pix e uma na escolha do boleto. A dona do
produto viu a leitura ruim no escuro antes de qualquer medida.

## Já tentei

- **Pintar o texto por fora** com `::part`: funciona, e é exatamente o desvio que a dona do produto mandou
  desfazer em 19/10 nos campos de Trazer dinheiro. Cor de peça é da pintura da linguagem.

## Conferi no pai

- O veredito de 13/10 (`v3.11.0`): *«`primarySubtle` perde "seleção" e fica o contêiner sólido»*, com o
  `onPrimarySubtle` como a tinta dele. A etiqueta é um contêiner `primarySubtle` com texto dentro.
- Os outros quatro tons coloridos já pintam o texto com o `on…Subtle` do seu contêiner. O `primary` é o
  único que usa a cor da família.

## Derivável?

Não: o texto mora no shadow, e a pintura é a da tabela.

## Se você disser não

O IB vive com 6 etiquetas abaixo do piso no escuro, ou troca o tom delas por outro que passe.

## Não estou pedindo

Mudar o fundo ou a borda do tom. Mudar os outros tons. Não medi o Dart: se a pintura dele sai da mesma
tabela, o app tem o mesmo defeito no escuro.

## Como o pai vai saber que funcionou

`<diletta-status-tag tone="primary">` no escuro, sobre `surface`, nas marcas do catálogo: o texto passa 4,5:1
contra o fundo da etiqueta. No claro, nenhum pixel muda nas duas marcas medidas aqui. O gate que mede as
pinturas ganha o par.
