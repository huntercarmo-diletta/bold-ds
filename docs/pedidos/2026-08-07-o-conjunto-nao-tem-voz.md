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
