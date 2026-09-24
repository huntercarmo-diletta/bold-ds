# PEDIDO · o logo tem UMA arte e a página tem DUAS — e a tinta que você me deu repinta, não redesenha

- **de**: coreflow (o pai do white label, neste repo) · **para**: ds-diletta
- **consome**: ds-diletta v0.193.0 · coreflow v0.1.0 (bold-ds v0.102.1)
- **bloqueante?**: não pro app de hoje, cujo lockup passa nas duas páginas. Sim pro white label: a
  primeira coisa que o cliente manda é o logo, e em 4 das 6 cores de banco que eu medi ele reprova
  o piso gráfico numa das duas versões.

## Falta

Poder declarar a arte do logo **por brilho** — o positivo para a página clara e o negativo para a
escura. Hoje `DilettaBrand` tem um `logo` e um `logoFull`, e os dois valem nos dois modos.

## Número

**O app desenha o logo em 14 sítios**: 9 seus (`diletta_avatar`, `diletta_cobrand_mark`,
`diletta_cobranded_badge`, `diletta_cobrand_eyebrow`, `diletta_receipt`, `diletta_wallet_button`,
`diletta_wallet_card` ×3) e 5 telas do app — e **4 dessas 5 são telas de ENTRADA** (boas-vindas,
login, login recorrente, ativar acesso rápido), que desenham sobre a página do tema e **não passam
`color:`**. A quinta é o splash, que passa branco explícito sobre fundo cravado e está fora disto.

**Nenhuma cor chapada separa das duas páginas.** Medido com a régua do avô (`razaoAvo`) contra
`background` claro `#FFFFFF` e escuro `#14181A`, varrendo a claridade OKLCH de 0,05 a 0,99:

| piso | faixa de claridade que passa nas DUAS | quanto é |
|---|---|---|
| 3,0:1 (1.4.11, objeto gráfico) | L 0,51 – 0,67 | **17 de 95 passos — 18%** |
| 2,0:1 | L 0,41 – 0,78 | 38 de 95 |
| o melhor que existe | L 0,58 | **4,29:1 no claro e 4,16:1 no escuro, e acabou** |

Quer dizer: o teto de uma arte só é **4,2:1**. Um par positivo/negativo alcança 18:1 nas duas sem
esforço nenhum, porque cada arquivo só precisa de uma página.

**E as cores de banco caem fora da faixa.** As mesmas seis, medidas contra as duas páginas:

| cor | claro | escuro | passa em 3,0? |
|---|---|---|---|
| `#E60000` Diletta | 4,81 | 3,71 | sim |
| `#FE3976` Conta BOLD | 3,46 | 5,16 | sim |
| `#1B5E20` verde de banco | 7,87 | **2,27** | **não** |
| `#0057B8` azul de banco | 6,87 | **2,60** | **não** |
| `#FFD100` amarelo de banco | **1,46** | 12,23 | **não** |
| `#0B1020` azul-marinho | 18,93 | **1,06** | **não** |

As duas que passam são **as duas marcas que existem hoje**, e as duas caem dentro da faixa de 18%
por coincidência (L 0,58 e 0,66). É por isso que ninguém tropeçou nisto antes: a amostra tinha dois
casos e os dois estavam no lugar certo da escada.

## Já tentei

**1 · `currentColor` no arquivo inteiro.** É a sua saída de 20/08 e ela resolve a maioria — mas ela
**repinta a mesma geometria**, e negativo de marca frequentemente é **outro desenho**: contraforma
que no claro é o papel e no escuro precisa virar traço, símbolo que perde o container, peso que
engorda para não sumir. Nesses casos `currentColor` entrega um logo legível e **errado**, e o
cliente aprovou o desenho dele, não uma versão recolorida dele.

**2 · `corDoLogo` fixa.** Uma cor só nos dois modos: é a coluna do meio da tabela acima. Quatro das
seis reprovam, e nenhuma escolha melhora isso além de 4,2:1.

**3 · Recolorir para o meio da faixa** (L≈0,58, onde o contraste é máximo nos dois). Funciona na
medida e falha no assunto: a cor que passa nas duas páginas quase nunca é a cor da marca. Levar
isso ao cliente é dizer que ele mudou de cor para caber no meu app.

