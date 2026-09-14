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
<link rel="stylesheet" href=".../coreflow-design-system-web/tokens/bold-tokens.css">
```

As duas primeiras são do avô: primitivas e papéis na tinta de REFERÊNCIA. A terceira é a nossa, e
declara os mesmos nomes com os valores do Bold. **Fora de ordem, a referência ganha e a tela sai
verde** — sem um erro no console.

**1b · A fonte.** O pacote emite `--cps-font-family` (hoje **Inter**), e os custom elements do avô
**não declaram fonte nenhuma** — herdam de quem hospeda. Então quem adota aplica no `body`:

```css
body { font-family: var(--cps-font-family); }
```

⚠️ **O pacote emite o NOME, não o arquivo.** O DS empacota a Inter em `.ttf` para o Flutter; um
produto web precisa hospedar os `.woff2` e declarar os `@font-face`. Sem isso a folha pede Inter e o
navegador cai no fallback — que é o mesmo defeito silencioso das variáveis sem valor.

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

**4 · Se a página não tiver bundler, precisa de import map.** `import 'coreflow-design-system-web'`
é um especificador NU: o Vite do IB resolve, o navegador cru não — ele exige caminho começando com
`/`, `./` ou `../`, e sem isso a página morre com `Failed to resolve module specifier` (medido em
11/09). A saída é declarar o mapa:

```html
<script type="importmap">
{ "imports": {
    "diletta-design-system-web": "/node_modules/diletta-design-system-web/index.js",
    "coreflow-design-system-web": "/node_modules/coreflow-design-system-web/index.js" } }
</script>
```

`catalogo/index.html` faz exatamente isso, e é o exemplo vivo.

## O catálogo

```
catalogo/index.html
```

As 25 peças, no produto cartesiano dos eixos que **o avô declara** (`blocos.js` dele, importado e não
copiado — bloco novo na tag dele aparece aqui sozinho). Dois botões:

- **modo** claro/escuro, pelo `data-theme`;
- **marca**, e ele é uma linha de código: liga e desliga a nossa folha. Desligada, a peça volta pra
  tinta de referência do avô. É o white label visível, sem trocar um componente — o gêmeo do seletor
  de marca do catálogo Flutter.

## O que a folha declara

| família | quantas | de onde |
|---|---|---|
| papéis de cor da linguagem | 57 | `DilettaScheme` do avô, com a rampa do Bold |
| papéis do esquema do produto | 9 | `CoreflowScheme` — o que o avô não tem |
| raio por nome | 4 | `CoreflowRadius` |
| escala de tipo | 20 degraus | `CoreflowType` — seis têm px que o avô não tem |
| espaço, elevação, duração, breakpoint | — | já vêm nas folhas do avô |

**282 declarações**, nenhuma digitada.

Dois nomes aparecem duas vezes de propósito — `primary` e `border`: o esquema do produto ganha do
papel genérico da linguagem, e é isso que faz o white label acontecer na cascata. Um gate reprova a
terceira colisão que aparecer sem ser declarada.

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
