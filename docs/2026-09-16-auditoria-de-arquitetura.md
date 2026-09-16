# Auditoria de arquitetura — 2026-09-16

Segunda rodada. A primeira é [03/08](2026-08-03-auditoria-de-arquitetura.md), e onde dá pra comparar, a
coluna "03/08" compara.

## Como esta rodada foi rodada, e o que isso custa

A ferramenta do pai (`ds-diletta/tool/audita_arquitetura.py`) **não estava na árvore desta sessão** — o
`ds-diletta` mora no Bitbucket e chega aqui por tag no `pubspec`, não como repo. Então as dez checagens
foram **reproduzidas** a partir do critério escrito nos dois documentos que as definem: a rodada de 03/08 e
o pedido [a auditoria não sabe que está num filho](pedidos/2026-07-30-a-auditoria-nao-sabe-que-esta-num-filho.md)
(que é quem fixou `produto_local`, `sem_comentario_dart` e a separação `_ =>` × `_ => throw`).

**A ressalva que isso impõe, dita antes dos números:** reprodução não é a ferramenta. Onde o critério dela
for mais fino que o regex daqui, o número daqui é o menos confiável dos dois. Os comandos de cada checagem
estão no fim, pra que rodar a ferramenta de verdade dê pra conferir linha a linha.

Duas coisas mais faltaram, e as duas mudam leitura:

- **não há Flutter nesta máquina** — nenhum gate foi executado. Tudo aqui é leitura de texto, e
  "os gates estão verdes" **não é** uma afirmação desta rodada;
- **o `app-newbold` não está no corpo de leitura.** Em 03/08 a checagem 4 só fez sentido com ele
  (*"eram 3 sem ele, 0 com"*). Aqui ela volta a ser inconclusiva pelo mesmo motivo — ver o item 4.

## O corpo

| | arquivos | linhas |
|---|---|---|
| `lib` (DS + catálogo + exemplo) | 77 | 19.046 |
| `test` (DS + catálogo) | 82 (77 `_test.dart`) | 9.386 |

Último commit que tocou `.dart`: **2026-09-04**. Último commit: **2026-09-08**. Doze dias de código parado
com designers consumindo o catálogo — que é o motivo desta rodada existir.

**E o corpo não é o mesmo de 03/08**, o que limita metade das comparações: lá eram *"27 arquivos de lib e 40
de teste"*; aqui são 77 e 82, num monorepo de três pacotes que naquela data não existia com esta forma.
Comparação de CONTAGEM (itens 8 e 9) carrega esse viés e está marcada onde carrega; comparação de SÍTIO
(itens 1 e 5, que apontam arquivo e linha) não carrega.

## O que a máquina achou, e o que eu li

| # | achado | 03/08 | hoje | leitura |
|---|---|---|---|---|
| 1 | maior arquivo de lib | 2477 · 32% | **4319 · 22,7%** (`ds_do_bold.dart`) | **o único que eu levaria adiante, e é o mesmo de 03/08** — ver abaixo |
| 2 | nome de produto IRMÃO no lib | 3 (falso positivo) | **0 em código · 1 citação** | **zero, e a única ocorrência é a prova de que o conserto da `ds v0.21.4` funciona** — ver abaixo |
| 3 | cadeia de decisão por tipo | 9 em `leitor_do_bold.dart` | **3 no repo inteiro**, máximo 1 por arquivo | **resolvido, e não por esta auditoria** — o leitor não decide mais por tipo |
| 4 | símbolo público com ≤1 uso | 0 (com o irmão no corpo) | **4 sem o corpo do app** | **inconclusivo**, pelo mesmo motivo de 03/08 — mas 1 dos 4 é achado por outra razão, ver abaixo |
| 5 | `_ =>` que degrada em silêncio | 2 | **5** | **3 são novos e nenhum tem razão escrita** — ver abaixo |
| 6 | `catch` vazio · `catch (_)` | 0 · 0 | **0 · 0** | nada |
| 7 | classe abstrata com ≤1 implementação | 0 | **0** | nada, e a razão é boa: as 9 `abstract` do lib são todas `abstract final class` — namespace de estáticos, que o Dart fecha pra extensão de propósito. Nenhuma é abstração esperando implementação, que é o que a checagem persegue |
| 8 | asserções de presença nos testes | 65 presença · 3 de pixel | **87 presença · 5 gates de pixel** (+1 ferramenta) | **a régua de 03/08 pegou**: os gates de pixel quase dobraram e a razão presença:pixel caiu. Ver abaixo |
| 9 | campos opcionais no lib | 21 | **143** | julgamento, e o número cru não compara (corpo diferente). Em DENSIDADE: 2,7 → **7,5 por mil linhas**. Sem caso medido de dano não é achado, mas é a única checagem cuja densidade quase triplicou, e quem for olhar olha por aí |
| 10 | vocabulário cravado | 3 listas | **3 listas + 1 nova** (`_variantesDaBarra`) | **curadoria declarada** — a nova nasceu com a razão em cima dela, como as três |

