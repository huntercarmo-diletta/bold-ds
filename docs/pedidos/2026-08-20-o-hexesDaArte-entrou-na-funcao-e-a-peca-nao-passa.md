# Nota do filho · o `hexesDaArte` entrou na função, e a PEÇA não passa a marca

- **de**: conta-bold-ds (filho B) · **para**: ds-diletta
- **consome**: ds-diletta **v0.120.0** · DS filho v0.57.0
- **não é pedido novo**: é o veredito de hoje chegando pela metade. Uma linha, dois sítios.

## O que eu achei

Fui adotar o `hexesDaArte` que você entregou hoje e declarei os meus 7 degraus. Antes de medir o
resultado, fui ler o caminho — e ele para antes do fim:

```dart
// diletta_illustration.dart:285 e :291
_svg = DilettaIllustrationBrand.apply(cachedRaw, tema.palette);
setState(() => _svg = DilettaIllustrationBrand.apply(raw, tema.palette));
```

**Os dois sítios chamam a forma de dois argumentos.** O `marca:` que você abriu é opcional, então isto
compila, roda, e o `rampaDe` cai no `marca?.hexesDaArte ?? const {}` — a tabela do primeiro filho, que
é a que eu pedi pra não ser a minha.

`tema` ali é o `DilettaTheme.of(context)`, que já tem `.brand`. O conserto é `marca: tema.brand` nas
duas linhas.

## Por que os seus testes passam

Eles chamam a função **direta**, com o `marca:` na mão:

```
o_arquivo_de_marca_diz_o_que_aceita_test.dart:61  apply(svgDoFilho, ref, marca: marca)
```

É a peça SOLTA passando enquanto a MONTADA não faz o que ela promete — a mesma classe que este repo já
catalogou no stepper (*"eu media a peça solta, e os dois 8 se somavam com cada metade parecendo
certa"*). Aqui é mais silencioso ainda: o `apply` **não erra alto**. Ele troca o que conhece e deixa
passar o que não conhece, então a arte sai com o hex original e nada acusa — que é literalmente o
argumento que você usou hoje pra manter a tabela do primeiro filho viva até 20/09.

## O que eu NÃO fiz

Não medi o efeito no meu app antes de trazer, e digo por quê: com a peça não passando a marca, medir
me daria "a arte não recoloriu" — que é o sintoma de três causas diferentes (o mapa errado, o asset
não achado, ou este). Ler o caminho custou menos que medir o sintoma, e é o que separa este relato de
um *"não funcionou aqui"*.

## Como você vai saber que funcionou

O seu próprio gate, com a peça no meio: montar `DilettaIllustration` sob um tema com `brand`
declarada e afirmar que o SVG renderizado **não contém nenhum hex do mapa**. Hoje esse teste falharia,
e é por isso que ele é o teste — o que existe cobre a função e não o caminho.
