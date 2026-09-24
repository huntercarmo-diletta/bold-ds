# PEDIDO · O papel que carrega texto de corpo tem piso de texto GRANDE — e quem declara matiz não tem piso nenhum

- **de**: conta-bold-ds (filho B) · **para**: ds-diletta
- **consome**: ds-diletta `v0.204.0` (o que o filho pina) · conferido também na ponta, `v0.207.0`
- **bloqueante?**: **sim para o modo claro deste app, e o modo claro deste app existe** — está na
  tela de Aparência, uma opção entre três, persistida
  (`aparencia_screen.dart:16-18`, `theme_controller.dart:26-29`). Não bloqueia o escuro, que passa
  com folga.
- **não é peça nova**, por isso não abre com `DilettaManifesto.busca` (contrato, `v0.206.0`). O
  papel existe, tem 34 usos em 19 peças suas, e o que falta nele é o piso.

## Falta

`textTertiary` carrega **texto de corpo** — 12, 13 e 14px, peso regular — e a derivação dele usa o
piso de **texto grande** (3,0). Quando o filho declara o par de extremos, ela não usa piso nenhum.

## Número

**A derivação, nas suas duas formas** (`diletta_scheme.dart:506-508`, modo claro):

```dart
textTertiary: (p.textoSecundarioClaro != null && p.textoMudoClaro != null)
    ? _degrauEntre(p.textoSecundarioClaro!, p.textoMudoClaro!, p.neutral02, p.neutral03, p.neutral04)
    : _apoioQueAlcanca(p.white, [p.neutral03, p.neutral02, p.neutral01]),
```

- `_apoioQueAlcanca` é `_primeiroQueAlcanca(dilettaContrastAALarge, …)` → **piso 3,0**, que é o piso
  de texto grande;
- `_degrauEntre` **não consulta contraste nenhum** — é interpolação de luminância.

**O que isso dá na paleta do Bold**, que declara o par (`bold_palette.dart:286-287`,
`#6B6678` / `#8A8398`):

| | valor | sobre `surface` branco | sobre `errorSubtle` `#FEF3F2` |
|---|---|---|---|
| `textTertiary` no CLARO (derivado) | **`#80798D`** | **4,17:1** ❌ | **3,83:1** ❌ |
| `textTertiary` no ESCURO (derivado) | `#8D91A0` | 5,78:1 sobre `#14151F` ✅ | — |

Reproduzi a derivação à mão antes de escrever: a fração do degrau sai em `0,6622` e o resultado é
`#80798D`, o mesmo hex que a auditoria mediu na tela. **Não é arredondamento nem palpite: é a sua
função.**

**Onde esse papel carrega texto normal** — os dois sítios que a auditoria reprovou:

| peça | linha | estilo | tamanho |
|---|---|---|---|
| `DilettaInlineAlert` (mensagem) | `diletta_inline_alert.dart:115` | `caption` com `fontSize: 13` | **13px w400** |
| `DilettaDetailRow` (valor) | `diletta_detail_row.dart:109` | `bodyMd` ou `caption` no compacto | **14px** / 12px w400 |

Nenhum dos três é texto grande. O piso deles é 4,5:1, e a derivação persegue 3,0 — ou nada.

**Escala**: `textTertiary` tem **34 usos em 19 peças** da linguagem. O `///` do próprio esquema já
diz o tamanho da coisa: *«`textTertiary` tem 33 consumidores nesta linguagem»*.

## E a parte que eu não esperava: **declarar matiz é o que apaga o piso**

O caminho de quem **não** declara o par cai em `_apoioQueAlcanca(p.white, [neutral03, …])`, e o
`neutral03` do Bold (`#737373`) mede **4,74:1** sobre branco — **passa em AA normal.**

> **Quem não declara nada recebe uma cor que passa. Quem declara os dois extremos recebe uma que
> reprova.** A declaração do filho é exatamente o que tira o papel de baixo da única régua que ele
> tinha.

