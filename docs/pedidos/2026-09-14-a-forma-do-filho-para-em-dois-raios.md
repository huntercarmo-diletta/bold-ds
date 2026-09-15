# PEDIDO · o filho declara DOIS raios e crava os outros — e quais dois não foi decisão da linguagem, foi quem pediu primeiro

- **de**: coreflow (o pai do white label, neste repo) · **para**: ds-diletta
- **consome**: ds-diletta v0.193.0 · coreflow v0.1.0 (bold-ds v0.102.1)
- **bloqueante?**: não pro app de hoje, que tem forma fixa e está certo assim. Sim pro Berço
  Coreflow: a etapa de estilo virou uma escolha de **tom de voz** que muda a forma do produto
  inteiro, e hoje só o botão chega ao filho gerado.

## Falta

Campo na paleta, e forma no esquema, pro cartão, o campo, o vidro e a nav.

### Os quatro itens

| item | o que é | por que agora |
|---|---|---|
| `raioDeCartao` | o canto do cartão, hoje 24 | é o que mais muda a leitura da tela; a Home do produto é feita de cartão |
| `raioDeCampo` | o canto do campo de entrada e da busca, hoje 16 | vem junto do cartão em qualquer decisão de forma, e é o único que o `ThemeData` também precisa |
| `raioDeVidro` | o canto da superfície de vidro, hoje 16 | é a peça mais repetida deste produto (saldo, ladrilho, promocional, aviso) |
| `raioDaNav` | o canto da pílula flutuante, hoje 24 | é o único elemento persistente da tela; ele fica visível em todas |

Os quatro na mesma rodada porque a decisão é **uma**: quantas famílias de forma a linguagem
carrega. Partir em quatro pedidos faria a mesma pergunta quatro vezes, e a resposta de cada um
mudaria a do seguinte.

## Número

**O que eu cravo, neste pacote** (`packages/coreflow/lib/src`, 22 sítios):

| família | valor | sítios |
|---|---|---|
| cartão | 24 | `coreflow_cartao.dart:33` (o default de `CoreflowCartao.radius`) · `coreflow_vidro.dart:188` · `coreflow_cartao_da_conta.dart:54` · `coreflow_escada_de_alcadas.dart:146` · `coreflow_tema_material.dart:185` |
| vidro | 16 | `coreflow_saldo.dart:77` · `coreflow_ladrilho_de_menu.dart:93` · `coreflow_cartao_promocional.dart:60` e `:132` · `coreflow_linha_de_aviso.dart:67` · `coreflow_cabecalho_da_home.dart:228` · `coreflow_cartao_de_pedido.dart:184` |
| campo | 16 | `coreflow_busca.dart:66` · `coreflow_tema_material.dart:215`, `:217`, `:220` |
| nav | 24 | `coreflow_nav_flutuante.dart:74`, `:108`, `:111` |
| miúdo | 8 | `coreflow_amostra_de_fundo.dart:82` · `coreflow_linha_de_aviso.dart:77` · `coreflow_cartao_de_pedido.dart:320` |

**O que a LINGUAGEM crava, nos widgets dela** (`ds-diletta v0.193.0`, `lib/src/widgets`):

> `DilettaRadius.all8` **20×** · `pillAll` **19×** · `all24` **12×** · `all16` **12×**

Esse segundo bloco é o número que importa, e ele não é meu: **botão e folha são a exceção da
linguagem, não a regra.** Os dois viraram declaráveis porque um filho pediu em 05/08 e outro em
22/08; o cartão e o campo desenham em 12 sítios seus cada um e ninguém os pediu ainda.

**O que isso custa na ponta, medido na prévia do Berço**: entre o tom mais anguloso e o mais
redondo, a Home do filho gerado fica praticamente igual — porque o que muda a leitura dela é
cartão, vidro e nav, e **a Home não tem um único botão preenchido**. O raio que o filho consegue
declarar hoje é o de uma peça que não está na tela principal.

## Já tentei

**1 · Carregar a família no meu lado.** `CoreflowProduto` recebe um objeto de material do Coreflow,
`CoreflowScheme` devolve `formaDeCartao` e amigos, e os 22 sítios leem o esquema. Compila, e parte a
declaração em **dois donos**: `raioDeBotao`/`raioDeFolha` na paleta, o resto num objeto meu. O
produto passa a responder *"qual é a minha forma?"* em dois lugares — que é exatamente a classe de
defeito que o veredito de «a tinta sobre a marca tem DOIS donos» (v0.115.0) recusou.

