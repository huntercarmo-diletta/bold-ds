# PEDIDO · O `success` reprova em AA como TEXTO no modo claro — e o conserto está dentro da própria rampa

- **de**: conta-bold-ds (filho B) · **para**: ds-diletta
- **consome**: ds-diletta `v0.194.3` · `web-v0.194.3`
- **bloqueante?**: **não** — eu assinei a dívida e sigo para homologação com ela declarada. Mando
  porque não é uma tela minha: **o app reprova no mesmo ponto, com o mesmo hex.**
- **precedente**: [o papel `primary` reprova em AA nos dois modos](2026-07-31-o-papel-primary-reprova-em-AA-nos-dois-modos.md) — veredito **ENTRA (pela TINTA, não pelo degrau)**, `ds v0.22.0`. É a mesma classe e eu proponho a mesma forma de conserto.

## Falta

O `success` do modo claro não alcança 4,5:1 sobre a superfície, e é usado como texto nos dois produtos.

## Número

`#0E9154` sobre branco dá **4,04:1**. O piso de AA para texto normal é 4,5.

**Não é caso meu.** Fui conferir se a peça era minha antes de escrever, e encontrei isto no app:

```dart
// app-newbold · design_system/widgets/bold_list.dart — BoldListAmount
final text = credit ? '+  $value' : negative ? '—  $value' : value;
style: BoldType.title.copyWith(
  fontSize: 14, fontWeight: FontWeight.w600,
  color: credit ? c.success : c.textPrimary,
)

// app-newbold · design_system/theme/bold_colors.dart
static const Color success04 = Color(0xFF0E9154);   // base (Redesenho v.01)
static const Color success = success04;
```

O mesmo hex que o meu `--cps-success` recebe do pacote. Medido nos dois:

| | tamanho | piso | medido | |
|---|---|---|---|---|
| **app** · valor de crédito no extrato | 14px peso 600 | 4,5 | **4,04:1** | reprova |
| **IB** · célula de crédito do extrato | 12px peso 400 | 4,5 | **4,04:1** | reprova |

14px com peso 600 **não é texto grande** pela 1.4.3 — o limiar é 18,66 em negrito ou 24 em qualquer
peso. Os dois caem no piso cheio.

**Consumidores**: 11 leituras de `--cps-success` aqui (5 como texto, 3 como fundo) e **69** de
`c.success` no app. É o par de dinheiro do extrato nos dois lados, e a lista de transações do app é
a tela mais aberta do produto.

### A rampa, para mostrar que o conserto mora dentro dela

Sobre o branco do claro, piso 4,5:

```
success01  #0A3F24   12,00:1  passa
success02  #12693A    6,76:1  passa          ← o conserto
success03  #1E8F4E    4,12:1  REPROVA
success04  #0E9154    4,04:1  REPROVA        ← a base de hoje
success05  #2FD27A    1,98:1  REPROVA
```

**O degrau vizinho não salva** — `success03` dá 4,12 e continua abaixo. Tem que ser o `02`.

E o escuro **não é tocado**: lá o papel já aponta para `success05`, que dá 9,18:1. O conserto é só
do lado claro, exatamente como foi no `primary` da `v0.22.0`.

**Como FUNDO também melhora.** O `success` sólido com glifo branco existe nos dois (`BoldSpotTone.
success => _SpotSpec(success04, white)`): branco sobre `#0E9154` dá 4,04:1 e sobre `#12693A` dá
**6,76:1**. Não há troca — o mesmo passo conserta os dois usos.

## Já tentei

**Trocar a tinta na minha folha de componente.** É pintar por cima da linguagem, que é a forma exata
que produziu a rampa invertida da Matera — e o `///` do meu próprio gate já diz que a correção
provável é *"o PAPEL escurecer no claro, na origem"*.

**Tirar a cor da célula pequena e deixar só o sinal `+`.** Chegou a ser a minha recomendação interna
e eu a **retirei** depois de medir o app: o `'+  $value'` em verde é decisão DELE, e consertar um
lado de uma decisão compartilhada é como se fabrica divergência. Eu passei o mês desfazendo
divergência; não vou criar uma para fechar um número.

**Aumentar o degrau do texto.** Levaria a célula de 12 para 24px para cair no piso de 3:1. É mudar o
desenho da tabela para acomodar a cor, e nenhuma tabela de extrato tem valor em 24.

**Assinar e seguir.** Foi o que eu fiz — a dívida está declarada, com data e nome, e travada em
gate. Este pedido é o caminho para pagá-la, não um pedido para desbloquear alguma coisa.

## Conferi no pai

Fui escrever que o papel estava errado, e parei no seu veredito de 31/07: você já respondeu esta
classe uma vez, e respondeu **corrigindo a tinta e não o degrau** — *"ENTRA (pela TINTA, não pelo
degrau)"*. Na ocasião você contou os consumidores do par e mostrou que três das quatro linhas da
minha tabela não eram defeito, porque ninguém desenhava aqueles pares.

Então já vim com a contagem feita, para poupar a viagem: **os dois pares deste pedido têm consumidor
real** — `success` como texto (5 aqui, e o valor de crédito no app) e `success` como fundo com
glifo branco (3 aqui, o `SpotTone.success` no app). Se a sua contagem no `lib/src` do DS disser
outra coisa, ela ganha da minha.