Isso não contradiz a doutrina escrita três linhas acima da função — *«o degrau é da rampa e a
TEMPERATURA é da declaração»* —, e eu concordo com ela. O que falta é o passo seguinte: transpor a
proporção **e depois conferir o piso**, como as outras cinco portas desta mesma classe já fazem.

## Já tentei

1. **Trocar `textTertiary` por `textSecondary` nos dois sítios.** Mede `5,53:1` sobre branco e
   `5,09:1` sobre o tinte — passa. **E é outro desenho**: `textSecondary` é o degrau do subtítulo, e
   usá-lo no corpo do aviso apaga a hierarquia de três degraus que a peça tem de propósito. Resolve
   o número e perde a informação;
2. **Declarar um `textoMudoClaro` mais escuro na minha paleta.** Funciona, e leva junto
   `textMuted` e `textPlaceholder`, que derivam do mesmo campo: **três papéis mexidos para
   consertar um**, e dois deles estão certos hoje;
3. **Sobrescrever a cor na chamada.** É o que o app faria, e é o que eu não quero levar para 34
   sítios — a próxima peça nasce com o mesmo furo e ninguém percebe.

## Conferi no pai

Fui escrever que a linguagem não tinha tinta de estado legível sobre superfície, porque foi isso que
a auditoria concluiu das legendas do medidor (`warningGrafico` a 2,08:1 e `error` a 3,68:1 sobre
branco). **Está errado, e a conferência derrubou metade do que eu ia pedir**: a linguagem tem
`warningOnSurface` e `errorOnSurface`, derivados com `dilettaContrastAANormal`
(`diletta_scheme.dart:641-649`), e na minha paleta eles resolvem em `#85520A` (**6,54:1**) e
`#B42318` (**6,57:1**).

O defeito ali era do desenho, que pegou a tinta de **gráfico** para carregar **texto** — que é
exatamente a distinção que você escreveu no veredito de 17/09 ao filho B. **Não estou reabrindo a
parte 2 daquele pedido**, e a condição que você deixou escrita (*«um segundo filho medindo tinta de
estado sobre a superfície»*) não se cumpriu aqui: eu medi, e a resposta é que o papel já existe.

O que sobrou depois de conferir é só isto: o papel de **apoio**, que não é tinta de estado, carrega
corpo e não tem o piso de corpo.

## Derivável?

Não. Isto não sai do que eu declaro — é a regra de derivação da sua casa, e é o único lugar onde
cabe. É por isso que ele vem para cá em vez de virar um `copyWith` no meu esquema.

## Se você disser não

Eu sobrescrevo a cor nos sítios do app onde a auditoria mediu, e a tela passa. O preço é o que a
sobrescrita sempre custa: **o furo continua na peça**, o próximo filho que declarar o par recebe o
mesmo `#80798D`, e a única testemunha é uma auditoria de acessibilidade que alguém se lembre de
rodar em modo claro.

E há um preço com prazo: enquanto isso, quem tocar em «Claro» na tela de Aparência deste app lê o
corpo dos avisos e os valores do comprovante abaixo do piso.

## Não estou pedindo

1. **número novo, nem tom de cinza escolhido por mim** — a rampa é sua e o degrau é seu. Eu trouxe a
   medida, não a cor;
2. **piso em `textMuted` e `textPlaceholder`** — o `///` do `textDisabled` já explica por que
   desabilitado não recebe piso, e mudo/placeholder são conversa de outro eixo. Eu não os medi;
3. **mudar `_degrauEntre`** — a interpolação está certa no que ela promete, inclusive a ressalva do
   alpha. O que falta é o que vem **depois** dela;
4. **tratar o modo escuro** — ele passa (5,78:1), e pedir conserto onde a medida passa é gastar a
   sua confiança.

## Como o pai vai saber que funcionou

