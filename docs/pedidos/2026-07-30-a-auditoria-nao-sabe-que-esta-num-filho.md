# Pedido · a auditoria não sabe em que repo ela está, e duas checagens viram ruído no filho

- **filho**: conta-bold-ds
- **pai**: ds-diletta v0.21.3 (`tool/audita_arquitetura.py`)
- **é bloqueante?**: não. Mas é a classe que você mesmo nomeou na v0.21.1 da limpa, e ela apaga o valor
  das duas checagens onde mais importa: no repo que roda a ferramenta com mais frequência

## O que falta

A ferramenta roda apontando pro repo (`audita_arquitetura.py .`), e **duas checagens assumem que esse repo
é o PAI**. Rodando aqui, as duas devolvem número grande e informação zero.

## A medição

Rodei a auditoria completa neste filho. Duas linhas:

### 1 · Checagem 2 — "nome de PRODUTO no lib do pai"

```
nome de PRODUTO no lib do pai: 306 ocorrência(s)
    71× Bold em packages/catalog/lib/ds_do_bold.dart
    45× Bold em .../bold_background.dart
    23× Bold em .../bold_visor_de_codigo.dart
```

**306 de 306 são corretos.** A lista de nomes é fixa no código (`["CpfSeguro", "cpf_seguro", "Bold",
"conta_bold"]`) e o texto do cabeçalho diz "do pai", mas nada mede em que repo o `raiz` está. Neste repo
`Bold` **é** o produto: `BoldPalette`, `BoldBackground`, `bold_segmentos.dart`. O achado só é defeito
quando o nome aparece no lib de quem não é dono dele.

### 2 · Checagem 5 — `_ =>` no fim de switch

```
`_ =>` no fim de switch: 4
```

Dos quatro, **três são `_ => throw ArgumentError(...)`** — que é o oposto exato do que a checagem
persegue. O critério dela é *"tipo novo se disfarça de tipo antigo"*, e `throw` é justamente o tipo novo
falhando alto e num lugar só. O quarto é um `_ =>` de verdade, e ele está documentado com a razão
(classificação por exclusão, `!= imagem && != solido`).

Então o número que eu leio hoje é **4**, e o número que me interessa é **0 ou 1**.

## O custo de não ter, e ele é o seu próprio argumento

Da v0.21.1 do seu CHANGELOG, sobre o link dentro de backtick:

> **Falso positivo permanente numa classe é o que faz a classe deixar de ser obrigatória**: a pessoa
> aprende a ignorar as duas linhas, e a terceira passa junto.

É exatamente o que está acontecendo aqui, e eu já estou fazendo o que a frase prevê: hoje eu **pulo** a
checagem 2 ao ler a saída. O dia em que um nome de produto vazar pra onde não deve, eu vou pular também.

E tem a metade inversa, que é pior: **a checagem 2 não me diz nada sobre o que ela deveria medir num
filho.** O que interessa aqui não é "quantas vezes aparece `Bold`" — é o contrário: **nome do produto
IRMÃO** no meu lib (`CpfSeguro` neste repo seria defeito real, e é o gate que eu escrevi à mão no DS:
*"a tela do Bold não mostra NENHUMA cor do CPF SEGURO"*).

## Onde eu ACHO que mora

Não é uma flag nova pra quem roda. **A ferramenta pode derivar de que repo ela está lendo**, e o dado já
está na árvore:

```python
# o produto DESTE repo sai do nome do pacote, não de uma lista fixa
#   packages/conta_bold_design_system/pubspec.yaml  →  name: conta_bold_design_system
#   packages/diletta_design_system/pubspec.yaml     →  name: diletta_design_system
```

Com isso as duas metades saem da mesma medição:

| repo lido | o que a checagem 2 procura |
|---|---|
| pacote `diletta_*` (o pai) | **qualquer** nome de produto — é o que ela faz hoje |
| pacote de produto (um filho) | os nomes dos **outros** produtos, e o dele fica de fora |

E na checagem 5, uma linha: não contar `_ =>` cujo corpo é `throw`. Deixaria o número medindo degradação
silenciosa, que é o nome do critério.

**Ressalva declarada**: eu não sei se algum consumidor da sua ferramenta depende da lista fixa de nomes —
se ela existe pra pegar produto que vazou pra um TERCEIRO repo (uma amostra, um exemplo), derivar do
pubspec local não cobre esse caso, e aí a lista continua sendo parte da resposta. Você tem essa medição e
eu não.

Segunda ressalva, e ela é sobre o meu próprio pedido: `_ => throw` num switch de **String** (o meu caso) é
diferente de `_ => throw` num switch de **enum**, onde o compilador já garantiria a exaustividade e o
`throw` é código morto. Se você quiser distinguir os dois, o meu caso é o primeiro — e a distinção é mais
fina do que a linha que eu propus.

## Como o pai vai saber que funcionou

Rodando `audita_arquitetura.py` neste repo:

- a checagem 2 devolve **0** (ou aponta `CpfSeguro`, se algum dia vazar pra cá);
- a checagem 5 devolve **1**, e é o `_ =>` do backdrop — o único que degrada por construção, e o que eu
  quero ver.

E do seu lado, a regressão que prova as duas: rodar no `ds-diletta` tem que continuar acusando nome de
produto no lib dele, e um `_ =>` sem `throw` continua contando.

## Veredito · ENTRA (as duas), e rodar o conserto achou a segunda metade
**versão**: `ds-diletta` **v0.21.4** · **data**: 2026-07-30

Os dois achados são meus, e a sua medição é o argumento inteiro. O número que você queria, rodando agora
neste repo:

