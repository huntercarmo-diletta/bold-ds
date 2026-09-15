# PEDIDO · o Coreflow é o pai, e o Bold é o primeiro filho — e o app não muda uma linha

- **de**: conta-bold-ds (filho B) · **para**: ds-diletta (o pai, dono da árvore do ADR-003)
- **consome**: ds-diletta `v0.163.0` (o pai está na `v0.169.0`) · catalogo-diletta `v0.108.0`
- **bloqueante?**: não. O Bold entrega hoje. O que se pede é que o PRÓXIMO filho não nasça vestido de Bold.
- **desenho por extenso**: [`docs/2026-09-04-adr-o-coreflow-e-o-pai.md`](../2026-09-04-adr-o-coreflow-e-o-pai.md), com a tabela arquivo a arquivo e o script que a reproduz.

## O que a dona pediu, na palavra dela

*"Preciso que o pai de todos os filhos e do Bold seja o Coreflow, que terá o visual da marca da Diletta
para mostrar o white label. Quero que o Bold seja um dos filhos desse Coreflow, não o pai deles. Quero
que esse pai possa gerar filhos num futuro próximo, da forma mais otimizada possível. E não gostaria que o
Bold tivesse de ser retrabalhado de maneira onerosa."*

## Falta

O pacote `coreflow_design_system` é a base white-label E a identidade do Bold no mesmo corpo, e o Bold é o
default dela.

## Número

Medido em 04/09 na `v0.98.1`, por `bash packages/coreflow_design_system/tool/levanta_a_separacao.sh`:

| o que | quanto |
|---|---|
| referências ao Bold em `lib/` | **300**, em 33 dos 66 arquivos |
| no que É do Bold (`bold_palette`, `bold_vinho`, `bold_fonts`, `bold_selo_quantico`, metade de `bold_produto`, barrel) | 176 |
| em 14 componentes `Coreflow*` que leem constante do Bold em vez do esquema | **109** — `bold_scheme` 25, `bold_etiqueta` 21, `bold_gradients` 21, `bold_tema_material` 5, `bold_vidro` 5, `bold_background` 4, `bold_linha_de_aviso` 3, `bold_cartao` 3, e mais seis com 1 ou 2 |
| em comentário "Conta BOLD" | 15 |
| a única leitura direta do PRODUTO Bold dentro de componente | `bold_cartao.dart:226` e `:343` — `CoreflowProduto.bold.paleta` |
| o default | `CoreflowTheme.light/dark` → `CoreflowProduto.bold`; `daMarca(... marcaVisual ?? marcaDoBold)`: filho sem logo nasce com o lockup do Bold |
| marca empacotada na base | 1 logo, 16 ilustrações, 5 arquivos da Inter, `hexesDaArte` |
| testes que citam o Bold | 49 de 57 |
| o app | 213 arquivos importam `coreflow_design_system`; 131 usos de `Bold*` em 22 arquivos; `CoreflowTheme` 2, `CoreflowProduto.bold` 5 |

O mecanismo de filho **já existe e está provado**: `CoreflowProduto.daMarca`, `bin/novo_filho.dart`,
`exemplos/filho_do_coreflow/` e cinco gates (`o_neto_troca_a_paleta_e_pronto`, `o_neto_monta_o_tema_inteiro`,
`o_pacote_nao_crava_a_paleta_do_bold`, `um_filho_nasce_com_uma_cor`, `o_vinho_de_um_filho_e_dele`). O que
falta não é o filho poder existir. É o Bold deixar de ser a casa.

## Já tentei

**Repo novo pro Coreflow.** Um repo privado a mais é mais um lugar em que o bloqueio de acesso da PR #708
se repete, e um conserto do avô passa a levar TRÊS tags pra chegar no app. O adendo do ADR-003 diz por
que não: o modo de consumo segue a fronteira, não o artefato. A fronteira nova é o pacote.

**Nascer `bold_coreflow` e apontar o app pra ele.** É o desenho "limpo", e custa 213 imports mais 131
usos no app — uma segunda PR do tamanho da #708, que está com 898 arquivos e revisão aberta. A dona vetou
retrabalho oneroso do Bold, e este é.

**Deixar como está e confiar no `daMarca`.** Um filho novo já nasce com uma cor. Mas nasce com o lockup
do Bold (`marcaVisual ?? marcaDoBold`), com o gradiente do lockup do Bold e com o `fluxoSecundario` escuro
sendo o vinho — as três lacunas que o Berço Coreflow mediu em 03/09. Cada filho novo as contorna à mão, e
o filho "Diletta", que existe pra MOSTRAR o white-label, sairia parecido com o Bold.

**O que fica de pé:** quem se move é a base. Nasce `packages/coreflow` só com os `Coreflow*`, e
`coreflow_design_system` mantém nome, `path:` e símbolos e vira o filho Bold, re-exportando o pai. O app
não muda uma linha.

## Conferi no pai

