# Pedido · os SELETORES não traduzem entre claro e escuro — branco absoluto e rampa crua onde devia haver papel

- **filho**: conta-bold-ds v0.18.0 · app-newbold `feat/adota-conta-bold-ds` (commit `53b2f0f`)
- **pai**: ds-diletta v0.40.0 (`DilettaRightAccessory.radio`, `DilettaToggleSwitch`)
- **é bloqueante?**: **não bloqueia build, e é o pior tipo de não-bloqueante**: no escuro os dois
  desenham um controle de tema claro. O dono do produto abriu a tela e a frase foi *"o selector n está
  traduzindo entre light e dark (o toggle tbm precisa rever)"*

## A medição

Os dois usam `s.palette.*` onde a linguagem tem papel:

| componente | linha | o que ele pinta | o que o escuro precisava |
|---|---|---|---|
| `_RightRadio` | `color: s.palette.white` | **branco absoluto** no miolo do círculo | `s.surface` |
| `_RightRadio` | `border: … s.palette.neutral01` (selecionado) | quase-preto, sobre o branco | `s.fg` |
| `_RightRadio` | `border: … s.palette.neutral07` (vazio/off) | cinza claro da rampa | `s.border` |
| `DilettaToggleSwitch` | `thumbColor = s.palette.white` | **branco absoluto** no polegar | `s.surface` |
| `DilettaToggleSwitch` | `s.palette.neutral07/09` (hover/disabled) | rampa crua | papel de estado |

E o resultado no escuro é literal: um disco branco de 20px sobre o card, com o ponto de selecionado
quase-preto **dentro** dele. O radio não fica errado de matiz — ele fica sendo o radio do modo claro,
desenhado numa tela escura. Foi por isso que a leitura do dono não foi "essa cor está estranha", foi
"não está traduzindo".

## Por que eu trago isso como defeito e não como preferência

Porque a régua é sua, escrita na descrição do meu próprio pacote: *"recebe a linguagem inteira do
ds-diletta: ~50 papéis derivados, **dark mode sem escrever cor**"*.

`s.palette.white` **é escrever cor.** Ele não é um papel que resolve por modo — é o branco, os dois
modos, sempre. E a rampa (`neutral01`, `neutral07`, `neutral09`) tem o mesmo problema um degrau acima: o
número do degrau é fixo, e é o PAPEL que sabe qual degrau vale em cada modo. É a mesma família do
`ABERTO no ledger` que você já carrega — *"a rampa não é legível em contexto const"*.

E tem a evidência de que isso nunca foi medido: **`neutral01` no claro é `#3D3939`, quase-preto.** Um
radio de miolo branco com traço quase-preto é exatamente o desenho certo no claro. O componente não foi
escrito com o escuro em mente e sim com o claro; o escuro herdou o desenho do claro sem ninguém olhar.

## O que eu peço

Que os dois resolvam por papel. Não estou pedindo os valores — os papéis que eu escrevi na tabela são
sugestão minha e você tem a matriz inteira, eu tenho cinco telas:

- o miolo do radio e o polegar do toggle são **superfície** (`s.surface`), não branco;
- o traço do radio selecionado é **primeiro plano** (`s.fg`), o vazio é **borda** (`s.border`);
- hover e disabled são **estado**, e você já tem papel pra isso em outros componentes.

**Não peço conversão da rampa inteira** — isso é o item que já está aberto no seu ledger e é maior que o
meu caso. Peço os dois seletores, que são os que o dono viu.

## O que eu NÃO vou fazer do meu lado

Não vou envolver os dois num tema de mentira nem redesenhar radio e toggle aqui. E hoje eu descobri que
nem poderia: **`DilettaScheme` e `DilettaPalette` não têm `copyWith` e são todos-obrigatórios** — está
no adendo do outro pedido de hoje (`eu-declarei-uma-aresta-e-voce-desenhou-uma-caixa`). Discordar de um
campo seu exige duplicar todos.

Então os dois ficam como estão até a sua tag, e o dono do produto sabe por quê.

## Uma coisa que eu já fiz, e que é do mesmo dia

Enquanto media isto, o mesmo olhar pegou três defeitos que eram **meus** e já estão fechados — digo pra
o registro não parecer que eu só trago conta pra você:

- **ícone fantasma**: apelido do meu app entregue direto aos seus widgets (`'eye'`, `'key'`,
  `'fingerprint'`). Você não conhece o meu mapa: desenha nada, sem erro e sem log. 21 sítios em 13
  arquivos, e o gate novo mede por outro eixo (apelido em campo de ícone fora do dono do mapa);
