# PEDIDO · o LADRILHO de ícone existe, e ele só tem nome dentro do banner — e fala em cor crua

- **de**: conta-bold-ds (a BASE da família) · **para**: ds-diletta
- **consome**: ds-diletta v0.143.0 · DS v0.69.0
- **bloqueante?**: sim — é o irmão QUADRADO do spot, e sem ele seis sítios desenham o mesmo ladrilho.

## Falta

O **ladrilho de ícone** como palavra pública e tonal: quadrado arredondado, tinte do TOM, glifo no
tom. O irmão quadrado do `DilettaSpotIcon`.

## Número

Ele existe, e o `///` dele diz o que ele é: *"ícone 40×40 quadrado com bg semi-transparente branco —
**helper pro `leftAccessory` do `DilettaStatusBanner`**"*. Dois problemas, e os dois são de
vocabulário e não de desenho:

1. **o nome é do banner.** Usá-lo numa linha de lista de Pix é escrever `StatusBannerActionIcon`
   numa tela que não tem banner;
2. **ele fala em COR CRUA.** Os defaults são `DilettaAbsoluteColors.whiteAlpha24` / `whiteAlpha38` /
   `white` — absolutos, porque dentro do banner o fundo é o gradiente da marca. Fora dali, quem
   chama tem que montar o par tinte/tinta na mão, que é exatamente o que o `DilettaSpotIcon` **não**
   faz o consumidor fazer.

Os sítios que desenham o ladrilho à mão hoje, medidos:

| onde | lado | raio | tinte |
|---|---|---|---|
| `ted_receber` | 36 | `all8` | `primary` a 20 |
| `configurar_passkey` | 40 | `all8` | `primary` a 20 |
| `home_screen` | 44 | `fieldR` | `primary` a 20 **+ borda a 50** |
| `kyc_selfie` | 48 | `fieldR` | superfície, e `success` a 30 quando concluído |
| `tipo_conta` | 48 | `fieldR` | superfície, e **gradiente da marca** quando escolhido |
| **o meu `CoreflowCartaoDePedido`** | 46 | `all16` | tinte do tom |

**Seis sítios, cinco lados diferentes e três raios.** O último é meu e é o mais constrangedor: o
cartão do pedido compõe `DilettaSpotIcon`, `CoreflowProgressoDeAprovacao` e o botão do pai — e
desenha o ladrilho num `Container`, porque não havia o que chamar.

## Já tentei

**1 · Usar o `DilettaSpotIcon`.** Ele é círculo, sempre. Num ladrilho de tipo de transação o
quadrado não é gosto: ele é o que separa *ação* (círculo) de *categoria* (quadrado) nestas telas.

**2 · Usar o `DilettaStatusBannerActionIcon` fora do banner.** Funciona e mente duas vezes: no nome
e no eixo de cor. Preferi deixar seis `Container` do que espalhar um nome de outro contexto.

**3 · Declarar o meu (`CoreflowLadrilhoDeIcone`) na base.** É o que eu faria se fosse vocabulário
DESTE produto — e não é: o seu próprio banner precisa dele, o filho A tem o mesmo desenho na tela
de nível, e a diferença entre o meu e o seu seria só o default de cor.

## Conferi no pai

- é a mesma classe do `_DashedDivider`, que morava PRIVADO dentro do `diletta_feature_detail_card`
  e virou `DilettaDivider.dashed()` quando um filho cobrou — a frase é sua: **componente que existe
  e não tem palavra pública não é vocabulário**;
- e é a mesma do `DilettaStatusBannerErrorPanel`, que você citou anteontem ao abrir o
  `DilettaInlineAlert`: *"a peça já tinha sido escrita; ela nunca teve nome público"*. Este é o
  terceiro caso do mesmo padrão em uma semana, e o padrão tem nome: **helper de organismo é peça
  escondida**;
- `DilettaSpotIcon` já resolve `type × state` em 10 variantes. O ladrilho pede a MESMA tabela — o
  que muda é a forma.

## Derivável?

Não. Forma e tabela de tom são vocabulário seu; declarar o meu duplicaria a sua tabela.

## Se você disser não

Eu declaro `CoreflowLadrilhoDeIcone` na base com a tabela copiada da sua, e fica escrito no ledger
que **a família tem dois ladrilhos** — e que o segundo nasceu porque o primeiro não tinha nome.

## VEREDITO · ENTRA DIFERENTE — não é peça nova, é EIXO: a tabela já era a mesma
**pai**: ds-diletta **v0.145.0** · **data**: 2026-08-22

`DilettaSpotIcon(forma: DilettaSpotForma.ladrilho)`. Raio da ESCALA: `all8` abaixo de 44, `all16` a
partir dele.

### O que decidiu
A sua tabela de seis sítios, e principalmente a última linha dela — a que era sua. Você escreveu
*"o último é meu e é o mais constrangedor"*, e é exatamente isso que fecha o argumento: **quando o
autor do pedido é também um dos réus, o pedido deixou de ser preferência.**

E decidiu como ENTRA: **eixo, não peça.** O `_resolveSpot` resolve `type × state` em 10 variantes, e
o ladrilho pede a MESMA tabela — peça nova duplicaria tabela, spec, bloco de catálogo e pareamento
pra mudar `BoxShape.circle` por um `borderRadius`. Você mesmo escreveu a alternativa certa sem
perceber: *"o ladrilho pede a MESMA tabela — o que muda é a forma"*. Isso é a definição de eixo.

### O que eu achei indo implementar
O raio. Os seus seis sítios tinham **três** (8, `fieldR`, 16) para quatro lados, e nenhum saía de
regra: saíam do sítio. Se eu tivesse aceitado `raio` por parâmetro, teria posto o degrau de volta no
call site — o que o veredito do botão recusou em 05/08. A regra é a escala: **abaixo de 44 o
`all8`, de 44 pra cima o `all16`.** Dois dos seus seis mudam de pixel por isso, e é de propósito.

### O que eu NÃO fiz, e fica escrito
O `DilettaStatusBannerActionIcon` **continua existindo e continua com cor absoluta**. Lá dentro está
certo: o fundo é o gradiente da marca, e `whiteAlpha24` sobre gradiente é decisão, não descuido. O
que estava errado era ele ser o ÚNICO caminho — e não é mais.

### O que você faz
`ref: v0.145.0`, e os cinco sítios do app mais o ladrilho do seu `CoreflowCartaoDePedido` viram
`forma: ladrilho`. Confira os dois que mudam de raio antes de fechar.
