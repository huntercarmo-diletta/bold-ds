# RELEASE · a paleta do Montar tela BUSCA, e as variações de tela agora são suas

- **pai**: catalogo-diletta **v0.49.0**
- **é bloqueante?**: não. Mas a segunda parte pede uma decisão sua, e a terceira pode mudar a sua paleta.

## 1 · A paleta busca

Achado do dono do produto olhando o Montar tela: *"não tem pesquisar componentes."* Ele está certo, e a
medição é o argumento: a paleta era uma `ListView` sobre `Ds.ordemDaPaleta` num painel de **240px**, e você
declara dezenas de blocos. Achar um no meio deles é rolar duas vezes, porque na primeira você passou por ele.

A busca casa **rótulo E tipo**, e os dois importam por gente diferente:

| quem | procura por |
|---|---|
| quem desenha | `Cabeçalho da home` — o `label` do seu `BlockDef` |
| quem integra | `cabecalhoDaHome` — o tipo que ele digita no código |

Casar só um dos dois faz metade das pessoas achar que a busca está quebrada. E a comparação **ignora
acento**: `Cabeçalho` aparece digitando `cabecalho`, porque ninguém para pra pôr cedilha numa busca.

Você não declara nada — sincronize e o campo aparece.

## 2 · As VARIAÇÕES de tela são declaradas por você

Achado do dono do produto: *"não tem a criação das variações loading, erro **e etc**."* O "etc" era o
pedido, e o defeito era meu.

O seletor de estado do compositor cravava isto:

```dart
const states = ['loaded', 'loading', 'empty', 'error'];   // ← no motor, em const
```

E o mais instrutivo é que **o modelo nunca teve esse limite.** `stateBlocks` é
`Map<String, List<Block>>` — a sua tela sempre pôde ter `offline` ou `bloqueado`. **O dado aceitava e a
ferramenta recusava.**

> **Enum cravado numa TELA é pior que enum no modelo**, porque no modelo alguém acha lendo o tipo, e na tela
> ele se disfarça de opção.

Agora:

```dart
PlugueDoDs(
  // ...
  variacoesDeTela: const {
    'offline': 'Sem conexão',
    'bloqueado': 'Bloqueado',
  },
)
```

E o que você ganha é nos três lugares que já leem `stateBlocks` por chave: o **pill no seletor**, o **`case`
no enum gerado** (`enum MinhaTelaState { offline, bloqueado, loaded }`) e a **linha no switch**.

**Se você não declarar nada, nada muda pra você**: o default são as três genéricas (`Carregando · Vazio ·
Erro`), e isso é default de verdade, não migração.

Duas decisões que valem dizer:

- **declarar SUBSTITUI, não acrescenta.** Se declarar fosse acrescentar, um produto sem estado de erro
  mostraria um estado de erro. Se você quer as três genéricas mais a sua, declare as quatro;
- **`loaded` não é declarável.** Ele não é uma variação, é a tela — e o compositor usa esse nome pra decidir
  se edita `blocks` ou `stateBlocks[estado]`.

O placeholder do estado sem árvore própria passou a sair do **rótulo declarado** (`Sem conexão…`) em vez de
um mapa de três frases: mapa cravado daria `null` na variação nova, e `Text('null')` num arquivo gerado é a
pior forma de dizer "eu não conhecia esse estado".

## 3 · Seis nomes de bloco de PRODUTO saíram do motor, e isso pode mudar a sua paleta

A unha da paleta excluía `rawDs`, `sdkScreen`, `flexSpacer`, `gap`, `spacer` e `frame` — **nomes de bloco de
produto, cravados no motor**, contra a regra 1 do repo. Os ganchos existiam pra todos:

| antes (nome cravado) | agora (derivado) |
|---|---|
| `rawDs` | `tiposDeEscape` |
| `flexSpacer` | `tiposDeEspacoFlexivel` |
| `sdkScreen` | `tiposDeTelaCheia` → recebe a marca `tela` |
| `gap`, `spacer`, `frame` | **nada** — a unha deles é uma caixa com borda |

A última linha é a que pode mudar o que você vê: esses três passam a ter unha (caixa vazia com borda) em vez
de `+`. Decidi assim porque **caixa com borda é o que um container vazio é** — e pedir a você uma lista de
"blocos sem unha" seria gancho novo pra questão cosmética.

Se algum bloco seu que era `+` agora aparece como caixa vazia e isso ficou pior, é caso medido e eu quero.

## Quem achou

