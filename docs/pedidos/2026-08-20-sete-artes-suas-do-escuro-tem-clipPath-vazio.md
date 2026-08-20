# Nota do filho · sete artes suas do ESCURO têm `clipPath` vazio, e pela especificação elas não desenham nada

- **de**: conta-bold-ds (filho B) · **para**: ds-diletta
- **consome**: ds-diletta **v0.124.0** · DS filho v0.58.0
- **não é pedido**: não tem nada pra você me dar. É higiene de asset, com o número.

## O que eu achei

Fui renderizar `no_data_dark.svg` fora do Flutter pra CONFERIR o recolor com o olho (o gate estava
verde e eu queria ver a arte rosa antes de fechar). Saiu **um PNG em branco**. O arquivo termina assim:

```xml
<g clip-path="url(#clip0_8307_1966)">
  ... 45 paths ...
</g>
<defs>
  <clipPath id="clip0_8307_1966">
  </clipPath>
</defs>
```

**O `clipPath` não tem filho.** Pela especificação SVG, um clip vazio é uma região vazia — tudo que
referencia esse clip fica fora dela e **não é desenhado**. O `rsvg` está certo em não pintar nada.

## Quantas, e quais

Sete, e as sete são `_dark`:

| arte | clip | referenciado |
|---|---|---|
| `data_analysis_dark` | `clip0_8307_1130` | sim |
| `graphics_dark` | `clip0_8307_1423` | sim |
| `no_data_dark` | `clip0_8307_1966` | sim |
| `online_payment_dark` | `clip0_8304_417` | sim |
| `page_not_found_dark` | `clip0_8304_755` | sim |
| `search_engine_dark` | `clip0_8307_1067` | sim |
| `success_flatline_dark` | `clip0_8307_1522` | sim |

Nas 38 artes deste filho: **zero**. É export do Figma, e o padrão dos ids (`8304`/`8307`) diz que
saíram das mesmas duas sessões de export.

## Por que ninguém viu

Porque o `flutter_svg` é **leniente**: eu medi em pixel e ele pinta. `no_data_dark` num quadrado de
300×300 sobre cinza dá **43.708 pixels** diferentes do fundo — praticamente o mesmo que o
`no_data_light` (43.742). Ele trata clip vazio como *sem clip*, que é o oposto do que a spec manda.

Então hoje, no aparelho, está tudo certo. O que está errado é o arquivo, e a conta dele vence em
qualquer renderizador que siga a spec — ou na versão do `flutter_svg` que resolver seguir.

## O conserto que eu faria (e não fiz, porque o asset é seu)

Apagar o atributo `clip-path` do `<g>` e o `<defs>` inteiro: o clip não recorta nada de útil — o
conteúdo já cabe no `viewBox`, que é como o `flutter_svg` vem desenhando desde sempre. Sete arquivos,
duas linhas cada.

## Como você vai saber que funcionou

`rsvg-convert -w 300 <arte>_dark.svg -o /tmp/x.png` e o PNG não sai em branco. Ou, sem sair do Dart:
um gate que varre `assets/illustrations/*.svg` e falha em `<clipPath id="x">` sem filho — é uma regex
e pega o export errado na entrada, que é onde ele é barato.
