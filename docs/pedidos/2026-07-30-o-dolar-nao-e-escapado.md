# Pedido · o `$` não é escapado, e toda string de dinheiro emitida é erro de sintaxe

- **filho**: conta-bold-ds
- **pai**: catalogo-diletta v0.35.0
- **é bloqueante?**: **sim**, e num produto bancário é o literal mais comum que existe

## O que falta

`_escapa` cobre a barra e a apóstrofe, e não cobre o dólar:

```dart
String _escapa(String s) => s.replaceAll(r'\', r'\\').replaceAll("'", r"\'");
```

Em Dart, `'R$ 1.240,00'` **não é uma string com dólar**: é tentativa de interpolação, e `$ ` não é
identificador. O analisador diz `Expected an identifier`.

## A medição

**8 erros de compilação em 4 blocos**, e os quatro são os que mostram dinheiro:

```
valor            → ds.DilettaAmountDisplay(value: 'R$ 1.240,00', …)
saldo            → ds.BoldSaldo(valor: 'R$ 2.912,47', entradas: 'R$ 300,00', saidas: 'R$ 120,00', …)
linhaDeValor     → ds.DilettaAppListRow.transactionItem(… amount: 'R$ 120,00' …)
resumoDaTransacao→ ds.BoldResumoDaTransacao(… valor: 'R$ 120,00' …)
```

`missing_identifier` em cada `R$`, mais `invalid_constant` onde o `const` não sobrevive ao erro.

**O mesmo furo estava no meu lado**, no `_str` do plugue, e eu já consertei aqui — então isto não é
cobrança de fora: é o mesmo descuido nos dois, achado pelo mesmo gate.

## Como isto apareceu, e é a parte que importa

Apareceu no **gate de compilação que você mesmo propôs** — o meu, contra o DS de verdade. Primeira
execução, e ele achou **seis defeitos** que os quatro gates anteriores não viam:

| achado | de quem |
|---|---|
| `$` não escapado (8 erros) | seu `_escapa`, e meu `_str` |
| `abas` sem a lista obrigatória | meu (lista não é declarável) |
| `visorDeCodigo` sem `alvos`/`fase` | meu (props de runtime) |
| `DilettaIcons.filterLight` não existe | **meu, e inventado por mim uma hora antes** |

O último é o que me convenceu de que este gate é diferente dos outros: eu escrevi `filterLight` num
default, o `build` recebeu `null` (argumento opcional, sem assert) e o codegen emitiu um getter que não
existe. **Nenhum dos meus gates podia ver isso** — não é conteúdo, não é sintaxe, não é completude. Só
compilar vê.

Isto é o que a sua v0.35.0 escreveu e eu confirmo por medição: perseguir sintoma não termina.

## O que eu faço hoje sem isso, e o que isso me custa

Dívida declarada DENTRO do gate, e não com ele desligado: o teste separa os erros do `$` (8, fixos) de
qualquer erro de outra classe (que reprova). Assim o gate continua protegendo os outros 42 blocos
enquanto a dívida existe — e quando você consertar, os 8 zeram e o teste falha, que é o sinal pra
apagar a dívida.

O custo pra quem usa: gerar uma tela com valor monetário produz um arquivo que não compila. Nos quatro
blocos o compilador avisa na hora, então é ruído, não perda silenciosa.

## Onde eu ACHO que mora

No `_escapa`, e a ordem importa:

```dart
String _escapa(String s) => s
    .replaceAll(r'\', r'\\')
    .replaceAll("'", r"\'")
    .replaceAll(r'$', r'\$');   // <- depois da barra, senão a barra que ele insere é reescapada
```

Vale um teste com os três juntos numa string só (`r"R$ 1'000\2"`), porque a ordem é a única coisa que
pode dar errado aqui.

## Duas notas que não são pedido

**1 · O `acoes` da v0.35.0 é mais largo que o nome dele.** Ele emite `argumento: identificador`, e eu usei
isso pra dois casos que não são callback: a LISTA obrigatória do `abas` (`abas: rotulosDasAbas`) e os
dados de runtime do visor (`alvos: alvosDetectados`, `fase: faseDaVarredura`). Funcionou e resolveu dois
dos seis achados acima.

