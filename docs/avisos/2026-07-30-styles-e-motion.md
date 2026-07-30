# RELEASE · a aba de Styles se desenha do seu inventário, e o motion ANIMA
**de**: catalogo-diletta v0.38.0 · **para**: conta-bold-ds · **data**: 2026-07-30

## O que mudou / o que eu recomendo

Dois achados do dono do produto, e o primeiro é de vocabulário — vale pros dois catálogos:

| | o que é | como se usa |
|---|---|---|
| **Foundations** | as DECISÕES: o que cada papel de cor significa, a gramática de superfície, por que a escala tem esses degraus | **se lê uma vez, e ensina.** É prosa |
| **Styles** | o INVENTÁRIO: rampa, degraus de tipo, raios, espaço, movimento | **se consulta.** É tabela |

Misturado, faz o pior dos dois: quem quer aprender rola por cima de 51 swatches, e quem quer conferir um
hex lê três parágrafos de justificativa. **Se a sua aba chamada "Fundamentos" mostra swatches, ela é
Styles** — e agora tem para onde ir.

Declare o inventário e a página se desenha:

```dart
PlugueDoDs(
  estilos: InventarioDeEstilo(
    cores: {'primary04': MeuDs.primary04, …},
    tipos: {'bodyMd': MeuType.bodyMd, …},
    raios: {'folha': 22, 'card': 16, …},
    movimentos: {'folha': MotionDaTransicao(duracao: …, curva: …, token: 'MeuMotion.folha')},
  ),
)
```

```dart
AbaDoCatalogo(id: 'styles', label: 'Styles', constroi: (_) => const AbaDeStyles())
```

**Espaço você não declara de novo**: sai de `spacingTokens`, que você já tem. Duas fontes pro mesmo
número é o defeito que esta família registrou três vezes.

**Cada família vem com o número junto do desenho** — hex na cor, tamanho e peso no tipo, o raio
DESENHADO (é a única forma de ver que 22 e 24 são diferentes), e o espaço em barra ordenada pelo valor.

## O motion anima, e é o ponto

Tabela de duração não é motion: **300ms com `easeOut` e 300ms com `elasticOut` têm a mesma linha na
tabela e são coisas diferentes na tela.** Cada token que você declarar em `movimentos` toca ao abrir a
página e ao toque, com a sua duração e a sua curva.

Se você já tem `motionDaTransicao` no plugue (o board usa pra tocar a seta), os valores são os mesmos —
o que falta é listá-los em `movimentos` pra eles terem página.

## O que você faz

1. declare `estilos` com as famílias que você tem — família não declarada não aparece, e não vira seção
   vazia;
2. troque a sua aba de styles pela `AbaDeStyles` e apague a página à mão;
3. **se a sua aba de fundamentos era styles, renomeie.** O id da aba é contrato (entra na URL), então
   trocar o id quebra link salvo: prefira criar `styles` e deixar `fundamentos` pra quando a prosa
   existir.

## Como isso chega

Troque o `ref:` do `catalogo-diletta` pra **v0.38.0**.

## Prazo

Nenhum: sem `estilos` declarado a aba diz o que declarar, e a sua página atual continua funcionando.

**E o que NÃO veio:** a página de Foundations. Ela é prosa, e prosa não se deriva de token — precisa de
renderizador de markdown no motor, que é bicho próprio. A prosa já viaja no pacote do DS pai
(`kDilettaSpecs`); falta desenhar, e está no ledger como fatia própria. Não escreva a sua à mão agora,
porque é exatamente o trabalho que a próxima fatia joga fora.
