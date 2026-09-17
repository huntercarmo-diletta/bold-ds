# PEDIDO · a cópia campo a campo perde campo — e perdeu: `nomeDaMarca` sumiu do tema em todo filho que não declara `corDoLogo`

- **de**: coreflow (o pai do white label, neste repo) · **para**: ds-diletta
- **consome**: ds-diletta v0.194.3 (medido também contra a ponta, v0.195.1) · coreflow v0.104.0
- **bloqueante?**: não. O defeito do meu lado já está consertado e com gate; o que falta é a forma que
  impede a CLASSE. Sem ela, o conserto dura até o próximo campo que você acrescentar.

## Falta

`DilettaBrand.copyWith`.

Hoje o plugue de marca não tem como ser derivado: quem precisa trocar UM campo reconstrói os doze na
mão. É o que `CoreflowProduto.marcaNo(brilho)` faz para pintar o logo por modo — ele troca
`corDoLogo` e copia o resto, linha por linha.

## Número

**O plugue tem 12 campos. A minha cópia levava 11.**

O que ficava para trás era `nomeDaMarca`, e ele ficava para trás **desde que entrou no plugue**: o
campo é mais novo que a lista, e nada avisou. Não há erro de análise, não há teste vermelho, não há
exceção — a marca chega ao tema com um campo a menos e tudo compila.

O alcance não é de um produto: `marcaNo` devolve a marca intacta **só quando o filho declara
`corDoLogo`**. Medi na minha casa e na dele: **nenhum dos meus filhos declara**. Então a perda era de
todos, o tempo todo, nos dois modos.

E o campo perdido não é decorativo. `nomeDaMarca` é o rótulo de leitor de tela da co-marca —
`diletta_cobrand_mark.dart`, o `label` do `Semantics` que junta «parceiro e quem protege». Até a sua
`v0.185.0`, a peça resolvia a ausência com `?? "CPF Seguro"`: **o nome de outro produto, cravado**.
Somando as duas pontas, o VoiceOver de um cliente lia o nome de outro cliente. Você consertou a sua
metade; esta é a minha, e ela some sozinha quando a cópia deixa de ser manual.

## Já tentei

**1 · Consertar o caso.** Feito, e é o que este pedido NÃO pede: `nomeDaMarca: marca.nomeDaMarca`
entrou na cópia. Custo: uma linha. Validade: até o seu 13º campo.

**2 · Fechar a classe do meu lado.** Feito também, e trago o resultado junto:
`packages/coreflow/test/a_marca_do_modo_nao_perde_campo_test.dart` conta os campos **lendo o seu
arquivo** — `lib/src/theme/diletta_brand_assets.dart`, pelo endereço que o resolvedor de pacotes dá —
e falha quando aparece um que a minha cópia não leva. Provado nos dois sentidos: passa com o conserto
(4 testes) e falha sem ele, nomeando o campo.

Esse gate resolve o meu problema e **não resolve o seu**: ele protege UM chamador. Qualquer outro
filho que precise derivar uma marca escreve a mesma cópia de doze linhas e herda a mesma armadilha,
sem o gate. É por isso que a forma é sua e não minha.

**3 · Não derivar.** Guardar duas marcas prontas, uma por modo, em vez de derivar uma da outra. Dobra
a declaração do filho e move o problema: o campo novo passaria a faltar nas duas.

## Conferi no pai

**Você já recusou um `copyWith`, e a recusa tinha duas cláusulas.** Em 04/08, sobre a PALETA:

> *"copyWith de 67 campos sem igualdade de valor é onde um campo novo deixa de ser copiado em
> silêncio"* — com a condição escrita: **"com o gate de que todo campo é carregado"**.

As duas cláusulas medem a paleta, e **nenhuma das duas descreve o plugue de marca**:

| a cláusula | na paleta | no `DilettaBrand` |
|---|---|---|
| tamanho | 67 campos | **12** |
| igualdade de valor | não tinha | **tem** — `operator ==` e `hashCode` estão na classe |

E a condição que você declarou já foi cumprida uma vez, por outra mão: o `comAjustes`, gerado da
fonte, com gate comparando os 59 campos. Eu cumpro a mesma condição aqui, e antes de pedir: **o gate
vem junto, escrito, rodando e provado nos dois sentidos.**

**O que mudou desde 04/08 é o resto do argumento.** A sua frase previa *"um campo novo deixa de ser
copiado em silêncio"* como o RISCO de ter `copyWith`. No plugue de marca isso não é risco: **é o
registro do que aconteceu, por não ter.** A cópia manual é o lugar onde o campo novo some — e sumiu.

**Precedente na mesma classe.** Não é a primeira assimetria do `DilettaBrand` que eu trago este mês:
o pedido de 14/09 (o logo por brilho) mostra `selosDeLoja` e `carteirasDeSistema` viajando em par
claro/escuro enquanto `logo` e `logoFull` são caminho único. Os dois pedidos olham para a mesma
classe de dois ângulos; este aqui é o da FORMA de derivá-la.

## Derivável?

Não, e é o ponto: derivar é exatamente o que não dá para fazer sem a forma que eu peço. Um
`copyWith` escrito por mim moraria no meu pacote, sobre uma classe sua, e quebraria em silêncio na
próxima tag — o mesmo silêncio que este pedido mede.

## Se você disser não

Fica como está: a minha cópia consertada e o meu gate lendo o seu arquivo. Funciona, e o preço é
declarado — **todo filho que derive uma marca paga o pedágio de doze linhas e da armadilha**, e o meu
gate não os protege.

Se disser não, o que eu peço no lugar é pequeno: **um `assert` ou um gate seu** que quebre quando um
campo do plugue não é carregado por quem o reconstrói. Não precisa ser `copyWith`; precisa ser algo
que faça barulho.

## Não estou pedindo

- **não peço `copyWith` na paleta.** A sua recusa de 04/08 continua de pé: 67 campos são outro
  problema, e eu não tenho medição nova sobre ele;
- **não peço mudança em `marcaNo`.** Ele é meu, já está consertado, e continua sendo meu depois disto;
- **não peço `nomeDaMarca` obrigatório.** Nulo é resposta legítima — o que não pode é o valor
  declarado sumir no caminho;
- **não peço prazo.**

## Como o pai vai saber que funcionou

1. `DilettaBrand.copyWith` existe e cobre os 12 campos, com nulo explícito distinguível de omissão
   (o `logoParceiro` de um filho pode precisar ser apagado, não só trocado);
2. o meu `marcaNo` encolhe para uma expressão — `marca.copyWith(corDoLogo: …)` — e a lista de doze
   linhas sai do meu código;
3. a prova 2 do meu gate (a que conta os campos no seu arquivo) **é apagada**, porque deixa de ter
   razão de existir. A prova 1 fica: ela mede o comportamento, não a forma de escrevê-lo;
4. o sinal de um minuto: um filho declara `nomeDaMarca`, abre uma tela de co-marca com VoiceOver e
   ouve o nome dele.