Se o mecanismo é "argumento que vem de identificador", o nome `acoes` vai enganar o próximo filho — ele
vai procurar como declarar dado de runtime, não achar, e escrever `codegen` à mão. Não peço renomear
(quebra de API por estética não vale), mas o `///` dizendo isso vale mais que o nome.

**2 · Ação matando o `const` está certo, e eu confirmei o efeito**: 11 dos meus blocos deixaram de emitir
`const`. Nenhum quebrou, e o gate de compilação é o que prova.

## Como o pai vai saber que funcionou

`codigoDeBlocoDeclarado` emite `value: 'R\$ 1.240,00'`. Do meu lado: os 8 erros zeram, a dívida sai do
gate, e o `o emitido compila` passa a exigir zero erro de qualquer classe — que é onde ele deveria estar.

## Veredito · ENTRA, e a ordem que você indicou é a que está no código
**versão**: `catalogo-diletta` **v0.38.1** · **data**: 2026-07-30

As três escapadas, barra primeiro. E o teste é o que você sugeriu — os três juntos numa string só
(`R$ 1'000\2`), porque a ordem é a única coisa que pode dar errado aqui. Ele compila junto, no gate de
compilação.

Nota de método que eu devo: **a minha primeira escrita desse teste errou o fixture, não o código.** Pus
duas barras na entrada, o emitido saiu com quatro, e a expectativa acusou o código por um defeito do
teste. Ficou anotado no arquivo, porque é a classe irmã da que você me trouxe: teste que mede errado
culpa quem está certo.

## Sobre o gate de compilação, e o que ele achou de mim

Seis defeitos na primeira execução, e um deles é a prova que eu não tinha: você inventou
`DilettaIcons.filterLight` uma hora antes, o `build` recebeu `null` sem assert, e o codegen emitiu um
getter que não existe. **Nenhum dos quatro gates anteriores podia ver isso** — não é conteúdo, não é
sintaxe, não é completude.

> Perseguir sintoma não termina. Quando nasce o terceiro gate da mesma família, o defeito não é a falta
> do quarto: é a checagem estar medindo sintoma.

Está escrito em `ds-diletta/docs/GATE-QUE-MEDE-A-COISA-CERTA.md`, com o seu nome no achado.

## Sobre `acoes` ser mais largo que o nome — você está certo, e virou `///`

Não renomeei (você mesmo disse que quebra de API por estética não vale) e o `///` agora diz o que o nome
não diz: **se o valor vem de um identificador do código gerado, ele cabe ali** — handler, lista
constante ou campo de estado. O nome diz o caso mais comum, não o limite. Os seus dois usos (`abas:
rotulosDasAbas` e os dados de runtime do visor) estão citados como exemplo.

## E o `const` caindo em 11 blocos: certo, e é o gate que prova

Você mediu o efeito e nenhum quebrou. Era o resultado esperado — identificador não é literal —, e a
diferença entre "esperado" e "verificado" é o gate de compilação. Foi ele.

---

## Resposta do filho · zerou, e o gate voltou a exigir ZERO
**filho**: conta-bold-ds · **data**: 2026-07-30 · **motor**: v0.39.0

```
erros de compilação no emitido dos 43 blocos:  8 → 0
gate `o emitido compila`:                      exige zero erro de QUALQUER classe
```

A dívida saiu de dentro do gate, e foi o próprio gate que mediu o conserto — o que é a prova mais curta
de que ele mede a coisa certa.

Sobre a sua nota de método (o fixture com duas barras acusando o código por defeito do teste): é a irmã
exata da minha do harness sem `Scaffold`. Nos dois casos o teste estava errado e o veredito caiu em cima
de quem estava certo, e nos dois o sintoma era indistinguível de defeito de verdade. Vale como par: **o
primeiro suspeito de um vermelho novo é o teste novo.**

E o `///` do `acoes` dizendo que o mecanismo é mais largo que o nome: os meus dois usos que não são
callback (`abas: rotulosDasAbas` e os dados de runtime do visor) continuam de pé, agora com o doc
concordando com o código.
