# PEDIDO · O trilho do medidor é derivado contra uma página que ninguém pinta — e some no claro

- **de**: conta-bold-ds (filho B) · **para**: ds-diletta
- **consome**: ds-diletta `v0.204.0` (o que este repo pina, e o que o app vendoriza desde 23/09)
- **bloqueante?**: **sim para um fluxo de dinheiro no modo claro**, e o modo claro deste app existe
  (tela de Aparência, três opções, persistida). O medidor de teto de «Meus limites» é a única
  representação visual de *quanto do meu teto já foi* — e no claro o trilho dele mede **1,02:1**
  contra o que está atrás. WCAG 2.2 SC 1.4.11 pede 3:1 para objeto gráfico. Não bloqueia o escuro.
- **não é peça nova**, por isso não abre com `DilettaManifesto.busca` (contrato, `v0.206.0`). É a
  derivação de um papel que existe, e que esta casa já pediu duas vezes (`v0.63.0` o `tone`,
  `v0.64.0` o trilho claro). O irmão deste pedido, sobre a **semântica** do mesmo medidor, está em
  [o medidor não se lê](2026-09-21-o-medidor-nao-se-le-nem-pela-semantica-nem-pela-bula.md).

## Falta

`_trilhoDerivado` escolhe a cor do trilho medindo separação **contra `p.bgClaro ?? p.white`** — uma
cor lisa. Só que nenhuma tela deste produto pinta essa cor lisa atrás do medidor: a `CoreflowPagina`
pinta **degradê**, e na lista de tetos a barra ainda está sobre um card de **vidro**
(`cardDeVidro: true`, `bold_palette.dart:565`). A separação que a função garante no papel (≥ 1,1)
não existe no pixel.

## Número

**A derivação** (`diletta_scheme.dart`, `v0.204.0`):

```dart
// :472 — modo claro
final trilho = _trilhoDerivado(p.bgClaro ?? p.white, p.primary04, p.error04, [...]);
// :965
final separam = candidatos.where((c) => dilettaContrastRatio(c, pagina) >= 1.1).toList();
final fecham  = separam.where((c) => pior(c) >= 3.0).toList();
```

`pagina` é a referência de separação. Ela recebe `p.bgClaro`. **Ninguém pinta `p.bgClaro` atrás
do medidor.**

**Medido no simulador** (iPhone 16, iOS 26.5, modo claro, tela 01 de «Meus limites», app com o
pacote da `v0.204.0`), pelo `revisor-visual` em 23/09, em quatro pontos ao longo da barra
(x = 150, 250, 340, 368):

| | cor | contra a superfície atrás | Δ por canal |
|---|---|---|---|
| trilho (`trilhoDeMedidor`) | `#F5DCE6` / `#FAF0F4` | **1,02:1** | ≤ 3/255 nos quatro pontos |
| preenchimento (`primary`) × trilho | — | **2,68:1** | abaixo do piso 3,0 que a própria função exige |

Para comparação, o **escuro** passa: a página escura é quase lisa (`p.bgEscuro ?? p.neutral01`) e
o trilho `#3D3939` mede 9,73:1 contra ela — e é esse trilho que o espelho da biblioteca no Figma
desenha nos dois modos, o que fez a divergência passar despercebida até a comparação app × Figma.

**O preço para quem usa**: na lista, a barra do Pix a 24% é um traço rosa curto sem trilho visível
— a pessoa não vê onde a barra *termina*, então não vê que está a 24%; vê um risco. O texto que
acompanha a cor (veredito de 09/08) diz «perto do teto» e «consumido», mas só nos dois degraus de
cima: no `normal`, que é onde a maior parte dos dias acontece, a barra é a única informação.

## Já tentei

**Do lado do consumidor não há por onde.** O trilho é papel do esquema (`s.trilhoDeMedidor`) e a
`DilettaProgressBar` o lê direto (`:121`); não há campo de cor de trilho na peça, e pintar um
`Container` atrás dela seria esta casa desenhando o trilho por fora do medidor — a mesma classe da
cópia privada que o pai apagou na `v0.31.0`.

**Declarar `bgClaro` como a cor do degradê** não resolve: o degradê tem dois extremos, e o card de
vidro é uma terceira superfície. Uma cor de referência não descreve três fundos.

## Conferi no pai

- `_trilhoDerivado` recebe UMA cor de página, nas duas chamadas (`:472` e `:676`).
- O `///` do próprio esquema já registra a lição, duas vezes, sobre os irmãos deste papel
  (`warningGrafico`, `trilhoDeMedidor`): *«o papel não é o degrau 03 da rampa»*. Este pedido é a
  mesma lição com outro sujeito: **a página não é a cor da página**.
- O pai já resolveu o mesmo problema para outra peça: o vidro do rodapé (`DilettaGlassSurface`,
  desde 17/08) pinta sobre qualquer fundo porque carrega a própria receita, não porque derivou de uma
  cor de página.

