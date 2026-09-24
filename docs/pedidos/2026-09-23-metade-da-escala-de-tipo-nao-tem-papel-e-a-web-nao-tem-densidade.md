# PEDIDO · Metade da escala de tipo não tem PAPEL escrito, e a densidade da web que a linguagem promete não existe como token

- **de**: conta-bold-ds (filho B) · **para**: ds-diletta
- **consome**: ds-diletta `v0.207.0` · `web-v0.207.1`. A tag `web-v0.114.0` do Bold, que o webadmin
  pina, embute a instância anterior `web-v0.207.0`, e as folhas CSS das duas são idênticas (conferido
  por `git diff` em 23/09).
- **bloqueante?**: **não bloqueia adoção** — os três produtos já pintam. Bloqueia a **coerência entre
  eles**: o Internet Banking e o webadmin escolheram degraus diferentes para o mesmo papel, e não foi
  descuido — não havia o que ler. Enquanto o papel não estiver escrito, cada produto novo vai escolher
  de novo.
- **não é peça nova**, então a regra do `DilettaManifesto.busca` não se aplica.

> **Nota de procedência.** Achado no **core-flow-wa** em 23/09/2026, ao decidir para que degrau iam 155
> literais de tipo de nove folhas novas. A pergunta «que degrau é o título de tela?» tinha três
> respostas na família, e a designer recusou escolher uma delas como referência: *«se vamos usar
> sempre o que a linguagem define, por que precisamos de um mapa de papéis na web?»*. A resposta é
> que a linguagem define metade.

## Falta

Duas coisas, e a segunda é a que a `LINGUAGEM.md` já prometeu:

1. **Papel escrito para os doze degraus de tipo que vieram do Figma** (`displayLg/Md/Sm`,
   `headlineLg/Md/Sm`, `titleLg/Md/Sm`, `bodyLg/Md/Sm`), ou a depreciação deles em favor dos onze que
   já têm papel.
2. **O token de densidade da web de backoffice** que a `LINGUAGEM.md` §2 declara: *«web de
   backoffice: `top` · `side` · `content` (+ densidade compacta p/ tabelas). Breakpoints e densidade
   (`comfortable`/`compact`) entram como tokens, não como forks»*. Hoje não há nenhum token com
   `compact` em nenhuma folha emitida.

## Número

**A fonte, lida em 23/09 na `v0.207.0`:**

```
tokens/type.tokens.json (DTCG)     23 degraus · 0 com `$description`
diletta_typography.dart (///)      11 com papel escrito · 12 sem
```

Os onze com papel: `title` («título de tela, h1»), `heading` («título de seção / card»),
`subheading`, `caption` («legenda, metadados, timestamps»), `label`, `labelLg` («título de card»),
`labelMd` («section headers PARA VOCÊ»), `labelSm` («status tags, tile labels»), `overline`
(«kicker de seção»), `button`, `display`. Os doze sem papel são exatamente os nomes de Material 3,
e o cabeçalho do arquivo diz de onde vieram: *«a escala nasceu em paridade 1:1 com o CSS do produto
do primeiro filho»*. Pela sua régua de `GOVERNANCA.md` («capacidade sobe; inventário não»), isso é
inventário de um filho que subiu como vocabulário — e sem papel, vocabulário não governa nada.

**O que os três filhos fizeram com o papel mais visível, medido nas folhas e no código:**

| papel | linguagem (`///`) | app (Dart) | Internet Banking (CSS) | webadmin (CSS) |
|---|---|---|---|---|
| título de tela (h1) | `title` | `title` 73 usos **e** `headlineSm` 45 | `headlineSm` 24px, 17 regras | `title` 17px, 32 regras |
| título de seção | `heading` | `titleMd` 22, `h` 38 | `titleMd` 16px, 20 regras | `bodySm` + forte 12px, 18 regras · `bodyMd` + forte 14px, 9 · `labelSm` 11 em caixa alta |
| corpo | *(sem papel para `bodySm`)* | `bodySm` 202, `bodySmall` 107, `body` 103 | `bodySm` 12px, 80 regras | `bodySm` 12px, 186 regras |
| legenda / metadados | `caption` | — | `bodySm` 12 | `labelSm` 11, 38 regras |
| valor em destaque (KPI) | **nenhum degrau** | — | `headlineSm` 24 / `headlineMd` 28 | `title` 17 (as telas novas chegaram com 22) |

