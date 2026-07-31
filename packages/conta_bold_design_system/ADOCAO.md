# Adoção do DS do Bold — o que é rename, o que é variante, o que sobe pro pai

Medido em 2026-07-29 contra `ds-diletta v0.2.0`, revisado contra a **v0.8.0** (que mudou o
modo de consumo deste filho de sync pra dependência — ver o pedido do raio). Fonte dos componentes do Bold:
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
| família de ícones | **herda o pai**, e agora sem exceção. Medido: pai 354, Bold 354, **310 com o mesmo nome** — é a mesma família; os 44 "só do Bold" são duplicata com sufixo `" 1"` do export. Os dois glifos que faltavam (o sparkle da assistente) subiram pro pai na v0.6.0, então o conjunto vai a **358** e este filho não declara asset próprio nenhum |
| componentes exclusivos | **sobem pra linguagem**, exceto os dois de marca (ver caixa 3) |

O detalhe dos ícones não é curiosidade: os componentes do pai referenciam **46 nomes** (não
44 — a doc dele está velha), e se o Bold entregasse o próprio conjunto, 6 desses cairiam no
fallback pelo sufixo (`chevron-left-solid` contra `chevron-left-solid 1`). Ícone errado
passa por decisão de design. Herdar elimina a classe inteira e custa zero linha.

---

## Caixa 1 · Rename puro — 47 ARQUIVOS de widget

