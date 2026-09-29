# PEDIDO · A busca e o código não leem a moldura do campo — o canto e a borda ficam cravados

- **de**: conta-bold-ds (filho B) · **para**: ds-diletta
- **consome**: ds-diletta `v2.5.0` (pino do pai, `packages/coreflow/pubspec.yaml:23`); o app vendoriza a
  `v0.113.0` deste repo, com o avô em `v0.204.0`. **Medido também na ponta, `v3.0.0` (`c7c9c94`)**: as
  linhas abaixo são dela, e são as mesmas na `v2.5.0`
- **bloqueante?**: **não**
- **irmãos**: [a ajuda do seletor](2026-09-29-o-seletor-e-o-campo-de-data-nao-repassam-a-ajuda-e-o-campo-de-valor-nao-tem-erro.md)
  e [o placeholder e o desligado](2026-09-29-o-placeholder-e-o-desligado-pintam-diferente-em-cada-peca-de-campo.md),
  da mesma varredura
- **não reabre** a sua recusa de 14/09 (*«raio por componente»*): não peço raio próprio para a busca,
  peço que ela leia o da família em que já está
- **não é peça nova**: o `busca()` não se aplica

## Falta

1. **O `DilettaSearchInput` ler `formaDoCampo`** em vez do `all16` cravado.
2. **O quadrado do `DilettaOtpInput` ler `s.border` em repouso** em vez de `s.palette.neutral07` — o
   degrau cru da rampa, que não troca no escuro nem segue a borda que o filho declara.

## Número

| peça | canto | borda em repouso | onde |
|---|---|---|---|
| `DilettaInput` (seletor e campo de data de carona) | `s.formaDoCampo` — `formaDeCampo` › `raioDeCampo` › 16 | `s.border` (declarável: `bordaClara` / `bordaEscura`) | `diletta_input.dart:346`, `:312`; `diletta_scheme.dart:965-968` |
| `DilettaSearchInput` | **`DilettaRadius.all16`, cravado** | `s.border` | `diletta_search_input.dart:119`, `:118` |
| `DilettaOtpInput` | `all8` (forma própria, e fica) | **`s.palette.neutral07`, cru**, 1,5 | `diletta_otp_input.dart:198`, `:206-207` |

**A busca.** O `///` da própria `formaDoCampo` diz que ela tem *«dois sítios com um canal só»* — o
campo e o seletor (`diletta_scheme.dart:963-964`). A busca é o terceiro campo e ficou fora: o raio 16
dela foi medido em 19/08 (`diletta_search_input.dart:26`), antes de a forma do campo ser
declarável (`v0.184.0`). **No Bold não aparece**, porque o nosso campo é 16
(`coreflow/lib/src/coreflow_radius.dart:21`). Aparece no filho que declarou 4 — o terceiro, que foi
quem pediu a forma: lá o campo sai com canto 4 e a busca na mesma tela com 16.

**O código.** Aparece no Bold, nos dois modos:

- **claro**: a borda do campo é `bordaClara` = `0x12000000`, preto a 7%
  (`bold_palette.dart:288`, `:429`); a do quadrado do código é `neutral07` = `#C6C6C6`
  (`bold_palette.dart:183`), a 1,5. O código sai com a borda bem mais escura que o campo acima dele;
- **escuro**: `neutral07` não troca de modo. A borda do campo cai em `bordaEscura` ou no branco a 8%
  (`diletta_scheme.dart:761`); a do quadrado continua `#C6C6C6`, um cinza claro sobre fundo escuro.

É a mesma classe que a sua `v0.74.0` limpou em 31 peças (*«pintavam o degrau CRU, congelados no modo
claro»*).

## Já tentei

Nada por fora: canto e cor estão dentro da peça, sem parâmetro.

## Conferi no pai

- As três peças na `v3.0.0` e na `v2.5.0` (`diletta_search_input.dart:119` e
  `diletta_otp_input.dart:198` e `:206-207` nas duas).
- Os seus vereditos da forma: `v0.184.0` (o raio do campo entra, com o seletor de carona) e 14/09 (a
  forma sobe por família, com `formaDeCampo`; recusa de raio por componente). A busca pertence à
  família *campo*, então isto é ela entrar na família, não um raio novo.
- O `///` do código (`diletta_otp_input.dart:10`, `:21-22`) declara os quadrados 40×40 e os estados
  por cor da rampa, vindos do desenho do primeiro filho. **O tamanho, o canto 8 e a espessura 1,5 eu
  trato como forma escolhida e não peço**; só a cor de repouso, que é degrau cru.

## Derivável?

Não.

## Se você disser não

A busca fica fora da forma declarada do campo, e o quadrado do código fica com borda de outra cor que
a dos campos da mesma tela — mais escura no claro e clara demais no escuro, no Bold de hoje.

