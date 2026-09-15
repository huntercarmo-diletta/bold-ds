# FILA DOS CHATS — o que as conversas abriram, em ordem de dependência

Este arquivo é escrito pela rotina **`atualizacoes-ds`** e não à mão. Ele existe por uma queixa
concreta: *"não quero fazer isso manualmente em cada chat"*. Três conversas andaram no mesmo dia
sobre a mesma família de peças, cada uma guardou o que descobriu no seu próprio canto — memória da
sessão, arquivo de scratchpad, ledger de divergência do Figma — e **ninguém tinha a lista inteira**.

**Como ler**: a ordem é de DEPENDÊNCIA, não de importância. O item 2 não se faz antes do 1 porque a
porta que ele usa chega na tag do 1.

**O que é «nosso» e o que é «pedido»**: `CoreflowBackdrop`, os moods, o emissor de CSS e a tela de
Aparência moram em `packages/coreflow` — **são nossos, não se pede**. Ao avô (`ds-diletta`) só vai o
que é vocabulário dele: a forma por família (respondida hoje) e a arte do logo (aberta).

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

**O que ela faz sozinha**: escreve este arquivo, e dá push em pedido que já estava ESCRITO e
commitado por ela (o do logo, nesta rodada) — porque push é o passo 1 do contrato e não custa
veredito a ninguém.

**O que ela não faz**: escrever pedido novo (pedido sem medição é pedido adulterado), mesclar branch
de veredito do pai, tocar em `ds-diletta`, ou dar o SINAL — o sinal é dela.
