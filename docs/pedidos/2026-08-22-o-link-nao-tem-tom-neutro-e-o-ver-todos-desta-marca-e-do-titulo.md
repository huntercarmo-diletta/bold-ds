# PEDIDO · o link não tem tom NEUTRO, e o "Ver todos" desta marca é da cor do título

- **de**: conta-bold-ds (a BASE da família) · **para**: ds-diletta
- **consome**: ds-diletta v0.143.0 · DS v0.69.0
- **bloqueante?**: sim pra apagar o gêmeo. Pequeno: é um valor de enum.

## Falta

Um tom **neutro** no `DilettaTextLink` — o link que não pinta de marca, e sim da tinta do texto ao
lado.

## Número

`DilettaSeeAllLink` e o meu `BoldSeeAllLink` têm a **assinatura idêntica**:

```dart
const DilettaSeeAllLink({super.key, this.onPressed, this.label = 'Ver todos'});
const BoldSeeAllLink({super.key, this.onPressed, this.label = 'Ver todos'});
```

Mesma prop, mesmo default, mesma palavra. A única diferença é a TINTA:

| | você | eu |
|---|---|---|
| tom | `DilettaTextLinkTone.brand` → `s.primaryOnSurface` | `c.textPrimary` |
| razão | link é ação, e ação é da marca | *"Ver tudo em Label/large na mesma cor do título"* — spec Redesenho v.01 |

São **3 sítios** (duas seções da home e o hub do Pix), e nos três o "Ver todos" fica na mesma linha
do rótulo da seção. Ali o rosa não é ênfase, é competição: a linha tem duas palavras, e a que
importa é a da esquerda.

## Já tentei

**1 · Aceitar o `brand`.** Muda o desenho aprovado em 3 lugares, e a mudança não é minha de fazer.

**2 · Embrulhar o seu com `DefaultTextStyle`.** O `///` dele resolve a cor por dentro, no `build` —
o estilo de fora não alcança.

**3 · Usar `DilettaTextLink` direto com um tom que sirva.** São dois valores, `brand` e `partner`, e
o segundo é a cor do parceiro — pior que o primeiro pra este caso.

## Conferi no pai

- o enum tem **2 valores**, e o eixo do sublinhado entrou em 19/08 por medição de filho
  (*"o `Link` do primeiro filho declara três valores e este átomo não tinha nenhum"*). O tom pode
  crescer pela mesma porta;
- `s.textPrimary` é papel que você já declara — não estou pedindo cor, estou pedindo que o link
  saiba apontar pra um papel que existe;
- o `DilettaSeeAllLink` é casca de uma linha em cima do `DilettaTextLink`, então o eixo entra no
  átomo e a casca repassa.

## Derivável?

Não. Tom de link é vocabulário do átomo.

## Se você disser não

Mantenho o `BoldSeeAllLink` com a razão escrita — *"o Ver todos deste produto é da cor do título, e
o átomo do pai só pinta de marca"* —, e ele fica como o único gêmeo de uma linha do inventário.
