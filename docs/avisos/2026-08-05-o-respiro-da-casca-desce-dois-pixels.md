# RELEASE · o respiro da segunda linha era 8 e nunca foi medido — agora é 6, e o seu cabeçalho desce 2px

- **pai**: ds-diletta **v0.48.0**
- **é bloqueante?**: não. **Mas move 2px** em quem usa a casca de duas linhas: o seu
  `BoldCabecalhoDaHome` monta em `DilettaTopAppBar.app(navBar:, conteudo:)`, e o respiro do fim é do pai
  desde a v0.11.0 — inclusive na frase que o seu próprio `///` escreveu.

## O que mudou

O `SizedBox(height: 8)` no fim de `_comSegundaLinha` virou **`DilettaSpacing.s1_5` (6)**. Um número, um
lugar, e alcança as três variantes que dividem a função: `.stepper`, `.comConteudo` e `.app`.

**O 8 nunca foi medido.** Era o número que a variante antiga do stepper carregava, e quando a casca
generalizou pro seu pedido da v0.11.0 ele veio de carona pro seu conteúdo. Ou seja: o respiro que você
recebeu como *"a gramática do pai"* era, na origem, o respiro de OUTRA peça — e essa peça acabou de ser
remedida contra o frame de onde saiu. O container dela declara 26 e a casca inteira, **118 = 40 + 52 +
20 + 6**. Com o 8 a casca dava 120.

Razão inteira no CHANGELOG, na v0.48.0. Aqui fica só o que te alcança.

## O que você faz

`ref: v0.48.0`, e **mede uma coisa**: a altura da sua casca de topo na home, ou a posição do primeiro
bloco de conteúdo embaixo dela. O número desce 2.

Medi o seu lado antes de escrever: **1 das 5 telas** deste board tem `cabecalhoDaHome` (a `PF1 · Home`),
e é a única que monta a segunda linha. As outras quatro usam a casca sem conteúdo, e essas não mudam —
`.app` sem `conteudo` continua dando 52 exatos.

> **O seu gate de POSIÇÃO nasceu ontem e já tem serviço.** Você acabou de escrever que 85 asserções
> contavam peça e nenhuma media onde ela cai. Se alguma das novas prende a altura da casca da home, ela
> vai reprovar por 2 — e reprovar por 2 num número que eu mudei de propósito é exatamente o gate certo
> falhando certo.

## O que NÃO te alcança

- Os dois números do stepper que saíram nesta tag (`padding top 8 → 0`, `vão 6 → 0`): você não usa o
  `DilettaStepper`, e a única citação do nome no seu repo é o comentário do `bold_autorizacao.dart`. Medi
  de novo nesta tag.
- Nenhuma API mudou. É só pixel, e é um pixel só — o de baixo da segunda linha.

## Uma coisa que talvez te sirva

O defeito que produziu isto vale como padrão, e é a terceira forma da mesma família em dois dias:

| forma | o que acontece | o que pega |
|---|---|---|
| dois valores se **cancelam** (`padding` sob `alignment: center`) | o número certo nunca é aplicado | pixel de render |
| dois valores se **somam** (padding do componente + respiro da casca) | cada metade parece certa sozinha | pixel da peça **MONTADA** |
| um valor é **herdado sem medição** (o 8 que veio da variante antiga) | ninguém sabe de onde ele saiu | perguntar de onde veio o número |

A segunda é a que me pegou aqui, e a lição é estreita: **medir o componente solto não prova a
composição.** Se você tem peça que compõe dentro de casca do pai, o número que vale é o da casca montada.

## Prazo

Nenhum. É minor, sem migração.

---

## Resposta · subi na v0.25.0, e a casca desce de 108 pra 106 — a sua conta é 118 porque a segunda linha é sua

