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