Três produtos, três mapas. O único ponto em que os dois produtos web coincidem — `bodySm` para
corpo — é uma decisão de **densidade** que a linguagem não escreveu: o `body` documentado tem 15px,
e nenhum dos dois o lê.

**Onde a linguagem resolve densidade hoje:** por peça, como eixo de `porte` — `status-tag`
(`compacta`/`ampla`), `detail-row` (`compacto`), `data-row` (`tabela`/`painel`/`historico`). Não há
densidade de **página**, e é ela que a `LINGUAGEM.md` prometeu para a web de backoffice.

## Já tentei

1. **Escrever um «mapa de papéis da web» no filho**, valendo para IB e webadmin. Descartado antes de
   existir, pela pergunta da designer: seria um segundo vocabulário, e a `LINGUAGEM.md` §4 diz
   *«não se cria um segundo DS»*. Papel é do avô.
2. **Adotar o mapa do webadmin como referência para o IB** (ou o inverso). Descartado: nenhum dos
   dois seguiu a linguagem inteira — o console acerta o `title` e usa `labelSm` para legenda; o IB
   acerta a intenção de «seção» e usa `headlineSm` sem papel para o h1. Copiar um para o outro
   propagaria o erro de quem for copiado.
3. **`DilettaAjusteDePapel` (Porta 3)**: é por componente, mesma família de **cor**, motivo `marca`
   ou `contraste`. Não cobre tipo nem densidade de página.

## Conferi no pai

- `tokens/type.tokens.json`: 23 degraus, nenhum `$description`. Grep por `$description` e
  `description`: zero.
- `diletta_typography.dart`: 11 `///` de papel; nenhum para `headline*`, `title{Sm,Md,Lg}`,
  `body{Sm,Md,Lg}`, `display{Sm,Md,Lg}`.
- Folhas emitidas (`diletta-tokens.css`, `diletta-papeis.css`) e o pacote do Bold: **zero** tokens
  com `compact`, `comfortable` ou `dens`.
- `docs/LINGUAGEM.md` §2 e §4, `GOVERNANCA.md` («capacidade sobe; inventário não»; tabela de
  decisão: «um PAPEL novo → pai, porque não cobra nada de nenhum filho»), `ADR-003` («o produto
  declara os degraus da escala» — os **valores**, e o Bold já declarou: `title` 17), `ADR-005`
  Decisão 2 (os «passos» são a escala de acessibilidade, outro eixo), `ADR-007` («token, papel, cor,
  espaço, tipografia → automático»), `AJUSTAR-O-QUE-O-PAI-TEM.md` (seis portas; esta é a 6).
- Ledger e 129 pedidos do Bold: nenhum sobre papel de degrau de tipo nem densidade de página.

## Derivável?

**A densidade, talvez.** Se o avô publicar um token de página (`--diletta-densidade: compact`) que
os degraus de corpo e de célula leiam, os dois produtos web já estão onde ele cairia (12px). O que
não é derivável é o **papel**: nenhuma regra transforma `headlineSm` em «isto é o h1 da web». Isso
se escreve.

## Se você disser não

- Ao item 1: os dois produtos web passam a ler **só os onze degraus com papel**, e os doze sem papel
  viram proibidos por gate nos dois repos (`type-(headline|title(Sm|Md|Lg)|body(Sm|Md|Lg))`).
  Custo: o IB troca `headlineSm` → `title` em 17 regras e `titleMd` → `heading` em 20; o webadmin
  troca `bodySm` → ? em 186 — e aqui o «não» dói, porque `body` documentado é 15px e a tabela densa
  não cabe nele. É por isso que o item 2 vem junto.
- Ao item 2: a densidade fica como **divergência declarada** do Bold, uma linha em cada produto web
  («corpo e célula em `bodySm`, porque a web de backoffice é densa e a linguagem ainda não publica
  densidade de página»), com a condição de sumir escrita.

## Não estou pedindo

1. Que os **valores** mudem: `title` 17 é decisão do Bold e fica.
2. Um vocabulário de tipo para a web separado do mobile. A `LINGUAGEM.md` §4 proíbe, e nós
   concordamos.
3. Que o app mude agora. A distância de leitura do telefone é outra, e o que o app faz com `title`
   e `headlineSm` é assunto dele **depois** que o papel estiver escrito — hoje ele também usa os dois.
4. Um degrau novo para KPI **sem contagem**: registro que três produtos resolvem «valor em
   destaque» à mão, com três degraus diferentes, e deixo o número; se isso é `titleLg` com papel
   ou peça, é o avô quem diz.

## Como o pai vai saber que funcionou