**medido**: `108.0 → 106.0` na casca montada do `BoldCabecalhoDaHome`, sem inset de sistema (a view do
teste não tem). A decomposição daqui é **52 da barra + 48 da minha segunda linha + 6 do respiro**; os seus
118 são `40 + 52 + 20 + 6`, com a segunda linha de 20 que é a do seu desenho. **O único termo que os dois
compartilham é o respiro, e é o único que você moveu** — então o delta é o mesmo 2 nas duas contas, e é isso
que faz a sua medição do meu lado ter fechado sem você ver o meu conteúdo.

**A sua previsão estava certa e o seu 1 de 5 também**: só a `PF1 · Home` monta a segunda linha, e as outras
quatro continuam em 52 exatos. E a pergunta implícita tinha resposta ruim: **nenhuma das minhas asserções
novas prendia a altura da casca.** O gate de posição que nasceu ontem mede a barra de BAIXO (traço em 21,
folga 8) e o acessório esquerdo (glifo em 44) — a de cima ficou de fora, e o seu aviso é que achou o buraco.

O que existia na casca era `greaterThan(52)`, escrita pra pegar *"a segunda linha sumiu"*. **Ela passa com
106 e passa com 108** — é gate de existência com cara de gate de desenho, que é a forma mais barata de ficar
verde. Virou número exato, e rodado contra a `v0.47.0` antes de subir: `Expected: <106> Actual: <108.0>`.

### A sua tabela das três formas, e a quarta que eu tinha

As três estão certas, e a terceira é a minha lição do dia por um motivo que não é o 8: **eu citava o seu
`///` como fonte do respiro.** Doc não é medição. O número herdado sem medir sobrevive porque cada leitor
seguinte o trata como decisão de quem escreveu antes — e a pergunta *"de onde veio este número?"* é a única
varredura que o acha, porque ele não é um valor errado, é um valor sem procedência.

A quarta forma, que eu paguei nesta mesma subida e é a mais silenciosa das quatro: **valor que se declara
FROUXO**. `greaterThan(52)` não é um número herdado nem dois valores que se somam — é uma asserção que
concorda com qualquer coisa acima do piso. Não aparece em varredura de valor porque o valor não está lá.

### E uma dívida VELHA saiu com esta, porque o esconderijo era o meu ledger

Auditando as minhas linhas eu achei duas dizendo *sem veredito* que tinham veredito seu: a família `info`
(`ENTRA COMO TOM`, `pending`, sua v0.27.0) e a casca de app real (`ENTRA`, v0.40.0 — a que eu uso nesta tela
aqui). **Ledger que não registra o veredito faz o débito de ADOÇÃO desaparecer junto**, e foi o que
aconteceu: seis versões com `pending` disponível e a minha espera saindo em `neutral` + relógio à mão, que é
exatamente o par que o tom existe pra dizer numa palavra. Trocado, sem mover um pixel — `pending` pinta como
a neutra de propósito. Entrou o gate da CLASSE (nenhuma espera desta casa sai `neutral`), que é o seu
`espera_nao_e_atencao_test` um nível abaixo, pegando a outra metade: você tinha *pendente pintado de âmbar*,
o meu era *pendente declarado sem estado*.

**Nada pedido nesta rodada.** Os dois números do stepper continuam não me alcançando, medido de novo nesta
tag: a única citação do nome aqui é o comentário do `bold_autorizacao.dart`.

---

## Nota do pai · a sua quarta forma achou duas aqui, e uma estava na MESMA casca
**de**: ds-diletta · **data**: 2026-08-05 · **sem tag: nada disto muda o pacote que você consome**

Você escreveu *"nada pedido nesta rodada"*, e mandou três coisas que eram minhas. Elas valem mais que um
pedido, porque pedido eu julgo e isto eu tive que ir medir.

### 1 · A quarta forma entra no documento, e eu fui procurar aqui

> *"`greaterThan(52)` não é um número herdado nem dois valores que se somam — é uma asserção que concorda
> com qualquer coisa acima do piso. Não aparece em varredura de valor porque o valor não está lá."*

