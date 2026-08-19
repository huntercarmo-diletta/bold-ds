# PEDIDO · a tinta sobre a marca tem DOIS donos, e eles discordam na mesma tela

- **de**: conta-bold-ds (filho B) · **para**: ds-diletta
- **consome**: ds-diletta v0.111.0 · catalogo-diletta v0.108.0 · DS filho v0.51.0
- **bloqueante?**: não — eu entrego sem isso, com o custo da seção «Se você disser não»

## Falta

Um jeito de o filho declarar `onPrimary` e **ganhar da sua derivação**, assumindo o número por escrito.

## Número

`dilettaTintaSobre(p.primary04, p.onPrimary, …)` mede branco sobre o rosa da marca em **3,46:1**,
não alcança o piso AA de 4,5 e cai pro escuro. Eu declaro `onPrimary: #FFFFFF` na paleta; você
entrega **preto**. Resultado, hoje, no aparelho:

| quem pinta | tinta sobre o rosa |
|---|---|
| `DilettaInputChip.selecionavel` (seu) | **preto** |
| `BoldButton` primário, `BoldToggle`, os selos (meus) | **branco** |

**A mesma tela mostra os dois.** Na tela de personalização da assistente, o chip "São Paulo"
selecionado sai com rótulo preto sobre o rosa e, quatro dedos abaixo, o CTA "Salvar alterações" sai
branco sobre o mesmo rosa. Chegou do dono do produto assim: *"em alguns lugares o over primary tá
preto e em outros branco, e deve ser tudo branco"*.

Alcance: **6 dos 9 arquivos seus que leem `onPrimary`** estão neste app, em **51 chamadas** —
`DilettaSpotIcon` (23), `DilettaIconButton` (19), `DilettaButton` (4), `DilettaCheckbox` (4),
`DilettaInputChip` (1). Do meu lado são 19 sítios declarando branco.

## Já tentei

**1 · Escurecer o `primary04`.** É o rosa do logo. Trocar o degrau conserta o contraste e muda a
marca em toda tela — é a saída que você mesmo recusou pro pedido que criou esta derivação:
*"tinta é consequência de legibilidade, preenchimento é decisão de marca"*.

**2 · `ajustesDePapel` com motivo `contraste`.** Não serve, e a razão é a sua própria trava: o motivo
`contraste` cobra **melhora medida**, e eu quero ir de 12,3:1 (preto) para 3,46:1 — piora. Com motivo
`marca` a troca teria que ser por outro papel da família `primary`, e nenhum deles é branco.

**3 · Aceitar o preto nos dois lados.** É a saída coerente, e eu medi antes de recusar: são as 51
chamadas acima mais os 19 sítios meus, e o CTA primário do produto passaria a ter rótulo preto. O
dono olhou e disse que não é o produto dele.

## Conferi no pai

Fui escrever que a derivação estava errada, e ela não está. O `///` do `onPrimary` carrega a
aritmética que a justifica — *"razão-com-branco × razão-com-preto ≈ 21, então quando o branco
reprova o preto passa com folga"* — e o caso que a produziu foi um pedido de filho com medição, em
que **dois de três palettes reprovavam**. A regra é boa e eu não quero que ela saia.

O que eu li e mudou o pedido: ela é uma derivação **incondicional**. `dilettaTintaSobre` recebe o
valor declarado e o descarta em silêncio quando ele não passa. Não existe caminho pra um filho dizer
*"eu medi, eu sei, e é minha"* — e é isso que eu peço, não a remoção do piso.

## Derivável?

Não. É exatamente o oposto de derivável: o que falta é o canal pra o valor **declarado** sobreviver
à derivação. Hoje declarar `onPrimary` na paleta não tem efeito nenhum quando o par reprova — o
campo existe e é ignorado, que é a pior das três posições possíveis (ter, não ter, ou ter mentindo).

## Se você disser não

Eu paro de usar o `DilettaInputChip.selecionavel` e desenho o chip aqui, com a tinta que o produto
pede. Preço: uma peça privada nova num filho que fechou a fila de privadas em 17/08, e um sítio a
menos de adoção — pra um caso em que a linguagem tem a peça certa e só discorda de uma cor.

E fica a assimetria escrita: enquanto a divergência existir, **o mesmo papel tem duas respostas no
mesmo app**, e nenhum gate acusa isso, porque cada lado está certo sozinho.

## Não estou pedindo

1. **remover o piso** — a derivação fica ligada por default, e quem não declara continua protegido;
2. **um campo por componente** — não é adequação de cliente, é um papel só, na paleta;
3. **que você concorde com o número.** 3,46:1 é meu, e eu quero assumi-lo por escrito. Se o formato
   for um campo que obrigue a escrever a razão junto, melhor pra mim — a próxima pessoa lê o motivo
   em vez de achar que foi descuido.

## Como o pai vai saber que funcionou

Dois gates, e o segundo é o que importa:

1. **o meu**: `DilettaInputChip.selecionavel` e o `BoldButton` primário pintam a MESMA tinta sobre o
   rosa, medido em pixel, nos dois modos;
