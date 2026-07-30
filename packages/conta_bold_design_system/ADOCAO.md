# Adoção do DS do Bold — o que é rename, o que é variante, o que sobe pro pai

Medido em 2026-07-29 contra `ds-diletta v0.2.0`. Fonte dos componentes do Bold:
`app-newbold/lib/design_system/widgets` (69 arquivos). O método foi extrair a API dos dois
lados — classes, construtores nomeados, enums — e comparar, em vez de casar por nome.

**Casar por nome engana, nos dois sentidos.** `bold_list.dart` parece o `list_tile` do pai e
é o `app_list` com o `spot_icon`. E `bold_app_bar.dart` parece uma segunda barra de topo e
não é: são os ACESSÓRIOS que entram dentro da barra — a mesma decomposição do pai
(`TopAppBar` monta, `NavigationTopBar` é o conteúdo, e os acessórios encaixam nos slots).
Onde o nome discorda da API, vale a API; onde a API parece divergir, vale conferir a
decomposição antes de chamar de divergência.

## Decisões já tomadas

| assunto | decisão |
|---|---|
| fonte da marca | **Inter**. Registrada em `BoldFonts`; os `.ttf` ainda não estão no pacote (ver `bold_fonts.dart`) |
| família de ícones | **herda o pai**. Medido: pai 354, Bold 354, **310 com o mesmo nome** — é a mesma família. Os 44 "só do Bold" são o mesmo arquivo com sufixo `" 1"`, resto de export do Figma |
| componentes exclusivos | **sobem pra linguagem**, exceto os dois de marca (ver caixa 3) |

O detalhe dos ícones não é curiosidade: os componentes do pai referenciam **46 nomes** (não
44 — a doc dele está velha), e se o Bold entregasse o próprio conjunto, 6 desses cairiam no
fallback pelo sufixo (`chevron-left-solid` contra `chevron-left-solid 1`). Ícone errado
passa por decisão de design. Herdar elimina a classe inteira e custa zero linha.

---

## Caixa 1 · Rename puro — 44 componentes

O pai cobre o conceito com superfície igual ou maior. A adoção é trocar `BoldX` por
`ds.DilettaY`, sem criar nada.

Alguns são idênticos até nos enums, o que era esperado: o DS do Bold nasceu se integrando
com o do primeiro filho.

| componente do Bold | vira | evidência |
|---|---|---|
| `BoldCheckbox` | `DilettaCheckbox` | enums idênticos (Size 2, Variant 5) |
| `BoldTooltip` | `DilettaTooltip` | enums idênticos (Side 4, Size 3, Style 2) |
| `BoldSpinner` / `BoldBusy` | `DilettaLoadingSpinner` | `SpinnerSize` 3 nos dois |
| `BoldIconButton` | `DilettaIconButton` | pai Type 5 ⊃ Bold 4; Size, State e Flush iguais |
| `BoldStatusTag` | `DilettaStatusTag` | pai Tone 6 ⊃ Bold 5 |
| `BoldButton` | `DilettaButton` | pai Type 8 ⊃ Bold 5; e 3 tamanhos bastam — o 4º do Bold sai |
| `BoldSkeleton` | `DilettaSkeleton` | pai tem `box`/`circle`/`line` ⊃ Bold `circle` |
| `BoldAppList` | `DilettaAppList` | 29 variantes contra 33 do pai, quase o mesmo conjunto |
| `BoldSelectField` | `DilettaDropdown` | pai 197L ⊃ Bold 96L |
| `BoldTextField` / `BoldCurrencyField` | `DilettaInput` | pai 391L, com `InputType` 3 |
| `BoldIllustration` | `DilettaIllustration` | pai 293L ⊃ Bold 54L, com `IllustrationSize` |
| `BoldAccordion` | `DilettaExpansionTile` | mesmo tamanho, mesmo papel |
| `BoldAlert` | `DilettaToast` | 4 estados nos dois |
| `BoldChip` | `DilettaInfoChip` | pai tem `Tone`, Bold não |
| `BoldInputChip` | `DilettaInputChip` | o input chip é **primário e sem tom** — os 5 tons do `BoldInputChipTone` são trabalho do status tag, e a conflação se desfaz na adoção |
| `BoldTopBar` | `DilettaTopAppBar` + `DilettaNavigationTopBar` | mesma decomposição: as variantes `back`/`close`/`home`/`icons` do Bold **são** as fábricas de acessório do pai |
| `BoldBottomApp` | `DilettaBottomApp` | inclusive o `.child`: os 4 usos reais colocam UM `BoldButton` dentro, o que o `.button` do pai cobre com `NavigationButton(primary:)` |
| `BoldContextBanner` | `DilettaStatusBanner` | — |
| `BoldControls` | `DilettaToggleSwitch` | pai tem `ToggleSize` |
| `BoldKeypad` | `DilettaKeyboard` | — |
| `BoldDatePicker` | `DilettaCalendar` | — |
| `BoldSheet` | `DilettaSheetOverlay` | — |
| `BoldNoticeRow` | `DilettaNoticeBanner` | — |
| `BoldPermissionGroup` | `DilettaCriteriaList` | — |
| `BoldPromoCard` | `DilettaFeatureCard` | — |
| `BoldQuickCard` / `BoldQuickAction` | `DilettaQuickAccessCard` | pai tem `QuickAccessState` |
| `BoldNavTopBar` | `DilettaNavigationTopBar` | — |
| `BoldNavigationButton` | `DilettaNavigationButton` | — |
| `BoldGlassAvatar` / `BoldAvatarStack` | `DilettaAvatar` | composição; pai tem `AvatarVariant` |
| `BoldPasswordSheet` | `DilettaPasswordBottomSheet` | — |
| `BoldHomeIndicator` | `DilettaBottomHomeIndicator` | — |

