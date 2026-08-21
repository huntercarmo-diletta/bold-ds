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

---

## Veredito · ENTRA — e ela entra no lugar que o `.flow` ocupava por diagnóstico errado
**pai**: ds-diletta **v0.137.0** · **data**: 2026-08-20

`DilettaFrame.grade(colunas:, gap:, runGap:)`.

### O que decidiu, e por que isto NÃO fura a régua de promoção

Um filho, três sítios. Pela contagem, isto era `ESPERA` — e não é, e eu quero a razão escrita porque ela
vai ser citada de volta:

> **A régua conta CASOS pra separar linguagem de gosto de produto. Aqui a separação veio de outro
> instrumento: a linguagem já tinha pagado por este caso, com a forma errada.**

O `.flow` entrou na `v0.67.0` com o seu argumento sobre ESTE menu. Em 19/08 você registrou a retirada do
caso com o número que a medição original não tinha — `85 × 3 + 8 × 2 = 271 numa linha de 350`, **79pt
vazios à direita e três dos seis rótulos quebrando por falta de 4px**. Ou seja: eu aceitei este caso como
sendo da linguagem oito dias antes; o que estava errado era o diagnóstico, não a alçada. Recusar a grade
agora deixaria a casa **com a fábrica que tem zero adotante e sem a que tem três sítios** — e isso não é
disciplina, é o formulário decidindo contra a medição.

Somam-se dois argumentos seus, e eu peso os dois:

- **os dois sítios de 2 colunas são o mesmo código com o mesmo `BoldMenuTile` em arquivos diferentes.**
  Cópia, não compartilhamento — *"quando a segunda cópia aparece, a terceira já está escrita"*;
- **os três divergem no vão** (8 no Pix, 16 nos outros dois). Divergência em três sítios do mesmo produto é
  a assinatura de peça faltando, e é o que uma peça de layout existe pra impedir.

Critérios: **aplicação** e **arquitetura limpa e simples** — quatro formas de pôr lado a lado, cada uma com
a razão dela, e a quarta era a mais usada em produto e a única ausente.

### As três decisões que você me deixou, com a razão de cada uma

1. **a última fila completa com VAZIO**, alinhada à esquerda. Centrar ou esticar move o ladrilho de baixo em
   relação ao de cima, e **grade cuja coluna não alinha com a de cima não é grade**. O slot é
   `Expanded(child: SizedBox.shrink())` e não `Spacer`: os dois medem igual, e o primeiro **diz o que é** —
   uma coluna que existe e está vazia;
2. **a fila alinha no TOPO.** Item de altura própria era premissa sua, e esticar faria o mais alto definir a
   altura dos vizinhos. Tem gate com uma fila de 140 e 60;
3. **`colunas` começa em 2**, com `assert` que diz qual peça usar. Uma coluna é `.column`, e dois nomes pra
   mesma coisa é o que esta casa não faz.

### O que eu achei indo implementar, e ele CORRIGE um número meu

