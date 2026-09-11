# A instância WEB do DS do Conta BOLD

Não é um design system paralelo, e não reimplementa componente nenhum. São **os custom elements do
avô** com **a tinta deste produto** — a mesma peça, a nossa cor.

O mecanismo é o mesmo que o Flutter usa há meses: o filho declara uma paleta e recebe os ~59 papéis
derivados. Aqui os papéis viajam como `--cps-*`, e variável CSS **se sobrescreve**. Trocar a cor não
pede fork, pede uma folha depois.

## Como adotar

**1 · As folhas, nesta ordem.** A ordem é a única pegadinha:

```html
<link rel="stylesheet" href=".../diletta-design-system-web/tokens/cps-tokens.css">
<link rel="stylesheet" href=".../diletta-design-system-web/tokens/cps-papeis.css">
<link rel="stylesheet" href=".../coreflow-design-system-web/tokens/bold-papeis.css">
```

As duas primeiras são do avô: primitivas e papéis na tinta de REFERÊNCIA. A terceira é a nossa, e
declara os mesmos nomes com os valores do Bold. **Fora de ordem, a referência ganha e a tela sai
verde** — sem um erro no console.

**2 · As peças.** Um import registra as 25:

```js
import 'coreflow-design-system-web';
```

**3 · Usar.** São custom elements: HTML normal, em qualquer framework ou em nenhum.

```html
<diletta-button type="primary" size="md" rotulo="Pagar"></diletta-button>
<diletta-status-tag tone="success" label="Aprovado"></diletta-status-tag>
```

Rótulo é **atributo**, não conteúdo. `exemplo/index.html` mostra as peças nos dois modos.

## De onde vem a nossa folha

De `BoldPalette.bold`, pela derivação **do avô** (`dilettaCorDoPapelGen`), emitida por
`coreflow_design_system/test/emite_o_css_do_bold.dart`:

```
flutter test test/emite_o_css_do_bold.dart     # reemite, dentro de packages/coreflow_design_system
```

**Nenhum hex é digitado**, e `o_css_do_bold_esta_em_dia_test.dart` roda na suíte comparando o arquivo
com a fonte, byte a byte. Papel novo no avô, degrau trocado na rampa, derivação alterada um andar
acima: tudo cai ali.

> Esse gate existe porque o Internet Banking mostrou o que acontece sem ele — 195 tokens transcritos
> à mão e zero gates ligando-os à fonte, e ninguém com como responder *"isto ainda é a nossa cor?"*.

## O que este pacote AINDA não tem

- **os 59 componentes `Coreflow*`** (saldo, cartão da conta, extrato) só existem em Flutter. Os 25 do
  avô são a camada de baixo — botão, campo, avatar, tabela. Quais dos 59 escrever é decisão por
  DEMANDA (`ADR-007`, fase 4), e a demanda se mede no produto que for adotar;
- **o `BoldSeloQuantico`**, único componente próprio deste DS, que é painter e não atravessou.

## Como ele sai daqui

Ainda não sai. O `npm` não tem o `path:` do `pub`, então subpasta de monorepo não se instala — é o
mesmo muro que o pedido de 11/09 derrubou um andar acima, e a resposta do avô foi **tag órfã**
(`tool/espelha_o_web.sh`, no repo dele). O mesmo padrão serve aqui quando um produto for consumir.
