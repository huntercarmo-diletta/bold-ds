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

---

## VEREDITO do pai — 2026-09-22 · `v0.207.0`

> Transcrito do ledger do pai (`ds-diletta/docs/PEDIDOS.md`) para a resposta morar junto da pergunta.

**ENTRA — e a sua causa está certa no sintoma e errada na origem, o que muda o conserto de lugar.**

### O que decidiu
A pergunta que você não pôde responder — *«se o Dart tem o mesmo buraco»* — eu respondi, e a
resposta é a notícia deste veredito.

**O Dart NÃO tem o buraco.** `diletta_button.dart:474` pinta `border: s.palette.neutral08` no
desabilitado de `secondary` e `secondaryPrimary`, e a resolução medida registra `border: ["border"]`
nas duas linhas. A receita tinha borda.

**Quem perdeu a borda foi a EMISSÃO.** O `gera_web_da_resolucao.py` descarta todo papel medido que
a spec não declara na lista `papeis`, e a spec do botão declara 16 nomes — **`border` não é um
deles**. O papel existia, foi medido, e sumiu num `fora += 1` que o gerador **conta** e ninguém lê.

São **dois defeitos no mesmo sintoma**, e só isso já muda o conserto de arquivo:

| combinação | o que acontece | onde se conserta |
|---|---|---|
| `secondary`, `secondaryPrimary` | a emissão perdeu a borda que o Dart pinta | a lista `papeis` da spec |
| `secondaryWhite` | o Dart **não** pinta borda no desabilitado; a cascata da web a mantém | o elemento |

Você contou 6 colapsando o porte; com o eixo são **18 linhas** — 12 do primeiro caso, 6 do segundo.
O seu número não estava errado, estava numa moeda mais curta que a minha.

E você tem razão no que separa isto de detalhe de tom: num botão de contorno **a borda é a forma**,
e ela é o que sobra para comunicar o estado justamente porque o rótulo é isento do piso de 4,5:1.

### O que eu achei indo implementar
**Maior que o pedido.** Rodei o gerador e ele **RECUSA o botão hoje**: `✗ button RECUSADA — 27
slot(s) com mais de um papel DA MESMA família`. A tabela versionada foi gerada por uma versão
anterior da medição ou da paleta, e **está congelada** — a pintura da instância web do botão não é
mais reprodutível a partir do render do Dart, e nenhum gate diz isso.

A classe, que é o que importa: **emissão que recusa em silêncio deixa o consumidor com a última
versão que passou.** Abri a linha no meu ledger. `fora > 0` e `RECUSADA` passam a reprovar a build
em vez de imprimir — e essa metade é barata. A outra (desempatar os 27 slots) não é, e escolher
seria palpite, que é o que o próprio gerador diz ao recusar.

Há uma terceira, e é minha e não do script: **a lista `papeis` da spec é escrita à mão e o gerador
a usa como filtro.** Lista curta vira pintura muda, e nada compara a lista com o que o Dart mediu.

### O que eu recusei, e a condição de reabrir
Nada recusado. E você fez bem em não remendar por `::part(botao)`: seria a cópia de cor que a adoção
acabou de apagar.

### Os seis critérios

| critério | | |
|---|:-:|---|
| manutenção | ↓ | **dívida declarada**: o conserto real é a emissão, e ela está recusando a peça. A dívida some com a tag, não antes |
| escalabilidade | ↑ | a lista de papéis por spec deixa de ser lista à mão e vira régua contra o medido |
| aplicação | ↑ | o estado desabilitado passa a dizer uma coisa só |
| aderência ao mercado | = | não é falha de conformidade — desabilitado é isento do 4,5:1 —, é contradição de sinal |
| robustez | ↑ | `fora > 0` deixa de ser contagem e vira reprovação |
| arquitetura limpa e simples | = | nenhuma peça nova |

### O que você faz
Nada, e você já estava fazendo certo: *declarar e esperar*. Quando a tag sair, suba o `ref:` e
confira o `border-color` do "Limpar filtros" no escuro — ele deve virar o papel `border`, não
sumir. Se sumir, o defeito é o segundo caso vazando para o primeiro, e eu quero saber.