Mais, sem observação: `amount_display`, `detail_row`, `dialog`, `empty_state`, `icon`,
`logo`, `otp_input`, `page_title`, `progress_bar`, `promo_banner`, `radio_list`, `receipt`,
`search_input`, `section_header`, `stepper`. O `glass_surface` também é rename — depois de
resolvida a seção do vidro.

---

## Caixa 2 · O que sobrou depois da revisão do dono — 3 casos

Cinco dos sete caíram na revisão de 2026-07-29, e vale registrar por quê: **quatro eram
leitura errada minha, um era escopo que não precisa crescer.**

| caiu | por quê |
|---|---|
| `BoldInputChip` tons | input chip é primário; quem tem tom é o status tag. São duas coisas |
| `BoldButtonSize` 4º tamanho | 3 tamanhos bastam. O quarto sai |
| `BoldSpotTone` | a quantidade de tons do `SpotIcon` do pai está boa, não precisa crescer |
| `BoldBottomApp.child` | desnecessário: dá pra passar a própria peça na variante que já existe. Medido nos 4 usos reais, todos são um botão só |
| `BoldTopBar` (8 variantes) | `bold_app_bar.dart` não é uma segunda barra: são os ACESSÓRIOS (`CircleButton`, `Avatar`, `AccountPill`, `AccountSwitcher`) que entram dentro da barra. O pai decompõe igual |

### O que resta

**1 · `BoldBalance` — nasce no filho por COMPOSIÇÃO, não como variante do pai.**

É o card de saldo da home, e a doc dele já diz do que é feito: card glass + botão + status
tag + tokens. Não é um `AmountDisplay` com modo oculto: é um organismo do produto, com
detalhes que são dele — largura do valor RESERVADA (mascarar não desloca nada) e o toggle de
ocultar morando no top bar, não no card. Composição de peças públicas do pai é a primeira
opção da ordem de preferência da governança, e é esta.

**2 · ~~O stroke e o glow do vidro~~ — RESOLVIDO na v0.4.0 do pai.** A receita do vidro
virou do filho: `blurDeVidro`, `tracoDeVidroClaro` e `tracoDeVidroEscuro` na paleta, com
default que não move um pixel do primeiro filho. Este filho já declara os três, e o gate
`traco-de-vidro-visivel` que veio junto foi medido por regressão deliberada: com o traço
branco no claro ele acusa 1.00:1, que é exatamente o bug que originou o pedido.

**3 · ~~Os acessórios de conta batem numa fronteira FECHADA~~ — ABERTA na v0.4.0.**

O pai adicionou `DilettaNavigationLeftAccessory.livre(child:, ocupaALinha:)`, e as fábricas
tipadas seguem iguais — os 110 usos de rename não mudam de forma. O `ocupaALinha` ele
acrescentou sem eu pedir, e a razão é boa: sem ele o cabeçalho ficaria na largura natural e o
centro da barra comeria o resto, então a abertura teria teto.

Duas coisas do pedido que não precisaram de nada, e ele mediu antes de responder: ícone à
direita com badge já existia (`DilettaNavRightIcon.badge`), e o seletor de conta ficou
registrado como PRIMEIRO pedido no ledger — troca de conta provavelmente é linguagem, mas um
caso é gosto local até um segundo filho medir.

