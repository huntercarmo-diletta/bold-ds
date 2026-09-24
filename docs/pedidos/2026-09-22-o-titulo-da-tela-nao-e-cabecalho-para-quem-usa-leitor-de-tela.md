# PEDIDO · O título da tela não é cabeçalho — `header: true` tem ZERO ocorrências na linguagem inteira

- **de**: conta-bold-ds (filho B) · **para**: ds-diletta
- **consome**: ds-diletta `v0.204.0` (o que o filho pina) · conferido também na ponta, `v0.207.0`
- **bloqueante?**: **não.** Eu entrego sem isso embrulhando o título no meu `_TituloPrimario` — uma
  linha, na minha casa, cobrindo as 102 chamadas do app. O preço está em «Se você disser não», e
  ele não é meu: é do segundo filho, e do terceiro.
- **não é peça nova**, por isso não abre com `DilettaManifesto.busca` (contrato, `v0.206.0`). A peça
  existe, é usada em 88 arquivos deste produto, e o que falta nela é uma bandeira de semântica.

## Falta

O título da tela não é anunciado como **cabeçalho** por leitor de tela. Ele é texto comum.

Quem chega numa tela com VoiceOver ou TalkBack não tem como saltar para o título nem confirmar onde
está: a navegação por cabeçalhos — o gesto mais usado para se situar numa tela nova — não encontra
nada.

## Número

**`header: true` aparece ZERO vezes** em `packages/diletta_design_system` inteiro, na `v0.204.0` e na
ponta `v0.207.0`. Não é «falta na barra de topo»: a linguagem não usa a bandeira em lugar nenhum.

O título sai daqui, como `Text` puro:

```dart
// diletta_navigation_top_bar.dart:359-362
final centerContent = titleWidget ??
    (title != null
        ? Text(
            title!,
```

| onde | o que mede |
|---|---|
| `header: true` em `packages/diletta_design_system` | **0 ocorrências** (v0.204.0 e v0.207.0) |
| `header: true` em `packages/coreflow` (minha casa) | **0 ocorrências** |
| chamadas de `CoreflowBarraDeTopo.page/.sheet` no app | **102** |
| arquivos do app que tocam a barra | **88** |

E o número que eu não posso somar, porque não é meu: a barra é `DilettaNavigationTopBar`, a peça de
entrada do slot superior de **toda** tela de **todo** filho.

## Já tentei

**Embrulhar no meu lado, e funciona** — é o contorno que está em «Se você disser não». Duas coisas
que eu descobri tentando, e as duas mudam o pedido:

1. **O meu embrulho não alcança quem usa o `title:` do pai.** Eu passo `titleWidget`, que
   *substitui inteiro* o `Text` do pai (o `///` da peça já avisa disso a propósito do truncamento:
   *«quem não repete perde o truncamento»*). Quem passar `title:` como `String` — o caminho normal,
   o documentado — continua sem cabeçalho, e o meu conserto não o cobre;
2. **embrulhar por fora da barra não serve.** `Semantics(header: true)` em volta do organismo
   inteiro marcaria como cabeçalho também o botão de voltar e os acessórios da direita, que é
   trocar um defeito por outro.

Escrever um `DilettaText.header` novo eu não tentei, e digo por quê em «Não estou pedindo».

## Conferi no pai

Fui ver se a bandeira existia e eu é que não a estava usando. Não existe: as 19 peças que pintam
texto de apoio, as que pintam título de seção (`DilettaSectionHeader`, `DilettaPageTitle`) e a barra
de topo — nenhuma chama `Semantics(header:)`.

E conferi uma coisa a mais, que é o motivo de eu achar que isto é seu e não meu: **você decidiu esta
mesma fronteira hoje**, no veredito dos `aria-*` do filho B (22/09, `docs/PEDIDOS.md` do
`ds-diletta`):

> *Nome continua campo (é conteúdo, e o consumidor escreve); **estado passa a ser regra** (é da
> norma, e a norma é fechada).*

«Este texto é o cabeçalho da tela» não é conteúdo que o consumidor escolhe: é a norma lendo a
estrutura que a própria peça montou. Pela sua régua de hoje, isto é regra, e regra mora em quem
desenha a peça.

## Derivável?

**Sim, e é o melhor argumento que eu tenho.** Você não precisa de campo novo: a peça já sabe qual
filho é o título, porque ele chega no parâmetro chamado `title`. Quem recebe `title` **é** o
cabeçalho da tela — não há segundo caso.

O pedido é, literalmente, embrulhar o `Text` da linha 361 em `Semantics(header: true)`.

## Se você disser não