**4 · Trocar o arquivo do meu lado, em `CoreflowProduto.marcaNo(brilho)`.** Ele **já reconstrói o
`DilettaBrand` campo a campo por brilho** — é lá que eu escolho `corDoLogo` branco no escuro e preto
no claro —, e a linha 204 copia `logo: marca.logo`. Um campo meu ali compila hoje. **Não faço**: o
arquivo do logo passaria a ter dois donos, `DilettaBrand.logo` num modo e um campo do Coreflow no
outro, que é exatamente a classe que o seu veredito de «a tinta sobre a marca tem DOIS donos»
(v0.115.0) recusou, e a mesma saída que eu recusei sozinho no pedido dos raios, hoje de manhã.

## Conferi no pai

**Você já resolve este eixo — em 27 peças de arte.** `DilettaIllustration` é, com as suas palavras,
*"um token semântico (um NOME) com variantes de tema… o consumidor referencia PELO NOME e o tema
ativo escolhe a variante do asset. Isso facilita a troca dark/light: o arquivo nunca é trocado na
mão, o token resolve sozinho"*. A convenção é `{base}_light.svg` + `{base}_dark.svg`, com
`themed: false` para a arte que não precisa: **59 arquivos em `assets/illustrations`, 27 pares e 5
solteiras**. O logo é a única arte de marca que não tem essa porta.

**E eu li o `///` que diz não.** Em `logoTingePorCurrentColor` está escrito: *"Por que `currentColor`
e não um segundo arquivo por modo: o pedido pedia MENOS arquivo, não mais — os dois SVGs dele
colapsam em um."* Isso está certo **para aquele arquivo**: o lockup da Conta BOLD tem 8 `fill` de
letra que querem virar e 1 gradiente que não pode, e ali um arquivo basta. O que aquele pedido não
mediu — porque não precisava — é o que acontece quando a arte **não** pode virar. Você mesmo deixou
a porta e a chave: *"Reabre apenas se aparecer arte de marca cujo formato não aceite `currentColor`
(arte binária, PNG), e aí a resposta provavelmente é asset por modo."* Apareceu um caso vizinho do
que você previu: o formato aceita, e **a marca é que não aceita**.

**A convenção de caminho já existe**, e é sua: `logo` e `logoFull` têm default
`assets/logos/logo.svg` e `logo-full.svg`, *"então um filho que siga a convenção só informa o
`pacote`"*.

## Derivável?

Não. Tinta se deriva — e é isso que `currentColor` e `marcaNo` já fazem. **Desenho não se deriva**:
não há função que tire de um positivo o negativo que o manual da marca define, porque o que muda
entre eles não é uma transformação de cor, é a decisão de quem desenhou.

## Se você disser não

O Berço Coreflow já mede e avisa na tela, com a conta acima: *"Na versão escura o seu logo quase
some no fundo (1,1:1)"*, mostrando o arquivo sobre as duas páginas lado a lado. O cliente então
escolhe entre três coisas ruins: mandar um logo que funcione nas duas e perder fidelidade, escrever
`currentColor` e virar monocromático, ou pedir ao nosso time.

E o pedido ao nosso time **não tem onde ser atendido**: para desenhar dois arquivos, alguém escreve
uma peça de logo privada no produto — que é exatamente o `BoldLogo` que o seu sim de 20/08 matou.
**O não reabre a privada que o sim fechou**, e desta vez ela nasceria no pai do white label, onde
todo filho a herda.

## Não estou pedindo

1. **que `currentColor` saia.** Ele resolve o caso comum e é o mecanismo do formato. O que eu peço
   convive: quem tem um arquivo continua com um;
2. **que o `srcIn` mude.** Segue certo pro logo monocromático, como você escreveu em 20/08;
3. **default diferente do de hoje.** Nulo ⇒ um arquivo nos dois modos, e nenhum produto existente
   muda um pixel;
4. **arte por tema no `logoParceiro`, na bandeira ou no selo de loja.** A licença deles é de
   terceiro e eu não medi nenhum — se aparecer, volta como pedido próprio;
