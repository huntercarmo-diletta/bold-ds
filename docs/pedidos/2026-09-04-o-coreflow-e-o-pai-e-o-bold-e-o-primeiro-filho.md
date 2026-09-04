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
