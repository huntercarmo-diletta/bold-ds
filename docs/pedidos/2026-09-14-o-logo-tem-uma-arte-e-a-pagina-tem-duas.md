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
