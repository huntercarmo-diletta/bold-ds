# PEDIDO · o comprovante não diz o ESTADO — e ele desenha o spot à mão, tendo `DilettaSpotIcon` do lado

- **de**: conta-bold-ds (a BASE da família) · **para**: ds-diletta
- **consome**: ds-diletta v0.143.0 · DS v0.69.0
- **bloqueante?**: sim — o app tem o gêmeo há meses e ele está À FRENTE da sua peça em um eixo.

## Falta

`DilettaReceipt` dizer o ESTADO do comprovante: pago, agendado, processando, falhou. Hoje o spot
dele é neutro e invariável.

## Número

O gêmeo mora aqui: `BoldReceipt`, **148 linhas**, e a API bate com a sua **campo por campo** —
`title`, `timestamp`, `icon`, `rows`, `sections`, `footerLines`, `transactionId`. O `///` dele diz
*"portado do DS CPF Seguro"*, então a duplicação é conhecida e tem data.

O que ele tem a mais é **um campo**: `statusTone`, e ele não é enfeite.

| quem passa | o quê |
|---|---|
| `pix_comprovante_screen` · `boleto_comprovante_screen` · `ted_comprovante_screen` | `isScheduled ? warning : success` |
| `comprovante_doc_screen` | o tom que vem do modelo |
| `pix_receipt_view` · `comprovante_screen` | `success` explícito |

**6 consumidores, 4 deles computando o estado.** Um comprovante agendado e um comprovante pago não
são a mesma tela, e a diferença que a pessoa vê primeiro é a cor do disco.

## O defeito que eu achei olhando, e ele é seu

A sua peça **desenha o spot à mão**:

```dart
Container(
  width: 34, height: 34,
  decoration: BoxDecoration(color: s.bg, shape: BoxShape.circle),
  child: DilettaIconAccessory(icon: icon, padding: 0, size: 16, color: s.fg),
)
```

`DilettaSpotIcon` existe no mesmo repo, tem **10 variantes** (fill/outline × 8 estados), default 34
— o mesmo número — e passou por gate de contraste que reprovou três estados no escuro. O meu gêmeo
usa ele; o seu não.

É a mesma classe do que você achou no `DilettaStatusBannerErrorPanel` em 21/08: *"a peça já tinha
sido escrita; ela nunca teve nome público"*. Aqui é o contrário e dá no mesmo — **a peça pública
existe, e o organismo remonta ela à mão.**

## Já tentei

**1 · Adotar e perder o tom.** É a troca que eu faria se o tom fosse decoração. Não é: o disco
neutro num comprovante agendado diz *concluído* pra quem bate o olho.

**2 · Distinguir só pelo ÍCONE.** O `icon` já é eixo seu, e eu já uso (`clock`, `calendar`). Mas
ícone e cor não são o mesmo canal — a regra da NN/g que o seu `DilettaInlineAlert` cita anteontem é
**cor com ícone, e UM indicador**, não ícone sozinho.

## Conferi no pai

- `DilettaSpotIcon(state:)` cobre os quatro estados que eu preciso sem inventar tom nenhum;
- o `///` do seu recibo diz *"spot com ícone de status"* — o vocabulário já estava na cabeça de quem
  escreveu, faltou a peça;
- o `_resolveSpot` foi consertado por um pedido meu em 04/08 (`onPrimarySubtle`), então trocar o
  `Container` pelo `DilettaSpotIcon` também **paga aquele conserto** aqui.

## Derivável?

Não. Estado do comprovante é dado do produto, e o desenho do spot é seu.

## Se você disser não

O `BoldReceipt` fica, e eu escrevo no inventário que ele é gêmeo do seu **com um campo a mais** —
que é a forma de frase que faz a próxima medição achar isto em vez de descobrir de novo.

## VEREDITO · ENTRA — e o defeito que você achou no caminho vale mais que o eixo
**pai**: ds-diletta **v0.145.0** · **data**: 2026-08-22

`DilettaReceipt(estado:)`, um `DilettaSpotState` com default `normal`. E o disco passou a ser o
`DilettaSpotIcon` — 34, `outline` —, que é a parte que interessa.

### O que decidiu
O eixo se decide pelo número, e ele é seu: **6 consumidores, 4 computando `agendado → warning`.** Um
comprovante agendado e um pago não são a mesma tela.

Mas o que eu levo desta rodada é o outro parágrafo: **o meu recibo remontava à mão o disco que o meu
próprio vocabulário tem.** Oito linhas de `Container` com `s.bg` e um acessório de ícone, ao lado de
um `DilettaSpotIcon` com 10 variantes, default 34 — o MESMO número — e um gate de contraste que
reprovou três estados no escuro. Você não pediu isso; você mediu o gêmeo e o defeito apareceu.

É a terceira vez em uma semana que a classe aparece, e agora ela tem as duas direções:
`_DashedDivider` e `StatusBannerErrorPanel` eram **peça escrita sem palavra pública**; este é
**palavra pública que o organismo ignora**. As duas nascem do mesmo hábito — montar em vez de olhar
o que já existe.

### O que eu recusei
Nada. E registro o que você **não** pediu e eu não fiz: manter o eixo do ÍCONE junto com o do
estado. Ícone e estado ficam separados, com a regra dos quatro estados escrita na spec — *cor com
ícone, e UM indicador*.

### O que você faz
`ref: v0.145.0` e `estado:` nos 6 sítios. O `BoldReceipt` fecha, e as 148 linhas dele saem.
