# PEDIDO · o link de texto tem 16 de alvo, e o piso da casa é 44 — o `Tappable` mede só a linha

- **de**: conta-bold-ds (filho B) · **para**: ds-diletta
- **consome**: ds-diletta `v3.3.1` (`5a0acb7`), pelo pino do `packages/coreflow/pubspec.yaml:23`, e é o
  que o app tem vendorizado (`bold-ds v0.122.1`, recibo `packages/ds_vendor.json` do `app-newbold`).
  **Medido também na ponta, `v3.9.0` (`171037d`, = `origin/main`)**: `diletta_text_link.dart`,
  `diletta_see_all_link.dart`, `diletta_alvo_de_toque.dart` e `diletta_section_header.dart` são os mesmos
  byte a byte entre as duas tags (`git diff v3.3.1 v3.9.0 -- <arquivo>` vazio). O `diletta_tappable.dart`
  mudou só no anel de foco (sombra → traço por fora), que não toca o tamanho
- **bloqueante?**: **não** — o link funciona; o alvo dele fica abaixo do seu próprio piso
- **é DEFEITO, não variante**: não pede eixo, tom nem peça nova. Pede que `DilettaTextLink` aplique o
  `DilettaAlvo.piso` que `DilettaIconButton`, `DilettaChatInput` e `DilettaToggleSwitch` já aplicam
- **achado por**: auditoria de acessibilidade do app, antes de uma PR, no link «Ver o que está
  bloqueado» da tela de valor do Pix (`lib/features/pix/presentation/screens/pix_valor_screen.dart:176`,
  branch `feat/saldo-bloqueado-minimo`)

## Falta

Dentro do `DilettaTextLink`, o piso de toque **por dentro** do `DilettaTappable`, com o desenho do tamanho
que é hoje:

```dart
DilettaTappable(onTap: …, child: DilettaAlvoDeToque(child: Text(label, style: …)))
```

`DilettaSeeAllLink` é casca de uma linha dele (`diletta_see_all_link.dart:28`) e herda o conserto sem
mudança própria.

## Número

O que a peça monta, na `v3.3.1` e na `v3.9.0`:

| | o que a peça faz | linha |
|---|---|---|
| árvore | `Semantics(button)` → `MouseRegion` → `DilettaTappable` → `Text` | `diletta_text_link.dart:133-159` |
| tipo do rótulo | `DilettaType.label` = 12 / altura `16/12` | `generated/diletta_type_tokens.g.dart:28` |
| área que responde | o `GestureDetector` do `Tappable` (`behavior` opaco por default) cobre **só o `Text`** | `diletta_tappable.dart:47`, `:137-139` |
| o piso da casa | `DilettaAlvo.piso = 44` | `diletta_metrics.dart:104-109` |

Medido com teste de widget no pino (`v3.3.1`), sob `DilettaPalette.referencia`:

| cena | alvo | toque fora do desenho |
|---|---|---|
| `DilettaSeeAllLink` como está | **altura 16** | 6px acima da linha: **0 toques** |
| o mesmo, embrulhado **por fora** em `DilettaAlvoDeToque` | caixa de 44 | 2px da borda da caixa: **0 toques** (o centro pega) |
| `DilettaTappable(child: DilettaAlvoDeToque(child: Text(…)))` | **44**, texto continua 16 | 2px da borda: **1 toque** |

16 passa a WCAG 2.5.8 (AA, 24×24) só pela **exceção de espaçamento** — nenhum outro alvo dentro do
círculo de 24. A **exceção de inline não vale aqui**: no Flutter o link é widget, nunca `TextSpan` dentro
de uma frase. E 16 reprova os três números que a casa cita: o 44 da HIG, o 48 do Material e o seu
`DilettaAlvo.piso`.

## A forma já está escrita por você

`diletta_icon_button.dart:203-206`, na `v3.9.0`:

> *«O PISO DO ALVO, e ele fica DENTRO do `DilettaTappable`: envolver por fora daria uma área que se vê e
> não pega.»*

É exatamente a segunda linha da tabela acima, e é por isso que o conserto não cabe na tela de quem
consome. O `DilettaInputChip.selecionavel` faz o mesmo arranjo à mão (`diletta_input_chip.dart:259-269`
na `v3.9.0`: `ConstrainedBox(minHeight: 44)` + `Center`, com o `Tappable` por fora), sem passar pelo
`DilettaAlvoDeToque` nem pelo `DilettaAlvo.piso`.

## O que achamos medindo o arranjo — e que você decide

**O `Center` do `DilettaAlvoDeToque` leva o link para o meio da linha quando a largura vem justa.**
Numa `Column(crossAxisAlignment: stretch)` de 390, o `Text` começa em `x = 0` hoje e em **`x = 157,5`**
com o arranjo acima. O `Center(widthFactor: 1)` só abraça o filho quando a largura é frouxa; justa, ele
centraliza. No ícone isso não aparece (a caixa pintada é quadrada e pequena); no link aparece, porque
link de texto é alinhado ao início da coluna.

