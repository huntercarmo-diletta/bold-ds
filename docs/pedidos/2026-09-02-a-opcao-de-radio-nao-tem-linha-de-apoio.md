# PEDIDO · a opção de rádio não tem linha de APOIO — e sem ela a escolha é entre duas coisas iguais

- **de**: conta-bold-ds (a BASE da família) · **para**: ds-diletta (o pai)
- **consome**: pai `v0.155.0`
- **peça**: `DilettaRadioList` / `DilettaRadioOption`
- **bloqueante?**: não. A tela foi entregue por composição; o que se pede é que ela pare de precisar
  disso.

## O caso, e ele não é meu — é do time do produto

Na tela de proximidade a pessoa escolhe **em qual conta recebe**. Duas contas na mesma agência
aparecem assim:

```
Ag. 0252 · 925241
Ag. 0252 · 331088
```

O que as distingue é o TITULAR, e é para ele que o dinheiro vai. Sem a segunda linha, a escolha é
entre duas coisas que se leem iguais — e o erro custa um pagamento no lugar errado.

`DilettaRadioOption` tem `value` e `label`. Só.

## O que eu fiz enquanto isso, e por que não serve como resposta

Compus a linha: `CoreflowLinhaDeLista` com o `DilettaRadioMark` (que virou público na `v0.152.0`,
por pedido desta casa) no `leading`, mais um `Semantics(inMutuallyExclusiveGroup: true)` por fora.

Funciona, e **é pior que a peça** em duas coisas que só a peça sabe:

- o `inMutuallyExclusiveGroup` é meu de novo. A `DilettaRadioList` já o põe, e eu o reescrevi porque
  não podia usá-la. Acessibilidade recomposta à mão é acessibilidade que a próxima tela esquece;
- o espaçamento entre opções (8) e o alinhamento do dot quando há duas linhas — a lista alinha ao
  topo quando tem apoio, e ao centro quando não tem — são decisões da peça. Na composição, elas
  viram números de tela.

## O que se pede

`DilettaRadioOption(subtitle:)`, nulo por default, e o `crossAxisAlignment` da linha seguindo a
presença dele. É o mesmo par que a `DilettaAppListRow` já tem — `title` + `subtitle` —, e não é
vocabulário novo na linguagem: é o vocabulário que a lista de opções não recebeu.

## O que eu conto, pra medir e não pedir por gosto

- **três** sítios deste produto compõem uma linha de rádio à mão hoje (proximidade, exportar
  extrato, encerrar conta) — os três porque a escolha mora dentro de uma linha que a lista não
  monta. Este pedido resolve UM deles, e é o único que precisa do apoio;
- **um** sítio já usava `DilettaRadioList` inteira e não precisa de nada.

Não peço a lista inteira mais flexível. Peço a linha de apoio na OPÇÃO, que é onde o dado mora.