E um achado que **não é das dez checagens**, porque a ferramenta não mede o que este repo decidiu em 04/09:

| | medido hoje | o que o ADR mediu em 04/09 |
|---|---|---|
| `bash tool/levanta_a_separacao.sh --total` | **300** | **300** |
| o que É do Bold (vai pro filho) | **176** | 176 |
| os 14 cortes (componente lendo constante do Bold) | **109** | 109 |
| "Conta BOLD" em comentário de doc | **15** | 15 |

## Os seis que merecem parágrafo

### 0 · O ADR do Coreflow está em zero, e os quatro números reproduzem na vírgula

O [ADR de 04/09](2026-09-04-adr-o-coreflow-e-o-pai.md) — *o Coreflow é o pai, o Bold é o primeiro filho* —
continua com **estado: proposto**, e nenhuma das cinco fases começou:

- `packages/coreflow` **não existe** (fase 0);
- o gate `o_coreflow_nao_cita_bold` **não existe** (fase 0);
- `levanta --total` devolve **300**, que é o número do dia em que o ADR foi escrito (fase 1 pediria 176).

Os outros três números do levantamento — 176, 109, 15 — reproduzem **exatos**. Três números iguais doze
dias depois não são coincidência: é a medição de que **nada se moveu**.

**A leitura, e ela não é "executem o ADR".** Um ADR proposto que não anda é barato enquanto ninguém depende
dele; o que mudou é que **designers passaram a usar o catálogo**, e a primeira coisa que o ADR prometia é o
que elas encostam: que um produto novo nasça sem herdar o Bold. Hoje ele ainda nasce com o Bold por
default, em cinco amarras que o ADR nomeia uma a uma.

O que fica proposto é **uma decisão, não trabalho**: o ADR tem um dono declarado (*"quem decide: o dono do
DS"*) e não tem veredito. Fase 0 sozinha custa um pacote vazio e um gate que **nasce vermelho com o número
do dia** — ratchet, não meta, como está escrito lá. E o gate da fase 0 é o que faz os 109 pararem de andar
sozinhos: sem ele, nada impede que o próximo componente `Coreflow*` leia mais uma constante do Bold, e o
número só reaparece na auditoria seguinte.

### 1 · O registro de blocos tem 4319 linhas e 96 blocos — e a proposta de 03/08 ficou mais cara

É o item que 03/08 levou adiante e **não fez**, com o custo escrito: *"o arquivo é editado a cada bloco, e
quem procura um bloco procura por nome — busca, não rolagem"*. Aquela leitura continua certa. O que mudou
é o tamanho do ganho que ela recusa:

| | 03/08 | hoje |
|---|---|---|
| linhas | 2477 | **4319** (+74%) |
| blocos no registro | 56 | **96** (+71%) |
| linhas por bloco | ~44 | **~45** |
| o corte por grupo daria | ~5 × 400 | **~5 × 860** |

A densidade **não piorou** — 44 → 45 linhas por bloco. O arquivo cresceu porque o vocabulário cresceu, que
é exatamente o que o cabeçalho dele diz que aconteceria (*"o escopo CRESCEU por medição"*). Então não há
defeito de desenho aqui: há um número que cresceu 74% sem ninguém revisitar a decisão que o deixou crescer.

**Fica proposto de novo, com uma diferença:** em 03/08 o custo do corte era partir o histórico de um arquivo
de 2477 linhas. Hoje é o de 4319, e daqui a dois meses é o de 6000. A decisão não fica mais barata esperando.

**E um número solto, que é conserto de uma linha:** o docstring do arquivo diz *"Hoje são 56 blocos (medido
em 2026-08-06)"*. São 96. O próprio docstring já se defende (*"a contagem que vale é a do registro, e os
gates derivam dela em vez de repeti-la"*) — o que sobra é a prosa 71% fora, e ela é a primeira coisa que
alguém lê ao abrir o arquivo.

