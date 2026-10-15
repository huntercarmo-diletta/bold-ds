# PEDIDO · O segmentado não tem segmento desligado — e as abas têm `desligadas`

- **de**: conta-bold-ds (filho B) · **para**: ds-diletta
- **consome**: ds-diletta `v3.13.0` · `web-v3.13.0`, pela tag `web-v0.123.0` deste repo
- **bloqueante?**: **sim, para a troca** — é o único buraco que sobrou entre o `BoldSegmented` local do IB e o `<diletta-segmented-control>`; sem ele, a troca deixa um dos sete sítios sem o estado que ele usa hoje
- **irmão**: `2026-09-17-o-render-da-linguagem-derruba-o-foco.md` (onde o teclado do segmentado foi pedido, e entrou)

## Falta

Um segmento que fica na fileira, anunciado como indisponível, e que as setas pulam: o `desligadas` que o `<diletta-tabs>` já tem (`observedAttributes = ['abas', 'selecionada', 'desligadas', 'rotulo', 'destinos']`, com `aceitavelDe(i, passo)` andando por cima das desligadas e `aria-disabled="true"` na aba), aplicado ao segmentado. O próprio `///` do segmentado diz *«Aqui não há segmento desligado, então a borda é direta»*.

## Número

| medida | valor |
|---|---|
| sítios do IB com `BoldSegmented` | **7** (11 ocorrências), medidos em 14/10 |
| sítios que usam o segmento desligado | **1**: "Como transferir" do envio por agência e conta (`EnviarScreen.tsx:309`): `Pix | TED`, com TED **desligada** quando o banco escolhido não aceita TED, e a frase do app ao lado: *«Este banco aceita somente Pix.»* |
| o que o elemento faz hoje com esse caso | nada: `segmentos` é uma lista de rótulos, `ativo` é um índice; todo segmento clica e toda seta chega |
| o que o `<diletta-tabs>` faz com o mesmo caso | `desligadas="1"` → `<span class="aba" aria-disabled="true">` sem clique, e a seta pula (`aceitavelDe`) |
| teclado do segmentado, medido em 14/10 | ←, →, Home e End andam; o foco segue; `mudou` com o índice; host 44 — é o que faltava em setembro, e entrou |

## Já tentei

- **Esconder a TED** quando o banco não aceita. É o que a troca faria sem este pedido — e esconder é a trava que a regra «informar, não travar» deste produto veta (decisão de 30/09): a pessoa precisa ver que TED existe e por que não serve aqui, que é o que a frase ao lado diz.
- **Deixar o segmento clicável e recusar no `mudou`**: o elemento marca `ativo` sozinho antes de avisar (`escolhe(i)` faz `setAttribute('ativo')` e então dispara), então a pílula anda para a TED e volta — o pior dos dois.
- **Manter a peça local só para esse sítio**: duas peças para o mesmo desenho, que é o que a adoção existe para apagar.

## Conferi no pai

- `diletta-tabs.js`: `get desligadas()` lê uma lista de índices separada por vírgula; `estadoDe(i)` devolve `desligada`; `aceitavelDe` anda por cima. Entrou pelo pedido das abas (*«as abas não têm nome, e o painel perde o dele»*, ENTRA em 22/09). O segmentado nasceu da mesma gramática (`tabindex` rotativo, mesmas teclas) e ficou sem o eixo.
- No Dart, `DilettaSegmentedControl` — a conferir se tem o estado por item; se não tiver, é pedido nos dois lados, como o do checkbox.

## Derivável?

Não: o segmento mora no shadow, e `aria-disabled` de fora não impede o clique de dentro.

## Se você disser não

O IB troca seis dos sete sítios e mantém o `BoldSegmented` local no envio por agência e conta — a peça local não morre, e a troca fica pela metade.

## Não estou pedindo

Motivo por segmento, nem tooltip: a frase do porquê fica na tela, ao lado, como está hoje. Pedindo o mesmo `desligadas` das abas, com o mesmo nome, no segmentado.

## Como o pai vai saber que funcionou

`<diletta-segmented-control segmentos="Pix|TED" ativo="0" desligados="1">`: o segundo segmento sai com `aria-disabled="true"`, o clique nele não muda `ativo` nem dispara `mudou`, e → a partir do primeiro não anda (ou anda para o próximo ligado, quando houver). O gate das abas (`aceitavelDe`) ganha o irmão.

## VEREDITO · ENTRA — o segmento desligado fica na fileira, e o teclado pula ele
**pai**: ds-diletta **v3.16.0** · **data**: 2026-10-15

### O que decidiu
Entrou o que você pediu, com o nome que você pediu: `desligados`, no formato das `desligadas` das abas. O segmento fica visível com `aria-disabled="true"` e `textDisabled`, o clique nele não muda `ativo` nem avisa `mudou`, e setas, Home e End pulam ele. Com `Pix|TED` e `desligados="1"`, a seta → a partir de Pix não anda e não avisa. A peça é só web: o Dart não tem segmentado, então não há par a cobrar.

### O que eu recusei, e a condição de reabrir
nada recusado.

### Os sete critérios

| critério | | |
|---|:-:|---|
| manutenção | ↑ | o `BoldSegmented` local morre nos 7 sítios |
| escalabilidade | ↑ | toda fileira de escolha com opção indisponível |
| aplicação | ↑ | o envio por agência do IB; adota o filho B |
| aderência ao mercado | ↑ | `aria-disabled` em `radiogroup`, como no `ToggleButtonGroup` do MUI |
| robustez | ↑ | a seta nunca para num beco, e o teste cobra |
| arquitetura limpa e simples | = | a mesma lei das abas, sem peça nova |
| conciso | = | um requisito na spec |

### O que você faz
`ref: v3.16.0`. No envio por agência, ponha `desligados="1"` quando o banco não aceitar TED. A frase do porquê continua ao lado.