## Derivável?

**Não a partir de uma cor.** O que é derivável é o **piso**: o trilho precisa separar ≥ 3:1 do
preenchimento (já exige) **e** ser visível contra a superfície mais clara que o produto pinta atrás
dele — e essa superfície o filho conhece, o pai não. Duas saídas honestas, e a decisão é sua:

1. **O filho declara a superfície de referência do medidor** (a mais clara sobre a qual ele pode
   cair: no Bold, o topo do degradê sobre vidro, `#FFEDF3`), e `_trilhoDerivado` deriva contra ela.
   Muda a paleta, não a peça.
2. **O trilho carrega a própria separação**, como o vidro do rodapé: um degrau com alfa sobre o que
   estiver atrás (`onSurface` a ~12%, que dá ≥ 1,3:1 sobre qualquer fundo claro deste produto).
   Muda a peça, não a paleta.

A 2 é a que não volta a quebrar quando o filho mudar o degradê.

## Se você disser não

O medidor continua sendo um risco rosa sem fim visível no claro, num fluxo em que a pessoa decide
quanto dinheiro mandar olhando para ele. E o espelho no Figma continua mentindo por omissão: ele
desenha `#3D3939` nos dois modos, então o desenho passa e o aparelho não.

## Não estou pedindo

- Trocar o trilho do **escuro** — passa com folga (9,73:1).
- Mexer no piso de 3:1 entre preenchimento e trilho — está certo, e é ele que hoje reprova 2,68.
- Um campo `trackColor` na `DilettaProgressBar` — seria o consumidor pintando o trilho por fora, e
  o pai já apagou uma cópia dessas.

## Como o pai vai saber que funcionou

```dart
// gate deste lado quando a tag sair: renderizar a barra sobre a CoreflowPagina
// clara com card de vidro e medir o pixel do trilho contra o pixel logo acima
// dele — ≥ 3,0 no `normal`, nas duas pontas da barra.
```

E do lado dele, o gate que já existe para `warningGrafico` (piso medido, não declarado) ganha o
trilho como segundo sujeito, com a superfície de referência vinda do filho.

## Como cheguei aqui

O `revisor-visual` comparou seis telas do app com os frames do Figma em 23/09 e a primeira
divergência da lista, por gravidade, foi esta. Fui ler a derivação esperando um número errado e
achei a referência errada: a função está certa para a página que ela imagina, e a página que ela
imagina não existe neste produto.

---

## Veredito · ENTRA DIFERENTE — a peça para de DEPENDER de saber o que está atrás
**pai**: ds-diletta **v2.5.0** · **data**: 2026-09-24 · **MEXE PIXEL**

Você achou o defeito exato: `_trilhoDerivado` mede separação contra `p.bgClaro ?? p.white`, uma cor
lisa, e nenhuma tela sua pinta essa cor lisa atrás do medidor — a página é degradê e a barra ainda
está sobre card de vidro. **A separação de ≥1,1 que a função garante no papel mediu 1,02:1 no
pixel.**

**E é por isso que eu não consertei a derivação.** Qualquer cor de referência que eu escolha ali é
um palpite sobre uma tela que eu não vejo: degradê, vidro, foto, card sobre card. Medir contra a
página é medir contra a que o filho **declarou**, e ele pinta outra — e isso vale para qualquer
filho, não só para você. Uma função cega não fica menos cega com um chute melhor.

Então a aresta deixa de ser decoração e vira estrutura: **o trilho ganha borda de 0,5 no papel
`border`, nos três skins.** A borda separa o trilho do que houver atrás **sem saber o que é**, que
é a única garantia que uma peça cega pode dar.

O skin `banner` já fazia exatamente isto, com `whiteAlpha38`, desde sempre — ele mora sobre cor de
marca e por isso alguém pensou nele. Os outros dois moram sobre *«a página»*, e ninguém pensou
**porque «a página» parecia conhecida.** Essa é a lição, e ela não é sobre medidor: *fundo que a
peça acha que conhece é o fundo que ninguém confere.*

**Isto MEXE PIXEL em todo medidor de todo filho** — meio ponto de borda. Está declarado no
CHANGELOG como tal, e o gate cobra a aresta nos três skins.

**Os sete**: manutenção ↑ · escalabilidade ↑ vale sobre qualquer fundo · **aplicação ↑ decide** — o
medidor de teto volta a existir no claro · aderência ao mercado ↑ WCAG 2.2 §1.4.11 · **robustez ↑
decide** — deixa de depender de um palpite sobre a tela do filho · arquitetura ↑ o skin irmão já
tinha a resposta · conciso = · **ressalva declarada: muda pixel, e a decisão é minha porque a
alternativa é um medidor invisível.**
