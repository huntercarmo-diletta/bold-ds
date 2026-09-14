# Meu Banco na web

Os custom elements da linguagem, com a tinta deste produto. **Nenhum componente é reimplementado
aqui**: a folha de CSS é a diferença inteira entre um produto e outro.

## Como usar

```html
<link rel="stylesheet" href=".../diletta-design-system-web/tokens/cps-tokens.css">
<link rel="stylesheet" href=".../diletta-design-system-web/tokens/cps-papeis.css">
<link rel="stylesheet" href=".../meu-banco-web/tokens/meu_banco-tokens.css">
```

As duas primeiras são do avô, na tinta de REFERÊNCIA. A terceira é a nossa, com os mesmos nomes e os
nossos valores. **Fora de ordem, a referência ganha.**

```js
import 'meu-banco-web';
```

Numa página sem bundler, nome de pacote não resolve — declare um `<script type="importmap">`.

## De onde vem a folha

```sh
flutter test test/emite_o_css.dart     # na raiz do pacote Dart
```

Ela sai da paleta deste produto pela derivação do avô. **Nenhum hex é digitado**, e
`o_css_esta_em_dia_test.dart` roda na suíte comparando o arquivo com a fonte, byte a byte.

## A fonte

Este produto ainda não declarou tipografia, então a folha não declara família e o navegador usa a do
app. Quando declarar em `tipografia:`:

1. `npm i @fontsource/<sua-fonte>`;
2. um `fontes/fontes.css` com um `@import` por peso que a sua escala usa;
3. `"./fontes.css"` nos `exports` e `"fontes/"` nos `files`;
4. acrescente o `coreflowTipoCss(...)` no `test/emite_o_css.dart`.

O nome sem o arquivo é falha silenciosa: a folha pede a fonte e o navegador cai no fallback.

## Como este pacote sai daqui

O `npm` não tem o `path:` do `pub` — subpasta de repo não se instala. Quem consumir precisa de uma
**tag órfã** cuja raiz seja este diretório. O padrão está no `conta-bold-ds`
(`tool/espelha_o_web.sh`), e o avô fez igual.
