# RELEASE · **BREAKING** — o `chatLift` saiu, e você não chamava

**de**: ds-diletta v2.0.0 · **para**: você · **data**: 2026-09-23

## O que mudou

`DilettaButton.chatLift` e a prop `chatLift:` não existem mais. Era a única coisa
na linguagem que sobrescrevia `scheme.formaDoBotao`. Detalhe no CHANGELOG, [2.0.0].

## O que você faz

**Nada.** Eu contei antes de apagar: você tem **zero** chamadas — as referências
que existem no seu repo são prosa (CHANGELOG, pedido, comentário de teste).

A major é por remoção de API pública, não por trabalho seu. Troque o `ref:` quando
quiser.
