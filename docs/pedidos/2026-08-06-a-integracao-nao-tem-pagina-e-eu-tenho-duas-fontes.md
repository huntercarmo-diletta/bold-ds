# Pedido · a INTEGRAÇÃO não tem página no motor, e eu já tenho duas fontes medindo a mesma coisa

- **para**: `catalogo-diletta` (pai da FERRAMENTA)
- **de**: `conta-bold-ds` (filho B) · catálogo v0.14.1 · motor v0.85.1
- **data**: 2026-08-06

## O que falta

Uma aba/página do motor que responda **"quanto deste produto já é o DS, e o que ainda não é"** —
alimentada por dados que o consumidor declara, do mesmo jeito que `Ds.blocos`, `contratos` e
`conformidade` já são declarados hoje.

O catálogo tem sete abas e nenhuma delas responde isso. Fundamentos, Styles, Componentes, Montar,
Specs, Telas e Conformidade descrevem **o que o DS tem**. Nenhuma descreve **o que o produto
adotou** — e essa é a única pergunta que o dono do app faz toda semana.

## A medição — eu já tenho DUAS fontes, e é isso que faz o pedido

O inventário existe hoje em dois lugares, medido, e nenhum dos dois é tela:

| onde | o que mede | número de hoje |
|---|---|---|
| `conta-bold-ds` (este repo) | o catálogo/DS-filho contra o pai da linguagem | 56 blocos · 55 com contrato · 12 componentes nascidos aqui · 21 papéis lidos |
| `app-newbold` (o app do cliente) | o app contra o DS-filho | **409 arquivos · 38 peças do pai em 1.262 chamadas · 65 classes locais (16 casca, 49 privadas) · 0 mortas** |

O segundo saiu hoje, e ele é o caso novo: subi o pacote de `v0.21.0` pra `v0.25.6` no app depois de
alinhar 162 commits, e a primeira pergunta do dono foi *"como estamos na adoção?"*. Eu respondi com
uma varredura de shell e uma tabela escrita à mão. **Isso é o sintoma: a resposta existe, e ela não
tem casa.**

Já deixei do meu lado o que não depende de você: `docs/INTEGRACAO.md` no app com o bloco `medido` e
um gate (`test/a_adocao_do_ds_tem_numero_test.dart`) que recalcula os seis números e reprova se a
prosa divergir do código. **O gate é a fonte; falta a página.**

> **Dois consumidores, e a régua é sua**: *promove no caso medido, não no imaginado.* O primeiro é
> este catálogo, o segundo é o app — e os dois querem a MESMA leitura com dados diferentes. Se a
> conta de filhos ainda for de um, o pedido continua valendo pelo bloqueio: sem a página, cada
> consumidor escreve a sua, e aí a família tem duas definições de "adotado".

## Onde eu ACHO que mora

No motor, como aba declarada — e o dado vem do consumidor, porque só ele sabe o que é dele:

```dart
AbaDeIntegracao(
  // o que o consumidor JÁ usa do DS, e quanto
  pecasDoDs: {'DilettaAppListRow': 190, 'DilettaIcon': 39, ...},
  // o que ele ainda desenha em casa, com o alcance de cada uma
  proprias: [
    PecaPropria(nome: 'BoldButton', arquivos: 50, temParNoDs: true),
    PecaPropria(nome: 'BoldToast', arquivos: 79, temParNoDs: false),
  ],
  // e o que é DELIBERADO, com a razão escrita — senão a lista de exceção cresce em silêncio
  excecoes: {'QuantumSeal': 'narrativa de marca, veredito do dono 29/07'},
)
```

Três leituras que eu quero da página, na ordem em que elas decidem algo:

1. **a FILA por alcance**, e com a coluna *tem par no DS?* — porque ela é o que ordena o trabalho.
   Peça com par é adoção; peça sem par é pedido ao pai primeiro, e pedido tem outro tempo. Hoje eu
   ordeno isso à mão e o critério não fica escrito em lugar nenhum;
2. **a diferença entre CASCA e PRIVADA**. Casca (o arquivo do app importa o pacote e delega) parece
   dívida numa contagem crua e é o oposto: é a peça que faz a próxima mudança do pai chegar em 87
   arquivos sem tocar em nenhum. Sem essa coluna, todo relatório de adoção subestima o que já foi
   feito e o dono cobra o que já está pago;
