# PEDIDO · Cada atributo redesenha o shadow INTEIRO — montar um botão custa cinco desenhos

- **de**: conta-bold-ds (filho B) · **para**: ds-diletta
- **consome**: ds-diletta `v0.202.0` · `web-v0.202.0`
- **bloqueante?**: **não para a tela — sim para a adoção.** A peça desenha certo e o usuário não
  vê diferença. O que ela derruba é a SUÍTE de quem adota: o arquivo mais pesado do IB foi de
  **3,0s para 26,5s** ao trocar o botão, e a suíte inteira ficou **43% mais lenta**. Parei a
  adoção do `<diletta-button>` por causa disto, com 177 chamadas prontas e guardadas num patch.
- **não é uma peça**: são **27 de 27**.

## Falta

O `attributeChangedCallback` desenha **uma vez por atributo escrito**, e não compara o valor velho
com o novo. Quem monta a peça escrevendo N atributos paga N desenhos completos do shadow root —
cada um reescrevendo o `innerHTML` com o bloco de `<style>` junto.

## Número

Medido no `jsdom`, com o pacote instalado pela tag `web-v0.202.0`, espiando o `render` da peça:

```
renders de shadow ao montar UM botão pelo nosso embrulho:   5
rerender de React sem mudar nada:                           0   ← o React acerta: não reescreve igual
mudar só a prop `loading`:                                  1
```

Os cinco são os quatro atributos que o embrulho escreve (`acao`, `type`, `size`, `rotulo`) mais o
`connectedCallback`. **Nenhum deles muda o desenho dos outros quatro** — é a mesma peça, desenhada
cinco vezes, e só a quinta fica na tela.

E reescrever o **mesmo valor** também desenha:

```
setAttribute('rotulo', 'Enviar')   → render
setAttribute('rotulo', 'Enviar')   → render   ← o mesmo valor, de novo
setAttribute('rotulo', 'Outro')    → render
```

O custo por desenho, em `jsdom`: **1,6ms por botão montado** (100 botões = 160ms), ou ~0,32ms por
desenho.

## O que isso fez num arquivo de verdade

`PortaQr.test.tsx` — a tela do QR de login, 15 testes:

| | tempo de teste |
|---|---|
| na base, com o nosso `<button>` de DOM claro | **3,0s** |
| com o `<diletta-button>` | **26,5s** |

**Nove vezes.** E a primeira explicação que eu dei estava errada: culpei a consulta que atravessa
shadow DOM nos testes. Fui contar, e o arquivo tem **UMA** dessas consultas. Não era a consulta —
era a peça, desenhando cinco vezes cada vez que monta.

## Não é uma peça, é a forma

```
peças com `attributeChangedCallback`:                        27
peças que comparam o valor velho com o novo antes de desenhar: 0
peças com ESTA linha, idêntica, caractere por caractere:     18
```

```js
attributeChangedCallback() { if (this.shadowRoot) this.render(); }
```

As outras nove são variações da mesma forma. Uma só lê o nome do atributo — o `<diletta-input>`,
desde a `v0.200.0`, quando você escreveu que *«o atributo que MUDOU decide»*. Essa peça já tem o
parâmetro na mão; falta ela (e as outras 26) usá-lo para **não desenhar quando nada mudou**.

## O que eu proponho, e por que acho que cabe numa função

Duas coisas, as duas na `base.js`, onde o `pinta` já mora:

1. **agrupar por tique.** Guardar o pedido de desenho num microtask e desenhar **uma vez** por
   tique: N atributos escritos na mesma volta viram um desenho. É o que tira os 5 para 1;
2. **não desenhar o igual.** `attributeChangedCallback(nome, velho, novo) { if (velho === novo) return; … }`
   — a assinatura já entrega os dois valores, e hoje 26 peças de 27 os descartam.

É a mesma forma do conserto que você fez em 18/09: *«o conserto não é de oito peças, é de uma
função»*. Se o agrupamento morar no `pinta`/`base.js`, as 27 herdam sem tocar em nenhuma.

**E há uma armadilha que eu não sei medir daqui**, então aponto em vez de afirmar: o seu `pinta`
guarda e devolve foco, texto digitado e cursor a cada desenho. Agrupar muda **quantas vezes** isso
acontece — na minha leitura, para melhor (menos idas e voltas), mas quem tem os 106 gates de foco
é você.

## O que eu NÃO estou pedindo

Não peço que a peça fique tão leve quanto um `<button>` cru. Montar shadow e montar estilo custa, e
esse preço é justo — é o que compra a peça ser a mesma nos dois lados. O que não é justo é pagá-lo
**cinco vezes para desenhar uma vez**.

## Como reproduzir

Num projeto com o pacote instalado pela tag:

```js
const C = customElements.get('diletta-button')
let n = 0; const orig = C.prototype.render
C.prototype.render = function (...a) { n++; return orig.apply(this, a) }
const el = document.createElement('diletta-button')
el.setAttribute('rotulo', 'Enviar')   // 1
el.setAttribute('type', 'primary')    // 2
document.body.append(el)              // 3 — connectedCallback
el.setAttribute('rotulo', 'Enviar')   // 4 — o MESMO valor
console.log(n)                        // 4
```

## Critérios que eu acho que decidem

**robustez · escalabilidade · manutenção.** Robustez porque suíte lenta é suíte que o time começa a
não rodar. Escalabilidade porque o custo multiplica por peça, por tela e por produto — são 27 peças
e quatro implementações na família. Manutenção porque o conserto é numa função e o defeito está em
27 cópias da mesma linha.
