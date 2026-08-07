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

---

## Veredito · ENTRA, e a arte foi CONFERIDA contra o irmão em vez de aceita
**pai**: `ds-diletta` **v0.51.0** · **data**: 2026-08-07 · **critério que pesou**: manutenção

`DilettaIcons.paperPlaneTopLight`. **353 no conjunto.**

### A classe antes do caso, que é o que decide

Você trouxe um nome; eu fui medir a família inteira, porque um buraco só não diz se é buraco ou gosto:

- **157 famílias** no conjunto;
- **sete têm só o sólido** — e **três são marca** (`apple`, `google`, `whatsapp`), onde par não faz
  sentido nenhum: marca não tem peso leve;
- sobram **quatro reais**: `check-to-slot`, `moon-cloud`, `siren` e o seu `paper-plane-top`.

**A sua é a única das quatro com consumidor medido**, e é isso que a faz entrar sozinha. As outras três
ficam como estão até alguém desenhar tela com elas — o mesmo tratamento que o `walletSolid` deu às cinco
irmãs dele.

### A sua leitura do espelho está exata

*"É o `walletSolid` com o sinal trocado."* É, e a simetria é literal: lá o arquivo sólido embarcava no
bundle **sem ter nome**, aqui a família tem nome pro sólido e **não tinha a arte leve**. Os dois são a
mesma coisa vista dos dois lados de uma tabela de pares que ninguém tinha montado inteira até hoje.

### A arte eu não aceitei — eu medi

O seu SVG carrega um `<g transform="translate(1 1) scale(0.767754)">` que **351 dos meus 352 não têm**
(sete têm algum). Transform num glifo é suspeita de arte reescalada, e arte reescalada num conjunto
significa um ícone com peso visual diferente dos irmãos — o tipo de coisa que ninguém abre ticket pra
consertar.

Medi a caixa de tinta dos dois, com o transform aplicado:

| glifo | x | y |
|---|---|---|
| `paperPlaneLight` (meu) | `0,98 .. 17,05` | `0,94 .. 16,04` |
| `paperPlaneTopLight` (seu) | **`1,00 .. 17,06`** | **`0,94 .. 17,00`** |

Mesma largura até a segunda casa, mesmo topo. **O `transform` existe justamente pra encaixar no box de
18** — é export ajustado, não arte reescalada. Entrou como veio.

### O que fez entrar não foi o desvio, foi o que ele mantinha vivo

> *"O custo não é o desvio: é que o app não pode apagar o bundle de ícones dele por causa de um arquivo.
> São 352 assets carregados de lá e 1 daqui, e a pasta local continua existindo — com o convite
> implícito de que dá pra pôr o próximo ali também."*

É o mesmo argumento da v0.6.0, quando o glifo de assistente entrou: **dois ícones próprios obrigam a
manter conjunto próprio.** Aqui era um, e um já bastava pra manter a pasta.

E o seu gate nos DOIS sentidos é a parte que eu não teria pedido: a segunda metade (*nome na lista que o
pai passou a ter reprova também*) é o que impede a lista de apodrecer calada. Ela vai reprovar agora, que
é o que você quer que aconteça.

### Como subir

`ref: v0.51.0`. `BoldIcon.soAqui` fica vazio, e a pasta `assets/icons` do app pode sair.

### Um número da prosa que o seu pedido derrubou de carona

Corrigindo `352 → 353` nos documentos, achei um `46` que devia ter caído anteontem: a frase é *"46 de
352"*, **dois números velhos numa frase só**, e a minha varredura procurava um de cada vez. O mínimo é 47
desde anteontem. Terceira vez esta semana que a forma da frase esconde o número.
