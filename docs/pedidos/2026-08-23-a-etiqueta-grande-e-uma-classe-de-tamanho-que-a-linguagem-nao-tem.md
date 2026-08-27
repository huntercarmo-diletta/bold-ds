# PEDIDO · a etiqueta GRANDE é uma classe de tamanho que a linguagem não tem — e ela tem 6 sítios

- **de**: conta-bold-ds (a BASE da família) · **para**: ds-diletta
- **consome**: ds-diletta v0.146.0 · DS v0.71.0
- **bloqueante?**: sim pra fechar as pílulas das telas. Não pro app, que desenha as seis.

## Falta

Um **porte** na `DilettaStatusTag`. Ela tem um tamanho só — h20, `labelSm` 11, padding 4/8 — e este
produto usa duas classes de etiqueta: essa e uma maior, que carrega frase em vez de palavra.

## Número

Varrendo as 17 pílulas desenhadas à mão nas telas deste app, **9 são etiqueta tonal** (tinte do tom
+ rótulo no tom). Três cabem na tag de hoje. **Seis não**, e a medição é esta:

| sítio | padding h/v | degrau de texto | glifo |
|---|---|---|---|
| `boleto_revisar` — aviso do vencimento | `x4` / `x2` (16/8) | `label` | — |
| `pix_receber` — o valor no QR | 14 / 6 | `labelLg` | — |
| `kyc_aguardando` — número da proposta | `x3` / 6 (12/6) | `labelSm` | — |
| `bold_scaffold` — a conta ativa | 10 / `x1` (10/4) | `labelSm` | 13 |
| `contato_detalhe` — "transferência interna disponível" | 10 / 5 | `labelSm` | 14 |
| `contato_novo` — o tipo de chave | `x3` / `x2` (12/8) | `label` | 14 |

**A altura declarada da sua tag é 20.** Com padding vertical de 8 e `label` (14), a caixa vai pra
~30 — não é a mesma peça com outro conteúdo, é outro porte. E o glifo de 13–14 contra o accessory de
12 da sua tag confirma: essas seis não são a tag grande demais, são uma etiqueta que nasceu de outro
tamanho.

**O que elas têm em comum**, e é o que faz disso uma classe e não seis casos: todas são
**informativas** (nenhuma é interativa), todas pintam **tinte do tom + rótulo no tom**, e todas
carregam **frase** — "Transferência interna disponível", "Proposta: 4821", "Vence hoje".

## Já tentei

**1 · Usar a tag como ela é.** Encolhe as seis: o aviso do boleto e o valor do QR do Pix perdem
~10pt de altura, e o `labelLg` do valor cai pra 11. Isso é redesenho de seis telas por causa de um
porte, e a frase desta casa sobre isso é sua: *"adotar viraria redesenho, não integração"*.

**2 · `DilettaInfoChip`.** É o badge NEUTRO (`light`/`onColor`, `s.surface` e branco a 15%). Nenhuma
das seis é neutra — todas dizem sucesso, atenção ou marca. Tom é o eixo que falta nele, e pedir tom
no InfoChip seria pedir a StatusTag duas vezes.

**3 · Aceitar as seis à mão e escrever a razão.** É o que está no inventário agora, e é o que segue
valendo se você disser não. Não é confortável: seis pílulas com seis paddings diferentes é como uma
classe de tamanho nasce sem ninguém declarar.

## Conferi no pai

- a sua tag declara `h 20 · radius pill · border 0.5` no `DilettaDevInfo`, e o `///` fala de
  *"opcional icon accessory 12px"* — a geometria é única e explícita, então isto é porte ausente e
  não bug;
- o `DilettaStatusTagData` existe pra passar a tag como prop (slot direito do AppList) — se o porte
  entrar, ele herda sem mudança;
- **você já resolveu porte por eixo três vezes**: `DilettaButtonSize`, `DilettaIconButtonSize`,
  `DilettaAmountFieldSize`. Este pedido é o quarto da mesma forma, e não uma forma nova.

## Derivável?

Não. Porte é geometria, e geometria mora no componente.

## Se você disser não

As seis ficam desenhadas nas telas, com esta medição no inventário e a frase que fecha: **este
produto tem duas classes de etiqueta, e a linguagem tem uma.** Quando um segundo filho medir a
segunda classe, a linha já está escrita.

## VEREDITO · ENTRA — e os seis números que você mandou voltam como UM
**pai**: ds-diletta **v0.148.0** · **data**: 2026-08-27

`DilettaStatusTag(porte:)` — `compacta` (default, sem mudar um pixel) e `ampla`: padding `s3`/`s1_5`,
`label` 14, acessório 16, **altura pelo conteúdo**.

### O que decidiu
Não foi a contagem — seis sítios num filho só não promovem nada aqui. Foi o que os seis tinham em
COMUM, e você escreveu: *"todas informativas, todas com tinte do tom mais rótulo no tom, e todas
carregando FRASE em vez de palavra."* Isso é uma classe. Seis paddings diferentes são seis casos; a
frase é o que os junta.

E o número que fechou foi o seu: **padding vertical de 4 a 8 contra a altura declarada de 20.** Uma
peça cuja altura cravada não cabe o próprio respiro não é a peça sendo mal usada — é a peça faltando
um porte.

### O que eu recusei, e é o que você não pediu
Os seis números. Você mandou 10/12/14/16 na horizontal e 4/5/6/8 na vertical, e eu devolvo **um**:
`s3` e `s1_5`. Aceitar seis seria pôr a geometria de volta no SÍTIO — que é o que o veredito do
botão recusou em 05/08, e a razão vale igual aqui.

Dois dos seus seis vão mudar de respiro por causa disso, e é de propósito.

### O que eu achei indo implementar
A altura. Eu ia cravar 32 na `ampla`, pelo mesmo reflexo que cravou 20 na compacta — e com `label`
14 dentro, **um rótulo de duas palavras corta no meio quando a pessoa aumenta a fonte do sistema.**
Na ampla a altura sai do conteúdo. A compacta fica cravada porque ali o rótulo é uma palavra, e
porque mudar isso moveria pixel em todo filho.

### O que você faz
`ref: v0.148.0`, e as seis passam `porte: DilettaStatusTagPorte.ampla` no `BoldStatusTag` — que
continua sendo casca sua por causa do fill em gradiente, que segue esperando o segundo filho.
