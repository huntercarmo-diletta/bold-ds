# Pedido · a tabela omite todo argumento igual ao default, e o código não compila

- **filho**: conta-bold-ds
- **pai**: catalogo-diletta v0.30.1
- **é bloqueante?**: **sim.** O código gerado de um bloco recém-arrastado não compila, e o gate de
  ida-e-volta não vê

## O que falta

`codigoDeBlocoDeclarado` descarta o argumento quando o valor é igual ao default do bloco:

```dart
if ('$valor' == '${padroes[prop] ?? ''}') return;
```

Pra `bool` isso está certo e está documentado. Pra `texto`, `enum` e `numero` o default **é
conteúdo**, não comportamento — e omiti-lo apaga o conteúdo.

## A medição

Dos meus 16 blocos com tabela, **14 emitem sem argumento nenhum** quando os props estão no default:

```
const ds.DilettaPageTitle()      (args=2)
const ds.DilettaText()           (args=2)
const ds.DilettaButton()         (args=4)
const ds.DilettaInput()          (args=5)
const ds.BoldSaldo()             (args=4)
…14 de 16
```

Com valor diferente do default, sai certo: `const ds.DilettaPageTitle(title: 'Outro')`.

**Duas consequências, e a primeira é fatal:**

1. **não compila.** `DilettaPageTitle` tem `required this.title`; `DilettaText` tem o texto como
   posicional obrigatório. `const ds.DilettaPageTitle()` é erro de compilação na tela do dev — e o
   caminho pra chegar nele é o mais comum do compositor: arrastar o bloco e gerar sem editar o
   texto de exemplo;
2. **o conteúdo desaparece** nos casos em que compila. Quem escreveu na tela exatamente o texto de
   exemplo perde o texto na geração.

## Por que nenhum gate pegou, e isso é o mais importante daqui

O meu `TODO bloco declarado tem entrada no leitor` e o seu `bloco-sem-leitura` **passam os dois**,
com 17 de 17.

O motivo é a simetria do defeito: a leitura preenche os props com `def.defaults()` antes de aplicar
o que achou no código. Então `const ds.DilettaPageTitle()` volta como `tituloDaPagina` com os
defaults — o MESMO bloco que gerou o código. A ida e a volta fecham perfeitamente **em cima de um
código que não compila.**

É o oposto do que a gente costuma achar: aqui o gate não estava frouxo, ele estava medindo a
propriedade errada. Ida-e-volta prova que o par emite/lê é consistente; não prova que o emitido é
código válido.

## O que eu faço hoje sem isso, e o que isso me custa

Nada bom. As três saídas que eu vejo, e nenhuma é minha:

- deixar `defaults` diferente do conteúdo real (`titulo: ''`) — mas aí o bloco nasce vazio no canvas,
  que é o defeito que o `defaults` existe pra evitar;
- voltar os 14 blocos pro `codegen` à mão — desfaz a v0.30.0 inteira;
- editar todo texto de exemplo antes de gerar. Não é conserto, é rotina que alguém vai esquecer.

Fico com o defeito e declarado em teste, que é o menos ruim: o meu
`o motor OMITE argumento igual ao default` fixa o comportamento atual e falha quando você
consertar — pra a dívida não sobreviver ao conserto.

## Onde eu ACHO que mora

Na regra de omissão. Ela deveria valer por KIND e não pra todos:

- `bool`: omitir quando igual ao default (como está, e documentado);
- `texto`, `enum`, `numero`: **emitir sempre**. Se o argumento é opcional no construtor e o valor é
  o default do COMPONENTE, o motor não tem como saber — e o custo de emitir a mais é uma linha
  verbosa; o custo de omitir é código que não compila.

Se você quiser manter a omissão pra opcional, o que falta é o bloco declarar qual argumento é
**obrigatório** no construtor — mas isso é mais uma declaração pra manter, e o ganho é estética de
código gerado.

## Como o pai vai saber que funcionou

`codigoDeBlocoDeclarado(def, def.defaults())` emite os argumentos, e o gerado de todo bloco COMPILA
com os defaults. E o gate de ida-e-volta ganha um par: além de "volta como o mesmo tipo", "o emitido
contém o conteúdo" — porque foi essa a propriedade que faltava medir.
