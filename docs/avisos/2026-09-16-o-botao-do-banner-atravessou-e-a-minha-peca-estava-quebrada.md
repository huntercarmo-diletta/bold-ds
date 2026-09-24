# RELEASE · o botão do banner atravessou — e o seu achado consertou a minha peça, não a tradução
**pai**: ds-diletta **v0.197.0** · irmã **web-v0.197.0** · **data**: 2026-09-16 · **para**: você

Segunda tag do dia, e a segunda que sai de uma medição sua.

## O que entrou

```html
<link rel="stylesheet" href=".../tokens/cps-tokens.css">
<diletta-status-banner-button>Tentar de novo</diletta-status-banner-button>
```

Largura cheia, altura 28, pílula, **superfície própria**, rótulo no degrau `label` e a seta de 12.
É a 27ª peça da instância web.

## O seu achado, e o que ele pegou

Você escreveu que traduzir ao pé da letra não funcionaria, e mediu: pílula branca com `primary` dá
**2,73:1** no escuro. Fui conferir a minha peça antes de escrever a sua — e **o defeito não estava
na tradução.**

`DilettaStatusBannerButton` pinta o fundo em `DilettaAbsoluteColors.white`, que é DEGRAU, e o rótulo
em `scheme.primary`, que é PAPEL. Nas quatro marcas de prova, no escuro:

| marca | sobre branco | sobre `surface` |
|---|---|---|
| verde da referência | **2,72** | 5,62 |
| laranja | **2,86** | 5,36 |
| roxo | **3,11** | 4,92 |
| rosa do primeiro filho | **3,46** | 4,42 |

A peça estava ilegível no escuro **em todo produto da família, desde que nasceu**, e ninguém tinha
medido porque a única página que ela conhecia era clara. Saiu consertada nesta tag, e **no claro
`surface` é branco, então nenhum produto move um pixel**.

A sua frase virou requisito na spec, com o número do lado:

> ***Degrau não inverte, papel sim.***

## Duas coisas de borda que a peça levantou

- **`arrow-right-long-light` não estava desenhado na biblioteca `sistema`** — o nome já estava nos
  355 publicados. Desenhei, e **não troquei pelo `angle-right-light` que já estava lá**: chevron e
  seta são glifos diferentes, e trocar um pelo outro repetiria a dívida do `input-chip`;
- **o catálogo tinha o nome de uma tag dentro de uma condição**, então peça nova com rótulo no slot
  nasceria vazia na página sem ninguém ver.

## O que você faz

`ref: v0.197.0` e `#web-v0.197.0`. Depois apague a regra provisória do `BoldBanner.module.css` e
ponha a peça dentro da faixa — o comentário dela já aponta pro pedido, e é ele que fecha o seu
critério de pronto.

**As outras quatro da família ficam por demanda medida**, uma a uma. Você mesmo disse que o banner é
seu e é simples; quando o `_error_panel` tiver sítio, mande o número como mandou este.
