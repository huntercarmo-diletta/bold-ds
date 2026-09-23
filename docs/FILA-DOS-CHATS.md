# FILA DOS CHATS — o que as conversas abriram, em ordem de dependência

Este arquivo é escrito pela rotina **`atualizacoes-ds`** e não à mão. Ele existe por uma queixa
concreta: *"não quero fazer isso manualmente em cada chat"*. Três conversas andaram no mesmo dia
sobre a mesma família de peças, cada uma guardou o que descobriu no seu próprio canto — memória da
sessão, arquivo de scratchpad, ledger de divergência do Figma — e **ninguém tinha a lista inteira**.

**Como ler**: a ordem é de DEPENDÊNCIA, não de importância. O item 2 não se faz antes do 1 porque a
porta que ele usa chega na tag do 1.

**O que é «nosso» e o que é «pedido»**: `CoreflowBackdrop`, os moods, a tela de Aparência e o repasse
de `disabled` no botão moram em `packages/coreflow` — **são nossos, não se pede**. Ao avô
(`ds-diletta`) só vai o que é vocabulário dele: a forma por família (respondida, e adotada), o EIXO
do logo (**respondido em 16/09 e entregue na `v0.196.0`** — o que sobrou é nosso), e o `copyWith` do
plugue de marca (escrito em 17/09 — **respondido e entregue na `v0.201.0`**, com os **catorze**
campos e não os doze que o pedido contou: *"o plugue cresceu duas vezes enquanto isto esperava"*).
A licença da arte não é nenhum dos dois: é pergunta para uma pessoa.

---

## Rodada de 2026-09-23 · fim de tarde

Cobre **22/09 17h50 → 23/09 17h44**. Foi o dia em que o pai deixou de ser `0.x`: **nove tags numa
manhã, da `v0.208.0` à `v2.1.0`**, com duas majors. Nenhuma delas responde um pedido nosso, porque
nenhum dos nossos seis pedidos à linguagem chegou a ele. Ao medir, apareceu um erro desta casa, que
seria barato de consertar antes do sinal ao pai: **os cinco pedidos que esta rotina e os chats
escreveram de 21 a 23/09 se identificavam como «filho A», e no ledger do pai o filho A é o CPF
Seguro.** O Bold é o **filho B**. Consertado nesta rodada, antes de qualquer envio.

**Chats lidos** (transcrição, não resumo de terceiro):

| chat | cwd | até | o que ele produziu pra cá |
|---|---|---|---|
| Meus limites (continuação) | `claude_newbold` · `9ef7cfe2` | 16h11 | a metade de *enforcement* da feature, a comparação app × Figma do `revisor-visual`, **o DS vendorizado `v0.102.1 → v0.113.0` na branch da feature**, o pedido do trilho do medidor e o item 9 (rodapé), os dois já no remoto em `5b2c02b` |
| a adoção do DS pelo webadmin | `claude_newbold` · `0f441ea9` | 17h44 | o `core-flow-wa` instalado, a prova no navegador de que o Bold ganha do avô em 6 de 6 papéis, a catraca da peça crua (83 em 35 arquivos) e **o remendo `::part(botao)`** a partir do handoff da Tatiana. **O pedido novo do item 1 sai daqui** |
| fundo como valor | `claude_newbold` · `43e09e89` | 16h35 | a pergunta dela, *«o flavor deveria levar consigo essa informação como código hex»*; o M14 ao Berço e a forma proposta ao pai |
| Envios do Berço → M14 | `claude_newbold` · `22128cb9` | 16h26 | o Berço V91: `material.fundos` resolvido no manifesto, 144 variáveis no `tokens.css`, o snippet Dart. **Nada de repo do DS** |
| recado do Berço | `bold-ds-pacote` · `aeb36817` | 16h27 | `39f1e79`, a forma proposta no pedido do fundo, **commitado local e não enviado** |
| esta rotina, rodada anterior | `bold-ds-pacote` · `a8f29c2d` | 10h15 | dois rebases do `PEDIDOS.md` contra a Tatiana e o diagnóstico do bump parado no app |
| Desktop Commander | `claude_newbold` · `18a6aa53` | 15h35 | plugin da organização desinstalado; **nada de DS** |
| `aprendizado-do-dia` (rotina) | `claude_newbold` · `ba8d0bdf` | 10h24 | ignorada por contrato |

---

### 0 · O QUE O PAI FEZ — a primeira major, e o que ela cobra de nós

52 commits na `main` do `ds-diletta` entre 22/09 17h34 e 23/09 16h41, todos do Hunter, e as tags
`v0.208.0` · `v0.209.0` · `v1.0.0` · `v1.0.1` · `v1.0.2` · `v1.1.0` · `v2.0.0` · `v2.0.1` · `v2.1.0`,
cada uma com o par `web-`. **Os vereditos do dia são todos do filho A** (CPF Seguro: dropdown
suspenso, dependência entre props, item de menu sem ícone, rótulo que não encolhe, botão
destrutivo, `chatLift`, escada de níveis, taxonomia). **Nenhum dos nossos seis pedidos à linguagem
está no ledger dele** (`docs/PEDIDOS.md`, conferido por assunto: medidor, título, piso de texto,
linha da lista, trilho, fundo). Continuam escritos, não recebidos.

O que a subida cobra do Bold, medido em `origin/main` deste repo (fora da cópia do avô) e na
branch de trabalho do app:

| mudança do pai | onde | Bold (`packages/`) | app (`lib/`) |
|---|---|---|---|
| `DilettaStatusTone.danger` → `.error` | `v1.0.0`, alias `@Deprecated` | **3 sítios** — `coreflow_autorizacao.dart:162`, `coreflow_etiqueta.dart:182`, `coreflow_saldo.dart:138` — e 1 teste (`a_autorizacao_pendente_test.dart:144`) | 8 arquivos |
| `DilettaTextLinkTone.neutro` → `.neutral` | `v1.0.0`, alias | zero | 2 sítios, `home_tab_redesign.dart:193` e `:256` |
| `chatLift` apagado | `v2.0.0`, **sem alias** | zero (só prosa no doc de adoção) | zero |
| `navGlowDe` · `footerUpDe` · `heroLift` · `cardLift` · `cardPvDe` | `v1.0.0`, removidos | zero | zero |
| o destrutivo em repouso pinta `errorSolid` | `v1.0.2` | **muda pixel** em todo botão de erro do Dart; o pai mediu 3,76 nas paletas dos filhos antes do conserto. Medir na subida, não presumir | — |

**Nada quebra a compilação do Bold na subida**: os aliases continuam lá. E aí está uma contradição
que vale uma linha ao pai: o `@Deprecated` diz *«Sai na v1.1.0»*
(`diletta_status_tag.dart:40`, `diletta_text_link.dart:39`, na `v2.1.0`), a `v1.1.0` passou, duas
majors passaram, e eles continuam. A própria `v1.0.0` escreveu a regra que explica: *«renomeação
de nome público só sai em major»*. Então *«sai na v1.1.0»* nunca foi possível. Isso não é pedido,
porque não nos custa nada. É nota para o próximo sinal: a data de saída escrita no alias está errada.

**A deriva, e ela piorou num dia:**

| onde | filho | pai | medido em |
|---|---|---|---|
| **app**, `origin/development` e `origin/release/homologation` | `v0.102.1` | `v0.180.0` | `packages/ds_vendor.json` |
| **app**, `origin/feat/grupos-de-limite-administracao` | **`v0.113.0`** | **`v0.204.0`** | o mesmo arquivo, desde `e8e73b17` (23/09) |
| **filho**, `main` | — | `v0.207.0` + `web-v0.207.1` | `packages/coreflow/pubspec.yaml:23` |
| **pai**, ponta | — | **`v2.1.0`** = `origin/main` `fb30e58` | `ds-diletta` |

**Nove tags entre o filho e o pai**, duas delas majors. **O `ds-diletta` local está
600 à frente e 657 atrás do remoto**, com um arquivo solto (`MELHORIAS-DO-DS-2026-09-11.md`).
Esse checkout não serve de medida, e esta rodada mediu tudo pelo `origin/main` e pelas tags.

---

### 0b · Os nossos cinco pedidos diziam «filho A» — consertado antes do sinal

O ledger do pai é claro, e a razão está na primeira página dele: *«pseudônimo estável (A, B, C)…
você reconhece os seus pelo conteúdo»*. O `CHANGELOG` da `v1.0.0` nomeia o filho A como
`cpf-seguro-flutter`; o comentário da `v1.0.2` em `diletta_scheme.dart` diz *«O filho B declarou
branco sobre o rosa `#FE3976`»*, que é o nosso. Dos 54 pedidos de setembro nesta pasta, 40 dizem
`filho B`, e **5 diziam `filho A`**, justamente os cinco mais novos:

- [o medidor não se lê](pedidos/2026-09-21-o-medidor-nao-se-le-nem-pela-semantica-nem-pela-bula.md)
- [o título da tela não é cabeçalho](pedidos/2026-09-22-o-titulo-da-tela-nao-e-cabecalho-para-quem-usa-leitor-de-tela.md)
- [o piso de texto grande](pedidos/2026-09-22-o-papel-que-carrega-texto-de-corpo-tem-piso-de-texto-grande.md)
- [a linha da lista corta no meio da palavra](pedidos/2026-09-23-a-linha-da-lista-corta-no-meio-da-palavra.md)
- [o trilho do medidor](pedidos/2026-09-23-o-trilho-do-medidor-e-derivado-contra-uma-pagina-que-ninguem-pinta.md)

O cabeçalho de cada um trocou `(filho A)` por `(filho B)`, e nada mais mudou. **Os cinco foram
remedidos na `v2.1.0`, e os cinco defeitos continuam lá**: `_trilhoDerivado(p.bgClaro ?? p.white…`
em `diletta_scheme.dart:472`; zero `Semantics` em `diletta_progress_bar.dart`; `fontSize: 13` em
`diletta_inline_alert.dart:116`; zero `header: true` em `packages/diletta_design_system/lib`; e o
`diletta_app_list.dart` só mudou uma linha entre `v0.204.0` e `v2.1.0`, a do alias `danger`. O
«consome: v0.204.0» de cada um continua verdadeiro, porque é o pino que o app vendoriza.

> **A classe**: o pseudônimo é a única coisa num pedido que o pai não mede, porque ele confia que o
> filho sabe quem é. Um pedido com o pseudônimo errado chega com a medição certa e a origem errada,
> e o ledger dele passa a atribuir ao CPF Seguro o que é do Bold. Nada acusa: o gate do índice
> confere arquivo × linha, não cabeçalho × ledger.

---

## 1 · PEDIDO NOVO — a peça web crava o raio que a paleta declara

[o arquivo](pedidos/2026-09-23-a-peca-web-crava-o-raio-que-a-paleta-declara.md) · **ao pai da
linguagem** · **não depende de nenhum outro item**. Por isso vem primeiro.

A Tatiana mandou à Agatha em 23/09 um handoff medido (*«o raio e a forma do app contra os da
web»*). No chat do webadmin, ela escolheu remendar no consumidor: *«quero fazer essas correções por
aqui. todos os estilos devem seguir o que foi estipulado pelo design system e está no catálogo»*.
O remendo entrou (`9e342ed` no `core-flow-wa`, local, não enviado). **O pedido não existia**, nem
aqui nem no ledger do pai. Esta rotina remediu as três linhas na `v2.1.0`:

| peça | web, `v2.1.0` | Bold declara | app desenha |
|---|---|---|---|
| botão | `diletta-button.js:148` `999px` | 16 (`bold_palette.dart:533`, `bold-tokens.css:244`) | 16 |
| campo | `diletta-input.js:144` `8px` | 16 (`bold-tokens.css:246`) | 16 |
| caixa do dropdown | `diletta-dropdown.js:132` `8px` | — | pílula |

**O que tornou isto pedido e não preferência nasceu hoje no próprio pai.** A `v2.0.0`, que apagou
o `chatLift`, escreveu em `specs/design-system-button/spec.md:155`: *«a FORMA é a declarada, sem
exceção»*, e o botão é `destino: ambos`. A instância web não abre exceção à forma declarada.
Ela simplesmente nunca a lê.

**O que o chat disse e o código confirma**: o campo e o dropdown já estavam remendados no webadmin
desde 22/09 (`tokens/index.css:134-135`), e o botão era o que sobrava, com `999px` na tela e
`--diletta-formaDeBotao: 16px` declarado e ignorado.

---

## 2 · O rodapé mede 20 onde a grade diz 24 — NOSSO, de pé, e agora com dono no app

O item 9 da rodada de 21/09, escrito por outro chat em `5b2c02b`. **Remedido hoje: continua**.
`coreflow_rodape.dart:73-74` recua com `DilettaSpacing.s5` dos dois lados, e
`coreflow_espaco.dart:25` declara `gutter = DilettaSpacing.s6`. Conserto de uma linha, e o gate do
gutter passa a olhar o rodapé. **Código, então não entra sem pedido dela.**

**O que mudou desde que foi escrito**: o rodapé com o aviso dentro da barra já chegou ao app, mas
só à branch da feature. `e8e73b17` vendorizou `v0.113.0` em `feat/grupos-de-limite-administracao`
(suíte: 4.041 passam, 2 falhas conhecidas). **`development` e `homologation` continuam em
`v0.102.1`**, e a `chore/ds-v0.113.0` (`1dbab237`) ficou parada e redundante. O conserto da foto
de 21/09 vai entrar no trem **junto com a feature de limites**, não antes dela. Isso é decisão
dela, não defeito, mas ninguém tinha escrito.

Quando o `s5 → s6` sair, ele pousa numa tag nova do filho, e o app precisa de outra vendorização.
**Por isso vale fazer este item ANTES de vendorizar de novo**, não depois.

---

## 3 · O fundo viaja como valor — a forma proposta está pronta e parada no disco

A pergunta foi dela (*«o flavor deveria levar consigo essa informação como código hex para ser
aplicado a qualquer tipo de código»*), e ela mandou encaminhar ao pai. Em 23/09:

- **o Berço já emite o valor** (V91, fora de qualquer repo do DS): `material.fundos` com `base`,
  camadas em hex com alfa, posição e escala, e a tinta, por modo; 144 variáveis no `tokens.css` da
  Norte Benk; um snippet Dart para o app;
- **a forma de o pai repassar** entrou no [pedido do fundo](pedidos/2026-09-23-o-fundo-nao-viaja-com-o-filho.md)
  como seção proposta, em `39f1e79`. **Esse commit é local**: a `main` está 1 à frente do remoto.
  Ele desfaz a ordem 3 → 1 → 4 do pedido de 18/09, porque com o fundo como dado os três fundos do
  Berço não precisam virar membros do enum;
- **a decisão que sobra é dela**: dado × enum. A proposta mantém os sete estilos de hoje e põe o
  dado ao lado.

**Depende de**: o sinal ao pai (item 5) e a decisão dado × enum. **O app espera por ele**: o
andaime `lib/core/theme/arte_de_fundo_gerada.dart` só se aposenta quando o pai carregar
`CoreflowProduto.fundos`. O chat do Berço registrou um desvio de cerca de 7% entre a conta do app e
a do site onde o véu do estilo `imagem` não tem compensação exata. **Esse número não foi medido por
esta rotina**. Ele sai do chat e fica aqui como afirmação, não como medida.

---

## 4 · Rastro do dia fora dos três repos — o webadmin, que é consumidor web do Bold

`~/Desktop/core-flow-wa`, branch `feat/a-adocao-do-ds-pelo-webadmin`, **quatro commits locais e
nenhum enviado** (`9e4d50f` · `e2d43da` · `75319d7` · `9e342ed`). A branch
`chore/o-pino-sobe-tres-tags-e-a-rampa-de-marca-chega` (`461bc31`) ficou separada, com o pino
`web-v0.114.0 → web-v0.117.0`, que é aditivo.

Não é repo desta família e não entra na lista de envio. Fica registrado por dois motivos:

- **o remendo `::part(botao)` depende do item 1**. Quando o pai entregar, o remendo sai e a trava
  dele em `formas.test.ts` tem que ser invertida, senão ela passa a guardar o remendo;
- **a catraca da peça crua (83) mediu vocabulário que falta na linguagem web**, com razão: caixa de
  seleção ×8, data ×2, cor, arquivo, intervalo, área de texto ×2. Destes, só a data tem veredito
  (`date-field` vai a `ambos`, 22/09, entrega na `v0.208.0`). **Nada disso vira pedido nesta
  rodada**: são pedidos do consumidor web, e a régua da recusa de 22/09 vale (*«pedir vocabulário
  que ninguém especificou é diferente de pedir a metade de um contrato que já está escrito»*).

---

## 5 · O que ninguém está fazendo, e trava os itens 1, 3 e os cinco de 0b

**O sinal ao pai.** Pelo contrato, o push não entrega: entrega o aviso humano ao `ds-diletta`.
Hoje há **sete** pedidos à linguagem escritos e nunca recebidos: medidor, título, piso de texto,
linha da lista, trilho, fundo (com a forma proposta) e forma na web. Enquanto isso, o filho A teve
oito julgados num dia. **O consumo atrás cresce a cada tag**: o pai que receber os nossos pedidos
já está na `v2.1.0`, e todos eles citam `v0.204.0` ou `v0.207.0` como o que consomem. Os pedidos
continuam certos, porque o defeito foi remedido na ponta, mas a subida do pino deste filho (item 6)
encurtaria a conversa.

## 6 · A subida do pino deste filho — `v0.207.0 → v2.1.0`, e ela é barata

A tabela do item 0 é o custo inteiro: **3 sítios e 1 teste** nossos, todos com alias, e zero
`chatLift`. O que tem preço é o **pixel do destrutivo** (`v1.0.2`). **Depende de nada**, mas é
código e tag, então é decisão dela. Registrado para que a próxima rodada não tenha que remedir.

---

## O que esta rodada escreveu, e o que espera o envio dela

| arquivo | o quê |
|---|---|
| `docs/pedidos/2026-09-23-a-peca-web-crava-o-raio-que-a-paleta-declara.md` | pedido novo |
| `docs/PEDIDOS.md` | a linha dele no topo da tabela da linguagem |
| cinco pedidos de 21–23/09 | `(filho A)` → `(filho B)` no cabeçalho |
| esta rodada | — |