Gate deste lado: `test/a_home_cabe_na_barra_do_pai_test.dart`. O cabeçalho ali é esqueleto de
propósito (o de verdade precisa de avatar, conta com carregando e troca de conta, que ainda
não nasceram aqui) — o que ele prova é o mecanismo, e que a identidade atravessa.

### O texto original do caso, mantido porque a razão continua valendo

Os slots do pai são tipados como `sealed class`:

```dart
sealed class DilettaNavigationLeftAccessory   // .back .close .home
sealed class DilettaNavigationRightAccessory  // .icons .buttonTertiarySmall .inputChip
```

`sealed` significa que **o filho não consegue nem compor um acessório novo** — não é questão
de não ter a peça, é que a hierarquia não aceita mais nenhuma. E isso contradiz a frase do
próprio pai: "extensibilidade não vem de hook, vem de o pai expor as peças".

Duas saídas, e a primeira é melhor:

- **`.custom(Widget)` nas duas classes seladas.** Não quebra nada, mantém as fábricas
  tipadas pros casos documentados, e devolve ao filho a capacidade de compor. É o pedido 7.
- promover o seletor de conta pro pai. Só vale se ele for linguagem — troca entre contas é
  vocabulário de qualquer produto com mais de uma conta, então é defensável, mas resolve UM
  caso e deixa a fronteira fechada pro próximo.

## Caixa 3 · Só o Bold tem — 12, e 10 sobem pra linguagem

Decisão do dono do produto (2026-07-29): os exclusivos sobem pro pai. A exceção é o que
carrega narrativa de marca, porque valor de marca no pai é a regra que o pai não quebra.

| componente | linhas | destino |
|---|---|---|
| `BoldCopyButton` | 106 | **pai** — copiar chave/código é vocabulário de qualquer produto financeiro |
| `BoldPageDots` | 65 | **pai** — indicador de página; o pai tem `journey_step`, que é outra coisa |
| `BoldTabBar` + `BoldTabs` | 181 | **pai** — abas segmentadas não existem no pai, e o chrome do próprio catálogo teve que inventar as dele |
| `BoldTransactionSummary` | 170 | **pai** — 4 classes (`SummaryRow`, `SummarySection`, `SummaryAction`, `TransactionSummary`); é a gramática de resumo de transação |
| `BoldMoneyInputFormatter` | 47 | **pai** — formatação de dinheiro BR; não é componente, é utilitário de linguagem |
| `BoldApprovalProgress` + `BoldSlaChip` | 147 | **pai** — aprovação por múltiplas assinaturas é vocabulário de conta PJ |
| `BoldRuleLadder` + `BoldRuleStep` | 150 | **pai** — a escada de alçadas, par do anterior |
| `BoldBackground` (+ `SecondaryBackground`, `HomeBackground`, `BackdropScope`, enum `BoldBackdrop`) | 291 | **pai** — backdrop com scrim de legibilidade é estrutura; os VALORES (a imagem, o wine-ink) ficam no filho |
| `BoldPixMark` | 38 | **pai**, e ele já tem meio caminho: existe token de ilustração `pix`. Marca do arranjo de pagamento é vocabulário brasileiro, não do Bold |
| `BoldQuantumSeal` | 431 | **filho** — narrativa de marca do Bold |
| `BoldQuantumPairing` (+ `QuantumCore`) | 712 | **filho** — idem, e é a maior peça exclusiva do produto |

O `BoldApprovalProgress` sobe junto com `BoldApprovalHeat` (a escada de cores de risco, hoje
em `bold_colors.dart`) — mas com a cor vindo de papel, não da lista literal de 5 valores.
Escada de risco é linguagem; os cinco hexes são do filho.

---

## O pedido 6 pro pai, achado medindo a navbar

A navbar foi o exemplo que levantou isso, e o resultado surpreende: **ela não precisa de
variante.** O glow do item ativo já é token do pai (`DilettaElevation.brandSoft`,
documentado como "nav item ativo, glow suave da marca"). O problema é outro:

```
brandLow     rgb=#003BE0   ← primary04 do CPF SEGURO
brandMedium  rgb=#2157EF   ← idem
brandHigh    rgb=#2157EF   ← idem
brandSoft    rgb=#003BE0   ← idem
```

As quatro elevações de MARCA são constantes com o azul do primeiro filho. Quatro
componentes do pai as usam: `nav`, `button` (no `chatLift`), `status_banner` e
`chat_completion_card`. Com a paleta do Bold plugada, **o glow sai azul**.

