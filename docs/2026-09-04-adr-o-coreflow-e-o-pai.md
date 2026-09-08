# ADR · O Coreflow é o pai, e o Bold é o primeiro filho — sem retrabalhar o app

**Data:** 2026-09-04 · **Estado:** proposto · **Branch:** `feat/coreflow-e-o-pai` · **Quem pediu:** Agatha
Pedroso · **Quem decide:** o dono do DS.

## A pergunta

*"Dá pra fazer o Coreflow ser o pai de todos os filhos, inclusive do Bold, sem retrabalhar o Bold de
maneira onerosa?"*

Dá. E a resposta tem um truque só: **quem se move é a base, não o Bold.** O pacote que o app já
importa continua existindo com o mesmo nome, o mesmo `path:` e os mesmos símbolos, e vira o filho. O
pai novo nasce ao lado dele. O app não muda uma linha de código.

## O que existe hoje, medido (04/09, `v0.98.1`)

O pacote `coreflow_design_system` é duas coisas coladas:

| o que | quanto |
|---|---|
| componentes `Coreflow*` (a base white-label) | 50 classes públicas em 60 arquivos |
| identidade do Bold | `BoldColors`, `BoldPalette`, `BoldSeloQuantico`, `BoldSeloEstado`, `BoldFonts`, `BoldVinho`, `CoreflowProduto.marcaDoBold`, `hexesDaArte`, 1 logo, 16 ilustrações, 5 arquivos da Inter |
| referências ao Bold dentro de `lib/` | **300**, em 33 dos 66 arquivos (`bash tool/levanta_a_separacao.sh --total`): 176 no que É do Bold, 109 em 14 componentes que leem constante do Bold, 15 em comentário |
| arquivos com nome `bold_*.dart` que definem classes `Coreflow*` | 65 — dívida de NOME, não de código |
| testes que citam o Bold | 49 dos 57 |
| como o app consome | `coreflow_design_system` por tag, `path: packages/coreflow_design_system`, 213 arquivos importam, 131 usos de `Bold*` em 22 arquivos, 68 símbolos `Diletta*` chegando pelo barrel |
| como o catálogo consome | `path: ../coreflow_design_system`; 20 referências a `Bold*` em 4 arquivos do plugue |

**O mecanismo de filho já existe e está provado.** Desde 20/08: `CoreflowProduto.daMarca(marca, id,
nome)`, o gerador `bin/novo_filho.dart`, a saída conferida em `exemplos/filho_do_coreflow/` e cinco
gates (`o_neto_troca_a_paleta_e_pronto`, `o_neto_monta_o_tema_inteiro`, `o_pacote_nao_crava_a_paleta_do_bold`,
`um_filho_nasce_com_uma_cor`, `o_vinho_de_um_filho_e_dele`). Um banco novo já veste o Coreflow inteiro com
uma cor. O que falta não é o filho poder existir — é o Bold **deixar de ser o default** da base.

**O que faz o Bold ser o pai hoje**, em cinco amarras:

1. **Default.** `CoreflowTheme.light/dark` → `CoreflowProduto.bold`; `CoreflowTheme.marca = marcaDoBold`.
2. **Logo herdado.** `daMarca(... marcaVisual ?? marcaDoBold)`: filho sem logo nasce com o lockup do Bold.
3. **Marca empacotada na base.** Logo, ilustrações, fonte, `hexesDaArte`, selo quântico, paleta.
4. **Constantes lidas por componente.** 14 arquivos `Coreflow*` leem `BoldColors.x`, `BoldVinho.x`,
   `BoldPalette.bold` ou `CoreflowProduto.bold` em vez do esquema em contexto.
5. **A marca Diletta não existe.** O pai `ds-diletta` não empacota logo (`DilettaBrand.nenhuma` aponta pra um
   arquivo que ele não tem) e a paleta default dele é uma rampa verde de exemplo. **Fora do escopo deste ADR** —
   entra depois, como um filho `diletta_coreflow`, quando a cor e os SVGs existirem.