### 2 · Zero em código, e a única citação é a prova de que a checagem está certa

`CpfSeguro` aparece **uma vez** neste repo, e ela é boa de ler:

```dart
// Spec do TOAST — espelha 1:1 o CpfSeguroToast: glyphs check/xmark/triangle/
```
`bold_aviso.dart:33`

Está dentro de um `//`, e é a regra que o pai escreveu na `v0.21.4` **rodando exatamente no caso que a
motivou**:

> **Nome de produto em COMENTÁRIO é citação; em CÓDIGO é dependência.**

Contando texto cru, a checagem devolveria 1 e alguém aprenderia a pular a linha. Com `sem_comentario_dart`
ela devolve **0**, e a citação — que diz de onde o desenho do toast veio — fica de pé. **Nada a fazer.**
Está aqui porque uma checagem que continua acertando seis semanas depois do conserto merece a linha.

### 4 · Um dos quatro símbolos não é sobre contagem de uso

A checagem 4 é inconclusiva sem o `app-newbold` — foi assim em 03/08 e é assim aqui. Os quatro:

| símbolo | usos neste repo | leitura |
|---|---|---|
| `CoreflowToast` | 0 | classe de estáticos; quem chama é o app. **Inconclusivo** |
| `CoreflowBarraComTeto` | 0 (2 citações em doc) | e `ds_do_bold.dart:1892` **escreve por que** ele não vira bloco. **Inconclusivo, e a ausência é declarada** |
| `OnboardingProgressBar` | 0 (1 citação em doc) | **inconclusivo** |
| `OnboardingPjChip` | **0** | **achado, e não por contagem** |

`OnboardingPjChip` (`bold_pagina.dart:185`) é exportado pelo barrel e o corpo dele inteiro é:

```dart
Widget build(BuildContext context) => const CoreflowEtiqueta(
      label: 'Abertura de conta PJ',
      tone: DilettaStatusTone.primary,
      icon: 'building-light',
      porte: DilettaStatusTagPorte.ampla,
    );
```

Uma **tela** do app, com o texto dela cravado, publicada na base white-label. Não é o Bold vazando pro pai —
é mais estreito que isso: é **uma tela de um produto** vazando. Ele e o `OnboardingProgressBar` são também os
dois únicos símbolos públicos do pacote que fogem do vocabulário da casa: inglês, sem prefixo, entre **97**
símbolos `Coreflow*` e **6** `Bold*` (`BoldColors`, `BoldPalette`, `BoldSeloQuantico`, `BoldSeloEstado`,
`BoldFonts`, `BoldVinho` — exatamente a identidade que o ADR manda pro filho).

**O que isso vale hoje:** pouco, e é por isso que está aqui e não numa PR — se o app o importa, apagar quebra
o app, e eu não tenho como medir isso desta sessão. O que ele faz é **mover uma amarra do ADR de lugar**: a
lista das cinco amarras não inclui "tela de produto empacotada na base", e agora inclui.

