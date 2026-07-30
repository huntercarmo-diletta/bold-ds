# RELEASE · Foundations agora é página, e a prosa do pai viaja
**de**: catalogo-diletta v0.41.0 · ds-diletta v0.18.0 · **para**: conta-bold-ds · **data**: 2026-07-30

## O que mudou / o que eu recomendo

A distinção estava decidida desde a v0.38.0 e faltava a metade que não se deriva:

| | o que é | como se usa |
|---|---|---|
| **Foundations** | as DECISÕES — o que cada papel significa, por que a escala tem esses degraus, a gramática | **se lê uma vez, e ensina** |
| **Styles** | o INVENTÁRIO dos valores | **se consulta** (e se desenha do seu `estilos`) |

Foundations é prosa, e prosa precisa de renderizador. Ele existe agora, com **tabela** — que era o
requisito e não o extra, porque a prosa desta família é cheia delas.

**E a prosa do pai VIAJA:** `kDilettaLinguagem` (DS v0.18.0) é o `docs/LINGUAGEM.md` inteiro dentro do
pacote. Você pluga sem copiar:

```dart
PlugueDoDs(
  fundamentos: {
    'A linguagem': kDilettaLinguagem,        // do pai, sem cópia
    'Nossa identidade': meuTextoDeMarca,     // o que é seu
    'Acessibilidade': meuTextoDeA11y,
  },
)
```

```dart
AbaDoCatalogo(id: 'fundamentos', label: 'Foundations', constroi: (_) => const AbaDeFundamentos())
```

A aba é índice à esquerda, uma seção por vez à direita — é a forma de todo doc longo, e evita a rolagem
de 2.000 linhas.

## O que você faz

1. **não copie a prosa do pai.** Cópia de prosa envelhece calada, e é a classe que a limpa persegue.
   Plugue `kDilettaLinguagem`;
2. escreva as SUAS seções: identidade do produto, decisões que são suas, acessibilidade do seu domínio.
   O que é da linguagem não é seu;
3. **se a sua aba "Fundamentos" mostra swatches, ela é Styles.** Use as duas: `AbaDeStyles` pro
   inventário e `AbaDeFundamentos` pras decisões.

O renderizador entende título, parágrafo, lista (com um nível de aninhamento), citação, código cercado e
tabela. **Não** entende HTML, imagem, link (o texto fica, o endereço sai — num catálogo offline ele não
leva a lugar nenhum), lista de três níveis e nota de rodapé. Se a sua prosa usa algo disso e você quer,
peça com o caso medido.

## Como isso chega

Troque o `ref:` do `catalogo-diletta` pra **v0.41.0**, e do `ds-diletta` pra **v0.18.0** (sync ou `ref:`,
conforme a sua fronteira).

## Prazo

Nenhum. Sem `fundamentos` declarado, a aba diz o que declarar e a sua página atual continua funcionando.
