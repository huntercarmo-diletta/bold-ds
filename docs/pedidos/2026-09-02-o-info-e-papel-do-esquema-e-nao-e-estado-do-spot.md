# PEDIDO · o `info` é PAPEL do esquema e não é ESTADO do spot — e a assimetria tem seis famílias de um lado e cinco do outro

- **de**: conta-bold-ds (a BASE da família) · **para**: ds-diletta
- **consome**: ds-diletta v0.155.0 · DS v0.91.0
- **bloqueante?**: não pro app, que desenha o disco à mão. Sim pra fechar a adoção: é a última
  decoração deste produto que reimplementa uma peça sua.

## Falta

`DilettaSpotState.info`.

## Número, e ele é a assimetria e não a contagem de sítios

O sítio é **um** — o cartão de "aguardando aprovação" nas autorizações. Um caso não vira pedido, e
eu não estaria escrevendo se o argumento fosse esse.

O argumento é que **o `info` já é papel na sua linguagem, e só o spot não sabe dele**:

| onde | tem `info`? |
|---|---|
| `CoreflowScheme` (os 22 papéis) | **sim** — `info` e `infoSubtle` |
| `DilettaStatusTone` (a etiqueta) | **sim** |
| `DilettaToastState` / o alerta em linha | **sim** (`normal` faz o papel) |
| `DilettaSpotState` | **não** — normal · disabled · primary · error · warning · success · loading · secure |

Seis lugares dizem "isto é informação" e o disco não diz. Um produto que precisa de um spot azul
tem duas saídas: desenhar o disco à mão (o que este app faz) ou mentir o tom (usar `normal`, que é
cinza, ou `primary`, que é a marca dizendo que aquilo é ação).

## Já tentei

**1 · `DilettaSpotState.normal`.** O disco fica cinza e o glifo perde o significado: um relógio de
areia cinza ao lado de "aguardando aprovação" lê como *desabilitado*, que é o oposto de *em
andamento*.

**2 · `DilettaSpotState.primary`.** Fica rosa. Marca num item que não é ação é a leitura errada, e é
a mesma classe do defeito que o seu `_resolveSpot` consertou em 04/08.

**3 · Desenhar à mão, que é o que está lá.** `Container` de 40 com `cs.info.withAlpha(26)` e o glifo
em `cs.info`: o alfa é escolha minha e nunca passou pelo seu gate de contraste — que é justamente o
que o `DilettaSpotIcon` tem e eu não.

## Derivável?

Não da minha parte. `info` é papel EXTRA da paleta (`papeisExtras['info']`), então o valor já viaja
por produto — o que falta é o estado que sabe lê-lo, e ele mora no `_resolveSpot`, que é seu.

## Conferi no pai

- o `DilettaSpotIcon` resolve os oito estados numa função só, e cada um é um par (fundo, tinta) com
  piso de contraste medido. Um nono entra pela mesma porta;
- `DilettaStatusTone.info` já existe e já tem par de cor — então a decisão de que cor `info` tem já
  foi tomada nesta linguagem, e este pedido não a reabre;
- o piso: no escuro, `info` sobre o tinte de `info` a 26 precisa passar o mesmo 3:1 dos outros oito.
  Se não passar com o alfa que a etiqueta usa, o número certo é seu — eu não tenho a medição.

## Se você disser não

O disco fica desenhado à mão e eu o declaro em
`app-newbold/test/o_que_ainda_desenha_tem_razao_test.dart`, com esta frase como razão: *"o
`DilettaSpotState` não tem info, e info É papel do esquema"*. É onde ele já está hoje.

## VEREDITO · MORA NO SEU DS — e quem respondeu foi a medição, não eu
**pai**: ds-diletta **v0.155.0** · **data**: 2026-09-02

Não entra. E o motivo não é o que o pedido supunha.

### O que decidiu

O pedido diz *"seis lugares dizem isto é informação e o disco não diz"*, e conferi a lista antes de
responder. Cinco dos seis são **seus**: o `CoreflowScheme`, a etiqueta, o alerta em linha. O sexto —
`DilettaStatusTone.info` — é meu, e ele é tom de ETIQUETA, não papel de esquema.

**Eu não tenho o papel `info`.** As famílias semânticas desta linguagem são sucesso, aviso, erro,
cofre e parceiro; o `info` é `papelExtra` da SUA paleta, com 39 usos entre o seu pacote e o seu app,
e **zero** em qualquer coisa minha.

Dar `DilettaSpotState.info` sem ter o papel seria uma de duas coisas, e as duas são piores que o
não: ou eu leio o extra da paleta de quem me chamou — e aí um estado meu passa a depender de uma
chave que só um produto declara —, ou eu cravo um azul, e aí a linguagem ganha uma sexta família
semântica por causa de um disco numa tela.

### O que eu recuso, escrito

Recuso **a família**, não o disco. Se um segundo produto desta casa declarar `info` como papel, a
conversa é outra e ela começa pelo esquema, não pelo spot — nessa ordem, porque estado sem papel é
um valor cravado com nome de token.

### O que você faz

O que você já fez, e a medição está no lugar certo: `CoreflowTomDoSpot.info` no seu pacote, com os
dois pares medidos contra o meu piso de 3:1 — **3,95** no escuro e **4,69** no claro. Os 18% de
alfa do escuro vieram da minha receita de outline (`warning`, `success` e `secure` usam o mesmo),
então o tom novo entrou na gramática que já existia em vez de inventar a dele.

Isto é o protocolo funcionando na direção menos comum: **o filho mediu, achou que o pedido não se
sustentava e implementou em casa** — com o gate que eu cobraria, porque pintar fora daqui é não
herdar o meu.
