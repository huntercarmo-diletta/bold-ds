# Pedido · o avião do chat tem `solid` e não tem `light` — é o `walletSolid` com o sinal trocado

- **para**: `ds-diletta` (pai da LINGUAGEM)
- **de**: `conta-bold-ds` (filho B) · DS filho v0.25.6 · pai v0.48.0
- **data**: 2026-08-07

## O que falta

`paper-plane-top-light`. Você tem **`paper-plane-top-solid`** e não tem o par leve — e tem os dois
pesos de `paper-plane` (o avião normal, sem o "top").

| glifo | `light` | `solid` |
|---|---|---|
| `paper-plane` | ✅ | ✅ |
| `paper-plane-top` | **falta** | ✅ |

## A medição — 76 nomes, 75 seus, 1 sozinho

O app deste produto virou consumidor direto do seu conjunto hoje: o `BoldIcon` dele era
`SvgPicture.asset` no bundle próprio e passou a ser casca do `DilettaIcon`. Medi nome por nome antes
de trocar, porque o modo de falhar aqui é o silencioso — **glifo que você não tem desenha nada, não
estoura, não avisa**, e foi assim que as setas de voltar e o `>` do extrato sumiram numa rodada
anterior desta adoção.

- **87** literais de ícone no app · **44** apelidos semânticos · **76** nomes depois da tradução;
- **75 dos 76 existem** no seu conjunto de 352;
- sobra **um**, e ele é usado em **2 sítios**: o botão de enviar do compositor de conversa da
  assistente e o cabeçalho da folha de canal.

## É a mesma forma do `walletSolid`, invertida

Na sua v0.45.0 você achou um `Wallet-solid.svg.vec` que **embarcava no bundle desde a v0.7.0 sem ter
token**, porque a caixa alta da primeira letra o jogou no balde de export cru. A frase que ficou:
*"das 6 famílias `light` sem `solid`, `wallet` era a única cujo arquivo sólido existia no disco — não
era gosto local, era buraco."*

Aqui é o espelho: a família `paper-plane-top` tem o sólido e **não tem a arte leve** do seu lado. Do
meu lado ela existe, é a que o produto usa, e o desenho não é o mesmo do `paper-plane` normal — o
`-top` aponta pra diagonal superior-direita e tem o entalhe na base. É glifo de ENVIAR de compositor
de chat, não de transferir dinheiro; o app usa os dois, em telas diferentes, de propósito.

**O SVG está na minha mão** (`lib/design_system/assets/icons/paper-plane-top-light.svg` no
`app-newbold`, 18×18, mesmo kit FontAwesome dos outros 351). Se ele servir, é adicionar arquivo e
nome. Se o seu desenho do `-top-solid` tiver outra origem e você preferir derivar o leve dele, melhor
ainda — o que importa é o par existir.

## O que eu faço hoje sem isso, e o que isso me custa

Uma lista fechada de UM nome (`BoldIcon.soAqui`) que desvia esses dois sítios pro asset local, com
gate nos dois sentidos:

- nome que você não tem e **não está** na lista ⇒ reprova (é o defeito silencioso virando vermelho);
- nome na lista que você **passou a ter** ⇒ reprova também, porque a lista apodrece calada: você
  entrega o glifo numa tag nova, ninguém tira daqui, e o app segue desenhando pelo asset dele pra
  sempre — com a lista afirmando "o pai não tem" sobre algo que ele tem.

O custo não é o desvio: é que **o app não pode apagar o bundle de ícones dele por causa de um
arquivo**. São 352 assets carregados de lá e 1 daqui, e a pasta local continua existindo — com o
convite implícito de que dá pra pôr o próximo ali também.

## Como o pai vai saber que funcionou

`BoldIcon.soAqui` fica vazio, o segundo teste do gate passa a reprovar se alguém puser algo lá, e a
pasta `assets/icons` do app **some** — que é o número que interessa: um consumidor a menos com
vocabulário próprio de ícone.
