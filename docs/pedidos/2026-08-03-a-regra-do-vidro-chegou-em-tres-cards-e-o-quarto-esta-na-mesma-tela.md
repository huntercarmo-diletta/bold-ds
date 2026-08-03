# Pedido · a regra do vidro chegou em TRÊS cards, e o quarto está na mesma tela

- **filho**: conta-bold-ds v0.9.2
- **pai**: ds-diletta v0.32.0 (`DilettaCardSurface`, `DilettaFeatureCard`)
- **é bloqueante?**: **não**, e é pequeno — mas é o tipo de resto que só aparece na tela montada, e ele
  apareceu no primeiro olhar depois do deploy

## O que falta

A `v0.32.0` fez o que eu pedi e converteu três: `DilettaAppList.carded`, `DilettaEmptyState` e
`DilettaQuickAccessCard`. O **`DilettaFeatureCard` ficou de fora**, e ele continua com

```dart
decoration: BoxDecoration(
  color: s.surface,   // ← sólido, cravado, como os outros três estavam
  ...
)
```

A medição é uma frase do dono do produto olhando o catálogo publicado: *"o glassy tá visível! esse tbm é
glassy"* — apontando o card **Conta PJ** da home, que é um `cartaoDeDestaque` → `DilettaFeatureCard`.

**Ele está na MESMA TELA que dois que converteram.** Duas listas em vidro, um cartão de destaque sólido, e o
mesmo fundo de cidade atrás dos três. Dois materiais na mesma dobra é pior que os dois errados iguais: o
primeiro parece decisão, e ninguém sabe qual é a certa.

## A medição do resto — porque um por um é o jeito de isto voltar amanhã

Varri `lib/src/widgets` do seu pacote atrás de card de CONTEÚDO que ainda crava superfície:

| componente | como está hoje | é card de conteúdo? |
|---|---|---|
| `DilettaFeatureCard` | `color: s.surface` cravado | **sim** — é o pedido |
| `DilettaFeatureDetailCard` | `s.isDark ? s.surface : null` + borda `primarySubtle` | **sim**, e com um `if (isDark)` que o vidro dispensaria |
| `DilettaInfoCard` | só borda `divider`, **sem cor** | não — é caixa de contorno, e vidro ali seria material novo |
| `DilettaPromoBanner` | `color: bg`, escolhido por variante | não — cor por chamada, mesmo caso do `NoticeBanner` que você declarou fora |
| `DilettaChatCompletionCard` | pinta com `primary07` | não — é peça de marca, e o Bold não tem chat |

Então o pedido é **dois**, não um: o `FeatureCard` (que a tela mostrou) e o `FeatureDetailCard` (que a
varredura achou, e que tem o `if (isDark)` como sintoma — a superfície dele já é um caso especial escrito à
mão).

## Por que eu não resolvo sozinho, de novo

Mesma fronteira do pedido de ontem, e a sua frase ainda vale: *"não é falta de parâmetro, é uma fronteira
desenhada errado"*. Eu declaro `cardDeVidro: true` e a decisão já está tomada deste lado — o que falta é a
peça ler a declaração. Envolver o `FeatureCard` num `GlassSurface` daqui faria o board desenhar vidro que o
componente não desenha, que foi o contorno que você recusou (com razão) na primeira rodada.

## O que eu peço

**`DilettaFeatureCard` e `DilettaFeatureDetailCard` passam pelo `DilettaCardSurface`**, como os outros três.
É a mesma troca, e no segundo ela apaga um `if (isDark)` de brinde: quem monta a superfície passa a ser quem
sabe montá-la nos dois modos.

Se algum dos dois tiver razão declarada pra ficar sólido, **é a razão que eu quero** — igual você fez com o
`NoticeBanner` (*"a cor dele é escolhida por chamada, e vidro descartaria a escolha em silêncio"*). Essa
frase resolveu o caso pra sempre; a ausência dela é o que faz o mesmo card voltar num print daqui a uma
semana.

## O que eu sugiro como gate, e é derivável

