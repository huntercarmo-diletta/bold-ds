# PEDIDO · O botão desabilitado fica com a borda da marca em força total

- **de**: conta-bold-ds (filho B) · **para**: ds-diletta (o pai)
- **consome**: ds-diletta `v0.207.0` · `web-v0.207.0`, pela tag `web-v0.114.0` deste repo
- **bloqueante?**: **não** — nada quebra, e nós não remendamos. É informação
  contraditória sobre o estado, e o consumidor não tem como consertar sem
  reintroduzir a cópia de cor que a adoção acabou de apagar.

> **Nota de procedência.** Achado no **core-flow-wa** (o webadmin), no dia em que o
> `WaBotao` deixou de desenhar e passou a delegar ao `<diletta-button>`. A designer
> olhou a barra de filtro no tema escuro e perguntou se o contorno rosa num botão
> desabilitado vinha da linguagem ou era coisa nossa. Vinha da linguagem.

## O caso

Um botão de contorno desabilitado **mantém o contorno na cor da marca, em força
total**, enquanto o rótulo dele empalidece. A borda diz "clicável" e o texto diz
"desligado", na mesma peça.

Medido no `<button>` renderizado, tema escuro, no "Limpar filtros" do console:

```
border-color   #f66fa0   ← primary, a rosa da marca
color          #3f424f   ← textDisabled
background     #14151f   ← surface
```

## A causa é de OMISSÃO, e está na tabela de pintura

A receita do estado desabilitado declara `background` e `color` e **não redefine
`border-color`**. Como a regra base já pintou a borda, ela sobrevive na cascata —
o `.botao:disabled` do shadow não tem o que opor a ela.

```
secondaryPrimary  normal  normal    background: transparent; color: primary; border-color: primary;
secondaryPrimary  normal  disabled  background: surface;     color: textDisabled;
                                                             ^ sem border-color
```

Varridas as 8 aparências × 2 estados, procurando "tem borda na base e não a
redefine no desabilitado". **São seis, e são exatamente os três tipos de
contorno da peça:**

```
secondary        normal · error      borda textTertiary
secondaryPrimary normal · error      borda primary / onErrorSubtle
secondaryWhite   normal · error      borda white
```

Os preenchidos (`primary`) e os sem moldura (`tertiary*`) não são afetados: eles
não declaram borda na base, então não há o que sobreviver.

## Por que isso não é detalhe de tom

Num botão de contorno o preenchimento é transparente — **a borda é a forma**. Ela
é o sinal mais forte que a peça emite, e mantê-la acesa num controle que não
responde ao clique é dizer duas coisas opostas ao mesmo tempo.

O rótulo desabilitado dá 1,82:1 no escuro e 2,32:1 no claro contra o fundo.
Estado desabilitado é **isento** do piso de 4,5:1 da WCAG 2.2 §1.4.3, então isto
**não é falha de conformidade** — e é por ser isento que a borda pesa mais: ela é
o que sobra para comunicar o estado, e está comunicando o contrário.

## O que eu NÃO confirmei

**Se o Dart tem o mesmo buraco.** Medi a instância web; a tabela de pintura é
gerada do render do Dart, então ou a omissão veio de lá, ou entrou na emissão.
Quem tem os dois lados na mão resolve em um minuto — e a resposta muda o
conserto de lugar. Não fui atrás porque a régua desta casa é medir o que se tem,
e eu só tenho a metade web.

## O que o consumidor está fazendo enquanto isso

**Nada.** O webadmin não escreve uma linha de cor neste botão desde que adotou a
peça — o `WaBotao` traduz papel para eixo e delega. Remendar por `::part(botao)`
seria reintroduzir a cópia de cor que a adoção acabou de apagar, e a cópia que
ninguém promete atualizar é o defeito que este repo já pagou duas vezes nesta
mesma semana (o `borda-forte` e as alturas).

Preferimos declarar e esperar.
