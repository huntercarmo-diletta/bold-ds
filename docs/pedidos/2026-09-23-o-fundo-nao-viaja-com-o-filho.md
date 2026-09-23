# PEDIDO · o fundo não viaja com o filho — e a escolha do cliente é transcrita à mão duas vezes

## O caso, em uma linha

Os tokens viajam com o filho; o FUNDO não. A lista de fundos que o cliente marcou no Berço é
copiada à mão para o tenant do app e, agora, para o do Internet Banking — e a arte de cada um é
calculada num terceiro lugar, que se declara andaime.

## Medido, e é o que dá o tamanho do problema

O gerador não conhece o Berço. `dart run coreflow:novo_filho` recebe `--id --nome --cor --saida`, e
nenhuma das três palavras — `manifesto`, `fundosOferecidos`, `berco` — aparece no
`packages/coreflow/bin/novo_filho.dart`.

O caminho de hoje, para UMA decisão do cliente:

```
Berço          manifesto.material.fundosOferecidos, material.fundo   (a escolha, com auditoria)
  ↓ à mão
app-newbold    lib/core/tenant/tenants/nortebenk.dart
               backdrops: [OpcaoDeFundo(…, 'Brilho'), OpcaoDeFundo(…, 'Vidro frio'), …]
  ↓ à mão
ib             src/config/tenants/nortebenk.ts
               fundos: [{ id: 'brilho-rosa', rotulo: 'Brilho' }, …]
```

E a ARTE, que o Berço calcula, é recalculada em `app-newbold`:
`lib/core/theme/arte_de_fundo_gerada.dart` — que diz de si mesmo, na primeira linha, que é **andaime**
do pedido de 18/09 e *«quando o pai desenhar os fundos, este arquivo sai»*.

## O que aconteceu quando o segundo consumidor chegou

O IB foi implementar fundo por marca em 23/09 e reproduziu o padrão inteiro: transcreveu a lista,
e **começou a escrever o quarto cálculo** — uma reimplementação em TypeScript do `tetoDeAlpha` do
auditor do Berço (11/09), para poder aplicar o teto de contraste que o app aplica em Dart.

Isso foi revertido antes de subir, e a reversão é o que motiva este pedido: **não é o consumidor que
tem de recalcular a arte.** Quando o terceiro filho nascer, a conta estaria em cinco lugares.

O que ficou de pé no IB é só o que não depende de ninguém: cada marca declara os fundos que oferece,
a preferência gravada é aparada para essa lista, e um gate confere se a folha daquela marca publica
os tokens que os fundos oferecidos pedem.

## O que pedimos

**Que o fundo viaje com o filho, como os tokens viajam.** A forma é sua; o que falta é o dado
existir do nosso lado:

- **a lista** — quais fundos aquele filho oferece, na ordem do cliente, com o rótulo que ele
  escolheu («Brilho» e não «Brilho rosa», numa marca azul) e qual é o padrão;
- **a receita de cada um** — base, brilhos, posições e alfas, já passados pelo auditor. O teto de
  contraste é do Berço e é aplicado na origem, onde a paleta e a base foram escolhidas juntas.

Com isso, app e IB **consomem**. Hoje os dois transcrevem, e o único que calcula diz que não deveria.

## EMENDA de 23/09 — o pedido é menor do que escrevemos

A primeira versão deste pedido falava em «a receita de cada fundo», e tratamos o giro de matiz como
coisa que o consumidor teria de calcular na hora — chegamos a concluir que o IB precisaria de
sintaxe de cor relativa (`oklch(from …)`), que este repositório nunca usou.

**Está errado, e a correção encolhe o pedido.** O giro é CONSTANTE POR MARCA: o polo análogo do azul
da Norte Benk é sempre a mesma cor. O resultado não é uma conta a refazer a cada pintura — são
**três hexadecimais por fundo**, do mesmo tipo que `--diletta-lockup01` já é hoje.

Ou seja: o consumidor nunca precisou da capacidade, e sim do VALOR. E valor é o que o DS já sabe
fazer viajar.

Isso também responde à pergunta óbvia — *«o Berço não gera isso? não dá para pegar de lá?»*.
Medimos: o `berco-coreflow.html` não está em nenhum dos três repositórios (`bold-ds`, `ds-diletta`,
`app-newbold`). O que existe alcançável é o teste que reproduz a conta
(`test/core/theme/a_conta_do_berco_test.dart`), e ele carrega a cor de AÇÃO (`#1D72FF`) e os
limites — não os polos já girados. O app os calcula em tempo de execução e nunca os materializa
onde a web leia.

