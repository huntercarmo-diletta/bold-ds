# PEDIDO · O título do estado vazio não é cabeçalho, nos dois lados

- **de**: conta-bold-ds (filho B) · **para**: ds-diletta
- **consome**: ds-diletta `v3.13.0` · `web-v3.13.0`, pela tag `web-v0.123.0` deste repo
- **bloqueante?**: **não** — o IB mantém o `BoldEmptyState` local (que usa `<h3>`) até o veredito
- **irmão**: `2026-10-08-o-titulo-do-dialogo-nao-e-cabecalho-e-a-rota-dele-nao-tem-nome.md` — o mesmo defeito, na peça ao lado, que **entrou** na `v3.10.0`

## Falta

Que o título do `DilettaEmptyState` / `<diletta-empty-state>` seja cabeçalho para quem ouve. Hoje é texto comum nos dois lados: na web, `<p class="titulo">` (`diletta-empty-state.js:79`); no Dart, `Text(title, style: tipoDe('subheading'))` sem `Semantics(header: true)` (`diletta_empty_state.dart:98-102`). A web espelha o Dart, e o Dart tem o buraco.

## Número

| medida | valor |
|---|---|
| estados vazios no IB que trocariam de peça | **53**, em 35 arquivos — todos com o título em `<h3>` hoje |
| o que o leitor de tela perde na troca | 53 cabeçalhos: a lista de cabeçalhos da página (a navegação por H do NVDA/VoiceOver) deixa de ter «Nenhuma solicitação aguardando aprovação», «Sem histórico», «Nada com esses filtros» |
| o precedente | `v3.10.0`, *«o diálogo se anuncia pelo título»*: título com `header`, caixa nomeada por ele. Julgado em 08/10 como **defeito, não variante** |

## Já tentei

Pôr o `<h3>` fora da peça e deixar o `titulo` vazio: a peça desenha o `<p>` vazio mesmo assim, e o espaçamento do cartão conta com ele. Passar o título pelo slot `ilustracao` é usar o lugar errado para o texto. Nenhum dos dois é adoção; é contorno.

## Conferi no pai

- `diletta_dialog.dart` desde a `v3.10.0`: título com `header`, e a spec do diálogo ganhou o requisito. O estado vazio tem a mesma anatomia (título + legenda + ação) e ficou de fora do veredito porque ninguém mediu.
- Na web, o `<diletta-dialog>` já fazia isso antes do Dart (*«A web já fazia»*, CHANGELOG 3.10.0). O estado vazio web nasceu em 14/10 copiando o Dart, e copiou o buraco.

## Derivável?

Não: o título mora dentro da peça nos dois lados.

## Se você disser não

O IB fica com o `BoldEmptyState` local nos 53 sítios, e a peça da linguagem só entra em tela nova onde o título não precise ser cabeçalho — que é nenhuma.

## Não estou pedindo

O nível do cabeçalho como eixo da peça (`h2` × `h3`). Pedindo que seja cabeçalho; se o nível precisar ser declarável, que venha como veio no diálogo. Também não estou pedindo mudar o desenho: `subheading` e cor ficam.

## Como o pai vai saber que funcionou

Na web, `shadowRoot.querySelector('.titulo').tagName` começa com `H`; no Dart, o `Semantics` do título tem `header: true` — o gate `o_dialogo_se_anuncia_pelo_titulo_test.dart` ganha o irmão do estado vazio.

## VEREDITO · ENTRA, defeito meu — o vazio se anuncia pelo título, como o diálogo
**pai**: ds-diletta **v3.16.0** · **data**: 2026-10-15

### O que decidiu
O seu precedente decidiu: é a mesma anatomia do diálogo, e o diálogo entrou na v3.10.0 como defeito. O título vira `Semantics(header: true)` no Dart e `<h3>` na web, com o mesmo `subheading` e a mesma margem. A legenda continua texto, e o nível fica fixo em `h3`. A spec ganhou o requisito, e o gate `o_vazio_se_anuncia_pelo_titulo_test.dart` é o irmão do teste do diálogo.

### O que eu recusei, e a condição de reabrir
- **nível declarável (`h2` × `h3`)**: você não pediu, e não entrou. Reabre quando uma tela medir o vazio como seção de primeiro nível.

### Os sete critérios

| critério | | |
|---|:-:|---|
| manutenção | ↑ | o `BoldEmptyState` local morre |
| escalabilidade | ↑ | todo filho recebe o cabeçalho sem saber |
| aplicação | ↑ | os 53 estados vazios do IB; adota o filho B |
| aderência ao mercado | ↑ | título de bloco é cabeçalho (WCAG 1.3.1) |
| robustez | ↑ | um teste por lado |
| arquitetura limpa e simples | = | um `Semantics` e uma tag |
| conciso | = | um requisito na spec |

### O que você faz
`ref: v3.16.0`. No IB, troque o `BoldEmptyState` pela peça nos 53 sítios e apague o `<h3>` de fora.