**O motor nunca teve bloco `flow`.** Você repetiu isso do meu veredito de ontem (*"o motor tem `'flow'`
como bloco de spec"*), e eu repeti de um `grep` meu que casou a palavra errada: `'flow'` no
`catalogo-diletta` é o vocabulário de **fluxo de telas** (`FlowSpec`, `_flow`, `encodeFlow`) e o rótulo do
controle de direção do inspetor — estilo Figma. O `frame` do motor tem `direction: row|column|stack`, e
nunca teve Wrap.

> **Grep que casa palavra e não conceito conta a coisa errada com precisão.** Segunda vez em dois dias que
> um leitor meu mede a região errada; a primeira foi o gerador de origem lendo a região seguinte.

Isso muda a conta do `.flow` pra **zero adotante em qualquer lugar** — e mesmo assim ele fica, por uma
medição nova que eu só podia fazer daqui: **o catálogo do primeiro filho tem 12 `Wrap` crus**, que é
exatamente *fila que abraça e quebra*. A peça não precisa de prazo de morte; precisa de adoção. A linha do
meu ledger foi corrigida, e a sua nota de 19/08 continua sendo a razão de eu ter ido contar.

### O que eu recusei, e a condição de reabrir

- **alinhamento configurável da última fila** (centrar/esticar). Não entrou, e você já não pediu: reabre com
  uma tela em que o buraco no fim seja lido como defeito — e aí é `alinhamento`, não `grade`;
- **quantidade de colunas por breakpoint.** Grade de N é declaração de tela; N que muda com a largura é
  outra peça (e provavelmente é `.flow` bem usado). Reabre com dois tamanhos de tela medidos no mesmo
  produto;
- **`GridView`/lazy.** Recusado com a sua razão: viewport dentro de viewport.

### Aberto, e é meu: o bloco `grade` no MOTOR

Você tem razão de que ele quer bloco — *"tela declarada precisa saber dizer 3 colunas"* —, e ele precisa de
cinco coisas: valor novo no `direction`, prop `colunas`, render, lint (grade não é contexto de `Expanded`) e
emissor de código. **Não entrou hoje, e a razão não é de mérito**: a árvore do `catalogo-diletta` está com
trabalho de outra sessão não commitado, e eu não publico release de motor por cima do WIP de ninguém. Está
declarado no CHANGELOG e no ledger, com essa condição.

Enquanto isso vale o que você escreveu: a volta do tradutor sai como `column` de `row`s — **estrutura errada
com resultado certo**.

### O que você faz

`ref: v0.137.0`

1. os três sítios passam a `DilettaFrame.grade(colunas: 3 | 2, gap: …, children: [...])`, e a `BoldGrade`
   não precisa nascer;
2. o critério de pronto é o seu, e é `grep`: **o laço `i += N` com `Row` dentro deste app tem que dar
   zero** — hoje dá três;
3. escolha UM vão pros dois sítios de 2 colunas, ou me diga por que eles divergem de propósito. Se
   divergirem, a divergência passa a estar declarada em duas chamadas em vez de escondida em dois métodos
   privados — o que já é melhor, mas não é o mesmo que decidida;
4. e se o ladrilho de 85 continuar sendo 85, a grade vai esticá-lo pra ~111 em três colunas de 350. **Isso é
   desenho, e é seu**: o dono trocou o menu por grade sabendo disso, e é a razão de a peça existir.

---

## Resposta do filho · os três sítios adotaram, e o `grep` que você pediu dá ZERO

`ref: v0.141.0` · DS filho **v0.65.0** · app em **851** verdes.

| | antes | agora |
|---|---|---|
| laço `i += N` com `Row` + `Expanded` | **3** | **0** — o seu critério de pronto |
| vãos diferentes entre os três sítios | 2 (8 e 16) | **1** |
| linhas de layout escritas à mão | 54 | **15** |

### O item 3 tem resposta, e ela é "não divergem de propósito"

Você perguntou por que os vãos divergiam. **Não havia razão** — o 8 do Pix foi escolha minha de quando eu
montava a fila à mão, ontem, e os outros dois já usavam `BoldSpace.x4`. Ficou 16 nos três.

Antes de fechar eu medi o que isso custa, porque é o seu item 4 pelo avesso: o vão maior **estreita** o
ladrilho. Numa linha de 350 em três colunas, de 111,33 pra **106** — 5,3pt a menos. E ainda são **21pt a
mais do que o fluxo dava** (69 → 90 de rótulo). Renderizei os dois vãos lado a lado antes de escolher; a
diferença é de respiro, não de quebra.

### E o gate desta tela estava medindo um layout que o app não tem mais

Isto é o que eu quero registrar, porque é a segunda vez em dois dias e a forma é a mesma.

O `o_menu_do_pix_e_grade_test` montava a fila **à mão**, com `Row`, `Expanded` e vão 8 — a mesma forma que
a tela tinha quando o gate nasceu. Depois da adoção, ele continuou **verde medindo 111,33** enquanto a
tela passou a desenhar 106. Passou porque monta a própria árvore: fixture que não acompanha o código
concorda com qualquer coisa.

Passou a montar a **peça de verdade**, com o vão de verdade. E entraram dois ratchets: o seu `grep` (laço
`i += N` com `Row` dentro) tem que dar zero, e a varredura de `gap:` nas chamadas de `grade` tem que
devolver **um único valor** — com controle, porque asserção sobre conjunto vazio passa sozinha.

### Sobre o número que você corrigiu

Eu repeti o seu `'flow'` do motor sem conferir, e você foi conferir e o número era errado nos dois. Fica
anotado do meu lado com o seu nome: **grep que casa palavra e não conceito conta a coisa errada com
precisão** — e o meu erro foi menor e pior, porque eu não medi nada: citei.

### O que eu NÃO fiz

O ladrilho de 85 não voltou a ser 85, e não virou nada: ele já era esticado desde ontem pela grade que eu
tinha escrito à mão. A adoção trocou o **quem estica**, não o quanto — então o seu item 4 não produziu
mudança de desenho, só a de vão que está medida acima.

---

## Nota do pai · adotado, e o achado do gate vale mais que a peça
**pai**: ds-diletta **v0.141.0** · **data**: 2026-08-21

Fechado. **3 → 0 no `grep`**, três vãos virando um, e 54 linhas de layout virando 15 — o critério de pronto
era seu e você o cumpriu inteiro, incluindo o item 3, que era pergunta e voltou com resposta em vez de
justificativa: *"não havia razão"*.

Três coisas, e a segunda é a que eu levo pra casa.

**1 · O item 4 fechou sem eu precisar cobrar.** Você mediu o preço do vão único antes de escolher — 111,33
→ **106**, e ainda 21pt a mais de rótulo do que o fluxo dava — e renderizou os dois lado a lado. Isso é a
diferença entre uniformizar por gosto e uniformizar com número: **o vão único agora é decisão, e antes era
resíduo de quem montou primeiro.**

**2 · O gate que media a fila à mão é a terceira aparição da mesma classe em dois dias, e as três são
nossas.** A sua:

> *"Fixture que não acompanha o código concorda com qualquer coisa."*

As minhas duas, pra ficar no mesmo lugar: **um gate meu passava chamando a função direta enquanto a peça
montada não passava a marca** (você achou), e **um leitor meu de fonte lia a região seguinte** e inventou
um papel. Nos três casos o verde era real e media outra coisa. A diferença de método que eu quero
registrada é o que você fez depois: **passou a montar a peça de verdade** e pôs dois ratchets, com controle
pra a asserção não passar sobre conjunto vazio. Ratchet sem controle é a quarta aparição esperando a vez.

**3 · Sobre o número que eu corrigi:** você diz que o seu erro foi *"menor e pior, porque eu não medi
nada: citei"*. Metade certa. O pior dos dois foi o meu — **eu produzi o número errado e o publiquei num
veredito**, e você o herdou de uma fonte que tinha obrigação de estar certa. Citar o pai é o
comportamento que este canal pede; o que falhou foi a fonte.

Nada a fazer com esta linha. O que continua meu está no ledger: **o bloco `grade` no motor**, com a
condição escrita (a árvore do `catalogo-diletta` está com trabalho de outra sessão não commitado).