**Então o pedido, na forma mínima**: para cada fundo que um filho oferece, publique as CORES já
resolvidas — os polos, a base e a tinta sobre o gradiente — junto com os alfas e as posições. O giro
de matiz, o teto de contraste e a escolha da base ficam onde já estão: na origem, uma vez.

## O que NÃO pedimos

Não pedimos que o pai desenhe os três fundos do Berço que ele ainda não tem (`degradeSimples`,
`harmoniaAnaloga`, `harmoniaComplementar`) — isso já é o pedido de 18/09 e está em curso. Este é o
degrau anterior: que a ESCOLHA e a RECEITA cheguem ao filho, seja qual for o conjunto desenhado.

## O que não sabemos

**Se o manifesto do Berço é acessível ao gerador.** Vemos o nome dele citado no app e no
`coreflow_scheme.dart`, e não sabemos se ele é arquivo, serviço ou passo manual — nem se a ligação
que falta é técnica ou de processo. Dizemos o que medimos.

## Os seis critérios

| critério | | |
|---|:-:|---|
| manutenção | ↑ | uma decisão do cliente em um lugar, contra duas transcrições e um recálculo hoje |
| escalabilidade | ↑ | o terceiro filho recebe o fundo dele sem ninguém transcrever nada; sem isto, a conta vai a cinco lugares |
| aplicação | ↑ | o fundo que a pessoa vê passa a ser o que o cliente aprovou, e não a cópia mais recente que alguém fez |
| aderência ao mercado | ↑ | é o que o resto do DS já faz: o token viaja no pacote, o consumidor não recalcula |
| robustez | ↑ | o teto de contraste passa a ser aplicado UMA vez, na origem, com a paleta e a base escolhidas juntas — hoje um consumidor pode aplicá-lo com a base errada e não saber |
| arquitetura limpa e simples | ↑ | some o andaime do app, e não nasce o do IB |

Nenhum `↓`, e vale dizer por quê: não estamos pedindo capacidade nova. Estamos pedindo que um dado
que já existe, já auditado, atravesse a fronteira em vez de ser copiado nela.

## FORMA PROPOSTA · 23/09 — o pai repassa o fundo como VALOR (para o veredito desta casa)

Chegou pelo chat que recebe os envios do Berço, com a palavra da dona do produto: **o fundo das telas
precisa chegar aos filhos (flavors) como valor — hex já resolvido —, e é o pai quem repassa.** O
destinatário deste pedido, portanto, é **esta casa** (`packages/coreflow`), pela mesma doutrina da
nota de 21/09 no pedido de 18/09: o `CoreflowBackdropScope` é nosso, ninguém pede ao avô.

Nada abaixo foi codificado. É a forma mínima que satisfaz os dois pedidos, medida contra
`origin/main` (`v0.117.0`) em 23/09, para a Agatha dizer se entra.

### O que esta casa mediu, e o que o recado dizia

| afirmação do recado | medido aqui (`v0.117.0`, 23/09) |
|---|---|
| `CoreflowProduto` não tem campo de fundo | confere: `coreflow_produto.dart` casa `fundo` só em comentário do logo (`:212`, `:217`); `fundosOferecidos`/`fundoPadrao` dão **zero** em `packages/` |
| `CoreflowBackdrop` é enum e resolve as cores na pintura | confere: 7 valores (`coreflow_background.dart:45`); a base sai de `primary08`/`bgEscuro`/`bg` (`:203-204`) e os brilhos de `primary04`/`warning03`/`warning04` (`:250-293`) — **dentro do `build`, nunca materializado** |
| o Berço já calcula e os polos estão no manifesto como hex | confere: `berco-envios/norteBenk/manifesto.json` → `extras.analogaFria #0089B4`, `analogaQuente #8755F3`, `complementar #FCB600`; `material.fundo = harmoniaComplementar`, `fundosOferecidos` com 4 |
| o app recalcula em `arte_de_fundo_gerada.dart`, andaime declarado | confere, **com endereço**: 359 linhas em `origin/release/homologation` (com `test/core/theme/a_conta_do_berco_test.dart`, 8 casos); **não está em `origin/development`** — o trem de HML tem o andaime e o de dev não |
| o emissor web já tem `coreflowPapeisCss` | confere (`coreflow_css.dart:50`), ao lado de `coreflowEsquemaCss`, `coreflowMedidasCss`, `coreflowTipoCss`, `coreflowGradientesCss`, `coreflowAjustesCss` — o fundo seria o sétimo bloco |
| o gate `o_desenho_da_web_e_o_do_mobile` anda os blocos | confere, **mas ele mora nos filhos**: `coreflow_design_system/test/` e `norte_benk_coreflow/test/`, não no pai — cada filho cobra a própria folha |
| o molde `produtoDe` tem `marcaVisual:` e `tipografia:` comentados | confere (`novo_filho.dart:171`, `:180`); `fundo`/`backdrop` aparece **1** vez no gerador, em prosa |