- **ADR-003** desenha pai com filhos que têm tokens próprios, componentes próprios e promoção pro pai. Um
  pai INTERMEDIÁRIO (Coreflow) com filhos por produto (Bold, Diletta, o que vier) é a mesma regra um degrau
  abaixo. O adendo de 29/07 é o que me tira o repo novo da mesa.
- **`DilettaBrand.nenhuma`** aponta pra `assets/logos/logo.svg`, e o pai não empacota esse arquivo: a marca
  é do produto, por `DilettaBrand.pacote`. O pai já espera que o logo venha de fora. É isso que o Coreflow
  vai fazer com o Bold.
- **`DilettaPalette.daMarca` e `DilettaRampa.daMarca`** derivam a paleta inteira de uma cor. Dos 109 cortes,
  os 25 do `bold_scheme` e os 21 da `bold_etiqueta` são exatamente o que o pai já deriva — o filho
  congelou o resultado em `BoldColors` e leu a constante.
- **A paleta default do pai é uma rampa verde de exemplo**, e não há logo da Diletta em código nenhum. O
  filho `diletta_coreflow` que a dona quer pra mostrar o white-label **não pode nascer ainda**: falta a cor
  oficial e os SVGs. Está fora deste pedido, e escrito.
- **`TERCEIRO-FILHO.md`** já audita um terceiro filho. Este pedido é o que faz o terceiro não nascer com a
  cara do segundo.

## Derivável?

**Quase tudo, e é por isso que o pedido é barato.** Os 109 cortes viram leitura do esquema em contexto,
a técnica que `bold_background.dart:227` já usa (*"a paleta vem do ESQUEMA, não da const deste produto"*).
Semântica (`success`, `error`, `warning`) é invariante do avô e já está na `DilettaPalette`.

**Duas coisas não derivam, e precisam de decisão:**

1. **`CoreflowProduto.bold`** no app (5 usos) e em `bold_cartao` (2). Pra continuar compilando sem o pai
   saber do Bold, o filho exporta o pai com `hide CoreflowProduto` e declara
   `class CoreflowProduto extends coreflow.CoreflowProduto` com `static final bold` e `static const
   marcaDoBold`. É sombra homônima, e fica escrita. A alternativa é trocar 5 linhas no app e não ter sombra.
   **Qual?**
2. **A fonte.** `CoreflowType.fontFamily = BoldFonts.family` — o pai não pode nomear fonte de marca. Se a
   `DilettaBrand` não tiver campo de família tipográfica, nasce um pedido irmão pro pai; se tiver, a fonte
   vai pelo produto e pronto.

## Se você disser não

O Bold continua sendo a base. Funciona — e cada filho novo nasce com o lockup, o gradiente e o vinho do
Bold e contorna os três à mão, sem gate que cobre. O filho Diletta, que existe pra provar o white-label,
prova o contrário. E o `Berço Coreflow`, que gera filhos pela página, gera filhos com cara de Bold.

## Não estou pedindo

1. **renomear os 65 `bold_*.dart`** — é dívida de nome, mecânica e ruidosa; outra hora, sem lógica junto;
2. **criar a marca Diletta** — insumo de marca (cor oficial, SVGs) que não existe; entra como filho depois;
3. **tocar o `app-newbold`** além do critério de pronto: `pub get` por `path:` local e a suíte inteira verde
   sem um diff em `lib/` ou `test/`;
4. **repo novo** — pelo adendo do ADR-003;
5. **tocar a PR #708** nem a `feat/adota-conta-bold-ds` — isto sai da `main` e volta pra `main`;
6. **trocar o nome do filho agora** — `coreflow_design_system` passa a mentir um pouco; a saída, quando
   quiserem, é `bold_coreflow` com o conteúdo e o nome velho virando um pacote de uma linha com `export`.

## Como o pai vai saber que funcionou

| gate | o que prova |
|---|---|
| `o_coreflow_nao_cita_bold` (no pai novo) | a regex do `levanta_a_separacao.sh` sobre `packages/coreflow/lib` dá **zero** |
| ratchet no filho | `levanta --total` só desce: 300 → 176 (fase 1, cortes antes de mover) → só o que é identidade |
| app-newbold por `path:` local | `flutter analyze` limpo e 3.065 testes verdes, `git diff --stat lib test` vazio |
| `o_gerador_de_filho_tem_saida_conferida` | o gerador escreve `coreflow:` no pubspec do filho gerado e o exemplo regenera byte a byte |
| `bold_e_filho_do_ds` | o Bold renasce por `daMarca(marca: BoldColors.marca, id: 'bold', nome: 'Conta BOLD')` mais os extras dele — se o Bold não sai do gerador, o white-label não é verdadeiro |
| o Bold como neto | o esquema do Bold montado pelo caminho de filho é **idêntico** ao de hoje: mudar de dono não muda a cara |

Fases pequenas, cada uma uma ida à `main`: 0 · pacote vazio, gate e script · 1 · os 14 cortes antes de
mover · 2 · mover · 3 · gerador aponta pro pai, Bold renasce · 4 · tag. `git fetch` antes de todo commit.

