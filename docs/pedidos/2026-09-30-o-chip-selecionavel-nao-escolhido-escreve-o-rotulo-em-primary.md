# PEDIDO · o chip selecionável NÃO escolhido escreve o rótulo em `primary` — 3,13:1 no claro, e o nosso pedido de 11/08 dizia `fg`

- **de**: conta-bold-ds (filho B) · **para**: ds-diletta
- **consome**: ds-diletta `v2.5.0` (`b44f89a`), pelo pino do `packages/coreflow/pubspec.yaml:23`, e é o
  que o app tem vendorizado (`bold-ds v0.120.0`, recibo `packages/ds_vendor.json` do `app-newbold`).
  **Medido também na ponta, `v3.3.1` (`5a0acb7`)**: o `diletta_input_chip.dart` é o mesmo byte a byte
  entre as duas tags (`git diff v2.5.0 v3.3.1 -- <arquivo>` vazio), então as linhas abaixo valem nas duas
- **bloqueante?**: **não** — a tela funciona; o rótulo não escolhido está abaixo do piso de texto
- **é DEFEITO, não variante**: não pede tom novo, eixo novo nem aparência nova. Pede que o repouso da
  variante que já existe leia um papel de TEXTO, que é a sua própria regra de 19/08 (abaixo)
- **não é o pedido neutro de 29/09**, e digo por quê antes de tudo: [o chip selecionável não tem aparência
  neutra](2026-09-29-o-chip-selecionavel-nao-tem-aparencia-neutra.md) pedia uma SEGUNDA aparência, em que
  a escolhida deixa de inverter. O seu veredito foi **NASCE NO FILHO**, com a condição *«reabre no segundo
  filho com pílula neutra medida»*. **Este não reabre aquele**: a escolhida continua invertendo em
  `primary`, exatamente como o nosso item 1 de «Não estou pedindo» daquele pedido prometia. Muda só a
  tinta e o fundo de quem NÃO está escolhido
- **não é peça nova**: é o `DilettaInputChip.selecionavel` (`v0.67.0`), e a casca de uma linha do pai
  (`packages/coreflow/lib/src/coreflow_chip_de_filtro.dart`)

## Falta

No `.selecionavel` **não escolhido**: rótulo (e glifo) na tinta de **texto** (`fg`) em vez de `primary`,
sobre um fundo de superfície em vez de transparente, com a borda `border` de hoje.

**Escolhido: sem mudança** (`primary` + `onPrimary`, 600). **Geometria: sem mudança** (pílula 26, alvo
44 fora do desenho, `labelSm`, respiro `s2`).

## Número

O que a peça pinta hoje, na `v3.3.1` e na `v2.5.0` (`packages/diletta_design_system/lib/src/widgets/diletta_input_chip.dart`):

| | o que a peça faz | linha |
|---|---|---|
| tinta do não escolhido | `s.primary` (a mesma `tinta` pinta rótulo, `leadIcon` e `trailIcon`) | `:184-188` |
| fundo do não escolhido | `DilettaAbsoluteColors.transparent` | `:203` |
| borda do não escolhido | `s.border` | `:205-211` |
| peso | 400 → 600 com a escolha | `:234` |

Contraste medido com o `DilettaScheme.light/dark(BoldPalette.bold)` da `v2.5.0` (a fórmula do gate
`o_piso_de_contraste_vale_nos_dois_modos_test.dart` deste repo; alpha composto sobre o fundo). O rótulo
é `labelSm`: **11 px**, peso 400 no não escolhido (`diletta_type_tokens.g.dart:22`) — não é texto
grande, o piso da 1.4.3 é **4,5**:

| par | claro | escuro |
|---|---:|---:|
| **hoje**: `primary` sobre `bg` (o fundo é transparente, então é a página que fica atrás) | **3,13** ✕ | 7,20 |
| **hoje**: `primary` sobre `surface` (se a página for cartão) | **3,46** ✕ | 6,66 |
| pedido, opção A: `fg` sobre `surface` | 11,40 | 18,15 |
| pedido, opção B: `fg` sobre `primarySubtle` | 10,13 | 8,03 |
| escolhido (não muda): `onPrimary` sobre `primary` | 3,46 | 7,70 |

Cores: claro `primary #fe3976` · `fg #3d3939` · `surface #ffffff` · `bg #f4f3f6` · `primarySubtle #ffedf3`
· `border #00000012`; escuro `primary #f66fa0` · `fg #ffffff` · `surface #14151f` · `bg #0a0b12` ·
`primarySubtle #9e1241` · `border #ffffff14`.

