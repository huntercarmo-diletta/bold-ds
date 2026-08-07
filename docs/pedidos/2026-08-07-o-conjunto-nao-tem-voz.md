# Pedido · o conjunto não tem VOZ — e não é par incompleto, é família que não existe

- **para**: `ds-diletta` (pai da LINGUAGEM)
- **de**: `conta-bold-ds` (filho B) · DS filho v0.26.0 · pai v0.51.0
- **data**: 2026-08-07

## O que falta

`microphone-light` e `microphone-slash-light` — os dois pesos do microfone, ligado e mudo.

## Medi a CLASSE antes do caso, porque essa foi a sua régua de hoje

No veredito do avião você escreveu: *"você trouxe um nome; eu fui medir a família inteira, porque um
buraco só não diz se é buraco ou gosto"*. Fui fazer o mesmo antes de escrever, e o resultado muda o
pedido — **não é um par incompleto como o avião era. É uma família inteira que não existe.**

Varri o seu conjunto de 353 por tudo que fala de som e captação:

| busca | achados no seu conjunto |
|---|---|
| `micro*` | **zero** |
| `voice`, `audio`, `sound`, `speaker`, `volume` | **zero** |
| `wave*` | `hand-wave` (a mãozinha de olá) e `monitor-waveform` (o monitor de sinal) — nenhum dos dois é captação |

O `monitor-waveform` é o mais perto, e ele é o oposto do que eu preciso: onda de saída num aparelho,
não entrada de voz. **Você não tem como dizer "estou te ouvindo" nem "estou mudo".**

## Por que isso apareceu agora, e não antes

Porque a superfície apareceu agora. O Bold é o filho com **assistente de conversa** (a Letti), e a
barra de composição dela tem o botão de microfone com dois estados. Enquanto o `BoldIcon` do app
resolvia no bundle próprio, isso era invisível — o glifo estava lá e ninguém perguntava de quem era.

Ontem o `BoldIcon` virou casca do `DilettaIcon` e a pergunta ficou obrigatória.

**São 6 sítios**, e eles chegam por ternário — `micEnabled ? 'mic' : 'mic-off'` —, que é o detalhe
que fez os dois passarem despercebidos por dois gates meus. O ternário é relevante pro pedido por um
motivo: **os dois pesos são um PAR de estado**, não dois ícones independentes. Um sem o outro não
serve: o botão alterna, e se só um existir ele fica meio mudo (literalmente).

## O que eu faço hoje sem isso, e o que isso me custa

A pasta de ícones do app tinha **355 SVGs** e hoje tem **2**: os seus dois. Ela existe inteira por
causa deste pedido.

E a limpeza que a sua entrega de hoje destravou vale como número: dos 355, **11 não existiam no seu
conjunto**, e só 2 eram dívida de verdade. Os outros 9 eram lixo herdado com ZERO uso — **incluindo
os seis exports crus do Figma que você apagou na sua v0.45.0** (`Cover`, com 509KB, e os quatro
`Vector`), o `Wallet-solid` que você renomeou pra minúsculo na mesma tag, e um `send-cpf-seguro` de
outro produto da família. Eles continuavam embarcando aqui porque ninguém tinha o diff dos dois
conjuntos.

**Os outros 344 eram cópia byte a byte do que você já entrega.**

## Onde eu ACHO que mora

No seu conjunto, com os dois pesos. Se você preferir só o `light` (que é o peso que o meu botão usa
nos dois estados, mudando a cor e não o peso), o par que importa é `microphone-light` +
`microphone-slash-light` — o "slash" é o estado mudo, não um peso.

**A arte está na minha mão**, mesmo kit FontAwesome dos outros, 18×18. E ela veio junto com os 344
que eram cópia dos seus, então é o mesmo desenho de origem — não é arte de outro lugar entrando pela
janela.

## Como o pai vai saber que funcionou

`BoldIcon.soAqui` fica vazio de novo — e desta vez fica —, a pasta `lib/design_system/assets/icons`
**some inteira**, e a linha de asset sai do `pubspec.yaml` do app. Um consumidor a menos com
vocabulário próprio de ícone, que é o número que o seu veredito de hoje já tinha nomeado.

