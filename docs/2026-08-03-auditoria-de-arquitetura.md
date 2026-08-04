# Auditoria de arquitetura — 2026-08-03

Rodada com a ferramenta do pai, com o app irmão no corpo de leitura:

```bash
python3 ../ds-diletta/tool/audita_arquitetura.py . ../app-newbold
```

O repo tem **27 arquivos de lib e 40 de teste**. A ferramenta não é gate — *"metade disto é julgamento, e o
script não finge o contrário"*. O que segue é a medição dela e a **minha leitura de cada item**, porque
número sem leitura é relatório.

## O que a máquina achou, e o que eu li

| # | achado | número | leitura |
|---|---|---|---|
| 1 | maior arquivo de lib | **2477 linhas** (`ds_do_bold.dart`), **32%** do lib | **real, e é o único item que eu levaria adiante** — ver abaixo |
| 2 | nome de produto irmão em string | 3 | **falso positivo**, e o motivo é bom: as três são `'CPF'` como documento (`'rotulo': 'CPF'`, *"Nome, CPF e contato"*). O primeiro filho se chama como um documento brasileiro, e a busca não distingue |
| 3 | cadeia de decisão por tipo | 9 em `leitor_do_bold.dart` | **é a peça certa** — são as 5 entradas que a tabela do motor não cobre (aninhamento, lista com filhos, `Duration`), cada uma com o motivo escrito |
| 4 | símbolo público com ≤1 uso | **0** com o irmão no corpo | eram 3 sem ele. O achado era do CORPO, não do código |
| 5 | `_ =>` que degrada em silêncio | 2 | **os dois têm razão escrita no código, e nenhuma é descuido** — ver abaixo |
| 6 | `catch` vazio · `catch (_)` | 0 · 0 | nada |
| 7 | classe abstrata com ≤1 implementação | 0 | nada |
| 8 | asserções de presença nos testes | **68** | **o achado mais útil da rodada** — ver abaixo |
| 9 | campos opcionais no lib | 21 | julgamento; a maioria é prop de componente que o pai declara opcional |
| 10 | vocabulário cravado (3 listas) | 3 | **curadoria declarada**, não descuido: cada lista tem a razão em cima dela |

## Os quatro que merecem parágrafo

### 1 · O registro de blocos tem 2477 linhas, e é 32% do lib

É o único item que eu levaria adiante, e ainda assim **não fiz**: são 56 blocos num arquivo, ~44 linhas por
bloco, e a concentração é consequência de o arquivo SER o vocabulário. Cortar por grupo
(`Estrutura`/`Conteúdo`/`Lista`/`Ação`/`Marca`) daria ~5 arquivos de ~400 linhas.

**O que me segura:** o arquivo é editado a cada bloco, e quem procura um bloco procura por nome — busca, não
rolagem. O ganho é de leitura no primeiro contato; o custo é o histórico do arquivo se partir em cinco.
Não é decisão de auditoria, é decisão de quem vai manter — **fica proposto, com o número medido**.

### 5 · Os dois `_ =>` são seguros por construção, e os dois dizem isso no código

- `bold_background.dart:149` classifica mood **por exclusão** (`!= imagem && != solido`), então estilo novo
  cai no tratamento certo. Escrever os sete casos duplicaria a mesma expressão seis vezes — e aí o risco
  vira esquecer de mudar uma delas;
- `ds_do_bold.dart:2200` devolve `MotionDaTransicao()` vazio de propósito: o motor lê isso como *"não
  declarado"*, que é a verdade quando o pai cria um tipo de transição novo.

A regra da ferramenta continua certa; o que ela não lê é o comentário em cima da linha.

### 8 · 68 asserções de presença — e hoje elas me custaram três voltas

A ferramenta avisa: *"presença ≠ comportamento: já me pegou 3× — sombra na árvore, ícone com arquivo,
camada no widget"*. **Aconteceu comigo três vezes hoje**, nas três coisas que o dono do produto viu antes
de qualquer teste:

| o que o teste dizia | o que a tela mostrava |
|---|---|
| o card está na árvore | o card era sólido, e devia ser vidro |
| o esqueleto está na árvore | o esqueleto era caixa cinza parada |
| o botão de ícone está na árvore | o ícone não desenhava nada (nome que o pai não tem) |

A resposta que eu passei a usar é **medir pixel**: hoje são **3 arquivos de teste** que leem
`RepaintBoundary → toImage → rawRgba` contra **65 asserções de presença**. Não é pra converter as 65 — a
maioria pergunta "existe?", e presença é a resposta certa pra essa pergunta. É pra a regra:

> **Onde a pergunta é material, cor ou movimento, presença passa com o defeito.** Aí o gate lê pixel, e com
> CONTROLE — o meu primeiro gate de vidro media "tem rosa" e teria passado com um cinza morno.

### 10 · As três listas cravadas são curadoria, e o gate cobre o risco delas

`_presetsDeTexto` (6 de 28), `_tiposDeBotao` (4 de 8) e `_idiomasDeLista` (3 de 3) são subconjuntos
escolhidos, com a razão escrita em cima: *"oferecer 28 estilos num seletor é oferecer nenhum"*.

O risco que a ferramenta aponta é outro e é real — valor que o pai **remova ou renomeie** continua na minha
lista. Ele está coberto: `o_emitido_compila` compila **cada opção de enum** de cada bloco, então opção morta
não passa no gate. Fica escrito aqui porque o próximo a ler a lista vai fazer a mesma pergunta.

## O que esta rodada NÃO mede

A seção 4 da ferramenta (aderência ao mercado) é pergunta, não medição, e as três valem repetidas:

- qual é a referência de prática de cada subsistema?
- o que a gente inventou que já tem nome lá fora?
- o que a gente copiou sem o contexto que fazia aquilo valer?

Deste repo, a resposta honesta de hoje: o vocabulário de blocos é nosso e não tem paralelo direto (o mais
próximo é o de um construtor visual tipo FlutterFlow); a gramática de spec de tela veio do motor do pai; e
o par forma/brilho do esqueleto é padrão de mercado (Shimmer), adotado com o nome de mercado.