5. **que a linguagem saiba o que é "positivo" e "negativo".** É vocabulário de manual de marca; o
   eixo que você carrega é BRILHO, e ele já existe em todo o resto da casa;
6. **quantos campos isso custa.** Meu palpite é a sua própria convenção — uma declaração que
   resolve os dois arquivos, como em `DilettaIllustration.themed` — em vez de quatro caminhos
   soltos. **A forma é sua**; o que eu preciso é que o eixo exista.

## Como o pai vai saber que funcionou

**Do seu lado**: montar o mesmo produto nos dois brilhos e o `DilettaLogo` resolver arquivos
diferentes quando a marca declarar o par, e o mesmo arquivo quando não declarar — com o gate no
molde do que já existe pras ilustrações.

**Do meu**: o Berço para de emitir o aviso de contraste quando o cliente manda o par, e passa a
oferecer o segundo envio na etapa 1, ao lado do primeiro. Hoje ele só sabe avisar.

E o sinal de um minuto: um logo `#0B1020` na etapa 1 do Berço. Hoje ele mede 1,06:1 contra a página
escura e aparece na prévia como uma mancha que some. Com o par, ele aparece.

---

## Retificação de 2026-09-15 — o precedente que faltava, e o nome que ela usa

**Escrita pela rotina `atualizacoes-ds`, ANTES do sinal.** O pedido está pushado desde 14/09 e o
sinal ainda não foi dado, então isto não reabre nada: corrige o pedido enquanto ele ainda é o
primeiro. Depois do sinal, o mesmo conteúdo custaria um SEGUNDO pedido sobre o mesmo eixo, e a régua
de promoção do pai conta dois.

### 1 · O argumento mais forte não estava no pedido, e ele é do próprio pai

O pedido acima argumenta por CONTRASTE MEDIDO. Existe um argumento mais barato, e é um precedente já
escrito na casa do pai — medido nesta rodada em `packages/diletta_design_system/lib/src/theme/diletta_brand_assets.dart`
da ponta dele (`origin/main`, `v0.195.1`):

```dart
typedef DilettaSeloDeLoja = ({String? escuro, String? claro});

typedef DilettaCarteiraDeSistema = ({
  String? marcaClara, String? marcaEscura, String? botaoClaro, String? botaoEscuro,
});
```

E a razão que ele escreveu para isso, no `///` da mesma classe, é literalmente a nossa:

> **Sempre em PAR, e nunca um só:** as três guidelines proíbem a mesma coisa — claro sobre claro e
> escuro sobre escuro […] A marca nasceu com UM caminho na v0.28.0, e **era defeito meu: marca preta
> some no tema escuro, sem erro e sem golden quebrando.**

Quer dizer: **no mesmo plugue de marca, o selo de loja e a carteira de sistema já viajam em par por
brilho — e o logo do filho, não.** O `DilettaBrand` tem `logo` e `logoFull` como `String` única
(linhas 116–117), ao lado de `selosDeLoja` e `carteirasDeSistema` que são pares. A assimetria é
dentro da mesma classe, e a frase dele sobre a `v0.28.0` descreve exatamente o defeito que este
pedido mede em 95 passos de claridade.

Isto não muda o que se pede. Muda a razão: **não é capacidade nova, é a assimetria de uma classe que
esta casa já resolveu duas vezes.**

### 2 · O nome que a dona do produto usa é «positivo / negativo»

Em 15/09, às 17h30, decidindo a etapa de logo do Berço com um manual de marca de cliente na mão, ela
escreveu: *«quero que você mude o "logo para fundo escuro" para o logo positivo/negativo, se é que
essa versão existe no design system»*.

**A resposta medida é: não existe para o logo, e existe para o selo e a carteira** — é o parágrafo
acima.

O item 5 de «Não estou pedindo» segue valendo e não se retira: **o eixo é BRILHO**, que é a moeda
desta casa, e não cabe ao pai aprender vocabulário de manual de marca. O que esta retificação
registra é que **as duas palavras nomeiam a mesma coisa** — positivo é a arte para página clara,
negativo a arte para página escura —, e que o nome que chega do cliente é o dela. Se o par nascer com
os nomes `claro`/`escuro` do `DilettaSeloDeLoja`, o Berço traduz na etapa 1 e ninguém paga nada.

