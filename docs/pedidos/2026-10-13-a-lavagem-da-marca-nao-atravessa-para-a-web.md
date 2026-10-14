# PEDIDO · A lavagem da marca não atravessa para a web — e `primarySubtle` no escuro é o degrau profundo

- **de**: conta-bold-ds (filho B) · **para**: ds-diletta
- **consome**: ds-diletta `v2.5.0` · `web-v2.5.0`, pela tag `web-v0.120.1` deste repo (o IB, consumidor web, está em `coreflow-design-system-web@0.120.1`)
- **bloqueante?**: **não** — o IB já vive com um token de produto (abaixo); o custo está em «Se você disser não»
- **irmão**: `avisos/2026-08-17-a-rampa-de-texto-RESPOSTA.md` (a linha `primaryWash` × `primarySubtle` da tabela do escuro)

## Falta

Um papel de **lavagem da marca** nos papéis emitidos para a web: o fill translúcido da marca sobre a
superfície, que diz «escolhido» sem cobrir o que está embaixo. O Dart deste filho tem o papel desde
02/09 — `CoreflowScheme.primaryWash` — e o contrato do cartão o declara como o jeito único de dizer
escolhido: *«borda `primary` mais fundo `primaryWash`, e é o jeito único desta linguagem desde
02/09»* (`coreflow_contratos.dart`). A emissão web (`bold-tokens.css`, os 63 papéis da linguagem) não
o traz, porque ele não é papel da linguagem. O consumidor web só tem `primarySubtle`, e no escuro
`primarySubtle` não é lavagem.

## Número

| medida | valor |
|---|---|
| `primarySubtle` no claro | `#ffedf3` — lavagem rosa; é o que o kit web desenha na linha marcada |
| `primarySubtle` no escuro | `#9e1241` — `primary03`, o degrau PROFUNDO; o mesmo valor de `onPrimarySubtle` claro e de `primaryPressed` escuro |
| `onPrimarySubtle` sobre `primarySubtle` no escuro | **4,89:1** (CHANGELOG, a menor folga da tabela) — ou seja, no escuro ele é o fundo SÓLIDO que carrega texto, não um tinte |
| `primaryWash` no Dart deste filho | claro: `primarySubtle` · escuro: `primary04` a **20%** (`coreflow_scheme.dart:281`) |
| ocorrências de `primaryWash` na emissão web | **0** (`bold-tokens.css`, `web-v0.120.1`) |
| folhas do IB que pintam fundo com `primarySubtle` | **19** de peça + **13** de tela; **4** delas dizem «selecionado» (trilho ativo, opção da lista de contas, sugestão do combobox, notificação marcada) |
| medido em 13/10 na vitrine da tabela nova do IB, no escuro | quatro linhas marcadas com `primarySubtle` = um bloco vinho cobrindo a tabela (captura no pedido do IB) |

## Já tentei

Um token do produto, `--ib-superficie-marcada`, em `tokens/produto.css` do IB: `primarySubtle` no
claro e `color-mix(in srgb, var(--diletta-primary) 10%, var(--diletta-surface))` no escuro, com os
mesmos seletores de modo da emissão. A linha marcada e a barra de seleção da tabela usam esse token
(13/10, aprovado pela designer na captura).

O que ele **não** faz: fazer o Dart e a web concordarem. O app diz escolhido com a marca a **20%**
sobre a arte de fundo; o IB com **10%** sobre a superfície. Dois alfas, nenhum emitido, e a
próxima tela do IB que precisar de «escolhido» vai escolher um terceiro.

## Conferi no pai

- A resposta do pai de 17/08 (`a-rampa-de-texto-RESPOSTA.md`) já separa os dois materiais, com a
  frase dele: *«fill translúcido e fill sólido são materiais diferentes»*. A tabela daquele dia
  registra `primaryWash` como «aqui» e `primarySubtle` como «no seu scheme». Esse acordo existe no
  Dart e parou na fronteira da web.
- Nos 63 papéis da emissão web não há nenhum com alfa da marca: os únicos alfas são as bordas
  (`border`, `divider`) e os vidros (`glassTint`, `glassStroke`).

## Derivável?

Sim, por `color-mix` no consumidor — e é exatamente o defeito: derivável por cada um é derivado por
cada um com um número diferente. O que o pai emite, os dois lados leem igual.

## Se você disser não

O token de produto fica no IB, com o 10% medido, e a lavagem do app e a da web seguem diferentes.
As quatro peças do IB que hoje dizem «selecionado» com `primarySubtle` sólido passam para o token
de produto na Fase 4 (T2), uma por vez.

## Não estou pedindo

- Mudar `primarySubtle` no escuro. Ele é o contêiner do `onPrimarySubtle`, medido em 4,89:1, e as
  peças que o usam como contêiner (alerta, tag) estão certas.
- Um papel «selecionado». Selecionado é estado; o que falta é o MATERIAL translúcido da marca, que
  o estado usa.

## Como o pai vai saber que funcionou

A emissão web traz `--diletta-primaryWash` nos dois modos, com o alfa que o pai decidir; o Dart
deste filho passa a ler o do pai em vez de derivar o seu; e o IB apaga `--ib-superficie-marcada`
e pinta a linha marcada com o papel.

## VEREDITO · ENTRA DIFERENTE — a lavagem sobe pra linguagem, derivada pelo pai, com o alfa do app
**pai**: ds-diletta **v3.11.0** · **data**: 2026-10-13

### O que decidiu

A sua frase: *«derivável por cada um é derivado por cada um com um número diferente»*. O papel entra como `primaryWash`, o 67º da linguagem, e não como o valor do seu Dart emitido por mim: o pai deriva da paleta e nenhum filho declara nada. Claro: `primary08`, o mesmo valor de `primarySubtle`. Escuro: `primary04` a **20%**. Emitido nos dois modos como `--diletta-primaryWash`. O alfa é o do app, e não o do IB: o app já está em produção com 20%, o IB tem um dia.

### O que eu achei indo implementar

No claro `primaryWash` e `primarySubtle` empatam em hex, e as tabelas de resolução listam os dois. É esperado: no claro o degrau suave já é lavagem. O significado de `primarySubtle` perdeu «seleção» e ficou só contêiner sólido do `onPrimarySubtle`.

### O que eu recusei, e a condição de reabrir

- **emitir o valor do seu Dart**: não. Derivação é do pai, alias é do filho. Reabre se outra marca precisar de alfa diferente; aí o alfa vira campo da paleta.

### Os sete critérios

| critério | | |
|---|:-:|---|
| manutenção | ↑ | um alfa num lugar, não dois |
| escalabilidade | ↑ | todo filho recebe o papel de graça |
| aplicação | ↑ | o Dart do filho B e as 4 peças de seleção do IB |
| aderência ao mercado | ↑ | é a camada translúcida de estado do M3 |
| robustez | ↑ | o papel passa pelo gate de chegada na web |
| arquitetura limpa e simples | = | um papel novo apaga duas derivações locais |
| conciso | = | um `///` e uma linha de significado |

### O que você faz

`ref: v3.11.0`. No Dart, troque a derivação local de `primaryWash` pela do pai: zero pixel. No IB, apague `--ib-superficie-marcada` e leia `--diletta-primaryWash`: **muda pixel no escuro**, a linha marcada passa de 10% a 20%. No claro nada muda.