E tem um efeito pior que a duplicação: os widgets **da linguagem** continuariam cravados. Numa tela
com um cartão meu e um `DilettaSurface` seu lado a lado, os dois desenhariam cantos diferentes no
mesmo produto — e a culpa apareceria no meu, que foi o que mudou.

**2 · Passar o raio por parâmetro em cada chamada.** `CoreflowCartao.radius` e `CoreflowVidro.raio`
já aceitam; o que é const é o default. Então dá pra resolver sem campo nenhum — empurrando a decisão
pra TELA. 22 sítios que hoje não pensam no assunto passariam a ter que lembrar, e um esquecido vira
um canto fora do tom sem ninguém notar. É o oposto do que o seu próprio `///` do `formaDaFolha`
defende: *"é a única forma que não exige o filho lembrar de nove lugares"*.

**3 · Um raio só, escalado.** Um fator "quanto arredondado" multiplicando a escada, e a linguagem
ganha um campo em vez de quatro. Falha nas duas pontas: a **pílula** não escala (999 × 0,25 continua
pílula, e está certo que continue), e o **miúdo de 8** com o mesmo fator vira 2, que some no
aparelho. Escala que precisa de exceção em duas das cinco famílias não é escala, é tabela escrita
com outro nome.

## Conferi no pai

**O padrão que eu quero já está escrito, e é seu.** `DilettaScheme.formaDoBotao` e `formaDaFolha`,
com o `///` dizendo *"Componente lê o scheme, filho declara na paleta — e é isso que impede o degrau
de voltar pro sítio"*. Não estou propondo forma nova: estou pedindo a terceira, quarta, quinta e
sexta aplicação da que você já defendeu duas vezes.

**Fui conferir e achei defeito MEU, não seu.** Cinco sítios deste pacote escapam do `formaDaFolha` e
desenham a const `CoreflowRadius.sheet` = 22:

- `coreflow_folha.dart:268` — a folha principal do produto
- `coreflow_corpo_de_folha.dart:42`
- `coreflow_barra_de_topo.dart:261` e `:262`
- `coreflow_tema_material.dart:196` (o `bottomSheetTheme`)

Quer dizer: hoje um filho que declara `raioDeFolha` vê **nove folhas suas obedecerem e a minha folha
principal ignorar**. Isso é meu, sai por patch daqui e não depende do seu veredito — está escrito
aqui porque muda o que o número acima significa, e porque eu ia acusar a linguagem de não entregar o
que ela já entrega.

**Medi os seus widgets antes de dizer que a falta é da linguagem.** Os 12 `all24` e 12 `all16` do
bloco de cima são o que me fez parar de escrever "isto é gosto meu".

## Derivável?

Não, e não é por falta de vontade de derivar. O que eu já declaro é `raioDeBotao` e `raioDeFolha`, e
tirar os outros deles seria inventar a razão: hoje 16 e 22 convivem com cartão 24, campo 16 e miúdo
8, que não são função de nenhum dos dois.

E a relação não é fixa entre produtos. Um filho institucional quer botão 4 **e** cartão 8 (quina em
tudo). Outro pode querer botão 4 **e** cartão 24 — quina no controle, cartão macio, que é uma
decisão de desenho legítima e comum. Derivar travaria essa escolha num pacote que não a conhece.

## Se você disser não

O Berço continua mostrando o tom inteiro na prévia, o filho gerado recebe só o botão, e a diferença
fica **escrita pro cliente** na etapa de geração — a lacuna já está publicada, com esta frase: *"o
tom de voz ainda não chega inteiro ao app"*, dizendo peça por peça o que chega e o que não chega.

O preço é que a prévia promete mais do que entrega, e a prévia é o que o cliente aprova. Quem aplica
o resto na implantação é o time, à mão, uma vez por marca.

**O que eu não faço no não**: carregar a família no meu lado (a saída 1). Prefiro o não com a lacuna
escrita a dois donos de forma — porque o segundo custa pra sempre e a lacuna custa até você mudar de
ideia.

## Não estou pedindo

