# PEDIDO · O campo tem UM porte e o botão tem TRÊS — falta `sm` e `md` em `input` e `dropdown`

- **de**: conta-bold-ds (filho B) · **para**: ds-diletta (o pai)
- **consome**: ds-diletta `v0.207.0` · `web-v0.207.0`, pela tag `web-v0.114.0` deste repo
- **bloqueante?**: **sim, para 10 campos** — não porque quebre, mas porque adotar a peça
  neles muda a densidade da tela, e a decisão de desenho fica trancada num número que o
  consumidor não pode pedir.

> **Nota de procedência.** Achado no **core-flow-wa** (o webadmin), fechando a adoção. A
> designer olhou uma tela de configuração com seis seletores de 32px empilhados, viu o
> campo do DS em 48, e perguntou: «os inputs e dropdown só têm um tamanho? Não tem lg, md,
> sm, por exemplo?»

## O caso, em uma linha

Todo controle interativo da família tem eixo de tamanho, menos os dois que são campo.

## Medido na fonte dos elementos instalados

```
diletta-button.js       PORTE { sm 28, md 36, lg 56 }      ALVO 44    3 portes
diletta-icon-button.js  PORTE { sm 32, md 40, lg 56 }      ALVO 44    3 portes
diletta-input-chip.js   ALTURA { sm 24, md 32 }            ALVO 44    2 portes
diletta-status-tag.js   PORTE ['compacta', 'ampla']                   2 portes

diletta-input.js        48px  (96 no `long`)               ALVO 44    UM
diletta-dropdown.js     48px                                          UM
```

**A comparação que fecha o argumento é o chip.** Ele tem dois portes, e os dois são
MENORES que o único do campo — 24 e 32 contra 48. Um chip de 24px e um campo de 48 na
mesma barra é a família dizendo que 24 é uma altura legítima de controle, e que campo não
pode tê-la.

## O arranjo já existe, e é o mesmo nas três peças que têm porte

O `///` do botão:

> *«O ALVO É MAIOR QUE O DESENHO no porte pequeno: 28 de botão dentro de 44 de alvo. Mesmo
> arranjo do chip e do DilettaAlvoDeToque — crescer o botão até 44 mudaria o ritmo da
> tela, que é justamente o que a altura carrega.»*

E o do campo, sobre o olho da senha:

> *«O olho é ALVO DE TOQUE: 44 é piso da 2.5.8, e ele não pode crescer a caixa de 48 — por
> isso o recuo negativo, o mesmo arranjo do chip.»*

Ou seja: **a peça de campo já conhece e já usa a separação alvo/desenho.** O que falta é
aplicá-la à própria caixa, como as outras três fazem. Não é mecanismo novo; é o mecanismo
que ela já tem, num eixo que ela não publica.

E é literalmente a frase do `///` do botão que sustenta o pedido: *«a altura carrega o
ritmo da tela»*. Num formulário de seis campos, o ritmo é o que está em jogo.

## Onde isso dói, medido campo por campo

No webadmin, dos 21 campos ainda crus, **17 podem adotar a peça** — e dez deles crescem:

| tela | campos | hoje | com a peça |
|---|--:|--:|--:|
| criar gestor · criar perfil | 3 | **21px** | 48 (**+27**) |
| configurar botões | 6 | **32px** | 48 (**+16**) |
| configuração, campos hex | 4 | **34px** | 48 (**+14**) |
| login, trocar senha | 4 | 48px | 48 (=) |

Os três de 21px são formulários curtos e o crescimento até melhora — 21px é a altura
padrão do navegador, que é pequena demais. **O problema são os seis de 32.** Eles ficam
empilhados num formulário de configuração; a 48 o bloco cresce 96px e a tela passa a
rolar onde não rolava.

Com `sm` (24 ou 28) e `md` (32 ou 36) publicados, esses seis adotariam a peça sem discussão
de densidade — que é o que este pedido quer destravar.

## O que não estamos pedindo

Não pedimos um número específico. A escala é da linguagem, e ela já tem duas famílias de
resposta possíveis: a do botão (28/36/56) ou a do chip (24/32). Qualquer das duas resolve;
escolher é de quem desenha a linguagem.

Também não pedimos porte no `long` (o textarea): ele tem 96 por ser multilinha, e altura
de área de texto é outra conversa.

## O que o consumidor está fazendo enquanto isso

**Parando.** Os dez campos ficaram crus de propósito, com a razão escrita na descrição da
PR: «subir todos para 48 é decisão de densidade, não troca mecânica». Preferimos adotar a
peça uma vez, no porte certo, a adotá-la em 48 agora e mexer nos mesmos dez sítios depois.