É a mesma classe dos gradientes (consertada), das superfícies do escuro e do tinte do vidro
(consertadas na v0.1.9). E sobreviveu pelo mesmo motivo que as superfícies: **nenhum dos
dois gates olhava pra `boxShadow`.** O teste de vazamento deste filho passou a olhar
(`bold_e_filho_do_ds_test`), então quando o pai derivar as quatro da paleta, o gate confirma
sozinho.

O conserto tem a forma que o pai já usa nos gradientes: `brandSoftDe(paleta)` e companhia.

---

---

## O vidro: separar duas coisas que eu havia juntado

Eu listei "stroke e glow de vidro" como um problema só. Medindo, são **dois**, e um deles
nem é do vidro — o vidro do Bold declara explicitamente que **não tem sombra**, com a razão
escrita: sombra atrás de vidro é reamostrada pelo `BackdropFilter` e vira halo sujo.

### O que cada lado tem, medido

| | pai (`DilettaGlassSurface`) | Bold (`BoldGlass`) |
|---|---|---|
| tinte | do scheme (`glassTint`, derivado da paleta desde a v0.1.9) | vinho-ink `#16060A` @ 50% no escuro · branco @ 50% no claro |
| blur | **10, cravado no componente** | **15**, token único (`BoldGlass.blur`) |
| stroke | **não existe** | **1px** — rosa `#FF9898` @ 30% no escuro · `primary08` no claro |
| sombra | não usa | proibida, com razão escrita |
| clip | `ClipRRect` quando tem raio | `Clip.antiAlias` obrigatório, com razão escrita |

Duas diferenças de valor (tinte e blur) e uma diferença de ESTRUTURA (o stroke). A do tinte
já está resolvida. Sobram blur e stroke.

### O argumento que decide, e ele é do próprio pai

O stroke do vidro do Bold não é gosto. A doc dele diz por que existe no claro: *"a borda
branca sumia sobre fundo claro"*. Ou seja, vidro branco @ 50% sobre fundo claro é uma
superfície **sem limite visível**.

E o pai tem uma regra de conformidade que se chama exatamente `borda-invisivel`, com o
motivo escrito: "card, painel e campo ficam sem limite visível". O limiar dela é 1.06:1.

O vidro claro do pai é `white @ 80%` sobre `neutral10` — e não tem stroke nenhum. Ele passa
hoje porque a conformidade olha os papéis do chrome, não a superfície glassy. **O stroke que
o Bold inventou é a regra do pai aplicada ao vidro.** Não é o segundo filho querendo algo
diferente: é o segundo filho tendo o defeito primeiro, porque o vidro dele fica sobre um
backdrop de imagem, onde a falta de limite salta.

### A recomendação

**Pedir ao pai duas fendas, com default que não muda um pixel do primeiro filho:**

```dart
DilettaGlassSurface(
  child: …,
  // blur e traço saem da paleta, como o tinte já sai
)
```

- `blurDoVidro` na paleta (opcional, default 10);
- `tracoDoVidro` — cor e largura, opcionais, default **nenhum traço**.

Com default preservado, o CPF SEGURO renderiza idêntico e a mudança é `minor`. E o Bold
passa a ter vidro sem escrever componente: os quatro lugares (`card.strokePainter`,
`glass_surface.border/fill`, `quick_action.simpleStroke`, `dialog.glow`) viram o
`DilettaGlassSurface` do pai com três valores de paleta.

É o mesmo desenho da v0.1.9, que é o precedente mais forte que existe: o tinte do vidro
virou campo opcional da paleta com fallback neutro. Blur e traço são a outra metade da
mesma peça, e ficaram de fora só porque ninguém tinha medido um segundo vidro.

**Por que NÃO fazer um `BoldGlass` no filho**, mesmo sendo mais rápido: vidro é
característica de CONTAINER, e o pai diz isso na doc do componente dele. Um vidro do filho
significa que todo container do pai que é glass por dentro (`TopAppBar`, `BottomApp`,
`Toast`, `Sheet`) continuaria com o vidro do pai, e o Bold teria DOIS vidros na mesma tela —
o dele nos cards, o do pai nas barras. Isso não aparece como bug: aparece como "o app está
um pouco inconsistente", que é a forma mais cara de defeito.

**O contorno, se o pai não pegar agora:** um decorador no filho que embrulha o
`DilettaGlassSurface` e desenha só o traço por cima. Mantém tinte, blur e clip do pai, e o
diff a jogar fora quando as fendas existirem é um arquivo pequeno. O que não vale é
reimplementar o `BackdropFilter` — o clip e o `saveLayer` do pai têm duas armadilhas
documentadas, e as duas custaram tempo em algum lugar.

