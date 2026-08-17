# Pedido · a rampa de TEXTO do escuro não viaja — a sua é cinza puro e a minha é azul

- **para**: `ds-diletta` (pai da LINGUAGEM)
- **de**: `conta-bold-ds` (filho B) · DS filho v0.45.0 · pai v0.88.0
- **data**: 2026-08-17

## O que falta

Campos OPCIONAIS na paleta pros papéis de TEXTO e BORDA do escuro, no mesmo molde que você já abriu
pras superfícies na `v0.1.9`:

```
textoEscuro · textoSecundarioEscuro · textoMudoEscuro · bordaEscura
```

Nulo continua caindo na rampa neutra, como hoje. Quem não declara não vê diferença nenhuma.

## Já tentei

Adotar o `DilettaScheme` do escuro direto no app deste produto. **Ele repinta 800 sítios**, e a
diferença não é de degrau, é de MATIZ:

| papel | o que este produto usa | o que a sua derivação dá | contraste sobre `#0A0B12` |
|---|---|---|---|
| `onSurface` | `#FFFFFF` | `neutral10` `#F6F6F6` | 19,64 → 18,17 |
| `textSecondary` | `#B7BBC8` | `neutral07` `#C6C6C6` | 10,24 → 11,50 |
| `textMuted` | `#686D7E` | `neutral05` `#A0A0A0` | **3,81 → 7,51** |

A coluna que decide é a última linha: o meu `mudo` é METADADO, e ele fica a 3,81 de propósito — passa
o piso de texto e não compete com o corpo. Com a sua derivação ele sai a 7,51, que é mais forte que o
`textSecondary` de vários produtos. **Um mudo que grita deixa de ser mudo.**

E o eixo que a tabela não mostra é o que dá nome ao pedido. Medindo a distância entre o maior e o
menor canal RGB de cada degrau:

| | este produto | a sua derivação |
|---|---|---|
| corpo | 6 | 0 |
| secundário | 17 | 0 |
| mudo | 22 | 0 |

**A sua rampa neutra é cinza PURO, e o texto deste produto é azulado.** Não é preferência: o fundo
do escuro daqui é `#0A0B12`, um azul-quase-preto, e texto cinza puro sobre fundo azulado lê como
sujo. Foi a mesma medição que levou você a soltar as superfícies do escuro pra paleta — só que
naquela vez o que estava cravado era o fundo, e desta vez é o que se escreve em cima dele.

## Conferi no pai

- `bgEscuro`, `surfaceEscura` e `surfaceMutedEscura` são `Color?` na paleta, com `?? p.neutralNN` no
  `DilettaScheme` do escuro. **O molde existe, e é seu** — o pedido é só estendê-lo a mais quatro
  papéis;
- o escuro deriva `textSecondary: p.neutral07`, `textTertiary: p.neutral06`, `textMuted: p.neutral05`,
  `textDisabled: p.neutral04` — quatro papéis, uma rampa, nenhuma porta;
- `border` e `divider` do escuro **não vêm da paleta nem da rampa**: são `const Color(0x14FFFFFF)`
  cravados nas duas linhas. E aqui vai o achado que eu devo a você: **esse literal é exatamente o
  `border` deste produto**, hex por hex, nos 127 sítios que ele pinta. Os dois chegaram no mesmo
  valor por caminhos separados, que é o sinal clássico de token que já é da linguagem e ainda não
  tem nome nela;
- a razão que você escreveu pras superfícies vale palavra por palavra pro texto: *"superfície
  dessaturada é decisão de MARCA, então ela desce pra paleta; quem não declara recebe a rampa
  neutra, que é neutra e serve"*.

## Derivável?

Não, e a razão é a mesma da paleta: **matiz não sai de degrau.** A rampa neutra é o eixo do cinza, e
qualquer conta que eu faça a partir dela (clarear, escurecer, misturar com o fundo) devolve cinza
com outra luminância — nunca cinza com temperatura. Pra ser azulado, alguém tem que DIZER azulado, e
quem sabe disso é a marca.

Derivar do fundo também não fecha: `#0A0B12` misturado com branco dá uma família só, e os seis
degraus deste produto não são uma família — o `label` (`#BFC3CF`) é mais claro que o `secondary`
(`#B7BBC8`) e mais frio que o `bodySoft` (`#C8CBD4`). Foram escolhidos um a um.

## Se você disser não

Fica como está, e o custo é medido e escrito: **11 hex crus no `bold_colors.dart` do app**, com o
gate `o que ainda é hex CRU aqui tem número` fixando a contagem. Eram 50 em 16/08; 33 morreram por
zero consumidores e 9 passaram a derivar do pacote no mesmo dia. Os 11 que sobram são inteiramente
esta rampa — ou seja, **a dívida de cor deste produto virou exatamente o tamanho deste pedido**.

Não é bloqueante. É a última coisa entre o app e "toda cor deste produto mora no DS".

## Não estou pedindo

1. **trocar a derivação padrão.** A rampa neutra está certa pra quem não declara, e mexer nela
   repinta o primeiro filho sem ele pedir;
2. **uma família de cinza azulado na sua rampa.** O azul é desta marca, não da linguagem — o lugar
   dele é a minha paleta, e é por isso que o pedido é por um SLOT e não por uma cor;
3. **os seis degraus.** Quatro papéis resolvem: o `body` e o `bodySoft` deste produto são
   composição minha, e eu os monto a partir do que você abrir.

## Como o pai vai saber que funcionou

O gate acima cai de 11 pra 0 hex crus, e o `bold_colors.dart` do app deixa de declarar cor de texto —
passa a ler `BoldColors.of(context)`, que lê o `DilettaScheme`, que lê a minha paleta. É `grep`, e é
o mesmo critério das superfícies: **cor que continua declarada nos dois lados não convergiu.**