## A decisão

### 1 · Nasce `packages/coreflow` — o pai

Só o que é linguagem de produto sem produto: os componentes `Coreflow*`, contratos, `CoreflowScheme`,
`CoreflowType`, `CoreflowRadius`, `CoreflowGradients` (a forma, não os valores), `CoreflowProduto` com o
`daMarca`, `CoreflowIlustracao` (lendo o kit **do produto**, por `DilettaBrand.pacote`). Depende de
`diletta_design_system` por tag e o re-exporta, como hoje.

**Gate de nascimento:** `o_coreflow_nao_cita_bold` — a mesma regex de `tool/levanta_a_separacao.sh` sobre
`packages/coreflow/lib` tem que dar **zero**. Nasce vermelho com o número do dia e só fecha em zero; é
ratchet, não meta.

### 2 · `packages/coreflow_design_system` MANTÉM O NOME e vira o filho Bold

Depende de `coreflow` por `path:` (mesmo monorepo, mesma tag) e o barrel faz
`export 'package:coreflow/coreflow.dart'`. Fica com o que é do Bold:

- `bold_palette.dart` (`BoldColors`, `BoldPalette`), `bold_vinho.dart` (`BoldVinho` — a marca escurecida é
  do Bold, gate `o_vinho_de_um_filho_e_dele`), `bold_fonts.dart` (`BoldFonts`), `bold_selo_quantico.dart`
  (a peça de autorização é deste produto; seu contrato sai de `bold_contratos.dart` e vem junto);
- a metade Bold de `bold_produto.dart`: `marcaDoBold`, `bold`, `hexesDaArte`, `nome: 'Conta BOLD'`;
- `CoreflowTheme` e `TelaDeExemploBold` do barrel — são atalhos do Bold, e ficam onde o app já os lê;
- `assets/logos/conta-bold-lockup.svg`, `assets/illustrations/` (16), `assets/fonts/` (Inter + OFL).

**`CoreflowProduto.bold` continua compilando no app** sem o pai saber do Bold: o barrel do filho exporta
o pai com `hide CoreflowProduto` e declara `class CoreflowProduto extends coreflow.CoreflowProduto`
redeclarando os dois construtores (`CoreflowProduto(...)`, `daMarca(...)`) e adicionando `static final bold`
e `static const marcaDoBold`. O tipo do filho **é um** `coreflow.CoreflowProduto`, então todo componente do pai
o aceita. É sombra homônima, e fica escrito aqui de propósito: quem ler `CoreflowProduto` no app está lendo o
do filho.

### 3 · O app não muda

| no `app-newbold` | muda? |
|---|---|
| `pubspec.yaml`: `coreflow_design_system` · `git:` · `path: packages/coreflow_design_system` | só o `ref:` na tag seguinte, como todo bump |
| 213 arquivos com `import 'package:coreflow_design_system/…'` | não |
| 131 usos de `BoldColors`, `BoldSeloQuantico` etc. em 22 arquivos | não — continuam no filho |
| `CoreflowTheme.light/dark` no `app.dart`, `CoreflowProduto.bold` (5) | não — ficam no filho |
| 68 símbolos `Diletta*` via barrel | não — o filho re-exporta o pai, que re-exporta o avô |
| gates e `tool/inventario_de_adocao.dart` (procuram a string `coreflow_design_system`) | não |

**Critério de pronto do app:** `flutter pub get` apontando o `path:` local para o filho desta branch,
`flutter analyze` limpo e a suíte inteira verde (3.065 testes na ponta de 03/09) **sem um diff em `lib/` nem
em `test/`**.

### 4 · O catálogo não muda agora

Depende do filho por `path:` e continua. O plugue Diletta, que mostra o Coreflow vestido de Diletta, é o
passo seguinte e depende da marca existir (amarra 5).

### 5 · O gerador aponta pro pai