**No app são 13 arquivos** com `CoreflowChipDeFiltro(`, todos por esta variante. O que a designer viu
no aparelho: Pix › Cobrar › Pix Automático, periodicidade com **cinco** chips numa fila
(`lib/features/pix/presentation/screens/pix_cobrar_automatico_flow.dart:437`, na branch
`feat/cobrar-com-pix-automatico`). Quatro rosas não escolhidos ao lado de um rosa cheio: o rótulo lê
mal e briga com a escolha, que é a única coisa que a fila tem para dizer.

## A contradição, que vale mais que o pedido

**1 · O nosso pedido de 11/08 pediu `fg`, e a variante nasceu em `primary`.** A tabela daquele pedido
([a família de chips não tem o selecionável](2026-08-11-a-familia-de-chips-nao-tem-o-selecionavel.md),
linha 16) dizia *«transparente + borda neutra + **tinta forte**»*, e a peça que ele descrevia — o
`BoldChipDeFiltro` da `ds v0.36.0` (`c0334be`, `bold_chip_de_filtro.dart:78`) — pintava
`color: escolhido ? s.onPrimary : s.fg`. A `v0.67.0` (`ba4e60b`, `diletta_input_chip.dart:90`) nasceu com
`escolhido ? s.onPrimary : s.primary`: herdou a tinta do chip-base, e nem o pedido nem o veredito
discutiram isso. A culpa da palavra é nossa: «tinta forte» não é nome de papel. O código que ela
descrevia era.

**2 · A frase «os dois pares passam AA» é nossa, e no Bold claro é falsa.** Nós a escrevemos em 11/08 e
ela está no `///` da variante (`:95`). O par não escolhido mede **3,13**. O escolhido mede 3,46, e esse
já é exceção declarada por nós: `tintasAssumidas` em `bold_palette.dart:514-521` (o branco sobre o rosa
é o CTA do produto, decisão do dono em 19/08). **O não escolhido não tem exceção nenhuma**, e não
deveria ter.

**3 · Pela sua régua de 19/08, este é o décimo sítio.** O veredito de
[o `primary` como TINTA não tem piso](2026-08-18-o-primary-como-TINTA-nao-tem-piso.md) (`v0.115.0`)
trocou de papel **nove** leituras de `s.primary` em posição de texto e disse: *«não é quem escreve tela
errou, é de qual papel a peça pega»*. O rótulo do chip escapou daquela varredura. A sua recusa do gate
dizia *«reabre se o décimo sítio NASCER errado»*; este não nasceu depois, nasceu antes (`v0.67.0`,
11/08) e passou pela varredura sem ser visto. Não conto isso como a condição do gate. Conto como
defeito de peça.

## Já tentei

1. **A casca do pai não alcança.** O `CoreflowChipDeFiltro` é uma linha sobre `.selecionavel`, sem
   parâmetro de tinta nem de fundo: a cor não entra de fora;
2. **o app já contornou uma vez, à mão.** `ChipContornado`
   (`lib/features/trazer_saldo/presentation/widgets/chip_contornado.dart`, Wesley, 29/09, dois usos em
   Cobranças emitidas) existe, diz o `///` dele, porque o `.selecionavel` tem *«o texto sempre na cor
   `primary` mesmo sem seleção — não dá pra pedir contorno cinza + texto cinza no estado não escolhido
   de fora do widget»*. Pinta `surface` + `textSecondary` + `border` no não escolhido. É o mesmo pedido,
   feito como peça local;
3. **a prova no aparelho.** A designer aprovou em 30/09, vendo no iPhone, a receita abaixo (opção A),
   aplicada numa cópia local da casca só para ver (não commitada, e a cópia volta ao original).

### Receita testada (opção A: `surface` + `fg`)

```dart
final s = DilettaTheme.schemeOf(context);
final tinta = escolhido ? s.onPrimary : s.fg;
// ...
decoration: BoxDecoration(
  color: escolhido ? s.primary : s.surface,
  border: Border.all(color: escolhido ? s.primary : s.border, width: 1),
  borderRadius: DilettaRadius.pillAll,
),
// Text: DilettaType.labelSm, color: tinta,
//       fontWeight: escolhido ? FontWeight.w600 : FontWeight.w400
// pílula 26, alvo 44 fora do desenho — iguais aos da peça
```

Na peça, isso são duas trocas: `:188` (`s.primary` → `s.fg`) e `:203`
(`DilettaAbsoluteColors.transparent` → `s.surface`, ou `s.primarySubtle`).

## Conferi no pai

- **o piso de texto passa nos dois modos nas duas opções** (tabela acima): A com 11,40 / 18,15, B com
  10,13 / 8,03;
