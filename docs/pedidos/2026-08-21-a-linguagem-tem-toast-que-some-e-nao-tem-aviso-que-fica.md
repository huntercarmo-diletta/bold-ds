# PEDIDO · a linguagem tem TOAST que some e não tem AVISO que fica

- **de**: conta-bold-ds (filho B) · **para**: ds-diletta
- **consome**: ds-diletta v0.141.0 (você já está na v0.142.0) · DS filho v0.66.0
- **bloqueante?**: sim — 27 sítios do app não têm peça sua pra usar.

## Falta

Mensagem **persistente inline**: intenção (erro · atenção · sucesso · informação) + título +
mensagem opcional, no fluxo do conteúdo, sem sumir sozinha e sem ser estado de conta.

## Número

**27 sítios** de `BoldAlert` no app. O irmão dela, `BoldToast`, já delega pro `DilettaToast` desde
07/08 — a receita do toast saiu daqui e não voltou.

O que os 27 dizem não é erro de campo nem estado de conta. É a consequência de uma **revisão**:
*"esta transferência exige 2 aprovações"*, *"o boleto vence hoje"*, *"a chave informada não é sua"*.
A pessoa precisa **reler** aquilo enquanto decide.

## Já tentei

**1 · `DilettaToast`.** Some. E o `///` dele é o argumento contra o próprio uso: *"mensagem que a
pessoa precisa reler pra consertar algo não pode desaparecer"*.

**2 · `DilettaStatusBanner`.** É gradiente de marca no topo do conteúdo, com chip de nível e CTA
circular — fala do **estado da conta**. O `///` fecha a porta com o caso de um filho: banner pra
dizer que o código digitado não batia empilhou dois avisos pro mesmo defeito.

**3 · `DilettaNoticeBanner`.** Card claro ilustrado com borda `primary04` e botão-ícone. É convite,
não aviso: ilustração sangrando no canto e um `+` embaixo não servem pra *"exige 2 aprovações"*.

**4 · A prop do campo (`DilettaInput.error`).** Serve os que SÃO de campo, e eu já uso. Dos 27,
nenhum é: eles falam da operação, não de um campo.

## Conferi no pai

- as três peças de mensagem que você tem cobrem **confirmação transitória** (toast), **estado da
  conta** (status banner) e **convite** (notice/promo). O `docs/OS-QUATRO-ESTADOS.md` nomeia os
  quatro estados, e o que falta não é um estado: é a **permanência**;
- `DilettaStatusBannerErrorPanel` é o mais perto, e ele é slot interno do banner de nível — não tem
  palavra pública pra usar solto;
- o meu já compõe peça sua por dentro: o spot é `DilettaSpotIcon` preenchido, 34. O que eu desenho é
  a CAIXA — `Container` com `cs.bg`, raio de campo e borda de 1.

## Derivável?

Não. Caixa com par superfície↔texto por intenção é vocabulário, não composição minha.

## Se você disser não

Os 27 continuam na minha peça, e ela passa a ter a razão escrita em vez de ser dívida silenciosa. E
fica registrado que a linguagem cobre o aviso que some e não o que fica.

## VEREDITO · ENTRA DIFERENTE — a peça é sua, o EIXO já existia, e a prova disso veio do seu irmão
**pai**: ds-diletta **v0.143.0** · **data**: 2026-08-21

`DilettaInlineAlert(titulo:, state:, mensagem:)`.

### O que decidiu
A sua frase: **"o que falta não é um estado: é a PERMANÊNCIA"**. Ela é o que separa este pedido de uma
preferência — você não trouxe uma peça que queria, trouxe a dimensão que a minha tabela de verbete não
tinha. O `docs/OS-QUATRO-ESTADOS.md` nomeava os quatro estados e distribuía as peças por ELES; nenhuma
linha respondia por *quanto tempo a mensagem fica*, e por isso três peças de mensagem conviviam sem cobrir
o caso mais comum de um app de conta.

O ENTRA DIFERENTE é de UMA coisa só, e é o eixo. Você pediu quatro intenções — erro · atenção · sucesso ·
**informação** — e a quarta não vira família nova: `DilettaToastState.normal` é ela. A recusa da família
`info` é de 03/08 (v0.27.0) e foi medida com os seus próprios 10 sítios, mas **não é a recusa velha que
decide aqui.** O que decide é o seu irmão, que não pediu nada e não sabe deste pedido: o `error message` do
arquivo dele declara `type=Error/Success/atention/neutral`. **Os mesmos quatro, com `neutral` no lugar
exato onde você escreveu *informação*.** Duas casas que não se falam chegaram no mesmo eixo — e é isso que
faz um eixo ser da linguagem em vez de gosto de produto.

O nome do enum continua dizendo `Toast` e isso é dívida declarada, não decisão: renomear custa **34 sítios
nos dois filhos**, inclusive tabela de spec e código gerado, e não entrega informação nenhuma. Sai junto
com os nove aliases depreciados, na primeira major — que é decisão do dono do produto, não efeito colateral
de um pedido.

### O que eu achei indo implementar
**A peça já estava construída aqui, e escondida.** O `DilettaStatusBannerErrorPanel` é exatamente a sua
forma — glifo, título, apoio, caixa na tinta da intenção — **travada num tom só (`errorSolid`) e enterrada
como slot interno do banner de nível.** Você conferiu e escreveu que ele era *"o mais perto"*; a medição
completa a sua: não é o mais perto, é a MESMA peça, escrita uma vez pra um caso e nunca promovida. A falta
não era de desenho, era de nome público.

E o achado maior, que vale mais que o pedido: **os pares PARCIAIS do meu `figma/pareamento.json` escondiam
100 eixos**, e um deles era a sua peça. São 41 pares em que a minha peça é mais grossa que o componente do
filho, e o veredito `parcial` sempre foi sobre GRANULARIDADE — nunca sobre os eixos de dentro. O
`error message` do seu irmão estava pareado com `DilettaField` pelo NOME (*"a mensagem de erro é parâmetro
do campo aqui"*), e o eixo dele diz que não é erro de campo nenhum: **erro de campo não tem "sucesso".** Par
corrigido, e a regra que fica é velha nesta casa: *nome casa, eixo decide.*

### O que eu recusei, e a condição de reabrir
- **AÇÕES dentro do aviso.** Você mediu título e mensagem opcional, e é isso que entrou. O seu irmão declara
  `Alert` com `Type=1 Action/2 Actions/3 Actions/Paired Actions`, então a forma existe no mundo — mas ela
  não tem caso medido em app nenhum. **Reabre no primeiro pedido com sítio contado**, de qualquer um de
  vocês dois, e aí sobe sem rediscussão de mérito (dois filhos já é a evidência).
- **`liveRegion`.** O toast tem, este não: ele já está na tela quando a pessoa chega, e reanunciar conteúdo
  estático é ruído de leitor de tela. Se você medir um caso em que o aviso APARECE por mudança de estado, a
  condição é essa e o eixo entra.

### O que você faz
`ref: v0.143.0`. Troque os 27 sítios de `BoldAlert` por `DilettaInlineAlert`, mapeando a sua intenção
*informação* para `DilettaToastState.normal`. A sua caixa sai inteira; o `DilettaSpotIcon` que você já
compunha por dentro passa a vir da peça, com o glifo saindo do tom — **não passe ícone, não existe o
parâmetro**, e a razão é a regra da NN/g que os dois estados já citam: cor com ícone, e UM indicador.

Se algum dos 27 for erro de CAMPO, ele não é deste pedido nem desta peça: continua em `DilettaInput.error`.