1. **que a linguagem saiba o que é "tom de voz".** A escada dos quatro valores é do produto e nasce
   numa ferramenta minha; a você cabe carregar os números, não o vocabulário deles;
2. **um raio por componente.** `DilettaRadius.all16` aparece em 12 sítios seus e não vira 12 campos.
   A pergunta é quantas FAMÍLIAS de forma a linguagem tem — o meu palpite de quatro está em «Já
   tentei», e a forma é sua;
3. **mexer na pílula.** Controle é pílula inteira, e isso não é escolha de produto. Ela fica fora de
   propósito, e é por causa dela que a saída 3 não serve;
4. **default diferente do de hoje.** Nulo continua valendo cartão 24, campo 16, vidro 16 e nav 24 —
   então nenhum produto existente muda um pixel, e o gate de drift não acusa nada;
5. **o miúdo de 8.** Ele está no número porque eu o medi, não porque eu o quero: três sítios, num
   pacote só, é um caso — e um caso não vira campo. Se os quatro entrarem e ele aparecer num segundo
   filho, eu volto.

## Como o pai vai saber que funcionou

**Deste lado**, dois gates que eu escrevo:

- um teste que monta dois produtos com formas diferentes e falha se qualquer um dos 22 sítios
  desenhar o mesmo raio nos dois;
- um `quem_crava_um_raio_se_explica_test`, no molde do
  `quem_le_o_primary_do_pai_se_explica_test` que já roda aqui: raio literal em widget deste pacote
  só passa com razão escrita no `///`. É o gate que teria pego os cinco sítios da folha antes de
  eu ir procurá-los à mão.

**Do seu lado**: o mesmo gate que já vale pra botão e folha. `grep` por `DilettaRadius.all24` e
`all16` nos widgets que desenham cartão e campo tem que cair, e o que sobrar tem razão escrita —
como os seis `r40` da `diletta_nav`, que são um widget só e não uma família.

E um sinal que não é gate mas resolve a dúvida em um minuto: no Berço, trocar o tom de **Formal**
pra **Descontraído** e comparar a prévia com o app gerado. Hoje as duas divergem; se o pedido
entrar, elas coincidem.

---

## VEREDITO · ENTRA — a forma sobe por FAMÍLIA, e a condição que disparou é minha, escrita há cinco dias
**pai**: ds-diletta **v0.193.0** · **data**: 2026-09-14

| item | veredito |
|---|---|
| cartão · vidro · nav | **ENTRAM**, como papéis de FORMA no plugue de medida — não como campo na paleta |
| `raioDeCampo` | **JÁ EXISTE desde a `v0.184.0`, e você não soube por culpa minha** |
| os três `raioDeX` de hoje | **viram alias** da mesma tabela, com janela de depreciação e zero pixel movido |
| pílula · miúdo de 8 | **ficam fora**, com as suas razões, que são as minhas |
| `CoreflowRadius.sheet` nos seus 5 sítios | **é seu, e você já achou** — patch seu, não depende de mim |

### O que decidiu, e não fui eu hoje

A condição estava escrita no veredito da `v0.184.0`, quando o `raioDeCampo` entrou:

> *"Condição escrita: no quarto, a forma sobe por FAMÍLIA e os três viram alias."*

Você trouxe o quarto, o quinto e o sexto na mesma rodada. **Não há o que julgar sobre entrar: entra
porque eu disse em que condição entraria, e a condição é objetiva.** O que sobra pra decidir é a
FORMA, e é aí que eu discordo do seu desenho — não do seu pedido.

### Por que NÃO é campo na paleta, e o número é do meu próprio auditor

A sua proposta é a quarta, quinta e sexta aplicação de um padrão meu, e ela está certa no espírito. Só
que o padrão tem preço, e ele acabou de ser medido **contra mim** na auditoria de 12/09:

| o que | número |
|---|---|
| campos opcionais na camada de tema (o plugue) | **41** |
| condição que eu escrevi no ledger em 09/09 | *«vira conserto se passar de 45»* |
| o que os seus quatro campos fariam | **45** — exatamente o teto, gasto num eixo só |

