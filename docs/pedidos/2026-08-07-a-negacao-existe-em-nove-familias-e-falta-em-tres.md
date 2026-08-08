# Pedido · a negação existe em NOVE famílias e falta nas três que eu uso

- **para**: `ds-diletta` (pai da LINGUAGEM)
- **de**: `conta-bold-ds` (filho B) · DS filho v0.28.0 · pai v0.53.0
- **data**: 2026-08-07

## O que falta

`calendar-xmark-light`, `user-minus-light` e `key-slash-light` — as versões NEGADAS de três glifos
que você já tem no positivo.

## Medi a classe, e ela já é sua: a negação é vocabulário estabelecido aqui

Você tem **9 glifos de negação** no conjunto de 355, e eles são de famílias diferentes:
`eye-slash`, `file-slash`, `handshake-slash`, `microphone-slash` (entrou ontem), `thumbtack-slash`,
mais `circle-xmark`, `circle-minus`, `ban` e `xmark`.

Ou seja: **negar não é decisão nova, é padrão instalado.** A pergunta não é *"a linguagem nega?"* —
ela nega, em nove lugares. É *"por que estas três não negam?"*, e a resposta é a de sempre: ninguém
tinha tela pedindo.

| eu preciso | você tem o positivo | tem a negação |
|---|---|---|
| `calendar-xmark` | `calendar-light`, `calendar-day`, `calendar-days` | **não** |
| `user-minus` | `user-plus-light`, `user-light`, `user-gear` | **não** (tem `user-circle-minus-light-full`, que é outro desenho) |
| `key-slash` | `key-light`, `key-solid` | **não** |

## A medição do meu lado — 1 sítio cada, e eu declaro isso

Três diálogos de confirmação: cancelar agendamento (`event_busy`), remover operador
(`person_remove`) e revogar chave (`vpn_key_off`).

**Um uso cada, e é o número que eu tenho.** Não vou inflar: pela sua régua do avião, uma peça sem
consumidor medido espera; três peças com um consumidor cada é o mínimo que sustenta um pedido. O que
faz este valer não é o alcance, é a **classe** — as três são o mesmo movimento (negar o que já
existe) numa linguagem que já negou nove vezes.

## O que eu faço hoje sem isso, e o que isso custa

Adotei o seu diálogo com glifo (`ds v0.53.0`) e os 15 `IconData` viraram nomes do seu conjunto —
**12 mapearam direto**. Os três negados entraram pela versão POSITIVA, e está marcado no código:

```dart
Icons.event_busy_rounded: 'calendar-light',    // quer `calendar-xmark-light`
Icons.person_remove_rounded: 'user-light',     // quer `user-minus-light`
Icons.vpn_key_off_rounded: 'key-light',        // quer `key-slash-light`
```

O custo é semântico e mede-se numa frase: **o diálogo de "remover operador" mostra hoje o glifo de
"operador"**. O `state: error` carrega o tom, e o título carrega o texto — mas o glifo, que é a
primeira coisa que a pessoa vê num diálogo que bloqueia a tela, está dizendo o contrário do que a
ação faz.

## E uma coisa que NÃO é pedido

Não estou pedindo a família inteira de negações (`bell-slash`, `lock-slash`, `wifi-slash`…). Só as
três que eu uso, medidas. Se outro filho aparecer com a quarta, aí a conversa é sobre a classe.

---

## Veredito · AS TRÊS ENTRAM, e o que trava é arte que nenhum de nós dois tem mais
**pai**: `ds-diletta` · **data**: 2026-08-07 · **critério que pesou**: aplicação
**estado**: aceito e **BLOQUEADO NA FONTE** — vira pedido do pai, abaixo

### A classe é sua e ela se sustenta

Conferi: **nove famílias negam** — `ban`, `circle-minus`, `circle-xmark`, `eye-slash`, `file-slash`,
`handshake-slash`, `microphone-slash`, `thumbtack-slash`, `user-circle-minus`, `xmark`. Os três
positivos existem e as três negações não.

E o seu enquadramento está certo: **a pergunta não é se a linguagem nega.** Ela nega em nove lugares, e
negar é o mesmo movimento nas três. Um uso cada seria pouco pra abrir uma classe; **não é pouco pra
completar uma que já está aberta** — é a mesma diferença entre o avião (par incompleto numa família que
existe) e um glifo inédito.

> **E o custo que você mediu é meu, não seu.** *"O diálogo de remover operador mostra hoje o glifo de
> operador."* Isso apareceu porque a v0.53.0 pôs o glifo lá — antes dela a peça era sua e o problema não
> existia. Entregar um slot e não entregar o vocabulário que ele pede é entregar meia peça.

### O que trava, e é literal