### 5 · Cinco `_ =>`, e os três novos estão todos no mesmo bloco

Os dois de 03/08 continuam lá, continuam certos, e continuam com a razão escrita em cima:

- `bold_background.dart:201` — classifica mood **por exclusão**; estilo novo cai no tratamento certo;
- `ds_do_bold.dart:3930` — devolve `MotionDaTransicao()` vazio **de propósito**: o motor lê como "não
  declarado", que é a verdade quando o pai cria uma transição nova.

Os **três novos** são o bloco `barraDeBaixo`, e são as três faces da mesma peça:

| linha | switch | o `_ =>` devolve |
|---|---|---|
| `ds_do_bold.dart:692` | `visibleProps` | `['variante']` — só o seletor, nenhuma prop |
| `ds_do_bold.dart:706` | `codegen` | `ds.DilettaBottomApp.button(...)` |
| `ds_do_bold.dart:799` | `build` | `DilettaBottomApp.button(...)` |

**Hoje eles não erram nada**, e conferi os três antes de escrever: as 5 opções de `_variantesDaBarra` estão
cobertas, `_ =>` é o ramo do `'button'` nos três, e render e codegen concordam opção por opção. O achado é a
exposição, e ela tem nome no próprio comentário do bloco: o `DilettaBottomApp` do pai tem **sete** factories
e este produto declara **cinco** — *"as duas de chat ficam fora por decisão do dono"*. No dia em que o Bold
ganhar chat, alguém acrescenta `'chat'` na lista e **as três caem no `button` em silêncio**: o inspetor
esconde as props, o preview desenha a peça errada e o codegen emite a peça errada.

E o gate que existiria pra isso passa: `o_emitido_compila` compila **cada opção de enum de cada bloco** — e
`button` compila. O gate mede sintaxe, não intenção; é o limite dele, e está escrito lá.

**O conserto é uma linha por switch, e o idioma já é deste arquivo**: nomear `'button'` explicitamente e
deixar `_ => throw ArgumentError(...)`, que é o que os outros **5** `_ =>` deste mesmo arquivo já fazem
(*"forma de divisor desconhecida"*, *"idioma de lista desconhecido"*, *"acessório esquerdo desconhecido"*).
Isso leva a checagem de **5 para 2** — os dois documentados —, e faz a variante nova falhar alto, num lugar
só, no dia em que ela entrar. É o critério que o pai escreveu na `v0.21.4` e é o que este arquivo já pratica
em três lugares; faltou nestes três.

### 8 · A régua de 03/08 pegou — os gates de pixel saíram de 3 pra 5

Foi o achado mais útil daquela rodada, e é o único que mudou de direção sozinho:

| | 03/08 | hoje |
|---|---|---|
| asserções de presença | 65 | **87** |
| **gates** que medem pixel | 3 | **5** |
| razão presença : gate de pixel | 21,7 : 1 | **17,4 : 1** |
| arquivos de teste no corpo | 40 | 82 |

A última linha é a ressalva: com o dobro de arquivos de teste, "87 asserções de presença" não é o mesmo
número que 65 era. O que **não** depende do corpo é a razão — 21,7 : 1 caiu pra 17,4 : 1 — e os dois gates
de pixel que nasceram.

E a contagem crua de "arquivos que leem pixel" daria **6**, não 5: o sexto é
`desenha_as_telas_de_loja.dart`, marcado `@Tags(['ferramenta'])`. Ele lê `toImage` pra **gerar** print, não
pra reprovar nada — somar ferramenta com gate inflaria justo a métrica que interessa. Os cinco gates:
`a_arte_deste_produto_segue_a_paleta`, `o_brilho_do_esqueleto_e_da_marca`, `o_card_de_conteudo_e_vidro`,
`o_escolhido_se_diz_de_um_jeito`, `o_fundo_do_frame_e_o_backdrop` — material, cor e movimento, que é
literalmente a regra que 03/08 escreveu:

