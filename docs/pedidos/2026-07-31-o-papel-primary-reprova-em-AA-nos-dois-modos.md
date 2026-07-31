# Pedido · o papel `primary` reprova em AA nos DOIS modos, e o app já resolveu isso de um jeito que eu não posso declarar

- **filho**: conta-bold-ds
- **pai**: ds-diletta v0.21.4 (`DilettaScheme.light/dark`)
- **é bloqueante?**: **não pra compilar, sim pra acessibilidade.** O rótulo de todo botão primário deste
  produto está abaixo de AA, e o do modo escuro está abaixo até do limiar de texto GRANDE

## O que falta

O esquema deriva `primary` de um degrau FIXO da rampa — `primary04` no claro, `primary05` no escuro —, e o
par com `onPrimary` não é legível em nenhum dos dois. **A paleta não tem como dizer qual degrau é a cor de
AÇÃO em cada modo**, que é justamente a decisão que o app do cliente tomou pra resolver isto.

## A medição

Isto veio de graça: declarei `papeis` com `tinta:` (v0.53.0 do motor) e o contraste medido apareceu na
página. Foi a primeira coisa que o gancho me deu.

```
             fundo      × tinta        claro     escuro
primary      #FE3976    × onPrimary    3,46:1    2,73:1     ← ✕ AA nos dois · ✕ AA GRANDE no escuro
success                 × onSuccess    4,04:1    6,07:1     ← ✕ AA no claro
warning                 × onWarning    2,08:1    6,03:1     ← ✕ AA e ✕ AA grande no claro
error                   × onError      3,68:1    4,49:1     ← ✕ AA nos dois (o escuro por 0,01)
```

Os limiares são os dois da WCAG 2.2 SC 1.4.3: **4,5:1** pra texto normal e **3:1** pra grande (18pt, ou 14pt
negrito). O rótulo de botão deste DS é `subheading` — **14px/600**, que **não** é texto grande: 14pt negrito
são 18,7px. Então o limiar que vale pro botão primário é 4,5:1, e ele está em 3,46:1.

### A rampa inteira, pra mostrar que o conserto existe dentro dela

```
primary02  #600627   branco → 13,52:1   ✓
primary03  #9E1241   branco →  8,03:1   ✓   ← o meu 03 (ajustado na adoção)
primary03  #CC1E58   branco →  5,39:1   ✓   ← o 03 do APP
primary04  #FE3976   branco →  3,46:1   ✕   ← o que o seu esquema usa no CLARO
primary05  #F66FA0   branco →  2,73:1   ✕   ← o que o seu esquema usa no ESCURO
```

**Não é a marca que é ilegível: é o degrau escolhido.** O rosa do logo (`04`) é a identidade; usá-lo como
superfície de texto é a decisão que reprova.

### E o app do cliente já resolve, invertido do seu esquema

O tema do app é mode-aware nesta exata linha, com o comentário dele:

```dart
// Marca/estado no LIGHT: shades profundos (contraste no branco)
primary: Color(0xFFCC1E58),   // primary03  → 5,39:1  ✓
// Marca/estado no DARK: shades claros/vibrantes (leem sobre o escuro)
primary: Color(0xFFFE3976),   // primary04  → 3,46:1  ✕
```

Quatro linhas de comparação, e a terceira é a que dói:

| | claro | escuro |
|---|---|---|
| app hoje | **5,39:1 ✓** | 3,46:1 ✕ |
| o seu esquema, com a minha paleta | 3,46:1 ✕ | **2,73:1 ✕✕** |

**O DS está pior que o produto que ele vem substituir, nos dois modos.** No claro porque usa o degrau da
marca onde o app usa o profundo; no escuro porque clareia mais um degrau ainda.

## O custo de não ter

O botão primário é o componente mais usado deste produto, e o rótulo dele é o texto mais lido do app. Hoje:

- **eu não posso consertar aqui.** `primary` é derivado por você da rampa; a única alavanca que a paleta me
  dá é mudar o valor de `primary04` — e isso é mudar **o rosa do logo**, que não é uma decisão de DS;
