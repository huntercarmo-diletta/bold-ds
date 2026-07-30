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

---

## Veredito · ENTRA (defeito meu, e a sua análise é melhor que o meu gate)
**pai**: catalogo-diletta · **data**: 2026-07-30 · **critério que pesou**: robustez

Saiu na v0.32.1. **O critério deixou de ser "igual ao default" e passou a ser "tem conteúdo"**:
argumento com valor sai sempre; só valor vazio ou nulo fica fora, porque `label: ''` é ruído e não há
conteúdo pra apagar ali.

Não fui pela sua proposta por kind (`bool` omite, os outros emitem) por um motivo que é o seu próprio
argumento levado um passo: **o motor não sabe o que é obrigatório no construtor, e isso vale pro `bool`
também.** Um `required bool` quebraria igual. Uma regra é mais simples e mais segura que três, e o custo
— gerado mais verboso — é o que eu escolho pagar contra código que não compila.

E não fui pela declaração de "qual argumento é obrigatório" pela razão que **você** deu: mais uma
declaração pra manter, com ganho de estética. Se algum dia a verbosidade doer de verdade, é esse o
caminho, e ele fica registrado aqui.

### A parte mais importante do seu pedido não era o defeito

> *"O gate não estava frouxo, ele estava medindo a propriedade errada. Ida-e-volta prova que o par
> emite/lê é consistente; não prova que o emitido é código válido."*

Isso está certo e eu não tinha visto. O defeito era **simétrico**: a emissão omitia o default e a leitura
repõe o default antes de aplicar o que achou, então `const ds.X()` voltava como o MESMO bloco. As duas
pontas fechavam perfeitamente em cima de código que não compila — **17 de 17 passando com 14 blocos
gerando erro de compilação.**

Entrou `emitido-perde-conteudo`: pra cada bloco com tabela, todo argumento cujo default tem conteúdo
precisa aparecer no gerado. É ortogonal à ida-e-volta, e a frase virou comentário no código porque é a
explicação mais curta de por que duas checagens que parecem a mesma não são.

**Sobre o teste que você deixou** (`o motor OMITE argumento igual ao default`, fixando a dívida pra ela
não sobreviver ao conserto): pode apagar — ele vai falhar agora, e é isso que você queria que
acontecesse. Foi a decisão certa: dívida declarada em teste é dívida que não vira permanente.

**Como chega**: v0.32.1 · troque o `ref:`. Depois, confira dois números: `bloco-sem-leitura` zerando com
os 17, e `emitido-perde-conteudo` zerando também. Se o segundo acusar algo, é bloco cujo `defaults` tem
conteúdo que o gerador ainda não leva — e aí eu quero ver qual.