> **Onde a pergunta é material, cor ou movimento, presença passa com o defeito.**

As 87 continuam certas: a maioria pergunta *"existe?"*, e presença é a resposta certa pra essa pergunta.
**Nada a fazer aqui** — fica registrado porque uma régua que muda o número um mês depois é a única prova de
que ela era régua e não frase.

### O ledger · 13 pedidos não estão no índice que existe pra achá-los

`docs/PEDIDOS.md` abre dizendo por que existe: *"este índice existe pra uma pergunta que não deveria custar
uma busca: o que ainda está aberto?"*

| | |
|---|---|
| arquivos em `docs/pedidos/` | **89** |
| linkados no ledger | **76** |
| **fora do ledger** | **13** — todos de 17/08 em diante |

Os 13 **têm veredito**, conferido arquivo por arquivo, então isto é bookkeeping e não pergunta perdida — com
uma exceção: `2026-08-18-a-folha-de-22` fechou em **ESPERA**, com condição de reabrir escrita, e é um item
aberto que não está no índice dos itens abertos.

E o ledger diagnosticou este defeito nele mesmo, antes de cometê-lo de novo:

> **o débito de ADOÇÃO se esconde no veredito que ninguém registrou.** (…) linha sem veredito é uma pergunta
> em aberto pro pai — e ela vira mentira no dia em que ele responde.

Da última vez o custo foi medido: o tom `pending` ficou **seis versões** disponível com esta tabela dizendo
que nada tinha voltado. O conserto é reconciliar 13 linhas — meia hora, e devolve a única pergunta que o
arquivo promete responder sem busca.

**O mesmo cheiro, dois arquivos adiante:** o resumo no fim do `PEDIDOS.md` diz *"40 pedidos, 39 com veredito"*,
recontado em 2026-08-06. São 89. E o `README.md:9` diz *"os 50 componentes (`Coreflow*`)"* — são **59**
widgets públicos, **97** símbolos `Coreflow*` no total. Nenhum dos dois é defeito de arquitetura; os dois são
números que envelheceram no lugar onde alguém de fora começa a ler.

## O que esta rodada NÃO mede

Além das três ausências do topo (ferramenta, Flutter, `app-newbold`), a seção 4 da ferramenta —
**aderência ao mercado** — é pergunta e não medição. As três de 03/08, com o que mudou desde então:

- **qual é a referência de prática de cada subsistema?** O que nasceu no intervalo foi o mecanismo de filho
  (`daMarca`, `bin/novo_filho.dart`, o exemplo conferido byte a byte). A referência de mercado disso tem nome
  — é o *white-label theming* de bibliotecas como Material 3 e Radix Themes: paleta de marca entra, papéis
  derivam. Vale a pergunta de se o `daMarca` está resolvendo algo que essas já resolvem, ou o pedaço que elas
  não resolvem (o kit de arte do produto, que é onde este DS gasta a maior parte);
- **o que a gente inventou que já tem nome lá fora?** A resposta de 03/08 continua: o vocabulário de blocos é
  nosso, o mais próximo é um construtor visual tipo FlutterFlow; a gramática de spec de tela veio do motor do
  pai; forma/brilho do esqueleto é Shimmer, adotado com o nome de mercado;
- **o que a gente copiou sem o contexto que fazia aquilo valer?** Sem caso medido nesta rodada.

E uma quarta, que esta rodada acrescenta porque o corpo de leitura mudou: **as designers usam o catálogo, e
nenhuma das dez checagens olha pra ele como produto.** Bloco que desenha certo e emite código errado é o furo
que o próprio `ds_do_bold.dart` chama de mais perigoso (*"nada falha"*), e o gate que existe — `o_emitido_compila` —
mede que o emitido **compila**, não que ele desenha a mesma coisa que o preview. Comparar as duas árvores por
bloco é medição que não existe aqui, e é a que eu abriria primeiro se alguém perguntasse qual gate falta.

## Como reproduzir os números

