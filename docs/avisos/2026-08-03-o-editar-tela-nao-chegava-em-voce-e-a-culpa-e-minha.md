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