`bin/novo_filho.dart` passa a escrever `coreflow:` no pubspec do filho gerado (hoje escreve
`coreflow_design_system:`), e `exemplos/filho_do_coreflow/` é regenerado — o gate
`o_gerador_de_filho_tem_saida_conferida` cobra byte a byte. Um filho novo depende **só do pai**, nunca do Bold.
O Bold vira o primeiro filho gerado: o teste de honestidade do white-label é o `bold` renascer por
`daMarca(marca: BoldColors.marca, id: 'bold', nome: 'Conta BOLD')` mais os extras dele, e o gate
`bold_e_filho_do_ds` passa a medir isso.

## Os 14 cortes — onde mora o trabalho (109 referências)

Tudo que é `Coreflow*` e ainda lê constante do Bold. A técnica é uma só, e o próprio código já a usa em
`bold_background.dart:227` (*"a paleta vem do ESQUEMA, não da const deste produto"*): trocar a constante pela
leitura do esquema/paleta em contexto, ou receber pelo produto.

| arquivo (pai) | refs | o que lê do Bold | corte |
|---|---|---|---|
| `bold_scheme.dart` | 25 | `BoldColors.superficie*`, `fluxoSecundario*`, `BoldVinho` | os papéis viram derivados da `DilettaPalette` do produto (`daMarca` já deriva superfície e vidro); `fluxoSecundario` escuro deixa de ser o vinho |
| `bold_etiqueta.dart` | 21 | `BoldColors.success04/05`, `error04/05`, `warning04` | semântica é **invariante do avô**: ler `DilettaPalette.success04`… do esquema |
| `bold_gradients.dart` | 21 | `BoldPalette.bold`, `BoldColors.lockup01/02` | `CoreflowGradients` guarda a FORMA; os valores vão pro `CoreflowProduto(gradientes:)` do filho — a lacuna "gradiente do lockup herda o do Bold" do Berço fecha aqui |
| `bold_tema_material.dart` | 5 | `BoldColors.error04`, `BoldColors.of(context)` | `ThemeData` monta do produto; a extensão `.of(context)` vai pro filho |
| `bold_vidro.dart` | 5 | `BoldVinho`, `BoldPalette` | tinta do vidro derivada da paleta do esquema |
| `bold_background.dart` | 4 | `BoldVinho.marcaDe(p)` | `marcaDe` é derivação da paleta: sobe pro pai com nome neutro (`CoreflowMarca.de(p)`) |
| `bold_linha_de_aviso.dart` | 3 | `BoldVinho` | idem |
| `bold_cartao.dart` | 3 | `CoreflowProduto.bold.paleta` | **a única leitura direta do produto Bold em componente**: ler a paleta do esquema em contexto |
| `bold_lista.dart`, `bold_pontos_de_pagina.dart`, `bold_visor_de_codigo.dart`, `bold_fundamentos.dart` | 1–2 | `BoldColors`/`BoldPalette` avulsos | esquema em contexto |
| `bold_type.dart` | 1 | `static String fontFamily = BoldFonts.family` | a família vem do produto (`DilettaBrand`/`CoreflowProduto.fonte`); o pai não nomeia fonte de marca |
| `bold_contratos.dart` | 2 | contrato do `BoldSeloEstado`, "Conta BOLD" | o bloco do selo vai pro filho junto com a peça |

Os outros 13 arquivos, com 15 referências, são **"Conta BOLD" em comentário de doc**: não bloqueiam o gate de código,
mas o gate conta a string inteira de propósito — corrigir o comentário é parte de o arquivo mudar de casa.

**Testes.** 49 de 57 citam o Bold. Regra de partição: teste de componente fica no pai e usa um
**produto-fixture** (o "neto" que `o_neto_monta_o_tema_inteiro` já monta, uma cor que não é a do Bold); teste de
identidade (`o_selo_quantico`, `dois_gradientes_e_so`, `bold_e_filho_do_ds`, `a_rampa_e_legivel_em_const` sobre a
paleta) vai pro filho. Nenhum teste é apagado.

## O que NÃO se faz aqui

