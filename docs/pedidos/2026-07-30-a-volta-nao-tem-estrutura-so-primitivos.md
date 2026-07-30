# Pedido · a VOLTA não tem estrutura, só primitivos

- **filho**: conta-bold-ds
- **pai**: catalogo-diletta v0.28.0
- **é bloqueante?**: não. Escrevi o meu à mão e funciona — o pedido é sobre o segundo filho que
  vai escrever o mesmo à mão, e sobre o buraco que nenhum dos dois vê

## O que falta

O motor entrega os primitivos de leitura (`ehCtor`, `argString`, `argBool`, `membroDeEnum`…) e
não entrega a ESTRUTURA que os organiza. Então cada filho escreve a própria cadeia de `if`.

## A medição

| filho | entradas no leitor | forma |
|---|---|---|
| este | 15 | cadeia de `if` à mão |
| outro filho (li o repo dele pra medir) | **66** | cadeia de `if` à mão |

O motor não conhece componente do DS, e **não pode** — ele não depende do design system. Isso está
certo e não é o que eu peço. O mapa construtor → bloco é vocabulário, é meu, e o nome do bloco e
das props são escolha minha: `ds.DilettaButton` vira `botao` aqui e viraria outra coisa noutro
filho.

O que se repete não é o vocabulário, é a MECÂNICA:

```dart
if (ehCtor(expr, 'ds.DilettaButton') || ehCtor(expr, 'DilettaButton')) {
  return _mk('botao', {
    'label': argString(expr, 'label') ?? '',
    'larguraTotal': argBool(expr, 'fullWidth') ?? false,
  });
}
```

Cada bloco é a mesma forma: construtor (com e sem prefixo `ds.`), tipo, e uma lista de
`prop ← argumento, com tipo e default`. Oitenta e uma dessas, entre dois filhos, escritas na mão.

### O buraco que a falta de estrutura esconde

**Bloco declarado no registro e ausente no leitor não falha em lugar nenhum.** A tela abre, e ele
vira `cru` — aparece como se alguém tivesse escrito código à mão naquele ponto. Não há erro, não
há aviso, e o sintoma (um bloco cru inesperado) parece decisão de quem montou a tela.

Eu só descobri que os meus 15 estavam completos porque escrevi o gate: percorre o registro,
gera o `codegen` de cada bloco com os defaults, passa pelo leitor e exige o mesmo tipo de volta.
São 12 linhas, achou o meu buraco (zero, felizmente), e **todo filho vai reescrever essas 12
linhas** — ou não vai, e aí não tem gate.

## O que eu faço hoje sem isso, e o que isso me custa

O leitor à mão, com o gate à mão. Custo: 15 entradas hoje, e o produto tem 69 componentes pra
adotar — então a cadeia vai pra perto de 60. Cada componente novo é uma entrada a mais em DOIS
lugares (registro e leitor) sem nada ligando os dois além do gate que eu mesmo escrevi.

## Onde eu ACHO que mora

No motor, como estrutura declarativa em cima dos primitivos que já existem. Algo em que eu
declare a MESMA coisa que já declaro no `BlockDef` — construtor, tipo, e o mapa prop ← argumento —
e o motor faça a varredura, o prefixo `ds.`, o default por tipo de prop e o bloco `cru` de
fallback.

Se for por aí, duas coisas que a medição sugere e a decisão é sua:

- o **gate** vem junto, senão a estrutura organiza o mapa e deixa o buraco aberto;
- talvez isto nem seja um campo novo: o `BlockDef` já declara `props` com `kind`, e o `codegen` já
  sabe qual argumento recebe qual prop. Se a ida já está declarada, a volta pode ser derivada —
  e aí "adicionar componente" volta a ser um lugar só.

A ressalva que o formato pede: eu não sei o custo disso pro motor, e a segunda possibilidade acima
pode ser bem maior do que parece de fora — derivar a volta da ida exige que o `codegen` deixe de
ser uma função livre de string.

## Como o pai vai saber que funcionou

Meu leitor encolhe (15 entradas viram 15 linhas de declaração), o gate sai do meu repo porque vem
do motor, e o teste que hoje é meu (`TODO bloco declarado tem entrada no leitor`) passa a ser da
conformidade. E o número que interessa: adicionar componente volta a mexer em um lugar, não dois.
