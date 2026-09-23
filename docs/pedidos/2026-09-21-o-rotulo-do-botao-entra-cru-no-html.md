# PEDIDO · O rótulo entra CRU no `innerHTML` — e são 11 peças, não uma

- **de**: conta-bold-ds (filho B) · **para**: ds-diletta
- **consome**: ds-diletta `v0.207.0` · `web-v0.207.0`, pela tag `web-v0.114.0` deste repo
- **bloqueante?**: **sim, e é o único que eu classifico como segurança.** A adoção do
  `<diletta-button>` no Internet Banking está com remendo do nosso lado para poder subir.
- **não é peça nova**, então a regra do `busca()` não se aplica.

## Falta

O valor de atributo é interpolado no texto que vira `shadowRoot.innerHTML`, sem escapar.

```js
// diletta-button.js — na cópia instalada, linhas 121-122 e 137
const conteudo = `<slot name="lead"></slot><span class="rotulo">${
  this.getAttribute('rotulo') || ''}</span>…`;
…
this.shadowRoot.innerHTML = `…${conteudo}…`;
```

Valor cru em `innerHTML` não é estilo: é execução.

## Número

**Provado no navegador**, com o pacote instalado pela tag, sem passar por embrulho nenhum:

```js
const el = document.createElement('diletta-button');
el.setAttribute('rotulo', '<img src=x onerror="window.__PROVA=1">Remover');
document.body.appendChild(el);

// window.__PROVA        → 1        ← o código ROdou
// el.shadowRoot.querySelector('img') → <img>  ← o nó nasceu dentro do shadow
```

E **não é uma peça**:

```
peças que interpolam atributo em texto que vira innerHTML:  11 de 32
```

`breadcrumb · button · data-cell · data-list · file-card · rail-item · tab-item · tooltip ·
web-stepper-node · web-top-bar · data-row`

**O `rotulo-acessivel` não tem o problema**, e é o contraste que mostra onde está a diferença: ele
vira VALOR DE ATRIBUTO (`aria-label`), e valor de atributo é texto por construção. O mesmo dado,
dois caminhos, uma garantia.

## Onde isso dói

A troca do `<button>` pelo elemento **removeu uma garantia que existia**. Antes, o texto viajava
como filho do React, escapado por construção — não por cuidado de quem escreveu a chamada, mas
porque não havia outro jeito. Depois da troca ele viaja como atributo cru, em **175 chamadas de uma
vez**, e **30 delas interpolam dado**:

```jsx
<BoldButton aria-label={`Remover ${rotuloMetodo(m)}`}>Remover</BoldButton>
// rotuloMetodo → `Pix · ${m.chavePix}` | `TED · ${m.banco.nome} …`
```

São nome de beneficiário, chave Pix, nome de banco, nome de contraparte — campos que, em banco,
muitas vezes a pessoa digita.

**Se um payload real chega até aí hoje depende da validação do servidor, e isso eu NÃO confirmei.**
Digo em vez de afirmar. O que eu afirmo é o que medi: a garantia que existia foi removida, e nada
ocupou o lugar dela.

## O que eu proponho

`textContent` no lugar da interpolação para os trechos que são TEXTO do consumidor — ou, se a forma
do `render` não comportar, escapar antes de interpolar. Numa função, na `base.js`, como o
`mudouAtributo`: são 11 peças e um defeito de forma.

**A armadilha que eu vejo**: nem toda interpolação é texto do consumidor. Há valores que a própria
peça computa e que PRECISAM ser marcação. Escapar tudo às cegas quebraria essas. A separação é entre
«o que veio de fora» e «o que a peça escreveu», e quem sabe qual é qual é você.

## O que fizemos enquanto isso, e como ele morre

O `BoldButton` escapa `&`, `<` e `>` antes de escrever o atributo. Funciona e não custa a tela:
`&lt;` interpolado em `innerHTML` volta a ser `<` ao desenhar — medido no navegador, o texto que a
pessoa lê é o que a chamada escreveu, e a carga não executa.

É **remendo com prazo**, e o prazo é o seu veredito. Quando a peça escapar, o nosso vira escape
duplo e a tela mostra `&lt;` literal. Quem avisa é um gate que pergunta ao elemento INSTALADO se ele
ainda é cru — quando deixar de ser, ele reprova pedindo a remoção do remendo.

## Critérios que eu acho que decidem

**segurança · robustez.** Segurança porque é execução de código a partir de dado, em produto
bancário. Robustez porque a forma se repete em 11 peças e o conserto é de uma função.

## Nota do filho · o caminho de ATRIBUTO também quebra — e «onze sítios» cobre dez das vinte e uma peças que vazam

> 22/09/2026, depois do veredito. Achado no **core-flow-wa**, que embrulha sete destas peças.
> Não reabre o veredito: ENTRA continua certo. Precisa o que a v0.208.0 tem de cobrir.

