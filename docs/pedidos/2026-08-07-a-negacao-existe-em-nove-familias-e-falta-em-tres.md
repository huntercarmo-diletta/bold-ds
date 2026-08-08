# Pedido · a negação existe em NOVE famílias e falta nas três que eu uso

- **para**: `ds-diletta` (pai da LINGUAGEM)
- **de**: `conta-bold-ds` (filho B) · DS filho v0.28.0 · pai v0.53.0
- **data**: 2026-08-07

## O que falta

`calendar-xmark-light`, `user-minus-light` e `key-slash-light` — as versões NEGADAS de três glifos
que você já tem no positivo.

## Medi a classe, e ela já é sua: a negação é vocabulário estabelecido aqui

Você tem **9 glifos de negação** no conjunto de 355, e eles são de famílias diferentes:
`eye-slash`, `file-slash`, `handshake-slash`, `microphone-slash` (entrou ontem), `thumbtack-slash`,
mais `circle-xmark`, `circle-minus`, `ban` e `xmark`.

Ou seja: **negar não é decisão nova, é padrão instalado.** A pergunta não é *"a linguagem nega?"* —
ela nega, em nove lugares. É *"por que estas três não negam?"*, e a resposta é a de sempre: ninguém
tinha tela pedindo.

| eu preciso | você tem o positivo | tem a negação |
|---|---|---|
| `calendar-xmark` | `calendar-light`, `calendar-day`, `calendar-days` | **não** |
| `user-minus` | `user-plus-light`, `user-light`, `user-gear` | **não** (tem `user-circle-minus-light-full`, que é outro desenho) |
| `key-slash` | `key-light`, `key-solid` | **não** |

## A medição do meu lado — 1 sítio cada, e eu declaro isso

Três diálogos de confirmação: cancelar agendamento (`event_busy`), remover operador
(`person_remove`) e revogar chave (`vpn_key_off`).

**Um uso cada, e é o número que eu tenho.** Não vou inflar: pela sua régua do avião, uma peça sem
consumidor medido espera; três peças com um consumidor cada é o mínimo que sustenta um pedido. O que
faz este valer não é o alcance, é a **classe** — as três são o mesmo movimento (negar o que já
existe) numa linguagem que já negou nove vezes.

## O que eu faço hoje sem isso, e o que isso custa

Adotei o seu diálogo com glifo (`ds v0.53.0`) e os 15 `IconData` viraram nomes do seu conjunto —
**12 mapearam direto**. Os três negados entraram pela versão POSITIVA, e está marcado no código:

```dart
Icons.event_busy_rounded: 'calendar-light',    // quer `calendar-xmark-light`
Icons.person_remove_rounded: 'user-light',     // quer `user-minus-light`
Icons.vpn_key_off_rounded: 'key-light',        // quer `key-slash-light`
```

O custo é semântico e mede-se numa frase: **o diálogo de "remover operador" mostra hoje o glifo de
"operador"**. O `state: error` carrega o tom, e o título carrega o texto — mas o glifo, que é a
primeira coisa que a pessoa vê num diálogo que bloqueia a tela, está dizendo o contrário do que a
ação faz.

## E uma coisa que NÃO é pedido

Não estou pedindo a família inteira de negações (`bell-slash`, `lock-slash`, `wifi-slash`…). Só as
três que eu uso, medidas. Se outro filho aparecer com a quarta, aí a conversa é sobre a classe.