Nenhum dos nove sítios do app cai nesse caso hoje (todos estão em `Row`, em `Align` ou em coluna
`start` — tabela abaixo), mas a peça vai cair num filho que a ponha numa coluna esticada. A saída de
que precisamos é **o desenho no início do alvo, não no meio**; se é parâmetro do `DilettaAlvoDeToque`,
um `Align` próprio no link ou outra coisa, é seu.

## O que muda junto, e é a consequência que a sua regra aceitou

O `diletta_metrics.dart:100-103` já diz: *«Isso muda layout onde havia caixa menor — é a consequência
aceita, e não um efeito colateral.»* Contado nos filhos, para você saber o tamanho dela:

**No app (`app-newbold`)** — nove sítios na branch `feat/saldo-bloqueado-minimo`, oito em
`origin/development` (o do Pix é o novo):

| sítio | peça | onde está | o que muda |
|---|---|---|---|
| `home/…/home_tab_redesign.dart:224` | `SeeAllLink` | `trailing` do `DilettaSectionHeader` | cabeçalho **16 → 44** |
| `home/…/home_tab_redesign.dart:287` | `SeeAllLink` | `trailing` do `DilettaSectionHeader` | cabeçalho **16 → 44** |
| `pix/…/pix_hub_redesign.dart:401` | `SeeAllLink` | `trailing` do `DilettaSectionHeader` | cabeçalho **16 → 44** |
| `trazer_saldo/…/trazer_saldo_screen.dart:93` | `SeeAllLink` | `trailing` do `DilettaSectionHeader` | cabeçalho **16 → 44** |
| `trazer_saldo/…/trazer_saldo_screen.dart:207` | `SeeAllLink` | `trailing` do `DilettaSectionHeader` | cabeçalho **16 → 44** |
| `cartoes/…/fatura_screen.dart:232` | `SeeAllLink` | `Align(centerRight)` acima dos chips de mês | +28 de altura |
| `pix/…/pix_valor_screen.dart:176` | `SeeAllLink` | coluna `start`, 4 abaixo da frase do bloqueio | vão visual **4 → 18** |
| `trazer_saldo/…/escolher_chave_sheet.dart:65` | `TextLink` | `Align(centerLeft)` na folha | +28 de altura |
| `trazer_saldo/…/estados_da_secao.dart:66` | `TextLink` | coluna `start`, colado embaixo do `CoreflowAviso` | +28, e o link desgruda do aviso |

O cabeçalho foi medido: `DilettaSectionHeader` é um `Row` centrado sem altura própria
(`diletta_section_header.dart:34-49`) e o título também é `label` 12/16, então ele mede **16** hoje e
**44** com o link de alvo (teste de widget, mesma cena). São **cinco** dos nove sítios.

**Neste repo** (`bold-ds`, pai Coreflow, filho Bold, Norte Benk): **zero** chamadas de produção. Uma no
catálogo, de demonstração (`packages/catalog/lib/ds_do_bold.dart:418`). Sem `typedef` que esconda
chamada por outro nome (procurado, vazio).

**No filho A: não medido** — não temos o repo dele.

## Já tentei

- **Consertar na tela**, embrulhando o `DilettaSeeAllLink` em `DilettaAlvoDeToque` por fora: a caixa
  vira 44 e o toque a 2px da borda dela não aciona (tabela do Número). É o *«área que se vê e não
  pega»* do seu `diletta_icon_button.dart:203-204`.
- **Montar o link à mão na tela** (`DilettaTappable` + `DilettaAlvoDeToque` + `Text`) resolveria, e é
  justamente a cópia divergente da peça que a casa não quer. Não fizemos.

## Conferi no pai

- `DilettaAlvoDeToque` (`diletta_alvo_de_toque.dart:23-43`) é a peça certa e já existe. Não é peça nova,
  então a busca do manifesto não se aplica.
- Quem usa o piso na `v3.9.0`: `diletta_icon_button.dart:206`, `diletta_chat_input.dart:417` e `:441`,
  `diletta_toggle_switch.dart:145`. O chip faz à mão (acima). `DilettaTextLink` e `DilettaSeeAllLink`
  não.
- `test/o_alvo_de_toque_tem_piso_test.dart` cobra ícone, chat e interruptor — não cobra o link.
- **O não anterior, relido antes de pedir.** No veredito de 11/08 (chip selecionável), você recusou
  levar o chip existente a 44: *«cresceria a caixa de 24 pra 44 em toda tela que já o usa, e ninguém
  pediu isso»*, e lembrou que 44 é AAA (2.5.5). **Isso mudou em 03/09** (`5411761`, *«o alvo de toque
  tem piso, e ele não é a caixa pintada»*): o piso de 44 virou regra sua, decidida pelo dono do
  produto, e foi aplicado a peças existentes mudando layout de propósito (`diletta_metrics.dart:94-103`).
  Este pedido não reabre aquele: pede que a regra de 03/09 alcance uma peça que ficou de fora.