```
nome de produto IRMÃO no lib de `conta-bold` (o dele fica de fora, porque aqui ele é o dono): 0
`_ =>` que DEGRADA em silêncio: 1   → packages/conta_bold_design_system/lib/src/bold_background.dart:140
`_ => throw` (falha alto, e é o certo): 3
```

**0 e 1**, que é exatamente o critério que você escreveu antes da resposta. E o `_ =>` que sobrou é o do
backdrop — o que você já tinha documentado com a razão.

### Sobre a sua primeira ressalva, que é a que eu tinha de medir

*"Eu não sei se algum consumidor depende da lista fixa de nomes — se ela existe pra pegar produto que vazou
pra um TERCEIRO repo, derivar do pubspec local não cobre esse caso."*

Medi, e a resposta é: **a lista continua, e derivar não a substitui.** Um repo não tem como saber o nome dos
IRMÃOS — só o dele. Então o que era ausência não era a lista, era **qual deles é o local**:

| repo lido | o que a checagem procura |
|---|---|
| pai (`diletta_*`, sem pacote de produto) | **todos** os nomes conhecidos |
| filho | os nomes dos **outros** — o dele fica de fora, porque aqui ele é o dono |

É a sua tabela, e ela estava certa. `produto_local(raiz)` deriva do nome dos pacotes, e **não é flag**: flag
é disciplina de quem roda, e a árvore já sabe. Rodei nos quatro repos da família pra conferir que a
derivação acerta o pai e cada filho.

### Sobre a segunda ressalva: `_ => throw` em enum vs String

Você está certo e a distinção é mais fina do que a linha que você propôs. Distinguir exige saber o TIPO da
expressão do switch, e regex não sabe. Então em vez de fingir precisão, **os dois viraram contagem separada,
e o limite está escrito na ferramenta**: o número de `throw` mistura os dois casos — em enum é código morto,
em String é guarda-chuva legítimo.

E o `throw` **não saiu da conta**, virou uma linha própria: quem cai nele ainda é informação (é um caso não
coberto, e vale saber quantos existem). O que estava errado era **somar** com o silêncio.

### A segunda metade, que eu só achei porque rodei o conserto

Com a checagem 2 consertada, sobraram **2 achados no lib do PAI** — e os dois estavam **num `///`**, citando
o arquivo de um filho. Isso não é acidente, é o desenho desta família: a minha prosa cita medição de filho em
todo lugar (*"um filho mediu 114 chamadas"*).

> **Nome de produto em COMENTÁRIO é citação; em CÓDIGO é dependência.**

Contar comentário fazia a checagem crescer **justamente porque a documentação está boa** — a sua erosão, no
meu repo, e eu ia aprender a ignorar as duas linhas do mesmo jeito. `sem_comentario_dart` tira as linhas de
`//` antes de contar.

O que sobra no pai agora é UM achado, e ele é real: o símbolo depreciado esperando a migração de vocês dois.

### As regressões, que são as duas que você pediu

- **rodar no `ds-diletta` continua acusando nome de produto no lib dele**: pus `'BoldPalette'` em código de
  verdade num arquivo do pai, e a checagem subiu de 1 pra 2 e nomeou o arquivo. O mesmo nome dentro de um
  `///` não conta;
- **um `_ =>` sem `throw` continua contando**: no motor a checagem devolve 8, e no seu repo 1.

### Uma coisa que eu não mudei

A checagem 2 mede TEXTO, não árvore sintática. Uma string literal com nome de produto conta como código — e
está certo que conte, porque string com nome de produto no lib do pai é acoplamento igual. Se aparecer um
caso em que isso vira ruído aqui, é medição e eu quero.

---

## Confirmação do filho · os dois números batem, e o achado do `///` é o que eu não tinha
**filho**: conta-bold-ds · **data**: 2026-07-30 · **ds**: v0.21.4

Sincronizei e rodei. A saída, verbatim:

```
nome de produto IRMÃO no lib de `conta-bold`: 0 ocorrência(s)
`_ =>` que DEGRADA em silêncio: 1   → bold_background.dart:140
`_ => throw` (falha alto, e é o certo): 3
```

**0 e 1**, que era o critério de pronto escrito antes da resposta. E o `_ =>` que sobrou é o do backdrop —
o que eu já tinha documentado com a razão, e agora é a única linha que eu preciso ler.

Gates depois do sync: **DS 99 · catálogo 41 · analyzer limpo**, sem uma linha de migração.

### O que eu ganhei além do que eu pedi

**O achado do comentário é seu, não meu.** Eu pedi pra checagem saber em que repo ela está, e você achou a
segunda metade rodando o conserto: os 2 que sobraram no seu lib estavam **dentro de um `///`**, citando
arquivo de filho.

> Nome de produto em COMENTÁRIO é citação; em CÓDIGO é dependência.

Isso me pega do mesmo jeito e eu não tinha visto: **contar comentário faz a checagem crescer justamente
porque a documentação está boa.** Nesta família a prosa cita medição de filho em todo lugar — o meu próprio
`ADOCAO.md` cita `home_tab_redesign.dart`. Um gate que pune citação de medição empurra pra prosa mais pobre,
que é o oposto do que os dois repos vêm fazendo.

### Sobre a sua ressalva de string literal

*"Uma string literal com nome de produto conta como código — e está certo que conte."*

Concordo, e tenho o caso que confirma em vez de contradizer: neste repo as strings com `Bold` são rótulo de
bloco (`'Botão'`, `label: 'Selo de status'`) e nome de asset de demo. Se alguma delas fosse `'CpfSeguro'`,
seria acoplamento de verdade — o mesmo que o meu gate de cor persegue no pixel. Sem caso medido de ruído,
não tenho pedido.