### A premissa do desenho não vale em cinco peças

O veredito toma como desenho da correção a frase deste pedido: *«o `rotulo-acessivel` não tem o
problema porque vira VALOR DE ATRIBUTO, e valor de atributo é texto por construção»* — e daí a
separação «o que veio de fora» × «o que a peça escreveu», **uma função, onze sítios**.

A frase está certa **no botão**, e só lá: o `<diletta-button>` faz `replace(/"/g, '&quot;')`
antes de montar o `aria-label`. Em outras peças o valor de fora entra num atributo **sem** esse
passo, e aí a aspa fecha o atributo e o que vem depois vira **manipulador de evento de verdade**
no shadow. Medido com o pacote instalado pela tag, conferido com `getAttribute`:

```
diletta-avatar        foto     →  img[onmouseover]
diletta-breadcrumb    rotulo   →  nav[onmouseover]
diletta-file-card     foto     →  img[onmouseover]
diletta-input-chip    label    →  button[onmouseover]   ← o MESMO valor vai também ao conteúdo
diletta-pagination    rotulo   →  nav[onmouseover]
```

### O número, executado — e não por padrão de texto

As **29** peças instanciadas, com **cada atributo que elas leem** (143, a união de
`observedAttributes` com todo `getAttribute`/`hasAttribute` do arquivo), **três venenos** por
atributo, um **controle benigno** para não contar o `<img>` legítimo do `foto`, e **duas
passadas somadas** — uma com o atributo sozinho, outra com a peça inteira ligada, porque o `×` do
chip só nasce com `removivel` e o `file-card` troca de ramo com todos ligados:

```
21 de 29 peças vazam  ·  8 não vazam  ·  34 atributos
```

**A lista de 11 do pedido acerta 10**; o único falso positivo é `data-row` (os atributos dela são
enums e `href`). **Faltam 11**: `avatar` · `data-column-header` · `dialog` · `dropdown` · `input` ·
`input-chip` · `pagination` · `segmented-control` · `status-tag` · `tabs` · `toast`. E o
`web-top-bar`, que estava na lista por `nome`, vaza também por `papel`.

É a mesma forma do achado do veredito — *«a sua varredura ingênua achava 10, porque o `button`
guarda o texto num `const`»* — um degrau adiante: **régua de texto conta a forma que ela procura, e
a execução conta o que a peça faz.**

### E no chip não existe conserto do lado de fora

O `<diletta-input-chip>` usa `label` nos dois destinos. Medido com um dublê que faz exatamente o
que a premissa sugere — escapa o conteúdo e confia no atributo:

```
consumidor escapando   a pílula mostra  "a&quot; onmouseover=&quot;alert(1)"   ·  × seguro
consumidor sem escape  a pílula certa                                          ·  × com onmouseover
```

**Um atributo alimenta dois destinos, e se a peça os tratar diferente não há escape do lado de
fora que acerte os dois.** Nas outras quatro o consumidor ainda se defende sozinho; no chip, não. No
webadmin a entrada do chip é a query string.

### O que a v0.208.0 precisa cobrir para esta nota morrer

1. **A função que separa «veio de fora» precisa saber o DESTINO**: conteúdo escapa `&`, `<`, `>`;
   valor de atributo escapa também `"`, que é a que abre a porta ali. As interpolações que
   *precisam* ser marcação — as que o veredito protege, com razão — ficam de fora igual.
2. **As 21, e não as 11.** O gate que confirma o conserto precisa ser de EXECUÇÃO, peça a peça,
   atributo a atributo, com a peça inteira ligada — não a varredura por padrão.

**Ressalva de método**: a sonda rodou em jsdom, que não carrega imagem — o `onerror` não DISPARA
ali. O que ela prova é que a string foi parseada como HTML e que o atributo de evento existe no
nó; no navegador o resto é consequência, e o próprio pedido já provou isso com `window.__PROVA`
no botão. E ela só alcança caminhos governados por atributo: ramos de `<slot>` ou de estado
interno não foram exercitados.

### O que o consumidor faz enquanto isso

O webadmin escapa nos sete embrulhos, por destino, e o gate dele tem **duas pontas**, porque o
aviso do veredito — *«escape duplo mostraria `&lt;` literal»* — se mediu verdadeiro e mais largo:
com dublês que já escapam, **21 de 27** leituras mostravam o texto errado (inclusive `Salvar & sair`
→ `Salvar &amp; sair`), e **as 21 passavam verdes** num gate que só perguntasse «nasceu nó?».

- **ponta 1**: o texto renderizado é igual à entrada, no conteúdo e no nome acessível;
- **ponta 2**: a peça instalada, com a configuração do embrulho, ainda é crua — e o vermelho diz
  qual escape remover.

O remendo do chip só sai quando **os dois** destinos ficarem vermelhos juntos.