Sem Python e sem a ferramenta do pai — `grep`, `awk`, `find`, que é a régua do `levanta_a_separacao.sh`:

```sh
# 0 · o corpo
find packages/*/lib exemplos/*/lib -name '*.dart' | wc -l
find packages/*/lib exemplos/*/lib -name '*.dart' -exec cat {} + | wc -l

# 1 · maior arquivo de lib
find packages/*/lib exemplos/*/lib -name '*.dart' -exec wc -l {} + | sort -rn | head -5
grep -cE "^ +'[a-zA-Z]+': _[a-zA-Z0-9_]+\(\),$" packages/catalog/lib/ds_do_bold.dart   # 96 blocos

# 2 · nome de produto IRMÃO (o local fica de fora; comentário é citação, não conta)
grep -rhE '\b(CpfSeguro|cpf_seguro)' packages/*/lib exemplos/*/lib | grep -vcE '^\s*//'   # 0
grep -rnE  '\b(CpfSeguro|cpf_seguro)' packages/*/lib                                      # 1, num `//`

# 3 · cadeia de decisão por tipo
grep -rhoE '\bis [A-Z][A-Za-z0-9_]*' packages/*/lib | wc -l               # 3

# 5 · `_ =>` que degrada em silêncio, e o que falha alto
grep -rnE '(^|\s)_\s*=>' packages/*/lib | grep -v throw                   # 5
grep -rnE '(^|\s)_\s*=>' packages/*/lib | grep    throw                   # 5

# 6 · catch
grep -rnE 'catch\s*\(\s*_\s*\)' packages/*/lib                            # 0

# 8 · presença × pixel
grep -rhoE 'findsOneWidget|findsNWidgets|findsWidgets|findsAtLeastNWidgets' packages/*/test | wc -l   # 87
grep -rlE 'toImage|rawRgba|RepaintBoundary' packages/*/test                                           # 6 arquivos
#   … dos quais 1 é @Tags(['ferramenta']) e não é gate  →  5 gates

# o ADR · a régua da separação
bash packages/coreflow_design_system/tool/levanta_a_separacao.sh --total   # 300
ls packages/                                                              # `coreflow` não existe
find packages -name '*o_coreflow_nao_cita_bold*'                          # vazio

# o ledger
ls docs/pedidos/*.md | wc -l                                                          # 89
grep -oE 'pedidos/[A-Za-z0-9._-]+\.md' docs/PEDIDOS.md | sort -u | wc -l               # 76
comm -23 <(ls docs/pedidos/*.md | sed 's|docs/||' | sort) \
         <(grep -oE 'pedidos/[A-Za-z0-9._-]+\.md' docs/PEDIDOS.md | sort -u)           # os 13
```

## O que eu levaria adiante, em ordem

Nenhum destes foi feito nesta rodada — auditoria mede, e as duas decisões do meio têm dono declarado que
não sou eu.

| | o que | custo | quem decide |
|---|---|---|---|
| 1 | os três `_ =>` do `barraDeBaixo` viram `_ => throw`, no idioma que o arquivo já usa | 3 linhas | quem mantém o plugue |
| 2 | o ADR de 04/09 ganha veredito — sim, não, ou depois | uma leitura | o dono do DS |
| 3 | reconciliar as 13 linhas do `PEDIDOS.md`, e o ESPERA da folha de 22 volta pro índice | meia hora | quem sobe a próxima tag |
| 4 | os três números que envelheceram: 56 blocos → 96 (`ds_do_bold.dart:10`), 40 pedidos → 89 (`PEDIDOS.md`), 50 componentes → 59 (`README.md:9`) | 3 linhas | idem |
| 5 | o corte do `ds_do_bold.dart` por grupo — **de novo proposto, e mais caro que em 03/08** | ~5 arquivos, histórico partido | quem vai manter |
| 6 | o gate que falta: preview × codegen por bloco, e não só "o emitido compila" | um teste | quem mantém o plugue |
