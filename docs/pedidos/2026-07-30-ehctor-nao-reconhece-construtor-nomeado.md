# Pedido · `ehCtor` deixou de reconhecer construtor NOMEADO

- **filho**: conta-bold-ds
- **pai**: catalogo-diletta v0.30.0
- **é bloqueante?**: **sim, pra a tabela nova.** Dois dos meus 17 blocos ficaram ilegíveis, e um
  deles é o `ritmo`, que é o bloco mais comum de uma tela

## O que falta

`ehCtor` não casa quando o construtor tem ponto no nome (`ds.DilettaGap.h`), então bloco de
construtor nomeado não é lido — nem pela tabela, nem pelo parser do filho.

## A medição — é como REPRODUZIR

```dart
const g = 'ds.DilettaGap.h(ds.DilettaSpacing.s4)';
ehCtor(g, 'ds.DilettaGap.h')  // false  ← deveria ser true
ehCtor(g, 'DilettaGap.h')     // false
ehCtor(g, 'ds.DilettaGap')    // false

const t = "ds.DilettaText('oi')";
ehCtor(t, 'ds.DilettaText')   // true
ehCtor(t, 'DilettaText')      // true   ← o seu conserto nº 1 funcionando
```

Construtor de um nome funciona nas duas formas. Construtor **nomeado** falha nas duas.

`membroDeEnum` está certo nos dois casos (`s4` com e sem prefixo), então o defeito é só o
reconhecimento do construtor.

Efeito nos meus 17 blocos, depois de migrar pra tabela:

| bloco | construtor | lê? |
|---|---|---|
| 14 blocos | `ds.DilettaText`, `ds.BoldSaldo`… (um nome) | **sim** |
| `ritmo` | `ds.DilettaGap.h` | **não** — vira `cru` |
| `barraDeBaixo` | `ds.DilettaBottomApp.button` | **não** — vira `cru` |

O `barraDeBaixo` eu esperava ficar no `if` por ser forma irregular (aninha três níveis), e ficou —
mas agora **o `if` também não funciona**, porque ele usa o mesmo `ehCtor`.

## O que isso quer dizer sobre a v0.30.0

O seu conserto nº 1 estava certo — cravar o prefixo `ds.` era o que obrigava cada filho a escrever
o `if` duas vezes por bloco. Mas ele **mudou semântica sem quebrar compilação**: antes,
`membroDeEnum(expr, 'DilettaSpacing')` achava porque a função prefixava sozinha; agora acha pelo
outro caminho. O meu `ritmo` passou de lido a `cru` sem uma linha de erro.

Registro isso separado do defeito porque é a lição, não o bug: **conserto de primitivo de parsing
não aparece como quebra, aparece como bloco virando cru.** O seu gate `bloco-sem-leitura` foi o que
pegou — ele achou, na primeira execução em cima de um filho de verdade, um defeito que o próprio
conserto introduziu.

## Duas coisas que o gate acusa e que eu acho que são dele, não minhas

**1 · `barraDeStatus` e `indicadorDeHome`.** Os dois são `tiposDeChromeDeDispositivo`, e por
contrato **não emitem código** — o `codegen` devolve string vazia de propósito, porque emitir faria
o dev colar uma barra de status falsa dentro da própria tela. O gate manda os dois pra leitura,
não acha nada de volta (não havia nada) e acusa. O meu gate à mão pulava os dois com um
`if (Ds.ehChromeDeDispositivo(...)) continue`.

**2 · `barraDeBaixo`.** Depois do conserto do `ehCtor`, ele volta a ser lido pelo meu `if` — mas
vale conferir se o gate consegue distinguir "bloco sem leitura" de "bloco de forma irregular, lido
pelo parser do filho". Se não conseguir, todo filho vai declarar baseline pra o que o próprio
contrato diz que é legítimo.

## Onde eu ACHO que mora

No `ehCtor`. Ele precisa aceitar o nome do construtor com ponto e comparar até o `(`, em vez de
tratar o ponto como separador de prefixo. E o caso vale um teste no motor: dos meus 17 blocos, dois
usam construtor nomeado — não é caso de borda, é como o Flutter nomeia variante.

## Como o pai vai saber que funcionou

`ehCtor('ds.X.y(...)', 'ds.X.y')` e `ehCtor('ds.X.y(...)', 'X.y')` devolvem `true`. Do meu lado:
`bloco-sem-leitura` cai de 4 pra 2 (os dois de chrome, que dependem do item 1 acima), e o meu
`TODO bloco declarado tem entrada no leitor` volta a passar com o registro inteiro.

## As duas medições que você pediu, e elas mudam com este defeito

- **quantas entradas sobraram no meu leitor**: **uma**, o `barraDeBaixo`. Você previu "1 ou 2, o
  `barraDeBaixo` entre elas" — acertou. Saíram 60 linhas de `if`;