O gate `todo_pedido_esta_no_indice_test.dart` passou (4 de 4) com a árvore desta rodada.

---

## Rodada de 2026-09-22 · fim de tarde

Cobre **21/09 17h57 → 22/09 17h50**. O dia teve um chat só produzindo DS, e ele produziu muito: o
fluxo «Meus limites» andou do protótipo à documentação, virou código e passou por duas auditorias no
fim da tarde. Dos itens que os agentes marcaram como falta do design system, **quatro não
sobrevivem à medição** e **dois viram pedido**. E duas coisas que ninguém no chat viu apareceram ao
medir: o repo deste filho andou dezesseis commits sem esta casa, e **o conserto de ontem não chegou
a nenhuma branch de entrega do app**.

**Chats lidos** (transcrição, não resumo de terceiro):

| chat | cwd | até | o que ele produziu pra cá |
|---|---|---|---|
| Meus limites (fluxo novo) | `claude_newbold` · `9ef7cfe2` | 17h44 | o dia inteiro — protótipo fechado, documentação no Figma, a feature em código (`b8a0a44e`), e as duas auditorias do fim da tarde. **Os dois pedidos desta rodada saem daqui** |
| PR #768 do Norte Benk | `claude_newbold` · `6bfe0d0d` | 17h02 | revisão do Matias respondida inteira, build no simulador, assinatura barrando o iPhone — **nada de DS** |
| `aprendizado-do-dia` (rotina) | `claude_newbold` · `7b625137` | 10h42 | ignorada por contrato |
| esta rotina | `bold-ds-pacote` · `a8f29c2d` | — | esta |

---

### 0 · O QUE O PAI RESPONDEU — a régua dos SEIS vira obrigatória, e oito vereditos numa madrugada

Isto vem primeiro porque muda a forma do que esta rotina escreve. Hoje às 17h34 o pai commitou
`91cfd58` na `main` (mais `31a04ea`, o derivado da paridade). **Nenhuma tag foi cortada** — os oito
vereditos têm entrega prevista na `v0.208.0`, que ainda não existe.

**A régua dos seis critérios passou a ser obrigatória e a ser uma TABELA.** Até aqui o veredito
citava os critérios que pesaram; a partir de hoje carrega os seis, cada um com sinal (`↑ = ↓ ⊘`) e
uma frase. A razão, escrita por ele:

> *Critério não citado se lê como critério não consultado. E a família não tem como distinguir «não
> pesou» de «não olhei» depois que o veredito está escrito.*

Um `↓` não veta — obriga a declarar a dívida. **Dois ou mais obrigam a reformular.** O que muda para
nós é do lado de ler, não de escrever: o formato do pedido do filho não mudou. O que mudou é que
toda resposta que voltar traz seis linhas, e uma delas pode ser uma dívida que a gente herda.

**Os oito vereditos são todos do filho B** (Internet Banking): foco/`delegatesFocus` · rótulo cru no
`innerHTML` · `aria-*` no hospedeiro · `role="cell"` · alvo de toque na paginação · borda do
desabilitado · campo de data · portes `sm`/`md`. Nenhum é nosso. **Mas um deles corrige a `v0.207.0`
de ontem**, e é a doutrina em que o pedido novo do item 2 se apoia:

> *O `rotulo-acessivel` não estava errado, estava incompleto — eu tratei como caso o que era classe,
> e a prova é que a classe voltou em menos de 24h pela mão do mesmo filho. Nome continua campo (é
> conteúdo, e o consumidor escreve); **estado passa a ser regra** (é da norma, e a norma é fechada).*

**E uma linha ABERTA que ele mesmo achou julgando**: a tabela de pintura da web está **congelada** —
`gera_web_da_resolucao.py` recusa o botão hoje (27 slots ambíguos) e o `pintura.g.js` versionado
ainda o contém. A classe: *emissão que recusa em silêncio deixa o consumidor com a última versão que
passou.* Não é nossa — não emitimos web por esse caminho —, mas fica registrada porque a instância
web do Coreflow sai do mesmo gerador.

---

### 0b · E o repo DESTE filho andou dezesseis commits — e não foi esta casa

Isto não veio de chat nenhum: veio do `git fetch`. Entre **21/09 18h23 e 22/09 15h56**,
`tatianahasimoto-diletta` publicou **16 commits** e **duas tags** (`v0.114.0`, `v0.115.0`, com
espelho web) na `main` do `bold-ds`.

| o que entrou | commits |
|---|---|
| o pai do filho sobe para `v0.207.0` | `50b6c0d` (`v0.114.0`) — o `pubspec` do `coreflow` no remoto pina `v0.207.0`; **o local ainda pina `v0.204.0`** |
| sete pedidos do filho B, escritos nesta pasta | `710cb86` · `e7b1909` · `730ee31` · `e841712` · `2fba174` · `4f3acbd` · `b63f0c9` |
| **gate novo**: todo pedido está no índice, e toda linha do índice aponta pra um pedido | `27dcf32` + `634fb75` |
| gate novo: o lock do exemplo aponta pro mesmo commit | `364ddcf` |
| a publicação passa a servir mais de um filho | `5e646c6` · `c6e5689` · `0710cd8` · `0eaf017` · `8dde9d2` (`v0.115.0`) |

**A `main` local está 1 à frente e 16 atrás.** O commit à frente é a rodada de ontem (`336a4f2`),
que nunca foi enviada. Isto tem três consequências práticas, e a primeira manda na ordem de tudo o
que vem depois:

1. **Integrado no mesmo dia, e o conflito ensinou uma coisa.** O `docs/PEDIDOS.md` foi tocado pelos
   dois lados na mesma região. A resolução **não** foi «manter as duas listas» — cinco linhas
   existiam nas duas versões, e em **três** delas o texto divergia. Em todas as três a nossa era a
   mais nova, porque carregava o que o pai entregou na tarde de 21/09 e a cópia do remoto ainda
   não: o índice de lá dizia **«sem veredito · BLOQUEANTE»** para o pedido do nome acessível do
   botão, que o pai tinha **entregue na `v0.207.0`**. A base ficou sendo a do remoto (que traz as 12
   linhas de índice restauradas pelo gate) com essas três trocadas pelas nossas, mais as três
   linhas novas desta casa.

   > **Dois autores escrevendo o mesmo índice produzem estados de veredito divergentes, e nada
   > acusa.** O gate novo fecha file↔linha nos dois sentidos; ele não compara o que a linha DIZ com
   > o que o ledger do pai já respondeu. É a mesma classe da bula do medidor: o arquivo estava certo
   > quando foi escrito e envelheceu sem alarme;
2. **o gate novo reprova a árvore local.** Em 21/09 havia 15 arquivos em `docs/pedidos/` sem linha
   no índice; o remoto já resolveu — 12 entraram e **3 ficaram fora com motivo declarado** numa
   lista fechada dentro do próprio gate. Dois deles esperam uma decisão de processo (o índice tem
   três seções e nenhuma serve para o que vai à **dona do produto**); o terceiro é o
   «[o fundo padrão é do cliente](pedidos/2026-09-18-o-fundo-padrao-e-do-cliente-e-o-filho-nasce-sem-ele.md)»,
   que o gate registra como **não sendo pedido** — *«quem pede é o app e quem responde é esta
   casa»* —, exatamente como esta rotina anotou em 21/09;
3. **este repo tem dois autores agora.** A regra de subir direto na `main` continua valendo, mas
   `git pull` deixou de ser opcional antes de escrever qualquer coisa aqui.

---

### A deriva, e hoje ela tem TRÊS números diferentes ao mesmo tempo

| onde | filho | pai | medido em |
|---|---|---|---|
| **app**, em TODA branch de entrega | `v0.102.1` | `v0.180.0` | `packages/ds_vendor.json`, igual em `origin/development`, `origin/release/homologation` e na branch de trabalho `feat/grupos-de-limite-administracao` |
| **filho**, `main` local | — | `v0.204.0` | `packages/coreflow/pubspec.yaml:23` |
| **filho**, `origin/main` | — | `v0.207.0` | o mesmo arquivo, no remoto |
| **pai**, ponta | — | `v0.207.0` + `91cfd58` sem tag | `ds-diletta`, `origin/main` |

A deriva que importa **não é a de três tags entre o filho e o pai**, que era a de ontem. É a de
baixo: **o app está onze versões do filho e vinte e quatro do pai atrás**, e é sobre esse código que
o fluxo novo foi escrito hoje.

---

## 1 · O conserto de ontem não chegou a nenhuma branch de entrega — e o defeito da foto está de pé

Ontem o defeito das **duas linhas acima do botão** foi achado numa foto, consertado no pai
(`v0.204.0`), publicado no filho (`v0.113.0`) e levado ao app. A rodada de ontem registrou o app
como feito, em `68ded84e`, refeito em `1dbab237`. **Medido hoje: aquele commit mora numa branch só.**

```
$ git branch --contains 1dbab237
  chore/ds-v0.113.0
```

`origin/development`, `origin/release/homologation` e a branch em que ela trabalhou o dia inteiro
carregam **filho `v0.102.1` · pai `v0.180.0`**. Nessa versão do pacote vendorizado:

- `DilettaBottomApp` **não tem** o slot `acima` — zero ocorrências fora de um comentário;
- `CoreflowRodape.acima` existe (`:66`, `:125`, `:141`) e é o caminho velho, o que embrulha o rodapé
  do pai numa **segunda barra** (`:164` — *«com conteúdo acima, o envelope do pai não serve»*).

**Quatro telas passam por ali hoje, em homologação:**

| tela | linha |
|---|---|
| `lib/features/pix/presentation/screens/pix_revisar_screen.dart` | 609 |
| `lib/features/ted/presentation/screens/ted_revisar_screen.dart` | 276 |
| `lib/features/boleto/presentation/screens/boleto_revisar_screen.dart` | 394 |
| `lib/features/pix/presentation/screens/devolucao/devolucao_screen.dart` | 436 |

A branch `chore/ds-v0.113.0` existe no remoto (`1dbab237`). **Não é trabalho a fazer: é entrega a
concluir**, e ela é dela, como todas. Fica em primeiro lugar por dependência: a foto que abriu o
caso continua reproduzível na revisão do Pix até essa branch entrar.

> O fluxo novo de hoje **não** passa por aí — as telas de `limites` usam
> `CoreflowRodape.button(primary:)` sem `acima`, conferido. O que ele pega da versão velha é outra
> coisa, e está no item 6.

---

## 2 · O título da tela não é cabeçalho — PEDIDO NOVO ao pai

A auditoria de acessibilidade das 17h31 marcou dois itens como *«não verificável no Figma, confira
no código»*. Conferidos os dois: **um já estava certo** (item 4), e este estava mesmo faltando.

**`header: true` tem ZERO ocorrências em `packages/diletta_design_system`** — na `v0.204.0` e na
ponta `v0.207.0`. Não é a barra de topo que esqueceu: a linguagem não usa a bandeira em lugar
nenhum. O título sai como `Text` puro em `diletta_navigation_top_bar.dart:361`.

Quem usa leitor de tela não consegue saltar para o título da tela nem confirmar onde está — a
navegação por cabeçalhos, que é o gesto de se situar numa tela nova, não encontra nada.

| medida | valor |
|---|---|
| `header: true` na linguagem (v0.204.0 e v0.207.0) | **0** |
| `header: true` em `packages/coreflow` | **0** |
| chamadas de `CoreflowBarraDeTopo.page/.sheet` no app | **102** |
| arquivos do app que tocam a barra | **88** |

**Metade disto é nossa e não se pede**: o `_TituloPrimario`
([`coreflow_barra_de_topo.dart:312`](../packages/coreflow/lib/src/coreflow_barra_de_topo.dart)) é um
`Text` nosso, e embrulhá-lo cobre as 102 telas com uma linha. Por isso o pedido **não é bloqueante**
e por isso ele é sobre o que o contorno **não** cobre: quem passa `title:` como `String` — o caminho
documentado — continua sem cabeçalho, porque o nosso `titleWidget` substitui o `Text` do pai
inteiro; e cada filho novo paga a mesma linha sem saber que precisa.

O argumento que decide é a régua que o **próprio pai escreveu hoje**, no veredito dos `aria-*`:
*nome é campo, estado é regra.* «Este texto é o cabeçalho da tela» não é conteúdo que o consumidor
escolhe — é a norma lendo a estrutura que a peça montou. E é **derivável**: quem recebe `title` é o
cabeçalho, não há segundo caso.

→ [pedidos/2026-09-22-o-titulo-da-tela-nao-e-cabecalho-para-quem-usa-leitor-de-tela.md](pedidos/2026-09-22-o-titulo-da-tela-nao-e-cabecalho-para-quem-usa-leitor-de-tela.md)

---

## 3 · O papel de apoio carrega texto de corpo com piso de texto GRANDE — PEDIDO NOVO ao pai

Mesma auditoria, critério 1.4.3. O auditor mediu `#80798D` na tela e marcou como peça do DS. Fomos
ver de onde o hex vinha, e **a derivação o reproduz byte a byte**.

```dart
// diletta_scheme.dart:506-508
textTertiary: (p.textoSecundarioClaro != null && p.textoMudoClaro != null)
    ? _degrauEntre(p.textoSecundarioClaro!, p.textoMudoClaro!, p.neutral02, p.neutral03, p.neutral04)
    : _apoioQueAlcanca(p.white, [p.neutral03, p.neutral02, p.neutral01]),
```

`_apoioQueAlcanca` é `_primeiroQueAlcanca(dilettaContrastAALarge, …)` — **piso 3,0**, que é o de
texto grande. `_degrauEntre` **não consulta contraste nenhum**.

| | valor | sobre branco | sobre `errorSubtle` |
|---|---|---|---|
| `textTertiary` CLARO (Bold declara o par) | **`#80798D`** | **4,17:1** ❌ | **3,83:1** ❌ |
| `textTertiary` ESCURO | `#8D91A0` | 5,78:1 sobre `#14151F` ✅ | — |

E o papel carrega corpo, não título: `DilettaInlineAlert:115` pinta a mensagem em **13px regular**;
`DilettaDetailRow:109` pinta o valor em **14px** (12 no compacto). O piso deles é 4,5. São **34 usos
em 19 peças** da linguagem.

**A tese, e ela não é o número:**

> Quem **não** declara o par cai no fallback e recebe `neutral03` (`#737373`, **4,74:1** — passa).
> Quem declara os dois extremos recebe uma cor que reprova. **A declaração do filho é o que apaga o
> piso.**

→ [pedidos/2026-09-22-o-papel-que-carrega-texto-de-corpo-tem-piso-de-texto-grande.md](pedidos/2026-09-22-o-papel-que-carrega-texto-de-corpo-tem-piso-de-texto-grande.md)

---

## 4 · Quatro coisas que os chats deram como falta do DS — e o código desmente

Esta seção vale mais que os dois pedidos juntos, porque é o que **não** foi escrito.

**(a) As legendas coloridas do medidor não são gap do DS.** A auditoria mediu `warningGrafico`
(`#F6A21A`, **2,08:1**) e `error` (`#EF4757`, **3,68:1**) sobre superfície branca e concluiu falta na
linguagem. A linguagem tem o papel: `warningOnSurface` e `errorOnSurface`, derivados com
`dilettaContrastAANormal` (`diletta_scheme.dart:641-649`), resolvem na paleta do Bold em `#85520A`
(**6,54:1**) e `#B42318` (**6,57:1**). O desenho pegou a tinta de **gráfico** para carregar
**texto** — que é exatamente a distinção que o pai escreveu no veredito de 17/09. **Conserto no
Figma, não pedido.** E, pela mesma medição, **a parte 2 daquele pedido não se reabre**: a condição
que o pai deixou escrita era *«um segundo filho medindo tinta de estado sobre a superfície»* — o
segundo filho mediu, e a resposta é que o papel já existe.

**(b) O botão desabilitado já carrega o estado na semântica.** O auditor não pôde verificar no
Figma. `diletta_button.dart:279-280` e `:332-333`: `Semantics(button: true, enabled: !_disabled)`.
Não é gap.

**(c) O slot `acima` não precisa «virar lista».** O prototipador escreveu *«não existe e precisa ir
ao repo: ou o slot vira lista, ou a biblioteca ganha uma peça de pilha de avisos»*. Em
`diletta_bottom_app.dart:105`, `acima` é `Widget?` — **uma `Column` empilha os dois avisos e
pronto**. A limitação é do `INSTANCE_SWAP` do Figma, que aceita uma instância só, e o próprio
relatório dele já dizia isso duas linhas depois (*«em Dart isso é uma `Column`, sem andaime»*). É
item da biblioteca do Figma, não pedido ao pai.

**(d) «Como o app roda só escuro, não é defeito no app real» — não é verdade.** A frase aparece
duas vezes no relatório de acessibilidade e desarmaria o pedido do item 3. O app tem tela de
Aparência com **Claro, Escuro e Do sistema** (`aparencia_screen.dart:16-18`), persistida em
`SharedPreferences` (`theme_controller.dart:26-29`). O escuro é o **default**, não o único. O modo
claro está a um toque.

---

## 5 · O pedido do medidor ganhou o preço medido — nota, não pedido novo

O pedido de ontem
([o medidor não se lê](pedidos/2026-09-21-o-medidor-nao-se-le-nem-pela-semantica-nem-pela-bula.md))
ainda não foi enviado, e nesse meio-tempo o fluxo virou código. **O contorno que a seção «Se você
disser não» previa deixou de ser hipótese.**

`lib/features/limites/presentation/widgets/medidor_de_teto.dart` (commit `b8a0a44e`, 22/09 14h35),
172 linhas: `ExcludeSemantics` em volta do `DilettaProgressBar.value` (`:62`) e um `Semantics` com
`excludeSemantics: true` por cima do `DilettaAppListRow` (`:96`, `:107`). **O consumidor não
contorna a falta — ele desliga duas peças do pai e reescreve o nó à mão**, com as palavras deste
fluxo, que não viajam para a segunda tela.

O mérito do pedido não mudou. O que mudou é que o preço agora tem arquivo, linha e data — e uma
dívida com prazo: quando o campo chegar, este arquivo passa a **esconder** a semântica nova, e nada
acusa. A nota foi escrita dentro do próprio pedido, como `## Nota do filho`, que é um dos quatro
nomes que a varredura da família reconhece.