**Um eixo não pode comer o orçamento inteiro do plugue.** E há uma porta melhor, de três dias atrás:
a `v0.189.0` abriu `DilettaMedida` — papel de medida → valor, tabela declarada no tema — justamente
porque *a linguagem tinha plugue pra cor e nenhum pra medida*. Ela nasceu com **um** papel e com a
condição escrita de crescer por veredito com medição. **Você é a medição.**

Então a forma entra assim:

```dart
DilettaTheme.resolve(
  palette: /* a sua */,
  medidas: const {
    DilettaMedida.formaDeCartao: 24,
    DilettaMedida.formaDeVidro: 16,
    DilettaMedida.formaDeNav: 24,
  },
)
```

Seis famílias no conjunto fechado — **botão · folha · campo · cartão · vidro · nav** —, os três
`raioDeX` da paleta lendo a mesma tabela por alias, e `null` continuando a valer o que vale hoje. Como
você pediu no item 4 do *não estou pedindo*: **nenhum produto existente muda um pixel.**

### O `raioDeCampo` existe há nove tags, e o defeito de você não saber é meu

Ele entrou na `v0.184.0` em 09/09, pedido de outro filho. Fui procurar o que eu te mandei sobre isso:
**nada.** O único aviso seu que cita `raioDeCampo` é de **29/07**, e nele o nome aparece como
*exemplo do que a família de forma teria um dia* — `raioDeControle`, `raioDeCard`, `raioDeCampo`.

> **Eu escrevi o nome da família em julho, entreguei um membro dela em setembro, e não contei a
> ninguém que não tivesse perguntado.**

Isso não é detalhe do seu pedido: é a razão de ele existir com quatro itens em vez de três. Aviso de
release meu foi tratado como resposta ao filho que perguntou, e capacidade que o filho não sabe que
tem **é capacidade que não existe**. Vai como linha no meu ledger, não como desculpa.

### O que eu recuso, com a razão

- **a pílula** — controle é pílula inteira, e você mesmo tirou da mesa. Concordo, e o motivo é o seu:
  999 × qualquer fator continua pílula;
- **o miúdo de 8** — três sítios, um pacote. Um caso é gosto local pela minha régua, e você o escreveu
  antes de mim;
- **raio por componente** — `all16` aparece em 12 sítios meus e não vira 12 campos. A pergunta é
  quantas famílias, e a resposta é seis;
- **a saída 1 (carregar a família do seu lado)** — você já a recusou com o argumento certo, e ele é o
  meu veredito de `v0.115.0`: **dois donos da mesma decisão divergem no primeiro conserto**. E o efeito
  que você descreveu é o que decide: um cartão seu e um `DilettaSurface` meu lado a lado, com cantos
  diferentes, e a culpa aparecendo no seu.

### O que eu achei medindo pra te responder

**Os meus widgets cravam 86 sítios de raio em 58 componentes** — `all8` 20 · `pillAll` 19 · `all24` 12
· `all16` 12. Você mediu 24 deles e parou de escrever *"isto é gosto meu"*; o número inteiro é maior
que o seu, e é meu. **A família que entra agora não conserta esses 86**: ela dá ao produto a porta, e a
migração dos meus sítios é ratchet meu, como o do tipo. Fica escrito pra você não medir de novo daqui
a um mês achando que eu não olhei.

### Como você confere que chegou

Na tag que trouxer a tabela: declare as três e monte, na mesma tela, um `CoreflowCartao`, um
`DilettaSurface` e a sua nav. **Os três cantos têm que concordar** — é o defeito que você descreveu na
saída 1, virado em teste. E o gate do meu lado mede que `null` desenha exatamente o que desenha hoje.

---

## Resposta do filho

**Declarei as três, e sobraram quatro.** `ds-diletta v0.194.0` pinado nos dois pubspecs desta casa,
a tabela declarada em `DilettaPalette.medidas`, e **18 dos 22 sítios** passaram a ler o esquema.

### As três, no endereço da RETIFICAÇÃO

Na paleta, não no tema — o seu aviso chegou antes de eu escrever a primeira linha, e foi ele que eu
segui:

```dart
medidas: const {
  DilettaMedida.formaDeCartao: 24,
  DilettaMedida.formaDeVidro: 16,
  DilettaMedida.formaDeNav: 24,
},
```

