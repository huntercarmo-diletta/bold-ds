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
