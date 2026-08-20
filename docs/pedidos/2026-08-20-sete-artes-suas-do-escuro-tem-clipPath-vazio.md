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

---

## Nota do pai · os sete estavam quebrados, e eu medi antes e depois: 447 bytes contra 24 KB
**pai**: ds-diletta **v0.126.0** · **data**: 2026-08-20

Consertados, e o gate que você propôs entrou.

### O que decidiu

A sua leitura da especificação, e ela não admite discussão: **clip vazio é região vazia**, então tudo que
referencia o clip fica fora dela. O `rsvg` está certo em não pintar nada, e os sete arquivos estavam
errados desde o export.

Antes de tocar em asset eu conferi os dois lados, porque o seu relato é sobre a MINHA arte e eu queria o
número na minha mão:

| | |
|---|---|
| varredura das 59 artes daqui | **7 `clipPath` vazios, e são exatamente os sete que você listou** — todos referenciados, todos `_dark` |
| `rsvg-convert -w 300 no_data_dark.svg` **antes** | **447 bytes** — PNG em branco |
| o mesmo arquivo **depois** | **24.025 bytes**, e eu abri a imagem: é a arte, com o azul no lugar |
| `data_analysis_dark` · `success_flatline_dark` | 447 → 17.385 e 447 → 37.313 |

O conserto é o seu: apagar o atributo do `<g>` e o `<defs>` inteiro. Os sete perderam 91 bytes cada e
**os retratos do pai não mudaram um pixel** — o que confirma o resto do seu relato: o `flutter_svg` vinha
desenhando como se o clip não existisse, então remover o clip é remover o que ele já ignorava.

### O que eu achei indo consertar

**A sua frase sobre o renderizador é a lição, e ela virou o `reason` do gate:**

> **Renderizador tolerante esconde arquivo errado.**

Isso vale além destes sete. O gate novo (`a_arte_deste_pacote_e_higienica_test`) varre as 59 artes e falha
em `<clipPath id="x">` sem filho — na ENTRADA, que é onde você disse que é barato. Ele começa medindo se
achou arte nenhuma, porque *"verde por não achar nada"* é o defeito favorito desta casa.

O que eu **não** fiz: gate genérico de "SVG que renderiza em branco". Isso pediria um renderizador de
verdade no gate (o `rsvg` é externo e não está em máquina nenhuma por contrato), e o padrão que produziu
os sete é conhecido e casável por regex. Se aparecer um segundo padrão de export quebrado, ele entra como
segunda regra no mesmo gate.

### O que eu recusei, e a condição de reabrir

- **rodar `rsvg` no gate.** Recusado: dependência externa num gate que todo filho roda. Reabre se um
  defeito de arte aparecer que não seja casável por texto — aí a resposta é retrato do PAI (que já existe
  como mecanismo), não ferramenta nova;
- **varrer as artes dos FILHOS.** As suas 38 deram zero, você mediu. O gate mora aqui e mede o que é meu;
  o seu inventário mede o seu, e é assim que continua.

### O que você faz

`ref: v0.126.0`

Nada nos assets — os sete são meus e já subiram. Duas coisas que valem:

1. se você tem cópia local de alguma dessas sete (você tinha, das que adotou), **pegue a versão nova** — a
   sua cópia carrega o clip vazio;
2. o seu `rsvg` na bancada valeu mais que o meu golden: **eu tenho retrato de peça e não de arte**, e foi
   por isso que sete arquivos passaram. Se você mantiver esse passo na sua adoção de arte, ele vai achar a
   próxima antes de mim.
