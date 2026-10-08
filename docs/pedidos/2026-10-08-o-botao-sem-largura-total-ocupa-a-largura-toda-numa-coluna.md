# PEDIDO · o botão sem largura total ocupa a largura toda numa coluna — `fullWidth: false` só encolhe dentro de `Row`

- **de**: conta-bold-ds (filho B) · **para**: ds-diletta
- **consome**: ds-diletta `v3.3.1` (`5a0acb7`), pelo pino do `packages/coreflow/pubspec.yaml:23`. O app
  vendoriza `bold-ds v0.122.1` com esse mesmo avô em `origin/development` e `origin/release/homologation`.
  **Medido também na ponta, `v3.9.0` (`171037d`)**: o `diletta_button.dart` mudou entre as duas tags
  (os portes passaram a vir da paleta, `portesDeBotao`), e **o arranjo que causa o defeito é o mesmo**
  nas duas: `alignment: Alignment.center` no contêiner da caixa
- **bloqueante?**: **não** — o botão funciona; ele só não tem o tamanho que o parâmetro promete
- **é DEFEITO, não variante**: não pede tamanho, tom nem eixo novo. Pede que `fullWidth: false` faça o
  que o nome diz em qualquer pai, e não só dentro de `Row`
- **achado por**: o chat da câmera do app (Terminator), ao montar os atalhos da câmera em hug, como o
  desenho aprovado de 07/10 pede; o mesmo contorno já existia na tela de parear aparelho

## Falta

`DilettaButton(fullWidth: false)` com a largura do próprio conteúdo (rótulo + recuo + glifos) quando o
pai oferece largura **frouxa** — `Column`, `Center`, `Wrap`, `Align`. Hoje ele só abraça o conteúdo
quando o pai dá largura infinita (`Row`).

## Número

**A causa**, na `v3.9.0` (as mesmas linhas na `v3.3.1` são `:246`, `:264`, `:276`, `:305-330`):

| | o que tem | linha |
|---|---|---|
| a caixa das variantes sólidas | `AnimatedContainer(…, alignment: Alignment.center, child: content)` | `diletta_button.dart:306-331` |
| as caixas do gradiente | `Container(…, alignment: Alignment.center, …)` no preenchimento em gradiente e no contorno em gradiente | `:247`, `:265`, `:277` |
| o que `fullWidth: true` acrescenta | `SizedBox(width: double.infinity)` por fora | `:281`, `:335-336` |
| o miolo | `Row(mainAxisSize: MainAxisSize.min)` com o rótulo em `Flexible` | `:187`, `:202` |

`Container` com `alignment` e sem largura **ocupa a largura máxima que recebe** (é o `Align` por dentro,
sem `widthFactor`). Então o `mainAxisSize.min` do miolo não chega à caixa: quem decide a largura é o
pai, e `fullWidth: false` não muda nada fora de uma `Row`.

**Medido com teste de widget** no pacote do filho, contra o pino `v3.3.1`, numa coluna de 390 sob o tema
claro do Bold, rótulo «Ok»:

| cena | largura |
|---|---|
| `DilettaButton(fullWidth: false)` numa `Column` | **390** |
| `DilettaButton(fullWidth: true)` na mesma `Column` | **390** |
| `DilettaButton(fullWidth: false)` dentro de uma `Row(mainAxisSize: min)` | **60,2** |
| `IntrinsicWidth(child: …)` em volta, na `Column` | **60,2** |

Ou seja: numa coluna, `true` e `false` dão **o mesmo botão**.

**Quanto isso alcança no app** (`app-newbold`, branch `feat/terminator-scan-aprovacao-legivel`,
`7dd677d4`). O Coreflow repassa `expand` como `fullWidth` sem mexer (`coreflow_botao.dart:157`, e o
`///` dele promete *«false = inline»*, `:96`). No app:

| | quantos |
|---|---|
| `expand: false` | **34** usos em **25** arquivos |
| embrulhados em `IntrinsicWidth` pra encolher | **5**: `unified_scanner_screen.dart:387`, `:1576`, `:1691`; `parear_dispositivo_screen.dart:990`, `:1321` — todos dentro de `Column` |

O comentário do app em `parear_dispositivo_screen.dart:987-989` já tinha chegado à mesma causa: *«o
container do `DilettaButton` tem `alignment: Alignment.center`, e container alinhado preenche a restrição
que recebe»*. Os outros 29 usos estão em `Row` ou em pai que estica de qualquer jeito; **não medimos um a
um** quais deles hoje saem largos sem querer.