- **Renomear os 65 `bold_*.dart`.** É mecânico e ruidoso; outro dia, outra PR, sem lógica junto.
- **Criar a marca Diletta.** Insumo de marca (cor oficial, SVGs de logo) que não existe em código nenhum.
- **Tocar `app-newbold`** além do critério de pronto (pub get + suíte por `path:` local, sem diff).
- **Tocar `feat/adota-conta-bold-ds`** nem a PR #708. Esta branch sai da `main` e volta pra `main`.
- **Trocar o nome do filho.** `coreflow_design_system` passa a mentir um pouco. A saída, quando quiserem, é barata
  e não toca o app: nasce `bold_coreflow` com o conteúdo e `coreflow_design_system` vira um pacote de uma linha que
  só faz `export`. O app segue compilando até uma PR puramente mecânica de imports.

## Fases, cada uma com o que a prova

| fase | o que | prova |
|---|---|---|
| 0 | `packages/coreflow` vazio + gate `o_coreflow_nao_cita_bold` + `tool/levanta_a_separacao.sh` | gate nasce vermelho com o número; script reproduz a tabela deste ADR |
| 1 | os 14 cortes, no pacote atual, **antes de mover** | `levanta --total` cai de 300 para 176 (só o que vai pro filho; os 15 de comentário somem junto); as duas suítes verdes; app verde por `path:` |
| 2 | mover os componentes pro pai; filho fica com identidade + `ContaBold` (opção B do veredito de 08/09: **sem sombra** — 17 linhas de código e 48 de teste no app trocam de nome) | gate do pai em zero nas DUAS colunas (nome e valor); suíte do filho verde; app verde numa cópia com os renomes |
| 3 | gerador aponta pro pai; exemplo regenerado; o Bold monta o tema pelo construtor de paleta INTEIRA (o adendo de 08/09 derrubou o `daMarca` como caminho dele) | `o_gerador_de_filho_tem_saida_conferida`, `bold_e_filho_do_ds` |
| 4 | tag do monorepo; CHANGELOG diz o que muda (nada) para quem consome o filho | app sobe o `ref:` num commit de uma linha |

Cada fase é uma PR pequena pra `main`. O Hunter trabalha na `main` em paralelo: `git fetch` antes de todo
commit, e commits pequenos.

**Estado em 08/09:** fases 0, 1 e 2 feitas na branch (veredito ENTRA em `bd1730a` na main; resposta do
filho no arquivo do pedido). Régua de nome em 148 e de valor em 98, todos no filho; pai em zero nas duas.

## Riscos, ditos

- **A sombra homônima de `CoreflowProduto`.** Dois tipos com o mesmo nome em pacotes diferentes. Mitigação: o
  do filho **estende** o do pai (é-um), e este ADR registra. Alternativa, se o dono preferir: trocar 5 linhas no
  app (`CoreflowProduto.bold` → `produtoBold`) e não ter sombra.
- **`fluxoSecundario` escuro e o gradiente do lockup** mudam de dono. Se o filho não os redeclarar, o Bold muda
  de cara. Prova: golden ou comparação de esquema Bold antes/depois no gate `o_neto_troca_a_paleta_e_pronto`
  invertido (o Bold como neto tem que dar o MESMO esquema de hoje).
- **A regex do gate** pode deixar passar um nome novo. O gate lista o que procura, e a lista é conferida contra
  os símbolos públicos do filho: símbolo do filho que não está na regex reprova.

## Como reproduzir os números

```sh
cd packages/coreflow_design_system
bash tool/levanta_a_separacao.sh            # tabela por arquivo
bash tool/levanta_a_separacao.sh --total    # 300 em 04/09
grep -rlE 'BoldColors|BoldPalette|BoldSelo|BoldFonts|BoldVinho|marcaDoBold|CoreflowTheme\.' test | wc -l   # 49
```

No app: `rg -l 'package:coreflow_design_system' lib | wc -l` (213) e
`rg -o '\bBold(Colors|Palette|SeloQuantico|SeloEstado|Vinho)\b' lib | wc -l` (131).

## Adendo de 08/09 — o que a fase 1 mediu, e uma premissa que caiu