- eu **já usei** a única saída disponível uma vez, e ela foi por outro caminho: ontem escureci o meu
  `primary03` (de `#CC1E58` pra `#9E1241`) porque o par `03` × `07` no escuro dava 3,29:1. Deu, porque o
  `03` não é a marca. Com o `04` esse recurso não existe;
- o gate que eu poderia escrever mediria e reprovaria o meu próprio produto sem me dar o que consertar.

## Onde eu ACHO que mora

**A paleta declara qual degrau é a AÇÃO em cada modo**, e o esquema usa isso em vez do degrau fixo:

```dart
DilettaPalette(
  primary04: Color(0xFFFE3976),        // a MARCA, e ela não muda
  // ...
  acaoNoClaro: Color(0xFF9E1241),      // ou o nome do degrau; opcional
  acaoNoEscuro: Color(0xFFFE3976),
)
```

Sem declaração, o comportamento de hoje continua — então nenhum filho migra por causa disto.

A razão de ser na PALETA e não no esquema: qual degrau lê sobre branco depende da rampa **daquele
produto**. O azul do primeiro filho a 4,5:1 pode ser o `04`; o rosa deste não é. Um número fixo no esquema
acerta um produto e erra o outro.

**Ressalva declarada, e ela é grande**: talvez a resposta certa seja "a marca é a marca, e botão primário
com 3,46:1 é decisão de negócio, não defeito de DS" — e nesse caso o que eu preciso não é conserto, é
**poder declarar a exceção** (algo como uma lista de pares que este produto aceita abaixo de AA, com a
razão escrita), pra a página mostrar "aceito, e por quê" em vez de um ✕ que ninguém vai consertar. As duas
saídas me servem; a que não me serve é o ✕ silencioso.

Segunda ressalva: eu medi `success`/`warning`/`error` contra `onSuccess`/`onWarning`/`onError`, que são os
pares do seu esquema. Se o desenho for que **ninguém põe texto sobre a cor sólida de estado** (só sobre o
`subtle`, e esses passam todos), então três das quatro linhas não são defeito — são pares que não existem
na prática, e o meu `tinta:` está declarando um par que o DS não usa. Você tem essa medição e eu não.

## Como o pai vai saber que funcionou

Na página de Styles deste catálogo, a linha `primary` mostra **✓ AA** nos dois modos, com o `primary04`
intacto na seção COR — a marca aparece, e a superfície de ação é outra.

E o gate que eu já tenho aponta pra isso: `os PARES que reprovam em AA são exatamente os quatro medidos`
fixa os números de hoje (`3.46`, `4.04`, `2.08`, `3.68`). Quando o conserto entrar, **ele falha**, e é assim
que eu fico obrigado a atualizar este pedido em vez de deixar um número velho aqui.

---

## Anexo · um segundo achado, menor, do mesmo gancho

`tinta:` nomeia uma chave de `papeis`, e o motor resolve com `papeis[nome]` — **nome que não existe vira
`null`, e `null` quer dizer "sem medição"**. Eu escrevi `tinta: 'onSuccess'` antes de declarar o papel
`onSuccess`, e as três faixas de estado ficaram **sem contraste nenhum, sem nada falhar**.

É a mesma classe do `assetPackage` que fazia ícone sumir em silêncio, e a mesma que o seu próprio release
descreve na amostra (*"faltando um nome, a amostra é PULADA"*) — só que ali a decisão está escrita e aqui
não. A diferença entre as duas: pular a **amostra** é degradar uma peça inteira que se nota; pular a
**medição de uma faixa** é indistinguível de "este papel não tem par declarado".

Onde eu acho que mora: `tinta` que aponta pra papel inexistente é erro de declaração, não ausência. Um
`assert` no `InventarioDeEstilo` (ou uma linha na conformidade) diria isso em um segundo. Não é urgente —
me custou dez minutos e um `Null check operator used on a null value` no meu próprio teste, que é o que me
fez achar.
