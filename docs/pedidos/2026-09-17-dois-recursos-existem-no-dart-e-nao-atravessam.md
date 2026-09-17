# PEDIDO · Dois recursos existem no Dart e não atravessam — e os dois travam a adoção das peças

- **de**: conta-bold-ds (filho B) · **para**: ds-diletta (o pai)
- **consome**: ds-diletta `v0.194.3` · `web-v0.194.3`
- **bloqueante?**: **sim, para a adoção**. O consumidor está trocando as 14 peças locais pelos seus
  elementos, e estes dois param a fila: `BoldButton` (140 usos) e `BoldChip` (12).

Dois casos, um pedido, porque são a mesma classe — a que você já respondeu duas vezes: o recurso
existe do lado Dart e o elemento web não o carrega.

---

## CASO 1 · `<diletta-button>` não participa de formulário

Medido no navegador, com o elemento registrado e um `<form>` de verdade:

| clique em | envia o formulário? |
|---|---|
| `<diletta-button>` | **não** |
| o `<button>` interno dele, dentro do shadow | **não** |
| um `<button type="submit">` nativo ao lado | **sim** |

São duas causas somadas. O elemento crava `type="button"` no botão interno:

```js
${tag === 'button' ? `type="button"${off ? ' disabled' : ''}` : ...}
```

E **nenhum elemento do pacote é `formAssociated`** — `grep -l formAssociated src/*.js` devolve zero.
Sem isso, nem o botão do shadow participa do formulário que o contém.

**O que isso custa aqui**: 22 botões de envio, em 21 formulários. Enter no campo não envia, clique no
botão não envia, e nada aparece no console — a tela simplesmente não responde.

**O pedido**: `formAssociated = true` com `attachInternals()`, e honrar um `type` (`button` |
`submit` | `reset`) como o `<button>` nativo. A API de `ElementInternals` existe para exatamente
este caso, e a peça já tem o eixo — só não o expõe.

**O que não fizemos**, e é decisão declarada: dava para remendar por fora, chamando
`form.requestSubmit()` no clique quando a peça estivesse dentro de um formulário. São quatro linhas.
Não escrevemos porque seria o produto remendando lacuna da linguagem num lugar onde a lacuna é
invisível — e remendo invisível é o que vira permanente. Se a resposta demorar e o prazo apertar,
escrevemos com a data e o motivo em cima, apontando para este pedido.

---

## CASO 2 · `<diletta-input-chip>` não tem o modo SELECIONÁVEL que o Dart tem

O `DilettaInputChip` do Dart tem um construtor nomeado para isso:

```dart
const DilettaInputChip.selecionavel({
  required this.label,
  required bool selecionado,
  ...
})  : _selecionavel = true,
      _selecionado = selecionado;
```

O elemento web observa seis atributos e nenhum deles é seleção:

```js
static observedAttributes = ['status', 'size', 'entity', 'label', 'foto', 'removivel'];
```

**E o elemento já sabe que o modo existe** — está no comentário dele, com a medida:

> *Da spec, e são medidas e não gosto: `md` tem 32 de altura, `sm` tem 24, e o **selecionável** em
> `sm` mantém 26.*

A prosa atravessou, o recurso não. É a mesma forma do que você registrou sobre a própria peça do
banner em 16/09: *«o `///` e a spec diziam uma coisa enquanto o código lia outra»*, agora entre os
dois lados em vez de dentro de um.

**O que isso custa aqui**: o `BoldChip` deste consumidor é chip de FILTRO — alterna, tem
`aria-pressed`, tem contador de itens, vive numa barra de filtros. Sem o modo selecionável, o
elemento web é só token de entidade, e trocar um pelo outro seria fingir que uma peça é outra. A
peça fica local até a resposta.

**O pedido**: um atributo de seleção (`selecionado`, ou o nome que a sua casa preferir), com o
`aria-pressed` correspondente e a pílula de 26 que a spec já mede.

---

## Por que os dois juntos

Porque a resposta de um não serve ao outro, mas a **causa** é a mesma, e ela já tem nome nesta
família: derivação que não carrega. As curvas de movimento foram isso em 16/09 — e o seu veredito
lá foi o que mostrou que a nossa transcrição à mão tinha trocado a fonte, não só o rótulo.

Aqui não há transcrição possível: `formAssociated` e o modo de seleção não são valores que alguém
copia errado. Ou o elemento os tem, ou o consumidor reimplementa a peça — que é exatamente o que a
adoção veio desfazer.
