# RELEASE · o contrato viaja com o código — e quem pagou por isso foi a sua medição
**pai**: ds-diletta **v0.194.1** · irmã **web-v0.194.1** · **data**: 2026-09-14 · **para**: você

Nada muda pra quem consome Dart, e nenhuma peça desenha diferente.

## O que entrou

```
npm i git+ssh://git@bitbucket.org/diletta/ds-diletta.git#web-v0.194.1
```

```js
import spec from 'diletta-design-system-web/spec-publicada.json';   // export `./spec`
spec.pecas['design-system-button'].arranjo.porPorte.lg   // {altura:56, recuoH:16, icone:18, tipo:'titleSm'}
```

**98 peças**, cada uma com propósito, `destino`, eixos, tipos, uniões, papéis, slots, geometria e —
nas duas primeiras — `arranjo`, que é a medida por porte. Conferido instalando num diretório vazio:
**372 KB**, e o contrato lido pelo nome do pacote.

## Por que, e o número é seu

O seu pedido de 11/09 trazia esta tabela, e eu respondi só a metade dela:

| o que você mediu | |
|---|---|
| componentes que o IB mantém por conta própria, em React | **187** |
| tokens de cor do IB transcritos à mão a partir do Dart | **195** |
| gates ligando essa transcrição à fonte | **0** |

Eu resolvi o transporte do CÓDIGO e deixei o contrato onde ele estava: **128 markdowns, com o
contrato dentro de um bloco de código.** Quem escreve em React não lê a nossa autoridade — lê o
nosso Dart e transcreve, e é por isso que aqueles 195 existem.

> **A spec virou autoridade e continuou saindo em prosa.**

Agora o pacote leva os dois. Não fecha a sua terceira linha sozinho — gate é do lado de lá —, mas
**ele torna o gate possível**: a transcrição passa a ter uma fonte declarada pra ser comparada.

## O que ele NÃO é, e a decisão está escrita

Não é gerador de componente. Pelos seis critérios, com quatro implementações na família (Flutter no
app, Flutter Web, custom element, React) o mercado de quatro plataformas escreve **estrutura à mão**
e compartilha **token e spec** — e um motor que interprete árvore por instância seria quatro motores
degradando em silêncio. O que viaja é o que a spec decide; a estrutura continua sendo sua.

## O que eu preciso de você

1. **suba o `ref:` pra `v0.194.1`** — entre ela e a `v0.193.0` que você consome não há migração
   cobrada;
2. **olhe o `spec-publicada.json` com o olho de quem escreve React** e me diga o que falta pra ele
   servir: se faltar campo, é medição e eu quero o nome do campo;
3. **as duas peças com `arranjo`** (botão e botão de ícone) são o experimento. Se a medida por porte
   bastar pra você escrever a mesma peça sem inventar número, eu estendo às outras; se não bastar,
   quero saber em que ponto ela não basta.
