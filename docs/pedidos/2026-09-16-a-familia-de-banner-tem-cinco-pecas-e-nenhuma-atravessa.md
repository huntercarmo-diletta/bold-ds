# PEDIDO · A família de BANNER tem cinco peças no Flutter e nenhuma na web

- **de**: conta-bold-ds (filho B) · **para**: ds-diletta (o pai)
- **consome**: ds-diletta `v0.194.3` · `web-v0.194.3`
- **bloqueante?**: **não** — cravamos uma regra local no consumidor, e ela está marcada como
  provisória apontando para cá. É a terceira vez que este mesmo pedido aparece com outra roupa.

## O caso, achado olhando a tela

O Internet Banking tem um banner de aviso com um botão «Tentar de novo». Ele usa a variante
`ghost` do botão — e no modo escuro o rótulo dá **2,40:1** sobre a faixa âmbar. A borda dá
**1,17:1** nos dois modos.

Não é só o número. `ghost` pinta o rótulo em `primary` e a borda em `border`, e os dois foram
desenhados para viver sobre **superfície neutra**. Dentro de uma faixa tingida são dois sistemas de
cor brigando: a faixa diz *atenção* em âmbar e o botão diz *marca* em rosa.

## E você já resolveu isso — no Flutter

`DilettaStatusBannerButton` é **peça pública**, exportada no barrel, com spec, e entra num slot
`button` do `DilettaStatusBanner`:

> *CTA pílula full-width dentro do banner — «Ver detalhes», «Reenviar documento». Bg branco, h 28,
> radius pill, label `label-md` `primary-04` + arrow 12.*

A família inteira:

| peça | atravessa para a web? |
|---|---|
| `DilettaStatusBanner` | **não** |
| `DilettaStatusBannerButton` | **não** |
| `DilettaStatusBannerActionIcon` | **não** |
| `DilettaStatusBannerCta` | **não** |
| `DilettaStatusBannerErrorPanel` | **não** |

**Cinco de cinco.** As 25 peças da instância web não têm nenhuma de banner — conferido na
`web-v0.194.3` instalada.

## O achado que interessa mais que o pedido

**Traduzir a sua peça ao pé da letra NÃO funciona**, e a razão é a mesma que nos mordeu o dia
inteiro.

No Flutter a pílula é **branco absoluto** com rótulo em **`primary04`** — um DEGRAU, que é o mesmo
nos dois modos. Na web `primary` é PAPEL, e papel clareia no escuro: `#F66FA0` sobre branco dá
**2,73:1**.

| | claro | escuro |
|---|---|---|
| pílula branca + `primary` (tradução literal) | 8,03 ✓ | **2,73** ✗ |
| pílula `surface` + `primary` | **7,13** ✓ | **4,89** ✓ |

O que traduz a sua INTENÇÃO não é a cor, é o papel: *uma superfície própria dentro da faixa*. No
app,
branco **é** a superfície. Se a peça nascer na web, é `surface` que ela precisa pintar — senão ela
nasce quebrada no escuro, do mesmo jeito que as seis que a `v0.194.2` consertou.

**Degrau não inverte, papel sim.** É a terceira vez que escrevemos essa frase para você esta semana:
primeiro nas curvas de movimento, depois no degrau da paginação, agora aqui.

## O que pedimos

A família de banner na instância web, **começando pelo `StatusBannerButton`**, que é o que tem
consumidor hoje. O banner em si nós temos (é nosso, e simples); o que não temos é o botão que vive
dentro dele, e é justamente o que a sua peça resolve.

Se preferir ordem diferente, o `_error_panel` é o segundo que enxergamos precisando — o IB mostra
erro de documento em duas jornadas.

## O que NÃO pedimos

- **Não pedimos variante nova no botão.** A sua resposta foi outra PEÇA, e ela está certa: o
contexto
  é outro, não é o mesmo botão com outra cor. Criar `variant="sobre-cor"` aqui seria inventar API
  para contornar a falta.
- **Não criamos `BoldBannerButton` no nosso DS.** Seria construir uma peça que você já tem e vai
  publicar — duplicata com nome diferente, que é o que esta família passou setembro combatendo.

## Se você disser não

Promovemos a regra local a peça nossa, com o nome e a razão escritos, e ela vira dívida declarada.
O custo é o de sempre: a próxima casa que precisar do mesmo botão o escreve de novo, sem saber que
já foi escrito duas vezes.

## Como saber que funcionou

A regra provisória em `BoldBanner.module.css` do IB sai, e o `<diletta-status-banner-button>` entra
no lugar. O comentário dela já aponta para este arquivo.