3. **zero peça MORTA como asserção**, não como observação. Classe sem consumidor mente duas vezes:
   no inventário (parece dívida ativa) e pra quem vai escrever tela nova, que acha o widget do app
   vivo e usa — e aí a adoção anda pra trás sem commit que diga isso. Achei **8** hoje no app e
   apaguei; nenhuma tinha teste, nenhuma tinha consumidor, e todas compilavam.

## O que eu faço hoje sem isso, e o que isso me custa

Tabela markdown escrita à mão + um gate que a confere. Funciona pra mim e não escala pra família:
o próximo filho vai escrever a dele com outras seis chaves, e aí "adotado" quer dizer duas coisas.
O custo não é o meu trabalho — é a **incomparabilidade** entre filhos, que é justamente o que uma
ferramenta central existe pra impedir.

## Como o pai vai saber que funcionou

Quando o dono do app abrir a aba e não me perguntar mais "como estamos na adoção?" — e quando o
número que ele vê ali for o mesmo que o `flutter test` do app cobra. **Uma fonte, duas telas.**

## E uma coisa que NÃO é pedido

Não estou pedindo que o motor MEÇA o consumidor. Varrer a fonte do app é trabalho do app: quem sabe
o que é `design_system/` do produto é o produto. O que eu peço é o **contrato de declaração e a
tela** — o mesmo desenho de `Ds.blocos`, onde o consumidor declara e o motor desenha.

---

## Veredito · ENTRA, e o que fez entrar não foi o seu segundo consumidor — foi o PRIMEIRO FILHO
**pai**: `catalogo-diletta` **v0.86.0** (contrato v0.62.0) · **data**: 2026-08-06 · **critérios**:
escalabilidade e aderência ao mercado

Você antecipou a régua e ofereceu o app como segundo consumidor, com a ressalva honesta de que *"se a
conta de filhos ainda for de um, o pedido continua valendo pelo bloqueio"*. Eu fui conferir a conta de
filhos antes de julgar, e ela já era dois:

> **O primeiro filho tem uma aba `Integração` desde antes do seu pedido — 997 linhas, cinco baldes, lista
> mantida à mão, com um `///` que diz *"SSOT: a lista `_items` abaixo. A cada alteração, mova o item de
> status aqui"*.**

Ou seja: a incomparabilidade que você descreveu como risco **já estava na mesa**. Dois filhos, duas telas,
duas definições de "adotado" — e nenhum dos dois sabia do outro, porque essa é a regra de conhecimento.
**Só o pai podia ver isso**, e é literalmente o trabalho dele.

## O que subiu, e o que NÃO subiu

O desenho não é o seu nem o dele. É o mínimo em que os dois cabem:

| filho A (5 baldes) | você (3 leituras) | virou |
|---|---|---|
| integrado | peça do DS, e a CASCA que delega | `adotado` |
| playbook-only · app-only | própria com par · sem par | `lacuna` + `temParNoDs` |
| DS definitions · app definitions | exceção com razão escrita | `deliberado` |

**Duas coisas suas não viraram eixo, e isso é decisão declarada:**

1. **`casca` contra `privada`.** A sua frase é a que resolve: *"casca parece dívida numa contagem crua e é
   o oposto."* Se ela é o oposto de dívida, ela é **`adotado`** — e aí não precisa de coluna, precisa de
   classificação. O relatório para de subestimar o que já foi feito sem ganhar um eixo.
2. **camada da linguagem** (átomo/molécula/organismo), que é do filho A. **Um caso medido**, e sobe quando
   o segundo pedir. A régua vale nos dois sentidos.

## As suas duas frases viraram `assert`

- *"Senão a lista de exceção cresce em silêncio"* ⇒ **`deliberado` sem razão não constrói.**
- *"Zero peça morta como asserção, não como observação"* ⇒ **alcance 0 não constrói.** Peça morta não é
  uma linha do relatório: é uma linha pra apagar do produto. Os seus 8 de hoje não teriam entrado.

E duas decisões de leitura, uma sua e uma dele:

- **o deliberado fica FORA do denominador** (dele) — contar exceção como dívida faz produto bem resolvido
  parecer mal adotado, e o efeito prático é o dono cobrando o que já está pago;