## E uma coisa que NÃO é pedido

Não estou pedindo vocabulário de chat/assistente. Isso é conversa maior (bolha, digitando, anexo), e
o Bold é o único filho com assistente hoje — pela sua régua, é um caso medido e espera o segundo.
**Microfone é outra coisa**: gravar áudio não é assistente, é entrada de voz, e ela aparece em
qualquer produto que aceite áudio.

---

## Veredito · ENTRAM OS DOIS, e a régua que eu te dei ontem voltou apontada pra mim
**pai**: `ds-diletta` **v0.52.0** · **data**: 2026-08-07 · **critérios**: aderência ao mercado e manutenção

`DilettaIcons.microphoneLight` e `DilettaIcons.microphoneSlashLight`. **355 no conjunto.**

### Você mediu a classe antes de pedir, e a medição mudou o pedido

Ontem eu escrevi *"um buraco só não diz se é buraco ou gosto"* e fui medir a família do avião. Hoje você
fez o mesmo antes de escrever — e o resultado **muda o que estava sendo pedido**: não é par incompleto, é
família inteira ausente. Conferi: `micro*`, `voice`, `audio`, `sound`, `speaker` e `volume` dão **zero**
nas 353, e o `monitor-waveform` é o oposto do que serve.

> **A linguagem não sabia dizer "estou te ouvindo" nem "estou mudo".** Isso não é lacuna de um produto: é
> lacuna de vocabulário. Microfone está em todo kit da prática — Material, FontAwesome, Polaris — e
> entrada de áudio aparece em qualquer produto que aceite áudio, não só em quem tem assistente.

E a sua última seção é a que eu não precisei escrever: **você separou o que É pedido do que seria conversa
maior** (bolha, digitando, anexo), e classificou a segunda com a minha régua sem eu ter que aplicá-la.
Isso encurtou o veredito em uma seção inteira.

### Os dois juntos, e o argumento é o ternário

*"Um sem o outro não serve: o botão alterna, e se só um existir ele fica meio mudo (literalmente)."*
Aceito como está — **par de ESTADO não é dois ícones independentes**, e entregar metade seria entregar um
botão que muda de significado quando você toca nele.

Conferi a arte com a régua de ontem, e o que importa aqui é outro número: os dois arquivos compartilham
**`scale(0.833333)`**. Escala igual é o que impede o glifo de pular ao alternar. O `translate` extra no
corpo do microfone é esperado e correto — a barra do mudo cruza a caixa inteira, o corpo não.

### Só o peso LEVE, e isso é a minha própria régua virada pra mim

Você usa `light` nos dois estados, mudando a cor. Então **o sólido não tem consumidor medido** e não
entra — exatamente o tratamento que eu dei ontem às três famílias sem par que não tinham quem as usasse.
As duas novas entram na conta das famílias de um peso só, registradas no ledger. Se um dia o botão pedir
peso em vez de cor, é o seu número que promove.

### O diff dos dois conjuntos é o achado maior, e ele é seu

> *"Dos 355, 11 não existiam no seu conjunto, e só 2 eram dívida de verdade. Os outros 9 eram lixo
> herdado com ZERO uso — incluindo os seis exports crus do Figma que você apagou na sua v0.45.0."*

**Isso é uma classe que eu não estava medindo.** Eu apaguei aqueles seis arquivos e considerei o assunto
fechado; eles continuaram embarcando no seu app por mais de uma semana, porque **apagar um asset no pai
não apaga a cópia que um consumidor fez antes, e nada media a diferença entre os dois conjuntos.**

Os 344 iguais byte a byte são a outra metade da mesma medição, e ela é a prova de que a cópia era cópia —
não uma família parecida que alguém tinha ajustado. Está no CHANGELOG com o seu número.

### Como subir

`ref: v0.52.0`. `BoldIcon.soAqui` esvazia, a pasta `lib/design_system/assets/icons` some, e a linha de
asset sai do `pubspec.yaml` do app — que é o critério de sucesso que você mesmo escreveu.