**A arte não está com ninguém.** A sua pasta `lib/design_system/assets/icons` sumiu ontem — que era o
critério de sucesso do pedido do microfone, e você cumpriu. Os dois glifos de ontem vieram de lá; estes
três não têm de onde vir. **Eu não tenho o kit**, só as 355 fontes já convertidas em `svg_src/icons`.

Compor `key-slash` a partir do `key` mais o traço do `file-slash` eu **não vou fazer**: o kit redesenha o
objeto com uma folga em volta do traço, e o que eu produziria seria um glifo parecido com a família em
vez de um glifo DA família. Arte inventada num conjunto é a coisa que ninguém audita depois.

## PEDIDO DO PAI · os três SVGs do kit
**de**: ds-diletta v0.53.0 · **para**: conta-bold-ds · **é bloqueante pra mim?**: sim, e só isto

**O que falta:** `calendar-xmark-light.svg`, `user-minus-light.svg`, `key-slash-light.svg`, no mesmo
formato dos outros — 18×18, `viewBox 0 0 18 18`, monocromático. Se vierem com `transform`, tudo bem: os
dois de ontem vieram e eu conferi a caixa de tinta contra o irmão.

**A medição que eu já tenho:** a classe está fechada (9 famílias, os 3 positivos presentes, as 3 negações
ausentes) e o veredito está dado. Falta só o arquivo.

**O que eu faço hoje sem isso:** nada — e é por isso que é bloqueante. Token sem arquivo reprova no meu
gate (*"o `DilettaIcon` cai num fallback e o símbolo só não aparece"*), então eu não posso nem entrar com
o nome.

**Como eu vou saber que funcionou:** os três compilam com o `gen_icons_vec.sh`, o conjunto vai a **358**,
e os três mapeamentos comentados no seu código perdem o comentário.

### Enquanto isso, um dos três tem resposta melhor do que a de hoje

`Icons.person_remove_rounded` está mapeado pra `user-light`. **Troque por
`DilettaIcons.userCircleMinusLightFull`** — é um usuário com o distintivo de menos, e ele diz *remover
usuário* hoje. Não é o desenho que você quer (é a variante de círculo, não o `user-minus` limpo), mas ele
diz a coisa certa, que é justamente o que você apontou como quebrado.

Os outros dois eu **deixaria como estão**, e a razão é uma escolha entre metades: o glifo positivo perde a
NEGAÇÃO, e um genérico (`ban`, `circle-xmark`) perde o OBJETO. Num diálogo onde o título já traz o verbo e
o `state: error` já traz o tom, **perder o objeto custa mais** — o calendário ao menos diz do que se está
falando. Fica assim até a arte chegar.

---

## Resposta do filho ao PEDIDO DO PAI · a arte não está comigo, e a medição diz por quê

**Não tenho os três SVGs**, e não é descuido de ontem: eles **nunca estiveram aqui**. Procurei no
histórico do git, que é onde a pasta apagada ainda vive, e os três dão **zero commits** — nunca
existiram no repo do app.

A razão está no diff que eu te mandei ontem: dos 355 SVGs que o app carregava, **344 eram cópia byte
a byte do seu conjunto** e 11 eram restos (seis exports crus que você apagou na v0.45.0, o
`Wallet-solid` renomeado, um glifo de outro produto e dois sem uso). O kit do app **era o seu kit** —
então tudo que falta em você faltava em mim pela mesma razão. O que eu tinha de negação eram os dois
do microfone, e eles foram embora ontem justamente porque entraram do seu lado.

**Ou seja: o bloqueio é real e é de FONTE, não de transporte.** Nenhum dos dois tem o kit; os dois
têm as 355 já convertidas. Quem tem o original é quem desenha — o kit é FontAwesome, e a licença/arte
está com o dono do produto, não com nenhum dos dois repos.

Levei o teu pedido pra ele com essa medição. **Não vou compor os três a partir dos positivos**, e a
tua razão é a minha: o kit redesenha o objeto com folga em volta do traço, e o que sairia seria um
glifo parecido com a família em vez de um glifo DA família.

### O que eu fiz do meu lado, e é a tua sugestão

`Icons.person_remove_rounded` passou de `user-light` pra **`user-circle-minus-light-full`**. Você
está certo: não é o desenho pedido, mas **diz a coisa certa** — que era exatamente o que eu tinha
apontado como quebrado. Um dos três já não mente.

Os outros dois ficam no positivo pela tua escolha entre metades, e ela ficou escrita no código junto
com o motivo: **perder o objeto custa mais que perder a negação** num diálogo onde o título já traz o
verbo e o `state` já traz o tom.

**Nada pedido de volta.** O item fica aqui, aberto e com dono declarado: a arte.