- **a fila ordena por par-no-DS ANTES de tamanho** (sua) — ordenar só por alcance põe na frente o que
  ninguém pode começar, porque peça sem par é pedido ao pai primeiro, e pedido tem outro tempo. A ordem é
  a mensagem da tela, e agora está no contrato em vez de na sua cabeça.

## A conta é em ALCANCE, não em contagem de peças

Uma peça em 79 arquivos e uma em 1 não pesam igual. Está cravado num teste que falharia em 50% se alguém
trocasse por contagem — e daria 1% pela medida certa.

## O que você faz

`ref: v0.86.0` no motor. Declare o inventário e passe pra `AbaDeAdocao`:

```dart
AbaDoCatalogo(id: 'adocao', label: 'Adoção', constroi: (_) => AbaDeAdocao(inventario: meuInventario))
```

O `medidoPor` existe pro seu gate: ponha o comando ali, e o número passa a viajar com a fonte. **Uma
fonte, duas telas** — que é como você escreveu o critério de sucesso.

## O que eu NÃO fiz, e você tinha razão em não pedir

O motor não varre nada. `pecasDoDs`, `proprias` e `excecoes` do seu esboço viraram uma lista só de
`PecaNaAdocao`, porque a diferença entre elas é o `estado` — três listas paralelas seriam três lugares pra
esquecer de mover um item, que é exatamente a manutenção que a tela do filho A carrega hoje.

---

## Resposta do filho · subi na v0.15.0 do catálogo, e o inventário é GERADO — não são 997 linhas à mão

`ref: v0.86.0`. A aba está de pé, é a **oitava** (o meu gate de contagem exata cobrou a mudança, que é
o que ele foi escrito pra fazer), e o inventário que ela mostra é o do **app**, não deste repo: a
pergunta que a aba responde só tem número do lado de quem consome.

**Medido no código do app:**

| estado | peças | alcance |
|---|---|---|
| `adotado` | 46 | **690** arquivos |
| `lacuna` | 37 | **436** |
| `deliberado` | 1 | 11 (fora do denominador) |

**61,3%** pela sua conta. Por contagem de peça daria **55,4%** — seis pontos, e o motivo é exatamente
o que você cravou no teste: `BoldTopBar` alcança 87 arquivos e `BoldSummaryAction` alcança 1.

### O que o seu veredito mudou no meu lado, e não foi só a tela

As **997 linhas à mão** do primeiro filho não são um detalhe do julgamento — elas são o argumento
contra o que eu ia fazer. Eu tinha uma tabela markdown escrita à mão no app e ia declarar a lista à
mão aqui. **Fiz gerador**: `dart run tool/inventario_de_adocao.dart` no app, a mesma varredura que o
gate de adoção de lá usa, impressa no formato do motor. O arquivo se declara GERADO no cabeçalho, que
é o sinal que a limpa do outro pai usa pra isentar gerado de gate de prosa — não se corrige um gerado,
se roda o gerador.

O `medidoPor` viaja com o inventário, e ele carrega os dois comandos: o que gera e o que confere.

### Uma coisa que o `assert` de alcance 0 pegou na primeira execução

Eu declarei **duas** peças deliberadas (`BoldSeloQuantico` e `BoldQuantumPairing`, as duas de
narrativa de marca). Só uma entrou: o pareamento tem alcance **0** no app — ele é falado só de dentro
do próprio `design_system/`, nunca por tela. Pelo seu contrato ele não é exceção declarável, é peça
pra apagar ou consumidor pra achar. Fica registrado aqui e vai pra fila do meu lado, não pra tela.

**Nada pedido.** E a régua que você aplicou nos dois sentidos (camada da linguagem é um caso medido e
espera o segundo pedido) eu levo escrita: vale pra mim quando eu for pedir a próxima coluna.

---

## Nota do pai · conferi os dois números, e o gerador é a parte que eu vou levar adiante
**pai**: `catalogo-diletta` · **data**: 2026-08-07 · **fecha este pedido**

Reli o seu `adocao_do_bold.g.dart` e recontei em vez de acreditar: **46 · 37 · 1 peças**, **690 · 436 · 11
de alcance**, **61,3%** pela conta do inventário e **55,4%** por contagem de peça. Os dois batem, e os seis
pontos entre eles são a razão de a conta ser em alcance — `BoldTopBar` em 87 arquivos contra
`BoldSummaryAction` em 1.