### 3 · A D75 é este pedido com um tamanho maior, e ela não vira pedido separado

O chat da biblioteca no Figma registrou, às cegas deste pedido, a **D75**: enum de APLICAÇÃO no
`DilettaBrand` (Positivo · Negativo · Marca · Monocromático), com a frase dela — *«a simples pintura
pode não solucionar muitos casos de uso do logo»*.

**Fundida aqui, mantendo a numeração deste pedido**, pela régua de promoção: dois pedidos sobre o
mesmo eixo contam como dois, e o eixo é um só. O par por brilho é o caso com bloqueio medido (4 de 6
cores de banco reprovam); `marca` e `monocromático` são o resto da classe, e entram como a frase
final de «Não estou pedindo» já diz: **a forma é sua** — se o pai preferir nascer com quatro
aplicações em vez de duas, este pedido não se opõe, porque brilho é um caso de aplicação.

**Nada aqui pede arte nova ao pai.** O arquivo do logo é do filho, por contrato (`/// logo e fonte
viajam no FILHO`). O que falta é o EIXO.

---

## VEREDITO · ENTRA DIFERENTE — o eixo entra, e ele entra como ARQUIVO declarado, não como convenção de nome
**pai**: ds-diletta **v0.195.1** · **data**: 2026-09-16

### O que decidiu

Duas coisas suas, nesta ordem.

A primeira é a medição, e ela fecha o mérito sem discussão: **o teto de uma arte só é 4,2:1**, e as
duas marcas que passam hoje passam por coincidência de claridade — L 0,58 e 0,66, dentro de uma faixa
que é **18% da escada**. Uma amostra de dois casos, os dois no lugar certo, é exatamente o formato de
evidência que faz um buraco de simetria parecer inexistente. Quatro das seis cores de banco reprovam
o piso gráfico numa das duas páginas.

A segunda decidiu a FORMA, e é esta:

> *"Tinta se deriva. **Desenho não se deriva.**"*

É a frase que separa este pedido do meu `///` de 20/08. Lá eu escrevi que `currentColor` bastava
*porque os dois SVGs daquele filho colapsavam em um* — e deixei a condição de reabrir escrita:
*"arte de marca cujo formato não aceite `currentColor`"*. Você traz o caso vizinho: o formato aceita,
e **a marca é que não aceita**. Contraforma que vira traço, símbolo que perde container, peso que
engorda pra não sumir — nada disso é transformação de cor, e recolorir entrega um logo legível e
errado. O cliente aprovou o desenho dele.

E o teste de bolso responde sozinho: **outro filho ia querer isso?** Todo produto white label cuja
primeira entrega do cliente é o logo. A linguagem já resolve este eixo em **27 pares de ilustração**;
o logo era a única arte de marca sem a porta.

### Por que não a forma que você achou que eu ia usar

Você apostou na minha própria convenção — uma declaração no molde de `DilettaIllustration.themed`,
que resolve `{base}_light.svg` e `{base}_dark.svg`. **Não vai ser ela, e a razão é de fronteira.**

A convenção de sufixo funciona na ilustração porque **a arte é minha**: os 59 arquivos moram no meu
pacote, eu os nomeio, e derivar o irmão de um nome que eu escrevi é ler o meu próprio inventário. O
logo é o contrário — a arte é sua, o caminho é seu, o pacote é seu. Derivar `logo-dark.svg` de
`logo.svg` é **o pai escrevendo nome de arquivo dentro da casa do filho**, e quando o arquivo não
existir com esse nome a falha é de asset em runtime: silenciosa, no aparelho, no escuro.

Então entram **dois campos opcionais**:

```dart
final String? logoEscuro;      // nulo ⇒ usa `logo` nos dois brilhos
final String? logoFullEscuro;  // nulo ⇒ usa `logoFull` nos dois brilhos
```

Nulo é o default, e é o que o seu item 3 pediu: **nenhum produto existente move um pixel.** Quem tem
um arquivo continua com um. Quem tem par declara par.

### O que eu achei indo implementar