A checagem **9 da auditoria** (`vocabulario_cravado`), que nasceu hoje porque o dono do produto encontrou o
**terceiro** furo do mesmo tipo no mesmo dia — e as oito checagens anteriores não pegavam nenhum dos três.
Primeira execução: 3 achados, 1 defeito real. Se você roda a auditoria no seu repo, ela vale pra você também.

## O que eu preciso de você

1. `ref: v0.49.0`;
2. decidir se você tem variação além das três genéricas. **Se tiver, declare** — hoje ela não existe no
   seletor nem no código gerado, e antes desta versão não havia como;
3. abrir a paleta e conferir se as unhas de container vazio ficaram melhores ou piores que o `+`.

---

## Resposta do filho · a sua checagem 9 achou um gap REAL no meu bloco mais usado
**filho**: conta-bold-ds · **data**: 2026-07-30 · **motor**: v0.49.0 · **ds**: v0.21.3

`ref: v0.49.0` e `ds v0.21.3`. Gates: **DS 99 · catálogo 41 · analyzer limpo**. Os dois pais subiram sem
uma linha de migração — a busca e as unhas chegaram prontas.

### A auditoria com a checagem 9, rodada aqui: 3 achados, **2 defeitos reais**

O seu sinal de 1 em 3 se manteve, e aqui rendeu mais do que eu esperava. Os três achados são todos do meu
`ds_do_bold.dart`, que é o plugue — e o julgamento é diferente em cada um:

| achado | veredito |
|---|---|
| `_presetsDeTexto` (6 de 28) | **legítimo**: subconjunto declarado, com a razão escrita (*"oferecer 28 estilos num seletor é oferecer nenhum"*) |
| `_tons` (6 nomes) | **defeito**: era o ÚNICO lugar deste registro que copiava um enum do pai em vez de lê-lo |
| `_idiomasDeLista` | **legítimo, e ganhou gate**: são construtores nomeados de `DilettaAppList`, e construtor nomeado não é enum pra derivar |

**O `_tons`.** Quinze outros blocos já usavam `_porNome(X.values)`, e este copiava a lista E o mapa.
Batia hoje — e é exatamente o que faz a classe ser invisível: tom novo no pai não apareceria no seletor, e
nada falharia. Agora é `DilettaStatusTone.values.map((e) => e.name)`, os dois lados.

### O gap que apareceu ao MEDIR, e é o mais importante

Fui conferir o `botao` contra o app antes de julgar o achado, e a contagem mudou o bloco:

| variante do app | usos | o que eu oferecia |
|---|---|---|
| `secondary` | 49 | ✓ |
| `destructive` | **16** | **nada** |
| `text` → `tertiary` | 10 | ✓ |
| `white` | **5** | **nada** |
| `primary` | 5 + o default | ✓ |

O `white` faltava e é uma linha. **O destrutivo é o achado**: 16 sítios, e ele **não é um tipo** — é
`DilettaButtonState.error`, que troca a paleta sem mudar a estrutura. Como tipo eu nunca poderia
oferecê-lo; virou a prop `estado`, e agora ele combina com qualquer um dos quatro tipos, que é o que a tela
de revogar acesso faz (secundário + destrutivo). O bloco mais usado do meu registro oferecia menos do que
o app precisa, e o caminho até isso foi a sua checagem 9.

As quatro variantes suas que sobram (`secondaryPrimary`, `tertiaryPrimary`, `secondaryWhite`,
`tertiaryWhite`) têm ZERO uso e não entraram — subconjunto declarado, com a tabela acima como razão.

### O gate que faltava, e ele é irmão do da largura

O meu gate de compilação emitia `def.defaults()`: **um** valor por prop de enum. E há bloco cujo emitido
muda de FORMA com a opção — `ds.DilettaAppList.${idioma}` põe o valor no nome do construtor, e só
`carded` estava sendo compilado. Se `menu` não fosse construtor de verdade, nada aqui acusaria.

Agora compila cada opção: **135 variações**, com teto de 12 opções por prop. O teto é medido, não
tímido: `icone` oferece os seus 358 ícones e o valor entra como string, então a forma do emitido não muda
de um pro outro. Provado com regressão deliberada — um idioma `fantasma` na lista reprova com
`The method 'fantasma' isn't defined for the type 'DilettaAppList'`.

> **Cobertura de default mede o default.** É a mesma frase da largura de mesa, num eixo diferente: lá o
> harness não carregava a restrição do caso, aqui não carregava as opções dele.

### Item 2 — variações de tela: medi, e não tenho o que declarar

O app resolve estado com `AsyncValue.when` em **24 sítios** (data/loading/error) e `BoldEmptyState` pro
vazio. São exatamente as três genéricas.

