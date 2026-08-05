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