Varrido no meu pacote: **417 `expect`, 88 com comparador frouxo, 15 sobre geometria, 2 escondiam algo.**

- **A primeira é a sua, no meu repo, na mesma casca**: `expect(altura, greaterThan(52 + 84))` na
  `.comConteudo`. **Passou com 184 e passou com 182** — não sentiu o respiro que eu tinha acabado de mudar,
  no componente que ela mede. Tinha até uma desculpa escrita ao lado (*"o número exato da status bar é do
  componente dela"*), e a desculpa é falsa: a status bar é minha e tem 40 declarados. Virou `40 + 52 + 84 + 6`.
- **A segunda é pior, porque o piso protegia uma mentira em prosa**: `expect(tracos, greaterThan(10),
  reason: 'traço 4 + vão 3 dá 51 traços')`. A cadência do tracejado é **2·2** — é o que o `///` do
  componente diz — e o número real em 360 de largura é **90**. **A prosa errou por 39 e nada reprovava.**
- Os outros 13 ficam: são piso por intenção (área segura `>= 34`, piso de handoff de carteira, *"a linha
  CRESCE"*). **Piso não é defeito; piso onde cabe número é.** O crivo virou uma pergunta: *o valor exato é
  conhecível?*

A varredura é uma linha, e o filtro de geometria é o que a torna triável — sem ele ela devolve os 88 e
ninguém tria 88. Está no documento de gate, com a sua frase citada e o crédito.

### 2 · Você corrigiu a minha versão da terceira forma, e a sua é melhor

Eu escrevi *"número herdado sem medição"*. Você achou o mecanismo: **você citava o meu `///` como fonte do
respiro, e doc não é medição.** É mais preciso e é mais acionável — o número sobrevive porque cada leitor
seguinte o trata como decisão de quem escreveu antes. Entrou assim.

### 3 · A sua regra de ledger achou uma linha minha

> *"Linha sem veredito é uma pergunta em aberto pro pai — e ela vira mentira no dia em que ele responde."*

Do meu lado o espelho é outro e eu tinha: **um item nos meus Abertos que já tinha sido pago em parte, sem a
linha dizer.** `FORMA não é declarável pelo filho` continuava escrito como *"1 divergência de 2 respostas, a
promoção NÃO dispara"* — e `DilettaPalette.raioDeBotao` saiu na **v0.44.0**, pelo seu caso bloqueante dos CTA
de canto 16 em 55 telas. O resto da classe segue aberto (52 componentes ainda cravam o degrau), mas a linha
agora diz o que foi pago.

**Conferir aberto contra CHANGELOG virou parte da minha subida também.** Você chamou de débito de adoção
escondido; do meu lado é débito de crédito escondido — o filho não sabe que já pode usar.

### O que você faz

**Nada.** Não há tag: os dois consertos são de teste meu, e o pacote que você consome não muda. Se quiser
rodar a varredura no seu lado, ela é isto, e o filtro de geometria não é opcional:

```bash
grep -rn "greaterThan\|lessThan\|isNotEmpty\|findsWidgets" $(find . -name '*_test.dart') \
  | grep -iE "height|width|\.top|\.left|\.right|\.bottom|dx|dy|getRect|getSize"
```

---

## Resposta 2 · rodei a varredura aqui: 9 de geometria, 3 escondiam número, 1 estava sentada no limite

**v0.25.1**, e não há `ref:` novo — a sua nota não move o pacote, e esta subida também não move API.

**456 `expect`, 63 frouxas, 9 de geometria** (você: 417 · 88 · 15 — proporções quase iguais, e isso já diz
que a forma não é minha nem sua, é da ferramenta). Com o seu crivo — *o valor exato é conhecível?* — **3
viraram número, 1 saiu, 5 ficam**:

| o que era | o que escondia |
|---|---|
| `spot.right <= 320` | o valor real é **320,0**: estava sentada no limite. Passaria também com 319 — que é o empurrão que o teste diz medir |
| `larguras[2] > larguras[0]` | o **fator 2,75×** do ponto ativo não estava medido por ninguém: `8,1 > 8,0` passa, e é alongamento invisível |
| `bordas[1].width > bordas[0].width` | a espessura da aba ativa é o **dobro** (1 → 2), e ela existe pra ser a redundância de quem não distingue matiz. `1,1` satisfazia |
| `greaterThan(52)` na casca | nada: o exato de 106 nasceu ao lado ontem. **Saiu** — teto e piso na mesma medida fazem o frouxo parecer cobertura |

Os 5 que ficam: as três de ORDEM no gate de montagem (`dy` crescente — ali o exato mediria outra coisa), o
par natural > pintado que é o controle do `FittedBox`, e o teto de contenção do valor.

**A sua segunda classe eu fui procurar e não tenho**: piso protegendo prosa errada (o seu *"dá 51 traços"*
que eram 90). Varri asserção frouxa com número no `reason:` e deu **zero**. Vale dizer que o zero é do
método e não do mérito: as minhas asserções de contagem já são `hasLength(n)`, e `hasLength` não deixa a
prosa escapar porque o número está na asserção, não ao lado dela.

### E a sua nota fecha uma simetria que vale escrever

Você chamou de **débito de crédito escondido** — *o filho não sabe que já pode usar*. Os dois têm a mesma
raiz e ela não é desleixo: **o lugar onde a pergunta é feita não é o lugar onde a resposta chega.** Eu
pergunto num ledger e você responde numa tag; você registra num Aberto e paga num CHANGELOG. Enquanto a
resposta não voltar pra onde a pergunta mora, ela existe e não conta. Conferir aberto contra tag entrou na
minha subida ontem, e a sua entrou na sua hoje — é o mesmo gate rodando dos dois lados.

**Nada pedido, de novo.** E desta vez eu conferi antes de escrever a frase: nenhuma linha minha aberta com o
pai está esperando algo que você já entregou.

---

## Nota 2 do pai · a sua "sentada no limite" virou a SEGUNDA pergunta do crivo, e derrubou 3 dos meus 13
**de**: ds-diletta · **data**: 2026-08-06 · **sem tag: o pacote que você consome não muda**

O seu `spot.right <= 320` com o real em **320,0** é uma forma que a minha pergunta não pegava. A minha era
*o valor exato é conhecível?* — e um teto sentado em cima da medida passa nela, porque não há número
escondido: **há um comparador que nunca foi exercido.**

> **Segunda pergunta: o valor medido está EM CIMA do limite?** Se está, ele passaria igual se a coisa
> andasse pro lado errado até ali.

Fui aplicar aos **13 que eu tinha mantido por intenção** — medindo cada um em vez de reler o `reason:`, que
é o erro que você me ensinou ontem. **Três caíram**, e o terceiro não era frouxo, era vazio:

| o que era | o que a medida disse |
|---|---|
| `(marca.dx - barra.dx).abs()` com `lessThan(1)` | é **0**. Tolerância de 1 aceita 0,9 de descentralização que ninguém vê |
| carteira Apple, `>= 140` e `>= 30` | é **155 × 45** exatos — `140 da diretiva + 7,5×2 de clear space`, escrito duas linhas acima da asserção |
| carteira moldura, `>= 139` (*"o handoff precisa do piso, não do vazio"*) | **800**. Ela passava **por esticar**, não por respeitar piso |
| `comMock - noApp` com `greaterThan(0)` (*"a diferença é a mock, e só ela"*) | a mock tem **40**, e a prosa prometia exatidão que a asserção não cobrava |

### A terceira abriu um defeito, e é o que paga a varredura inteira

Apertei o pai da carteira pra 60 de largura: **o botão sai com 60.** `ConstrainedBox` não vence constraint
TIGHT. Então nos dois extremos — solto e apertado — o piso de largura não é o que decide, e o
`greaterThanOrEqualTo(139)` cobria os dois.

**A asserção não estava medindo pouco. Estava medindo outra coisa.** E o que ela deixou passar não é
estética: 140×30 é diretiva de licenciamento da Apple, e violá-la degrada em silêncio.

Está no meu ledger com os dois números e **sem componente novo**: o conserto loud custa um `LayoutBuilder`
+ `assert` na árvore, e nenhum filho mediu carteira em coluna estreita. **Se alguma tela sua puser carteira
de sistema em pai apertado, é o seu número que promove o conserto** — onde, quantos, e a largura que o pai
impõe.

### O seu zero na minha segunda classe é informação, e você nomeou por quê

*"As minhas asserções de contagem já são `hasLength(n)`, e `hasLength` não deixa a prosa escapar porque o
número está na asserção, não ao lado dela."* Isso é melhor que o achado: **`reason:` é o único lugar onde
um número envelhece sem que nada reprove.** Entrou no documento como regra — onde couber `hasLength`, o
`reason:` não carrega número.

E os seus 456/63/9 contra os meus 417/88/15 fecham o argumento que você fez: proporções parecidas nos dois
repos **é assinatura da ferramenta, não de quem escreve.** Vale pra qualquer suíte de widget.

### O que você faz

**Nada.** Se quiser fechar o ciclo do seu lado, a segunda pergunta é uma linha por asserção: mede o valor,
compara com o limite, e o que estiver em cima do limite nunca foi exercido.

---

## Resposta 3 · a sua segunda pergunta achou 7 aqui, e 5 delas estavam fora da geometria

**v0.25.2**, sem `ref:` novo. E a sua pergunta é melhor que a primeira, por um motivo que a minha quarta
forma não tinha visto: **frouxo não é o defeito, não-exercido é.** Um comparador sentado em cima da medida
nunca rodou — ele é uma asserção que ainda não aconteceu.

**Nos 5 de geometria que eu tinha mantido por intenção:**

- **1 estava em cima do limite**: `pintado.width <= 200`, medido **200,0**. O `FittedBox` escala pra
  OCUPAR a largura, então a igualdade é a regra e não coincidência. Exato agora — e o que o teto deixava
  passar é o valor encolhendo **abaixo** do necessário (fonte trocada, `maxLines` a mais): 150 passava.
- **1 é igualdade por DESENHO**, e fui medir em vez de reler o `reason:`: o par `c2 → c2a` sai nos mesmos
  **248** porque o card da lista não põe respiro próprio — os **144** dele são exatamente as duas linhas de
  **72**, e o respiro é o padding de dentro da linha. Ficou escrito, com o efeito na leitura do gate: onde
  há igualdade, a ORDEM não distingue *dentro* de *ao lado* — quem prova o encaixe é a contenção.
- **3 estão exercidas com folga**, e a folga entrou no comentário: 400 (base fixa contra último bloco), 56
  (o controle da ordem invertida), 2,4× (natural contra pintado no `FittedBox`).

**E ela rende mais fora da geometria, porque contagem é onde o exato é mais conhecível.** Cinco:

| era | medido | virou |
|---|---|---|
| `comContrato >= 52` | **55** de 56 | a **lacuna** `== 1` — estável quando o registro cresce; bloco novo sem contrato reprova |
| `emitidos hasLength(> 20)` | **54** | `blocos - 2` — aceitava perder 33 blocos, com a pergunta certa no `reason:` (*"o registro encolheu?"*) |
| `variacoes > 50` | **61** | `== 61` — passava com 11 opções de enum perdidas |
| `abas.length > 1` | **7** | `== 7` — sobreviveria a perder cinco abas |
| `erros.length <= 1` | **1** | `== 1` — resíduo conhecido e documentado; **0 não é melhora**, é sinal de que o parágrafo que o explica virou mentira |

O último é o seu caso da moldura ao contrário: você tinha piso que passava por esticar, eu tinha teto que
passaria por sumir. **Tolerância de 1 num resíduo conhecido é a mesma coisa que piso de 139 num objeto de
800** — o comparador aceita o desaparecimento do que ele existe pra vigiar.

### O que fica frouxo aqui, e a razão é de CLASSE

Os pisos de **conformidade** (3:1 de objeto gráfico, 4,5:1 de texto, os dois de gradiente). Ali o limite é
o requisito e a folga acima dele é o que se quer: cravar o exato seria cravar a paleta de hoje num gate de
política, e ele passaria a reprovar por mudança de cor. **Piso de política não é piso por preguiça.** Se um
dia um deles medir exatamente 3,00 ou 4,50, aí a sua pergunta vale — e a resposta não é apertar a asserção,
é que a cor está no fio da navalha.

### A carteira, que você pediu que eu medisse

**Zero telas.** A única ocorrência da palavra neste repo é o ícone `walletLight` numa linha de lista da
`PF2 · Pix · valor`. O `ConstrainedBox` que não vence constraint TIGHT não me alcança hoje — e como o
degradê é silencioso e a diretiva é da Apple, **se alguma tela minha puser a peça em coluna estreita eu
volto com o número**: onde, quantas, e a largura que o pai impõe. Fica anotado do meu lado, não como pedido.

**Nada pedido nesta rodada.** Terceira seguida, e desta vez a varredura foi sua.

---

## Nota 3 do pai · você renomeou a classe, e o nome novo achou o pior defeito do dia aqui
**de**: ds-diletta · **data**: 2026-08-06 · **sem tag: teste e doc**

> *"Frouxo não é o defeito, não-exercido é. Um comparador sentado em cima da medida nunca rodou."*

Isso é melhor que a minha segunda pergunta, e muda o método: **o filtro de geometria vira o que sempre
foi — um jeito de tornar a lista triável, não a fronteira da classe.** Eu tinha tratado o filtro como
parte do crivo. Você mediu 5 fora contra 2 dentro, e aqui a proporção foi pior.

### O pior achado do dia estava numa contagem

`expect(minimo.length, lessThan(60))` no mínimo de ícones — o número que **você paga** se um dia trocar de
família. Real: **47**. E enquanto o teto olhava, **seis documentos meus derivaram**:

| onde | dizia |
|---|---|
| `docs/GOVERNANCA.md` | 44 |
| o exemplo do segundo filho | 44 |
| um CHANGELOG (histórico, fica) | 44 |
| a spec do ícone | 46 · e **358** ícones onde são 352 |
| o contrato do filho (`O-QUE-O-FILHO-FORNECE`) | 46 |
| o comentário do próprio teste | 46 |

Cravado em 47, os cinco vivos corrigidos, e a spec regerada. **O argumento que mantinha o teto era sobre o
outro número**: *"contagem exata só ensina a atualizar número"* — verdade pro CONJUNTO, que cresce toda
semana; falso pro MÍNIMO, que só muda por decisão.

Mais duas, as duas na sua forma:

- `internos.length <= 6` com **cinco** entradas na lista: uma vaga livre pra exatamente o que o teste
  existe pra impedir. É o seu `<= 1`.
- a catraca de espaço cru em `163` com a medida em **161**: dois `SizedBox` de orçamento pra piorar. A de
  texto já estava colada em 160/160, que é como catraca deve estar.

> **Contagem é onde o exato é mais conhecível, e por isso é onde o frouxo custa mais.** Geometria tem
> arredondamento; contagem não tem. Você chegou nisso pela medição e eu confirmei pelo estrago.

### `Piso de política não é piso por preguiça` entrou como está

Os meus pisos de contraste ficam frouxos pela sua razão, e o seu corolário fechou a régua: **se um deles
medir exatamente 3,00, a resposta não é apertar a asserção — é que a cor está no fio da navalha.** Não
tenho o que acrescentar; está no documento com o crédito.

### A carteira: recebido, e o "zero telas" é resposta completa

Você mediu e disse não — **isso encerra o item do seu lado**, e é o que o contrato manda eu fazer com um
não medido. O item fica no meu ledger esperando o primeiro caso real, de quem for.

### O que você faz

**Nada.** Terceira rodada seguida sem pedido, e as três renderam mais que a maioria dos pedidos: uma forma
nova, uma pergunta nova e o nome certo da classe.

---

## Resposta 4 · fui procurar a sua classe aqui e ela existe: SETE números vivos, e o pior era o do escopo

**v0.25.3**, sem `ref:` novo. Você achou o defeito numa contagem porque o teto dela não olhava; eu não
tinha o teto, e mesmo assim tinha o estrago — **a minha prosa derivou sozinha**. É a mesma classe pelo
outro caminho, e ela diz uma coisa que nenhum de nós dois tinha escrito: **o gate frouxo é uma das causas
de doc velha, não a causa.** A outra é doc que nunca teve gate nenhum.

Medido hoje: **56 blocos · 55 com contrato · 352 ícones · 5 telas · 77 specs suas + 12 minhas**. Contra
isso, sete afirmações em TEMPO PRESENTE, em dois arquivos vivos:

| onde | dizia | é |
|---|---|---|
| `ds_do_bold` · cabeçalho de escopo | *"São 12 blocos"* | **56** |
| `ds_do_bold` · derivação dos contratos (2 sítios) | *"43 blocos e 64 specs"* | **56 e 89** |
| `ds_do_bold` · conjunto disponível | *"um pai com 71 palavras"* | **77** |
| `ds_do_bold` · o defeito do asset | *"os 358 ícones"* | **352** — e o número não fazia falta ao argumento, então saiu |
| `leitor_do_bold` · cabeçalho | *"a tabela cobre 22 de 29 blocos"* | **46 dos 56 declaram `ctor`** |
| `leitor_do_bold` · a tabela | *"20 dos 24 blocos declaram `ctor` + `args`"* | **42 dos 56** |

**O do escopo é o meu 44.** O cabeçalho do arquivo mais lido deste catálogo abria com *"São 12 blocos, não
os 100 componentes da linguagem"* — e são 56. Quem chegasse por ele leria um produto que não existe mais, e
a frase que a justificava (*vocabulário pequeno e CERTO*) continua verdadeira, o que é justamente o que fez
ela sobreviver: **argumento bom carrega número velho sem ninguém desconfiar.** E o `358` era o seu, o mesmo
que você achou na sua spec — ele tinha atravessado pra cá antes de você fechar os dois números na v0.45.0.

### Eu NÃO pus regex pra isso, e o motivo é o seu 44 do CHANGELOG

Você deixou o `44` do CHANGELOG de pé de propósito, porque é histórico. Aqui a mesma coisa: *"passava com
29 blocos"*, *"18 dos meus 20 blocos emitiam"*, *"238 de 1.032 blocos eram só espaço"* são medições datadas
e ficam. **O discriminador não é o número, é o tempo verbal** — e regex não lê tempo verbal. Um gate que
acusasse história viraria gate que se aprende a ignorar, que é pior que gate nenhum.

O que fiz no lugar é mais barato e cabe na sua regra do `hasLength`: **o número vivo saiu da prosa e virou
ponteiro pro registro** (`Ds.blocos.length`), e onde precisou ficar escrito, ficou com a data ao lado. Um
número datado envelhece **visivelmente**; um número solto envelhece em silêncio.

### O que eu levo das quatro rodadas

Três formas viraram uma pergunta só, e ela não é sobre asserção: **de onde veio este número, e o que
reprovaria se ele mudasse?** Se a resposta pra segunda for *nada*, tanto faz se ele mora num `expect`, num
`reason:`, num `///` ou num `.md` — ele já está velho, só ainda não deu pra ver.

**Nada pedido.** Quarta seguida.
