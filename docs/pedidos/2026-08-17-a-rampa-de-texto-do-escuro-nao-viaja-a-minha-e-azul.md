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

---

## Veredito · ENTRAM OS QUATRO — e a rampa cinza é a SUA, não a minha

**pai**: `ds-diletta` **v0.109.0** · **data**: 2026-08-17

`textoEscuro` · `textoSecundarioEscuro` · `textoMudoEscuro` · `bordaEscura`, opcionais, nulo cai na
rampa neutra. Mais dois papéis que você não pediu, e eles são a parte que mais importa.

### O que decidiu: você provou que a saída barata não existe

O molde é meu e o precedente é meu, então o mérito nunca foi o difícil. O que fecha o pedido é a seção
**Derivável?**, e ela responde a pergunta que eu ia fazer primeiro — *por que não tinge a sua própria
rampa e pronto?* Fui medir pra cobrar isso de você e a resposta é NÃO, com número: **nenhum degrau
neutro serve um modo só.**

| degrau | no ESCURO | no CLARO |
|---|---|---|
| `neutral10` | `fg` · `onSurface` | `surfaceSubtle` |
| `neutral06` | `textTertiary` | `textDisabled` · **`surfaceLoadingStrong`** |
| `neutral05` | `textMuted` · `textPlaceholder` | `textPlaceholder` |

Tingir o `neutral10` de branco pro corpo do escuro **apaga o `surfaceSubtle` do claro** — 1,00 contra
a superfície, a peça deixa de existir. E o `neutral06` pinta uma SUPERFÍCIE: rampa de texto entrando em
material. Você não tinha caminho do seu lado, e é isso que a porta paga.

### E o diagnóstico está invertido — a correção muda o que eu NÃO podia fazer

O título do pedido diz *"a sua é cinza puro e a minha é azul"*. Ela não é. Medindo a sua régua na
**rampa de referência daqui**:

| degrau | referência | spread | o seu produto | spread |
|---|---|---|---|---|
| `neutral10` | `#F5F8F9` | 4 | corpo | 6 |
| `neutral07` | `#B2BCC4` | **18** | secundário `#B7BBC8` | **17** |
| `neutral06` | `#929EA7` | **21** | rótulo `#BFC3CF` | 16 |
| `neutral05` | `#74818B` | **23** | mudo `#686D7E` | **22** |

**Os dois lados chegaram quase no mesmo lugar** — 18/23 contra 17/22 —, e é a segunda vez em duas
semanas que um cruzamento acha isso (o seu `0x14FFFFFF` de borda, hex por hex, é o mesmo achado com
outra roupa). A rampa que apaga a temperatura é a **CINZA que a sua paleta declara** (spread 0 nos três
degraus), não a minha derivação.

Isso não derruba o pedido: a porta é necessária pela tabela acima, com ou sem culpa da minha rampa. Mas
muda o que eu podia fazer com ela — **a derivação default fica intacta**, e não porque a sua recusa nº1
pediu, e sim porque ela já estava certa. Se eu tivesse aceitado o diagnóstico, o conserto natural seria
"esfriar a rampa neutra do pai", e isso repinta o outro filho por um defeito que não é meu.

### Os DOIS papéis que você não pediu, e por que quatro portas não resolviam

Você mediu que quatro portas resolvem. Não resolvem, e o número é meu: **`textTertiary` tem 33
consumidores nesta linguagem e `textDisabled` tem 25.** Os dois ficariam na rampa. Na sua paleta isso é
**um degrau de spread 0 entre um de 17 e um de 22**, em 58 sítios — a mesma feiura que você veio
consertar, três degraus depois, e a que ninguém ia procurar porque o pedido saiu verde.

Não abri slot pros dois: papel especulativo é o que esta casa recusa, e você declarou não ter medição
pros seis. Eles se **derivam do par**:

> **o degrau é da rampa, a temperatura é da declaração** — a fração de luminância que o degrau ocupa
> entre os vizinhos dele na SUA rampa, transposta pro par que você declarou.

É a metade que faltava da sua frase. *Matiz não sai de degrau*, e você está certo; **degrau sai de
degrau**, e é o que sobrou pra derivar. A proporção é medida, não escolhida: 57% na referência, 53%
numa rampa cinza. O desabilitado fica FORA do vão (abaixo do mudo), então o outro extremo dele é a
página, que é para onde texto desabilitado anda em qualquer rampa. Par incompleto não deriva.

### Quatro campos, sete papéis — e a razão é a sua própria régua

`textoEscuro` → `fg` + `onSurface` · `textoMudoEscuro` → `textMuted` + `textPlaceholder` ·
`bordaEscura` → `border` + `divider`. Os três pares têm **o mesmo valor hoje**. Porta separada pra
papéis que já são a mesma cor é divergência esperando acontecer — e um deles ia te pegar: você declara
`textoMudoEscuro` em 3,81 e o `textPlaceholder` continuava em 7,51, dois papéis idênticos separando-se
sem ninguém pedir.

**O 3,81 fica**, sem piso nenhum, e isso está em teste com o seu número. Você escreveu *"um mudo que
grita deixa de ser mudo"*; piso cravado aqui seria recusar o pedido com outro nome. O piso desse papel
é seu.

### O que puxar o fio achou: `borderSubtle` estava presa desde a v0.1.9

Na referência `borderSubtle` e `surface` são o mesmo `neutral02` — borda que só se lê contra a página.
A porta de v0.1.9 mudou **uma das duas**: quem declara `surfaceEscura` (você) tinha a borda invisível
de volta visível, e nada media isso. Agora ela acompanha `surfaceEscura ?? neutral02`. Idêntico pra
quem não declara. **É a mesma classe do seu pedido, uma camada ao lado, e ela viveu 100 tags.**

### Duas ressalvas, e uma é sobre a sua medição

1. **as suas duas tabelas discordam no corpo.** A primeira diz `onSurface` = `#FFFFFF`, cujo spread é
   **0**; a segunda diz corpo = **6**. Uma das duas é outro valor (`bodySoft`, provavelmente). Não muda
   o veredito — o eixo está certo nos outros dois degraus, e é neles que a decisão mora —, mas o corpo
   do seu escuro tem dois números neste pedido;
2. **nada muda no Figma.** Os quatro são nulos na referência, e a reconciliação de variáveis segue
   516 = 516. A sua paleta é o único lugar onde eles existem.

### O que você faz

`ref: v0.109.0`, declara os quatro, e o gate dos hex crus cai de **11 pra 0**. Não declare o terciário
nem o desabilitado: eles chegam derivados, e se eles saírem errados no seu produto isso é medição nova,
não campo novo — me manda o número.

E confere uma coisa que eu não consigo ver daqui: com o corpo em `#FFFFFF` e o mudo em `#686D7E`, o
terciário derivado é o valor que o seu `label` (`#BFC3CF`) queria ser? A sua rampa **não é monotônica**
(o rótulo é mais claro que o secundário), e a minha derivação é. Se o seu rótulo for um quinto degrau
com papel próprio, isso é o próximo pedido — e ele não é este.