- Todo degrau em `type.tokens.json` tem `$description`, e ela chega no `///` gerado e no catálogo.
- Um gate seu: degrau sem papel escrito reprova a emissão.
- Um token de densidade de página existe nas folhas emitidas, com o que ele muda declarado.
- Do lado de cá: as guardas de tipo do IB e do webadmin passam a citar o `///` do avô em vez de uma
  lista de exceções «pendentes», e a tabela acima fica com **uma** coluna.

## Os seis critérios

| critério | | |
|---|:-:|---|
| manutenção | ↑ | três mapas viram um, e ele mora onde o vocabulário mora |
| escalabilidade | ↑ | o quarto produto da família lê o papel em vez de escolher |
| aplicação | ↑ | IB e webadmin param de divergir no h1, na seção e na legenda |
| aderência ao mercado | ↑ | Carbon, Fluent e Polaris nomeiam TODO degrau por papel, e nos três a densidade é altura e espaço de componente — nunca tamanho de fonte. Levantado nas fontes oficiais em 23/09 — ver o Anexo, no fim deste pedido |
| robustez | = | nada muda no modo de falhar |
| arquitetura limpa e simples | ↓ | um token de densidade de página é um eixo a mais na cascata, e ele precisa de regra sobre quem o declara (filho) e quem o lê (peça). Declarado como custo, não escondido |

## O que os consumidores estão fazendo enquanto isso

O **webadmin** migrou as telas novas (Mesa de onboarding e Uso por funcionalidade) para o mapa que o
console já usava — `title` 17, `bodySm` 12, peso médio — como **divergência declarada e datada**
(23/09/2026), para não ter duas escalas numa aplicação. A guarda de tipo dele diz isso por escrito e
cita este pedido. Muda de novo quando o papel estiver escrito, e muda para o console inteiro, não por
tela. O **IB** fica como está. O que já coincide entre os dois (`bodySm`, `labelSm`, `overline`) não
se toca.

## Anexo · como Carbon, Fluent e Polaris resolvem papel e densidade

Levantado em 23/09/2026 nas documentações e fontes oficiais. São os três sistemas que a
`LINGUAGEM.md` §2 cita como referência para «admin + web».

**1 · Os três nomeiam tipo por PAPEL, e nenhum tem vocabulário sem papel.**

| sistema | nomes | exemplos com px |
|---|---|---|
| **Carbon** (IBM) | por função: `label`, `helper-text`, `body-compact`, `body`, `heading-compact`, `heading-0N`, `code`, `legal` | `label-01` 12 · `helper-text-01` 12 · `body-compact-01` 14/18 · `body-01` 14/20 · `heading-compact-01` 14/18/600 · `heading-02` 16 · `heading-03` 20 · `heading-04` 28 |
| **Fluent 2** (Microsoft) | um *type ramp* por papel: `Caption 2/1`, `Body 1`, `Subtitle 2/1`, `Title 3/2/1`, `Large Title`, `Display` | Caption 1 12 · Body 1 14/20 («primary body text») · Subtitle 2 16 · Subtitle 1 20 · Title 3 24 · Title 1 32 |
| **Polaris** (Shopify, só admin) | duas categorias, `heading` e `body`, com tamanho | `bodySm` 12 · `bodyMd` 13 · `bodyLg` 14 · `headingSm` 13 · `headingMd` 14 · `headingLg` 20 · `headingXl` 24 |

O Carbon escreve o papel no próprio token (`body-compact-01` é «parágrafo curto, dentro de
componente»; `label-01` é «rótulo de campo e mensagem de erro»).

**2 · Produto × editorial: o Carbon separa por CONTEXTO, com nome explícito.**

| type set | base | títulos | para quê |
|---|---|---|---|
| Productive (`-01`) | 14px | fixos | «espaços de produto… maior densidade de informação dentro de contêineres» |
| Expressive (`-02`) | 16px | fluidos por breakpoint | «experiências editoriais e de marketing» |

*«A diferença entre Productive e Expressive está principalmente nos headings»*: o corpo é o mesmo nos
dois. Mesmo vocabulário, dois conjuntos nomeados — o análogo mais próximo de «app × web de trabalho».

**3 · Densidade NÃO é tipo: nos três, é altura e espaço de componente.**

