# PEDIDO · Os fundos se apoiam em quatro cores de marca que a linguagem não publica

- **de**: conta-bold-ds (filho B) · **para**: ds-diletta (o pai)
- **consome**: ds-diletta `v0.194.3` · `web-v0.194.3`
- **bloqueante?**: **não** — o consumidor cravou as duas cores de que precisava como constante local,
  na forma que este repo já usa para o QR, com o motivo escrito em cima.

## O caso

O app do Conta BOLD tem sete fundos de tela, e a personalização deixa a pessoa escolher entre eles.
Seis são campos de brilho montados sobre quatro cores, declaradas direto no widget:

```dart
static const _pink   = Color(0xFFFE3976);
static const _coral  = Color(0xFFFE7B5E);
static const _yellow = Color(0xFFFEED35);
static const _violet = Color(0xFF7B3FF2);
```

Elas aparecem 9 vezes entre as sete variantes — `_pink` em quatro, `_coral` e `_violet` em duas,
`_yellow` em uma.

**Nenhuma das quatro é papel.** Fomos levar o fundo dos fluxos secundários para a web e descobrimos
isso tentando escrever `var(--cps-...)`:

| a cor do app | o papel mais próximo na web | bate? |
|---|---|---|
| `#FE3976` | `--cps-primary` = `#9e1241` no claro, `#f66fa0` no escuro | **não** |
| `#7B3FF2` | — | **não existe** |
| `#FE7B5E` | só dentro do `--cps-gradiente-primary`, como parada | parcial |
| `#FEED35` | idem | parcial |

As duas últimas existem como **paradas de um gradiente**, não como cor que alguém possa pedir.

## Por que não dá para usar `primary`

Porque o fundo não muda de cor com o tema. `--cps-primary` muda — é papel, e é isso que ele deve
fazer. Um brilho de fundo que troca de rosa no escuro para vinho no claro é outro desenho, não o
mesmo desenho em dois modos.

É a mesma natureza do QR, que este repo já resolveu do mesmo jeito: *o código é lido por câmera, e
câmera não tem tema*. Aqui é *a marca é a marca, e o brilho não inverte*.

## O pedido

As quatro cores como **primitivas publicadas** — não como papel, porque papel muda com o modo e estas
não mudam. A escala da marca já viaja (`warning01`…`warning06`, `success01`…); estas quatro são do
mesmo tipo de coisa e não têm nome.

Se a sua leitura for que elas são do FILHO e não da linguagem, a resposta é igualmente útil: aí a
porta certa é o filho declará-las no próprio esquema, e nós escrevemos isso na nossa casa em vez de
cravar constante local. **O que não serve é o estado de hoje** — quatro cores que sustentam sete
telas e não têm nome em lugar nenhum, copiadas à mão de um widget para uma folha CSS.

Foi exatamente a transcrição à mão que você mostrou errar nas curvas, no pedido de 16/09: *«não erra
só o rótulo: troca a fonte quando a fonte não está emitida»*. Aqui a fonte também não está emitida.

## O que fizemos enquanto isso

Duas delas (`_pink` e `_violet`) entraram como constante local na folha do fundo, com o motivo e a
medição em cima, e com o gate de cor literal do consumidor cobrando declaração — cor nova naquele
arquivo reprova até ser declarada com um porquê.

As outras duas não foram usadas: o consumidor só trouxe o fundo dos fluxos secundários, que é o mais
usado no app (59 telas contra 13 da foto). Os cinco fundos de personalização ficam para quando a web
tiver essa área — e aí as quatro fazem falta de uma vez.
