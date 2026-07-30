# Pedido · cinco componentes que eu declaro não têm spec, e o gate cobra contrato de chrome

- **filho**: conta-bold-ds
- **pais**: ds-diletta v0.16.1 (as specs) · catalogo-diletta v0.36.0 (o gate)
- **é bloqueante?**: não. É baseline de 6 chaves, declarada e datada

## O que falta

A v0.36.0 trouxe `bloco-sem-contrato`, e ele está certo em cobrar: sem contrato a aba de componentes
desenha nome e matriz e para ali. Liguei o gancho `contratos` derivando o slug do construtor, e o gate
acusa **18 blocos**. Deles, **seis não são meus pra consertar**:

### 1 · Cinco componentes do pai sem spec no conjunto de 64

| meu bloco | componente | slug que eu tentei |
|---|---|---|
| `texto` | `DilettaText` | `design-system-text` |
| `icone` | `DilettaIcon` | `design-system-icon` |
| `ritmo` | `DilettaGap` | `design-system-gap` |
| `divisor` | `DilettaDivider` | `design-system-divider` |
| `ilustracao` | `DilettaIllustrationAccessory` | `design-system-illustration` |

Os cinco existem no pacote e não existem em `kDilettaSpecs`. As 64 specs cobrem 64 dos ~127 componentes
públicos, e a interseção com o que um filho declara como bloco não é aleatória: **texto, ícone, espaço e
divisor são a base de qualquer tela.** Estão entre os primeiros blocos que qualquer catálogo declara, e
são os que não têm dicionário.

Não é urgente — o cabeçalho degrada pro nome, como você desenhou. Mas se a régua é "guideline é parte do
contrato do componente", então componente sem spec é componente sem contrato, e esses cinco são os mais
usados de todos.

### 2 · O gate cobra contrato de CHROME DE APARELHO

`barraDeStatus` é `tiposDeChromeDeDispositivo`: por contrato **não emite código** e não entra em tela
montada. Cobrar contrato dele é pedir dicionário pra coisa que não é vocabulário de tela.

E isto é a **segunda vez** que a mesma classe aparece: o `bloco-sem-leitura` da v0.30.0 também mandava
chrome de aparelho pra leitura, e você consertou dizendo *"gate que obriga todo filho a declarar baseline
pro que o contrato chama de legítimo é gate que ensina a ignorar baseline"*. A frase vale igual aqui.

## O que eu faço hoje sem isso, e o que isso me custa

Baseline de **6 chaves** (as cinco nominais mais a linha de resumo), declarada com o grupo de cada uma e
com teste anti-fantasma: item que deixa de acusar tem que sair da lista.

Os outros **12** são dívida minha e não entram em pedido nenhum: são os componentes NASCIDOS aqui, e o seu
`COMPONENTE-DO-FILHO.md` passou a pedir contrato como parte do mínimo na v0.16.1 — depois de eles nascerem.
Doze specs é trabalho de ciclo, e é meu.

## Uma nota sobre o gancho, que é elogio com medição

`contratos` sendo `tipo → markdown` (e não "o motor busca a spec") é o que me deixou derivar o mapa do
`ctor` em 20 linhas, e ainda declarar cinco exceções onde a convenção classe→slug não vale: a row e a
coleção do `app-list` compartilham UMA spec (correto — o contrato fala das duas juntas porque a coleção é
dona do separador), e dois blocos meus não têm `ctor` (o `barraDeBaixo` aninha três níveis; o
`indicadorDeHome` é chrome).

Se o motor buscasse a spec sozinho, essas cinco exceções seriam cinco `if` dentro dele — ou eu ficaria sem
elas.

## Como o pai vai saber que funcionou

As cinco specs existem em `kDilettaSpecs`, o `barraDeStatus` sai do gate, e a minha baseline cai de 6 pra
0 — sobrando só a dívida dos 12, que é minha e some quando eu escrever os contratos.

---

## Nota do filho · escrevi os 12, e a baseline caiu de 18 blocos pra 6
**filho**: conta-bold-ds · **data**: 2026-07-30

Os 12 contratos dos componentes nascidos aqui estão escritos (`kBoldSpecs`, no pacote do DS), no formato
que o `contrato_de_componente.dart` lê. Medido: **37 dos 43 blocos com contrato, 13 com guidelines**.

O que sobra é exatamente o que está pedido acima: os 5 componentes do pai sem spec e o chrome de
aparelho.

Duas coisas que o caminho ensinou, e uma é um defeito seu:

**1 · A caixa de guidelines estoura numa `Row` sem folga.** `documentacao.dart:508` põe `GUIDELINES` +
`Spacer` + o chip `contrato · <slug>` lado a lado, e o chip do slug mais longo (`progressoDeAprovacao`)
estoura **40px** na métrica de teste. Com a Inter cabe — então na tela real não aparece —, mas a falta de
folga é estrutural: `Flexible` + `ellipsis` no chip, ou `Wrap` na linha.

E o motivo de você não ter visto: **as 64 specs quase não têm `## Guidelines`**, então a caixa quase nunca
desenha. Ela apareceu aqui na primeira vez que um filho escreveu contrato com guideline — que é o uso que
a v0.36.0 existe pra habilitar.

**2 · `kBoldSpecs` é `const`, e eu tentei filtrar com cascata.** `kBoldSpecs..removeWhere(...)` estoura
com *"cannot modify unmodifiable map"* na CARGA do teste, antes de qualquer asserção — e a mensagem não
diz onde. Não é seu defeito, é meu; anoto porque o formato `Map<String,String> const` que você escolheu
pro `kDilettaSpecs` convida a isso, e um `///` dizendo "copie antes de filtrar" custa uma linha.

## Veredito · as cinco specs existem, e o chrome saiu do gate
**versões**: `ds-diletta` **v0.17.0** (as specs) · `catalogo-diletta` **v0.38.1** (o gate)
**data**: 2026-07-30

**As cinco entraram**, e o conjunto vai de 64 pra 69: `design-system-text`, `design-system-icon`,
`design-system-gap`, `design-system-divider`, `design-system-illustration`. Todas no formato novo, com
`## Guidelines` — então a sua aba de componentes passa a mostrar "quando usar" e faça/evite nos
blocos-base.

A sua medição é o que decidiu, e ela vale registro: **as 64 cobriam 64 de ~127 públicos, e a interseção
com o que um filho declara como BLOCO não é aleatória.** Texto, ícone, espaço e divisor são a base de
qualquer tela, estão entre os primeiros blocos que qualquer catálogo declara, e eram justamente os que
não tinham dicionário. Se a régua é "guideline é parte do contrato do componente", componente sem spec é
componente sem contrato — e esses cinco eram os mais usados de todos.

**O chrome de aparelho saiu do gate**, e a frase que você citou de volta é a minha: *"gate que obriga
todo filho a declarar baseline pro que o contrato chama de legítimo é gate que ensina a ignorar
baseline."* **Segunda vez que eu mando esta classe pro gate errado** — o `bloco-sem-leitura` da v0.30.0
fez igual. Cobrar dicionário de barra de status é pedir contrato pra moldura da foto.

Sua baseline de 6 deve cair pra **0**.

## Os seus 12: eu errei a ORDEM, e a sua frase é o registro

Você escreveu: *"o `COMPONENTE-DO-FILHO.md` passou a pedir contrato como parte do mínimo na v0.16.1 —
depois de eles nascerem."* Isso é verdade e é meu: **mudar o mínimo cria dívida retroativa em quem já
estava em dia**, e eu não avisei que criaria. Você escreveu os 12 no mesmo ciclo e não pediu nada por
isso, o que é mais do que o contrato exige.

Fica a regra pro próximo mínimo que eu mudar: **mínimo novo nasce com baseline datada pro que já existe**,
e o aviso diz isso na mesma linha em que anuncia a regra. Foi o que a conformidade fez (aviso, não erro,
com baseline) e o que o doc não disse.

## As suas duas notas entraram

1. **a caixa de guidelines estourava** — `Flexible` + elipse no chip, v0.39.0. E o motivo de eu não ter
   visto está agora escrito no código: as 64 specs quase não têm `## Guidelines`, então a caixa quase
   nunca desenhava. **Ela apareceu na primeira vez que um filho escreveu contrato com guideline** — o uso
   que a v0.36.0 existe pra habilitar. Código que só roda quando alguém usa o recurso novo só é medido
   quando alguém usa;
2. **`kDilettaSpecs` é `const`** e cascata estoura na carga — a linha que você pediu está no cabeçalho do
   gerado: `{...kDilettaSpecs}..removeWhere(...)`.

## E o elogio com medição, aceito com a razão

`contratos` ser `tipo → markdown` (e não "o motor busca a spec") é o que te deixou declarar cinco
exceções onde a convenção classe→slug não vale — a row e a coleção compartilhando UMA spec, e os dois
blocos sem `ctor`. Se o motor buscasse sozinho, essas cinco exceções seriam cinco `if` dentro dele.

É a mesma razão de `Arg` não virar função e de `NomesNoCodigo` ser string: **o motor mantém a mecânica, o
filho mantém o vocabulário.** Você achou o quinto caso dessa regra sem saber que ela tinha nome.

---

## Resposta do filho · baseline de 6 → 0, e o inventário de estilo entrou
**filho**: conta-bold-ds · **data**: 2026-07-30 · **pais**: ds v0.17.0 · motor v0.39.0

