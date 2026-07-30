# Resposta ao CHAMADO · o raio dos meus controles

- **filho**: conta-bold-ds
- **pai**: ds-diletta v0.8.0
- **é bloqueante?**: não. Isto é resposta a chamado, não pedido — e a resposta é **quase
  "bate"**
- **chamado**: `docs/avisos/2026-07-29-medir-o-raio-do-seu-produto.md`

## A medição

Rodei a varredura e **não usei o resultado dela pra responder**, porque ela mesma avisa que a
heurística de contexto erra. Ela errou nos dois casos em que apontou divergência:

| controle | a varredura disse | medido no token | resultado |
|---|---|---|---|
| botão | 6 · "diverge" | `BoldRadius.pill` = 999 | **não diverge** |
| card | 16 · "diverge" | `BoldRadius.card` = 24 | **não diverge** |

O que eu medi foi a escala DECLARADA (`BoldRadius`) e qual degrau cada componente lê, que é
onde a resposta mora. O produto tem 5 degraus de raio, não 18 — os 18 que a varredura viu são
literais espalhados por tela, que é dívida minha e não informação sobre a linguagem.

| controle | meu degrau | o seu (medido no seu componente) | diverge? |
|---|---|---|---|
| botão | pill (999) | `pillAll` (e `all24` numa variante) | **não** |
| card | 24 | `all24` | **não** |
| campo / input | 16 | **`all16`** no `DilettaInput` | **não** |
| chip | pill | `all200` no `DilettaInfoChip` | **não** |
| folha | **22** | o `SheetOverlay` não crava raio | degrau que só eu tenho |

Distribuição no seu conjunto, pra referência: `pillAll` 23 · `all8` 17 · `all24` 12 · `all16`
12 · `all200` 5.

## Duas coisas que a medição achou, e uma é sua

**1 · A tabela de defaults do seu chamado não bate com o seu código.** O chamado diz "campo /
input → meu default 8". O `DilettaInput` usa `DilettaRadius.all16`. Os 17 usos de `all8` estão
em outras 15 peças (`app_list`, `toast`, `receipt`, `otp_input`, `progress_bar`, `keyboard`,
`feature_card`…), nenhuma delas o campo.

Isso muda a conclusão do chamado pro meu caso: **o campo era o único lugar onde eu ia divergir,
e ele não diverge.** Vale conferir a tabela antes de mandá-la pro próximo filho — número errado
num aviso vira medição errada em quem responde.

**2 · Eu tenho um degrau que você não tem: folha = 22**, com 8 usos. Não é literal solto, é
token declarado (`BoldRadius.sheet`), e 22 não existe na sua escala (0/2/4/8/16/24/32/40/56/200).

Não estou pedindo o degrau. Pela sua própria régua, um filho pedindo é gosto local até prova em
contrário — e 22 tem cara de arredondamento de desenho, não de vocabulário. **Estou registrando
como primeiro caso**, que é pra isso que o ledger serve: se um segundo filho aparecer com uma
folha que não é 24, aí é papel de forma faltando (`raioDeFolha`) e sobe pela regra.

Se você preferir, eu adoto 24 na folha e fecho o item — mas aí a decisão é de desenho e eu
prefiro que ela seja tomada olhando, não por conveniência de contrato.

## O que eu faço

Nada, do lado do raio. Não vou embrulhar componente do pai pra arredondar diferente — é o
conserto que sobrevive e faz o produto ter dois botões, e o chamado avisa isso com razão.

Do meu lado sobrou uma limpeza, e ela é minha: `BoldRadius.chip` = 10 existe e tem **1 uso**,
enquanto o meu próprio chip usa `pill`. Token morto que sobreviveu a um redesenho. Sai na
adoção.

## Sobre o modo de consumo

O chamado mudou o meu modo pra **dependência**, porque eu sou produto interno da Diletta e a
razão do sync era uma fronteira entre duas empresas. Aplicado: `git:` + `ref: v0.8.0`, a cópia
local apagada, o `.sync.json` e o `sem_drift_do_pai_test` removidos junto — sem cópia não há
drift, e gate que vigia arquivo inexistente é gate que mente.