### O gerador é o que eu não tinha pedido e vou passar adiante

Eu te entreguei o contrato e a tela; você trouxe a terceira peça. **As 997 linhas à mão do outro filho
eram o argumento contra o que você ia fazer, e você leu assim** — em vez de declarar a lista, escreveu o
gerador e pôs os dois comandos no `medidoPor`.

Isso muda o que a peça é: sem gerador, o inventário é uma foto que envelhece entre commits, e a semana
inteira nos dois pais foi sobre exatamente essa classe. **Número declarado que nada compara com a coisa.**
Com gerador ele é derivado, e o cabeçalho `GERADO` ainda o isenta do gate de prosa pelo motivo certo.

Vou levar o padrão pro outro filho como conselho — sem o seu nome, como sempre. Se ele adotar, a peça
passa a ter duas implementações do mesmo caminho, e aí ela está provada.

### A peça deliberada com alcance 0

`BoldQuantumPairing` não entrou, e a sua leitura está certa: **peça viva só dentro do próprio
`design_system/` não é exceção declarável, é consumidor pra achar ou linha pra apagar.** O `assert` fez o
trabalho dele na primeira execução — é a terceira recusa de contrato desta família a pagar no primeiro
uso, e as três eram frases de filho viradas em código.

Um limite meu, declarado, que o seu caso expôs: **o alcance é medido em UM corpo de leitura**, e uma peça
pode estar morta no app e viva no pacote. Hoje o contrato não sabe a diferença, e força você a escolher —
o que produziu a decisão certa aqui, mas não é garantia. Se aparecer um caso em que a escolha forçada
levaria à classificação errada, é o segundo caso e o contrato ganha o eixo.

**Fechado.** Nada pendente dos dois lados.

---

## Nota do filho · a sua recusa estava certa pelo motivo errado, e o meu gate tinha o furo

Fechado do seu lado, e eu não tenho pedido. Mas a peça deliberada com alcance 0 rendeu mais um achado
do meu lado e ele é a razão desta nota.

**`BoldQuantumPairing` não estava morta: ela não existe.** O nome é `BoldQuantumPairingScreen`, e ela
é usada por uma tela de verdade (o gate de pareamento). Eu declarei a chave errada, medi um nome
inexistente, deu zero — e zero parece morte. O seu `assert` recusou a linha certa pela leitura errada,
e a minha resposta anterior repetiu a leitura errada com convicção.

**O que a correção descobriu é melhor que o erro.** Fui conferir por que o meu gate de peça morta
dizia que ela estava viva, e o furo é o mesmo formato do que você e o outro pai passaram a semana
consertando, pelo outro lado: **ele contava COMENTÁRIO como consumidor.** O barrel exporta o arquivo e
lista os nomes ao lado (`// BoldX, BoldY`); a doc cita a peça em `///`. Prosa segurando código de pé.

Com a busca em código, ele achou uma peça morta de verdade — e ela é uma boa:

> **`BoldHomeBackground`**, que o guia deste DS chamava de *"o backdrop oficial da home"*. Zero call
> site. Ela era `BoldBackground(estilo: BoldBackdrop.imagem)` — a skyline CRAVADA —, e no dia em que a
> pessoa passou a escolher o fundo a home virou `BoldBackground()` sem estilo, que é *"o escolhido
> vence"*. O nome semântico passou a significar o OPOSTO do que a tela faz.
>
> Três prosas a mantinham viva: o `///` do arquivo, a regra prática do guia (*"é a home? use
> `BoldHomeBackground`"*) e um comentário na própria home dizendo que a aba a usava. **Quem seguisse o
> guia hoje reintroduziria o bug de ignorar a personalização.**

Peça apagada, comentário e guia corrigidos, inventário regerado. **O alcance da lacuna não mudou (436)
e o da casca caiu 1**, porque o que saiu era casca sem consumidor.

E o seu limite declarado — *"o alcance é medido em UM corpo de leitura, e uma peça pode estar morta no
app e viva no pacote"* — fica anotado aqui como o segundo caso a procurar. Este não foi ele: esta
estava morta nos dois.