> **COBERTURA NO CATÁLOGO, medida em 2026-07-30 a pedido do dono do produto** ("o catálogo já tem todos
> os itens do pai que você usa?"). A resposta era NÃO, e o buraco maior era o maior componente:
>
> | componente do pai sem bloco | usos no app |
> |---|---|
> | `DilettaTopAppBar` | **109** |
> | `DilettaNavigationTopBar` | 13 |
> | `DilettaStatusBanner` · `DilettaCalendar` | 4 cada |
> | `DilettaKeyboard` | 2 |
>
> Os cinco entraram no mesmo ciclo. **Agora todo componente do pai com uso medido no app tem bloco** — 56
> blocos, 48 por tabela, 52 com contrato.
>
> Os 8 que continuam sem bloco têm **zero uso** (`tooltip`, `stepper`, `bannerPromo`, `barraDeProgresso`,
> `folhaDeSenha`, `otp`, `linhaDeDetalhe`, `glassSurface` direto), e ficam de fora pela mesma razão dos
> sete gradientes mortos: declarar o que ninguém usa parece progresso.

> **Quanto disso está no catálogo (2026-07-30):** dos 47, **27 já são bloco** — o resto entra por
> medição, e **8 estão fora de propósito por terem ZERO uso no app** (`tooltip`, `stepper`,
> `bannerPromo`, `barraDeProgresso`, `folhaDeSenha`, `otp`, `linhaDeDetalhe`, `glassSurface` direto).
> Declarar bloco de componente que ninguém usa é o mesmo erro dos sete gradientes mortos: parece
> progresso.

O pai cobre o conceito com superfície igual ou maior. A adoção é trocar `BoldX` por
`ds.DilettaY`, sem criar nada.

Alguns são idênticos até nos enums, o que era esperado: o DS do Bold nasceu se integrando
com o do primeiro filho.

> **O número dizia 44, e a limpa de 2026-07-30 mediu 47.** A unidade é ARQUIVO
> (`app-newbold/lib/design_system/widgets/*.dart`): **31 na tabela abaixo + 16 na lista de prosa**. Está
> escrito aqui porque contagem sem unidade declarada não se confere — quem recontou por CLASSE achou 51,
> e nenhum dos dois números estava errado, faltava dizer o que se contava.

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
| `BoldStatusBadge` (3 usos) · `BoldFilterChip` (10) | `DilettaInfoChip` · `DilettaInputChip` | os dois moram em `bold_chip.dart`, e são coisas diferentes: um informa, o outro filtra |
| `BoldInputChip` | `DilettaInputChip` | o input chip é **primário e sem tom** — os 5 tons do `BoldInputChipTone` são trabalho do status tag, e a conflação se desfaz na adoção |
| `BoldTopBar` | `DilettaTopAppBar` + `DilettaNavigationTopBar` | mesma decomposição: as variantes `back`/`close`/`home`/`icons` do Bold **são** as fábricas de acessório do pai |
| `BoldBottomApp` | `DilettaBottomApp` | inclusive o `.child`: os 4 usos reais colocam UM `BoldButton` dentro, o que o `.button` do pai cobre com `NavigationButton(primary:)` |
| `BoldOperatingStrip` (2 usos) · `BoldOperatingSlot` (2) | `DilettaStatusBanner` | `BoldOperatingContext` tem **zero uso** — não portar |
| `BoldSwitch` (9 usos) | `DilettaToggleSwitch` | pai tem `ToggleSize` |
| `BoldKeypad` | `DilettaKeyboard` | — |
| `BoldDatePicker` | `DilettaCalendar` | — |
| `BoldSheet` | `DilettaSheetOverlay` | — |
| `BoldNoticeRow` | `DilettaNoticeBanner` | — |
| `BoldPermissionGroup` | `DilettaCriteriaList` | — |
| `BoldPromoCard` | `DilettaFeatureCard` | — |
| `BoldMenuTile` (8 usos) / `BoldQuickAction` | `DilettaQuickAccessCard` | pai tem `QuickAccessState` |
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

### O que a limpa de 2026-07-30 acrescentou aqui — um rename ERRADO

**`BoldSegmentedControl` (3 usos) não é `DilettaToggleSwitch`.** A linha antiga dizia
`BoldControls → DilettaToggleSwitch`, nomeando o ARQUIVO (`bold_controls.dart`) em vez das classes: ele
declara DUAS, e só uma é um switch. Um switch é binário; um segmented control é escolha entre N — mapear
um no outro é perder o componente na adoção.

E o pai **não tem** segmented control: `grep` em `lib/src/widgets` não acha nenhum. O parente mais
próximo é o `BoldAbas`, que nasceu aqui — mesma API (`List<String>` + índice + `onChanged`) e outro
idioma visual (sublinhado contra pílula preenchida). Então o caminho provável é **variante do
`BoldAbas`**, não componente novo — e é decisão pra o próximo ciclo, com os 3 usos medidos.

Isto é a armadilha que a abertura deste documento descreve — *"casar por nome engana"* — aplicada ao
próprio documento, em quatro linhas dele. As outras três eram só nome trocado; esta mudava o destino.

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

O passo 4 é o que falta com mais força hoje: a Aurora renderiza 4 dos componentes do pai — que em
2026-07-30 são **101 arquivos e 127 classes públicas** em `ds-diletta/packages/diletta_design_system/lib/src/widgets`
— e promover componente sem ampliar essa cobertura é aumentar a superfície não medida do pai na mesma
proporção. (A contagem antiga vinha sem unidade declarada; arquivo e classe não são a mesma coisa, e a
diferença entre as duas é 26.)

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

---

## Tipografia — fechada em 2026-07-30

A escala é linguagem (ADR-003), então o filho não declara degrau: decide a SUBSTITUIÇÃO, uma
vez. A fonte de verdade é `test/o_mapa_da_tipografia_test.dart`, que fixa os 19 degraus
escolhidos e falha se o pai mover tamanho ou peso de algum deles.

Medido: 19 presets no produto antigo contra 23 do pai. **Sete idênticos** em tamanho e peso.
Nos outros doze a regra foi **papel primeiro, métrica depois** — quando o pai tinha a métrica
exata no papel errado (`titleSm` 14/500 contra `labelLg` 14/600), escolhi o papel, porque nome
de papel é o que o próximo dev lê.

| antigo | vira | muda |
|---|---|---|
| `headlineMd` `headlineSm` `titleMd` `labelMd` `labelSm` `bodySm` `bodyLg` | o degrau de mesmo nome | nada |
| `labelLg` | `labelLg` | peso 500 → 600 |
| `button` | `button` | peso 700 → 600 |
| `label` | `label` | peso 700 → 600 |
| `h2` 22/700 | `title` | peso → 600 |
| `display` 46/800 | `displayMd` | 45/600 — o 46 era 1px de drift |
| `title` 17/700 | `heading` | 16/600 — idem |
| `tileLabel` 10/500 | `labelSm` | 11/500 — abaixo de 11 o pai não tem, e pedir um degrau de 10 seria a linguagem descendo pra caber num arredondamento meu |
| `h1` 30/800 | `headlineLg` | 32/600 |
| `body` 15/500 | `bodyMd` | 14/400 |
| `bodySmall` 13/500 | `bodySm` | 12/400 |
| `mono` 13/400 | `numericSm` | 13/500 **tabular** |
| `monoCaption` 11/400 | `numericXs` | 11/500 **tabular** |

Os dois últimos fecham um ciclo: o `mono` do produto nunca foi monoespaçado — era a fonte da
marca com dígitos tabulares, que é a resposta certa pra CPF, chave e valor. O pai só tinha o
degrau de 22, e os de 13 e 11 entraram na v0.1.9 por este pedido mais o de outro filho.

`h1` e `body` eu resolvi pela LADEIRA e não pelo vizinho mais próximo: o produto tinha
display 46 · h1 30 · h2 22, e o pai tem displayMd 45 · headlineLg 32 · titleLg 22. Mapear
degrau a degrau preserva a proporção entre eles, que é o que o olho lê — escolher cada um pelo
vizinho achataria a hierarquia.

**A fonte está empacotada** (2026-07-30): Inter v4.0, cinco pesos (400/500/600/700/800) em
`assets/fonts/`, sob SIL Open Font License 1.1 — a licença viaja em `OFL.txt`, como ela exige.
`BoldFonts.empacotada` é `true`, e `a_fonte_da_marca_viaja_test` cobra os quatro jeitos disso
ser mentira.

Empacotada em vez de resolvida por `google_fonts`, e a razão não é preferência: fonte de marca
que depende de download é fonte que às vezes não é a da marca — no primeiro launch, no avião,
na rede do cliente. É também o que o primeiro filho faz.

Este é o ÚNICO asset que o filho declara. Ícone e ilustração são vocabulário e vêm do pai.

---

## Gradiente — fechado em 2026-07-30, em DOIS

Regra do dono do produto: no máximo dois, `primary` e `accent`, e o resto se modula neles.

Ela saiu de graça, o que é raro numa consolidação de 10 pra 2. A medição de uso mostrou que
**sete dos dez tinham ZERO uso** — `pay`, `ted`, `statement`, `receive` e `charge` (azul, âmbar,
verde, azul claro e roxo, uma cor por tipo de transação), mais `balanceCard` e o alias
`primaryButton`. Cinco matizes estrangeiros numa marca rosa que ninguém consumia: token morto,
não decisão de desenho a rediscutir.

Os três que sobravam já eram os dois:

| antigo | usos | vira |
|---|---|---|
| `brand` (pôr do sol de 3 paradas) | 6 | `primary` |
| `pix` | 4 | `accent` |
| `primaryButtonShort` | 1 | `accent` |

E os dois foram MODULADOS, o que resolveu dois problemas de uma vez:

| | antes | agora | ganho |
|---|---|---|---|
| `primary` | rosa → coral → amarelo | **`primary04` → `warning03`** | branco vai de 1.21 (invisível) a 3.37 na pior parada |
| `accent` | rosa → laranja literal | **`warning03` → `warning02`** | pior parada 3.37, outra 6.54 |

**O ganho principal é que sobrou ZERO literal de cor.** O coral, o amarelo e o laranja eram três
valores de marca morando no arquivo de gradiente, porque a paleta não tem campo pra parada de
gradiente — três valores que um rebrand não alcança. Modulando dentro das rampas que já existem,
as quatro paradas passam a ser degraus da paleta, e há gate pra isso.

O laranja vir da rampa `warning` não foi conveniência: quando a rampa `accent` coral foi
descontinuada em 2026-07-16, o próprio produto registrou que os usos decorativos dela migravam
pra `warning`.

Então a consolidação renomeia dois e apaga sete. Gate: `dois_gradientes_e_so_test` — a regra é
contagem, não convenção, porque foi assim que dez apareceram (um por tela, nenhum por decisão).

**O defeito de acessibilidade que a medição achou, e que a modulação consertou.** O produto tinha
`onGradient = white` e, no mesmo arquivo, um comentário admitindo que "o branco lava no amarelo".
Branco sobre as três paradas antigas: **3.46 · 2.56 · 1.21** — a última invisível. E o ink escuro
não resolvia: ele salvava o amarelo (9.43) e afundava no rosa (3.29). Não existia tinta legível
ao longo do pôr do sol inteiro, e isso era propriedade de um gradiente que atravessa rosa e
amarelo.

Com a modulação, branco passa em toda parada dos dois (mínimo **3.37**), então `onGradient` volta
a ser branco — agora por medição. A escolha se justifica pelo PIOR caso e não parada a parada: no
`warning03` o ink ganha por 0.01, que é empate, e o que decide é o `warning02`, onde o ink desaba
pra 1.74 contra 6.54 do branco. (Eu havia escrito que o branco ganhava "em todas as paradas"; o
gate me pegou.)

**A regra de uso que os números impõem:** 3.37 passa AA-grande (3.0) e não passa AA de texto
(4.5). Sobre gradiente vale glifo e rótulo a partir de 18.7px em peso 600 — rótulo de botão a
15px usa o `primary` SÓLIDO do scheme, onde a conformidade do pai já garante o par.

Conserto que fica pra adoção: as iniciais do `avatar_stack` e do `avatar_row` são brancas sobre o
meio do gradiente antigo, a 2.56:1. Com o primary novo elas vão a 3.37.

**O que continua pendente do pai:** as três formas de gradiente dele derivam a própria cor
(`primary03 → primary05`, cravado), então não há fenda de material — nem os meus dois cabem lá.
Enquanto isso, `bold_gradients.dart` carrega forma E material; quando a fenda existir, a forma
sai e sobram as cores.

---

## Revisão de DUPLICAÇÃO — 2026-07-30

Segunda pergunta do dono do produto: *"já revisou o que tem hoje no Bold pra saber se não está duplicando
componente?"* Revisei os 56 blocos por três eixos, e **nenhum componente está duplicado**. O que existe é
ADJACÊNCIA, e ela virou doc — porque a pergunta que ele fez é a que qualquer pessoa faz ao ver os dois
cards lado a lado.

| eixo | achado |
|---|---|
| dois blocos sobre a MESMA classe do pai | 1: `linha` e `linhaDeValor`, os dois `DilettaAppListRow`. É intencional — são as duas fábricas do pai (`menuItem` com 109 usos no app, `transactionItem` pra linha de dinheiro), e a spec `app-list` cobre as duas |
| componente do filho duplicando um do pai | 0 |
| componente do filho duplicando outro do filho | 0 |

**Os três pares adjacentes, e o que separa cada um** (agora escrito no `Evite` de cada contrato):

- **`resumoDaTransacao` × `comprovante`**: o primeiro é o CABEÇALHO da tela (valor herói, spot com tom
  semântico); o segundo é o DOCUMENTO compartilhável (ícone neutro centralizado, linhas label/valor,
  rodapé com ID e logo). Coexistem no mesmo fluxo: o comprovante abre pelo CTA da tela de resumo;
- **`saldo` × `valor`**: `valor` é UM número entre hairlines (detalhe de transação, header de extrato);
  `saldo` é o organismo da home com modo oculto, entradas/saídas e atalho do extrato. Tela que mostra um
  número e nada mais usa o primeiro;
- **`abas` × `segmentos`**: aba troca a LISTA, segmento troca um PARÂMETRO. A prova é do produto, não
  minha: `pix_meus_qr_flow.dart` usa os dois seis linhas um do outro.

E dois que PARECIAM duplicação e a medição descartou: `copiar` não tem equivalente no pai (nenhum
componente dele copia pra área de transferência), e `pontosDePagina` também não (o pai não tem indicador
de página).

---

## Componentes — o primeiro nasceu em 2026-07-30

Ordem por USO medido no app, não por tamanho de arquivo. A lição vem dos gradientes: sete dos
dez estavam mortos, e portar código morto é o pior tipo de trabalho — parece progresso.

| componente | usos | estado |
|---|---|---|
| `BoldBackground` (+ scope, + enum de 7 fundos) | **114** | **nasceu** |
| `BoldSeloQuantico` (era `BoldQuantumSeal`) | 9 | **nasceu** — e tinha 3 defeitos |
| `BoldDinheiro` (era `BoldMoneyInputFormatter`) | 8 | **nasceu** — e o teto deslizava |
| `BoldSaldo` (era `BoldBalance`) | 3 | **nasceu** |
| `BoldCopiar` (era `BoldCopyButton`) · `BoldAbas` (era `BoldTabs`) | 3 cada | **nasceram** |
| `BoldCabecalhoDaHome` | 3 | **nasceu** — e é CASCA, não acessório |
| `BoldVisorDeCodigo` | 1 (e é o diferencial) | **nasceu** — sem plugin de câmera |
| `BoldResumoDaTransacao` (era o topo de `BoldTransactionSummary`) | **3** | **nasceu** — e só o CONTEÚDO |
| `BoldEscadaDeAlcadas` (era `BoldRuleLadder`) | 2 | **nasceu** — e o texto estava abaixo de AA |
| `BoldProgressoDeAprovacao` · `BoldPrazoDaPendencia` | 1 cada | **nasceram** — o par da pendência |
| `BoldSegmentos` (era `BoldSegmentedControl`) | 3 | **nasceu** — e NÃO é variante das abas |
| `BoldPontosDePagina` (era `BoldPageDots`) | 1 | **nasceu** — cor de papel, e o ativo alonga |
| `BoldPixMark` | 1 | **não nasce**: é `DilettaIcon(pixSolid)`. Rename, e a regra do BCB é doc |
| `BoldSecondaryBackground` | 1 | **não nasce**: é `BoldBackground(estilo: solido)`, que já existe |
| `BoldFilterChip` (10) · `BoldSwitch` (9) · `BoldMenuTile` (8) · `BoldStatusBadge` (3) | rename | do pai — não nascem aqui |
| `BoldQuantumCore` | 0 como componente | a fazer — o corte da tela de 712 linhas |
| `BoldHomeBackground` · `BoldTabBar` · `BoldAccountPill` · `BoldAccountSwitcher` | **0** | **não portar** |

**Dois dos "1 uso" que sobravam dissolveram na medição, e nenhum precisou de código.** O `BoldPixMark` é
um invólucro de três linhas sobre `BoldIcon('pix-solid')`, e o pai tem os três glifos de Pix
(`pixLight`, `pixMark`, `pixSolid`) — a doc dele já dizia *"in new code prefer BoldIcon('pix')"*. O que
valia guardar é a REGRA do Banco Central que mora no comentário: a marca do Pix vai nos pontos de marca
do Pix, e ícone genérico de QR não substitui. Regra é doc, não widget.

O `BoldSecondaryBackground` é `BoldBackground(style: solid)` com outro nome — e o fundo que nasceu aqui
já tem os sete estilos no enum. Portar seria criar um segundo nome pro mesmo estado.

**O `BoldTransactionSummary` foi o terceiro achado de classificação, e o mais útil:** ele não é
componente, é a TELA do comprovante (`Scaffold` + fundo + barra + cabeçalho + seções + CTA). Das seis
peças, cinco já existiam na linguagem — o que faltava era só o cabeçalho, e ele nasceu como
`BoldResumoDaTransacao`. A medição que justifica: **três telas de comprovante** (Pix, boleto, TED)
escrevem esse cabeçalho, e a TED escreve à mão com o valor a 34 contra 32 das outras duas. Bloco que
já é a tela não compõe com nada no catálogo; cabeçalho compõe com os cinco.

Dois achados de classificação no caminho:

- **`BoldQuantumPairingScreen` não é componente, é TELA** (712 linhas em `bold_quantum_pairing.dart`) — o consumidor é
  `pairing_gate_screen.dart`. Tela é conteúdo (catálogo ou app), não DS. O corte é
  `BoldQuantumCore` (a peça animada) pra cá, e a tela pra fora;
- o `AccountPill` e o `AccountSwitcher` que eu citei no pedido da barra de topo têm **zero uso**:
  o cabeçalho da home monta a própria coisa por dentro. O pedido estava certo, a justificativa
  não.

### O que a adaptação do backdrop mudou

**A arte saiu do widget.** A versão antiga cravava `assets/images/bg_city_*.jpg` dentro do
componente — caminho de asset do app dentro do DS, o que faz o componente não renderizar fora do
app. Agora a arte entra pelo `BoldBackdropScope` (que o app já declarava pro estilo), e sem arte o
fundo de imagem DEGRADA pro brilho da marca em vez de mostrar retângulo vazio. É o mesmo desenho
do pai pra marca ausente.

**Quatro literais de cor viraram um.** Rosa, coral e amarelo eram rampa e foram modulados
(`primary04`, `warning03`, `warning04`) — a mesma modulação dos gradientes. Sobrou o **violeta**
(`#7B3FF2`), que não pertence a rampa nenhuma deste produto e sustenta os dois moods frios
(`vidroFrio`, `aurora`). Está isolado e nomeado em `BoldBackdropTints`, com gate que falha se
aparecer um segundo valor fora da paleta.

**Resolvido em 2026-07-30, e a saída foi melhor que as duas que eu tinha proposto.** Decisão do
dono do produto: um token de cor de vidro pro **vinho**. Ele faz o mesmo trabalho que o violeta
fazia — dar um polo frio e profundo contra o rosa — com cor que é da marca.

Nasceu `BoldVinho`, com dois degraus (`marca` #90093A e `ink` #16060A) e não uma rampa, porque
degrau nasce quando um caso pede. O vinho aparecia em QUATRO lugares do produto antigo com quatro
nomes diferentes — `brandPrincipal`, `glassFill`, `secondaryFlow` e o violeta dos fundos — e nenhum
era token de marca. Agora tem casa, e três coisas passaram a ler de lá:

- os dois fundos frios (`vidroFrio`, `aurora`), que perderam o violeta;
- o `tinteDeVidroEscuro` da paleta, que era um hex solto e agora diz que é o vinho-tinta a 50%;
- o slot de parceiro, que **empresta** o vinho em vez de ser a casa dele — eu tinha posto o valor
  ali como fallback com um "REVISAR" escrito, e agora trocar o parceiro um dia não move o vidro.

Com isso o backdrop tem **zero valor de cor solto**, e há gate que impede o violeta de voltar.

### Um limite do motor do catálogo, medido

`fundoDaTela` do plugue devolve `Color?`. Então dos sete fundos, só o **sólido** aparece no
preview — os outros seis são widget (arte e brilhos radiais), não cor. Pro Bold isso pesa mais que
pra um produto de fundo plano: o vidro dele só parece vidro sobre algo, e `BackdropFilter` sobre
cor lisa não desfoca nada visível.

Wired o que dá: o frame agora usa a base do backdrop (`bgEscuro` no escuro, `primary08` no claro),
que cobre 54 dos 64 usos explícitos. O resto é pedido ao catálogo pai, quando valer a pena.

### O selo quântico, e os três defeitos que a adaptação achou

**1 · Três estados eram dois booleanos.** `waiting` + `failed` dá quatro combinações pra três
estados, e a quarta (`waiting: true, failed: true`) não tinha significado — o selo mostrava o loop
e ignorava o `failed`. Virou `BoldSeloEstado`, enum de três. É a exigência 7 do contrato pelo
motivo exato: estado impossível que se disfarça de válido, em vez de nem compilar.

**2 · O selo era só-escuro.** `Colors.white` cravado no rótulo e no trilho do anel: sobre o
backdrop claro do produto o texto desaparecia. Agora sai de papel (`s.fg`), e os dois modos
renderizam.

**3 · A tipografia estava presa num estático.** `BoldType.fontFamily` era lido DENTRO do
`CustomPainter`, e painter não vê tema — então a família não acompanhava o `ThemeData`. É o mesmo
defeito que o pai consertou na v0.5.0 (um `DefaultTextStyle` substituído em vez de mesclado).
Agora o estilo é resolvido no widget e entregue pronto; o painter deixou de saber que fontes
existem.

E nove literais de cor viraram zero: dois eram exatamente a paleta (`#2FD27A` é `success05`,
`#FF4D5E` é `error05`) e os outros sete não tinham casa — violeta, roxo, laranja claro, dois
rótulos e dois pares de tinta escura. O polo profundo agora é o vinho, o claro é o rosa, o acento
é a rampa de laranja, e as tintas escuras são o degrau 01 do estado aprofundado por função. Há
gate que lista os sete e falha se algum voltar.

**Primeiro bloco do catálogo que vem de componente do FILHO**, em grupo próprio ("Marca do
Bold"): vizinhança na paleta é decisão de linguagem, e peça de marca não se mistura com
vocabulário herdado. Declarar é publicar — ele apareceu no compositor sem ninguém tocar no
catálogo.

---

## O leitor de código — o diferencial deste filho (2026-07-30)

Nenhum outro filho lê código. Este lê **QR e código de barras**, classifica pelo conteúdo e roteia:
Pix por EMV, boleto por linha digitável, autorização de transação por QR próprio.

**O corte é a decisão que importa.** A tela de scanner (`lib/shared/widgets/unified_scanner_screen.dart`) tem 603 linhas e depende de
`mobile_scanner`, `permission_handler`, roteador e estado. Nada disso entrou: um DS que arrasta
plugin de câmera obriga todo consumidor a carregar câmera, inclusive o catálogo, que só quer
desenhar.

Entrou o que é desenho e o que é conhecimento:

| peça | o que é |
|---|---|
| `BoldVisorDeCodigo` | o overlay: cantos em colchete, varredura com rastro, segundo quadro em saltos de câmera, rótulo com linha de chamada, alvos fantasma. `CustomPainter` puro, zero dependência |
| `BoldFormatosDeCodigo` | a lista de formatos, com o motivo escrito. É a peça de conhecimento mais fácil de perder, e já custou bug de QA: o default da plataforma **não habilita 1D**, e o boleto brasileiro é ITF de 44 dígitos |

Quatro literais de cor viraram zero. **A que se vê: o verde neon `#39FF14` virou `success05`** — era
estética de visão de máquina, e a alternativa seria um quinto valor de marca fora da rampa. Fica
registrado como escolha.

E a fonte do rótulo era `'monospace'` cravada; agora é `numericXs`, o degrau de dado técnico que
este filho pediu na v0.1.9 — que existe exatamente pra número em coluna, que é o caso de um código
lido.

No catálogo o visor é bloco de **tela cheia** (`tiposDeTelaCheia`): sem isso o motor daria a ele o
padding e o scroll do frame, e o retículo apareceria deslocado do centro da câmera.

## Os três símbolos que a auditoria conta como "sem uso", e por que dois ficam — 2026-07-30

A checagem 3 da auditoria de arquitetura cobra símbolo público com um uso ou menos, e ela tem razão em
cobrar: API sem consumidor é peso que alguém mantém sem saber por quê. Neste repo ela aponta três, e o
julgamento é diferente em cada um — o que este arquivo registra, porque a auditoria vai apontar de novo:

| símbolo | usos aqui | veredito |
|---|---|---|
| `rodarCatalogo()` | 1 | **fica**: é o ponto de entrada, e ponto de entrada tem um chamador por definição |
| `lerTelaDoBold()` | 1 | **fica**: é gancho de plugue (`leCodigoComoSpec`), e gancho é chamado pelo motor |
| `BoldBackground.veuDaStatusBar()` | **0** | **fica, e o consumidor é o APP** |

O véu é o que mascara o conteúdo rolando por baixo do notch, e ele tem **dois usos no app hoje**
(`home_tab_redesign.dart:327` chama o `statusBarScrim` do DS interno). Zero aqui significa "o app não
adotou ainda", e não "ninguém precisa" — é a mesma leitura que o pai faz do lado dele: *num pai, quem
chama a API mora fora.*

**E um saiu.** `BoldDinheiro.emReais(String) → double` tinha um uso: o próprio teste. Medindo o app, o
caminho dele **não existe** — os campos de dinheiro guardam `_cents` (int) e emitem `_cents / 100.0` na
hora de avisar a tela; ninguém nunca lê a string formatada de volta pra double. `centavosDe` fica, porque é
a volta que o app faz de verdade.

> **API que só o próprio teste chama é API que ainda não foi pedida.** E o teste dela dava a impressão
> oposta: cobertura verde num caminho que produto nenhum percorre.