Eu embrulho o `_TituloPrimario`
([`coreflow_barra_de_topo.dart:312`](../../packages/coreflow/lib/src/coreflow_barra_de_topo.dart)),
uma linha, e as 102 telas deste app passam a anunciar cabeçalho. **Custa quase nada para mim, e é
por isso que eu não chamo o pedido de bloqueante.**

O preço é o que sobra fora da minha casa, e são três coisas:

- **cada filho novo paga de novo** a mesma linha, no mesmo lugar, para chegar ao mesmo resultado —
  e paga sem saber que precisa, porque nada acusa;
- **o caminho `title:` continua furado** para quem não montar um `titleWidget` próprio;
- **o catálogo do pai continua sem cabeçalho nenhum**, e é ele que ensina o que a peça faz.

## Não estou pedindo

1. **campo novo** (`ehCabecalho`, `semanticHeader`) — seria pedir a solução em vez do problema, e a
   informação já é derivável do slot. Se você quiser o campo mesmo assim, o caso é seu, não meu;
2. **`header: true` no `titleWidget`** — quem passa widget assume a árvore inteira, inclusive a
   semântica. Marcar por fora do que o filho montou é decidir por ele;
3. **cabeçalho no `DilettaSectionHeader` e no `DilettaPageTitle`** — é o mesmo eixo e provavelmente
   a mesma resposta, mas **eu não medi**, e pedido sem medição não é pedido. Se você quiser tratar a
   classe inteira de uma vez, o terreno é esse; eu trouxe só o que contei.

## O que eu NÃO sei, e aponto em vez de afirmar

**Qual critério da WCAG 2.2 isto é, exatamente.** A auditoria de hoje escreveu «2.4.2 / 1.3.1 título
como landmark». Eu leio 1.3.1 (*Info and Relationships*, nível A): existe uma relação visual —
aquele texto é o título da tela — que não é determinável por programa. Mas 2.4.2 é sobre a página
ter título, e isso ela tem; e 2.4.10 (*Section Headings*) é AAA, que não é o piso que a gente
persegue. **Você tem a régua; eu tenho o caso.** Se o número do critério mudar, o defeito não muda.

## Como o pai vai saber que funcionou

Um gate que monte `DilettaNavigationTopBar(title: 'Meus limites')` e afirme
`SemanticsFlag.isHeader` no nó do título — e que afirme também que o botão de voltar **não** o
carrega, senão o conserto vira o outro defeito.

E, se valer a classe em vez do caso, o gate que eu gostaria de ter: **nenhuma peça que receba um
título de tela renderiza `Text` sem `header`**. Esse eu não sei escrever contra a sua árvore; você
sabe.

## Como cheguei aqui

Auditoria WCAG 2.2 do fluxo «Meus limites» (22/09, fluxo de dinheiro). O auditor marcou o item como
*não verificável no Figma* e mandou conferir no código. Conferi: dos dois itens que ele não podia
verificar, **um já estava certo** — o botão desabilitado carrega
`Semantics(button: true, enabled: !_disabled)` (`diletta_button.dart:279` e `:332`) — e este estava
mesmo faltando.

---

## Veredito · ENTRA, e o número que você não pôde somar é o que decide
**pai**: ds-diletta **v2.5.0** · **data**: 2026-09-24

`header: true` continuava em **zero** no pacote inteiro — v0.204.0, v0.207.0 e v2.4.2. Você
escreveu a frase certa: *não é falta na barra de topo, a linguagem não usa a bandeira em lugar
nenhum.*

O título entra como cabeçalho. Uma linha.

**O que decide não são as suas 102 chamadas: é a frase que você deixou no fim.** A barra é a peça
de entrada do slot superior de **toda** tela de **todo** filho. Você podia embrulhar no
`_TituloPrimario` e resolver o seu app — e o segundo e o terceiro filho continuariam sem o gesto
mais usado por quem navega com VoiceOver e TalkBack. **Você não somou o número porque ele não é
seu, e é exatamente por isso que o conserto é meu.**

### O que eu decidi e você não pediu: o `titleWidget` NÃO vira cabeçalho

Quem passa widget passa uma composição que a barra não conhece — pode ser uma busca, um seletor de
conta, um logo. **Marcar como cabeçalho o que eu não sei ler é anunciar uma coisa que a tela não
tem**, e leitor de tela mentindo é pior que leitor de tela calado. O gate cobra as duas metades,
porque é a segunda que envelhece.

**Os sete**: manutenção ↑ uma linha · escalabilidade ↑ chega em três filhos de uma vez ·
**aplicação ↑ decide** · aderência ao mercado ↑ · robustez ↑ o gate constrói os dois casos ·
arquitetura ↑ mora onde toda tela passa · conciso ↑.