## Não estou pedindo

1. **que o código perca o canto 8 ou os quadrados de 40** — é a forma dele;
2. **raio declarável só para a busca** — ela lê o do campo;
3. **mudar os três degraus de altura da busca** (`lg` 48 · `md` 36 · `sm` 28) — ficam;
4. **mexer nas cores de foco e de preenchido do código** (`s.primary`, `s.fg`) — já são papéis.

## Como o pai vai saber que funcionou

- num esquema com `formaDeCampo: 4`, o `DilettaInput` e o `DilettaSearchInput` saem com o mesmo canto;
- num esquema com `bordaClara` declarada, o quadrado vazio do `DilettaOtpInput` sai com a mesma cor de
  borda do `DilettaInput` em repouso, e no escuro troca junto com ele.

## Como cheguei aqui

A mesma varredura das peças de formulário que a designer pediu em 29/09 (ver o
[irmão da ajuda](2026-09-29-o-seletor-e-o-campo-de-data-nao-repassam-a-ajuda-e-o-campo-de-valor-nao-tem-erro.md)).

---

## Adendo do filho · 29/09, tarde — o item 2 pede o papel errado

O item 2 pede o quadrado vazio do código em `s.border`. Na mesma tarde, medindo a caixa do checkbox, o
`border` mediu **1,17:1** contra `surface` no Bold claro e **1,39:1** na referência. §1.4.11 pede 3:1
para a fronteira de controle. A tradução entre os modos continua certa. O papel é que não serve para
traço de controle. Está no [pedido do contorno](2026-09-29-a-caixa-vazia-do-checkbox-e-do-radio-nao-passa-3-para-1.md):
se ele entrar, o quadrado do código lê o papel que sair de lá, e não o `border`. O item 1 (a busca ler
`formaDoCampo`) não muda.

---

## VEREDITO · ENTRA O ITEM 1, e o item 2 espera o papel de contorno — como o seu adendo diz

**pai**: ds-diletta **v3.2.0** · **data**: 2026-09-29

| item | veredito |
|---|---|
| 1 · a busca ler `formaDoCampo` | **ENTRA** |
| 2 · o quadrado do código em `s.border` | **ESPERA** o papel de contorno de controle |

### O que decidiu

O item 1, a sua leitura do meu `///`: a `formaDoCampo` dizia *«dois sítios com um canal só»*, e a busca
era o terceiro campo, que ficou fora porque o 16 dela foi medido antes de a forma ser declarável.

O item 2, o seu adendo, que chegou enquanto eu escrevia: *«A tradução entre os modos continua certa. O
papel é que não serve para traço de controle.»* Eu já tinha trocado o quadrado para `s.border`, e
**desfiz**. O `border` mede 1,17:1 contra `surface` no Bold claro, e o `neutral07` que estava lá mede
1,71. Os dois reprovam o 3:1, e a troca pioraria o claro para consertar o escuro.

### O que eu fiz

- `DilettaSearchInput` lê `s.formaDoCampo`;
- o quadrado vazio do `DilettaOtpInput` **continua** `neutral07`, com a dívida escrita ao lado da linha:
  ele não troca de modo, e quem fecha é o papel do [pedido do contorno](2026-09-29-a-caixa-vazia-do-checkbox-e-do-radio-nao-passa-3-para-1.md).

### O que eu achei indo implementar

nada além do seu adendo. Ele achou o defeito da minha troca antes de ela sair.

### O que eu recusei, e a condição de reabrir

O item 2 reabre no dia em que o papel de contorno existir. Aí o quadrado lê esse papel, junto com o
checkbox e os dois rádios.

### Os sete critérios

| critério | | |
|---|:-:|---|
| manutenção | ↑ | um canal só para a forma do campo, agora com os três sítios |
| escalabilidade | ↑ | o filho que declara 4 tem busca e campo com o mesmo canto |
| aplicação | = | no Bold a busca não muda, porque o seu campo é 16 |
| aderência ao mercado | = | nada novo |
| robustez | ↑ | a troca que pioraria o contraste não saiu |
| arquitetura limpa e simples | ↑ | a busca lê o scheme, e não o próprio canto |
| conciso | = | nada novo para escrever |

### O que você faz

`v3.2.0`. A busca não muda no Bold. O código muda na hora do papel de contorno.

---

## Nota do pai · 29/09 — o item 2 saiu pelo papel de contorno

**pai**: ds-diletta **v3.3.0** · **data**: 2026-09-29

A célula vazia do `DilettaOtpInput` lê `contornoDeControle`, o papel que o seu adendo apontou, e não
`border`. Ele troca com o modo e passa 3:1 contra a superfície. **O que você faz:** `v3.3.0`.
