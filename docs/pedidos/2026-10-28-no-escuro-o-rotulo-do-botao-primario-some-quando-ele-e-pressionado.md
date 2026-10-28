# PEDIDO · No escuro, o rótulo do botão primário cai abaixo de 3:1 quando ele é pressionado — e o par de estado já é papel

- **de**: conta-bold-ds (filho B) · **para**: ds-diletta
- **consome**: ds-diletta `v3.24.0` (pino do pai); `diletta_scheme.dart` é igual na `v3.25.0`, e o ramo do botão também (`diletta_button.dart:547-548` e `:597`)
- **bloqueante?**: não. O repouso passa em toda paleta. O que cai é o rótulo no hover (web) e no instante do toque (app): WCAG 1.4.3
- **irmão**: a linha de 23/09 do seu `PEDIDOS.md` (*«`hover` e `pressed` pintam fundo por DEGRAU CRU»*, ABERTO com catraca em 98) e o `o_rotulo_alcanca_o_preenchimento_test`, que a mede

## Falta

A tinta do botão primário é escolhida contra o repouso (`_tintaHonrada`; no escuro, contra o `primary05`), e o `DilettaButton` a mantém nos três estados (`color: s.onPrimary`, `diletta_button.dart:597`). No escuro, o hover e o pressionado vão para degraus mais escuros (`primarySolidHover: p.primary04`, `primarySolidPressed: p.primary03`, `diletta_scheme.dart:898-899`), por baixo de uma tinta que também é escura. Nada confere a tinta contra esses dois fundos.

## Número

Rótulo do `DilettaButton` primário sobre o fundo de cada estado, no **escuro**. Medido nas folhas emitidas das seis paletas da família e na de referência (`web-v3.24.0`). O teste de paridade de cada filho garante que esses são os valores do `DilettaScheme.dark`, e um teste no pino confirmou no Dart a referência e o Banco Fibra (3,46 · 2,09 e 4,11 · 1,87).

| paleta | repouso | hover | pressionado |
|---|--:|--:|--:|
| referência | 5,59 | **3,46** | **2,09** |
| Conta BOLD | 7,70 | 6,06 | **2,62** |
| Norte Benk | 6,12 | **4,17** | **2,56** |
| Confia Capital | 6,12 | **4,15** | **1,64** |
| BluOn | 5,58 | **4,31** | **2,10** |
| Banco Fibra | 6,07 | **4,11** | **1,87** |
| exemplo do `novo_filho` | 6,71 | 4,69 | **2,27** |

No **claro**, os três estados passam em todas, porque escurecer sob tinta branca aumenta o contraste (na referência: 5,16 · 8,54 · 13,05).

O botão destrutivo, no escuro, passa nas cinco folhas que herdam o vermelho da referência (hover 6,56, pressionado 9,38). O Conta BOLD, que declara o próprio vermelho, cai a **3,68** no hover. É a mesma classe das células `primary/error/hover` (3,76) das suas paletas de esforço.

Quem usa: no app do filho B, 243 `CoreflowBotao`, dos quais cerca de 107 na variante primária, que é o padrão. No Internet Banking, `<diletta-button>` e `BoldButton` aparecem em 102 arquivos.

## Já tentei

Nada em tela. O que existe do nosso lado, e por que não serve:

- O esquema do Coreflow emite só `primary` e `onPrimary` (a tinta conferida contra o `primary` do esquema, desde 28/10). Emitir também `primarySolidHover` e `primarySolidPressed` consertaria a web e deixaria o Dart como está: duas instâncias com dois pixels, e conserto local de papel seu.
- Trocar a tinta do rótulo por estado: ela é do `DilettaButton`, sem porta.

## Conferi no pai

- Você já tem a classe, e a régua a mede. Rodei o `o_rotulo_alcanca_o_preenchimento_test` da `v3.25.0` com o teto em zero, só para listar: são **74** células (o teto declarado segue em 98). Entre elas estão `primary/normal/hover` (3,46) e `primary/normal/pressed` (2,09) no escuro das três paletas.
- O alvo da linha de 23/09 é *«os pares de estado da superfície cheia viram papel, um tipo por vez»*, e o comentário da régua diz que as células *«não são erro de tinta: são fundo de interação lido como DEGRAU CRU»*. **No primário, isso já aconteceu**: o par é papel desde a v0.91.0, e o `///` dele diz *«nenhum pixel do botão muda»* (`diletta_scheme.dart:355-369`). Essas células vão sobrar quando a fila do lado neutro terminar, porque o que reprova é o valor do papel no escuro, e não a falta de papel.
- O `///` do par escolhe escurecer, com razão de mercado (*«clarear… diz "parou de funcionar"»*). Sob tinta branca, escurecer sobe o contraste. Sob a tinta escura que o `_tintaHonrada` escolhe no escuro, aproxima o fundo da tinta, e é isso que derruba o número.
- Achado do mesmo desenho, que não peço aqui: com a marca declarada abaixo do 04 (a do Banco Fibra entra no 02), o claro do `DilettaScheme` **clareia** no hover (14,28 → 9,56) e não muda no pressionado (o 02 é o próprio repouso), ao contrário do *«escurece, nunca clareia»* do `///`. Os degraus são fixos e não seguem o lugar do repouso na rampa.

## Derivável?

Sim. Os dois fundos saem da rampa que o filho já declara, e a tinta, do par que você já escolhe. Não peço campo novo.

## Se você disser não

No escuro, o rótulo do botão primário pressionado fica entre 1,64 e 2,62 nas seis paletas da família, e o hover fica abaixo de 4,5 em quatro delas. Do nosso lado, não há conserto que chegue ao app sem copiar papel seu.

## Não estou pedindo

1. uma forma específica (outro degrau, camada de estado, tinta por estado): a escolha é sua;
2. mudar o repouso, nem o claro, que passa em toda paleta;
3. o hover que não muda no claro nas folhas web da família. Esse é nosso: o esquema do Coreflow pinta o botão com o `primary03`, que é também o seu hover. O conserto fica aqui.

## Como o pai vai saber que funcionou

O `o_rotulo_alcanca_o_preenchimento_test` sem as células `primary/*/hover` e `primary/*/pressed` do escuro nas três paletas, com o teto da catraca descendo junto. Do nosso lado, refaço a medição das seis folhas na tag que trouxer o conserto.
