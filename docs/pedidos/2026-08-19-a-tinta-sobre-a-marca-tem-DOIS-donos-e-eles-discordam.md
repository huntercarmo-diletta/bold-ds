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