**Neste repo** (`bold-ds`): zero `IntrinsicWidth` em volta de botão no pai e no filho.

## Já tentei

- **`IntrinsicWidth` por fora** — é o que o app faz, e funciona (tabela acima). O custo é uma passada de
  layout a mais em cada botão, e a regra *«para encolher, embrulhe»* não está escrita em lugar nenhum:
  quem não leu o comentário da tela de parear põe `expand: false` e recebe um botão largo.
- **`Center` ou `Align` por fora** — não resolve: os dois repassam largura frouxa, e o contêiner alinhado
  da peça ocupa a máxima de novo.
- **`Row` por fora** — resolve, e é um `Row` de um filho só para fazer o parâmetro funcionar.

## Conferi no pai

- A spec `specs/design-system-button/spec.md` (`v3.9.0`) não fala de largura: zero ocorrências de
  `fullWidth`, `largura`, `encolh`. O contrato do parâmetro está só no `///` e no exemplo
  (`diletta_button.dart:61`).
- Ledger (`docs/PEDIDOS.md` de `origin/main`): nenhuma linha sobre largura do botão. O pedido de 13/08
  sobre as abas que **abraçam o rótulo** (`DilettaTabs.largura`) é o vizinho mais próximo, e entrou.
  Nenhum «não» anterior a reler.

## Derivável?

**Não do lado de cá.** O contêiner que estica mora dentro da peça.

## Se você disser não

Os cinco `IntrinsicWidth` ficam, com o comentário apontando para este pedido, e o `///` do
`CoreflowBotao` passa a dizer que `expand: false` só encolhe dentro de `Row`. Isso é nosso e se faz no
mesmo dia.

## Não estou pedindo

- a forma do conserto: `widthFactor`, alinhar só quando `fullWidth`, ou outra — é sua;
- mudança no botão de largura total nem no conteúdo centrado quando a largura vem justa (coluna
  `stretch`): ali o rótulo continua no meio, como hoje;
- mudança na web: não medimos o `<diletta-button>`.

## Como o pai vai saber que funcionou

Um teste de widget com a mesma tabela do Número:

1. `fullWidth: false` numa `Column` de 390 mede a largura do conteúdo, igual à da `Row`;
2. `fullWidth: true` na mesma coluna continua 390;
3. numa coluna `crossAxisAlignment: stretch`, `fullWidth: false` mede 390 e o rótulo fica centrado.

Do lado de cá, quando a tag sair: subimos o `ref:`, vendorizamos, e o app tira os cinco `IntrinsicWidth`.

## Como cheguei aqui

O chat da câmera do app abriu o assunto em 06/10 e o passou ao entregador em 08/10. Tudo acima foi
medido no código das duas tags do avô (`v3.3.1` e `v3.9.0`), no pai deste repo (`1e380de`) e no app
(`7dd677d4`); as larguras, com teste de widget descartável rodado no pacote do filho contra o pino
`v3.3.1`.

## VEREDITO · ENTRA, defeito meu — o botão abraça o conteúdo em qualquer pai
**pai**: ds-diletta **v3.10.0** · **data**: 2026-10-08

### O que decidiu

A sua tabela: numa coluna, `true` e `false` davam o mesmo botão. As quatro caixas (sólida e as de degradê) perderam o `alignment: center` e passam por um `Center(widthFactor: 1)`: com largura frouxa abraça, com largura justa centraliza.

### O que eu achei indo implementar

nada. Não há golden de botão, então nenhum retrato mudou.

### O que eu recusei, e a condição de reabrir

nada recusado.

### Os sete critérios

| critério | | |
|---|:-:|---|
| manutenção | ↑ | o contorno do `IntrinsicWidth` deixa de existir |
| escalabilidade | ↑ | vale pra todo pai frouxo, em todo filho |
| aplicação | ↑ | os cinco `IntrinsicWidth` do app saem; adota o app do filho B |
| aderência ao mercado | ↑ | é o que `hug` quer dizer no Figma e no M3 |
| robustez | ↑ | gate com a sua tabela: coluna, linha, esticada e degradê |
| arquitetura limpa e simples | ↑ | uma caixa a menos de responsabilidade: quem decide a largura é `fullWidth` |
| conciso | ⊘ | sem texto novo além do `///` da prop |

### O que você faz

`ref: v3.10.0`, e tire os cinco `IntrinsicWidth` de `unified_scanner_screen.dart` e `parear_dispositivo_screen.dart`. Os 29 outros `expand: false` podem encolher onde antes saíam largos: vale olhar as telas.