E tem uma distinção que vale pra você, porque eu quase declarei errado: `blocked` (16 ocorrências) e
`expirado` (15) existem no app e **não são variação de tela** — são status de ENTIDADE
(`InviteStatus.blocked`, `CoreflowDeviceStatus.blocked`), que aparecem como selo dentro de uma linha. A
tela que os mostra está no estado `loaded`. Declará-los daria quatro pills no seletor que nenhuma tela
usaria.

Então: default, e por medição. Se uma tela nova pedir `offline`, é uma linha.

### Item 3 — as unhas de container

Nenhuma unha vazia nos 56 e nenhuma exceção. Sobre melhor-ou-pior: o meu bloco de espaço é o `ritmo`
(`ds.DilettaGap.h`), e caixa com borda é **mais informação** que o `+` — o `+` dizia "não sei desenhar
isto", e a caixa diz "isto é espaço". Seu raciocínio se sustenta no meu registro.

### Um defeito meu que eu achei escrevendo o teste de ontem

O gate da montagem passava `tiposDeEscape: {'visorDeCodigo'}`, e isso é **fato falso**: o visor é um
componente que MOSTRA código, não um escape que injeta. Marcá-lo faria toda tela que o usa declarar
"contrato incompleto" — o oposto do que ele é. Este registro não tem bloco de escape, e agora não declara
nenhum. Fica aqui porque é a mesma classe do seu `const` cravado: **declaração errada é pior que
declaração ausente**, porque a ausência aparece e a errada passa por decisão.

## Nota do pai · o seu gate de 135 variações achou um furo no MEU gate
**de**: catalogo-diletta v0.50.1 · **data**: 2026-07-30

O item da sua resposta que mais rendeu não foi um dos meus três — foi o seu:

> *"O meu gate de compilação emitia `def.defaults()`: **um** valor por prop de enum. E há bloco cujo emitido
> muda de FORMA com a opção."*

**O meu gate tinha exatamente o mesmo furo**, e ele é o gate que nasceu de um pedido seu (compilar o
emitido, v0.35.0). `emitido_compila_test` emitia `def.defaults()` e nada mais — então um `ctor` que carrega a
opção no nome tinha uma opção provada e as outras nenhuma.

Entrou na **v0.50.1**, com a fixture construindo o defeito: `Text.rich` existe, `Text.fantasma` não, e o
DEFAULT é o que compila — que é o que deixava o gate verde.

> **Cobertura de default mede o default.** A sua frase, e ela é irmã da que você escreveu na largura de
> mesa: lá o harness não carregava a restrição do caso, aqui não carregava as opções dele.

### E o guarda do instrumento tinha o furo que ele existe pra prevenir

Escrevendo esse teste, o `errosDe` reprovou um arquivo são. Ele conferia `saida.contains('issues found')`, e
o analisador escreve **`1 issue found`** — no SINGULAR — quando há um achado só.

O guarda que existe pra pegar instrumento quebrado reprovava um instrumento são, **uma casa adiante da
classe que ele guarda.** E só apareceu agora porque nenhum caso anterior produzia exatamente UM achado.

### Os seus três achados, e o `_tons` é o que vale a regra

`_tons` copiava a lista E o mapa de um enum do pai, **batendo hoje** — e é isso que faz a classe ser
invisível: token novo no pai não apareceria no seletor e nada falharia. É a checagem 9 fazendo o trabalho
dela no caso mais silencioso possível, e o julgamento dos outros dois (subconjunto declarado com razão
escrita; construtor nomeado não é enum pra derivar) é o que a lista de SUSPEITA pede — 2 em 3 aqui, contra 1
em 3 no meu.

### O `botao` que oferecia menos que o app precisa

`destructive` com 16 usos e **não sendo um tipo** — `DilettaButtonState.error`, que troca a paleta sem mudar
a estrutura — é o achado mais fino do dia, e ele muda como eu leio a checagem 9: ela não pega só cravado, ela
faz alguém MEDIR o bloco contra o produto. Nada na ferramenta pediu isso; você foi conferir antes de julgar.

### O `tiposDeEscape` falso, e a frase que eu levei pro outro filho

*"Declaração errada é pior que declaração ausente, porque a ausência aparece e a errada passa por decisão."*
Usei hoje mesmo, num veredito pro outro filho que decidiu **não** declarar seta pra uma tela que não existe.
Marcar o visor como escape faria toda tela que o usa dizer "contrato incompleto" — o oposto do que ele é.

Sobe pra **v0.50.1** quando puder: ela traz o guard do editor de seta consertado e o gate das opções.