## Derivável?

Sim, e é uma linha: o papel `success` do esquema CLARO passa a apontar para `success02` em vez de
`success04`. Não peço primitiva nova, não peço nome novo, não peço eixo. A rampa já tem a cor.

O que eu **não sei** e é seu: se `success04` é a cor da MARCA de sucesso — aquela que aparece num
selo, num gráfico, num ilustrativo — e não a tinta de texto. Se for, o conserto talvez seja um papel
separado para texto, e aí é forma e não valor. Você é quem sabe qual dos dois o `success` é.

## Se você disser não

Eu sigo com a dívida assinada, que já está escrita:

> `## ASSINATURA — 18/09/2026 · Tatiana Hasimoto, design do Conta BOLD`
> São 20 regras, e elas seguem para homologação assim, por decisão declarada.

O preço não é meu, é do leitor: o valor de dinheiro que entrou na conta é o número que mais
importa na tela mais aberta dos dois produtos, e ele é o que está abaixo do piso. Não trava
entrega nenhuma — só continua sendo verdade.

## Não estou pedindo

1. **Que a marca fique mais escura.** Peço o papel de TEXTO no claro; se o verde de marca precisa
   continuar `#0E9154` num selo ou num gráfico, os dois podem coexistir — o piso de gráfico é 3:1 e
   `success04` passa nele;
2. **nada no modo escuro.** Lá o papel dá 9,18:1 e está certo;
3. **paridade de rampa com o app.** As duas já são a mesma rampa; é justamente por isso que o
   defeito é o mesmo;
4. **que você conserte o app.** Isso é conversa nossa com o time dele — mas ele herda pelo mesmo
   caminho, e é por isso que o pedido vale por dois.

## Como o pai vai saber que funcionou

O gate que eu já rodo aqui, e que hoje lista esta regra como dívida:

```
--cps-success sobre --cps-surface, modo claro   →  espera ≥ 4,5:1
```

E a catraca que vem junto: quando o papel for corrigido, a linha **some da minha lista de dívida** e
o teste que exige igualdade exata fica vermelho — me obrigando a apagar a dívida em vez de esquecê-la
lá. O conserto se anuncia sozinho deste lado.

Do seu lado, o que eu escreveria é a mesma medição contra as duas superfícies do esquema, para os
papéis que TÊM consumidor de texto — porque foi exatamente a falta dessa contagem que fez a minha
tabela de 31/07 ter três linhas que não eram defeito.

## VEREDITO do pai — 2026-09-18 · `v0.200.0`

> Transcrito do ledger do pai (`ds-diletta/docs/PEDIDOS.md`, commit `1067760`) para a resposta
> morar junto da pergunta, como o contrato manda. O texto é dele, palavra por palavra.

**ENTRA DIFERENTE — pela TINTA, não pelo degrau. É a QUINTA vez que a mesma lição volta, e desta vez o buraco é de simetria e é meu.** O precedente que ele trouxe (18/08, `primaryOnSurface`) decide **contra a forma pedida**: *tinta é consequência de legibilidade, preenchimento é decisão de marca*. Mover o papel `success` moveria o selo, o gráfico e o sólido com glifo branco — cujo piso é 3:1 e que passa. **Medindo a MINHA paleta de referência como texto sobre a superfície, cada uma das QUATRO famílias reprova em UM dos dois modos**: `success` 4,06 · `warning` 3,51 · `secure` 4,00 no claro, `error` 3,58 no escuro — nenhuma passa nos dois, nenhuma falha nos dois (a primeira tabela que eu escrevi tinha duas linhas erradas, e quem as corrigiu foi o teste). Em 18/08 eu dei piso de tinta à família da MARCA e não estendi às de ESTADO. Entram quatro papéis derivados (`successOnSurface`, `errorOnSurface`, `warningOnSurface`, `secureOnSurface`) com `_primeiroQueAlcanca(4,5)` por modo — que **devolve o degrau 02 na rampa dele**, exatamente o que ele pediu, e mantém o 03 na de referência. **E a linguagem tinha o mesmo desenho com o mesmo defeito, num par DIFERENTE**: `diletta_amount.dart:72` pinta o valor de crédito com `s.success` sobre `successSubtle` — **3,57:1** —, e o papel certo já existia (`onSuccessSubtle`, 5,52) sem consumidor. Das 8 leituras de cor de estado nos meus widgets, 7 são glifo (piso 3:1, seguem) e a oitava é a do dinheiro. **E o papel novo acordou um gate calado**: `DilettaAppList` cravava `palette.secure03` no glifo de `secure`, que sobre a superfície escura dá **2,21** — abaixo do piso gráfico, invisível, e nenhuma régua via porque leitura crua não aparece em lugar nenhum. Papel derivado é de graça pro filho: minor. Critério: aderência ao mercado · robustez · escalabilidade

**Entregue em**: **v0.200.0** — veredito e entrega no mesmo dia (e **v0.200.1** meia hora depois: a `pinta` tomava o foco ao montar, e quem viu foi o PNG)
