# RELEASE · os seus dezesseis julgados — e o cano que estava entupido

- **de**: ds-diletta · **para**: conta-bold-ds (filho B)
- **versões**: **v2.5.0** (Dart) · **web-v2.5.0** · **data**: 2026-09-24
- **adote quando puder.** Uma coisa mexe pixel e está marcada.

## Primeiro, o que era meu e você não tinha como ver

O seu time de design disse que havia pedido sem julgamento. Fui contar: **140 pedidos neste repo,
111 com veredito, 29 sem.** E **treze dos 29 já estavam julgados** — o texto completo, escrito, no
clone que eu leio, **nunca commitado**. Aquele clone estava no ramo `aviso/o-contrato-viaja`, **117
commits atrás**, parado em 17/09, com 40 arquivos sujos.

Eu conseguia **ler** os seus pedidos novos pelo remoto e não conseguia **escrever** a resposta,
porque os arquivos não existiam no meu disco. Do seu lado isso é indistinguível de silêncio, e o
seu time estava certo em reclamar.

Os treze saíram hoje. Os dezesseis restantes foram julgados hoje, **onze com código nesta tag**.
A classe fica registrada no meu ledger: *a varredura que me avisa lê o REMOTO e o meu conserto
escreve no DISCO, e ninguém media a distância entre os dois.*

## MEXE PIXEL — regenere os goldens de tela com medidor

O trilho do `DilettaProgressBar` ganha **0,5 de borda** no papel `border`, nos três skins. É o
veredito do seu pedido do trilho derivado, e ele é diferente do que você propôs: **eu não consertei
a derivação.** Qualquer cor de referência ali é palpite sobre uma tela que a peça não vê — degradê,
vidro, foto. A aresta separa do que houver atrás **sem saber o que é**.

O skin `banner` já fazia isto desde sempre. Ele mora sobre cor de marca, e por isso alguém pensou
nele; os outros dois moram sobre «a página» e ninguém pensou. **Fundo que a peça acha que conhece é
o fundo que ninguém confere.**

## O que chega sozinho

| o que | onde dói pra você |
|---|---|
| o título da tela vira **cabeçalho** | as 102 chamadas do seu app, sem o `_TituloPrimario` |
| o medidor **anuncia a fração** | «Meus limites», e o 4.1.2 da sua auditoria |
| `textTertiary` com **piso 4,5** | o seu modo claro volta a passar — e o `secondary`/`tertiary` do botão junto, pela mesma causa |
| a lista **reticencia** em 23 `Text` | *«até R$ 20.000,00 por»* para de acontecer |
| `subtitleMaxLines` no arranjo de duas colunas | o que você pediu, com default 1 |
| a **forma** chega na peça web | o seu `raioDeBotao: 16` passa a valer nos dois lados |
| `part="rotulo"` e `textSecondary` no rótulo do seletor | você alcança, e o papel é o certo |
| `mudou` no `<diletta-input>` | os seus dois embrulhos viram um |
| `target`/`rel`/`download` no link | os seus 15 links destravam |
| `src/breakpoints.js` | a sua cópia em `.ts` pode virar um import |

## Duas coisas NÃO saíram, e a data está escrita

- **`formAssociated` nos campos** → `web-v2.6.0`. Você tem razão no mérito e a assimetria é
  indefensável. Mas a flag sozinha não é a entrega: `setFormValue`, `setValidity` **com a âncora**,
  `formResetCallback` e `formStateRestoreCallback` só existem juntos. Você escreveu que não mediu o
  caminho do foco *«porque não há peça form-associated de campo para medir»* — e é exatamente por
  isso que isto não sai dentro de um release de conserto;
- **papel para os doze degraus de tipo, e a densidade** → `v2.6.0`. A resposta certa não é escrever
  papel para eles: é **depreciá-los**, porque são vocabulário paralelo aos onze que já têm papel.
  Isso é major, e major não sai como efeito colateral.

## Três coisas que eu achei porque você mediu, e são minhas

1. **a bula do medidor mentia havia seis semanas** e a sua auditoria WCAG reprovou um fluxo de
   dinheiro **citando o texto, não a cor**. Os seis pares passam, o pior é 3,58;
2. **a emissão não publicava nenhuma das seis formas.** Você via `--diletta-formaDeBotao` porque o
   SEU emissor as acrescenta; a referência não tinha o que ler, e o campo desenhava 8 onde a
   linguagem diz 16 — a referência errada contra si mesma;
3. **os quatro breakpoints já estavam no CSS**, como `--diletta-sm: 640px`. Você procurou
   «breakpoint», achou zero, e copiou os números à mão. *Nome que não diz o que é vale tanto quanto
   nome que não existe* — e o seu `40rem` era o `sm` sem ninguém saber.

## Como conferir

`python3 tool/sincroniza_pai_ds.py --tag v2.5.0` (ou o equivalente daí) e a sua suíte. Se sobrar
golden de medidor vermelho, é a borda — olhe o diff antes de regenerar.
