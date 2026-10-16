# PEDIDO · O campo de data não tem hora — e o console marca instantes em três `datetime-local` crus

- **de**: conta-bold-ds (filho B) · **para**: ds-diletta
- **consome**: ds-diletta `v3.19.0` · `web-v3.19.0` na `main` deste repo; o console `core-flow-wa` prende `web-v0.118.0` (avô `web-v2.5.0`). Console medido em `release/homologation` `afb1fec4` (15/10)
- **bloqueante?**: não
- **irmão**: `2026-10-15-os-atributos-nativos-do-input-nao-atravessam-para-o-campo.md`, cujo veredito mandou a data para o `<diletta-date-field>`

## Falta

Um campo que recebe dia **e** hora, com rótulo, ajuda, erro, `min` e `max` da linguagem.

## Número

| sítio | o que marca |
|---|---|
| `src/features/pix/ui/TelaAbrirMed.tsx:433` | «Relato recebido em», com `max` igual a agora |
| `src/features/incidentes/ui/TelaIncidentes.tsx:390` | «Início» de um incidente |
| `src/features/incidentes/ui/TelaIncidentes.tsx:402` | «Fim estimado» |
| total | **3 campos em 2 telas**, todos `<input type="datetime-local">` com a moldura, a ajuda e o erro montados à mão (`CampoNativo`) |
| `DilettaManifesto.busca` sobre as specs da `v3.19.0` | `busca('hora')` → `[]` · `busca('data')` → `[data-cell, data-column-header, data-header-row, data-list, data-row, calendar, date-field, day-group]` |

Os outros 5 campos de data do console (`type="date"`, em `TelaExtratoDoCliente.tsx:308`, `EspelhoDoApp.tsx:358-359` e `SeletorDePeriodo.tsx:90` e `:103`) **não** entram aqui: o `<diletta-date-field>` cobre os cinco, e trocar é trabalho nosso.

## Conferi no pai

- `diletta-date-field.js` (`web-v3.19.0`): `observedAttributes = ['valor', 'label', 'placeholder', 'erro', 'ajuda', 'min', 'max', 'estado']`. É o dia, sem hora. O `calendar` também não tem hora.
- O veredito de 15/10 recusou `type="date"` no `<diletta-input>` porque *«a data é o `<diletta-date-field>`»*. O mesmo raciocínio vale para `datetime-local`: **não peço que o `<diletta-input>` aceite**. Peço que a peça de data saiba a hora.

## Já tentei

- **O nativo**: é o que existe. O navegador desenha o controle dele, fora da moldura, da ajuda e do erro da linguagem.
- **Dois campos** (data no `date-field`, hora num `<diletta-input>` com máscara): não montei. Por leitura, o `max` igual a agora passa a ser regra de duas peças que precisam concordar.

## Derivável?

Não. A peça de data não tem por onde receber a hora.

## Se você disser não

Os três `datetime-local` ficam nativos, com a moldura à mão, e o `CampoNativo` continua existindo só por eles.

## Não estou pedindo

1. **fuso**: o console fixa Brasília (`TelaIncidentes.tsx:69`), e isso é da tela;
2. **segundos**: nenhum dos três sítios usa;
3. **intervalo de instantes**: o par Início/Fim são dois campos, e a regra entre eles é da tela.

## Como o pai vai saber que funcionou

O campo de data com hora: o `valor` em `AAAA-MM-DDTHH:MM`, e `min` e `max` no mesmo formato. Do lado de cá, os três nativos saem.

## Como cheguei aqui

Lote do webadmin de 07–16/10, item 7. A metade do texto longo deste item **não** virou pedido: o `<diletta-input type="long">` já existe, e o cursor foi consertado na `web-v3.3.1` (pedido de 29/09). Falta o console subir o pino.