2. **o seu**: uma paleta que declara a tinta e a assume aparece na sua auditoria como **exceção
   nomeada**, com o número e a razão — não como ausência de defeito. A diferença entre "isto passa" e
   "isto é uma dívida com dono" é a coisa toda; foi você que escreveu que exclusão que não deixa
   número é dívida escondida com nome bonito.

---

## Veredito · ENTRA DIFERENTE — a porta existe, com número obrigatório e TETO no piso gráfico
**pai**: ds-diletta **v0.115.0** · **data**: 2026-08-19

`DilettaPalette.tintasAssumidas`, uma lista de `DilettaTintaAssumida(papel, razao, medida)`.

### O que decidiu

A sua leitura da derivação, que é mais precisa que o pedido:

> *"Ela é uma derivação INCONDICIONAL. `dilettaTintaSobre` recebe o valor declarado e o descarta em
> silêncio quando ele não passa. Não existe caminho pra um filho dizer 'eu medi, eu sei, e é minha'."*

E a frase que fechou a forma, que é sua e virou o `///` do tipo:

> *"O campo existe e é ignorado — a pior das três posições possíveis: ter, não ter, ou ter mentindo."*

Isso decidiu **contra** as minhas duas primeiras ideias. A primeira era um motivo novo no
`ajustesDePapel`; a segunda, um campo por peça. As duas morreram no seu item 2 (*"não é adequação de
cliente, é um papel só, na paleta"*) e no seu número: **51 chamadas em 6 dos meus arquivos, mais 19
sítios seus.** Ajuste por componente resolveria 6 arquivos e deixaria o sétimo nascer errado — a mesma
razão pela qual o seu outro pedido, o do piso, também não virou ajuste.

Critérios: **manutenção** (uma declaração contra 70 sítios) e **robustez** — e a robustez é o que
justifica as travas abaixo, porque porta sem batente é como a divergência voltaria por dentro.

E o seu item 3 é o que eu mais gostei de implementar: *"se o formato obrigar a escrever a razão junto,
melhor pra mim — a próxima pessoa lê o motivo em vez de achar que foi descuido."* `razao` e `medida` são
**obrigatórios**, e a `medida` é **conferida**: `excecoesDeTintaAssumida` recalcula o contraste e acusa
`tinta-assumida-com-numero-errado` quando o declarado é melhor que o medido. Número que ninguém confere é
adjetivo com vírgula.

### O TETO, que é a única coisa que você não pediu e entrou

A declaração é honrada **até o piso de objeto gráfico do modo** (3:1 no AA, 4,5 no AAA), e não abaixo:

> **Marca decide entre legível e mais legível; ninguém decide por ilegível.**

Acima do teto existe decisão a tomar — um rótulo em 3,46 **se vê**, não alcança o piso de texto, e alguém
assume esse número com nome e data. Abaixo de 3:1 não há decisão: há rótulo invisível, e aí a derivação
continua consertando, porque isso não é dívida com dono, é defeito.

**O que isso significa na sua paleta, medido, e é informação e não recusa:**

| modo | branco sobre o preenchimento | o que sai |
|---|---|---|
| claro | 3,46 sobre o `primary04` | **o seu branco.** Passa do teto, você assumiu |
| escuro | 2,73 sobre o `primary05` | a tinta derivada — abaixo do teto |

Então o `onPrimary` do seu escuro continua não sendo branco. **O seu gate 1 fecha do mesmo jeito** — ele
mede *o chip do pai e o `BoldButton` pintam a MESMA tinta sobre o rosa, em cada modo* —, e fecha porque os
dois passam a ler o papel: no claro os dois ficam brancos, no escuro os dois ficam com a tinta derivada.
O que não fecha é *branco nos dois modos*, e o caminho pra isso não é meu: **é o DEGRAU do escuro**. Se o
produto quer branco lá, o preenchimento do escuro precisa de um rosa mais fechado — decisão de marca, e
ela é sua.

### O que eu achei indo implementar

**1 · O seu gate 2 já estava respondido pela conformidade, e eu não sabia.** Você pediu que a exceção
aparecesse *"como exceção nomeada, com o número e a razão — não como ausência de defeito"*. Fui escrever o
silenciamento do `contraste-role` e descobri que **não precisa**: aquela checagem cobra o piso GRÁFICO do
modo, que é exatamente o teto. Ou seja — uma tinta honrada nunca deixa a conformidade vermelha, e uma
tinta abaixo do teto **não é honrada** e cai na derivação. As duas metades já concordavam; o que faltava
era a lista com o número, e é ela que `excecoesDeTintaAssumida` devolve.

**2 · A exceção diz em QUAIS MODOS ela vale, e essa coluna não estava no seu pedido.** Ela existe porque a
sua própria paleta é o caso em que a resposta difere por modo. `honradaEm` é medido comparando o pixel que
saiu com o valor declarado — não repetindo a conta do teto —, então se a derivação mudar de forma um dia,
a medição continua certa.

**3 · Assumir PREENCHIMENTO é violação, e isso é fronteira e não zelo.** O gate recusa
`tintasAssumidas: [primary]` com `tinta-assumida-que-nao-e-tinta`: preenchimento já é livre, não há
derivação pra vencer ali, e declaração que não faz nada é a que ninguém remove. Papel que não existe
(typo) também é acusado — `onPrimaryy` não é *"não fez efeito"*, é `tinta-assumida-de-papel-inexistente`.

**4 · O helper novo quebrou o meu gerador de origem dos papéis** — e o teste que confere o gerador tinha o
MESMO furo, palavra por palavra. Está contado no veredito do seu outro pedido e no
`GATE-QUE-MEDE-A-COISA-CERTA.md` (24ª entrada). Sai daqui como registro: **o seu pedido pagou um defeito
meu que não tinha nada a ver com cor.**

### O que eu recusei, e a condição de reabrir

- **honrar abaixo de 3:1.** Recusado com a razão acima. **Reabre** com um caso em que alguém assuma um
  número abaixo do piso gráfico E tenha argumento que não seja *"o dono prefere"* — por exemplo tinta que
  só aparece sobre gradiente onde a pior parada não é o pixel medido;
- **assunção por MODO** (`onPrimary` branco só no claro, declarado). Recusado por agora: o teto já produz
  esse resultado sem campo novo, e campo que repete o que a medição já faz é a segunda fonte que um dia
  discorda. Reabre se você quiser assumir no ESCURO um valor que o claro não assume — aí a lista precisa
  de eixo, e o pedido traz o número dos dois lados;
- **remover o piso**, que você já não pediu. Fica escrito: a derivação nasce ligada, e quem não declara
  continua protegido.

### O que você faz

`ref: v0.115.0`

1. na sua paleta:

   ```dart
   tintasAssumidas: const [
     DilettaTintaAssumida(
       papel: 'onPrimary',
       razao: 'o dono do produto decidiu branco sobre a marca — CTA, selos e toggle',
       medida: 3.46,
     ),
   ],
   ```

2. **os 19 sítios seus passam a ler `s.onPrimary`** em vez de cravar branco. É o que faz a declaração
   valer: enquanto eles pintarem branco por conta própria, o dia em que a marca mudar de degrau produz a
   mesma divergência de hoje com outro número;
3. o `DilettaInputChip.selecionavel` passa a pintar branco no claro sem você fazer nada;
4. rode `excecoesDeTintaAssumida(suaPaleta)` no seu gate e **imprima a linha**. Ela é a dívida com dono, e
   ela vale mais no seu relatório que no meu: *"declarado 3,46 · medido claro 3,46 / escuro 2,73 · honrada
   em claro — o dono do produto decidiu branco"*. Se o número mudar porque a marca mudou, o seu gate
   avisa antes de alguém achar que foi descuido;
5. e me diga o que o dono decide sobre o ESCURO. Se ele quiser o branco lá também, o caminho é o degrau do
   preenchimento — e se você medir esse caso, ele vira pedido, não conversa.

## Resposta do filho · adotado na v0.53.0 — honrado no claro, e a divergência ANDOU pro escuro
**data**: 2026-08-19

Declarei, e a auditoria confere:

```
onPrimary · declarada 3,46 · medidas {claro: 3,46 · escuro: 7,70} · honrada em {claro}
violacoesDaTintaAssumida = 0
```

No claro a tinta sobre a marca é **branca** nas suas peças — o mesmo branco que o CTA deste produto
sempre usou. O caso que abriu o pedido (chip escuro ao lado de CTA branco, na mesma tela) fechou.

**E o teto fez exatamente o que você escreveu que ele faria, o que é a parte que eu preciso registrar
como dívida e não como vitória:** no escuro você clareia a marca pro degrau 05 e o branco cai pra
**2,73**, abaixo de 3:1 — a derivação segue mandando e a tinta sai escura. Mas o meu esquema usa o
**04 nos dois modos**, então no escuro as minhas peças pintam branco sobre `#FE3976` (3,46) e as
suas pintam escuro sobre `#F66FA0`. **A divergência não morreu, ela andou de modo.**

Não estou pedindo nada por isso ainda, e é de propósito: o que falta medir é se o produto quer a
marca no 05 no escuro (e aí a tinta escura vem junto, coerente) ou no 04 (e aí a pergunta é sua). É
decisão do dono antes de ser pedido, e ela vai com os dois números quando eu tiver o veredito dele.

**E um achado seu que eu confirmo daqui:** o gate 2 que eu pedi já existia. O `contraste-role` cobra
o piso gráfico, que é o teto — então tinta honrada nunca deixa a conformidade vermelha. O que eu
pedi por engano foi um gate novo pra uma cobrança que a sua régua já fazia.

**O gate do catálogo mudou de lado por causa disto.** Ele afirmava *"nenhum par declarado reprova em
AA"* e passou a afirmar **"todo par abaixo de AA é exceção DECLARADA"** — com a lista de exceções
vinda da paleta e a auditoria conferindo o número. Par que reprova sem declaração continua defeito;
com declaração é dívida com dono. A régua é sua, e ela ficou melhor que a minha original.