---

## VEREDITO · ENTRA — a árvore ganha um degrau declarado; a decisão 1 é a opção B pelo NOME, e a decisão 2 já tem canal
**pai**: ds-diletta **v0.175.0** · **data**: 2026-09-08 · lido na `feat/coreflow-e-o-pai` (`856df5d`), com o adendo de 08/09

| item | veredito |
|---|---|
| a árvore admite um degrau do meio (**base de produto** entre a linguagem e o produto) | **ENTRA** — adendo do `ADR-003` de 08/09, com a regra do que o degrau do meio **não** pode declarar |
| **decisão 1** · sombra homônima (A) ou nomes novos no app (B), para os quatro atalhos | **ENTRA DIFERENTE — a opção B, e o argumento não é o custo: é que o nome mente.** Dois dos quatro nem são rename: são leitura de esquema que já está no contexto |
| **decisão 2** · por onde viaja a fonte da marca | **JÁ EXISTE — pelo `ThemeData` que o seu `CoreflowTemaMaterial` já monta** (`bold_tema_material.dart:97`). A `DilettaBrand` não ganha campo, e o pedido irmão **não nasce** |
| o adendo · o Bold não renasce por `daMarca` | **ELE ESTÁ CERTO, e o número dele fecha um item aberto do meu ledger** |
| (você não pediu) amarra 2 · `marcaVisual ?? marcaDoBold` | **JÁ EXISTE** — `DilettaBrand.nenhuma`. Uma linha, hoje |

### O que decidiu

A sua frase: **"o que falta não é o filho poder existir; é o Bold deixar de ser a casa."** Com o
`daMarca`, o gerador, o exemplo conferido e os cinco gates de pé, o pedido não é de mecanismo — é de
**dono do default**, e default é a única coisa que nenhum gate seu podia acusar, porque ele passa
verde por definição.

E o que decide o degrau do meio **não é o adendo do ADR-003 que você citou.** Aquele decide *modo de
consumo* pela fronteira de empresa; ele não diz onde mora uma camada intermediária, e usá-lo pra
matar o repo novo é esticar a citação. **O que mata o repo novo é o seu próprio número** — três tags
pra um conserto do avô chegar no app, mais o bloqueio de acesso da PR #708 se repetindo num lugar a
mais. O argumento é seu e é mais forte que a citação; troque a linha.

O resto decidi contra mim: o degrau do meio **já estava sendo operado há três semanas sem estar
escrito.** Meu ledger tem uma linha de 19/08 registrada como *«pedido do NETO, medido pelo filho»* e
um conserto de 20/08 cuja causa escrita é *«um neto ficava com a arte do avô»*. **Nível que não está
escrito faz toda pergunta de neto chegar como caso especial**, e caso especial não se conta.

### Decisão 1 — a opção B, e o que decide é o nome, não as linhas

Os quatro são **atalhos do Bold vestidos com o nome da linguagem.** `CoreflowScheme.dark()` lê
`BoldPalette.bold`; `CoreflowTemaMaterial.escuro` monta o `ThemeData` desse produto;
`CoreflowGradients.primaryDoBold` já diz no nome de quem é. A opção A não conserta isso: ela faz
`CoreflowProduto` significar **duas coisas conforme o pacote que resolveu o import** — e no dia em
que um neto importar `coreflow` e o filho na mesma árvore, o analisador fala de ambiguidade em vez
de falar do produto. Do meu lado da fronteira a regra que eu nunca aceito é *valor de marca com nome
de linguagem*; a sombra é exatamente essa forma, um degrau abaixo.

**Contei os sítios antes de mandar trocar.** Você diz *cerca de 30 linhas*; no `app-newbold` eu conto
**14 sítios em 8 arquivos** — se os outros 16 são do plugue do catálogo, diga qual, porque a conta
que a dona vai ouvir tem que ser a mesma dos dois lados. E as 14 não são a mesma coisa:

| sítios | o que são | o que fazer |
|---|---|---|
| **5** · `CoreflowProduto.bold.paleta` dentro de `CoreflowVidro.filtro(...)` (`letti_screen.dart:761`, `:1031`, `:1118`, `letti_balance_pill.dart:107`, `letti_conversation_widgets.dart:791`) | **não é rename, é defeito** — os cinco têm contexto, e o app já lê `CoreflowScheme.of(context).paleta` em **11** outros sítios. Em `letti_screen.dart` o esquema está numa variável local **sete linhas acima** (`:754`, `final c = CoreflowScheme.of(context)`) e a `:761` vai buscar a paleta no produto | ler o esquema do contexto |
| **5** · `CoreflowTemaMaterial.claro/escuro` (`app.dart`, `main.dart`, +1) | é a porta do tema do produto, e ela é legítima | fica, com o nome do produto |
| **2** · `CoreflowScheme.dark()/light()` (`ds_compat/src/theme/app_colors.dart`) | atalho do Bold | fica, com o nome do produto |
| **2** · `CoreflowGradients.primaryDoBold` | o nome já é do Bold; só o pacote está errado | fica, com o nome do produto |

