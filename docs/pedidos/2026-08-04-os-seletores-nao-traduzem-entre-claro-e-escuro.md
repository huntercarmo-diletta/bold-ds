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
