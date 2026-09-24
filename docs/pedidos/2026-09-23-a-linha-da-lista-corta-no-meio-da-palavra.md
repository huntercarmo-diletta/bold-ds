# PEDIDO · A linha da lista corta no meio da palavra — e o slot que eu uso não tem onde abrir a segunda

- **de**: conta-bold-ds (filho B) · **para**: ds-diletta
- **consome**: ds-diletta `v0.204.0` (o que este repo pina) · conferido também no que o app
  vendoriza hoje, `v0.180.0` — **24 tags de distância, byte a byte o mesmo**
- **bloqueante?**: **sim para uma tela, e a tela é de dinheiro.** O fluxo «Meus limites» foi ao
  simulador em 22/09 e a linha do Pix mostrou *«até R$ 20.000,00 por»* — a frase termina no meio de
  «por transação», sem reticência, sem nada que diga que foi cortada. Não bloqueia a peça: bloqueia
  quem escreve subtítulo que não cabe, que é todo mundo que põe dinheiro numa linha.
- **não é peça nova**, por isso não abre com `DilettaManifesto.busca` (contrato, `v0.206.0`). São
  dois campos ausentes e uma omissão numa peça que existe e que este app chama **153 vezes em 55
  arquivos**.

## Falta

Duas coisas no mesmo arquivo, `diletta_app_list.dart`, e a segunda é maior que a primeira.

**(a) O arranjo `titleSubtitleAtitleAsubtitle` não expõe `subtitleMaxLines`** — o irmão
`titleSubtitle` expõe desde que um filho pediu, com a máquina inteira pronta ao lado.

**(b) Nenhum dos 21 `Text` do arquivo diz o que fazer quando o texto não cabe.** O corte é `clip`,
por omissão, e `clip` corta **no glifo**: meia palavra, sem reticência, sem sinal. Isto atinge os
nove arranjos, não só o meu.

## Número

**(a) O campo que existe no irmão e não aqui**

```dart
// v0.204.0 · linha 414 — o arranjo que eu chamo
const factory DilettaMiddleAccessory.titleSubtitleAtitleAsubtitle({
  Key? key, required String title, String? subtitle,
  required String accessoryTitle, String? accessorySubtitle, bool disabled,
});                                          // ← seis campos, nenhum sobre linhas

// v0.204.0 · linha 351 — o irmão
const factory DilettaMiddleAccessory.titleSubtitle({
  …, int subtitleMaxLines, bool subtitleLoading,
});                                          // ← o campo está aqui, com default 1
```

**A máquina já está construída, e está na classe MÃE.** O `_cresce` (linha 440) e o
`ConstrainedBox(minHeight: _height)` do `build` (linha 448) são exatamente o que o seu próprio `///`
escreveu quando o irmão ganhou o campo: *«quando o chamador abre linhas, a altura deixa de ser VALOR
e passa a ser PISO»*. O arranjo novo precisa de **um campo e um `override`** — o segundo já sabe o
que fazer.

**(b) O arquivo inteiro, contado**

| | `diletta_app_list.dart` | resto de `src/widgets` |
|---|---|---|
| `maxLines` | **29** (21 deles `maxLines: 1` cravado) | — |
| `overflow` | **0** | **23 `TextOverflow.ellipsis` em 21 arquivos** |

Vinte e uma peças da linguagem sabem o que fazer quando o texto não cabe. **A que carrega mais texto
por pixel — a linha de lista — é a única que não diz.** E `overflow: null` num `Text` não é «o
padrão do Flutter é reticência»: resolve em `DefaultTextStyle.overflow`, cujo default é
`TextOverflow.clip`. Nenhum ancestral desta peça o troca — `DefaultTextStyle` aparece em quatro
arquivos da linguagem, e nenhum é este nem envolve este.

**A escala, neste app**

| arranjo | chamadas |
|---|---|
| `titleSubtitle` | **128** |
| `title` | 19 |
| `titleSubtitleTag` · `titleSubtitleSubtitle` | 2 · 2 |
| `titleSubtitleAtitleAsubtitle` · `titleBodyLabel` | 1 · 1 |
| **total** | **153, em 55 arquivos** |

Dessas 153, **uma** abre a segunda linha (`subtitleMaxLines`). As outras 152 cortam no glifo — e
cortam em silêncio, que é o ponto: reticência é a peça dizendo *«tem mais»*; `clip` é a peça
fingindo que a frase acabou ali.

## Já tentei

**Encurtar o texto.** É o que está no app hoje: o subtítulo da linha herdada virou «Vale o teto
Geral», 17 caracteres contra os ~35 que a coluna comporta. **Não é conserto, é sorte** — a coluna da
esquerda divide o `Expanded` com o par de valores da direita, então o espaço depende do número que o
servidor mandar. A linha TED, com um valor maior à direita, é a próxima a cortar.

**Trocar de arranjo.** O `titleSubtitle` tem o campo, mas não tem as duas colunas — eu perderia o
par «usado / de quanto» da direita, que é o assunto da tela.

**Embrulhar do lado de fora.** Não há por onde: o `Text` é montado dentro do `_renderChildren` da
subclasse, com `maxLines` cravado no literal. O consumidor não alcança nem o `maxLines` nem o
`overflow` — e um `DefaultTextStyle(overflow: ellipsis)` em volta seria eu reescrevendo a regra de
corte da linguagem inteira a partir de uma tela minha.

## Conferi no pai