- **A ou B é seu, e eu digo o que medi para ajudar a decidir.** A designer pediu *«a que der o melhor
  contraste em cada modo»* e aprovou A no aparelho. O rótulo favorece A nos dois modos. A pílula contra a
  página: `surface` sobre `bg` dá 1,11 (claro) e 1,08 (escuro), quase só a borda a separa; `primarySubtle`
  sobre `bg` dá 1,02 no claro (some) e **2,45 no escuro**, porque o `primarySubtle` do escuro é o vinho
  `#9e1241`: quatro pílulas vinho ao lado da escolhida em rosa, que é a briga que este pedido quer tirar.
  **Não medi a opção B no aparelho**;
- **a borda fica `border`, e é a sua frase de 29/09**: o `contornoDeControle` da `v3.3.0` saiu dizendo
  que *«o `border` não muda: ele continua certo para card, campo e chip»*. A borda mede 1,06 (claro) e
  1,33 (escuro) contra `bg`; quem identifica a pílula é o rótulo, como no pedido neutro de 29/09;
- **cor não é o único canal** (1.4.1): 400 → 600 continua. Com o não escolhido em `fg`, a diferença
  entre os dois estados passa a ser fundo cheio + tinta invertida + peso, e não rosa-claro × rosa-cheio;
- **a spec muda junto**: `specs/design-system-input-chip/spec.md` declara em `papeis` `border`,
  `borderSubtle`, `onPrimary`, `primary`, `primarySubtle`, `surface`, `surfaceMuted`, `surfaceSubtle`,
  `textDisabled` — **sem `fg`**. O `o_dart_obedece_a_spec` vai cobrar. E o gerado
  `test/resolucao/design-system-input-chip.json` (status `normal`, `color: ["primary"]`) regrava;
- **a web tem o mesmo repouso**: `diletta-input-chip.js` da `web-v3.3.1` (`692ff8a`) põe
  `background: transparent` no escolhível (`:155`) e deixa a cor do rótulo com a pintura, que dá
  `primary`; o `ESCOLHIDO` (`:45`) não muda. No Bold web o `primary` do claro é sobrescrito por
  `#9e1241` (`bold-tokens.css`, bloco do produto), então lá o número não reprova; **o desenho** é o mesmo
  rosa-sobre-transparente. Se a regra entrar, peço que entre nas duas pontas para a spec continuar uma só;
- **achado de passagem, na mesma peça**: o `DilettaDevInfo` declara `'border primary-04'` e
  `'bg: white'` (`:271-272`) também para o `.selecionavel`, que pinta borda `border` e fundo
  transparente. O inspetor mente sobre esta variante hoje.

## Derivável?

Sim, inteiro. `fg`, `surface`, `primarySubtle` e `border` já existem nos dois modos de todo filho;
nenhum número novo, nenhum papel novo, nenhum campo novo no produto.

## Se você disser não

1. **se o não vier como «o acento de marca no repouso é desenho»**: então o seu caminho de 19/08 é o
   `primaryOnSurface`, e ele passa — **7,26** sobre `bg` e 8,03 sobre `surface` no claro (`#9e1241`),
   8,70 / 8,04 no escuro (`#ff87ab`). Resolve o piso, **não resolve a queixa da designer**, que é ter
   quatro rosas brigando com um. A pergunta volta para ela com essa medida;
2. **se o não vier como «é variante, sobe no segundo filho»** (a regra 3 dos dois vereditos de 29/09):
   discordo pelo item 3 da contradição, mas acato. A receita testada vira peça do nosso pai
   (`packages/coreflow`), a casca deixa de ser de uma linha, e o `ChipContornado` do app passa a ter um
   endereço para consumir.

## Não estou pedindo

1. que o escolhido mude: a inversão em `primary` continua, e o 3,46 dele segue como exceção nossa
   declarada;
2. a aparência neutra de 29/09 (a escolhida por contorno): a condição de reabrir aquela continua de pé;
3. que o chip-base (sem `.selecionavel`) mude. A mesma `tinta` da `:188` pinta o rótulo dele em
   `primary` sobre `surface` (3,46 no claro) — é o mesmo desenho do Figma `Input chips` que ele
   declara. Não medi uso dele no app e não o incluo; se a troca da `:188` alcançá-lo sem querer, é
   isso que o gate precisa separar;
4. gate que proíba `color: s.primary` em texto: a sua recusa de 19/08 fica.

## Como o pai vai saber que funcionou

