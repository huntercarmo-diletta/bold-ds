# PEDIDO AO DONO · a seleção engrossa a borda em CINCO telas, com QUATRO espessuras — e este DS já respondeu isso de outro jeito

- **de**: conta-bold-ds (a BASE da família) · **para**: o dono do produto
- **consome**: DS v0.87.0
- **bloqueante?**: não. O eixo `larguraDaBorda` entrou pra o desenho sair das telas hoje; a pergunta
  é o que decide se ele fica.

## O que eu achei

A varredura das 128 pinturas das telas em 01/09 achou **nove** bordas com espessura diferente de 1.
**Cinco delas são condicionais, e as cinco significam a mesma coisa: escolhido.**

| tela | o que ela escreve |
|---|---|
| editor de menu da home | `selected ? 2 : 1` |
| tipo de conta (onboarding) | `selected ? 2 : 1.5` |
| documentos da empresa | `uploaded ? 1.4 : 1` |
| alçadas — faixa dourada | `golden ? 1.3 : 1` |
| autorizações — cartão do pedido | `selected ? 1.5 : 2` |

Quatro espessuras de "escolhido" — **1,3 · 1,4 · 1,5 · 2** — e a última **inverte a lógica das
outras quatro**: escolhido fica mais FINO.

## Por que isso é pergunta e não conserto

**Este pacote já respondeu uma vez, e a resposta foi outra.** O `CoreflowCartaoDePedido` marca
`selecionada` trocando a **cor** da borda — `s.primary` contra `s.border` — e não a espessura. Ele é
a peça mais nova das seis, e foi desenhada olhando o problema.

Então a linguagem diz *"escolhido"* de dois jeitos: uma peça por cor, cinco telas por espessura. Uma
linguagem que diz a mesma coisa de dois jeitos tem um jeito a mais.

## O que eu NÃO fiz, e por quê

Converter as cinco pra cor. Seria uma linha em cada uma, e **mudaria pixel em cinco telas numa
passada que ninguém abriu pra olhar**.

A régua desta casa sobre isso já custou caro três vezes hoje: `analyze` limpo e 852 testes verdes
não viram um fio a mais em 25 telas, nem duas telas desenhando arquivo inexistente, nem dois cinzas
no mesmo pegador. **Gate não vê forma.** Trocar a affordance de seleção em cinco telas é
exatamente o tipo de mudança que precisa de olho, e eu não tenho aparelho nem retrato aqui.

## O que eu fiz

`CoreflowCartao(larguraDaBorda:)`, com a razão escrita no campo. O desenho saiu das cinco telas — a
caixa agora é a peça — e o pixel não mudou em nenhuma.

O campo é declaradamente temporário: **quando a pergunta for respondida, ele sai e as cinco viram
`borderColor`.**

## A pergunta, em uma linha

*Seleção neste produto é COR de borda (como o cartão de pedido faz) ou ESPESSURA (como as cinco
telas fazem)?* Se for cor, eu converto as cinco e apago o eixo. Se for espessura, o cartão de pedido
é que está fora do padrão, e aí a espessura precisa de um número só — não de quatro.

---

## VEREDITO DO DONO · 2026-09-02 — *"vamos manter tudo no DS"*

A pergunta oferecia duas saídas — cor ou espessura — e a resposta escolheu o EIXO em vez do valor: a
decisão mora aqui. Então não é só que seleção virou cor; é que ela deixou de ser algo que uma tela
escreve.

### O que entrou

`CoreflowCartao(selecionado:)` — **borda `primary`, fundo `primaryWash`**, que é a resposta que o
`CoreflowCartaoDePedido` já dava. `larguraDaBorda` saiu e no lugar dela ficou `bordaReforcada`, um
BOOLEANO: o produto tem duas espessuras de fio, 1 e 1,5, e as duas moram no cartão. Número livre foi
o que deixou cinco telas inventarem quatro valores em quatro dias.

### O que a conversão achou, e não estava no pedido

Contar cinco divergências abriu mais três, e as três são do mesmo tipo — **peças que respondiam
sozinhas uma pergunta que a casa já tinha respondido**:

| onde | o que dizia |
|---|---|
| `CoreflowAmostraDeFundo` | um SEXTO jeito: anel de 2,5, transparente quando não escolhido |
| `CoreflowCartaoDePedido` | escolhia com o `primary` **do PAI** enquanto o resto do produto escolhia com o deste DS — dois rosas diferentes, e ninguém tinha os dois na mesma tela pra ver |
| `tipo_conta` × `home_menu_editor` | dois banhos pra mesma seleção: `primary.withAlpha(15)` contra `primaryWash`, ~3,4× de diferença |

O da amostra de fundo **fica**, e é o único: a peça retrata uma ARTE DE FUNDO num quadrado de 52, e
tingir o miolo pintaria por cima justamente do que a pessoa está escolhendo. Está declarado no gate
com essa razão, pra ser reencontrado no dia em que alguém contar de novo.

O do cartão de pedido é o achado que paga a passada. Ele foi apontado no pedido como *"a peça mais
nova, desenhada olhando o problema"* — e ela era. Estava certa na forma e errada na fonte.

### O olho, que era a razão de isso ser pergunta

Os dois pares foram renderizados e abertos, claro e escuro. O que se vê: no CLARO, `alpha 15` sobre
branco lê **cinza sujo**, não rosa — a tela de tipo de conta marcava a escolha com uma sujeira. Com
`primaryWash` ela marca com a marca. No escuro a diferença é de força, e a favor.

### O que ficou de gate

`test/o_escolhido_se_diz_de_um_jeito_test.dart`, e ele defende a **unicidade**, não o valor: quatro
fios com espessura própria declarados com a razão de cada um, entrada nova falhando, entrada morta
falhando, e um teste de PIXEL provando que o miolo muda e muda para a MARCA — um filho verde tem que
ler escolha em verde, e um gate que só lesse `border` passaria com a seleção invisível a um braço de
distância.

### Onde estava a sétima cópia, e por que nenhum gate a via

Na tela de preferências do Letti — **dentro da zona isenta**. O gate das razões escreve a isenção com
todas as letras (*"a Letti é app à parte e não se refaz nesta adoção"*), então não é buraco, é porta
declarada. Mas o que passou por ela foi uma cópia de uma forma do DS, com `Colors.transparent` no
lugar do token, num `foregroundDecoration` que o gate lista entre os pintores e não lê ali.

Zona isenta é onde forma se reproduz sem ninguém contar. A conversão foi feita mesmo assim: a peça
existe agora, e usá-la custou menos que manter a cópia.

### O que a passada NÃO fez, e o que a medição devolveu depois

Escrevi aqui que este pacote lê **dois esquemas** — `CoreflowScheme.of` em 16 arquivos e
`DilettaTheme.schemeOf` em 25 —, que eles discordam no claro, e que converter os 25 era o próximo
trabalho.

**A parte dos 25 estava errada, e a correção veio de medir melhor.** A primeira medição reaproveitou
a árvore entre os dois modos e leu o tema anterior; montando cada modo separado, o que diverge são
**três campos**:

| campo | claro | escuro |
|---|---|---|
| `primary` | `#9e1241` aqui contra `#fe3976` no pai | **igual** |
| `error` | `#b42318` contra `#ef4757` | **igual** |
| `textTertiary` | difere | difere |

E ninguém neste pacote lê `error` nem `textTertiary` do pai. Sobram **cinco** peças lendo `primary`,
e **quatro estão certas**: pintura, anel sobre foto, barra cheia e ponto de página querem o rosa da
MARCA. Não é bug ter dois `primary` — são dois PAPÉIS, o profundo pra ser tinta e o da marca pra ser
pintura.

A quinta era defeito de verdade: a faixa de contexto de operação escrevia texto pequeno com o rosa
da marca sobre a lavagem dele mesmo, **2,63:1**. Consertada na `v0.95.0`, com o gate junto.

**A lição não é sobre cor.** Eu ia converter 25 arquivos por causa de um número que eu mesmo tinha
medido errado — e a varredura global teria mexido na cor de tudo que é claro pra consertar um sítio.
Medir de novo custou dez minutos.
