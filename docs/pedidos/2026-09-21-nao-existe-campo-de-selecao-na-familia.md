# PEDIDO · Não existe campo de SELEÇÃO na família — nem no Dart, nem na web

- **de**: conta-bold-ds (filho B) · **para**: ds-diletta (o pai)
- **consome**: ds-diletta `v0.202.0` · `web-v0.202.0`, pela tag `web-v0.112.0` deste repo
- **bloqueante?**: **não** — o consumidor tem a peça dele e ela funciona. Mas é vocabulário
  básico faltando, e enquanto faltar cada filho desenha o seu.

> **Nota de procedência.** Achado no **core-flow-wa** (o webadmin), terminando a adoção do
> DS. Ele foi listar o que ainda é peça local e por quê, e este é o único caso em que a
> resposta não é «trava por defeito» nem «o app não tem» — é que a peça não existe.

## O caso, em uma linha

Escolher UM valor entre muitos não tem componente na família.

## O que procuramos, e onde

Nos **25 elementos web**: nenhum `select`, `dropdown`, `combobox` ou `listbox`. O
`<diletta-input>` declara `type` com três valores — `text`, `password`, `long` — e nenhum
deles é seleção.

Nas **61 peças Dart** do `coreflow`: idem. O que existe é vizinho e resolve outra coisa:

| peça | o que ela resolve | por que não serve |
|---|---|---|
| `coreflow_campo_de_texto` | digitar texto livre | não há lista de opções |
| `coreflow_segmentos` | escolher entre POUCAS, todas visíveis | não escala: o console tem selects de 8+ opções |
| `coreflow_chip_de_filtro` | ligar/desligar filtros | é múltipla escolha, e some do fluxo de formulário |
| `coreflow_ladrilho_de_menu` | navegação | não devolve valor |

## Onde isso dói, medido

No webadmin: **4 usos** de campo de seleção em 3 telas — perfil do gestor, natureza e
confiança na fila de KYC. São formulários, não filtros: o valor escolhido é submetido.

Não é volume; é **vocabulário**. Um produto da família que precise de "escolha um entre
muitos" hoje tem três saídas, todas ruins: desenha a sua (o que fizemos), força
`segmentos` numa lista que não cabe, ou usa `<select>` cru e perde a tinta.

## O que a nossa peça faz, para o pedido não pedir menos do que já existe

`WaCampoSelect` é um `<select>` nativo com rótulo, e a razão de ser nativo está no `///`
dela: o `<select>` do sistema traz busca por digitação, rolagem com teclado e o painel do
sistema operacional no celular — coisas que um dropdown desenhado à mão perde e quase nunca
recupera.

Então o pedido **não é** «um dropdown desenhado». É a peça da linguagem em volta do
controle nativo: rótulo, estados (repouso, erro, desabilitado), mensagem de ajuda e de
erro — exatamente o que o `<diletta-input>` já faz para texto.

## O pedido

Um `type` de seleção no `<diletta-input>`, ou um `<diletta-select>` irmão dele, com o
mesmo eixo de estado e as mesmas folgas de acessório. O conteúdo (as `<option>`) vem por
slot, do consumidor, como o `<select>` nativo espera.

Se a casa preferir que a peça nasça no filho, também serve — mas aí vale declarar, porque
hoje a ausência não está escrita em lugar nenhum, e cada filho a descobre sozinho.

## Uma observação sobre a ordem

Este é o terceiro caso desta família que encontramos ao adotar: o `Dialog`/`folha` sem
instância web (pedido irmão, de hoje), o `DilettaStepper` que o IB reportou em 17/09, e
agora a seleção. Os três têm a mesma forma — **não é recurso que ficou para trás dentro de
uma peça, é peça que não existe** —, e os três só aparecem quando alguém tenta trocar tudo
e lista o que sobrou.

Se for útil, o inventário que o webadmin fez (25 elementos × as peças locais de cada
filho) é barato de repetir e acha os próximos.