### A forma, em cinco degraus

1. **`CoreflowFundo` como DADO, não estilo.** `{id, rotulo, claro: CoreflowFundoResolvido, escuro:
   CoreflowFundoResolvido}`, e o resolvido é `{base: Color, camadas: [{cor: Color, alpha, x, y,
   escala}], tintaSobreOGradiente: Color}`. Um pintor genérico de camadas
   (`CoreflowBackground.deDados(fundo)`) desenha qualquer receita — os três fundos do Berço
   (`degradeSimples`, `harmoniaAnaloga`, `harmoniaComplementar`) **não precisam virar membros do
   enum**. Os sete estilos de hoje continuam; ganham `CoreflowFundo.doPai(CoreflowBackdrop, paleta)`,
   que **materializa** os valores que hoje só existem dentro da pintura (`:203-293`).
2. **`CoreflowProduto` ganha `fundos: List<CoreflowFundo>` e `fundoPadrao`** — os itens 1 e 2 do
   pedido de 18/09. O `CoreflowBackdropScope` lê `produto.fundoPadrao` em vez de cravar `imagem`
   (`coreflow_background.dart:188`); a Aparência lista `produto.fundos` em vez de `.values` (item 8
   da fila).
3. **Emissão web: `coreflowFundosCss(produto)`** escreve `--diletta-fundo-<id>-base`,
   `-camada-N-cor/-alpha/-x/-y/-escala` e `-tinta`, por modo, ao lado de `coreflowPapeisCss`. O gate
   `o_desenho_da_web_e_o_do_mobile` de cada filho passa a andar os fundos também. **O IB consome a
   folha; nunca recalcula** — é a tese da emenda acima (o giro é constante por marca; viaja o valor).
4. **`novo_filho`: o molde ganha `fundos:` comentado** ao lado de `marcaVisual:` e `tipografia:`. A
   ligação com o Berço é **de processo**, não técnica: o Berço substitui o `lib/<id>.dart` que o
   gerador escreve, e o `manifesto.json` viaja na entrega (M13 do rastreio dos envios). Isso responde
   ao «o que não sabemos» acima — o manifesto é arquivo e chega com a entrega; **falta só o campo onde
   escrever**.
5. **Gate de paridade, com data de validade.** Enquanto o andaime do app existir,
   `a_conta_do_berco_test` compara o ENTREGUE (o valor do filho) com o RECALCULADO; quando o pai
   desenhar dos dados, o andaime sai e o gate com ele.

### O que isto muda no pedido de 18/09

A ordem lá era **3 → 1 → 4** («o 1 não se faz antes do 3»: declarar uma lista de fundos antes de os
fundos existirem é declarar o enum de novo). A forma acima **desfaz essa dependência**: o fundo passa
a ser dado, então o produto declara a receita e o pai a pinta — o item 3 (os fundos do Berço
existirem como membros do enum) deixa de ser pré-requisito. O item 2 (a arte do `imagem` declarada na
marca) segue solto e segue sendo o único candidato a pedido ao avô.

### O que a dona decide

- **Dado ou enum?** É a bifurcação. Enum é o que esta casa tem (7 valores, pintura por caso, o `_ =>`
  seguro por construção em `:195`); dado é o que faz o valor atravessar a fronteira sem o consumidor
  saber pintar. O recado propõe dado **e** mantém o enum para os sete de hoje — os dois convivem.
- **Onde o `tintaSobreOGradiente` é decidido.** O pedido diz «na origem, uma vez» (o Berço, com o
  teto de alfa do auditor). Se o pai também derivar, são duas fontes; a forma acima deixa o pai só
  **repassar**.
- **Versão.** É campo novo em `CoreflowProduto` com default — compatível; entraria como minor.

Rastreio completo dos envios (M1–M14): `~/Desktop/berco-envios/MELHORIAS-DO-ENVIO-2026-09-18.md`
(M14 é este). O sinal de push é da Agatha; nada aqui foi enviado.