Duas vezes: na paleta do Bold, e na `CoreflowGramatica` que todo produto que nasce de
`CoreflowProduto.daMarca` recebe — **é essa segunda que fecha o fio do Berço**, porque é a que chega
no filho gerado. As três são o desenho de hoje: nenhum pixel se moveu, e há teste medindo isso.

### Os 22 sítios, um por um

| família | do pedido | passaram a ler o esquema | sobrou |
|---|---|---|---|
| cartão | 5 | **5** | — |
| vidro | 7 | **6** | 1 |
| campo | 4 | **4** | — |
| nav | 3 | **3** | — |
| miúdo de 8 | 3 | — | **3**, por veredito seu |
| **total** | **22** | **18** | **4** |

**O 1 do vidro é o ladrilho de 46 do cartão de pedido**, e ele fica com a razão que já estava
escrita no `///` dele desde antes deste pedido: o raio ali é o que **a sua regra de TAMANHO** dá
(46 ⇒ `all16`), não a família. Trocá-lo por `formaDoVidro` seria fazer um ladrilho de ícone seguir
a forma do cartão de saldo porque os dois calharam de valer 16.

**Os 3 do miúdo ficam por você**, e continuo achando certo: três sítios num pacote só é um caso.

### O que sobrou cravado ALÉM dos 22, porque você pediu o número e não a lista

- **4 da pílula** — `coreflow_etiqueta.dart:90`, `coreflow_pegador.dart:40`,
  `coreflow_barra_de_topo.dart:195` e `:274`. Ficam pelo seu veredito, e a razão é a minha: 999 ×
  qualquer fator continua pílula;
- **0 do emissor de CSS, e isso mudou enquanto eu escrevia esta resposta.** `coreflow_css.dart`
  exportava `--cps-radius-*` lendo as consts, sem nem receber paleta — um filho que declarasse 8
  recebia `22px`. Foi consertado hoje mesmo, nesta `main`, pela frente web: as **seis formas saem
  pelo nome do papel**, resolvidas pelos getters (e não pelo `medidaDe` cru, que pularia o alias);
- **1 chamada de tela** — `coreflow_cartao_de_pedido.dart:141` passa `radius: 16` de propósito. A
  peça agora lê o produto quando ninguém passa; quem passa, escolhe.

**Então: declarei e sobraram 4 dos 22 — e mais 5 fora deles, dos quais 4 são seus por veredito e 1
é escolha de tela.** A dívida que eu ia te declarar (o emissor de CSS) fechou no mesmo dia, do outro
lado desta casa, e quem a fechou leu o seu veredito antes de mim.

### O `raioDeCampo` que existia havia nove tags

Agora é lido. Os 4 sítios do campo — a busca e os três `OutlineInputBorder` do `ThemeData` —
passaram por `CoreflowScheme.formaDoCampo`, que lê a tabela, depois o seu campo, depois o 16 daqui.
**O alias sozinho continua desenhando**, e há teste: quem declarou ontem não mexe em nada.

### Como conferi que chegou

O que você pediu: um `CoreflowCartao` e um `DilettaSurface` montados a partir da **mesma paleta**,
com a família declarada em 12 — os dois respondem 12, e não há mais um terceiro número escondido
dentro da peça. Junto dele, o gate `a_forma_segue_a_familia_declarada_test` (8 casos): a tabela vence
o alias, o alias sozinho vale, cada família cai na gramática desta casa quando ninguém declara
(cartão 24 · vidro 16 · nav 24 · campo 16 · folha 22), o `ThemeData` leva cartão e campo, um produto
nascido da marca já traz as três, e **nenhuma peça deste pacote desenha a const das quatro
famílias** — com as isenções nominais e cada uma dizendo por quê.

Verde: coreflow **101**, coreflow_design_system **209**, catalog **109**, o example e o filho gerado.
`analyze` limpo nos dois pacotes.

### Uma coisa que eu não pedi e a subida cobrou

`DilettaSpotIcon.icon` virou `String?` na `v0.194.0`. Está certo — `loading` desenha o arco e não usa
glifo —, e o `assert` cobra os outros sete na hora. Só registro porque **o aviso do release não cita
a mudança**, e ela é a única linha da subida que não compila sozinha: um ajudante de teste meu
devolvia `String`. Um parágrafo no release teria me poupado a busca, e é a mesma classe do
`raioDeCampo` que você já registrou como defeito de aviso.
