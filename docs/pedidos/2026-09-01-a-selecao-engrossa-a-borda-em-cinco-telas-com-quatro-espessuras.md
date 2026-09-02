# PEDIDO AO DONO · a seleção engrossa a borda em CINCO telas, com QUATRO espessuras — e este DS já respondeu isso de outro jeito

- **de**: conta-bold-ds (a BASE da família) · **para**: o dono do produto
- **consome**: DS v0.87.0
- **bloqueante?**: não. O eixo `larguraDaBorda` entrou pra o desenho sair das telas hoje; a pergunta
  é o que decide se ele fica.

## O que eu achei

A varredura das 128 pinturas das telas em 01/09 achou **nove** bordas com espessura diferente de 1.
**Cinco delas são condicionais, e as cinco significam a mesma coisa: escolhido.**

| tela | o que ela escreve |
|---|---|
| editor de menu da home | `selected ? 2 : 1` |
| tipo de conta (onboarding) | `selected ? 2 : 1.5` |
| documentos da empresa | `uploaded ? 1.4 : 1` |
| alçadas — faixa dourada | `golden ? 1.3 : 1` |
| autorizações — cartão do pedido | `selected ? 1.5 : 2` |

Quatro espessuras de "escolhido" — **1,3 · 1,4 · 1,5 · 2** — e a última **inverte a lógica das
outras quatro**: escolhido fica mais FINO.

## Por que isso é pergunta e não conserto

**Este pacote já respondeu uma vez, e a resposta foi outra.** O `CoreflowCartaoDePedido` marca
`selecionada` trocando a **cor** da borda — `s.primary` contra `s.border` — e não a espessura. Ele é
a peça mais nova das seis, e foi desenhada olhando o problema.

Então a linguagem diz *"escolhido"* de dois jeitos: uma peça por cor, cinco telas por espessura. Uma
linguagem que diz a mesma coisa de dois jeitos tem um jeito a mais.

## O que eu NÃO fiz, e por quê

Converter as cinco pra cor. Seria uma linha em cada uma, e **mudaria pixel em cinco telas numa
passada que ninguém abriu pra olhar**.

A régua desta casa sobre isso já custou caro três vezes hoje: `analyze` limpo e 852 testes verdes
não viram um fio a mais em 25 telas, nem duas telas desenhando arquivo inexistente, nem dois cinzas
no mesmo pegador. **Gate não vê forma.** Trocar a affordance de seleção em cinco telas é
exatamente o tipo de mudança que precisa de olho, e eu não tenho aparelho nem retrato aqui.

## O que eu fiz

`CoreflowCartao(larguraDaBorda:)`, com a razão escrita no campo. O desenho saiu das cinco telas — a
caixa agora é a peça — e o pixel não mudou em nenhuma.

O campo é declaradamente temporário: **quando a pergunta for respondida, ele sai e as cinco viram
`borderColor`.**

## A pergunta, em uma linha

*Seleção neste produto é COR de borda (como o cartão de pedido faz) ou ESPESSURA (como as cinco
telas fazem)?* Se for cor, eu converto as cinco e apago o eixo. Se for espessura, o cartão de pedido
é que está fora do padrão, e aí a espessura precisa de um número só — não de quatro.
