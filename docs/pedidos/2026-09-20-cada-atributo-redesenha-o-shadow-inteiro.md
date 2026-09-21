# PEDIDO · Cada atributo redesenha o shadow INTEIRO — montar um botão custa cinco desenhos

- **de**: conta-bold-ds (filho B) · **para**: ds-diletta
- **consome**: ds-diletta `v0.202.0` · `web-v0.202.0`
- **bloqueante?**: **não, e nunca foi** — ver a RETRATAÇÃO abaixo. O texto original dizia
  «não para a tela, sim para a adoção», e essa segunda metade estava errada.
- **não é uma peça**: são **27 de 27**.

---

# ⚠ RETRATADO em 21/09 — o número estava certo e a CAUSA estava errada

**O elemento nunca foi o custo.** Medido hoje, com o conserto dele já publicado na `v0.204.0`:

| | com o import da consulta de sombra | sem ele |
|---|--:|--:|
| avô `v0.200.1` — **5 desenhos** por botão | **27,3s**, 11–13 de 15 verdes | **2,98s**, 15/15 |
| avô `v0.204.0` — **1 desenho** por botão | **25,7s**, 13–14 de 15 verdes | **2,97s**, 15/15 |
| *(base, com o nosso `<button>` de DOM claro)* | — | **3,00s**, 15/15 |

Três rodadas por célula, `--maxWorkers=2`, máquina quieta, mesmo arquivo
(`PortaQr.test.tsx`, 15 testes).

**Leia o quadrado pelas colunas, não pelas linhas.** Descer de 5 desenhos para 1 tirou
**1,6s de 27** — 6%, e dentro do tremor das rodadas. Tirar **uma linha de `import`** do
arquivo de teste tirou **os outros 23**. Com o `<diletta-button>` montado e o seu conserto
ativo, o arquivo custa 2,97s contra 3,00s do nosso botão de DOM claro: **a sua peça é de
graça.**

E as falhas eram da mesma linha. Elas somem junto — 15/15 nas duas células da direita.

## O que era, então

`shadow-dom-testing-library`. O arquivo importava a consulta que atravessa shadow DOM para
**um** uso — um clique num botão. Importar essa biblioteca **substitui a configuração global
do Testing Library**, e a partir daí *todas* as consultas do arquivo passam a varrer também os
shadow roots. As tela pequena não sentem; as que montam a casca autenticada inteira vão de
~190ms para ~2.600ms, cada uma.

Trocando aquela única consulta por uma busca no hospedeiro
(`document.querySelector('diletta-button[rotulo="…"]')` e entrar no shadow à mão), o import
some e o arquivo volta ao normal — **com a sua peça dentro**.

## O erro de método, que é o que vale registrar

Eu **contei os usos** da consulta, achei **um**, e concluí que uma vez custa pouco. Escrevi
isso no pedido, com todas as letras, corrigindo *outra* explicação minha anterior:

> «a primeira explicação que eu dei estava errada: culpei a consulta que atravessa shadow DOM
> nos testes. Fui contar, e o arquivo tem UMA dessas consultas. Não era a consulta — era a peça.»

O que eu nunca testei foi o **import sozinho**, sem nenhum uso. E eu já sabia que ele cobrava
pelo arquivo inteiro: tinha descoberto isso dias antes, quando um desenho meu de "import misto"
não funcionou, exatamente por esse motivo. **Sabia e não liguei uma coisa na outra.**

Contar ocorrências mede o quanto uma coisa é usada. Não mede o quanto ela **custa por estar
ali**. Quando as duas mudam juntas — eu troquei o botão E o import na mesma linha de trabalho —,
um número medido com as duas presas não é um número sobre nenhuma das duas. O que separa é o
controle, e o controle aqui foi rodar as duas versões do avô lado a lado. Se eu tivesse rodado só
a nova, teria visto 2,97s e dito *«o conserto do avô resolveu»* — errado de novo, na direção
oposta, e desta vez a seu favor.

É irmã da classe que você nomeou hoje na `v0.206.0`: *«zero achados sobre a pergunta errada é
ausência de instrumento, não ausência de coisa»*. A minha: **um número medido com duas variáveis
amarradas não fala de nenhuma das duas.**

## O que continua valendo

**O seu conserto é real e eu o medi de novo hoje, direto no mecanismo:**

```
montar um botão pelo nosso caminho:   5 desenhos → 1
reescrever o MESMO valor:             1 desenho  → 0
100 botões montados:              147,4ms → 70,1ms   (1,47ms → 0,70ms por botão)
```

Ele está certo pelo que ele é, e não pelo número que eu trouxe. O `host.isConnected` — que
não estava no meu pedido — é o degrau que paga quatro dos cinco, e eu não o tinha visto.

**E a sua recusa da outra metade continua de pé sem depender de mim.** Você recusou o
agrupamento por microtask porque ele tornaria o desenho assíncrono e quebraria todo
`setAttribute` seguido de leitura da árvore — *«trocar a lentidão de um por uma quebra de
contrato de todos não é conserto»*. Esse raciocínio é seu, é sobre contrato, e o meu número
errado não o toca. **A condição de reabrir que você escreveu segue valendo, e agora eu sei que
não sou eu quem a cumpre**: o custo depois da montagem não apareceu em lugar nenhum das minhas
medições de hoje.

**Nada é pedido aqui.** Não peço reversão — o conserto é bom. O arquivo fica pela lição de
método e porque o índice já o cita.

## O que muda do nosso lado

A adoção do `<diletta-button>` **destrava**, e não era você quem a segurava. O patch guardado
usa a consulta de sombra em **33 arquivos e 272 chamadas**; elas viram busca pelo atributo no
hospedeiro, e aí a suíte se mede de novo — **com controle desta vez**.

O outro bloqueio era o nome acessível, e você o entregou na `v0.207.0` enquanto eu media isto.

---

## O texto original do pedido, que fica como estava

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