Fase 0 e fase 1 estão na branch (`45e12ff`): a régua foi de **300 para 164**, e a foto do Bold
(`o_esquema_do_bold_nao_mudou`, 210 valores) segue verde. Duas medições novas, feitas depois dos cortes.

### 1 · O grafo de imports diz onde o veredito trava

Sobre os 68 arquivos de `lib/src`, com a régua do script e os imports transitivos dentro do pacote:

| classe | quantos | o que são |
|---|---|---|
| zero na régua e só importam zero — **movíveis hoje** | 36 | `bold_background`, `bold_botao`, `bold_rodape`, `bold_saldo`, `bold_contratos`, `coreflow_vinho`, `coreflow_vocabulario`… |
| zero na régua, **travados** por importar arquivo com Bold | 23 | 14 via `bold_scheme.dart`; 6 via `bold_scheme` + `bold_type`; 1 via `bold_gradients`; 1 via `bold_type`; 1 via `bold_selo_quantico` |
| com Bold | 9 | `bold_palette` 103, `bold_selo_quantico` 23, `bold_produto` 12, `bold_gradients` 4, `bold_type` 3, `bold_fonts` 2, `bold_fundamentos` 2, `bold_scheme` 2, `bold_vinho` 1 |

Os dois gargalos são exatamente as duas decisões do pedido: **`bold_scheme.dart`** (2 referências, os
atalhos `dark()`/`light()` que leem `BoldPalette.bold`; **19 arquivos** o importam) e **`bold_type.dart`**
(3 referências, `fontFamily = BoldFonts.family`; 6 o importam). Com o veredito 1 os atalhos viram sombra
e destravam 14 + 1; com o veredito 2 a fonte muda de canal e destravam os outros 7. Não há terceiro nó.

### 2 · O Bold NÃO renasce por `daMarca` — a fase 3 muda de enunciado

A decisão 5 e a linha 3 da tabela de fases dizem que o Bold renasce por `daMarca(marca: BoldColors.marca,
id: 'bold', nome: 'Conta BOLD')` mais os extras. Medido em 08/09, comparando esse produto com
`CoreflowProduto.bold`:

| o que | difere |
|---|---|
| a rampa de marca | **9 de 9** degraus — `daMarca` põe `#FE3976` no degrau **05** (é onde a claridade dele cai) e deriva os outros oito; a rampa do Bold é desenhada à mão, com o rosa no 04 |
| os outros campos da paleta (22 amostrados: neutros, semânticos, superfícies, vidro, brilho) | **21 de 22** — o Bold declara neutros, vermelhos, verdes, superfícies e vidro próprios; `daMarca` traz os da referência do pai |
| o esquema, `daMarca` só | 18 de 25 no claro, 20 de 25 no escuro |
| o esquema, `daMarca` + os `papeisExtras` do Bold | ainda **13 de 25** no claro e **14 de 25** no escuro |

A conclusão não é defeito de ninguém: **o Bold é um filho de paleta inteira, não um filho de uma cor.**
`daMarca` é a porta de quem nasce com uma cor; o Bold nasce com `BoldPalette.bold` — 103 constantes que
são decisão de marca — e o caminho dele é `CoreflowProduto(paleta: BoldPalette.bold, marca: marcaDoBold,
gradientes: CoreflowGradients.bold)`, que é o que `CoreflowProduto.bold` já faz e o que a sombra da fase 2
vai continuar fazendo. O gate `bold_e_filho_do_ds` da fase 3 passa a medir **isso**: o Bold monta o tema
inteiro pelo construtor de paleta do pai, sem que o pai saiba que ele existe. A frase "renasce por
`daMarca`" sai do enunciado da fase 3.

Reproduzir: o grafo sai de um script de 30 linhas sobre `lib/src` (régua do script + `^import '…'`
transitivo); a comparação, de um teste temporário que instancia os dois produtos e compara papel a
papel — os dois estão descritos aqui e os números são de 08/09 sobre `45e12ff`.