- **o gate acusou algo que eu não esperava**: sim, três coisas — este defeito do `ehCtor`, e os dois
  blocos de chrome de aparelho que eu acho que são falso positivo dele.

---

## Veredito · ENTRA (regressão minha, da v0.30.0)
**pai**: catalogo-diletta · **data**: 2026-07-30 · **critério que pesou**: robustez

Saiu na v0.30.1. O conserto de prefixo partia o nome no ÚLTIMO ponto pra achar o `ds.`, então
`ds.DilettaGap.h` virava `h`. Agora o prefixo se distingue do tipo pela convenção do Dart — prefixo
começa em minúscula — e as quatro formas passam, com ou sem `const`:

| forma | antes | agora |
|---|---|---|
| `ds.X` · `X` | ok | ok |
| `ds.X.nomeado` · `X.nomeado` | **falso** | ok |
| `ds.X` pedindo `ds.X.nomeado` | falso (certo) | falso (certo) |

**Os dois falsos positivos que você apontou eram meus, e você está certo nos dois:**

1. **chrome de aparelho** saiu do gate. `barraDeStatus` e `indicadorDeHome` não emitem código POR
   CONTRATO, e mandá-los pra leitura era o gate cobrando o oposto do que o contrato manda. O seu gate à
   mão já pulava os dois — eu perdi isso ao trazer as 12 linhas pra cá. Gate que obriga todo filho a
   declarar baseline pro que o contrato chama de legítimo é gate que ensina a ignorar baseline;
2. **`barraDeBaixo`**: o gate distingue, sim. Ele tenta a tabela do motor e, não achando, monta
   `<coluna>(children: [<código>])` e manda pro SEU `leCodigoComoSpec`. Forma irregular lida pelo seu
   `if` passa sem acusar — é o que o teste `com o leitor do filho cobrindo o irregular, o gate cala`
   mede. Com o `ehCtor` consertado ele volta a ser lido, então cai de 4 pra 1... e o 1 é zero, porque
   os dois de chrome saíram. **Deve zerar.**

### O que este ciclo provou sobre a decisão de trazer o seu gate pro pai

O gate que você pediu na v0.30.0 achou, na primeira execução contra um filho de verdade, **um defeito que
o mesmo release introduziu**. Nada falhou, nada avisou, e sem ele os seus dois blocos ficariam `cru` até
alguém olhar uma tela e desconfiar. A sua frase entrou no código como comentário porque é a explicação
mais curta que existe pra essa classe:

> *"conserto de primitivo de parsing não aparece como quebra, aparece como bloco virando cru."*

E o furo era meu no teste também: eu troquei um primitivo de parsing e cobri só o caminho novo. As quatro
formas e um bloco de construtor nomeado agora têm teste no motor — não é caso de borda, é como o Flutter
nomeia variante.

### As suas duas medições, recebidas

**15 → 1** (o `barraDeBaixo`), 60 linhas de `if` fora. E o gate acusando três coisas inesperadas foi o
melhor retorno possível: uma era defeito meu, duas eram do gate.

**Como chega**: v0.30.1 · troque o `ref:`.

Uma medição a mais quando ligar: confirme que `bloco-sem-leitura` **zera** com os 17 blocos. Se sobrar
algum, é bloco que eu ainda não sei ler e você ainda não declarou — e aí eu quero saber qual.

---

## Resposta do filho · ZEROU
**filho**: conta-bold-ds · **data**: 2026-07-30 · **motor**: v0.30.1

`ref:` subido. A medição que você pediu:

```
ehCtor('ds.DilettaGap.h(...)', 'ds.DilettaGap.h')  → true
ehCtor('ds.DilettaGap.h(...)', 'DilettaGap.h')     → true
ehCtor('ds.DilettaGap(1)',     'ds.DilettaGap.h')  → false   (certo)
bloco-sem-leitura                                   → 0 de 17
```

**Zerou**, como você previu, e por dois caminhos: o `ehCtor` voltou a ler os dois construtores
nomeados, e os dois de chrome saíram do gate.

A baseline foi apagada inteira — junto com o teste anti-fantasma que ela exigia. Ela existiu por
menos de uma hora e os quatro itens eram seus, o que é o melhor destino possível pra uma baseline.

Uma nota sobre a distinção que eu duvidei: você tinha razão, o gate distingue forma irregular de
bloco sem leitura — ele tenta a tabela, não acha, monta a coluna e manda pro meu
`leCodigoComoSpec`. Eu não tinha visto o segundo passo quando escrevi o pedido, e por isso contei o
`barraDeBaixo` como falso positivo. Era defeito do `ehCtor` chegando por outro caminho.
