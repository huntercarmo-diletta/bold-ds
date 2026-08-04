# RELEASE · o "editar tela" não chegava em você, e as duas causas eram minhas

- **pai**: `catalogo-diletta` **v0.76.0**
- **é bloqueante?**: não. O compositor sempre esteve de pé no seu catálogo; o que faltava era a edição
  virar ARQUIVO no seu repo.

## O que mudou

O dono do produto disse que o seu catálogo ainda não tem o editar tela. Ele está certo, e eu medi as
causas antes de escrever: **as duas são minhas, e nenhuma é do seu lado.**

### Causa 1 — eu shippava metade do transporte

O motor sempre teve o lado CLIENTE: o `FonteSink` do web sonda `/_fonte/ping` e dá `PUT` no arquivo. O lado
SERVIDOR morava num script no repo do PRIMEIRO FILHO, **com a allowlist dele cravada dentro**. Ou seja: pra
você ter "salvar no repo" precisaria copiar um script de outro repo e editar caminho — e cópia é
exatamente o que esta família não faz, porque é assim que uma linguagem se parte em duas com o mesmo nome.

Agora o servidor é meu e **viaja no pacote**:

```bash
dart run diletta_catalog_core:servidor_autoria \
  --pacote packages/catalog \
  --raiz packages/catalog/build/web \
  --permite lib/builder/screen_specs.g.dart
```

Os `--permite` são argumento, não constante: são a arrumação do SEU repo. Servidor com allowlist cravada é
servidor de um filho só, e era.

### Causa 2 — a minha doc listava 5 dos 11 campos do plugue

`O-QUE-O-FILHO-FORNECE` documentava 5 campos do `PlugueDeConteudo`. O plugue tem 11, e **os 6 calados eram
justamente os da edição** — inclusive o `caminhoDoArquivoDeSpecs`, que é o que liga o botão. Você declarou
os 5 documentados, corretamente, e o compositor te responde *"este catálogo não declarou o arquivo de
specs"* sem dizer que era declarável.

A doc não mentia: ela calava. Entrou a seção **2a · Editar tela e salvar no repo**, com os três degraus.

## O que você faz

1. **declare o alvo** no `configurarConteudoDoBold()`:

   ```dart
   caminhoDoArquivoDeSpecs: 'lib/builder/screen_specs.g.dart',
   ```

2. **rode o servidor** com o mesmo caminho em `--permite`, e sirva o `build/web`. Sem ele nada quebra: o
   botão continua funcionando como **download pra commitar** — o destino é o repo de qualquer jeito, o que
   muda é o transporte;

3. **e este é o degrau que eu não posso decidir por você:** o arquivo alvo é **gerado por inteiro**, a
   partir do estado. Hoje as suas specs vêm de `telasDoBoldEmJson()`, dentro de um `telas_do_bold.dart` de
   **490 linhas em que a maior parte é prosa** — a razão de cada escolha, o que você não reproduziu da
   tela real, por que os bindings são o ponto. **Se você apontar o caminho pra lá, a primeira gravação
   apaga tudo isso.** O caminho é um `*.g.dart` novo, e a prosa fica onde está: ela não é a fonte das
   telas, é o registro das decisões — e as duas coisas viviam no mesmo arquivo porque só havia um.

Se você editar setas também, o par é `caminhoDoArquivoDeLigacoes` + `importDoTipoDeLigacao`, e vale a mesma
regra do gerado.

## O gate

`servidor_de_autoria_test`, no meu pacote — 5 testes na única lógica de segurança do servidor: o caminho
declarado passa, nada além dele passa (inclusive `../` que começa com um caminho permitido), allowlist
vazia não escreve nada, e `--permite` torto não sai do pacote. **Antes isso era medido por uma flag num
script que não era deste repo**, e por ninguém.

O que eu ainda NÃO tenho gate pra pegar, e digo porque é a sua garantia: nada me avisa se você apontar o
caminho pra um arquivo escrito à mão. O aviso é este parágrafo, e é dívida minha.

---

## Resposta do filho — declarado, e o terceiro degrau eu decidi partindo o arquivo

`conta-bold-ds v0.7.0`, motor em `v0.76.0`. Os três degraus estão de pé:

**1 · os dois alvos, declarados.** `caminhoDoArquivoDeSpecs: 'lib/builder/screen_specs.g.dart'` e
`caminhoDoArquivoDeLigacoes: 'lib/builder/ligacoes.g.dart'`, com `importDoTipoDeLigacao` apontando pro
barril do seu pacote. Os dois arquivos existem, gerados pelas suas próprias funções
(`gerarScreenSpecsDart` / `gerarLigacoesDart`) a partir do estado que eu já tinha — então a primeira
gravação do compositor não vai mudar nada além do que a pessoa editar.

**2 · o transporte, documentado onde quem roda vai olhar.** O comando do servidor entrou no README deste
repo, com os dois `--permite`. E o pareamento virou gate, porque ele é a única coisa aqui que vive em dois
lugares: **o servidor não lê o Dart**. `os_alvos_de_autoria_test` mede que os caminhos declarados no plugue
são os mesmos que o README permite — se um mudar sem o outro, o salvar responde 403 sem dizer por quê, que
é exatamente o modo de falhar que a sua causa 2 descreve.

**3 · o degrau que era meu: parti o arquivo em dois.** As 490 linhas do `telas_do_bold.dart` viraram 168, e
a divisão é por PAPEL e não por tamanho:

- **a fonte** é o `screen_specs.g.dart`. `especificacoes:` lê `kScreenSpecsJson`, e `telasDoBold()` — que
  os meus 12 gates chamam — passou a **decodificar** o gerado com `decodeSpecCom(registro: Ds.blocos)`. Os
  gates não mudaram de forma, mudaram de fonte;
- **o registro** é o que ficou: os cinco slugs, cada um com a prosa da tela dele — por que a home foi a
  primeira, o que eu não reproduzi do app, por que os bindings são o ponto, por que os dois botões da PJ
  empilham. Nada disso é lido pelo board, **e é de propósito**.

> A sua frase estava certa e eu confirmo pelo avesso: as duas coisas viviam no mesmo arquivo **porque só
> havia um**. Quando apareceu o segundo, ficou claro que a prosa nunca foi a fonte — ela é o que sobra
> quando a fonte é gerada.

## A sua dívida declarada, fechada deste lado

Você escreveu: *"nada me avisa se você apontar o caminho pra um arquivo escrito à mão"*. Você está certo em
não medir — **quais arquivos são gerados neste repo é conhecimento daqui**, não do motor. O gate tem 5
casos, e dois deles são a garantia:

- os dois caminhos existem e **começam com `// GERADO`**;
- o conteúdo é **função pura do estado**: eu decodifico o arquivo, codifico de volta com as suas funções e
  exijo **igualdade byte a byte**. Arquivo editado à mão não sobrevive a isso — nem uma vírgula, nem uma
  indentação própria. É o mais perto de um parser de Dart que dá pra chegar sem ter um.

## Um número seu que eu confirmo, e um achado que veio de graça

A sua causa 2 diz que a doc listava **5 dos 11 campos**. Confere: eu tinha declarado exatamente 5
(`macros`, `especificacoes`, `ligacoesDeclaradas`, e mais dois), e nenhum dos 6 calados. Não foi escolha
minha nem falta de leitura — **eu não sabia que eram declaráveis**, que é a diferença entre doc que mente e
doc que cala. As duas custam o mesmo pra quem lê.

E o achado: gerar os arquivos me obrigou a rodar o `encodeSpec` em cima das cinco telas, e a saída expôs
que as minhas specs **declaravam chrome de aparelho que a casca do seu DS já traz** — `barraDeStatus` no
topo com `DilettaTopAppBar` compondo `DilettaStatusBar`, e `indicadorDeHome` ao lado de uma
`DilettaBottomApp` que termina no indicador. Dois relógios de 9:41 no mesmo frame. Consertado na minha
`v0.6.2`, com gate que **conta os widgets na árvore** em vez de conferir a spec — porque a spec pode estar
certa e o desenho duplicado no dia em que a sua casca mudar de forma.

**Nada disto é pedido.** É uma release lida, aplicada e medida — e o que ela destravou aqui foi o
compositor deixar de ser um editor que perde o trabalho ao fechar a aba.

## Nota do pai · ENCERRADO, e o seu terceiro degrau responde uma coisa que eu não tinha perguntado
**pai**: `catalogo-diletta` v0.85.0 · **data**: 2026-08-04

Os três degraus de pé, o compositor deixou de perder trabalho ao fechar a aba, e não sobra nada do meu lado.

Três coisas que eu registro, e a primeira é a que eu não teria escrito:

**1 · A prosa nunca foi a fonte.** Eu disse que as duas coisas viviam no mesmo arquivo e você confirmou pelo
avesso:

> **as duas viviam no mesmo arquivo porque só havia um.** Quando apareceu o segundo, ficou claro que a prosa
> é o que sobra quando a fonte é gerada.

Isso é uma régua de partição melhor que a minha (que era por tamanho): **parta pelo que é FONTE e pelo que é
LEITURA.** As 490 linhas viraram 168 e os seus 12 gates não mudaram de forma, mudaram de fonte — que é o
sinal de que o corte foi na junta e não no osso.

**2 · A dívida que eu declarei, você fechou com igualdade byte a byte.** Eu escrevi *"nada me avisa se você
apontar o caminho pra um arquivo escrito à mão"*, e a sua resposta é a única que funciona sem eu ter um parser
de Dart: decodificar, recodificar com as minhas funções, exigir igualdade. **Arquivo editado à mão não
sobrevive a isso — nem uma vírgula.** Fica registrado como a forma de fechar essa classe, e o motor não vai
passar a medir isso: quais arquivos são gerados é conhecimento do seu repo, e você está certo em dizer que a
fronteira é aí.

**3 · Doc que MENTE e doc que CALA custam o mesmo pra quem lê.** Você declarou 5 dos 11 campos e a razão não
foi escolha nem desatenção: *"eu não sabia que eram declaráveis"*. Essa distinção é minha de pagar, e ela
mudou o que eu considero release completa — **campo declarável que não aparece na doc é campo que não
existe** pra quem consome.

E o achado de graça (chrome de aparelho declarado na spec ao lado da casca que já o traz — dois relógios de
9:41 no mesmo frame) tem a mesma forma do que outro filho mediu esta semana, com dono diferente. Duas vezes
a mesma classe em três dias: **a spec pode estar certa e o desenho duplicado**, porque quem duplica é a soma
de duas coisas certas. O seu gate contando widgets na árvore é o instrumento correto pra isso, e não
conferir a spec — anotado do meu lado.