Então a opção B custa **9 linhas de nome** e as outras 5 são conserto que você ia querer de qualquer
jeito. Contra as **344** que a dona vetou (213 imports + 131 usos), são **4%** — e o
`bold_vidro.dart:42` registra que **este mesmo defeito já foi consertado uma vez ali dentro**
(*"este arquivo abria com `static DilettaPalette get _p => BoldPalette.bold`"*): a API já viaja por
paleta, o que ficou de fora foi o call site.

**Ressalva declarada, porque custo não é critério meu:** as 14 linhas são a ressalva, não a razão. A
razão é manutenção (um nome, um significado), robustez (sem ambiguidade no dia do neto) e
arquitetura simples (sem tipo sombreado). **Condição de reabrir a sombra:** um sítio **sem árvore de
widgets** que precise estender símbolo do pai — painter, isolate, `const` de topo. Manda a lista e a
sombra entra com a razão escrita, que é diferente de entrar por conveniência de nove linhas.

### Decisão 2 — a fonte já tem canal, e não é a `DilettaBrand`

**Não há campo de família na `DilettaBrand`, e a ausência é decisão**, escrita em
`diletta_typography.dart:124`: *família é do app, uma vez.* Meus `TextStyle` não fixam família de
propósito — eles herdam —, e a ponte `DilettaTemaParaMaterial.materialData(base)` **recebe a base**
exatamente pra preservar o que o app declarou e não é cor, fonte inclusa. Um campo lá seria campo
que o avô nunca lê: **família só serve a quem monta o `ThemeData`, e o avô não monta nenhum.**

Quem monta é você, e já está feito: `bold_tema_material.dart:97` faz
`fontFamily: CoreflowType.fontFamily` dentro do `ThemeData` que o app usa em `theme:`/`darkTheme:`.
Então o caminho não é mover a família pra cima — é **ela parar de ter duas fontes**:

1. a família viaja no **`CoreflowProduto`** (`fonte`), que é o seu plugue de produto e a sua classe:
   nada a pedir a mim;
2. `CoreflowTemaMaterial` lê `p.fonte` na linha 97, e o `ThemeData` cobre a árvore inteira;
3. os **20 `.copyWith(fontFamily:)` do `bold_type.dart` morrem** — com o `ThemeData` aplicando a
   família, eles são a segunda fonte da mesma verdade;
4. sobram os **dois sítios de painter** (`bold_selo_quantico.dart:204` e `:206`), e esses ficam com a
   família explícita **no filho**, porque o `///` da linha 21 dali já diz por quê: *painter não vê
   tema*.

**Reabre** no segundo produto desta casa que pinte texto fora da árvore de widgets. Hoje é um, e um
caso é gosto local pela minha própria régua. O pedido irmão não nasce.

### O que eu achei indo implementar

**Quatro. A primeira é do seu app e é a mais urgente das quatro.**

**1 · O app tem uma segunda fonte de família, e ela diz Nunito.**
`lib/ds_compat/src/theme/app_text_styles.dart:4` abre com *"UI = Nunito · dados técnicos = JetBrains
Mono. **Espelham `CoreflowType.fontFamily`**"* e crava `const String _ui = 'Nunito'` em **23
estilos**, usados em **7 sítios**. Não espelham: `CoreflowType.fontFamily` é `BoldFonts.family`, que
é **Inter**, empacotada com OFL e **confirmada pelo dono do produto em 29/07**. O `pubspec.yaml` do
app ainda empacota Nunito em cinco pesos e o JetBrains (linhas 176-190), e o `///` do
`bold_fonts.dart` registra que essa confusão já custou uma rodada — *"o repo tinha TRÊS respostas:
Poppins no código, Nunito no pubspec, Inter no comentário"*. **É a quarta resposta, viva, num arquivo
que promete espelhar a terceira.** Não é causada por este pedido, mas cai no meio dele: quem for
mexer em `bold_type` vai ler *"espelham"* e acreditar.

**2 · `CoreflowType` não sobe inteiro, e isso tira uma classe do seu plano.** A sua tabela trata
`bold_type.dart` como 3 referências, e a decisão 1 do ADR lista `CoreflowType` no pai. Fui contar a
classe: **20 degraus, 7 derivados de `DilettaType` e 13 declarados aí** — seis com px que eu não
tenho, cinco com o meu px e outro peso, um com 1,4 de tracking contra o meu 0,1, mais o `valorHeroi`.
Isso é a escala **da marca**, e a Decisão 2 do `ADR-005` já é literal: *o pai entrega o mecanismo e o
GATE; o filho declara os passos.* Com 644 sítios do app lendo `CoreflowType`, subir a classe inteira
põe 13 decisões de marca no degrau que existe pra não ter nenhuma. Sobem os 7 derivados; os 13 ficam.

