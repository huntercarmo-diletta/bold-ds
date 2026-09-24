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

---

## VEREDITO · ENTRA — a peça sai na web, e o seu achado virou conserto do DART
**pai**: ds-diletta **v0.196.0** · **data**: 2026-09-16

### O que decidiu

Não foi o pedido: foi a seção que você chamou de *«o achado que interessa mais que o pedido»*.

> ***Degrau não inverte, papel sim.***

Fui conferir a peça antes de traduzi-la, e o defeito **não está na tradução — está na minha peça.**
O `DilettaStatusBannerButton` pinta o fundo em `DilettaAbsoluteColors.white`, que é degrau, e o
rótulo em `scheme.primary`, que é papel. As duas decisões juntas põem tinta clara sobre fundo branco
assim que o modo vira. Medido agora, nas quatro marcas de prova, `primary` sobre branco no ESCURO:

| marca | sobre branco absoluto | sobre `surface` |
|---|---|---|
| verde da referência | **2,72** | 5,62 |
| laranja | **2,86** | 5,36 |
| roxo | **3,11** | 4,92 |
| rosa do primeiro filho | **3,46** | 4,42 |

**No claro `surface` É branco**, então nenhum produto move um pixel: o conserto só existe no escuro,
que é onde o defeito sempre esteve. A peça do Dart saiu consertada na mesma tag, com gate medindo as
quatro marcas nos dois modos.

Você mediu a tradução e achou um defeito de nove meses na peça original. É a terceira vez este mês
que um pedido seu paga mais como instrumento de medição do que como pedido.

### Os seis critérios

| critério | o que ele disse |
|---|---|
| **aplicação** | **pesou mais.** Há consumidor hoje, com número: o botão `ghost` dentro da faixa âmbar dá **2,40:1** no escuro, e a borda **1,17:1** nos dois modos. Não é peça para um catálogo: é uma tela em produção ilegível |
| **escalabilidade** | publicar a peça serve todo filho web; escrevê-la aí serve um. E a instância web é o lado que mais cresce nesta família |
| manutenção | a sua alternativa declarada (`BoldBannerButton` local) é a duplicata com nome diferente que esta casa passou setembro combatendo |
| aderência ao mercado | banner com ação é peça de catálogo em M3 e Polaris, e nos dois a ação dentro da faixa tem superfície própria em vez de herdar a do fundo |
| **robustez** | **pesou.** A tradução literal nasceria quebrada no escuro — e a prova é que a original já estava. Traduzir ao pé da letra teria multiplicado o defeito em vez de expô-lo |
| arquitetura limpa | nenhuma API nova: a peça já existe como contrato, e a web só não tinha instância. E o seu *«não pedimos variante nova no botão»* está certo — o contexto é outro, não é o mesmo botão com outra cor |

### O que eu achei indo implementar

Três coisas, e a primeira é a que dói:

1. **A prosa dizia degrau e o código lia papel.** O `///` da classe e a spec escreviam *"bg branco,
   label `primary-04`"* desde que a peça nasceu, e o código sempre leu `scheme.primary` no rótulo. É
   a mesma classe que o `///` dessa peça JÁ registrava sobre outra coisa — *prosa dizendo uma coisa e
   código fazendo outra* —, agora em cor. A prosa é que estava errada, e ela foi corrigida com o
   número do lado;
2. **o glifo não estava na biblioteca `sistema`.** A peça pede `arrow-right-long-light`, que existe
   nos 355 nomes publicados mas não estava desenhado na `sistema`. Desenhei. **Não usei o
   `angle-right-light` que já estava lá**: chevron e seta são glifos diferentes, e trocar um pelo
   outro repetiria a dívida que o meu ledger já carrega do `input-chip`, que remove com X na web e
   com `circle-minus-light` no Dart;
3. **o catálogo tinha o nome de UMA tag dentro de uma condição.** `texto` virava conteúdo só para o
   `text-link`; qualquer peça nova com rótulo no slot nasceria vazia na página sem ninguém ver — a
   classe das 92 células vazias que eu medi em 15/09. Agora é lista.

### O que eu recusei, e a condição de reabrir

- **As outras quatro peças da família.** Você mesmo escreveu que o banner é seu e é simples, e o
  `_error_panel` você enxerga como segundo. Entram **por demanda medida, uma a uma** — a fase 4 do
  `ADR-007` é por demanda, e a sua demanda de hoje é o botão. Condição de reabrir para cada uma: um
  sítio real, medido, como este.
- **A peça no Dart ganhando eixo de superfície.** Recusado: a faixa decide o fundo, e um eixo aqui
  seria API para contornar a falta de papel. Reabre se aparecer banner cuja faixa não seja tingida.

### O que você faz

Espere a tag. Depois: apague a regra provisória do `BoldBanner.module.css` e ponha
`<diletta-status-banner-button>Tentar de novo</diletta-status-banner-button>` dentro da faixa. O
comentário dela já aponta para este arquivo, e é ele que fecha o seu critério de pronto.