---

## 6 · O que é nosso, e não se pede

| item | onde | o que é |
|---|---|---|
| `_TituloPrimario` sem `header` | `coreflow_barra_de_topo.dart:312` | a metade nossa do item 2 — uma linha, 102 telas |
| a folha lê `primary08` cru da Primitiva no claro | `coreflow_folha.dart:257-265` | a **D102**, que o prototipador reabriu hoje: no `Bold · Escuro` a instância herda `c.surface`, no claro herda a primitiva direto. É nossa peça |
| a área segura da folha não existe como propriedade no Figma | `coreflow_folha.dart:155-158`, `:246` | o corpo soma `padding.bottom` em runtime; no desenho vira override manual em cada instância. Cabe um booleano na peça da biblioteca, como o `BottomApp` já faz com o indicador de home |
| `acima` só existe na factory `.button` | `diletta_bottom_app.dart:105`, `_ButtonVariant:202` | medido e confirmado: nem `nav`, nem `keyboard`, nem `livre`. **Fica como observação, não como pedido** — nenhuma tela real pediu o slot em outra variante, e pedido sem caso medido volta reprovado |
| três linhas do índice têm uma quarta célula invisível | `docs/PEDIDOS.md` | a tabela declara 3 colunas e essas linhas escrevem 4 (as três são de 11/08): o renderizador **descarta a última**, e o texto que some é o «achado» de cada uma — *«metade das telas tinha o fundo errado»*, numa delas. O gate novo confere arquivo↔linha, não a contagem de colunas. Achado resolvendo o conflito de hoje; **é nosso arquivo, conserto daqui** |
| truncamento da linha secundária a 200% (1.4.4) | `medidor_de_teto.dart` | o auditor marcou como dono **app**. `Flexible` + `maxLines: 2`. Não é DS |

---

## Rodada de 2026-09-21 · tarde

A rodada da manhã fechou às 10h52. Esta cobre **10h52 → 17h57**, e o dia rendeu mais depois do
almoço do que antes: **quatro tags do pai**, um defeito que atravessou os três níveis em três horas,
e uma auditoria de acessibilidade que **reprovou um fluxo por três bloqueantes — e só um sobrevive à
medição**.

**Chats lidos** (transcrição, não resumo de terceiro):

| chat | cwd | até | o que ele produziu pra cá |
|---|---|---|---|
| Duas linhas acima do botão | `claude_newbold` · `a90fd506` | 17h22 | **o mais produtivo do dia**: defeito de DS achado numa foto, consertado no pai, publicado nos três níveis |
| Meus limites (fluxo novo) | `claude_newbold` · `9ef7cfe2` | 17h56 | o protótipo no Figma, a auditoria WCAG e a **tabela «falta no DS»** — é daqui que sai o pedido desta rodada |
| PR do Norte Benk | `claude_newbold` · `6bfe0d0d` | 16h17 | PR #768, e a branch antiga apagada do remoto — **nada de DS**, fica pelo rastro do revert |
| esta rotina, a rodada da manhã | `bold-ds-pacote` · `aeb36817` | 11h31 | o pino do avô, interrompido por ela — e o que ele mediu antes de parar |
| esta rotina, a rodada da tarde | `bold-ds-pacote` · `c014e6ef` | — | esta |
| `aprendizado-do-dia` (rotina) | — | — | ignorada por contrato |

---

### 0 · O QUE O PAI RESPONDEU — e são quatro tags numa tarde

Isto vem primeiro porque muda o desenho do que vem depois. Entre 11h08 e 17h43 o pai publicou
**`v0.204.0`, `v0.205.0`, `v0.206.0` e `v0.207.0`**, com espelho web em cada uma. Duas delas fecham
pedidos nossos, e uma **muda o contrato pelo qual esta rotina escreve pedido**.

| tag | hora | o que é | o que fecha |
|---|---|---|---|
| `v0.204.0` | 11h08 | `DilettaBottomApp.button(acima:)` — o que vai acima do CTA entra na barra | o defeito do item 1, achado hoje às 10h38 |
| `v0.205.0` | 13h11 | `<diletta-dialog>` e `<diletta-dropdown>` atravessaram | **duas linhas do índice**: o diálogo e o campo de seleção |
| `v0.206.0` | 17h35 | `DilettaManifesto.busca` passou a ignorar acento | — · **e mexeu no contrato** |
| `v0.207.0` | 17h43 | `semanticLabel` no botão | o pedido escrito **hoje de manhã** por outro chat |

**A `v0.207.0` é o ciclo mais curto que esta família já teve.** O pedido
[o botão não tem onde pôr o nome que o leitor de tela anuncia](pedidos/2026-09-21-o-botao-nao-tem-onde-por-o-nome-que-o-leitor-de-tela-anuncia.md)
foi escrito pelo chat da adoção do Internet Banking (filho B) e commitado aqui em `5c26612`. O
veredito é **ENTRA nos dois** — `semanticLabel` no Dart caindo no `label`, `rotulo-acessivel` na web
virando `aria-label` no `<button>` INTERNO —, e a parte que interessa a esta fila é a outra:

> **A dúvida do pedido virou a metade mais importante da entrega.** Quem escreveu não sabia se o
> campo abriria a porta pra anunciar nome diferente do texto da tela, citou a §2.5.3 (*Label in
> Name*) e disse *«você tem os 110 gates e a régua; eu tenho o caso»*. O pai respondeu que a citação
> estava certa e **transformou a norma em `assert`** — que some em release, ignora acento e caixa.
> A seção «o que eu NÃO sei» pagou mais que a seção «o que eu proponho».

E o campo **não é obrigatório**, ao contrário do `DilettaIconButton.semanticLabel`: *«lá não há outro
nome, aqui há, e obrigar faria 200 chamadas repetirem o rótulo»*.

**O contrato mudou, e é obrigação desta rotina (v0.206.0).** `docs/PEDIDO-DO-FILHO.md` ganhou uma
exigência: **pedido de PEÇA NOVA agora começa com uma linha de código**, e ela é uma só —

```dart
DilettaManifesto.busca('<o que você precisa>')   // e escreva aqui o que ela devolveu
```

O motivo está escrito lá e é nosso: *«outro publicou um pedido de campo de seleção medindo as 61
peças do degrau do meio — a peça estava na linguagem, declarada»*. É a linha
«[não existe campo de seleção na família](pedidos/2026-09-21-nao-existe-campo-de-selecao-na-familia.md)»
deste índice, virada régua. **Vazio dela é resposta**, e conta como número. O pedido desta rodada não
é peça nova, e por isso não abre com `busca` — mas o próximo que for, abre.

### A deriva, e ela nasceu hoje de tarde

| | pino | ponta | deriva |
|---|---|---|---|
| app (`ds_vendor.json`, 21/09) | filho `v0.113.0` · pai `v0.204.0` | — | — |
| filho (`coreflow_design_system/pubspec.yaml:34`) | pai `v0.204.0` | pai `v0.207.0` | **3 tags** |

As três são de hoje entre 13h11 e 17h43. **Nenhuma é urgente para nós**: a `v0.205.0` é instância
web, a `v0.206.0` é a busca do manifesto, e a `v0.207.0` é o campo do botão — que interessa ao filho
B, não a esta casa, até alguém aqui precisar anunciar um nome diferente do rótulo.

---

## 1 · O defeito que atravessou os três níveis numa tarde — FECHADO

**Como começou**: ela mandou uma foto da tela de revisão de transação e uma pergunta de uma linha —
*«por que nessa tela existem duas linhas acima do botão? É do design system ou da tela?»*

**Era do design system.** Duas barras de vidro empilhadas, cada uma desenhando a própria aresta de
cima. Medido no print antes de abrir código: linha 1 em y=757 com 467px (a tela inteira), linha 2 em
y=786 com 425px (recuada dos dois lados).

**A causa, e ela está escrita no arquivo que sobrou** ([coreflow_rodape.dart:162](../packages/coreflow/lib/src/coreflow_rodape.dart)):

> *«Aqui havia um desvio: com `acima`, esta casca embrulhava o rodapé do pai numa SEGUNDA barra […]
> O preço apareceu na foto da revisão do Pix: duas linhas acima do botão.»*

**O conserto foi no pai, não aqui, e a razão é boa**: o slot passou a morar onde mora a geometria —
`DilettaBottomApp.button(acima:)`, um vidro, uma aresta, um indicador de home, com teto de 30% da
altura em tela curta. A casca ficou com **quatro linhas úteis** de repasse
([coreflow_rodape.dart:175](../packages/coreflow/lib/src/coreflow_rodape.dart)).

| nível | o que saiu | verificação |
|---|---|---|
| pai `ds-diletta` | `0691872` · `v0.204.0` · `web-v0.204.0` | 877 testes, +7 novos |
| filho `bold-ds` | `4709890` + `53212e9` · `v0.113.0` | 108 testes, +3 novos |
| app | `68ded84e`, depois refeito em `1dbab237` | 419 testes de Pix e autenticação |

**E foi conferido na tela rodando, não no argumento**: preview isolado da tela real com o aparelho
forçado a Tier C — o pior caso, que é justamente onde o selo aparece e onde a segunda linha nascia.
Duas linhas → uma. 393 pontos de largura, e a segunda não existe mais.

**Nada a pedir. Nada a fazer.** Fica aqui porque é o item que produziu a `v0.204.0`, que é o pino de
hoje.

---

## 2 · A auditoria reprovou o fluxo por TRÊS bloqueantes, e dois não existem

Este é o item que vale a rodada, e ele só aparece porque **duas medições independentes discordaram** —
o `auditor-acessibilidade` leu o protótipo no Figma, o `construtor-biblioteca-figma` leu os hex reais
das variáveis, e eu fui ao Dart da `v0.204.0` conferir os dois. **A ordem do contrato manda escrever
a contradição antes do pedido, porque ela vale mais.**

| bloqueante da auditoria | veredito da medição | onde medi |
|---|---|---|
| **1.4.11** · o medidor não alcança 3:1 contra o trilho | **FALSO — e a fonte do erro é nossa** | `diletta_scheme.dart:504,714` |
| **4.1.2 / 1.1.1** · o percentual não existe em leitura nenhuma | **VERDADEIRO** | `diletta_progress_bar.dart` · zero `Semantics` |
| **1.4.4** · o campo de valor quebra em 100% | **FALSO no código — é do Figma** | `diletta_amount_field.dart` · nenhuma largura fixa |

**O 1.4.11 é o mais instrutivo, porque o defeito é de DOCUMENTAÇÃO e ele viajou três saltos.** A
auditoria citou o comentário do componente no Figma; o comentário no Figma copiou o `///` do Dart; e
o `///` do Dart diz, hoje, na `v0.204.0`:

> *«Elemento gráfico pede 3:1 (WCAG 1.4.11). Contra o trilho `neutral07`: […] `warning` 1,82 · 1,17
> […] Nenhum alcança 3:1»* — [diletta_progress_bar.dart:83–91](https://bitbucket.org/diletta/ds-diletta)

**Só que o trilho não é `neutral07` desde a `v0.64.0`.** Quem o tirou de lá fomos nós, no pedido
[o trilho da barra é claro nos dois temas](pedidos/2026-08-10-o-trilho-da-barra-e-claro-nos-dois-temas.md)
(10/08), que criou `trilhoDeMedidor` **e** `warningGrafico` exatamente para resolver este número. A
linha 121 do widget pinta `s.trilhoDeMedidor`, e o papel é derivado com piso:

```dart
warningGrafico: _primeiroQueAlcanca(3.0, trilho, [p.warning04, p.warning03, p.warning02, p.warning01])
```

**O conserto entrou há seis semanas e a tabela do `///` ficou.** Hoje ela reprovou um fluxo de
dinheiro inteiro, por um defeito que já não existe. E nem contra `neutral07` os números batem mais:
daria 1,22 e 1,04, que são os do nosso pedido de 10/08, não os 1,82 e 1,17 que o texto repete.

> **A ressalva que nenhum dos dois agentes escreveu, e que eu medi:** `_primeiroQueAlcanca`
> ([diletta_scheme.dart:1035](https://bitbucket.org/diletta/ds-diletta)) **não garante o piso** — se
> nenhum candidato alcança, ele devolve o melhor da lista e segue em frente, calado. Na paleta do
> Bold os seis tons passam (3,10 a 6,39). Em outra paleta, podem não passar, e **nada acusa**. Isso
> é degrau de um gate, não de um `///`, e está no pedido.

**O 1.4.4 é do desenho, não do código.** A auditoria viu `"4.200"` quebrar em duas linhas por uma
largura fixa `w-[91px]` no frame. Procurei a largura no Dart e ela não existe: nem em
`diletta_amount_field.dart` (a única medida é `SizedBox(width: DilettaSpacing.s2)`), nem na casca
[coreflow_campo_de_valor.dart](../packages/coreflow/lib/src/coreflow_campo_de_valor.dart), que só
repassa porte. **É defeito do protótipo**, e conserta-se no Figma.

**E um quarto achado da auditoria também cai**: o glifo branco sobre o âmbar a 2,1:1. O
`DilettaSpotIcon` não pinta branco — pinta `s.onWarning`, que é medido
([diletta_spot_icon.dart:77](https://bitbucket.org/diletta/ds-diletta)). O comentário do próprio
arquivo diz que *«era `palette.white` […] nos cinco»* e deixou de ser. Se a auditoria viu branco
numa tela, o defeito é de quem montou à mão.

**Placar: de três bloqueantes, um é real.** E dos dois falsos, um é culpa nossa — do `///` que não
acompanhou o próprio conserto.

---

## 3 · PEDIDO NOVO — o medidor não se lê, e a sua própria bula mente

**Escrito**: [o medidor não se lê, nem por quem usa leitor de tela nem por quem lê a bula dele](pedidos/2026-09-21-o-medidor-nao-se-le-nem-pela-semantica-nem-pela-bula.md)

Junta os dois defeitos que sobraram do item 2, e eles são do **mesmo arquivo**, `diletta_progress_bar.dart`:

- **`Semantics` ausente** — zero ocorrências no `build`, conferido na `v0.204.0`. O percentual só
  existe se o consumidor escrever no `caption`, e o leitor de tela não anuncia progresso nenhum.
  **Isto é a deixa do nosso pedido de 09/08**: ali o contraste do `warning` fez o pai pôr o TEXTO
  junto dos dois medidores — mas o texto está na LINHA IRMÃ, e não na barra. Quem vê, lê. Quem ouve,
  não.
- **A tabela de contraste do `///`** — seis semanas atrás do conserto, e hoje custou um bloqueante
  falso numa auditoria. Proposta: regerar a tabela a partir de `trilhoDeMedidor` e **travar num teste
  que recalcula**, em vez de repetir texto. E, junto, o degrau que eu medi: `_primeiroQueAlcanca` que
  não alcança devolve o melhor sem avisar.

**Por que um pedido só e não dois**: são o mesmo arquivo, a mesma peça e a mesma auditoria, e a
segunda metade é a explicação de por que a primeira demorou a aparecer — a bula dizia que o problema
era a cor, então ninguém olhou a semântica.

**Este pedido não abre com `DilettaManifesto.busca`** e a razão está escrita nele: não é peça nova, é
campo ausente e documentação velha numa peça que existe e que nós mesmos ajudamos a consertar duas
vezes.

---

## 4 · O que a tabela «falta no DS» trouxe e NÃO virou pedido

O `construtor-biblioteca-figma` devolveu seis itens (F1–F6). Dois viraram o pedido do item 3. Os
outros quatro morrem aqui, e cada um por um motivo diferente — **é o trabalho de separar «nosso» de
«pedido» que a fila existe pra fazer**.

| item | o que é | por que não é pedido |
|---|---|---|
| **F3** · não existe linha de limite com medidor | proposta de `DilettaLimitRow` novo | **o slot já existe**: `DilettaAppListRow.footer` está no Dart em [`diletta_app_list.dart:1450`](https://bitbucket.org/diletta/ds-diletta), e o `///` da própria barra cita esse uso. **Pedir peça nova pra um slot que existe é exatamente o que a `v0.206.0` acabou de tornar mais caro.** O que falta é a linha de limite em si, e ela é **nossa** — monta-se em `packages/coreflow` com o `footer` |
| **F4** · a legenda do medidor não muda de tinta com o tom | `caption` é sempre `s.textPlaceholder` | **verdade, e é pequeno demais sozinho** — e esbarra na regra que o próprio pai escreveu no veredito de 09/08: cor não é informação, o texto é obrigatório de qualquer jeito. Fica anotado para pegar carona no próximo pedido do medidor, se houver |
| **F5** · números crus onde há token | `SizedBox(height: 4)` e `height: 2` em `diletta_amount_display.dart:100,108`; `DilettaSpacing.s1` vale **4** e `s0_5` vale **2** (conferido em `tokens/spacing.tokens.json`) | **higiene do pai**, duas linhas, sem consumidor bloqueado. Vai por aviso, não por pedido |
| **F6** · o glifo do alerta | branco sobre âmbar daria 2,08:1 | **não existe** — o código pinta `s.onWarning`. Ver item 2 |

**E um que não é do DS nem nosso, é da biblioteca do Figma**: o `AppListRow` do Figma (`61:78`) não
expõe o slot `footer` que o Dart tem. É o que faria a linha de limite existir sem widget novo. O
construtor **não mexeu** porque a peça tem 17 instâncias no protótipo de onboarding — **decisão dela**.

---

## 5 · A entrega parou no meio, e nada acusou — gate escrito por outro chat

Isto é de hoje e é sobre a nossa própria `v0.113.0`. Outro chat encontrou e commitou o gate em
`ca5e226`: [uma_versao_e_uma_tag_test.dart](../packages/coreflow_design_system/test/uma_versao_e_uma_tag_test.dart).

**O que aconteceu, medido nas datas das tags deste repo:**

| | hora |
|---|---|
| `v0.113.0` emitida | **11h45** |
| `package.json` do pacote web | ficou em **0.112.0** |
| `web-v0.113.0` emitida | **13h21** |

**96 minutos** em que o consumidor resolvia uma tag que não existia, com os 497 testes desta casa
passando o tempo todo — *«nada acusou, porque nada olhava»*. A causa é de classe, não de caso: a tag
do monorepo não publica a instância web; quem publica é `tool/espelha_o_web.sh`, rodado à mão depois.
**Memória de pessoa não é gate.** E o pai já mediu a mesma classe do lado dele: 23 tags de 279
entregavam um número diferente do nome.

O gate mede as duas coisas que dão para medir sem rede — os dois números do repo, e se cada `vX.Y.Z`
tem a `web-vX.Y.Z` ao lado. Deliberadamente **não** confere o conteúdo da tag publicada.

**Nada a fazer**: já está na `main`. Fica registrado porque a rodada da manhã relatou a `v0.113.0`
como entregue, e ela estava entregue pela metade.

---

## 6 · Rastro do dia no app — nenhum DS, mas muda onde o DS chega

Sem item de fila, e sem nada a pedir. Fica pelo endereço, que mudou duas vezes.

- A vendorização saiu primeiro na branch errada (`feat/norte-benk-hml`, commit `68ded84e`), **o push
  saiu segundos antes do «não suba nessa branch»**, e ela escolheu **revert com commit novo** em vez
  de reescrita de histórico — `a650da33`. A branch remota foi apagada depois, a pedido dela.
- O endereço que vale é **`chore/ds-v0.113.0`, saída de `development`, commit `1dbab237`**, já no
  remoto. Leva junto uma correção no `tool/ds_vendor.sh` do app, que era o que bloqueava a
  vendorização a partir da `development`.
- **Sem PR.** O destino pelo fluxo de lá é `release/homologation`.

**Não medi o conteúdo dessa correção de script** e não vou: é `tool/` do app, fora das três casas
desta fila, e nenhuma linha dela toca `packages/`.

---

## O que esta rodada escreveu, e o que espera o envio dela

**Escrito, commitado local, NADA enviado:**

| arquivo | o quê |
|---|---|
| `docs/FILA-DOS-CHATS.md` | esta rodada |
| `docs/PEDIDOS.md` | o pedido novo, mais **três vereditos que chegaram hoje de tarde** |
| `docs/pedidos/2026-09-21-o-medidor-nao-se-le-nem-pela-semantica-nem-pela-bula.md` | o pedido do item 3 |

**Nenhuma tag. Nenhum PR. Nenhum merge. Nenhum push.** E nenhum código consertado: os itens 2, 4 e 5
são achados, e achado vira linha aqui. **O pino do avô continua na `v0.204.0`**, três tags atrás da
ponta — subir é conserto de código, e não é desta rotina.

---

## Rodada de 2026-09-21

**Chats lidos** (transcrição, não resumo de terceiro). A janela vai de **18/09 10h54** — onde a
rodada passada parou — até **hoje, 21/09**:

| chat | cwd | até | o que ele produziu pra cá |
|---|---|---|---|
| Norte Benk em HML | `claude_newbold` · `6bfe0d0d` | 18/09 17h12 | **o mais caro da rodada**: a cidade do Bold no filho errado, o fundo do cliente, e **351 linhas de andaime** |
| Berço Coreflow (white label) | `claude_newbold` · `22128cb9` | 18/09 17h36 | as 13 melhorias entraram no site (Versão 90) — **nada pra cá**, é o site |
| Recepção de envios do Berço | `claude_newbold` · `43e09e89` | 18/09 17h39 | o rastreio M1–M13 e a página pra squad — **nada pra cá**, é o site e o app |
| Árvore do Coreflow (diagrama) | `claude_newbold` · `84ecce8e` | 18/09 15h51 | nada pra cá — é desenho, e o link é o de sempre |
| esta rotina, a rodada de 18/09 | `bold-ds-pacote` · `37301ddd` | 18/09 11h44 | a rodada anterior — e **o push saiu, porque ela mandou** (*"sobe na main"*, 11h41) |
| `aprendizado-do-dia` (rotina) | `claude_newbold` · `72f5b16b` | 18/09 10h39 | ignorada por contrato — alimenta os agentes de UI/UX, não esta fila |
| **19 e 20/09** | — | — | **fim de semana: zero sessões, zero turnos** (conferido turno a turno, não presumido) |

**E aqui está a coisa estranha desta rodada: ninguém conversou, e tudo andou.** Enquanto os chats
estavam parados, o `origin/main` do `bold-ds` recebeu **13 commits e três tags** (`v0.110.0` ·
`v0.111.0` · `v0.112.0`) — **todos os treze da Tatiana**, entre 18/09 11h55 e **hoje 02h11**. E o pai
recebeu **9 commits e cinco tags de linguagem** (`v0.200.0` · `v0.200.1` · `v0.201.0` · `v0.202.0` ·
`v0.203.0`), a última **hoje às 10h29**. **`main` local × `origin/main` = ahead 0, behind 13.**

> **Duas ressalvas de método, porque mudam o que você lê abaixo.**
>
> 1. **A `main` local NÃO foi adiantada.** O `git merge --ff-only` foi recusado pelo sandbox desta
>    rodada. Então **tudo que está medido abaixo foi medido em `origin/main`**, não na árvore local —
>    e o commit desta rodada nasce 13 commits atrás. O comando de sincronia está no fim.
> 2. **O `PEDIDOS.md` não foi tocado nesta rodada, de propósito.** A Tatiana o editou em cinco dos
>    treze commits; reescrever a cópia local, que está atrasada, apagaria o trabalho dela num rebase.
>    **A linha que falta está escrita no item 1, pronta pra colar depois da sincronia.**

**A regra segue sendo dela**: esta rodada **não deu push, não abriu PR, não mesclou nada e não criou
tag**, e **não consertou código**.

---

## 1 · SEIS VEREDITOS CHEGARAM HOJE ÀS 10h29 — e nenhum deles está no nosso índice

**Estado**: **ABERTO, e é o primeiro porque muda o desenho de tudo que vem depois.**

A `v0.203.0` do pai (`be3f918`, hoje 10h29) tem o título que diz o tamanho: *"seis pedidos julgados, e
os três que eram defeito saíram juntos"*. Cinco desses seis são pedidos que **a Tatiana escreveu no
fim de semana**, e o sexto é a retratação de um deles.

| pedido (nosso, no `origin/main`) | escrito | veredito no ledger do pai | onde |
|---|---|---|---|
| `2026-09-20-cada-atributo-redesenha-o-shadow-inteiro` | 20/09 19h20 | **ENTRA a metade que não quebra ninguém** — `mudouAtributo()` na `base.js`; o agrupamento por microtask **não** entra (quebraria `setAttribute`+leitura em 110 gates dele, nos nossos e nas 177 chamadas guardadas) | v0.203.0 |
| `2026-09-20-o-relogio-do-pending-nao-casa-a-regra-que-o-alinha` | 20/09 19h30 | **ENTRA como escrito.** Defeito de 21/08, um mês no ar, invisível aos 110 gates *porque todos perguntam se o glifo existe, e ele existia* | v0.203.0 |
| `2026-09-21-o-anel-de-foco-do-campo-nao-se-ve` | hoje 01h56 | **ENTRA nos dois lados.** E o número dele: **1,17 é o mesmo `surfaceMuted` que esta casa já tirou do anel do toggle** — mesmo número, outro campo, três semanas depois. *Conserto de caso não fecha classe* | v0.203.0 |
| `2026-09-21-nao-existe-campo-de-selecao-na-familia` | hoje 01h29 | **ENTRA na fila da web, e a premissa estava errada**: `DilettaDropdown` existe na linguagem com `destino: ambos`. A busca varreu o **degrau do meio** | fila da web |
| `2026-09-21-o-dialogo-e-a-folha-existem-no-dart-e-nao-atravessam` | hoje 01h29 | **O DIÁLOGO entra e a declaração dele estava ERRADA** (`destino: codigo` numa peça que é `ambos`; a fila da web foi de 13 pra 14). **A FOLHA é do degrau do meio** — o `coreflow_folha` mora aqui | v0.203.0 (o destino) |
| `2026-09-21-o-botao-destrutivo-nao-passa-em-AA-no-escuro` | hoje 02h04 | **FECHADO pela retratação dela mesma**, 7 minutos depois (`2efacd9`, 02h11). O par passa: 6,57 no claro, **11,26** no escuro, porque no escuro a linguagem INVERTE o botão | — |

**Três coisas que isto deixa aberto, e são de bookkeeping, não de código:**

1. **O índice mentia, e parou de mentir hoje — FECHADO.** Quando esta rodada foi escrita,
   `docs/PEDIDOS.md` tinha **126 linhas de pedido e 16 sem veredito**, e **cinco dessas 16 tinham sido
   julgadas na mesma manhã**. O próprio `PEDIDOS.md` já tinha escrito a regra: *«linha sem veredito é
   uma pergunta em aberto pro pai — e ela vira mentira no dia em que ele responde»*. As cinco colunas
   foram escritas a pedido dela, no mesmo dia: **abertas de 16 para 11**, e a linha do botão destrutivo
   ganhou a confirmação dele e a varredura de 30 linhas aceita. *A regra sobreviveu à própria prova:
   ela pegou oito horas, não seis versões.*
2. **O código não tem.** O `bold-ds` pina o avô na **`v0.202.0`**
   (`packages/coreflow_design_system/pubspec.yaml:34`) e a ponta dele é a **`v0.203.0`**. Os seis
   vereditos estão a um degrau.
3. **A lição que o pai tirou é sobre nós, e é elogiosa.** Sobre a retratação: *«matriz de combinações
   não prova ausência quando a matriz foi montada por suposição — irmã do meu "zero chamadas" que
   tinha duas e do meu gate que casava zero linhas em 35 arquivos. Ele achou em horas; as minhas
   levaram semanas.»*

> **O que foi escrito no `PEDIDOS.md`** (nenhuma linha nova — cinco colunas de veredito em linhas que
> já existiam): `v0.203.0 · web-v0.203.0` no **shadow**, no **relógio** e no **anel de foco**;
> **`fila da web`** no campo de seleção; **`v0.203.0` (o destino) · o resto na fila da web** no
> diálogo/folha. A linha do botão destrutivo já estava marcada RETRATADA pela outra mão e ganhou só a
> confirmação dele.
>
> **E um susto que valeu a conferência**: na primeira passada o casamento por nome de arquivo pegou
> **seis** linhas onde havia cinco. Não era duplicata no índice — é o pedido do diálogo **citando** o
> do shadow no corpo do argumento (*peça com foco preso dentro de shadow precisa que o
> `attributeChangedCallback` não reescreva o shadow a cada atributo*). A escrita foi refeita casando o
> link inteiro. **Três linhas do índice têm uma barra não escapada e ficam com 6 campos em vez de 5** —
> são pré-existentes, não foram tocadas, e ficam registradas aqui porque quebram qualquer leitura
> automática da tabela.

---

## 2 · O item 7 da rodada passada virou linha ABERTA no ledger do PAI — por mão dele, e sem pedido

**Estado**: **ABERTO na casa dele. Nada a fazer aqui, e é o melhor resultado possível.** Depende do 1
(chegou na mesma leitura de ledger).

A rodada de 18/09 mediu o eixo do logo, concluiu *"hoje a diferença não muda nenhuma tela"* e
**decidiu não abrir pedido**. Essa medição está agora no ledger do pai, com data de 18/09, como item
dele:

> **duas peças minhas respondem a mesma pergunta ao contrário** — `DilettaLogo` escolhe claro/escuro
> por `tema.isDark` (`diletta_logo.dart:90`), que é o brilho da PÁGINA, e `DilettaSystemWalletMark`
> escolhe pela **luminância do FUNDO** desde a v0.28.0 […] O filho mediu os cinco sítios dele **e não
> abriu pedido** porque hoje as duas respostas coincidem. **A disciplina foi dele; a incoerência é
> minha.** — *status: ABERTO*

E ele escreveu sozinho a condição que a nossa fila tinha escrito como hipótese: *"uma superfície sob o
logo que NÃO vire com o tema (vidro sobre cor de marca, banner colorido, splash de fato fixo)"*. Mais
o que a nossa fila não tinha visto: *"o escape de hoje não alcança — `color:` na chamada resolve a
TINTA e não escolhe a ARTE"*.

**O que isto prova, e vale mais que o item**: medição sem pedido chegou. Não foi preciso gastar um
pedido para mover a casa do pai — bastou medir e deixar escrito. É o oposto do custo do item 3 da
rodada passada, onde um veredito que existia e não circulou fez um filho nascer com remendo.

---

## 3 · O pedido do fundo está no lugar errado — e ele é TODO nosso

**Estado**: **ABERTO, e é o item mais caro que é nosso.** Não depende de 1 nem de 2: não há nada a
esperar do pai aqui.

Em 18/09 11h37 o chat do HML escreveu à mão
`docs/pedidos/2026-09-18-o-fundo-padrao-e-do-cliente-e-o-filho-nasce-sem-ele.md`. **Duas coisas com
ele, e as duas foram resolvidas nesta rodada:**

**Primeira: está endereçado pra cá.** O cabeçalho diz `para: coreflow (o pai) e o Berço` — e é o único
dos 116 arquivos de `docs/pedidos/` que aponta pra dentro. O `PEDIDOS.md` abre com *«o que este filho
pediu aos pais»*; os destinatários são `ds-diletta` (68 pedidos), `catalogo-diletta` (4) e a dona do
produto (2). **Pela doutrina desta fila — *o que mora em `packages/coreflow` é nosso e se faz aqui* —
nenhum dos quatro itens dele é pedido ao avô.** O arquivo ficou onde está, com uma nota no topo
dizendo isso, e o item passa a ser carregado aqui.

**Segunda: a medição envelheceu em três dias, e foi refeita.** O original mediu na `v0.102.1`; esta
rodada remediu em `origin/main` (**`v0.112.0`**, hoje). **Dez tags depois, nenhum número se moveu:**

| onde | v0.112.0, 21/09 |
|---|---|
| `coreflow_produto.dart` | **0** campos de fundo — as duas linhas que casam `fundo` são comentário sobre o **logo** (`:212`, `:217`) |
| `CoreflowBackdrop` (`coreflow_background.dart:45`) | **7** valores. Dos 4 que o cliente marcou no Berço, **só `vidroFrio` existe** |
| `coreflow/bin/novo_filho.dart` | **0** ocorrências de `fundo`/`backdrop` |
| `norte_benk_coreflow/lib/norte_benk.dart` | **0** — declara paleta, marca e forma; fundo não |

A ordem interna dele é **3 → 1 → 4, com o 2 solto**, e está escrita no arquivo com o porquê de cada
espera. Só o item 2 (a arte de fundo declarada na marca) é candidato a virar pedido de verdade ao avô
— e hoje não é, porque o `CoreflowBackdropScope` é nosso.

---

## 4 · A Aparência foi resolvida no APP — e o preço está medido: 351 linhas

**Estado**: **ABERTO aqui, FECHADO lá.** Depende do 3 — é o mesmo eixo, e o 3 é a forma escrita dele.

Os itens **7 e 8 da rodada de 15/09** (`solido` não serve de fundo de Home + a Aparência não conhece a
curadoria do produto) foram marcados **"nosso"**, para se fazer em `packages/coreflow`. **Eles foram
feitos — do outro lado da fronteira**, em 18/09 17h05, no `app-newbold` (`b33775de`, branch
`feat/norte-benk-hml`, assinado por ela):

| | |
|---|---|
| arquivo novo | `lib/core/theme/fundo_do_app.dart` — **351 linhas** |
| commit | 8 arquivos, **+445 / −54** |
| o que carrega | `enum FundoDoBerco { degradeSimples, harmoniaAnaloga, harmoniaComplementar }` e um `FundoDoApp` que une os fundos desta casa com os do Berço |
| a conta | `camadasDoFundo`, `degradeSimplesDe` com teto de alfa contra `textSecondary`, `matizGirado` em OKLCH com a regra da faixa amarela — **a mesma matemática do site, copiada** |
| como engana o DS | os fundos do Berço são rasterizados e entregues **como a ARTE do estilo `imagem`**, descontando o véu que o `imagem` pousa (branco 0,20 / preto 0,08) |

**Não é crítica ao que foi feito — é a medida do que falta aqui.** O próprio commit escreve a data de
validade: *«Quando o pai desenhar os fundos, `FundoDoBerco` vira valor do enum dele e
`ArteDeFundoGerada` sai»*. E o andaime tem **exatamente a forma do buraco**: os três fundos que ele
implementa são os três que faltam no `CoreflowBackdrop`, e o quarto do Norte Benk (`vidroFrio`) não
está lá porque é o único que esta casa já desenha.

**O que isto muda na fila**: os itens 7 e 8 de 15/09 deixam de ser *"nosso, e ninguém fez"* e passam a
ser ***"nosso, e alguém já pagou por nós — em outro repo, em linhas que vão ter que ser apagadas"***.
A matemática não precisa ser inventada: ela existe rodando em dois lugares (o Berço e estas 351
linhas), e o trabalho aqui é **portar**, não projetar.

---

## 5 · A deriva: o pacote está a um degrau, e o app dobrou a distância

**Estado**: **ABERTO.** Depende do 1 só no primeiro degrau.

| | pino | ponta | degraus | rodada passada |
|---|---|---|---|---|
| `bold-ds` (ponta remota) → avô | **v0.202.0** | v0.203.0 | **1** | 1 |
| `app-newbold` → `bold-ds` | **v0.102.1** (vendorizado) | v0.112.0 | **10 tags** | 6 |
| `app-newbold` → avô | **v0.180.0** (`packages/diletta_design_system/pubspec.yaml:6`) | v0.203.0 | **30** | 19 |
| `norte_benk_coreflow` no app | **v0.108.0** (`"adiantada": true`) | v0.112.0 | **4 tags** | 0 — nasceu na ponta |

**O recibo do app (`packages/ds_vendor.json`) foi regerado em 18/09 e o `filho`/`base` continuam em
`v0.102.1`**: o trabalho do Norte Benk adicionou a quarta irmã sem subir a base. A deriva do app
**não** foi criada por esta rodada nem pelo fim de semana — ela é a de 10/09 crescendo enquanto o
pacote anda. Onze dias, 10 tags.

---

## 6 · O papel do pai continua parado em branch — e agora os vereditos nem branch têm

**Estado**: **ABERTO como papel** (o mérito segue fechado no código, desde a rodada passada).

`docs/avisos/2026-09-17-o-prefixo-do-css-virou-da-linguagem-e-o-seu-white-label-cala.md` **continua
existindo só em `origin/aviso/o-prefixo-do-css`** (branch de 17/09 10h34, sem commit novo). Em
`origin/main` o último aviso é de **14/09**. É a quarta rodada seguida com essa linha.

**E o canal mudou de forma no fim de semana, sem ninguém anunciar.** Nenhuma branch nova nasceu — as
últimas são de 14/09 e 17/09. Os vereditos da `v0.200.0` até a `v0.203.0` chegaram aqui **pela leitura
direta do ledger dele** (`ds-diletta/docs/PEDIDOS.md`), transcritos à mão pela Tatiana em `1e3caaf`
(18/09) e `f275460` (20/09, *"os oito vereditos voltam para junto das perguntas"*).

**O que isso custa, escrito antes de doer:** ler o ledger funciona e é rápido — foi assim que os oito
voltaram. Mas **o ledger dele não sabe quando nós lemos**. A branch tinha uma data e um dono; a
transcrição depende de alguém lembrar de reler. **Os seis vereditos de hoje são a primeira prova
disso**: eles estão no ledger há oito horas e não estão no nosso índice (item 1), e não há branch, não
há sinal e não há nada que vá avisar.

---

## 7 · Reconferidos na ponta remota, sem mudança

- **A licença Font Awesome Pro** (item 8 de 18/09): sem mudança dos dois lados. Ela respondeu em 15/09
  que **temos a licença**; o `PROCEDENCIA.md` continua não existindo e **o pai continua sem ser
  avisado**. Isto não é código de ninguém: é uma frase que precisa sair daqui pra casa dele.
- **O D76 e o D77** (a arte no Figma que carrega a marca de um filho): sem mudança, seguem esperando
  decisão dela.
- **Code Connect**: segue bloqueado por plano, e o plano B segue entregue.

---

## 8 · Levantado e NÃO medido — entra como levantamento, não como afirmação

**As 13 melhorias do Berço (M1–M13)** foram rastreadas em 18/09 a partir de como a squad do app
consumiu a entrega do Norte Benk, e **entraram no site no mesmo dia (Versão 90)**. O achado que as
reordenou: a squad montou o Norte Benk num `Tenant` de doze campos
(`app-newbold`, `lib/core/tenant/tenant.dart`, PR #747, em `origin/development` e
`origin/release/homologation`) — **não usou nenhum arquivo do anexo do Berço, só o conteúdo**.

**Isto não entra na fila como item, e a razão é a fronteira:** M1–M13 mudam o **site** e o **app**.
Nada ali muda `packages/coreflow`. O que *pode* virar item aqui é uma pergunta que esta rodada **não
mediu** e por isso não afirma: **o `Tenant` de doze campos do app e o `CoreflowProduto` desta casa são
a mesma ficha escrita duas vezes?** Se forem, a segunda é dívida; se não forem, a diferença merece
estar escrita em algum lugar. Fica pra próxima rodada, com medição.

---

## O que mudou de dono desde a rodada anterior

- **Item 1 de 18/09** (o veredito do logo) — fechado lá, e **reaberto na casa do pai como item DELE**
  (item 2 acima). Saiu da nossa fila.
- **Itens 2, 3 e 4 de 18/09** — fechados em 18/09 pelos commits `99a5303`, `1fe7d93` e `03e73cc`, e o
  push saiu no mesmo dia a pedido dela.
- **Item 7 de 18/09** (contraste medido) — de *"medido, não vira pedido"* para *"linha aberta no
  ledger do pai"*. **Não é mais nosso.**
- **Itens 7 e 8 de 15/09** (os fundos e a Aparência) — de *"nosso, por fazer"* para *"nosso, e o app
  já pagou por nós"* (item 4 acima). **Continuam nossos.**
- **Cinco pedidos novos** entraram no `origin/main` pela mão da Tatiana no fim de semana, e **seis
  vereditos** voltaram hoje. Nenhum deles é desta fila — mas o índice deles é (item 1).

---

## O que está pronto pra você enviar

Um commit local, **só documentação**, em `bold-ds-pacote`, branch `main`:

| arquivo | o quê |
|---|---|
| `docs/FILA-DOS-CHATS.md` | esta rodada |
| `docs/pedidos/2026-09-18-o-fundo-padrao-e-do-cliente-e-o-filho-nasce-sem-ele.md` | **arquivo novo** (estava sem versionar): remedido na `v0.112.0`, com a nota de endereçamento e o andaime de 351 linhas |
| `docs/PEDIDOS.md` | **num segundo commit**, depois que ela mandou subir: as cinco colunas de veredito da `v0.203.0` (item 1) |

**Os dois subiram, e cada um esperou a palavra dela** — que é a regra de 15/09 funcionando, não uma
formalidade: a rodada escreveu, ela mandou (*"sobe na main"*, duas vezes), e só então saiu.

| commit | o quê | como foi |
|---|---|---|
| `e09eea3` | a rodada e o pedido do fundo | rebaseado sobre os 13 commits da Tatiana, `2efacd9` → `e09eea3` em fast-forward |
| `edd5511` | as cinco colunas de veredito, e esta seção | `e09eea3` → `edd5511`, fast-forward |

**O `--ff-only` foi recusado pelo sandbox no meio da rodada**, então tudo aqui foi medido em
`origin/main` e não na árvore local — e o primeiro commit nasceu 13 atrás, resolvido no rebase. Fica
anotado porque é a segunda rodada seguida em que a medição e a árvore de trabalho não são o mesmo
lugar.

**Nenhuma tag. Nenhum PR. Nenhum merge.** E nenhum código foi consertado — os itens 3, 4 e 5 são
achados, e achado vira linha aqui. **O pino do avô continua na `v0.202.0`**, um degrau atrás dos seis
vereditos: isso é conserto de código, e não é desta rotina.

---

## Rodada de 2026-09-18

**Chats lidos** (transcrição, não resumo de terceiro):

| chat | cwd | até | o que ele produziu pra cá |
|---|---|---|---|
| Berço Coreflow (white label) | `claude_newbold` · `22128cb9` | 17/09 15h32 | o conserto do `nomeDaMarca`, o pedido do `copyWith`, e **a decisão dela: o negativo é ARQUIVO à parte, não o colorido repintado** |
| Recepção de envios do Berço | `claude_newbold` · `43e09e89` | 17/09 16h47 | **o Norte Benk nasceu**, subiu na `main` remota e saiu na `v0.108.0` |
| `aprendizado-do-dia` (rotina) | `claude_newbold` · `24ca60dc` | 17/09 10h21 | a regra do logo em três linhas, e **o encargo de MEDIR** antes de reabrir |
| O front do onboarding / o que o Michel fez | `claude_newbold` · `a90fd506` | 17/09 15h38 | nada pra cá — é produto, e já estava no item 9 de 15/09 |
| Norte Benk em HML | `claude_newbold` · `6bfe0d0d` | 18/09 10h39 | nada pra cá — app |
| esta rotina, disparada em 17/09 17h37 | `bold-ds-pacote` · `37301ddd` | — | **não escreveu nada**: a rodada de 17/09 não saiu, e é por isso que esta cobre dois dias |

**E o canal do pai andou o dobro da rodada passada.** `git fetch` nos dois: o `ds-diletta` recebeu
**26 commits** e **quatro tags de linguagem** (`v0.196.0` · `v0.197.0` · `v0.198.0` · `v0.199.0`) mais
sete da web; o `bold-ds` remoto recebeu **27 commits** e três tags (`v0.106.0` · `v0.107.0` ·
`v0.108.0`), a última cortada por ela mesma. **`main` local × `origin/main` = ahead 15, behind 27.**

**A regra segue sendo dela**: esta rodada **não deu push, não abriu PR, não mesclou nada e não criou
tag**, e **não consertou código** — achado de código vira linha aqui, não commit. O que ficou pronto
está no fim do arquivo, com o comando.

---

## 1 · O VEREDITO DO LOGO CHEGOU — **ENTRA DIFERENTE**, e já está entregue desde 16/09

**Estado**: **RESPONDIDO e ENTREGUE**, e é o primeiro porque muda o desenho de tudo o que vem
depois. O item 3 da rodada passada fecha aqui.

O pedido de 14/09 (`docs/pedidos/2026-09-14-o-logo-tem-uma-arte-e-a-pagina-tem-duas.md`) foi julgado
em **16/09 11h01** (`00c345d`) e **entregue às 11h38 do mesmo dia**, na **`v0.196.0`** (`205cba0`) —
veredito e entrega na mesma data, que o próprio ledger dele registra como o caso raro.

| | o que o pedido apostou | o que entrou |
|---|---|---|
| forma | convenção de sufixo, como `DilettaIllustration` | **dois campos declarados**: `DilettaBrand.logoEscuro` e `.logoFullEscuro`, nulos por default |
| razão | — | **fronteira**: *"as 59 ilustrações são arte DESTE pacote — eu nomeio os arquivos. O logo é arte do FILHO"*, e derivar `logo-dark.svg` seria o pai escrevendo nome de arquivo dentro da casa do filho, com a falha aparecendo como asset em runtime, no escuro, calada |
| a frase dele | — | ***tinta se deriva, desenho não se deriva*** |
| o que o pedido não pediu | — | **declarar o par não bastaria**: o `DilettaLogo` tinha dois caminhos de tinta e **os dois pintavam**. Par declarado passa a DESLIGAR o `srcIn`, com a precedência escrita — **chamada > marca > arquivo** |

E **ele reabriu, por conta própria, a porta que ele mesmo deixou em 20/08** (*arte de marca cujo
formato não aceite `currentColor`*) num caso vizinho: **o formato aceita, a marca é que não aceita** —
que é exatamente o que a retificação de 15/09 desta fila tinha escrito como munição.

> **Duas coisas que o rito não cumpriu, e ficam registradas.**
>
> 1. **O veredito não voltou pro arquivo do pedido.** Não há branch `veredito/*` nova no `bold-ds`
>    (as duas que existem são de 11/09 e 14/09), e `docs/pedidos/2026-09-14-…` em `origin/main`
>    continua com um commit só, o `296290a` dela. Quem abrir o pedido hoje lê um pedido aberto.
> 2. **O SINAL nunca foi dado** — e ele respondeu assim mesmo, lendo o repo. Push não é entrega
>    (`PEDIDO-DO-FILHO.md`, passo 2), mas desta vez o passo que faltava não segurou a resposta.

---

## 2 · A porta está FECHADA deste lado: `marcaNo` não copia o par, e o gate que nasceu ontem já acusa

**Estado**: **ABERTO, e é o item mais caro da rodada.** Depende do 1 — o campo existe no avô desde
16/09, e a ponte até o filho não existe.

`CoreflowProduto.marcaNo(brilho)` reconstrói o plugue inteiro campo a campo porque `DilettaBrand` não
tem `copyWith`. Em `origin/main`, `packages/coreflow/lib/src/coreflow_produto.dart:227-243`, a lista
copia **12 campos**. O plugue do avô na `v0.198.0` — que é o pino de `origin/main`
(`packages/coreflow/pubspec.yaml:23`, subido em `c45410e`, 17/09 13h34) — tem **14**.

**Não é previsão: rodei a régua do próprio gate.** A prova 2 de
`packages/coreflow/test/a_marca_do_modo_nao_perde_campo_test.dart` lê os campos na FONTE do avô com
`RegExp(r'^\s{2}final\s+[\w<>?,\s]+\s(\w+);')` e subtrai a lista que esta casa copia. Passando esse
mesmo regex no `diletta_brand_assets.dart` da `v0.198.0`:

```
campos no plugue: 14
o que o gate acusaria: ['logoEscuro', 'logoFullEscuro']
lista citando campo que não existe: []
```

**O gate que foi escrito ontem pra fechar a CLASSE pega a instância seguinte — e a instância já está
na árvore que os desenvolvedores clonam.** Só que ele não está lá: o gate e o conserto do
`nomeDaMarca` são o commit **`81cad85`, local e não enviado**.

> **Deixou de ser simulação no mesmo dia.** Com o merge do item 4 feito (`03e73cc`), o `ref: v0.198.0`
> e o gate passaram a viver na mesma árvore pela primeira vez, e o teste foi RODADO:
>
> ```
> flutter test  →  104 passam, 1 falha
> a_marca_do_modo_nao_perde_campo_test · «campo novo no plugue do avô derruba este gate»
>   Expected: empty
>     Actual: Set:['logoEscuro', 'logoFullEscuro']
> ```
>
> **A `main` local está vermelha em um teste, e é o teste certo falhando pelo motivo certo** — no
> commit em que o `ref:` sobe, e não seis telas depois.

### CONSERTADO em 18/09, a pedido dela — `99a5303`

`logoEscuro: marca.logoEscuro` e `logoFullEscuro: marca.logoFullEscuro` entraram na cópia, na ordem
do construtor do avô; os dois nomes entraram na lista da prova 2 e na `marcaCheia` da prova 1.
**coreflow 105 verdes, `analyze` limpo.**

**Hoje isso não move um pixel, e é bom que não mova**: nenhum produto declara o par ainda. O que muda
é que declarar passa a funcionar — antes, quem declarasse recebia o positivo nos dois modos, sem erro
e sem teste vermelho.

**Provado por mutação**: tirando as duas linhas, a prova 1 reprova nos dois modos
(`Expected: [...negativo.svg] · Actual: [null, null]`) e a prova 2 segue verde — que é o desenho
declarado do gate, porque acrescentar nome à lista sem acrescentá-lo à cópia não engana quem mede
comportamento.

> **E a régua da separação pegou o meu comentário.** A primeira versão do `///` citava o produto pelo
> nome e pelo caminho do SVG dele, e o `o_coreflow_nao_cita_bold_test` reprovou com
> `lib/src/coreflow_produto.dart:243  assets/logos` — **ela lê comentário, que é justamente por que
> existe**. Reescrito sem os dois, com o caso remetido a esta fila, que é onde nome de produto pode
> aparecer. Ficou registrado no próprio `///`.

**O que este conserto NÃO faz, e é decisão dela**: declarar o par no produto. A porta está aberta; a
arte negativa do segundo filho continua sem `logoEscuro:` declarado no arquivo dele (item 3). Isso
muda o que um cliente vê, e não é conserto de porta.

**E são TRÊS campos perdidos em `origin/main`, não dois.** `nomeDaMarca` também não está na lista de
lá (`grep` por `nomeDaMarca: marca.nomeDaMarca` devolve **0** em `origin/main`). A consequência mudou
de tamanho desde ontem e fica medida com honestidade:

- **o Bold não move um pixel** — `ContaBold.marca` (`conta_bold.dart:23`) **não declara**
  `nomeDaMarca`, então o campo é nulo com ou sem a cópia;
- **o Norte Benk perde o dele** — `norte_benk.dart:33` declara `nomeDaMarca: 'Norte Benk'`, e o
  produto nasceu e saiu na `v0.108.0` com a cópia velha. Na `v0.198.0` o `?? "CPF Seguro"` já morreu
  (o avô consertou na `v0.185.0`): `diletta_cobrand_mark.dart:158` junta os nomes com
  `whereType<String>()`, então o leitor de tela da co-marca **não diz o nome de outro cliente — ele
  simplesmente cala o nome deste**.

**E o gerador nasce com a mesma porta fechada**: o molde da marca em
`packages/coreflow/bin/novo_filho.dart:171-175` oferece `logo`, `logoFull` e
`logoTingePorCurrentColor`, e não menciona `logoEscuro`. Todo filho novo nasce sem saber que o par
existe.

**Esta rodada não consertou nada disso**, por regra. O conserto é de uma linha e meia e o `copyWith`
pedido em 17/09 tira a lista de cena inteira — os dois esperam o envio dela.

---

## 3 · O Norte Benk nasceu com o remendo escrito como espera — um dia DEPOIS do veredito

**Estado**: **ABERTO, e fecha junto com o 2.**

O segundo filho nasceu em 17/09 (`d0de5f6`, 16h00) e saiu na `v0.108.0` (`54ba76b`, 16h17). A arte
negativa dele **está versionada e não alcança ninguém**: `assets/logos/norte_benk_mono.svg`, ao lado
do símbolo e do lockup, com o `///` do próprio arquivo dizendo por quê —
`packages/norte_benk_coreflow/lib/norte_benk.dart:24-31`:

> *"A VERSÃO POSITIVA/NEGATIVA veio do cliente e viaja em `assets/logos/norte_benk_mono.svg`. Ela é
> um **DESENHO à parte** — contraforma que vira traço, símbolo que perde o container —, e não o
> colorido repintado. […] Só que `DilettaBrand` tem UM `logo` […] **Até o pedido entrar, quem monta o
> app aplica este arquivo à mão** onde a colorida não separa do fundo."*

**O pedido entrou no dia anterior.** O filho nasceu carregando a espera de uma resposta que já tinha
chegado, numa árvore que já pinava a `v0.198.0`. Não é defeito de quem escreveu: é o custo exato de o
veredito ter ficado só na casa do pai (item 1, ressalva 1).

E a frase dela de 17/09 10h38 — *"o logo positivo/negativo pode ter um contorno diferente do logo
padrão"* — e a do pai — *"desenho não se deriva"* — são a mesma frase, ditas no mesmo dia, em casas
diferentes, sem uma ter lido a outra.

### FECHADO em 18/09, a pedido dela — `1fe7d93`

A porta abriu no `99a5303` e a declaração entrou logo depois. **E a medição mudou o campo que recebe
o arquivo**: não é `logoEscuro`, é **`logoFullEscuro`**.

O mono é o **LOCKUP**, medido nos arquivos e não deduzido do nome — `viewBox 0 0 380 166` e 7 paths,
os mesmos do lockup colorido, contra `0 0 197 84` e 2 paths do símbolo. Declará-lo no slot do símbolo
poria a palavra de volta nas seis peças do avô que desenham só a marca, no escuro e só no escuro.

**Os números, medidos contra as páginas DESTE produto** (clara `#FFFFFF`, escura `#14181A`), e não
contra as da referência:

| | página clara | página escura |
|---|---|---|
| branco — o mono | 1,00:1 | **17,87:1** |
| azul `#2A57A5` — a marca | 6,99:1 | **2,56:1**, abaixo do piso gráfico de 3:1 |
| ouro `#E8B236` | 1,94:1 | 9,23:1 |

O mono só pode ser a arte do escuro, e é o slot em que entrou. O que ele conserta é o azul a 2,56.

**E o símbolo fica SEM PAR, com a ausência escrita em vez de improvisada.** O cliente não mandou
negativa da marca, e o avô não deriva desenho (*«tinta se deriva, desenho não se deriva»*). `logoEscuro`
fica nulo, o símbolo colorido vale nos dois brilhos como antes, e as seis peças seguem com o azul a
2,56 no escuro. **É pedido ao dono da marca, e o lugar de pedir é o Berço** — na etapa do logo, ao lado
do lockup negativo. Até lá, quem precisar passa `color:` no sítio.

Gate novo `a_negativa_e_do_lockup_e_chega_no_tema_test`, cinco provas, mutação feita: movendo o
arquivo pro slot errado os cinco reprovam, e os que dependem do caminho reprovam DIZENDO o motivo em
vez de estourar num nulo. **Pacote: 15 verdes (eram 10), `analyze` limpo.**

> **E o `logoTingePorCurrentColor: true` fica.** Os três SVG deste produto não têm um `currentColor`
> sequer, então ele não tinge nada — **ele impede**: sem ele, o `srcIn` com a `corDoLogo` que o
> `marcaNo` preenche pintaria o lockup colorido de uma cor só. Estava sem razão escrita e agora tem.

---

## 4 · A `main` local e a remota: o merge não tem mais UM conflito de prosa, tem DEZ

**Estado**: **ABERTO, e é o portão de tudo o que se escrever aqui.** Depende do 5 só para a ordem do
que se resolve dentro dele.

**Retificação da rodada passada, e ela é minha.** O item 1 de 15/09 afirmou, com simulação, que o
merge inteiro tinha **um** conflito e era de prosa. Era verdade naquele dia. Resimulado hoje com
`git merge-tree --write-tree main origin/main`:

| | 15/09 | 18/09 |
|---|---|---|
| divergência | ahead 10 / behind 9 | **ahead 15 / behind 27** |
| conflitos | 1 | **10** |

E a razão não é que a simulação de lá estivesse errada — é que **o remoto andou 18 commits, e um
deles trocou o número que as duas mãos escreviam igual**:

- `docs/PEDIDOS.md` e `docs/pedidos/2026-09-11-o-pacote-web-nao-sai-do-monorepo.md` — **prosa, e a
  resolução continua sendo manter os dois lados**;
- os outros **oito** (`packages/coreflow/pubspec.yaml`, `packages/coreflow_design_system/pubspec.yaml`,
  `packages/coreflow/bin/novo_filho.dart`, os dois `package.json`/lock da web e os dois
  `pubspec.lock` de exemplo) **saem todos de UM commit local, o `261e5af`** — a subida do avô pra
  `v0.194.3`. O remoto passou por cima dela em `c45410e` (avô → `v0.198.0`) e evoluiu o gerador
  junto.

**Quer dizer que a resolução dos oito é uma frase: fica o lado do remoto.** O `261e5af` está
superado, não em disputa. O que exige cabeça são as duas páginas de prosa.

### FEITO em 18/09, a pedido dela — `03e73cc`

O merge foi executado nesta rodada e os dez conflitos estão resolvidos. **Push, PR e tag continuam
sendo dela**; o que mudou foi só a árvore local.

- **os oito de pino**: lado do remoto, nos dois `pubspec.yaml`, no `tagWebDoAvo`, nos dois
  `package.json` da web e nos três locks. **Conferi que o lado remoto é verdade antes de tomá-lo**,
  porque o nosso lock de 15/09 foi escrito à mão sem npm nesta máquina: `v0.198.0` → `4c05ee7` e
  `web-v0.198.0` → `e7460ff` são os shas reais das tags no `ds-diletta`;
- **`docs/pedidos/2026-09-11-…`**: os dois lados ficaram, em ordem cronológica — a Retificação de
  11/09, o VEREDITO do pai (nosso), e a Retificação 2 de 15/09 (deles);
- **`docs/PEDIDOS.md`**: base é o lado remoto, que traz os 13 pedidos novos do item 9 e os vereditos
  de 16/09. Voltaram as três coisas que só existiam aqui — o «fio fechado» dos raios, o veredito da
  `v0.194.4` no catálogo sem tinta (lá a coluna de estado estava vazia) e a linha inteira do
  `copyWith`. **A linha do logo ficou com o VEREDITO de lá e a coluna de estado reescrita**: a D75 já
  fundida, o veredito que não voltou pro arquivo, e a porta ainda fechada deste lado.

**E o merge deixou a suíte vermelha em um teste, que é o item 2.**

---

## 5 · O aviso do prefixo do CSS está em branch — e o conserto já está na `main`, pela outra mão

**Estado**: **mérito FECHADO no código, ABERTO só como papel.**

Branch nova do pai: **`origin/aviso/o-prefixo-do-css`** (17/09 10h34), release `v0.198.0`, com o
título que diz o tamanho: *"o prefixo do CSS é da linguagem, e o white label do filho cala se ele só
subir o `ref:`"*. Toda variável emitida pra web deixou de se chamar `--cps-` (a sigla do PRIMEIRO
consumidor) e passou a ser **`--diletta-*`**; a ponte com o nome velho sai na **`v0.210.0`**.

**E o aviso é sobre nós, com o nosso arquivo citado**: ele mediu o custo já acontecido em
`exemplos/filho_do_coreflow/web/tokens/meu_banco-tokens.css`, *"um banco inventado que nasceu com
`--cps-` em 210 sítios, pelo seu `novo_filho`"*.

O aviso manda fazer quatro coisas **nesta ordem**, e diz o preço da ordem invertida: *"você tem uma
janela em que o white label está mudo"*. **A janela aconteceu, durou 24 minutos e foi medida por quem
a abriu**: `c45410e` subiu o `ref:` às 13h34 e `3629a23` consertou a folha às 13h58, com a prova
colhida num diretório vazio antes de publicar —

```
<diletta-button>  desenhou em  #17a37d   ← o verde de REFERÊNCIA
a nossa folha declarava        #f66fa0   ← o rosa do Bold, que ninguém lia
```

— sem um erro no console, que é o modo silencioso de o CSS falhar. **Conferido hoje na ponta
remota**: `coreflow_css.dart:26` declara `const prefixoDaLinguagem = '--diletta-'` e `:33` o
`prefixoDaPonte`; o `meu_banco-tokens.css` tem **0** `--cps-` e **210** `--diletta-`; a folha do
Norte Benk tem **282** nomes novos e **72** de ponte. Os quatro passos do aviso estão feitos.

**Falta só trazer o papel**: `docs/avisos/2026-09-17-o-prefixo-do-css-virou-da-linguagem-e-o-seu-white-label-cala.md`
existe apenas na branch. É a terceira vez que uma resposta do pai fica parada em branch — e desta vez
a branch chega DEPOIS do conserto, não antes.

---

## 6 · A deriva: o pacote está a um degrau, o app está a seis tags e dezenove degraus

**Estado**: **ABERTO.** Depende do 4.

| | pino | ponta | degraus |
|---|---|---|---|
| `bold-ds` (ponta remota) → avô | **v0.198.0** | v0.199.0 | **1** |
| `app-newbold` → `bold-ds` | **v0.102.1** (vendorizado) | v0.108.0 | **6 tags** |
| `app-newbold` → avô | **v0.180.0** (`packages/diletta_design_system/pubspec.yaml:6`) | v0.199.0 | **19** — eram 15 na rodada passada |

Medido junto, porque muda o tamanho do item 2: **a `v0.199.0` não acrescenta campo ao plugue de
marca** — 14 campos, os mesmos da `v0.198.0`. Subir o pino mais um degrau não aumenta a dívida da
cópia campo a campo.

E a `v0.199.0` traz cinco pedidos do filho B julgados de uma vez, mais a regra que nasceu deles:
*"número em comentário é medição com data de validade e sem alarme"* — 20 pares do `onXSubtle` agora
medidos, o pior em 4,59.

---

## 7 · A escolha por CONTRASTE MEDIDO: esta rodada MEDIU, e **não vira pedido hoje**

**Estado**: **MEDIDO e FECHADO como pedido; segue ABERTO como condição.**

Em 17/09 ela cravou a regra em três linhas (registradas em `~/.claude/design-refs/aprendizados.md`):

1. o logo do cliente entra com as cores dele, sem tinta do DS;
2. positiva/negativa **sai da oferta** e vira **recurso de contraste** — positiva **preta**, negativa
   **branca**;
3. **entra a que gera mais contraste com o fundo daquela tela** — por medição, tela a tela.

O ponto 3 não é a regra que o pai entregou: ele escolhe por **`tema.isDark`**
(`diletta_logo.dart:90`), que é o brilho da PÁGINA. E o chat deixou o encargo escrito pra esta
rotina, com portão: *"medir `razaoAvo` do preto e do branco contra o fundo real de cada tela onde
`DilettaLogo` aparece (página E superfície) […] **Não reabrir o pedido sem essa medição**"*.

**Medido. E a resposta é: hoje a diferença não muda nenhuma tela.**

São **cinco sítios** no app, todos em `lib/features/auth/presentation/screens/` — `splash:108`,
`boas_vindas:101`, `login:187`, `login_recorrente:434`, `ativar_acesso_rapido:145`. Os cinco assentam
sobre `CoreflowBackground`, e o que ela pinta debaixo do logo é uma de duas coisas:

- a base `s.bg` do esquema (`coreflow_background.dart:198-204`), que **é** a página; ou
- a arte do backdrop `imagem` — e a arte é **dois arquivos declarados por modo**:
  `bg_city_light.jpg` e `bg_city_dark.jpg` (`app.dart:691-692`, `core/theme/arte_de_fundo.dart:14-15`).

**As duas viram com o tema.** Nas cinco telas, `tema.isDark` e *"o fundo real desta tela"* dão a
mesma resposta.

**E o sítio que parecia o contraexemplo não é um — é uma contradição de prosa.** O splash passa
`color: DilettaAbsoluteColors.white` na chamada, e o comentário de `splash_screen.dart:106-107`
justifica assim: *"o fundo desta tela é fixo (#0A0B12, casado com o splash nativo) **nos dois
modos**, então a regra do tema — preto no claro — erraria aqui"*. Só que o `backgroundColor` do
`Scaffold` (`:85`) é coberto: quatorze linhas abaixo, `:92` monta
`CoreflowBackground.fixo(estilo: CoreflowBackdrop.imagem)`, que pinta `ColoredBox(s.bg)` e empilha a
arte **do modo** por cima. **A razão escrita não se sustenta no widget logo abaixo dela** — a tinta
branca está certa no escuro e é exceção de mão no claro, por um motivo que o código não confirma.

**O que fica escrito, pro dia em que o caso aparecer** — e é munição pronta, não opinião:

- **a casa do pai já decidiu isto ao contrário, uma vez.** `DilettaSystemWalletMark` (v0.28.0):
  *"o componente escolhe claro/escuro **pela luminância do FUNDO** (e não pelo `isDark`, que erraria
  em banner escuro no tema claro)"*. Duas peças da mesma casa, mesma pergunta, respostas opostas;
- **e o escape de hoje não alcança o caso novo**: `color:` na chamada resolve a TINTA e **não escolhe
  a ARTE**. Em `diletta_logo.dart:90` o `asset` sai de `tema.isDark && temPar`, e `color` não aparece
  nessa linha. No dia em que o Bold declarar o par, o splash no tema claro recebe a arte POSITIVA
  sobre o que quer que esteja ali, e o `color: white` de hoje não conserta isso;
- **e isto não reabre a exclusão nº5 do pedido de 14/09** (*"o eixo que você carrega é BRILHO"*). O
  eixo continua sendo brilho. O que muda é **de quem**: o da página ou o da superfície sob o logo.

**Condição de reabrir, escrita**: um sítio medido em que a superfície debaixo do logo **não vira com
o tema** — vidro sobre cor de marca, banner colorido, ou um splash que de fato fique fixo.

---

## 8 · A arte Font Awesome Pro — sem mudança, e o rastro continua aberto dos dois lados

**Estado**: **mérito FECHADO por ela em 15/09 («temos a licença»); ABERTO no ledger do pai e sem
PROCEDENCIA aqui.** Reconferido hoje:

- a linha de 15/09 segue na seção de abertos do `ds-diletta/docs/PEDIDOS.md`, com *"não é decisão
  minha"* e a condição de fechar escrita: *"a resposta do dono sobre o alcance da licença"*. **Ela
  respondeu; ele não soube.** Viaja junto com o sinal — é a mesma viagem do item 1, e não custa
  veredito a ninguém;
- `find` por `PROCEDENCIA*` neste repo continua devolvendo **vazio**. O arquivo equivalente ao
  `packages/diletta_design_system/PROCEDENCIA.md` do pai não existe aqui nem na cópia do app, que é
  quem de fato redistribui os 355 `.svg.vec`. **Esta rotina não escreve texto de licença por
  inferência** — onde ele mora e com que palavras é decisão dela.

---

## 9 · Treze pedidos novos entraram na `main` remota pela outra mão — e um deles é primo do nosso item 6

**Estado**: **REGISTRO, pra ninguém escrever duas vezes a mesma coisa.**

Entre 15/09 e hoje 09h53, `tatianahasimoto-diletta` escreveu **13 arquivos de pedido** em
`docs/pedidos/` que não existem na `main` local — a frente da web e do Internet Banking:

```
2026-09-15-o-gate-que-nasceu-junto-com-o-codigo-concorda-com-ele.md
2026-09-16-a-familia-de-banner-tem-cinco-pecas-e-nenhuma-atravessa.md
2026-09-16-o-badge-do-spot-icon-nao-atravessa-e-a-web-marca-com-tarja.md
2026-09-16-o-que-a-web-precisa-e-o-dart-nao-carrega.md
2026-09-17-a-ponte-do-prefixo-nao-tem-porta.md
2026-09-17-as-abas-nao-tem-nome-e-o-painel-perde-o-dele.md
2026-09-17-dois-recursos-existem-no-dart-e-nao-atravessam.md
2026-09-17-nao-existe-tinta-de-estado-sobre-a-superficie.md
2026-09-17-o-campo-apaga-o-que-a-pessoa-digitou.md
2026-09-17-o-campo-nao-tem-onde-por-icone-ajuda-nem-botao.md
2026-09-17-o-render-da-linguagem-derruba-o-foco.md
2026-09-17-os-fundos-do-app-se-apoiam-em-quatro-cores-sem-papel.md
2026-09-18-o-verde-de-sucesso-reprova-como-texto-nos-dois-produtos.md
```

**O primo é o de 17/09 sobre os fundos**, e ele NÃO é o nosso item 6 — é o vizinho de linha. Ele
mede que as quatro cores que sustentam os sete fundos (`#FE3976`, `#FE7B5E`, `#FEED35`, `#7B3FF2`)
**não são papel em lugar nenhum**, e pede ao pai que as publique. O nosso item 6 mede outra coisa no
mesmo arquivo: que dois moods decoram com a rampa de **aviso**. **Donos diferentes** — o dele é
vocabulário do pai, o nosso se conserta aqui. Ficam separados, e citados um no outro.

> **`docs/PEDIDOS.md` não foi reescrito nesta rodada, de propósito.** Nenhum pedido novo nasceu aqui
> (ver item 7), e o índice da `main` local está **27 commits atrás** — reescrevê-lo agora fabricaria
> o décimo-primeiro conflito do item 4. Ele se regenera depois do merge.

---

## 10 · Os nossos, reconferidos na ponta remota e sem mudança

Medidos hoje em `origin/main`, todos iguais à rodada passada:

| item | medição de hoje |
|---|---|
| **`CoreflowBotao` não repassa `disabled`** | `grep disabled` em `coreflow_botao.dart` devolve **zero**. Segue a única peça do pacote sem repasse e sem razão escrita |
| **os moods decoram com a cor de ALERTA** | `coreflow_background.dart:265` · `:270` · `:272` — `warning03`/`warning04` de pé |
| **`CoreflowBackdrop.solido` não serve de fundo de Home** | o enum tem os mesmos **sete** valores; `degradeSimples` e `liso` não existem |
| **a tela de Aparência não conhece a curadoria** | `fundosOferecidos` devolve **zero** em `packages/` |

## 11 · Levantado e NÃO medido — entra como levantamento, não como afirmação

- **D81–D85** e **D92–D94**: sem nome novo nos chats desta janela, e sem o nome o `grep` mede a minha
  escrita. Inalterados desde 15/09;
- **o cabeçalho do filho gerado traz a versão do APP, não a do repo.** O `///` de
  `packages/norte_benk_coreflow/lib/norte_benk.dart:11` diz *«Gerado pelo Berço Coreflow em 2026-09-17
  (pai coreflow · bold-ds v0.102.1 · avô v0.180.0)»* — e `v0.102.1`/`v0.180.0` são os pinos da cópia
  VENDORIZADA do `app-newbold`, não os do repo, que naquele dia estava em `v0.107.0` com o avô em
  `v0.198.0`. **Não mexi**: é linha de procedência, registra o que o Berço acreditava no nascimento, e
  o conserto é no Berço (ele lê a versão do lugar errado), não aqui;
- **o gate mais novo do remoto não roda nesta máquina.**
  `packages/coreflow_design_system/test/a_peca_do_avo_le_o_que_esta_folha_declara_test.dart` (de
  `3629a23`, 17/09) lê os fontes das peças web do avô em `node_modules` para perguntar *"a peça do avô
  sai na cor deste produto?"*. Aqui não há **node nem npm**, e a pasta não existe: ele reprova no
  próprio autoteste — `Expected: a value greater than <20> · Actual: <0>`, com a razão escrita
  (*"não li os fontes das peças do avô"*). **Conferido com `git stash` que já reprovava antes do
  conserto de hoje**, então não é regressão nossa: é o mesmo buraco de ferramenta que fez o lock da web
  ser escrito à mão em 15/09. Entra como levantamento porque o conserto é instalar npm nesta máquina, e
  isso é decisão dela;
- **os 42 consertos do onboarding** levantados em 17/09 (5 bloqueios, 27 defeitos, 10 lacunas,
  verificados por refutação: 31 de 55 sobreviveram) — **são de produto, não de DS**, e o maior deles
  é que o ramo pessoa física não envia nada ao servidor. Fica citado porque é a jornada em que o
  fundo de imagem aparece nas 12 telas por acidente de default (item 7 da rodada passada), e não
  porque peça alguma da linguagem esteja envolvida.

---

## O que mudou de dono desde a rodada anterior

- **O item 3 (o logo) FECHOU pelo lado do pai** — respondido em 16/09, entregue na `v0.196.0`. O que
  sobrou dele virou o item 2 desta rodada, que é nosso;
- **o item 4 (Font Awesome) não mudou**, e continua esperando a mesma viagem;
- **o item 1 (a divergência) piorou de propósito**: o remoto andou, e a resolução ficou mais simples,
  não mais difícil;
- **nasceu um filho novo** — `packages/norte_benk_coreflow`, na `main` remota desde 17/09 16h00. É a
  primeira vez que esta fila tem dois produtos para medir, e o item 2 já mede diferente para cada um.

---

## Rodada de 2026-09-15

**Chats lidos** (transcrição, não resumo de terceiro):

| chat | cwd | até | o que ele produziu pra cá |
|---|---|---|---|
| Biblioteca Figma da Diletta | `claude_newbold` | 15/09 17h44 | ondas 8–10, o protótipo do onboarding, e **D80 · D81–D85 · D86–D89 · D92–D94** |
| Berço Coreflow (white label) | `claude_newbold` | 15/09 17h31 | o rename do «Tom de voz», e **a decisão dela sobre o logo** |
| Coreflow é o pai (este repo) | `bold-ds-pacote` | 15/09 11h23 | os quatro merges de resposta do pai, e o `ref:` em v0.194.3 |
| `aprendizado-do-dia` (rotina) | `claude_newbold` | 15/09 10h44 | nada pra esta fila — reescreveu o prompt DESTA rotina |

**E o canal do pai andou muito.** `git fetch` nos dois repos: o `ds-diletta` recebeu **18 commits e
três tags** hoje (`v0.194.4`, `v0.195.0`, `v0.195.1`), e o `bold-ds` remoto recebeu **9 commits e a
tag `v0.105.0`**, de outra mão. Nada disso está na árvore local.

**A regra desta rodada mudou, e é dela** (15/09, 10h40): *«escreve tudo e deixa o envio comigo»*.
Esta rodada **não deu push, não abriu PR, não mesclou nada e não criou tag** — ao contrário da
anterior, que pushou o pedido do logo. O que ficou pronto está no fim deste arquivo, com o comando.

---

## 1 · A `main` local tem 10 commits presos, o remoto andou 9 — e os dois subiram o avô

**Estado**: **ABERTO, e é o primeiro porque tudo o que se escrever aqui nasce em cima de uma árvore
que o remoto não conhece.** Medido com `git rev-list`: `main...origin/main` = **ahead 10, behind 9**.

Os 10 daqui são os quatro merges de resposta do pai de hoje (`516180d`, `c98915c`, `5233636`,
`b60948c`), o `546a0e1` do fio da forma, e o `261e5af` que subiu o avô. Os 9 de lá são a frente web:
o degrau de tipo, os gates do que está instalado, o gerador, e o release `v0.105.0` (`8f4a60d`,
15/09 16h41).

**E o pior não é a divergência, é a duplicata.** As duas pontas subiram o avô de v0.194.0 para
**v0.194.3**, cada uma por sua mão e no mesmo dia:

| onde | commit | assunto |
|---|---|---|
| local, não enviado | `261e5af` | *o avô sobe pra v0.194.3 — as três tags que passaram e o lock do web escrito à mão* |
| remoto, não puxado | `f77074a` | *chore(avo): sobe de v0.194.0 para v0.194.3 — o degrau de tipo da web chega, e o contrato vem junto* |

O mesmo `ref:` nos mesmos pubspecs — e **a duplicata sai de graça, ao contrário do que esta fila
afirmou quando foi escrita.** A primeira versão deste item dizia que o merge conflitaria nos dois
`pubspec.yaml` e nos `package.json`/`package-lock.json` da web, e que seria preciso escolher o lado
do remoto nos locks. **Simulei o merge com `git merge-tree --write-tree main origin/main` e não é
isso**: as duas mãos escreveram o MESMO valor, então o Git auto-mescla e a árvore resultante já sai
certa — `ref: v0.194.3` nos dois pubspecs, `web-v0.194.3` no `package.json` e no `package-lock.json`.
Não há escolha a fazer. *(Previsão sem simulação mede quem escreveu a previsão, que é a mesma classe
do `CoreflowRadius` contado pelo nome da const em 14/09.)*

**O merge inteiro tem UM conflito, e é de prosa**, em
`docs/pedidos/2026-09-11-o-pacote-web-nao-sai-do-monorepo.md`: dois acréscimos ao mesmo arquivo de
pedido, um de cada lado —

| lado | commit | o que acrescentou |
|---|---|---|
| local | `dbebd27` | o **VEREDITO do pai**, vindo da branch `veredito/o-web-sai-por-tag` |
| remoto | `66753d2` | *os 187 componentes do IB eram 50 — e eu não consigo refazer a conta* |

**Nenhum invalida o outro: a resolução é manter os dois**, não escolher lado. Quer dizer que o item 1
não espera nada — nem tag, nem resposta do pai, nem npm. Ele espera só alguém sentar e juntar dois
parágrafos.

> Item 2 da rodada anterior fechou por um lado e reabriu pelo outro: o pino web que ficara em
> `web-v0.193.0` **está em `web-v0.194.3` no remoto**, resolvido por quem tinha npm. A frase da
> rodada passada — *«o filho gerado hoje nasce um número à frente da nossa própria instância web»* —
> deixou de valer lá, e continua valendo na árvore local.

**Esta rotina não mescla.** Merge de branch de veredito do pai e reconciliação de main divergente são
as duas coisas que o prompt dela proíbe, e as duas exigem escolher lado num conflito.

## 2 · O avô está TRÊS tags à frente do pino, e uma delas muda o desenho do que vem depois

**Estado**: **ABERTO.** Depende do 1 — subir o pino numa árvore que já tem duas subidas do avô em
conflito é fabricar a terceira.

Medido em `git show origin/main:packages/coreflow_design_system/pubspec.yaml` (linha 34) e nas tags
do `ds-diletta`:

| | versão | o que é |
|---|---|---|
| pino do `bold-ds` (ponta remota) | **v0.194.3** | `ref:` nos dois pubspecs, e `web-v0.194.3` nos dois `package.json` |
| ponta do `ds-diletta` | **v0.195.1** | 15/09 17h31 |

As três que passaram, e por que importam aqui:

- **`v0.194.4`** (11h38) — *o catálogo viajava quebrado, e com tinta apareceram outros dois*. É o
  **veredito do nosso pedido de 14/09** (`2026-09-14-o-seu-catalogo-web-publicado-renderiza-sem-tinta.md`),
  que estava escrito como *nota, não pede nada*. Ele consertou pela **segunda das três saídas que nós
  oferecemos** e **recusou a terceira por escrito** — e a terceira é justamente a que esta casa tomou
  um andar abaixo (não emitir o catálogo). A razão dele é quem instala, e está no ledger. **A nossa
  decisão não muda**; o que muda é que agora existe um não registrado contra ela, e reabrir sem caso
  novo volta reprovado.
- **`v0.195.0`** (13h11) — *`<diletta-icon>`: o nome viaja, a arte não, e a razão é licença*. É a
  forma do conserto do item 4 desta fila.
- **`v0.195.1`** (17h31) — *a biblioteca `sistema`: as 20 formas cravadas viraram 12 nomes*. Chegou
  50 minutos depois do nosso release `v0.105.0`, que se anuncia com *«o avô vem dois degraus à
  frente»*. **São três, não dois** — a conta do release envelheceu no mesmo dia.

**E a deriva do app é muito maior do que a do pacote.** O `app-newbold` consome `bold-ds v0.102.1`
(`packages/coreflow_design_system/pubspec.yaml:6`, vendorizado), e essa tag pina o avô em
**`v0.180.0`**. Da tag do app até a ponta do avô são **15 degraus** (v0.180.0 → v0.195.1); do pacote
até a ponta, **3**. É essa distância que o **D80** do chat do Figma converteu em conta pronta: no dia
em que o app subir, *o botão destrutivo primário troca glifo e rótulo de branco para preto, nos dois
modos, porque o branco reprova o mínimo de contraste de texto* — cinco amarrações e uma constante.

## 3 · O logo: ela cravou o eixo hoje, e o precedente já existe na casa do pai — RETIFICADO

**Estado**: **o pedido segue sem veredito e sem SINAL**, e esta rodada **escreveu a retificação
dentro do próprio arquivo**, que é a última janela barata.

Os dois fios que a rodada anterior deixou em aberto fecharam, e no mesmo lugar.

**Ela decidiu, às 17h30, com um manual de marca de cliente na mão**: *«quero que você mude o "logo
para fundo escuro" para o logo positivo/negativo, se é que essa versão existe no design system»*.

**E a resposta medida é a munição que faltava.** Em
`packages/diletta_design_system/lib/src/theme/diletta_brand_assets.dart` da ponta do pai, no MESMO
plugue de marca:

```dart
typedef DilettaSeloDeLoja = ({String? escuro, String? claro});
typedef DilettaCarteiraDeSistema = ({String? marcaClara, String? marcaEscura,
                                     String? botaoClaro, String? botaoEscuro});
```

contra `final String logo;` e `final String logoFull;` (linhas 116–117), que são caminho único. **O
selo de loja e a carteira já viajam em par por brilho; o logo do filho, não** — e o `///` dele
explica o par com a nossa frase: *«marca preta some no tema escuro, sem erro e sem golden
quebrando»*, registrado como defeito dele na `v0.28.0`.

Isso baixa o pedido de *capacidade nova* para *assimetria de uma classe que esta casa já resolveu
duas vezes* — que é a categoria mais barata de aprovar.

**A D75 foi fundida no pedido de 14/09**, mantendo a numeração mais antiga, pela régua de promoção:
dois pedidos sobre o mesmo eixo contam como dois, e brilho é um caso de aplicação. O item 5 de «Não
estou pedindo» **não se retirou** — o eixo continua sendo BRILHO, que é a moeda do pai; o que entrou
foi a nota de que positivo/negativo e claro/escuro nomeiam a mesma coisa, e a tradução fica no Berço.

> **O que continua sendo dela, e só dela: o SINAL.** Push não é entrega
> (`ds-diletta/docs/PEDIDO-DO-FILHO.md`, passo 2). O pedido está no `origin/main` desde 14/09; a
> retificação está commitada e esperando o envio.

## 4 · A arte Font Awesome Pro viaja no repo do app — RESPONDIDO por ela: temos a licença

**Estado**: **mérito FECHADO em 15/09 pela dona do produto**; segue **ABERTO no ledger do pai**, que
não foi avisado. Já não depende do 2: a saída técnica da `v0.195.0` deixou de ser obrigatória.

O pai registrou hoje, em `docs/PEDIDOS.md` (seção Abertos), levantado pela própria resposta de
procedência:

> **os `.svg.vec` de arte Font Awesome Pro VIAJAM no pacote Dart que os três filhos consomem** — e um
> deles, **o B, consome vendorizado, com a arte escrita dentro do repo dele**. […] ABERTO, **e não é
> decisão minha** — é pergunta de licença, não de arquitetura.

**O filho B é esta casa, e a medição confirma o dedo apontado:**

| onde | `.svg.vec` rastreados no git | tamanho |
|---|---|---|
| `bold-ds` (este repo) | **0** | — |
| `app-newbold`, `packages/diletta_design_system/assets/icons/` | **355** | **1,4 MB** |

No `bold-ds` a arte não é versionada: os 2.130 arquivos que o disco mostra estão todos em `build/` e
em cópias geradas, e o pacote chega por `git:`. **Quem redistribui é o app**, pela vendorização de
10/09 — e os 355 estão declarados em `pubspec.yaml:30-31` (`assets: - assets/icons/`).

**E não há PROCEDENCIA.** O pai criou `packages/diletta_design_system/PROCEDENCIA.md` em 15/09,
dizendo que os 355 são Font Awesome Pro e que *a licença Pro proíbe redistribuir o asset a quem não
tem licença*. Nesta casa não existe arquivo equivalente — `find` por `PROCEDENCIA*` e `*LICENS*`
devolve vazio —, e a cópia vendorizada do app tampouco o carrega.

**O que esta rotina NÃO fez, por regra**: não tocou em `packages/` do `app-newbold` (é cópia
vendorizada; conserto vai no repo do DS) e não escreveu nota de licença, porque *se a licença Pro
desta empresa cobre os produtos que consomem o pacote* é pergunta para uma pessoa, não para uma
medição.

### RESPONDIDO por ela em 15/09, ao ler esta rodada: **«temos a licença»**

Isso fecha o mérito, e fecha pelo caminho que o próprio pai deixou escrito no ledger:

> *se a licença Pro desta empresa cobre os produtos que consomem o pacote, **isto está dentro e a
> linha existe só pra ninguém poder dizer que não sabia**; se não cobre, a saída é a mesma que a
> Font Awesome recomenda e que o lado web já usa.*

Está dentro. **A saída do lado web — `<diletta-icon>` da `v0.195.0`, o nome viaja e a arte não — deixa
de ser conserto obrigatório do lado Dart** e volta a ser o que era antes da pergunta: desenho do
pacote web, pelas razões dele.

**Registrado como o que é: declaração da dona do produto, datada — não medição.** Esta linha não
afirma cobertura jurídica, afirma que quem responde por ela respondeu. O que sobra é só o rastro, e
são duas coisas pequenas:

1. **O pai não sabe.** O item está **ABERTO no ledger dele** (`ds-diletta/docs/PEDIDOS.md`, seção
   Abertos, 15/09) e ele declarou que *não é decisão minha*. A resposta precisa chegar junto com o
   próximo sinal — **é a mesma viagem do sinal do logo**, e não custa veredito a ninguém.
2. **Falta o «ninguém pode dizer que não sabia» deste lado.** O pai criou
   `packages/diletta_design_system/PROCEDENCIA.md` em 15/09; aqui não existe equivalente, e a cópia
   que de fato redistribui — os 355 arquivos no repo do app — também não carrega nenhum. **Esta
   rotina não escreveu o arquivo**: onde ele mora (aqui, no app, ou nos dois) e com que palavras é
   decisão dela, e texto de licença não se redige por inferência.

## 5 · `CoreflowBotao` é a única peça do pacote que não repassa `disabled` — e são cinco telas

**Nosso.** Mora em `packages/coreflow`, não se pede a ninguém.

O chat do Figma mediu no app rodando: *«o botão principal desabilitado pinta exatamente a mesma cor
do habilitado […] em cinco das doze telas o botão convida ao toque e não responde»*. **Fui conferir o
mecanismo no código, e ele está certo:**

`packages/coreflow/lib/src/coreflow_botao.dart:148-157` monta o `DilettaButton` com nove argumentos —
`label · onPressed · type · size · state · leadIcon · trailIcon · isLoading · fullWidth` — e
**`disabled` não é um deles**. O `CoreflowBotao` também não expõe o campo: são 11 props
(linhas 58–70) e nenhuma é `disabled`.

**Do lado do pai, o comentário diz por que isso não se resolve sozinho** — `diletta_button.dart:150-152`:

```dart
// Disabled é ESTADO EXPLÍCITO — onPressed null é só não-interativo
bool get _disabled => widget.disabled;
```

Passar `onPressed: null` deixa a peça inerte e **não muda um pixel**: a pintura, o cursor
(`SystemMouseCursors.forbidden`, linha 336) e o `enabled:` da semântica (linhas 280 e 333) todos
penduram em `widget.disabled`.

**E o botão é a exceção dentro do próprio pacote**, o que é o argumento que fecha:

| peça do `coreflow` | repassa? | onde |
|---|---|---|
| `CoreflowBotoesDeNavegacao` | **sim** — `disabled: travado` | `coreflow_botoes_de_navegacao.dart:78` |
| `CoreflowCampoDeTexto` | **sim** — `disabled: !habilitado` | `coreflow_campo_de_texto.dart:187` |
| `CoreflowLista` | **não, e com a razão escrita** | `coreflow_lista.dart:60` |
| `CoreflowBotao` | **não, e sem razão escrita** | — |

A `CoreflowLista` é o precedente que diz o que fazer: *«três props saíram por não ter chamador —
`badge`, `disabled` e `loading` […] voltam por repasse no dia em que uma tela pedir»*. **O chamador
agora existe e está medido**: cinco telas do onboarding.

## 6 · Os moods decoram com a cor de ALERTA

**Nosso.** Sem mudança desde a rodada anterior — reconferido na ponta remota:
`coreflow_background.dart:265` (`p.warning03` a 0,30), `:270` (`p.warning04` a 0,22) e `:272`
(`p.warning03` a 0,26). `aurora` e `porDoSol` seguem montados sobre a rampa semântica de aviso, que é
`#876307`/`#B0810A` **em toda marca**, e no claro ainda multiplica por k=1,3.

A receita do Berço (`harmoniaAnaloga`/`harmoniaComplementar` em OKLCH, com a regra da faixa amarela)
continua pronta do lado de lá e não veio pra cá.

## 7 · `CoreflowBackdrop.solido` não serve de fundo de Home, faltam dois fundos — e o Figma achou o mesmo buraco

**Nosso.** Segue aberto, e ganhou uma segunda testemunha: **a D88**.

Reconferido: o enum `CoreflowBackdrop` (`coreflow_background.dart:45-65`) tem os mesmos sete valores,
`degradeSimples` e `liso` não existem em lugar nenhum de `packages/coreflow/lib/`, e a base
`primary08` no claro continua em `:203-204`.

**O que a D88 acrescenta** é a mesma falta vista pela outra ponta: o chat do Figma achou *«um
comentário órfão no tema do app descrevendo o fundo de fluxo secundário que nunca foi
implementado»* — e a consequência medida é que **o app mostra a arte da cidade no onboarding inteiro
porque nenhuma tela passa estilo**, ou seja, por acidente de default e não por decisão. É a mesma
lacuna que o item 7 descreve desde a rodada passada, agora com o custo visível numa jornada de 12
telas.

## 8 · A tela de Aparência não conhece a curadoria do produto

**Nosso.** Sem mudança, e depende do 7. Reconferido: `packages/catalog/lib/ds_do_bold.dart:3049` e
`:3055` seguem lendo `CoreflowBackdrop.values`, e `fundosOferecidos` **não existe** em
`coreflow_produto.dart` — `grep` devolve zero.

## 9 · Levantado hoje, e que esta rodada NÃO mediu

Entra na fila como levantamento, não como afirmação — item de fila afirma o que foi verificado, e
estes não foram:

- **D81–D85**, as duas de código: *um papel de cor que as telas leem e não aparece na lista
  publicada*, e *o cartão de tipo de conta que redesenha à mão um componente que o pai já tem*. O
  chat não nomeou o papel nem o componente, e sem o nome o `grep` mede a minha escrita e não a tela —
  que é o erro que esta rotina já cometeu com o `CoreflowRadius` em 14/09.
- **D92–D94**: o acessório esquerdo da linha de lista trava em 34 e o app usa 40 e 48 (override não
  pega por ser instância dentro de instância), e a peça de rodapé é cravada numa altura que não cresce
  para dois botões. **São da biblioteca no Figma**, e o que houver de código atrás mora no pai.
- **Os dois defeitos de navegação do onboarding** — pessoa física nunca define senha (a tela de criar
  senha só é alcançada pelo ramo PJ, e duas telas se declaram *5 de 6*), e a tela de conta aprovada é
  órfã. **São de produto, não de DS**: o próprio chat disse que pedem um change do OpenSpec.

---

## O que mudou de dono desde a rodada anterior

- **Itens 1, 2, 3, 4 e 5 da rodada de 14/09 fecharam** — as duas branches mescladas, o `ref:` em
  v0.194.0 e depois v0.194.3, as três formas declaradas com o pai aprovando em 15/09, o pedido do logo
  pushado, e o emissor de CSS fechado por outra mão (`ca33d6c`).
- **O «Tom de voz» do Berço virou «Forma do app»** e **não toca este repo**: `grep -i` por
  `tom de voz`/`tomDeVoz`/`formaDoApp` em `packages/coreflow/lib/` e `packages/coreflow_design_system/lib/`
  devolve zero. O nome só viajava até o `manifesto.json` do Berço. Fica registrado porque o manifesto é
  a porta do filho gerado, e renomear porta é a classe de mudança que chega calada.
- **D76 e D77 continuam esperando decisão dela** e não mudaram de estado hoje.

---

## Rodada de 2026-09-14

**Chats lidos** (transcrição, não resumo de terceiro):

| chat | cwd | até | o que ele produziu pra cá |
|---|---|---|---|
| Berço Coreflow (white label) | `claude_newbold` | 14/09 17h30 | 6 pendências do Coreflow, 2 já viraram pedido |
| Biblioteca Figma da Diletta | `claude_newbold` | 14/09 17h00 | D75 · D76 · D77, e a onda 7 |
| `aprendizado-do-dia` (rotina) | `claude_newbold` | 14/09 10h45 | nada pra esta fila — alimenta os agentes dela |
| Coreflow é o pai (este repo) | `bold-ds-pacote` | 11/09 | fechado, nada novo |

**E o canal do pai andou sem ninguém ver.** Esta rotina deu `git fetch` e achou **duas respostas de
hoje** que não estão na `main` — o veredito do pedido dos raios e o release `v0.194.0`. Ficam no topo
da fila porque mudam o desenho do que vem depois.

---

## 1 · A resposta do pai chegou e está em branch, não na `main`

**Estado**: **FEITO em 14/09** — as duas branches foram mescladas na `main` (`a3c37eb` e `7846705`).
**Origem**: canal do pai, achado por esta rotina.

| o que | onde |
|---|---|
| VEREDITO · a forma sobe por FAMÍLIA | `origin/veredito/a-forma-sobe-por-familia` (`718c41e`, 14/09 14h58) |
| RELEASE `v0.194.0` + RETIFICAÇÃO do endereço | `origin/aviso/a-forma-chegou` (`ec496bd`, 14/09 15h51) |

**ENTRA**, e não como campo na paleta: **papel de forma em `DilettaMedida`**. Seis famílias —
`formaDeBotao · formaDeFolha · formaDeCampo · formaDeCartao · formaDeVidro · formaDeNav` —, os três
`raioDeX` viram alias da mesma tabela, `null` desenha o que desenha hoje. A pílula e o miúdo de 8
ficaram fora, com as nossas próprias razões. E **`raioDeCampo` existe desde a `v0.184.0`** — nove
tags — sem que este filho soubesse; o pai registrou o defeito como dele.

**A retificação é do mesmo dia**: a tabela mora em **`DilettaPalette.medidas`**, não em
`DilettaTheme.resolve(medidas:)` como o veredito da manhã dizia — o `DilettaScheme` não enxerga o
tema. Quem for aplicar o veredito **sem ler o aviso escreve no endereço errado**, e é por isso que
este item é o primeiro.

> Feito com `--no-ff`, pra branch continuar sendo o nome da resposta. **Três respostas anteriores
> dele seguem paradas em branch** — `veredito/o-web-sai-por-tag` (11/09), `nota/fila-de-31` e
> `nota/coreflow-v0186` (10/09) —, e nenhuma delas foi tocada nesta rodada.

## 2 · Subir o `ref:` pra `v0.194.0` — FEITO (`bfb6aeb`)

Os dois pubspecs subiram, e a suíte cobrou **três coisas que o `ref:` não mostra**:

| o que mordeu | por quê |
|---|---|
| o gate `o filho gerado recebe o MESMO avô que o pai pina` | o gerador pinava `web-v0.193.0`; um filho novo nasceria com duas versões da língua. `tagWebDoAvo` → `web-v0.194.0` |
| o gate byte a byte do exemplo versionado | o `web/package.json` do filho de exemplo carrega a mesma tag |
| `o_resumo_da_transacao_test.dart` não compilava | **`DilettaSpotIcon.icon` virou `String?`** na `v0.194.0` — `loading` desenha o arco e não usa glifo. Os outros sete seguem obrigatórios pelo `assert` do avô |

Verde nos cinco pacotes: coreflow 93 · coreflow_design_system 207 · catalog 109 · o example e o
filho gerado.

**Um pino ficou atrás, e é de propósito**: `packages/coreflow_design_system_web` segue em
`web-v0.193.0`. O `package-lock.json` dele resolve por commit e **não há node nem npm nesta
máquina** pra re-resolver — subir só o `package.json` deixaria o lock discordando. Quer dizer que
**o filho gerado hoje nasce um número à frente da nossa própria instância web**, e isso é uma linha
pra próxima rodada.

## 3 · Declarar as três formas, e dizer ao pai o que sobrou — FECHADO (o pai aprovou em 15/09)

Fecha o **item 1 da fila do Berço** — o pedido `2026-09-14-a-forma-do-filho-para-em-dois-raios.md`,
que agora tem a `## Resposta do filho` escrita no próprio arquivo. **18 dos 22 sítios** passaram a
ler o esquema; sobraram 4, cada um com a razão (o ladrilho de 46, que segue a regra de TAMANHO do
avô, e os 3 do miúdo de 8, que ficaram fora por veredito).

Nasceram quatro gêmeas no `CoreflowScheme` — `formaDoCartao`, `formaDoVidro`, `formaDaNav`,
`formaDoCampo` —, e a `formaDaFolha` passou a ler a tabela antes do campo. **A declaração é dupla de
propósito**: na paleta do Bold e na `CoreflowGramatica`, que é a que chega no filho gerado pelo
Berço — sem ela, o tom de voz continuaria parando no botão.

```dart
BoldColors.paleta.comMaterial(medidas: const {
  DilettaMedida.formaDeCartao: 24,
  DilettaMedida.formaDeVidro: 16,
  DilettaMedida.formaDeNav: 24,
})
```

**E a medição desta rotina estava CURTA.** Eu tinha contado 16 usos de `CoreflowRadius` e concluído
"7 viram declaração"; o pedido tinha contado **22 sítios**, e a diferença é que metade deles não usa
a const deste pacote — desenha `DilettaRadius.all16`/`all24` direto, que o meu grep não via.
**Contar pelo nome da const mede quem escreveu o grep, não o que a tela desenha.**

A conta que valeu, sítio por sítio:

| família | do pedido | passaram a ler o esquema | sobrou |
|---|---|---|---|
| cartão | 5 | **5** | — |
| vidro | 7 | **6** | 1 — o ladrilho de 46, que segue a regra de TAMANHO do avô (46 ⇒ `all16`) |
| campo | 4 | **4** | — |
| nav | 3 | **3** | — |
| miúdo de 8 | 3 | — | **3**, por veredito dele |
| **total** | **22** | **18** | **4** |

Fora dos 22 seguem cravados **4 da pílula** (veredito dele, razão nossa) e **1 chamada de tela** que
escolhe 16 de propósito. O emissor de CSS — que era o item 5 desta fila — **fechou no mesmo dia, do
outro lado da casa** (`ca33d6c`).

**A conferência que ele pediu** virou teste: um `CoreflowCartao` e um `DilettaSurface` montados da
mesma paleta, com a família declarada em 12 — os dois respondem 12, e não há mais um terceiro número
escondido dentro da peça. Junto dele, o gate `a_forma_segue_a_familia_declarada_test`, 8 casos,
incluindo *nenhuma peça deste pacote desenha a const das quatro famílias*.

## 4 · O pedido do logo — ESCRITO, e esta rotina deu o push

**Estado**: no `main` do `bold-ds` desde esta rodada. **Falta o SINAL ao pai** — e o sinal é humano,
por contrato (`ds-diletta/docs/PEDIDO-DO-FILHO.md`, passo 2). Push não é entrega; entrega é a linha
no ledger dele.

`docs/pedidos/2026-09-14-o-logo-tem-uma-arte-e-a-pagina-tem-duas.md` — pede arte de logo **por
brilho**. Medido: nenhuma cor chapada passa em 3:1 contra as duas páginas fora da faixa L 0,51–0,67
(**17 de 95 passos**), o teto de uma arte só é **4,29:1 / 4,16:1**, e **4 de 6 cores de banco
reprovam** numa das versões.

### E aqui os dois chats se cruzaram — é o achado desta rodada

O chat do **Figma** registrou, às cegas do outro, a **D75**: *enum de **aplicação** no
`DilettaBrand` (Positivo · Negativo · Marca · Monocromático) + arquivo dedicado opcional por
aplicação, arquivo vence tinta*, com a frase dela: *"a simples pintura pode não solucionar muitos
casos de uso do logo"*. No Figma isso entra na **onda 7**, como eixo `Aplicação` no componente `Logo`.

**É a mesma lacuna, pedida com dois tamanhos diferentes**: o pedido escrito pede o eixo BRILHO (duas
artes), a D75 pede o eixo APLICAÇÃO (quatro, e brilho é um caso dele). O pai ainda não julgou.

> Decisão que só ela pode tomar, e antes do veredito: **o pedido vira um só com o eixo de
> aplicação, ou o brilho entra primeiro e a aplicação vira o segundo pedido?** Pela régua de
> promoção do pai, dois pedidos sobre o mesmo eixo contam como dois — o que joga a favor de mandar
> o menor primeiro. Pela régua dela — *"a pintura não resolve o caso de uso"* — o menor nasce
> velho.

**E o Berço já anda na frente do DS, de propósito**: o site recebe o par positivo/negativo, o
arquivo viaja como `assets/logos/{arquivo}_negativo.svg`, sai no manifesto, e o Dart gerado leva um
comentário dizendo **por que** o campo não está declarado e **onde** está o pedido. No dia do
veredito, esse comentário é o que tem que sumir — é o rastro que fecha o fio.

## 5 · `coreflow_css.dart` emite a gramática, não o produto — FEITO por outra mão (`ca33d6c`)

**Não fui eu, e é o melhor jeito de este item fechar.** A frente web leu o veredito e emitiu as
**seis formas pelo nome do papel** (`--cps-formaDeCartao`…), resolvidas pelos GETTERS e não pelo
`medidaDe` cru — que leria só a tabela e devolveria pílula pra quem declarou o alias. Junto veio o
pino do `package.json` web, que esta rotina tinha deixado em `web-v0.193.0` por falta de npm.

**Uma nota que fica pra próxima rodada, e não é defeito hoje**: o emissor lê cinco das seis formas
do esquema do AVÔ (`DilettaScheme.light(p)`) e só a folha do nosso. Hoje os números coincidem
(cartão 24 · vidro 16 · nav 24 nos dois), então o CSS e o Flutter concordam. **No dia em que a
gramática desta casa divergir do default do avô em alguma dessas cinco**, a web emitirá o número
dele e as peças desenharão o nosso — a mesma classe do `CoreflowRadius.card` valer 24 contra o
`DilettaRadius.card` de 16, que já está escrita como *casar por VALOR e nunca por nome*.

## 6 · Os moods decoram com a cor de ALERTA

**Nosso.** `aurora` = `primary04` 0,32 + **`warning03`** 0,30 + vinhoMarca 0,32; `porDoSol` =
**`warning04`** 0,22 + **`warning03`** 0,26 + `primary04` 0,30 (`coreflow_background.dart:265`).

Medido no chat do Berço: `warning03` = `#876307` e `warning04` = `#B0810A` **em toda marca** — são
degraus da rampa semântica de aviso e não derivam da paleta. No claro ainda multiplicam por k=1,3.

**O Berço já resolveu do lado dele** e a receita está pronta pra vir: `harmoniaAnaloga` e
`harmoniaComplementar`, polos girando o matiz em OKLCH (±32° e +180°), com a **regra da faixa
amarela** (matiz 70°–120° com claridade ≤ 0,75 suja; análogo espelha pro outro lado na metade do
giro, complemento clareia até L 0,82; marca que já vive na faixa é isenta).

## 7 · `CoreflowBackdrop.solido` não serve de fundo de Home, e faltam dois fundos

**Nosso.** Medido na Home: brilho **0,10** (0,13 no claro) contra **0,44** dos que funcionam, e a
base `primary08` deixa a tela inteira da cor da marca. Ele saiu da lista do Berço. Entram duas
propostas que **não existem no Coreflow**: `degradeSimples` (já registrada antes) e `liso`
(`lerp(white, primary04, 0.05)` no claro, papel de fundo no escuro, sem camada nenhuma).

## 8 · A tela de Aparência não conhece a curadoria do produto

**Nosso.** Ela lista `CoreflowBackdrop.values` — enum fixo (`packages/catalog/lib/ds_do_bold.dart:3049`,
e o `o_fundo_do_frame_e_o_backdrop_test` varre o mesmo `.values`). O Berço guarda o que o cliente
removeu em `manifesto.material.fundosOferecidos`, e **isso não chega ao app**: `CoreflowProduto`
precisa declarar os fundos que oferece, e a tela ler essa lista. Depende do 7 — declarar uma lista
de fundos antes de os fundos existirem é declarar o enum de novo.

## 9 · O rodapé mede 20 onde a grade diz 24

**Nosso**, e é de uma linha. `coreflow_rodape.dart:74` recua o conteúdo com `DilettaSpacing.s5`
(20); `coreflow_espaco.dart` declara `gutter = DilettaSpacing.s6` (24) e diz por quê: *«o 24 ganhou
porque é o gutter do CHROME da linguagem»*. O gate «o gutter das telas é um» cobra o corpo; o rodapé
ficou de fora dele.

Medido em 23/09 pelo `revisor-visual`, na recusa do Pix: o card do aviso começa em x=20 e o valor
«R$ 4.200,00» logo acima começa em x=24 — **o rodapé desalinha 4 pt do corpo em toda tela que usa
os dois**, e o app tem 46 arquivos com `CoreflowRodape`. Contra o Figma (que desenha 24) a mesma
diferença.

Conserto: `s5 → s6` na linha 74, e o gate do gutter passar a olhar o rodapé. Não foi feito nesta
rodada porque é código, e código sem pedido dela não entra — ver «Como esta fila se mantém».

---

## O que não entra nesta fila, e por quê

- **D76** (`erro.generico`/`sad_face` sem pintura na rampa — não recolore em marca nenhuma) e **D77**
  (a Base mistura duas rampas: 9 cenários no azul do pai e `erro.estadoInvalido` no rosa do Bold —
  **um terceiro filho herdaria o rosa**): são da biblioteca de arte no Figma e **esperam decisão
  dela**. O D77 é o candidato a virar pedido: arte que carrega a marca de um filho não é arte do avô.
- **Code Connect** está bloqueado por **plano** (a org é Professional; a API pede assento Dev/Full) —
  não é dívida de código, e o plano B (bloco na descrição do componente) já está entregue.
- **A fila dos agentes dela** (`critico-de-fluxo-ux`, `auditor-acessibilidade`, `revisor-visual`,
  `critico-de-composicao`) é outra fila, vive no scratchpad do chat do Berço e é entregue pela rotina
  `aprendizado-do-dia`. Esta aqui só cuida do que muda código do Coreflow.

## Como esta fila se mantém

A rotina `atualizacoes-ds` reescreve este arquivo a cada rodada: lê as transcrições dos chats do dia,
dá `git fetch` no `bold-ds` pra ver se o pai respondeu, mede no código o que der pra medir, e
**recompara com a rodada anterior**. Item que sumiu da fila sem commit correspondente vira pergunta,
não desaparece.

**O que ela faz sozinha**: escreve este arquivo, o `PEDIDOS.md` e os arquivos de pedido, e **commita
local**.

**O que ela NÃO faz, desde 15/09** — a regra é dela, e a frase é dela: *«escreve tudo e deixa o envio
comigo»*. **Nunca push, nunca PR, nunca merge, nunca tag.** No contrato do pai o push é o que ENTREGA
o pedido, e entrega é decisão da Agatha. Some daqui o que a rodada de 14/09 dizia: aquela rodada
pushou o pedido do logo, e essa permissão acabou.

Também não se toca: `packages/` do `app-newbold` (é cópia vendorizada — o conserto vai no repo do
DS), `~/.claude/agents/`, e nenhuma correção de código que ela não tenha pedido. **Achado de código
vira linha nesta fila, não commit.** E segue de pé: não escrever pedido sem medição, não mesclar
branch de veredito do pai, não tocar em `ds-diletta`, e não dar o SINAL — o sinal é dela.