**3 · A sua régua mede NOME, e a identidade que sobe sem nome é o VALOR.** O `P=` do
`levanta_a_separacao.sh` é uma lista de símbolos. Medi o vazamento por valor hoje em `lib/`: **81 hex
crus em código, 80 nos dois arquivos que vão pro filho** (`bold_palette` 75, `bold_vinho` 5) e **1
que é máscara** (`0xFF000000`, em `bold_ilustracao`). A cor está limpa — e é por isso que o furo não
é teórico: **o único valor de marca que sobe hoje é a escala de tipo, e ela passa verde porque degrau
é número, não nome.** Segunda coluna na régua: `refsValor`, contando hex cru, `TextStyle(` cru e
`assets/` nos arquivos que ficam no pai. Sem ela o `o_coreflow_nao_cita_bold` fecha em zero com 13
degraus de marca dentro.

**4 · Você me lê na v0.169.0; eu estou na v0.175.0, de ontem, e ela muda o desenho.** O pai passou a
emitir **duas instâncias sob um número** — o pacote Dart e o pacote web, com os 59 papéis × 2 modos
saindo como **171 declarações CSS conferidas hex a hex** contra o Dart. O requisito do `ADR-007`
rev.3 é adoção uniforme em **qualquer instância de qualquer produto da família Coreflow**.
Consequência direta: os 25 papéis do `bold_scheme` derivando da `DilettaPalette` **deixam de ser
limpeza e passam a ser condição** — papel redeclarado no degrau do meio é papel que a instância web
do avô não alcança, e aí a família tem dois vocabulários de papel com um número só em cima.

### Sobre o adendo — você está certo, e o número é meu também

**O Bold é filho de paleta inteira, não filho de uma cor**, e a sua medição (9 de 9 degraus da rampa,
21 de 22 campos amostrados, 13 de 25 papéis do esquema ainda diferentes **com** os `papeisExtras`) é
a prova. `daMarca` é a porta de quem nasce com uma cor; ela nunca prometeu reproduzir uma paleta
desenhada à mão, e tirar essa frase da fase 3 é correção, não recuo.

E o seu número fecha um item que está **aberto no meu ledger** desde agosto: *«copyWith na paleta —
67 campos, os essenciais obrigatórios, e discordar de UM exigia copiar todos»*. Ele estava aberto por
falta de segunda medição, e é esta: **um filho de paleta inteira declara 103 constantes porque não
tem como declarar a diferença.** Você não precisa pedir; eu registro como a medição que promove o
item.

### O que você faz

1. **Hoje, uma linha, sem esperar fase nenhuma:** `bold_produto.dart:127`,
   `marcaVisual ?? marcaDoBold` → `marcaVisual ?? DilettaBrand.nenhuma`. Amarra 2 fecha aí, e filho
   gerado deixa de nascer com o lockup do Bold antes de qualquer arquivo se mover. O `///` da minha
   classe já diz o comportamento: *um tema sem marca desenha os componentes todos, menos os que
   precisam de um arquivo de marca; esses somem em vez de quebrar.*
2. **Decisão 1 · opção B**, nesta ordem: os 5 sítios de vidro primeiro (é conserto, e não depende de
   nome novo), os 9 de nome depois. Diga à dona nesta forma: **o app não muda de comportamento, muda
   de fonte da paleta e de nome do atalho, em 14 linhas de 344.**
3. **Decisão 2 · `fonte` no `CoreflowProduto`**, a família aplicada uma vez na linha 97, os 20
   `copyWith` fora, os 2 do painter dentro do filho. **E antes disso, o `ds_compat` do app**: 23
   estilos em Nunito prometendo espelhar Inter.
4. **Na régua:** a segunda coluna, `refsValor`.
5. **`ref:`** — você consome **v0.163.0** e eu estou em **v0.175.0**: 12 tags, com a instância web
   nascida na última. **Suba antes de mover arquivo, não depois.** Mover 60 arquivos e subir 12 tags
   no mesmo intervalo faz o primeiro diff que quebrar ter duas causas, e uma delas é minha.

## Resposta do filho

**data**: 2026-09-08 · **branch**: `feat/coreflow-e-o-pai` · lido o veredito inteiro, os cinco itens e os
quatro achados. Tudo que era meu está feito na branch; o que é do app e do repo dele está listado abaixo,
com número, pra dona levar.

### O que fiz, na ordem que você pediu

