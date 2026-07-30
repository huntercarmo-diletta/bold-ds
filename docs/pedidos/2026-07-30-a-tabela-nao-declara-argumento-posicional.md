# Pedido · a tabela não declara argumento POSICIONAL, e o conserto da v0.32.1 destampou isso

- **filho**: conta-bold-ds
- **pai**: catalogo-diletta v0.32.1
- **é bloqueante?**: **sim**, e pro bloco mais comum de qualquer tela. Dois blocos meus emitiam Dart
  inválido, e três gates verdes por cima

## O que falta

`Arg` só sabe emitir `nome: valor`. Não há forma de declarar que um argumento é **posicional**, e
posicional não é caso de borda na sua própria linguagem:

```dart
ds.DilettaText('oi', style: ...)        // o conteúdo é posicional
ds.DilettaGap.h(ds.DilettaSpacing.s4)  // o token é posicional
```

Eu declarava o nome vazio (`Arg.texto('')`), que era a única saída, e o emissor concatena assim:

```dart
partes.add("${arg.argumento}: '${_escapa('$valor')}'");   // nome vazio ⇒ ": 'oi'"
```

## A medição

Antes da v0.32.1 isso **nunca aparecia**: os dois argumentos eram iguais ao default do bloco, e a regra
de omissão os descartava. O seu conserto — certíssimo — removeu a cobertura:

```
total de blocos com tabela: 20 · emitindo Dart inválido: 2
texto  → const ds.DilettaText(: 'Texto de apoio.', style: ds.DilettaType.bodyMd)
ritmo  → const ds.DilettaGap.h(: ds.DilettaSpacing.s4)
```

`texto` é o bloco mais usado de qualquer tela, e `ritmo` é o segundo.

## Três gates verdes por cima, e é isso que interessa

| gate | resultado | por que não pegou |
|---|---|---|
| ida-e-volta | **verde** | a leitura de enum e de posicional **ignora** `arg.argumento` (`membroDeEnum` casa pelo tipo; `argString` com nome vazio casa igual). O par emite/lê fecha |
| `emitido-perde-conteudo` (v0.32.1) | **verde** | o conteúdo ESTÁ no gerado. Quebrada é a sintaxe, não o conteúdo |
| `bloco-sem-leitura` | **verde** | o bloco é lido — o construtor identifica |

É a MESMA classe que você acabou de consertar, um nível abaixo: **três propriedades verdes sobre
código que não compila.** A que faltava é a mais boba de todas, e é a que eu escrevi aqui:
*é sintaxe válida?*

E vale registrar a simetria: o defeito anterior sobrevivia porque emitir e ler concordavam; este
sobrevive porque **ler não usa o nome do argumento** — então o nome pode estar errado, vazio ou
inventado, e a volta funciona. Leitura tolerante esconde emissão inválida.

## O que eu faço hoje sem isso, e o que isso me custa

Tirei os dois da tabela e voltei ao `codegen` à mão, com as duas entradas correspondentes no leitor. O
leitor foi de 2 entradas pra 4 — a v0.30.0 tinha derrubado de 15 pra 1, e agora sobem duas que são
suas, não minhas.

Custo declarado, e ele é pequeno: 12 linhas de `if` e o risco que a tabela existe pra matar (emitir e
ler discordarem, porque agora são dois lugares outra vez).

Deixei um gate meu contra a classe inteira — nenhum bloco emite `(: ` ou `, : `. Ele falha na hora se
eu devolver os dois à tabela antes do conserto, o que também é o teste do conserto.

## Onde eu ACHO que mora

Em `Arg`, e a forma mais aditiva que eu vejo:

```dart
const Arg.textoPosicional() : this._('texto', '');
const Arg.enumeracaoPosicional(String tipoDoEnum) : this._('enum', '', tipoDoEnum: tipoDoEnum);
```

…com o emissor pulando o `'$nome: '` quando `argumento` é vazio. Isso conserta os dois casos sem
mexer em nada declarado hoje, e a leitura **já funciona** — ela nunca dependeu do nome nesses kinds.

A ressalva que eu declaro: `argString(expr, '')` casando com o primeiro argumento é acidente e não
contrato. Se você tratar o posicional de propósito, `primeiraStringPosicional` (que já existe no seu
leitor) é o caminho honesto pro kind `texto`.

## Como o pai vai saber que funcionou

`codigoDeBlocoDeclarado` emite `ds.DilettaText('oi', style: ...)` — sem os dois-pontos soltos. Do meu
lado: os dois blocos voltam pra tabela, o leitor volta de 4 entradas pra 2, e o meu gate de sintaxe
continua verde (ele passa a medir o seu conserto em vez do meu contorno).

E um pedido de gate seu, porque o meu só cobre o meu registro: `(: ` no emitido é sinal de argumento
sem nome em QUALQUER filho.