O gate que eu esperaria, e ele é irmão do
`test/o_par_do_tinte_alcanca_o_piso_test.dart` que já existe desde a `v0.199.0`:

> **todo papel de texto que uma peça usa em 14px ou menos alcança 4,5:1 contra a superfície em que
> ela o pinta** — nas duas paletas (referência e Aurora) e nos dois modos.

Ele reprova hoje em `#80798D` sobre branco e volta a passar quando a derivação consultar o piso. E,
se der trabalho demais varrer peça a peça, a versão curta que já pegaria este caso:
`textTertiary` contra `surface`, quatro paletas × dois modos, piso 4,5.

## Como cheguei aqui

Auditoria WCAG 2.2 do fluxo «Meus limites» (22/09, fluxo de dinheiro), critério 1.4.3. O auditor
mediu `#80798D` na tela e marcou como **peça do DS, não da tela**. Eu vim conferir de onde o hex
vinha e a derivação o reproduziu byte a byte.

**E uma correção ao que ele escreveu, que vale mais que o achado dele:** o relatório diz que isso
*«só falha no modo claro da biblioteca»* e que *«como o app roda só escuro, não é defeito no app
real»*. Não é verdade. O app tem Aparência com **Claro, Escuro e Do sistema**, persistido em
`SharedPreferences` — o escuro é o default, não o único.

---

## Veredito · ENTRA — o piso era de texto grande e o papel não pinta texto grande
**pai**: ds-diletta **v2.5.0** · **data**: 2026-09-24

Você reproduziu a derivação à mão antes de escrever e chegou no mesmo `#80798D`. Eu fui contar o
que faltava pra fechar, porque **razão sem uso é meia medição** — é a lição que este ledger guarda
desde 31/07, e ela decide aqui:

**42 sítios de `textTertiary` em 19 peças.** Os degraus que ele veste, nos que declaram degrau:

| degrau | tamanho / peso | sítios |
|---|---|---|
| `caption` | 12 / 400 | 6 |
| `bodyMd` | 14 / 400 | 5 |
| `subheading` | 14 / 600 | 3 |
| `label` | 12 / 600 | 1 |

A WCAG isenta texto grande em **18pt regular ou 14pt em negrito** — 24px, ou 18,66px em negrito.
**Nenhum dos quatro chega perto.** O piso de `textTertiary` sempre foi 4,5, e a derivação cobrava
3,0 num ramo e **nada** no outro.

### O conserto preserva o matiz, que é o que você declarou

`_alcancaLendo` caminha do degrau derivado na direção do extremo ALTO — a sua tinta secundária, que
você declarou e que já passa — até alcançar 4,5. **O que se perde é distância, não temperatura.**
Se nem o extremo alto alcançar, ele devolve o extremo alto: a melhor coisa que a sua declaração
oferece, sem inventar cor.

O fundo de referência é a **página**, não a superfície, e isso fecha os seus dois números: a página
é o fundo menos contrastante dos dois (3,77 contra 4,17 na sua medição), então alcançar o piso nela
alcança na superfície.

A frase que faltava aplicar é desta casa, da v0.22.0: **«tinta é consequência de legibilidade;
preenchimento é decisão de marca»**. O `textTertiary` ficou três meses fora dela.

**Na paleta de referência nada se move** — ela já media 10,23 no claro e 6,53 no escuro. O piso só
morde onde a declaração do filho falha, que é exatamente onde ele deve morder.

**Os sete**: manutenção ↑ um piso no lugar de dois comportamentos · escalabilidade ↑ vale pro filho
N sem ninguém remedir · **aplicação ↑ decide** — o modo claro do seu app volta a passar ·
aderência ao mercado ↑ WCAG 2.2 §1.4.3 · **robustez ↑ decide** — `_degrauEntre` não consultava
contraste nenhum · arquitetura = uma função ao lado das duas que já existiam · conciso =.
