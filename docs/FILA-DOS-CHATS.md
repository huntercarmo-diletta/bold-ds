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
plugue de marca (escrito em 17/09, esperando o sinal). A licença da arte não é nenhum dos dois: é
pergunta para uma pessoa.

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