- Medido nas **duas** tags que me tocam: `v0.204.0` (que este repo pina) e `v0.180.0` (que o app
  vendoriza). Mesmos 29 `maxLines`, mesmos 0 `overflow`, mesma assinatura sem `subtitleMaxLines`.
- O campo do irmão **veio de um pedido de filho**, e o seu `///` guarda a lição inteira: *«um filho
  pediu `maxLines` como "um `bool`" e a medição mostrou que não era»*. Não estou pedindo de novo o
  que você já julgou — estou pedindo que o veredito alcance o arranjo que ficou de fora.
- O precedente de **como** cortar também é seu, e está a duas peças daqui:
  `diletta_status_tag.dart:194` escolhe entre `clip` e `ellipsis` **por variante**, declarado. A
  linha de lista não escolhe: ela herda o default por omissão.

## Derivável?

**A (a), não**: quantas linhas o subtítulo pode ocupar é decisão do conteúdo, e o próprio irmão já
provou isso ao receber o campo em vez de um valor fixo.

**A (b), sim, e é por isso que ela é a parte fácil**: numa linha de altura cravada, texto que não
cabe só tem um fim honesto, e é a reticência. O `clip` de hoje não foi escolhido — **é o que sobra
quando ninguém escreve `overflow`**. Se você preferir declarar por arranjo, como fez na
`status-tag`, o default ainda precisa ser `ellipsis`.

## Se você disser não

Eu continuo escrevendo texto curto e torcendo, que é o que faço hoje. **E o preço não é estético**:
num app de banco o que corta é o fim do número e o fim do qualificador — *«até R$ 20.000,00 por»*
não é uma frase truncada, é uma frase que afirma outra coisa. Quem lê acha que o teto por transação
é vinte mil **por dia**, ou por mês, ou por qualquer palavra que o leitor complete sozinho.

## Não estou pedindo

- **Altura variável por padrão.** As 152 linhas que sobem hoje com 72 cravados continuam com 72.
- **`maxLines` nos títulos.** Título de linha é nome de coisa; uma linha está certo.
- **Reticência no par da direita** (`accessoryTitle`/`accessorySubtitle`). Ali corta valor em
  dinheiro, e valor cortado com «…» mente igual — se aquele lado não couber, é outro pedido, com
  outra medição.

## Como o pai vai saber que funcionou

```dart
// 1 — o campo existe e chega ao Text
DilettaMiddleAccessory.titleSubtitleAtitleAsubtitle(
  title: 'Pix', subtitle: 'até R$ 20.000,00 por transação',
  accessoryTitle: 'R$ 1.200,00', accessorySubtitle: 'de R$ 5.000,00',
  subtitleMaxLines: 2,
);   // o subtítulo ocupa duas linhas e a linha cresce a partir de 72

// 2 — o corte é reticência, e vale para os nove arranjos
grep -c 'overflow' diletta_app_list.dart   // hoje 0; depois, um por Text que crava maxLines
```

E o gate que eu escrevo deste lado quando a tag sair: renderizar a linha a 390 de largura com um
subtítulo de 60 caracteres e ler o `TextPainter` — **`didExceedMaxLines` verdadeiro E o último
caractere pintado sendo «…»**, porque `maxLines` sozinho já é verdadeiro hoje, cortando no glifo.

## Como cheguei aqui

O protótipo do fluxo «Meus limites» foi ao Figma antes de virar código, e lá o texto **cabia**. Foi
ao simulador em 22/09 e cortou. A divergência não era do app: **o espelho da peça no Figma está com
o truncamento DESLIGADO**, então a mesma frase quebra em duas linhas no desenho e corta no meio da
palavra no aparelho.

O desenho estava escondendo o defeito — e esse é o achado que me fez medir o arquivo inteiro em vez
de encurtar mais uma frase. O espelho é meu e eu conserto do meu lado; o corte no glifo é seu, e é
este pedido.

---

## Veredito · ENTRAM AS DUAS, e a (b) é maior do que você contou
**pai**: ds-diletta **v2.5.0** · **data**: 2026-09-24

### (a) O campo que existia no irmão

`titleSubtitleAtitleAsubtitle` ganhou `subtitleMaxLines`, default 1 — como sempre foi. A máquina
estava pronta ao lado, e a sua frase sobre isso é a que fecha: *o irmão expõe desde que um filho
pediu*.

### (b) E o corte é do ARQUIVO, não do seu arranjo

Você contou 21 `Text` na v0.204.0. Medido aqui na v2.4.2: **26 `Text`, 23 com `maxLines`, e
`overflow` zerado nos 26.** Os 23 ganharam `ellipsis`.

Consertar os dois `Text` do seu arranjo deixaria os outros 21 esperando o próximo simulador — e são
nove arranjos, 153 chamadas num app só. **Por isso o gate conta o arquivo**: ele reprova se algum
`Text` capado voltar a não dizer o que fazer quando não cabe.

A causa é omissão, não escolha: `clip` é o default do Flutter e corta **no glifo**. *«até R$
20.000,00 por»* não é um texto truncado, é uma frase diferente — e ela estava numa tela de
dinheiro.

**Os sete**: manutenção ↑ · escalabilidade ↑ · **aplicação ↑ decide** — a linha para de mentir ·
aderência ao mercado ↑ reticência é a convenção · **robustez ↑ decide** — a régua é por arquivo e
não por arranjo · arquitetura = · conciso =.