- Ledger (`docs/PEDIDOS.md` de `origin/main`): nenhuma linha sobre alvo de link.

## Derivável?

**Não do lado de cá.** O `GestureDetector` mora dentro da peça e só ela decide o tamanho dele.

## Se você disser não

O link do Pix e os oito outros ficam com alvo de 16, e o achado fica registrado no app como conhecido,
sem remendo: remendar seria a cópia da peça. Se o não for pelo layout dos cinco cabeçalhos, a pergunta
que sobra é se o alvo do link pode crescer **sem** ocupar layout (só no teste de toque) onde o vizinho
não é tocável, como o título do cabeçalho. Você descartou isso em 03/09 por um motivo concreto (dois
alvos a menos de 8 disputando a faixa), e não estamos reabrindo: só registrando que, no cabeçalho, o
vizinho não é alvo.

## Não estou pedindo

- número: o piso é o seu `DilettaAlvo.piso`;
- mudança no desenho do link (tipo, tom, sublinhado, cor): o texto fica 12/16;
- mudança no `<diletta-text-link>` web: ele é `display: inline` (`src/diletta-text-link.js:54`) e mora
  em frase, onde a exceção de inline da 2.5.8 vale. Não medimos caso web que precise de alvo;
- nada no Coreflow: o `CoreflowSaldo` já anuncia as linhas como botão desde a `v0.122.1` deste repo, e o
  `Semantics(button: true)` do link já existe (`diletta_text_link.dart:133-135`).

## Como o pai vai saber que funcionou

Um caso em `o_alvo_de_toque_tem_piso_test.dart`, nos moldes do do ícone:

1. `DilettaTextLink` e `DilettaSeeAllLink`: o `DilettaAlvoDeToque` existe e mede ≥ 44 de altura;
2. o `Text` continua com 16 (o desenho não cresceu);
3. toque a 2px da borda do alvo, fora do texto, aciona;
4. numa `Column(crossAxisAlignment: stretch)`, o texto continua começando no início da linha.

E, do lado de cá, quando a tag sair: subimos o `ref:`, vendorizamos e a auditoria do app mede o link
do Pix de novo.

## Como cheguei aqui

Achado pela auditoria de acessibilidade do app na tela de valor do Pix, em 05/10, antes da PR. Tudo
acima foi medido no código das duas tags do avô (`v3.3.1` e `v3.9.0`) e no app (branch de trabalho e
`origin/development`); as alturas e os toques, com teste de widget descartável rodado no pacote do
filho contra o pino `v3.3.1`.

## VEREDITO · ENTRA, defeito meu — o alvo vai pra dentro do tappable, e o texto fica no início
**pai**: ds-diletta **v3.10.0** · **data**: 2026-10-08

### O que decidiu

A sua frase: *«pede que a regra de 03/09 alcance uma peça que ficou de fora»*. É isso, e o meu próprio `///` do botão de ícone já dizia onde o piso mora. O seu achado do `Center` decidiu a forma: o `DilettaAlvoDeToque` ganhou `alinhamento` opcional (default o centro de hoje, nenhum chamador muda) e o link usa `AlignmentDirectional.centerStart`. `DilettaSeeAllLink` herda sem mudança.

### O que eu achei indo implementar

nada além do que você mediu. O arranjo do chip selecionável continua à mão; fica como está até alguém mexer nele.

### O que eu recusei, e a condição de reabrir

- **alvo sem ocupar layout no cabeçalho**: não. A regra de 03/09 é piso que ocupa, e os cinco cabeçalhos passarem de 16 a 44 é a consequência aceita. Reabre se um desenho aprovado medir o cabeçalho de 16 com link.

### Os sete critérios

| critério | | |
|---|:-:|---|
| manutenção | ↑ | um conserto na peça, não nove na tela |
| escalabilidade | ↑ | todo filho que usa o link recebe o piso sem saber |
| aplicação | ↑ | o link do Pix e os oito outros passam a pegar o toque; adota o app do filho B |
| aderência ao mercado | ↑ | 44 da HIG, 48 do M3, e o piso da casa |
| robustez | ↑ | 4 casos novos no gate do alvo, incluindo coluna esticada e RTL |
| arquitetura limpa e simples | = | um parâmetro opcional numa peça que já existia |
| conciso | = | `///` de uma linha |

### O que você faz

`ref: v3.10.0`. No app, nada a trocar nas telas; confira os cinco cabeçalhos (16 → 44).
