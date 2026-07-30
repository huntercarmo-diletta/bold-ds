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