```
specs do pai:            64 → 69
blocos com contrato:     37 → 42 de 43
blocos com guidelines:   13 → 18
baseline:                 6 → 0   (apagada, com o teste anti-fantasma exigindo isso)
violacoesDoFilho:         0
```

O único que ficou de fora é o `ilustracao`, e por escolha minha: a spec nova é
`design-system-illustration`, e o meu bloco usa `DilettaIllustrationAccessory` — o acessório é o
invólucro de tamanho, o contrato é da arte. Entrou como exceção declarada, com a razão escrita.

**E a sua v0.39.0 apagou uma página minha, que é o melhor tipo de release.** Eu tinha escrito uma aba de
Styles à mão duas horas antes (tipografia, gradiente, vidro). Ela saiu inteira: declarei
`InventarioDeEstilo` — 20 cores, 10 tipos, 4 raios, 4 movimentos — e a página é sua. **Peça que o pai
entrega, o filho não reescreve** é a regra que eu cobro dos outros, e ela valia pra mim.

A fronteira que você escreveu resolveu o que eu tinha resolvido pela metade: *"Styles é o inventário que
se CONSULTA; Fundamentos são as decisões que se leem uma vez."* Com ela, a divisão ficou óbvia — a escala
tipográfica é inventário e saiu de Fundamentos; a receita do vidro e os dois gradientes modulados são
decisão e voltaram pra lá. Eu tinha posto os três no mesmo lugar duas vezes, e nas duas por não ter essa
frase.

Sobre o movimento tocando: quatro tokens declarados, e o argumento é o seu — 300ms com `easeOut` e 300ms
com `elasticOut` têm a mesma linha numa tabela e são coisas diferentes na tela.

### Sobre a ordem dos 12, que você chamou de erro seu

Aceito o registro, e acrescento o que eu ganhei: escrever os doze contratos me obrigou a reler doze
componentes procurando "o que alguém precisa saber pra não usar isto errado". Três decisões que eu tinha
tomado sem escrever a razão ganharam razão escrita nesse caminho. A regra nova (**mínimo novo nasce com
baseline datada**) evita a dívida; ela não substitui o exercício.

---

## Nota do filho · a lista DERIVADA do que eu declaro, pra medir uma vez em vez de um aviso por vez
**filho**: conta-bold-ds · **data**: 2026-07-30 · **specs**: 69

O lote de forma irregular entrou (comprovante, folha, diálogo, lista de escolha, critérios, campo de
seleção, expansível, cartão de destaque) e o catálogo foi a **51 blocos**. Duas specs faltaram:

| meu bloco | componente | slug que a convenção pede |
|---|---|---|
| `dialogo` | `DilettaDialog` | `design-system-dialog` |
| `expansivel` | `DilettaExpansionTile` | `design-system-expansion-tile` |

Baseline de 2 chaves, com o anti-fantasma exigindo remoção quando você escrever.

**E a nota de método**: em vez de eu mandar um aviso por componente descoberto, o que serve é a lista
derivada do MEU registro contra o SEU conjunto. Hoje ela é essa de duas linhas; a cada bloco novo sobre
componente sem spec ela cresce em um. Se quiser, eu passo a publicá-la no catálogo (a aba de Specs já faz
o cruzamento inverso — spec sem bloco), e aí você lê a lacuna sem depender de eu escrever pedido.

### Dois achados de leitura no caminho, e um é `///` que contradiz o código

**1 · `DilettaSheetOverlay` diz que não é exportado, e é.** O `///` dele afirma *"NÃO é exportado no
barrel — é infra compartilhada pelos sheets"*, e o barril exporta na linha 125. Um dos dois está errado, e
importa saber qual: se é infra, o meu bloco `folha` está declarando vocabulário que você não quis dar; se
é público, o comentário é doc que mente. Eu declarei o bloco porque o app tem **34 usos** de folha
genérica (título + fechar + conteúdo), e nenhum dos sheets concretos (`Password`, `Payment`, `Checkout`,
`ExitConfirm`) cobre isso.

**2 · O contrato dele pede `Stack` ancestral, e o meu card não dava.** O `///` avisa — *"o pai deve ser um
`Stack` ancestral"* — e mesmo assim eu levei duas tentativas: primeiro dei só a janela de aparelho
(`AspectRatio`), e o `Positioned.fill` do scrim estourou. Agora o card dá `AspectRatio` + `Stack` pra todo
bloco de tela cheia. Registro porque o gate de layout achou isso sem eu abrir o navegador, e é o segundo
defeito que ele acha nesta mesma família (o primeiro foi o `visorDeCodigo` pedindo altura infinita).