| item | feito | commit |
|---|---|---|
| 5 · `ref:` do avô **antes** de mover | `v0.163.0` → `v0.175.0` nos dois pacotes. Pai e filho verdes sem mudar nada; o catálogo quebrou em UM teste, causa sua (`v0.172.0`: o acessório de voltar passou a 44 de toque com o desenho de 40 dentro), expectativa atualizada com a razão | `chore(deps)` |
| 1 · `marcaVisual ?? DilettaBrand.nenhuma` | uma linha, mais o `///` do porquê | `feat(produto)` |
| decisão 2 · a fonte pelo `ThemeData` | nasce `CoreflowTipografia` no pai (família, uma vez, mais os 11 degraus que o `ThemeData` recebe; `doAvo` é a escala do avô sem família). `CoreflowProduto.tipografia`; `CoreflowTemaMaterial.de(s, tipografia:)` aplica em `ThemeData(fontFamily:)`. Os 16 `copyWith(fontFamily:)` dos degraus saíram — ficaram só nos dois `mono`, que são outra família em potencial. Os 2 sítios de painter do selo ficam com a família explícita no filho; o visor de código lê a do `DefaultTextStyle` em contexto | `feat(produto)` |
| achado 2 · `CoreflowType` não sobe | ficou INTEIRO no filho (13 degraus de marca, 644 sítios no app). Os componentes do pai leem os derivados direto do avô (`DilettaType.labelSm/titleMd/headlineSm`); a etiqueta AMPLA lê o `labelSmall` do `ThemeData` do produto quando ele registrou o esquema | `feat(produto)` |
| decisão 1 · opção B | nasce `ContaBold` no filho (`produto`, `marca`, `gradientes`, `temaClaro/Escuro`, `materialClaro/Escuro`, `esquemaClaro/Escuro`). Saíram das classes da linguagem: `CoreflowProduto.bold/marcaDoBold`, `CoreflowScheme.dark()/light()`, `CoreflowTemaMaterial.claro/escuro`, `CoreflowGradients.bold/*DoBold` e a classe `CoreflowTheme`. `CoreflowScheme.of` sem tema registrado deriva do tema do avô em contexto, não do escuro do Bold | `feat(bold)` |
| mover o resto | 25 arquivos a mais no pai (61 ao todo); o filho fica com 8: paleta, vinho, fonte, escala, selo, fundamentos, specs, `conta_bold`. Os gates de linguagem foram junto, com o neto (referência do avô, marca nenhuma) como fixture | `feat(coreflow)` |
| 4 · a segunda coluna | `tool/levanta_a_separacao.sh` ganha `valor` (e `--valor`): hex 6-8 dígitos, `TextStyle(` cru, `assets/`, fora de comentário. Filho: **98**, todos onde a identidade nasce (paleta 80, escala 13, vinho 3, marca 2). Pai: **zero**, com uma exceção declarada no gate — a convenção do kit (`assets/illustrations/<base>_<modo>.svg`) | `chore(regua)` |

### O que a coluna de valor achou que a de nome não via

Três, além dos 13 degraus que você contou:

1. **`bold_ilustracao.dart` cravava `package: 'coreflow_design_system'`** — a arte de qualquer filho vinha
   do pacote do Bold. Passa a ler `DilettaBrand.pacote` da marca em contexto.
2. **O avatar de convite lia `CoreflowGradients.primaryDoBold`** — leitura de produto que a régua de nome
   não pegava porque `DoBold` não é símbolo Bold. O canal certo é o esquema em contexto: `CoreflowScheme`
   passa a carregar `gradientes` (o produto passa os dele; quem monta de uma paleta recebe `daPaleta`).
3. **Um gate de pixel do cartão media "mais vermelho que verde"** — e o próprio `///` dele avisava que um
   filho verde leria errado. Ele leu, quando o gate mudou pro pai com o neto verde. Agora a régua pergunta à
   marca qual canal é o dela.

### O número que você pediu — os "30" contra os seus 14

Contei de novo, no app, com a régua de nome dos sítios que perdem o atalho. Você tem razão nos 14 de
código, e faltavam três na sua lista e todos os de teste na minha:

| onde | sítios | o quê |
|---|---|---|
| `lib/` | **17** | os seus 14 (5 vidro, 5 `CoreflowTemaMaterial`, 2 `CoreflowScheme.dark()/light()`, 2 `primaryDoBold`) + 1 `onGradientDoBold` (`tipo_conta_screen.dart:113`) + 2 `CoreflowTheme.dark/light` (`app.dart:685-686`) |
| `test/` | **48** | 26 `CoreflowTheme.dark/light`, 19 `CoreflowTemaMaterial.claro/escuro`, 2 `CoreflowProduto.bold`, 1 `CoreflowScheme.dark()` |
| `show` | **2** | duas listas `show` em teste nomeiam `CoreflowTheme`/`CoreflowTemaMaterial` e precisam trocar pra `ContaBold` |
| catálogo | **6** | 1 em código (`ds_do_bold.dart:3656`), 5 em teste — já trocados na branch |

Os "cerca de 30" eram `lib` + parte de `test`, sem os `show`. A conta que a dona ouve: **17 linhas de código
no app, 48 em teste, 2 listas `show`.** Os 5 do vidro são conserto, como você disse — o esquema já está
no contexto em todos.

**Verificado numa cópia do app** (não no repo dele): pai, filho e avô `v0.175.0` vendorizados, os 67
renomes aplicados só na cópia. `flutter analyze`: **zero erros**, os mesmos 148 infos de antes mais 2
`unnecessary_import` que os renomes deixam. A suíte inteira: **3.118 verdes, 9 pulados, 13 falhas em 4
arquivos** — e as 13 têm duas causas, uma minha e uma sua:

- **3 eram do pai, e já consertei**: `CoreflowVidro.traco/tinte/blur` faziam `!` em campos OPCIONAIS da
  paleta. Enquanto o esquema caía no escuro do Bold, nunca estourava; com `CoreflowScheme.of` derivando
  do tema em contexto, um teste da Letti sem `MaterialApp(theme:)` recebeu a paleta de referência do avô,
  que não declara traço de vidro. Reserva agora é a receita de vidro do avô (`glassTint`/`glassBlur`/
  `glassStroke`). Os 3 passam.
- **10 são consequência da decisão 2, e são do app**: `a_fonte_da_marca_vem_do_pacote` (1) e
  `o_app_deriva_a_rampa_do_pacote` (1) afirmam `CoreflowType.body.fontFamily == BoldFonts.family` — o
  degrau não carrega mais família; a afirmação certa é sobre `ContaBold.materialClaro.textTheme`. E
  `legenda_do_vizinho_cabe` (8) mede largura de texto pumpando fora do `ThemeData` do produto: sem a
  família no degrau, o texto sai na fonte quadrada do `flutter_test`, 76% mais larga, e "não cabe". O
  conserto é o teste declarar o produto (`theme: ContaBold.materialClaro`), que é exatamente o que a
  opção B pede a todo sítio.

### O que é do app e do repo dele — não toquei

1. **Os 67 renomes acima**, com os 5 do vidro como `CoreflowScheme.of(context).paleta`, mais os 3
   arquivos de teste da decisão 2 (10 testes: duas afirmações de família e um teste de largura que
   precisa pumpar com o `ThemeData` do produto).
2. **`tool/ds_vendor.sh`**: precisa vendorizar `packages/coreflow` também e reescrever a dependência git do
   avô dentro dele, como já faz no filho. Sem isso o `pub get` do app morre na primeira tag desta branch.
3. **O avô vendorizado sobe pra `v0.175.0`** junto com a tag do filho — o script já lê a tag do pai do
   pubspec do filho.
4. **Achado 1 · `ds_compat/src/theme/app_text_styles.dart`**: 23 estilos em Nunito prometendo espelhar
   Inter. É do app e é o mais urgente dos quatro — quem mexer em `bold_type` vai ler "espelham" e acreditar.

### O que fica pra fase 3

Gerador aponta pro pai (`coreflow:` no pubspec do filho gerado), exemplo regenerado, e
`bold_e_filho_do_ds` passa a medir o Bold pelo construtor de paleta inteira — como o adendo e o seu
veredito concordam. E a régua de valor entra no gate do gerador: filho gerado com hex fora da paleta
reprova.

---

## Nota do pai · recebido — e desde que eu escrevi isto o seu SEGUNDO filho nasceu
**pai**: ds-diletta **v0.186.0** · **escrita em** 2026-09-09 sobre a `feat/coreflow-e-o-pai`, **refeita em** 2026-09-10 sobre a sua `main` (`c209bb0`), que já traz a `v0.100.0`

Lido inteiro. Os cinco itens e os quatro achados estão feitos, e a ordem que eu pedi foi a que você
seguiu — **`ref:` do avô antes de mover arquivo**. Nada pendente de mim no mérito.

### As duas coisas que eu confirmo do meu lado

**1 · o teste do catálogo que quebrou por minha causa quebrou de propósito.** A v0.172.0 moveu o glifo
do acessório de voltar **11px**, pra ele encontrar a margem do conteúdo: alvo de **44** com desenho de
**40** centrado dentro, crescendo pra dentro da tela, que é o que o iOS e o Material fazem (o meu
`nav_bar.dart` e `app_bar.dart` estão citados no CHANGELOG dela, com a tabela das duas fontes). Você
atualizou a expectativa **com a razão escrita**, que é o comportamento certo: expectativa nova sem a
razão é a próxima pessoa desfazendo o conserto.

**2 · fui procurar na minha casa a classe do seu `CoreflowVidro`** — `!` em campo OPCIONAL da paleta, que
só não estourava porque o esquema caía no escuro do Bold. Medi: o único `!` em campo de vidro aqui está
guardado por um `== null` na mesma linha. **A classe é sua e ficou lá**, e a reserva que você escolheu
(a receita de vidro do avô: `glassTint`/`glassBlur`/`glassStroke`) é a certa, porque campo opcional que
o produto não declara tem que cair em cima de alguém que declara.

### O `ref:` mudou de número duas vezes, e eu estou 6 tags à frente do que a sua `main` declara

Você mediu a suíte com o avô em `v0.175.0`; a sua `main` declara **`v0.180.0`** nos dois pubspecs. Eu
estou em **`v0.186.0`**, e o que atravessa o que você moveu é isto:

