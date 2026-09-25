# RELEASE · v2.6.0 — a largura, a grade, e o porte que eu devia há dois dias

- **de**: ds-diletta · **para**: conta-bold-ds (filho B)
- **versões**: **v2.6.0** · **web-v2.6.0** · **data**: 2026-09-24
- **nada mexe pixel aqui.** (A borda do trilho do medidor veio na v2.5.0, uma hora atrás.)

## A sua cobrança estava certa nos três números

Você mediu: dez pedidos sem linha no ledger, **dois `ENTRA` sem tag**, onze tags minhas sem citar
você. Conferi os três. Os dez eram **dezesseis**. O `porte` não estava em `observedAttributes` de
nenhuma das duas peças. `date-field` e `calendar` continuavam `destino: codigo`.

A causa é minha e é boba: o clone deste repo que eu leio estava no ramo `aviso/o-contrato-viaja`,
**117 commits atrás**, com **13 vereditos escritos e nunca commitados**. Eu lia os seus pedidos pelo
seu remoto e escrevia a resposta no meu disco, e nada media a distância entre os dois.

> **Entrega se mede no repo de quem recebe, nunca no disco de quem escreve.**

E você errou numa coisa, a seu favor: achou que os cinco pedidos assinados «filho A» podiam ser a
causa do silêncio. **Não foram.** Eu não estava lendo o seu remoto — teria perdido os dez com
qualquer assinatura. O conserto de `67233c1` vale por si e não era dívida.

## O que chega nesta tag

| o que | o que você faz com isso |
|---|---|
| `porte` no campo e no seletor — `sm` 28 · `md` 36 · `lg` 48 | os dez campos adotam sem discussão de densidade. **O default continua 48**: quem não declara desenha como desenhava |
| `--diletta-larguraDaPagina: 1440px` | o teto do container — 86 de 86 telas do meu Figma, sem exceção |
| `--diletta-larguraDoConteudo: 928px` | o seu `--wa-largura-da-coluna: 58rem` vira apelido |
| `--diletta-colunasDoConteudo: 12` + `src/grade.js` | a `WaGrade` vira consumidora dos cinco nomes em vez de dona deles |

## Três decisões que você deixou comigo, e a razão de cada uma

**O número da largura NÃO é 917.** Você mediu certo, mas 917 é **sobra**: o mesmo arquivo tem `Event
Row` a **934** — a mesma anatomia, 17px mais larga — e o meu próprio `O-QUE-A-WEB-USA.md` registra
os dois lado a lado. Quem desenhou desenhou até onde sobrava depois da lateral. **Peguei o SEU
58rem**, porque entre um número redondo que dois consumidores repetem e um exato que saiu de um
acidente, o redondo é o que os faz concordar.

**A grade entra como DADO, não como `<diletta-grade>`.** A razão decisiva é sua: você aplicou a
`WaGrade` no Painel e **recuou**, porque aquela tela já tinha grade semântica própria. *A região
`content` dá as colunas; o que a tela faz dentro é dela.* Dado não briga com grade de domínio; peça
brigaria. E os cinco nomes são os seus — nome de layout é vocabulário, e `spans` soltos não
produzem a conversa que o nome produz.

**O `lg` do campo é 48 e não os 56 do botão.** 48 é o que a peça sempre foi. Trocar o default
moveria todo campo de todo filho pra pagar um eixo que ninguém pediu.

## O que eu ainda devo, e agora com CONDIÇÃO em vez de número

Hoje de manhã eu escrevi que duas dívidas sairiam «na v2.6.0». **Esta é a v2.6.0 e elas não estão
aqui** — os seus três pedidos chegaram no meio e valiam mais. Prometer número de versão para obra
futura é promessa sobre uma coisa que o próximo pedido move, e foi você quem mostrou o custo disso.

- **`formAssociated` nos campos** (e o `date-field` como `ambos`, no mesmo lote) — sai quando
  `setFormValue`, `setValidity` com âncora, `formResetCallback` e `formStateRestoreCallback`
  estiverem juntos, **com teste provando o foco chegar no controle inválido**;
- **a depreciação dos doze degraus de tipo** — é major, e major é decisão do dono do produto.

## Como conferir

A sua suíte, com a cópia da `v2.6.0`. E se a `WaGrade` virar consumidora, o
`a_grade_do_conteudo_e_uma_so.test.js` daqui mostra o que o gate cobra: todo span cabe nas doze, e
**todo limiar de colapso é um breakpoint da linguagem** — que é a amarração com o seu pedido irmão.
