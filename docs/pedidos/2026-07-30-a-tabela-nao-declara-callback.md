# Pedido · a tabela não sabe emitir CALLBACK, e 12 blocos saem sem handler

- **filho**: conta-bold-ds
- **pai**: catalogo-diletta v0.33.1
- **é bloqueante?**: **sim.** Dois blocos emitem código que não compila, e um deles é o `botao` — o
  bloco mais comum de qualquer tela. Os outros dez compilam **inertes**

## O que falta

`Arg` tem quatro kinds — `texto`, `bool`, `numero`, `enum` — e nenhum emite **identificador**. Callback
é identificador:

```dart
ds.DilettaButton(label: 'Continuar', onPressed: aoContinuar)
//                                              ^^^^^^^^^^^ não é literal de nada
```

Então todo bloco de tabela cujo componente recebe um handler sai sem ele.

## A medição

**12 dos 36 blocos com tabela** perdem callback na emissão:

```
botao · saldo · abas · linha · linhaDeValor · botaoDeIcone · interruptor
campoDeBusca · estadoVazio · chipDeEntrada · cartaoDeAcesso · caixaDeSelecao
```

E a gravidade se divide em duas:

| grupo | quantos | o que acontece |
|---|---|---|
| `required` no construtor | **2** | **não compila.** `DilettaButton.onPressed` e `DilettaToggleSwitch.onChanged` são `required` |
| opcional | 10 | compila e fica **inerte**: botão de ícone que não responde, chip que não filtra, busca que não busca |

O segundo grupo é o que me preocupa mais, e é o mesmo argumento que você usou pra recusar a minha
proposta por kind na v0.32.1: **o silencioso é pior que o que quebra.** Código que não compila o dev vê
na hora; tela montada com dez controles mortos parece pronta.

Uma nota de medição que vale como método: contar só a convenção do pai (`on[A-Z]`) dava **10**. Os dois
que faltavam eram blocos nascidos AQUI, que nomeiam handler em português (`aoTrocar`, `aoAbrirExtrato`).
Medir uma convenção só esconderia o defeito justamente na parte que é minha.

## Por que os gates não pegaram — e agora são QUATRO

Nenhum dos gates existentes acusa:

| gate | por que passa |
|---|---|
| ida-e-volta | a leitura não lê callback (não há o que ler num identificador) |
| `emitido-perde-conteudo` | callback não é "conteúdo" de prop: não está em `args` |
| `emitido-invalido` (v0.33.1) | a sintaxe está perfeita; falta um argumento |
| o meu de sintaxe | mesma coisa |

É a **quarta** vez que o emitido está errado com todos os gates verdes, e cada vez a propriedade que
faltava era outra: conteúdo (v0.32.1), sintaxe (v0.33.1), e agora **completude** — o emitido tem todos os
argumentos que o construtor EXIGE?

Isso sugere um gate que fecha a família em vez de um por sintoma: **compilar o emitido.** Um teste que
monta um arquivo com os blocos do registro e roda `dart analyze` nele pegaria os três casos e os que
ninguém pensou. É mais caro que um regex, e é a única checagem que mede a propriedade que interessa —
"o código gerado compila" — em vez de aproximações dela.

## O que eu faço hoje sem isso, e o que isso me custa

Deixo a dívida DECLARADA em teste (`a tabela PERDE o callback`, fixando 12), e **não** desfaço a tabela.

A alternativa seria tirar `ctor` desses 12 e voltar ao `codegen` à mão com 12 entradas no leitor — o que
desfaz a v0.30.0 exatamente onde ela mais rendeu, e cria dois lugares pra manter a mesma correspondência.
Trocar um defeito localizado por uma regressão estrutural é pior negócio, e você consertou os dois
últimos no mesmo dia.

O custo aceito, dito claro: quem gerar tela com esses blocos hoje precisa adicionar o handler à mão. Nos
dois `required` o compilador avisa; nos dez opcionais, não avisa ninguém.

## Onde eu ACHO que mora

Num kind novo, e o nome já existe no seu contrato: `ActionRef`.

```dart
const Arg.acao(String argumento, String nomePadrao);   // emite `onPressed: aoContinuar`
```

Duas coisas que eu declaro como ressalva:

1. **o nome do handler é vocabulário do filho** (`aoContinuar`, `aoTrocar`), então ele vem na declaração,
   como o `tipoDoEnum` já vem;
2. **na LEITURA, ação não volta como prop** — não há o que preencher. O motor pode ignorar o kind na
   volta, e isso não quebra a simetria: a tabela deixa de ser "toda prop tem argumento" e passa a ser
   "todo argumento tem origem", que é o que ela já é pro `bool` omitido.

O `ActionRef` que você já tem cobre o caso escopado a item (`() => onX(e)`) dentro de slot repetível —
então o kind novo tem onde encaixar sem inventar conceito.

## Como o pai vai saber que funcionou

`codigoDeBlocoDeclarado` emite `ds.DilettaButton(label: 'Continuar', onPressed: aoContinuar)`. Do meu
lado: o teste de dívida cai de 12 pra 0 e sai do repo, e os 36 blocos de tabela passam a emitir código
que compila — o que eu quero poder provar com o gate de compilação, não com regex.
