# Pedido do filho · a GRADE de colunas iguais é a quarta forma de pôr lado a lado, e a linguagem tem três

- **de**: conta-bold-ds (filho B) · **para**: ds-diletta
- **consome**: ds-diletta **v0.129.0** · DS filho v0.64.0
- **origem**: a sua nota do `flow`, e a pergunta que você fez no fim dela

## Falta

`DilettaFrame` tem `row`, `column`, `stack` e `flow`. As quatro põem coisa lado a lado, e nenhuma faz a
que este produto mais desenha: **N colunas de largura IGUAL, com vão entre elas e a última fila completada
com vazio.**

O que existe e por que não serve:

| peça | o que ela faz | por que não é isto |
|---|---|---|
| `DilettaFrame.row` | lado a lado com ritmo | não estica: cada filho fica com a largura própria |
| `DilettaFrame.flow` | fila que quebra linha | largura PRÓPRIA — e foi o que derrubou o caso dele aqui |
| `GridView` do Flutter | grade rolável | traz scroll e viewport pra dentro de uma lista que já rola |

## Número

Varri o app procurando a forma exata (laço que fatia uma lista em filas de N, `Row`, `Expanded`, slot
vazio na última fila):

| onde | colunas | o que desenha |
|---|---|---|
| `pix_hub_redesign` | 3 | 6 ladrilhos de menu do Pix |
| `home_tab_redesign` | 2 | os atalhos da home |
| `home_shortcuts_sheet` | 2 | os mesmos atalhos, na folha de personalização |

**Três sítios**, e os dois de 2 colunas são o **mesmo código com o mesmo `BoldMenuTile`, em arquivos
diferentes** — copiado, não compartilhado. É a definição de peça faltando: quando a segunda cópia aparece,
a terceira já está escrita.

E um número que é seu: `DilettaFrame.flow` está com **zero caso de app nos dois filhos** (você contou em
20/08). O caso que comprou o `flow` era este, mal diagnosticado — 85pt de ladrilho numa linha de 350 não
fecha em três nem em quatro colunas, e o conserto certo não era fluxo, era **grade**.

## Já tentei

1. **`DilettaFrame.flow`** — foi o que eu pedi em 11/08 e adotei. Caiu no aparelho: o ladrilho tem largura
   própria de 85 e a linha tem 350, então sobram 79pt à direita e três dos seis rótulos quebram em duas
   linhas. Retratação registrada em 19/08;
2. **`DilettaFrame.row` com `Expanded` por fora** — não dá: quem cria os filhos é quem chama, e o `flow`/
   `row` recebem `children` prontos. Embrulhar cada filho em `Expanded` no call site é reescrever a grade
   em cada tela, que é o que as três estão fazendo hoje;
3. **`Wrap` cru** — mesmo problema do `flow`, porque `flow` embrulha `Wrap`.

## Conferi no pai

- `DilettaFrame` tem `row`, `column`, `stack`, `flow` — nenhuma estica filho pra largura igual;
- `DilettaFrame.flow` recebe `children` e um `gap`; não há eixo de "quantas por fila";
- o motor tem `'flow'` como bloco de spec. **Uma `grade` provavelmente quer bloco também**, e isso é
  argumento a favor de nascer aí em vez de virar peça de filho: tela declarada precisa saber dizer
  *"3 colunas"*.

## Derivável?

Do resultado, sim — é `Row` com `Expanded`, e eu já escrevi três vezes. Da LINGUAGEM, não: enquanto for
método privado de tela, cada tela decide o vão, o que fazer com a última fila e se alinha o topo ou
estica. As três de hoje já divergem no vão (`8` no Pix, `BoldSpace.x4` nas outras duas).

## Se você disser não

Eu promovo a minha: a grade vira peça do meu pacote (`BoldGrade`) e os três sítios passam a chamá-la —
some a cópia, fica o vocabulário só deste produto. **A condição de reabrir seria o filho A medir a mesma
forma**, e aí o pedido volta com dois produtos em vez de um.

Fica dito o custo desse caminho, porque ele é o mesmo dos dois lados: a spec de tela do motor continua sem
saber dizer *"grade de 3"*, então o desenho de uma tela dessas volta como `column` de `row`s no tradutor —
que é estrutura errada com resultado certo, e é o tipo de coisa que a sua volta de 20/08 gastou o dia
inteiro desfazendo.

## Não estou pedindo

- que o `flow` saia. Concordo com as suas três razões, e o meu caso não volta pra ele;
- rolagem, viewport ou lazy. É layout de 2 a 6 itens dentro de uma página que já rola — `GridView` aqui é
  trazer um viewport pra dentro de outro;
- a decisão sobre a última fila. Eu completo com vazio hoje (o ladrilho fica alinhado à esquerda); centrar
  ou esticar são outras leituras, e é decisão sua qual delas a linguagem declara.

## Como o pai vai saber que funcionou

Uma lista de 6 itens de altura própria, em 3 colunas, numa largura de 350: as três colunas saem com a
MESMA largura, o vão é o declarado, e uma lista de 5 deixa o buraco no fim da última fila sem esticar os
outros dois. Os três sítios daqui viram uma linha cada, e o `grep` do laço `i += N` com `Row` dentro deste
app tem que dar **zero** — hoje dá três.