```
DilettaInputChip.selecionavel(label: 'Mensal', selecionado: false), em claro e escuro,
  com a paleta de referência e com a do Bold:
espera: Text.style.color == s.fg · peso 400
        BoxDecoration.color == s.surface   (ou s.primarySubtle, o que você escolher)
        Border.color == s.border
        contraste(tinta, fundo) >= 4,5 nos dois modos e nas duas paletas
DilettaInputChip.selecionavel(..., selecionado: true):
        igual a hoje — s.primary / s.onPrimary / 600
e a pílula continua 26 dentro de uma caixa de 44
```

Do nosso lado: o `CoreflowChipDeFiltro` não muda uma linha; sobe o pino, e os 13 arquivos do app
mudam no repouso sem tocar tela.

## Como cheguei aqui

A designer, no chat do Pix Automático do app (`claude_newbold-cobrar-pix-automatico`,
`feat/cobrar-com-pix-automatico`, 30/09), olhando a tela no iPhone; ela aprovou a opção A no aparelho.
Re-medi na tag do pino e na ponta, rodei as cores do scheme dos dois modos num teste descartável sobre
o `BoldPalette.bold`, e li antes de escrever o nosso pedido de 11/08, os dois de 29/09 com os
vereditos, e o de 18/08 do `primary` como tinta.

## VEREDITO · ENTRA — o não escolhido escreve em `fg` sobre `surface`, e o repouso da variante vira o do chip-base
**pai**: ds-diletta **v3.7.0** · **data**: 2026-10-01

### O que decidiu
A sua frase: *«o `BoldChipDeFiltro` [...] pintava `color: escolhido ? s.onPrimary : s.fg`»*. A variante nasceu
do seu pedido de 11/08 e herdou a tinta do chip-base sem ninguém decidir. É defeito, não variante: não espera
segundo filho. Medi na `v3.7.0`: `diletta_input_chip.dart:188` (`s.primary`) e `:203` (`transparent`), iguais
aos seus. O `primary #fe3976` sobre `bg #f4f3f6` dá **3,13**, 11 px a 400. Reproduzi o número.

Opção **A**. Ela não acrescenta caso: o `.selecionavel` em repouso passa a pintar o fundo do chip-base
(`s.surface`, `:204`), e o ramo `_selecionavel ? transparent` sai. A B pinta vinho no escuro (2,45 contra
`bg`), que é a briga que o pedido quer tirar. Nas duas pontas: o `diletta-input-chip.js:155` troca
`transparent` por `surface` e ganha `color: fg`. A spec ganha `fg` em `papeis` e a resolução regrava.

### O que eu achei indo implementar
- **o chip-base tem o mesmo defeito, e você o deixou de fora com razão.** A mesma `tinta` da `:188` pinta o
  rótulo do chip-base em `primary` sobre `surface`: **3,46** na sua paleta clara. Ele não vai para `fg`, porque
  o desenho do Figma `Input chips` é rosa. Vai para `primaryOnSurface`, que é a regra de 18/08 para texto e
  preserva o desenho. É o décimo sítio daquela varredura, e entra no mesmo lote;
- **o `///` da `:95` diz «os dois pares passam AA»**, e é falso na sua paleta. A frase sai;
- **o `DilettaDevInfo` (`:271-272`) mente** sobre esta variante. Passa a ler os papéis do build.

### O que eu recusei, e a condição de reabrir
- a opção B (`primarySubtle`): reabre se um filho medir a pílula sumindo sobre `surface`, com a tela nomeada.

### Os sete critérios
| critério | | |
|---|:-:|---|
| manutenção | ↑ | um ramo de fundo a menos; repouso igual ao do chip-base |
| escalabilidade | ↑ | `fg` passa o piso em qualquer paleta; `primary` depende da marca |
| aplicação | ↑ | 13 arquivos do app mudam sem tocar tela; o `ChipContornado` fica sem razão de existir |
| aderência ao mercado | ↑ | o filter chip do M3 escreve o não escolhido em tom neutro e marca a escolha pelo fundo |
| robustez | ↑ | teste de contraste ≥ 4,5 nos dois modos, na referência e numa paleta de `primary` claro |
| arquitetura limpa e simples | ↑ | sai um caso especial, nenhum papel novo |
| conciso | = | uma frase falsa do `///` sai, nenhuma entra |

### O que você faz
`ref:` a próxima minor do pai. Do seu lado: subir o pino, a casca não muda. Apagar o `ChipContornado` e
trocar os dois usos dele pelo `CoreflowChipDeFiltro`. Eles pintam `textSecondary` e a peça vai pintar `fg`:
se a designer quiser o secundário, é outro pedido, com o número dele.
