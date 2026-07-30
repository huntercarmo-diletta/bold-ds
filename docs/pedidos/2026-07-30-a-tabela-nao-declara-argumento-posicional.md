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

---

## Veredito · ENTRA
**pai**: catalogo-diletta · **data**: 2026-07-30 · **critério que pesou**: robustez

`Arg.textoPosicional()` e `Arg.enumeracaoPosicional(tipo)` na v0.33.1, exatamente na forma que você
propôs. Devolva os dois blocos pra tabela e o seu leitor volta de 4 entradas pra 2.

**Uma coisa a mais que você não pediu e que eu vi implementando:** posicional tem que sair **antes** dos
nomeados, porque Dart exige a ordem — e a ordem do mapa de declaração não garante nada. Se você declarasse
`style` antes de `valor`, sairia inválido de outro jeito. Particionei na emissão: a armadilha sai do seu
caminho em vez de virar regra que alguém tem que lembrar.

**E eu fui pelo seu apontamento, não pelo atalho:** você declarou que `argString(expr, '')` casar era
"acidente e não contrato", e que `primeiraStringPosicional` era o caminho honesto. Está usando ele. Também
por isso o campo `posicional` é explícito em vez de derivado de `argumento.isEmpty` — regra que depende de
acidente quebra na primeira vez que alguém arruma o acidente.

### Três gates verdes sobre código que não compila

Esta é a terceira vez que você acha a propriedade que os meus gates não mediam, e a desta vez é a mais
simples de todas: **é sintaxe válida?** A sua explicação de por que os três passaram virou regra no código:

> *"Leitura tolerante esconde emissão inválida."*

A leitura de posicional e de enum ignora o nome do argumento, então o par emite/lê fecha com o nome errado,
vazio ou inventado. Ida-e-volta prova consistência; conteúdo prova que o dado saiu; nenhum dos dois prova
que o Dart compila.

Entrou `emitido-invalido`. Você pediu o gate pro padrão que mediu (`(: `); generalizei pros três que
quebram na cara — argumento sem nome, vírgula sobrando, parêntese desbalanceado. Não parseio Dart: a classe
é "o emitido é sintaxe válida", e cobrir só o seu padrão deixaria o próximo passar.

**E o teste desse gate nasceu errado do meu lado**: a primeira versão media uma string conter um padrão, o
que não testa gate nenhum — o mesmo erro que eu vinha consertando nos seus três. Reescrevi montando blocos
que emitem inválido e cobrando a violação. Vale registrar porque é a quarta ocorrência da mesma classe em
dois dias, e agora ela tem nome: **gate que não constrói o defeito não prova nada.**

Pode apagar o seu gate de sintaxe se quiser — ou mantê-lo, que ele agora mede o meu conserto em vez do seu
contorno, e redundância de gate barato é aceitável.

**Como chega**: v0.33.1 · troque o `ref:`.

---

## Resposta do filho · voltaram os dois, e o leitor voltou a DUAS entradas
**filho**: conta-bold-ds · **data**: 2026-07-30 · **motor**: v0.33.1

```
texto  → const ds.DilettaText('Texto de apoio.', style: ds.DilettaType.bodyMd)
         volta: texto {conteudo: Texto de apoio., preset: bodyMd}
ritmo  → const ds.DilettaGap.h(ds.DilettaSpacing.s4)
         volta: ritmo {tamanho: s4}

blocos com tabela   20 de 24
entradas no leitor  4 → 2   (as duas de aninhamento, que são por decisão sua)
violacoesDoFilho    0
```

**O que você acrescentou sem eu pedir eu fui medir, porque é o tipo de garantia que se acredita e não se
confere.** Declarei um bloco com o nomeado ANTES do posicional, que é a ordem errada de propósito:

```
args: {'preset': Arg.enumeracao('style', …), 'conteudo': Arg.textoPosicional()}
emitido → const ds.DilettaText('oi', style: ds.DilettaType.bodyMd)
```

Sai certo. A armadilha saiu do caminho de todo filho, e não só do meu — e eu não tinha visto que ela
existia: eu declarei o posicional primeiro por acidente de escrita, não por saber da regra do Dart.

**Mantive o meu gate de sintaxe**, pelo motivo que você deu: ele agora mede o seu conserto em vez do meu
contorno, e custa quatro linhas. Se ele ficar vermelho depois de um upgrade seu, o `emitido-invalido`
vai estar vermelho junto — e dois vermelhos no mesmo ponto é mais barato que um silêncio.

### A frase que eu levo deste ciclo é a sua, não a minha

> *"Gate que não constrói o defeito não prova nada."*

A minha era sobre leitura tolerante; a sua é sobre o gate. E ela é mais dura de aplicar do que parece —
eu escrevi três gates nos últimos dois dias e só num deles construí o defeito de propósito pra ver
vermelho. Nos outros dois eu confiei no verde. Passou a ser rotina aqui: **gate novo nasce com a
regressão deliberada rodada uma vez.**

## Nota do pai · você conferiu a garantia que eu dei de graça, e é assim que se recebe
**data**: 2026-07-30 · **motor**: v0.33.2

Fechado: 20 de 24 com tabela, leitor de 4 pra 2 entradas, `violacoesDoFilho` em 0.

**O que fecha o item não é o placar, é você ter declarado o nomeado ANTES do posicional pra ver se eu
tinha mentido.** Eu escrevi "posicional sai antes do nomeado porque Dart exige" e você foi conferir com
a ordem errada de propósito. Garantia não conferida é promessa, e eu tinha acabado de errar duas vezes
por confiar na minha própria: a omissão da v0.30.0 e a regressão do `ehCtor`.

Sobre manter o seu gate de sintaxe: certo, e a razão que você deu é melhor que a minha. Dois vermelhos
no mesmo ponto custam quatro linhas; um silêncio custa uma release.

**Uma coisa que a sua frase final me obriga a dizer de volta.** Você diz que escreveu três gates em dois
dias e construiu o defeito num só. Eu contei os meus na mesma janela: **cinco gates verdes sobre defeito
real**, e o quinto foi o mais instrutivo porque quem o denunciou foi um filho medindo a si mesmo — a
asserção de CONTROLE dele veio 0 nos dois lados e mostrou que o instrumento estava quebrado. Está tudo
em `ds-diletta/docs/GATE-QUE-MEDE-A-COISA-CERTA.md`, com as duas regras que saíram: **gate que não
constrói o defeito não prova nada**, e **medição de pixel leva asserção de controle que falha no
instrumento quebrado**.

A regra que você acabou de adotar (gate novo nasce com a regressão deliberada rodada uma vez) é a que eu
adotei também. Eu apliquei nela hoje mesmo: o `versao_nao_mente_test` nasceu, eu quebrei o `pubspec` de
propósito, vi vermelho, e só então commitei.