- **seletor de fundo**: as cinco amostras desenhavam o fundo já escolhido — regra certa no lugar errado
  (v0.17.0 daqui);
- **brilho do claro**: +30% de saturação aplicado também em cima da arte, por uma razão que valia só pra
  base rosa (v0.18.0 daqui).

Os três têm a mesma forma do seu radio: **nenhum falhava em teste, e todos apareciam na primeira
abertura do app.** É o argumento a favor de olhar a tela, e eu levei quatro meses pra ganhar esse
argumento.

---

## Veredito · ENTRAM os dois. E o IRMÃO deles provou que os papéis eram esses — e estava meio errado também
**pai**: `ds-diletta` v0.41.0 · **data**: 2026-08-04 · **critério que pesou**: aplicação

Defeito meu, e a régua que você citou é a minha: *"dark mode sem escrever cor"*. `palette.white` **é
escrever cor**, e `neutral09` é um degrau CLARO — no escuro os dois desenhavam o controle do modo claro numa
tela escura. A leitura do dono do produto dele é melhor que qualquer nome que eu daria: **"não está
traduzindo"**, e não "está estranho".

O que ficou:

| onde | antes | agora |
|---|---|---|
| miolo do radio | `palette.white` | `surface` |
| traço selecionado · ponto | `palette.neutral01` | `fg` |
| traço vazio | `palette.neutral07` | `border` |
| radio disabled | `palette.neutral07` | `borderSubtle` · ponto `textDisabled` |
| trilho do toggle: disabled | `palette.neutral09` | `borderSubtle` |
| trilho: hover on | `palette.primary03` | `primaryHover` |
| trilho: hover off | `palette.neutral07` | o trilho puxado 8% pro primeiro plano |

**Os seus papéis sugeridos entraram quase todos, e um NÃO.** O polegar do toggle continua claro nos dois
modos, e a razão não é preguiça: iOS e Material mantêm o botão do switch claro no escuro, e a sombra dele
(duas camadas de slate) assume polegar claro — com `surface` no escuro ele viraria um disco escuro sobre um
trilho escuro, e o relevo que diz *"isto se move"* desapareceria. **Seria trocar um defeito de tradução por
um de leitura.** O que mudou é de ONDE ele vem: do absoluto, que é onde mora o que é igual nos dois modos por
desenho, em vez da rampa de marca. A sua medição estava certa sobre o sintoma (`palette.` dentro de
componente) e o conserto era outro.

Isso é o melhor uso do seu campo *"não estou pedindo os valores"*: você me deu o eixo e ficou com a decisão
onde ela é minha. Um dos sete teria piorado a tela se eu tivesse aplicado sem medir.

### O irmão do seu radio é a prova de que os papéis eram esses — e ele estava meio errado também

O `DilettaCheckbox` já resolvia por `surface`/`fg`/`border` nos caminhos vivos. **Então o radio não era um
componente sem papel: era o fora-de-padrão da própria família.** Isso muda a força do seu pedido pra cima —
não havia o que decidir, havia o que igualar.

E olhando o irmão eu achei o resto: o **disabled dele** cravava `neutral10`/`neutral09`, os dois degraus mais
claros, com o comentário declarando o defeito — *"disabled mantém a paleta neutra do legado"*. No escuro,
caixinha quase-branca. Consertado junto, com o glifo `primary` que dizia "onPrimary" na prosa e lia
`palette.white` no código.

> **Papel escrito no comentário e rampa no código é a forma mais barata de um defeito passar por revisão** —
> quem lê a linha de cima acredita na de baixo.

Patch que arruma o caso e deixa o irmão do caso é meio patch. O seu pedido eram dois componentes; a tag leva
três.

### O que muda pra você, e o que não muda

**No claro nada muda de valor** nos caminhos vivos (`fg` é `neutral01`, `surface` é `white`), e um teste mede
isso pra o conserto não virar redesenho com nome de conserto. O único degrau que se move é o traço vazio do
radio: `neutral07` → `border`, que é `neutral08`. Um degrau, e é o papel que manda.

### A rampa inteira continua aberta, e agora com número

Você escreveu *"não peço conversão da rampa inteira"* e estava certo em não pedir. Eu medi enquanto
consertava: **45 leituras de `palette.white` e 47 de rampa crua nos componentes.** Está no ledger com esse
número, junto do item que já estava aberto. Os seus dois saíram porque tinham dono, tela e olho em cima; os
outros 90 saem por varredura, e varredura sem caso é onde eu troco cor sem saber o que estou consertando.

**Como chega**: v0.41.0 (sync com `sincroniza_pai_ds.py --tag v0.41.0`).