### O glow, que é outro assunto

`BoldElevation.glow(cor, opacity)` é sombra colorida de marca: item ativo da nav (0.65),
`dialog.glow` (0.45), realce de botão. O pai TEM isso — `brandLow/Medium/High/Soft` — e o
problema não é falta, é que os quatro são literais com o azul do primeiro filho (pedido 6).

Então: **glow não é decisão de design, é conserto.** E `dialog.glow` do Bold, que eu havia
posto na lista do vidro, é só a `brandMedium` do pai depois do conserto.

A única decisão real que sobra no glow é de intensidade: o `brandSoft` do pai é 18% e o Bold
usa 45–65%. Intensidade de marca é do filho, então quando as quatro virarem função da
paleta, a fenda de opacidade acompanha — ou o Bold aceita a do pai. Isso se decide olhando,
não discutindo, e cabe numa tela do catálogo.

### O `BoldGlassAuth` fica no filho, e não vira vidro

É o segundo vidro do Bold: um wash em gradiente que some subindo, pra a foto de tela cheia
aparecer atrás do card de login. A doc dele já diz "uso restrito, não vire o vidro
alternativo". Um uso, uma tela, decisão estética de um produto: é filho, e não é `glass` —
chamá-lo de vidro é o primeiro passo pra ele virar o segundo vidro de todo mundo.

---

## Como um componente SOBE pra linguagem — proposta de processo

O pai tem a regra ("variante nasce no filho, sobe no segundo pedido") e não tem o
procedimento. A proposta abaixo não inventa exigência: cada item é um gate que o pai **já
tem**, aplicado na ordem em que ele morde.

1. **Nenhum valor de marca viaja.** Nem default, nem exemplo. Cor, sombra e gradiente saem
   de papel ou de função da paleta. É o que `fronteira_pai_filho_test` cobra.
2. **Se falta papel, cria-se papel** — é de graça pro filho, porque papel é derivado.
   Componente que precisa de um degrau cru é sinal de vocabulário faltando.
3. **Spec antes do código**, em `specs/`. O pai tem 64; componente sem contrato escrito é
   componente cuja variante ninguém sabe recusar.
4. **Entra na Aurora.** Se o segundo filho sintético não o renderiza, não está provado que
   outra marca o usa — e é a lacuna que deixou as superfícies do escuro passarem.
5. **Golden do filho de origem não muda um pixel.** É a prova de que a promoção preservou
   comportamento; se mudou, ou falta papel, ou a promoção mudou o desenho por acidente.
6. **CHANGELOG antes da tag, dizendo qual foi o segundo pedido.** Sem isso a regra da
   promoção vira formalidade. Componente novo é `minor`.
7. **O filho apaga a versão local no sync seguinte** — e o gate de drift garante que ela
   não sobreviva escondida.

O passo 4 é o que falta com mais força hoje: a Aurora renderiza 4 dos 100 componentes, e
promover 10 componentes sem ampliar essa cobertura é aumentar a superfície não medida do
pai na mesma proporção.

---

## Ordem sugerida

1. ~~O pai deriva as quatro elevações de marca da paleta~~ — **ENTREGUE na v0.3.0.** Medido
   depois do sync: `brandSoftDe` e `navGlowDe` saem `#FE3976`, o rosa daqui. O pai ainda
   acrescentou `navGlowDe` a 35%, que é mais perto dos 45–65% que este produto usava do que
   os 18% do `brandSoft` antigo. O `dialog.glow` deixou de ser um caso.
2. ~~Blur e traço do vidro~~ — **ENTROU COMO FORMA na v0.4.0.** Os três campos estão
   declarados; as 18 leituras de vidro em 7 componentes passam a ser o
   `DilettaGlassSurface` do pai, sem componente novo aqui.
3. **Nascer no filho** `QuantumSeal` e `QuantumPairing`, que não dependem de decisão
   nenhuma.
4. **Subir os 10**, um por vez, com o processo acima — começando pelos dois que são par
   (`ApprovalProgress` + `RuleLadder`), porque eles medem o processo com um caso real de
   vocabulário e não de utilitário.
5. ~~A barra de topo~~ — **ENTROU na v0.4.0**, e era o único bloqueante. Os 113 usos podem
   entrar na linguagem. O pai pediu a medição do que sobrar fora dela quando isso acontecer.
