# RELEASE · os seus seis pedidos julgados — e os três que eram defeito saíram na mesma tag
**pai**: ds-diletta **v0.203.0** · irmã **web-v0.203.0** · **data**: 2026-09-21 · **para**: você

Os vereditos estão escritos ao lado das perguntas, nos seis arquivos. Este aviso é o que muda do seu
lado, e ele começa pelo que estava travando a adoção.

## Os três que saíram

| o que você mediu | o que entrou | o que você faz |
|---|---|---|
| 5 desenhos por botão montado · suíte 3,0s → 26,5s | `mudouAtributo()` na `base.js`, nas 27 peças: **5 → 1**, mesmo valor **1 → 0** | **solte o patch dos 177**. O que segurava a adoção do botão caiu |
| anel de foco a 1,64:1 (1,46 na referência) | `primary` no repouso, `error` no erro, **nos dois lados** | nada — e leia a linha abaixo, porque ela é sobre o seu conserto |
| relógio do `pending` 2,4px torto | a regra alcança os dois caminhos de glifo | nada. Pode usar `porte="ampla"` com as frases inteiras |

## A parte que eu te devo dizer: **o anel que vocês adotaram também reprova**

Vocês divergiram com o número na mão, e o número que vocês tinham era o do tom **rejeitado**, não o
do adotado. Medi o de vocês, na paleta emitida deste repo:

| modo | o anel do webadmin | contra `surface` | razão | |
|---|---|---|--:|:-:|
| claro | `primary` @40% = `#ffb0c8` | `#ffffff` | **1,71:1** | ❌ |
| escuro | `primary` @40% = `#6e3953` | `#14151f` | **2,05:1** | ❌ |

**1,71 contra os 1,64 do `primaryTrack` que vocês tiraram.** A divergência custou trabalho e não
comprou acessibilidade. O `primary` cheio de vocês passa — 3,46:1 no claro, 6,66:1 no escuro —, e
tirando o alfa a divergência some sozinha, porque vira a regra da linguagem.

> **Alfa é a armadilha desta classe**: ele muda o contraste e não muda o nome do token, então a
> medição feita no token continua verdadeira e passa a descrever outra cor.

## Os três que não saíram, e por quê

**O campo de seleção**: a peça **existe** — `DilettaDropdown`, na LINGUAGEM, declarada
`destino: ambos`, e já listada na régua da `v0.201.0` como *sem instância web*. A sua busca varreu as
61 peças do `coreflow`, que é o degrau do meio. Não é reparo em você: o ADR-003 declara três degraus
desde 08/09 e **eu nunca escrevi como se procura neles** — está aberto no meu ledger com a origem
neste pedido. A instância web nasce em volta do `<select>` NATIVO, e o seu argumento ganha inteiro.

**O diálogo**: entrou a declaração, não a peça. `design-system-dialog` dizia `destino: codigo` — eu
tinha declarado que ele não atravessa, o que o mantinha fora da fila e de toda medição. Agora é
`ambos`, e a fila da web passou de 13 para **14**. A folha é do **seu** degrau: o `coreflow_folha`
mora no seu repo, eu tenho o contêiner. E o contêiner não tem spec, que é o irmão do meu defeito —
um por declaração errada, outro por ausente.

**O microtask**: ficou de fora com a condição escrita. Ele tornaria o desenho assíncrono, e aí
`setAttribute` seguido de ler o shadow passaria a ler a árvore velha — nos meus 110 gates, nos seus, e
nos 177 que você tem guardados.

## O que você me deu além dos pedidos

Três instrumentos em uma semana, e eu aceitei os três: a **régua do seletor de compensação** (aceita
no mérito, esperando um mapa de estados por peça, senão ela reprova o desenho correto), a
**varredura de contraste de 30 linhas** e o **inventário dos 25 elementos contra as peças locais**.
Mande os dois últimos quando puder, sem prazo — o inventário é o que acha os próximos três «peça que
nunca saiu», e a varredura é o contrário da lista declarada que deixou o anel invisível por um mês.

E a sua retratação do botão destrutivo fica no ledger pela frase, não pelo caso:

> **Uma matriz de combinações não prova ausência quando a matriz foi montada por suposição.**

Ela é irmã de dois erros meus que levaram semanas. O seu levou horas, e o que encurtou foi a pergunta
de uma linha de quem estava olhando a tela.

## Prazo

Nada aqui é bloqueante seu. O `ref:` sobe quando quiser.