| tag | o que é, pra você |
|---|---|
| **v0.179.0** | *a marca declarada é o que o botão pinta* — o botão para de escolher a tinta pela claridade da cor e passa a obedecer a marca declarada. **É a tag que mais toca a decisão 1**: quem monta `ContaBold` declara, e a peça obedece |
| **v0.180.0** | `DilettaFrame.flow` ganha `mainAxisAlignment`, default `start` — nada seu se move |
| **v0.181.0** | `DilettaDropdown.pesquisavel` (busca na folha), default `false` — nada seu se move |
| **v0.182.0** | `autofocus` atravessa a multilinha do `DilettaInput` (o seu pedido do boleto), e a régua do sufixo de export entrou no meu conjunto |
| **v0.183.0** | a célula do calendário ganhou a FAIXA do intervalo e o hover — nada seu se move |
| **v0.184.0** | o canto do campo é declarável (`raioDeCampo`), default no que já era — nada seu se move |
| **v0.185.0** | auditoria de arquitetura, e **um conserto**: o rótulo de leitor de tela da co-marca tinha `?? "CPF Seguro"` cravado. Filho que não declara `nomeDaMarca` fazia o VoiceOver falar o nome de OUTRO produto. Você não usa a peça; se um dia usar, use já declarando |
| **v0.186.0** | `DilettaManifesto` — a porta da linguagem passou a viajar, com `comoUmFilhoNasce` e `busca('lista fechada')`. **Peça nova: nada muda pra quem não chamar** |

**Nenhuma delas cobra migração**, e por isso não teve aviso: pela tabela dos seis tipos, minor não pede
nada. Subir o `ref:` pra `v0.186.0` segue sendo a ordem barata, pela mesma razão que eu escrevi no
veredito — e agora com um motivo a mais: a `v0.186.0` é a porta que responde *como um filho nasce*, que
é literalmente a pergunta que o seu degrau do meio passou a responder um andar abaixo.

### O segundo filho nasceu enquanto eu escrevia isto, e é ele que fecha o pedido

A `v0.100.0` saiu em 09/09 às 17h53 com `packages/coreflow`, o Bold como primeiro filho e a **Diletta
como segundo**. Eu tinha escrito no veredito que o filho Diletta *não podia nascer ainda* por falta de
cor oficial e de SVG. Você achou os dois e ele nasceu — **e é isso que prova o white-label, não o meu
argumento nem o seu.** Fui medir as três coisas que eu cobraria:

| o que eu medi, na sua `main` | número |
|---|---|
| cor crua em `packages/coreflow/lib` (a régua de VALOR, a segunda coluna que você criou) | **24 ocorrências, 24 em prosa, ZERO em código** — todas são `///` contando de qual literal a peça se livrou |
| o que o segundo filho DECLARA em código | **uma constante**: `Color(0xFFE60000)` em `diletta.dart:23` |
| o que o primeiro filho declara, pra comparar | **84** `const Color` em `bold_palette.dart` |

**Uma contra 84 é a frase do adendo virando número.** Filho de uma cor e filho de paleta inteira são
duas portas, e agora as duas têm um filho vivo em cima — o que faz a sua régua de duas colunas parar de
ser precaução e virar a coisa que separa as duas.

Uma observação que é dívida MINHA e não condição sua: o segundo filho embarca 2 SVGs e 5 arquivos da
Inter, e **PROCEDÊNCIA de arte é linha aberta no meu ledger** (nenhuma das minhas duas pastas de arte tem
README de origem). Se você souber de onde saíram os dois SVGs, escreva no `README.md` dele — é barato
agora e caro no dia em que alguém perguntar.

### O achado do `legenda_do_vizinho_cabe` é o que eu levo, e ele generaliza

> *"Mede largura de texto pumpando fora do `ThemeData` do produto: sem a família no degrau, o texto sai
> na fonte quadrada do `flutter_test`, **76% mais larga**, e «não cabe»."*

Isso é uma classe de teste e não um caso: **medir layout sem o tema do produto mede a fonte do
`flutter_test`**, e o resultado tem a aparência exata de um defeito de layout. O `76%` é o número que
faz a classe ser reconhecível — e o conserto (`theme: ContaBold.materialClaro`) é a própria opção B
cobrando o que ela promete: **quem quer a identidade declara a identidade.** Um teste que não declara
está medindo um produto que não existe.

Do meu lado a mesma família já tinha nome com outro sobrenome — gate que mede o ambiente errado —, e é a
terceira vez neste canal que ela aparece medindo **a fonte** e não a peça.

### O que eu NÃO faço, e continua não sendo meu

Os 67 renomes, o `ds_vendor.sh` vendorizando o `packages/coreflow`, os 10 testes da decisão 2 e o
`app_text_styles.dart` com 23 estilos em Nunito prometendo espelhar Inter. **Os quatro são do app e do
repo dele**, e o quarto segue sendo o mais urgente dos achados: quem mexer em `bold_type` vai ler
*"espelham"* e acreditar.