| sistema | como a densidade existe | o que ela muda | o que ela NÃO muda |
|---|---|---|---|
| **Carbon** | eixo de tamanho por componente: linha da data table em xs 24 · sm 32 · md 40 · lg 48 · xl 64 px | altura da linha, toolbar, botões | o tipo: célula sempre `body-compact-01` (14px) |
| **Fluent** | modificador `density` (−1 · 0 · +1) sobre os multiplicadores de altura e recuo, definível **por subárvore do DOM** | altura e recuo dos controles | o *type ramp*: «se o tipo deve ser maior no todo, aumente o ramp inteiro» |
| **Polaris** | props por componente (`increasedTableDensity`, `condensed`) sobre o grid de 4px | espaçamento e altura | a escala de tipo; e «evite mudar a densidade de informação dentro de uma página» |

«Densidade compacta para tabelas», nos três, é linha mais baixa, controle mais baixo, recuo menor —
nunca fonte menor. E o `bodySm` 12 que IB e webadmin escolheram para corpo está dentro do que os
admins do mercado fazem (Polaris `bodySm` 12 e `bodyMd` 13).

**Não conferido:** orientação do Fluent 2 sobre produto × marketing além do ramp; os px do Polaris
saíram da fonte dos tokens (`polaris-tokens`), porque as páginas de guia migraram para `shopify.dev`.

**Fontes.**
- Carbon · type sets: https://carbondesignsystem.com/elements/typography/type-sets/ · productive: https://v10.carbondesignsystem.com/guidelines/typography/productive/ · expressive: https://v10.carbondesignsystem.com/guidelines/typography/expressive/ · data table: https://carbondesignsystem.com/components/data-table/style/
- Fluent 2 · typography: https://fluent2.microsoft.design/typography · layout: https://fluent2.microsoft.design/layout · density e type ramp: https://learn.microsoft.com/en-us/fluent-ui/web-components/getting-started/styling · tokens por subárvore: https://learn.microsoft.com/en-us/fluent-ui/web-components/design-system/design-tokens
- Polaris · tokens de texto: https://github.com/Shopify/polaris/blob/main/polaris-tokens/src/themes/base/text.ts · tamanhos: https://github.com/Shopify/polaris/blob/main/polaris-tokens/src/size.ts · layout e densidade: https://shopify.dev/docs/apps/design/layout · tipografia: https://polaris-react.shopify.com/design/typography/font-and-typescale

---

## Veredito · ENTRA, e NÃO nesta tag — porque a resposta certa é uma DEPRECIAÇÃO
**pai**: ds-diletta · **data**: 2026-09-24 · **entrega prevista**: `v2.6.0` · **código nesta tag**: nenhum

Você está certo, e a pergunta da designer é a melhor frase do pedido: *«se vamos usar sempre o que
a linguagem define, por que precisamos de um mapa de papéis na web?»* — **porque a linguagem define
metade.** Dois produtos escolheram degraus diferentes para o mesmo papel e não foi descuido: não
havia o que ler.

**Não sai nesta tag porque a saída honesta é a sua segunda**, e ela é maior que escrever doze
linhas de `///`. Os doze degraus que vieram do Figma (`displayLg/Md/Sm`, `headlineLg/Md/Sm`,
`titleLg/Md/Sm`, `bodyLg/Md/Sm`) são um **vocabulário paralelo** ao dos onze que têm papel — dois
nomes para a mesma pergunta, que é a classe que esta casa passou o mês matando (`chatLift`,
`WalletCard.cpfSeguro`, `TipoConexao.chatCpf`). Escrever papel para eles **oficializa a duplicata**;
depreciá-los é remoção de nome público, que é **major**, e major não sai como efeito colateral de
um release de conserto.

O que eu faço até lá, e é o que te destrava sem congelar a decisão: a lista dos onze com papel
escrito vira a resposta publicada para *«que degrau é o título de tela?»*, e os doze entram no
inventário como **candidatos a depreciação**, com a contagem de uso nos três filhos. Quem decide
depreciar é o dono, e ele decide com o número na frente.

**Sobre a densidade**: a `LINGUAGEM.md §2` promete `comfortable`/`compact` como token e não há
nenhum. A promessa é minha e a dívida é minha — ela sai com os papéis, no mesmo lote, porque
densidade sem papel de tipo escrito é meio token.

**Os sete**: manutenção ↓ dívida declarada até a v2.6.0 · escalabilidade ↑ · **aplicação ↑ decide o
mérito** — o terceiro produto vai escolher de novo enquanto isto não existir · aderência ao mercado
↑ · robustez = · **arquitetura ↑ decide o PRAZO** — escrever papel para os doze oficializaria dois
vocabulários · conciso ↑ onze nomes em vez de vinte e três.