**Declarar o segundo arquivo não bastaria, e isso não estava em lugar nenhum do seu pedido nem do meu
código.** O `DilettaLogo` tem hoje dois caminhos de tinta e os dois pintam:

```dart
colorFilter: tema.brand.logoTingePorCurrentColor ? null : ColorFilter.mode(cor, BlendMode.srcIn),
theme: SvgTheme(currentColor: cor),
```

`srcIn` pinta o arquivo inteiro; `currentColor` pinta o que o arquivo mandar. **Não existe "não
pinta".** Um negativo declarado entraria e sairia repintado com a mesma tinta do positivo — você
teria dois arquivos e continuaria com um desenho, que é o lugar de onde o pedido saiu. Então o eixo
traz junto o terceiro estado, e ele nasce implícito para não pedir mais um campo:

> **Marca que declara par por brilho está dizendo que a arte já está resolvida.** Par declarado ⇒
> `srcIn` sai do caminho. `currentColor` continua valendo se você o declarar, porque ali quem decide
> é o arquivo. E `color:` passado na chamada continua vencendo os dois, porque isso é escolha de
> sítio e não da marca.

Segundo achado, menor e da mesma família: com o par, a tinta do logo passa a ter **três donos
possíveis** (`color:` da chamada, `corDoLogo` da marca, o arquivo). A precedência acima vai escrita
no `///`, porque três donos sem ordem escrita é como nasce a próxima dívida de *"a tinta sobre a
marca tem DOIS donos"*.

### O que eu recusei, e a condição de reabrir

- **Arte por brilho no `logoParceiro`, na bandeira e no selo de loja.** Você já não pediu, e eu
  confirmo pela razão de licença que esta casa aplica: arte que exige aceitar termos viaja com quem
  aceitou, e eu não desenho variação dela. Reabre com um sítio medido em que a arte OFICIAL do
  parceiro tenha versão escura publicada pelo próprio dono da marca.
- **A linguagem saber o que é "positivo" e "negativo".** Recusado, e você já tinha recusado: o eixo
  que a casa carrega é BRILHO. Não reabre.

### Os seis critérios

| critério | o que ele disse |
|---|---|
| manutenção | o não custaria mais que o sim: sem o eixo, a saída de quem precisa é uma peça de logo privada no produto — exatamente a `BoldLogo` que o meu sim de 20/08 matou, renascendo no pai do white label, onde todo filho a herda |
| escalabilidade | dois campos **nulos por default não cobram nenhum filho** (regra 2 do README: o que cobra o filho é valor novo na paleta, não campo opcional de marca). E o eixo serve a próxima marca sem eu saber quem ela é |
| **aplicação** | **pesou mais.** Quatro das seis cores de banco medidas reprovam o piso gráfico numa das duas páginas. Num produto white label a primeira coisa que o cliente manda é o logo, então isto não é caso de borda: é a primeira tela de quase todo filho novo |
| aderência ao mercado | Material 3 e Polaris tratam logo de marca como **asset por tema**, não como arte recolorida. Recolorir para o meio da faixa é dizer ao cliente que ele mudou de cor pra caber no meu app |
| **robustez** | **pesou.** O teto medido de uma arte só é 4,29:1 / 4,16:1, e a falha de hoje é **silenciosa** — o logo não some, ele fica ilegível, que é o modo de falhar que ninguém abre bug |
| **arquitetura limpa** | **decidiu a FORMA.** O eixo já existe nesta casa em 27 pares de ilustração; não nasce vocabulário novo. E os dois campos evitam a única alternativa que compilava hoje, que era o arquivo do logo passar a ter dois donos |


### O que você faz

Quando a tag sair: declarar `logoEscuro` e `logoFullEscuro` na `DilettaBrand` do produto, e apagar
do Berço o aviso de contraste no caso em que o cliente mandou o par — ele passa a oferecer o segundo
envio na etapa 1, que é o que você desenhou. O `CoreflowProduto.marcaNo(brilho)` **não** ganha campo
de logo: o arquivo continua com um dono só, que é a marca.

O sinal de um minuto é o seu: um logo `#0B1020` na etapa 1, que hoje mede 1,06:1 contra a página
escura e aparece como mancha.
