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
