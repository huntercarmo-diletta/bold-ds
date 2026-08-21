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