Você já tem `quem monta vidro à mão é só CHROME`. O par que falta é o inverso, e ele é uma lista de exclusão
como a sua: **todo widget cujo nome termina em `Card` monta pelo `DilettaCardSurface`, exceto os declarados
com motivo** (`InfoCard` = contorno, `PromoBanner`/`ChatCompletionCard` = cor por chamada). Assim o card
número seis nasce certo, ou nasce com a razão escrita — que é o que eu não tenho como cobrar daqui.

## O que eu já fiz do meu lado

Nada além de declarar — e é esse o ponto. `cardDeVidro: true` está na `BoldPalette.bold` desde a minha
`v0.9.0`, com gate que mede **pixel** (o azul de trás atravessando o tinte, canal B >20 acima do R). O gate
passa nos três convertidos. Quando os dois entrarem, ele passa a valer pros cinco sem eu escrever linha.

---

## Veredito · ENTRA UM dos dois, e o outro tem a razão que você pediu
**pai**: `ds-diletta` v0.33.0 · **data**: 2026-08-03 · **critério que pesou**: aplicação

### 1 · `DilettaFeatureCard` entra, e ficar de fora não foi decisão

Foi processo meu, e é bom dizer qual: **eu fui pela lista de quatro que você mediu, em vez de varrer a minha
própria pasta de widgets.** A sua lista estava certa sobre o que ela cobria; o buraco era ela não ser a minha
varredura. Por isso o card apareceu no primeiro print depois do deploy.

A sua frase é melhor que "faltou um" e virou o `///` do gate:

> **Dois materiais na mesma dobra é pior que os dois errados iguais: o primeiro parece decisão, e ninguém
> sabe qual é a certa.**

### 2 · `DilettaFeatureDetailCard` NÃO entra, e aqui está a razão

Você pediu a razão em vez do conserto se fosse o caso, e é o caso:

**A superfície dele é gradiente de MARCA** — branco → `primary09` no claro. Vidro descartaria a marca em
silêncio, que é exatamente a razão pela qual o `NoticeBanner` ficou fora na primeira rodada. Card cuja
superfície carrega identidade não troca de material por declaração de material: ele perderia a identidade
junto.

E o `if (isDark)` que você leu como sintoma **não é contorno da falta de vidro**: é o `primary09` não ter
papel no escuro, então no escuro o gradiente não existe e sobra o sólido. Isso é **assimetria de paleta**, não
de card. Se um dia isso incomodar de verdade, o pedido é outro — *"o `primary09` não tem papel no escuro"* — e
ele tem um caso medido: este card.

### 3 · O gate inverso é seu, e entrou como você desenhou

`todo_card_monta_pelo_card_surface_test`: todo widget de card monta pela peça, **ou está numa lista com o
motivo escrito**. As seis exceções, cada uma com a razão no código:

| exceção | motivo |
|---|---|
| `info_card` | contorno: não tem preenchimento nenhum, só borda. Vidro ali seria material NOVO |
| `feature_detail_card` | gradiente de marca (o item 2) |
| `chat_completion_card` | preenchimento de marca (`primary07`) |
| `wallet_card` · `wallet_card_stack` | arte de marca — gradiente, logo, bandeira |
| `face_id_card` | vive DENTRO da folha, que já é vidro. Vidro dentro de vidro dobra o material |
| `card_surface` | é a própria peça |

E duas asserções que você não pediu e que a sua própria frase exige — *"a ausência da razão é o que faz o card
voltar num print"*: **exceção declarada pra arquivo que não existe mais falha**, e **motivo curto demais
falha**. Um `// ok` na lista faria a lista existir sem fazer o trabalho dela. A primeira já me pegou: eu tinha
escrito *"é a própria peça"* e o teste reprovou por motivo curto.

### O que você faz

Nada além de subir pra **v0.33.0**. O seu gate de pixel passa a valer pros quatro convertidos sem você
escrever linha, que era o que você disse — e é a melhor prova de que a fronteira está no lugar certo agora:
**a declaração era sua desde a v0.9.0, e o que faltava era a peça ler.**
