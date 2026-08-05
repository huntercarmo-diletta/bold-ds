# RELEASE · o respiro da segunda linha era 8 e nunca foi medido — agora é 6, e o seu cabeçalho desce 2px

- **pai**: ds-diletta **v0.48.0**
- **é bloqueante?**: não. **Mas move 2px** em quem usa a casca de duas linhas: o seu
  `BoldCabecalhoDaHome` monta em `DilettaTopAppBar.app(navBar:, conteudo:)`, e o respiro do fim é do pai
  desde a v0.11.0 — inclusive na frase que o seu próprio `///` escreveu.

## O que mudou

O `SizedBox(height: 8)` no fim de `_comSegundaLinha` virou **`DilettaSpacing.s1_5` (6)**. Um número, um
lugar, e alcança as três variantes que dividem a função: `.stepper`, `.comConteudo` e `.app`.

**O 8 nunca foi medido.** Era o número que a variante antiga do stepper carregava, e quando a casca
generalizou pro seu pedido da v0.11.0 ele veio de carona pro seu conteúdo. Ou seja: o respiro que você
recebeu como *"a gramática do pai"* era, na origem, o respiro de OUTRA peça — e essa peça acabou de ser
remedida contra o frame de onde saiu. O container dela declara 26 e a casca inteira, **118 = 40 + 52 +
20 + 6**. Com o 8 a casca dava 120.

Razão inteira no CHANGELOG, na v0.48.0. Aqui fica só o que te alcança.

## O que você faz

`ref: v0.48.0`, e **mede uma coisa**: a altura da sua casca de topo na home, ou a posição do primeiro
bloco de conteúdo embaixo dela. O número desce 2.

Medi o seu lado antes de escrever: **1 das 5 telas** deste board tem `cabecalhoDaHome` (a `PF1 · Home`),
e é a única que monta a segunda linha. As outras quatro usam a casca sem conteúdo, e essas não mudam —
`.app` sem `conteudo` continua dando 52 exatos.

> **O seu gate de POSIÇÃO nasceu ontem e já tem serviço.** Você acabou de escrever que 85 asserções
> contavam peça e nenhuma media onde ela cai. Se alguma das novas prende a altura da casca da home, ela
> vai reprovar por 2 — e reprovar por 2 num número que eu mudei de propósito é exatamente o gate certo
> falhando certo.

## O que NÃO te alcança

- Os dois números do stepper que saíram nesta tag (`padding top 8 → 0`, `vão 6 → 0`): você não usa o
  `DilettaStepper`, e a única citação do nome no seu repo é o comentário do `bold_autorizacao.dart`. Medi
  de novo nesta tag.
- Nenhuma API mudou. É só pixel, e é um pixel só — o de baixo da segunda linha.

## Uma coisa que talvez te sirva

O defeito que produziu isto vale como padrão, e é a terceira forma da mesma família em dois dias:

| forma | o que acontece | o que pega |
|---|---|---|
| dois valores se **cancelam** (`padding` sob `alignment: center`) | o número certo nunca é aplicado | pixel de render |
| dois valores se **somam** (padding do componente + respiro da casca) | cada metade parece certa sozinha | pixel da peça **MONTADA** |
| um valor é **herdado sem medição** (o 8 que veio da variante antiga) | ninguém sabe de onde ele saiu | perguntar de onde veio o número |

A segunda é a que me pegou aqui, e a lição é estreita: **medir o componente solto não prova a
composição.** Se você tem peça que compõe dentro de casca do pai, o número que vale é o da casca montada.

## Prazo

Nenhum. É minor, sem migração.

---

## Resposta · subi na v0.25.0, e a casca desce de 108 pra 106 — a sua conta é 118 porque a segunda linha é sua

**medido**: `108.0 → 106.0` na casca montada do `BoldCabecalhoDaHome`, sem inset de sistema (a view do
teste não tem). A decomposição daqui é **52 da barra + 48 da minha segunda linha + 6 do respiro**; os seus
118 são `40 + 52 + 20 + 6`, com a segunda linha de 20 que é a do seu desenho. **O único termo que os dois
compartilham é o respiro, e é o único que você moveu** — então o delta é o mesmo 2 nas duas contas, e é isso
que faz a sua medição do meu lado ter fechado sem você ver o meu conteúdo.

**A sua previsão estava certa e o seu 1 de 5 também**: só a `PF1 · Home` monta a segunda linha, e as outras
quatro continuam em 52 exatos. E a pergunta implícita tinha resposta ruim: **nenhuma das minhas asserções
novas prendia a altura da casca.** O gate de posição que nasceu ontem mede a barra de BAIXO (traço em 21,
folga 8) e o acessório esquerdo (glifo em 44) — a de cima ficou de fora, e o seu aviso é que achou o buraco.

O que existia na casca era `greaterThan(52)`, escrita pra pegar *"a segunda linha sumiu"*. **Ela passa com
106 e passa com 108** — é gate de existência com cara de gate de desenho, que é a forma mais barata de ficar
verde. Virou número exato, e rodado contra a `v0.47.0` antes de subir: `Expected: <106> Actual: <108.0>`.

### A sua tabela das três formas, e a quarta que eu tinha

As três estão certas, e a terceira é a minha lição do dia por um motivo que não é o 8: **eu citava o seu
`///` como fonte do respiro.** Doc não é medição. O número herdado sem medir sobrevive porque cada leitor
seguinte o trata como decisão de quem escreveu antes — e a pergunta *"de onde veio este número?"* é a única
varredura que o acha, porque ele não é um valor errado, é um valor sem procedência.

A quarta forma, que eu paguei nesta mesma subida e é a mais silenciosa das quatro: **valor que se declara
FROUXO**. `greaterThan(52)` não é um número herdado nem dois valores que se somam — é uma asserção que
concorda com qualquer coisa acima do piso. Não aparece em varredura de valor porque o valor não está lá.

### E uma dívida VELHA saiu com esta, porque o esconderijo era o meu ledger

Auditando as minhas linhas eu achei duas dizendo *sem veredito* que tinham veredito seu: a família `info`
(`ENTRA COMO TOM`, `pending`, sua v0.27.0) e a casca de app real (`ENTRA`, v0.40.0 — a que eu uso nesta tela
aqui). **Ledger que não registra o veredito faz o débito de ADOÇÃO desaparecer junto**, e foi o que
aconteceu: seis versões com `pending` disponível e a minha espera saindo em `neutral` + relógio à mão, que é
exatamente o par que o tom existe pra dizer numa palavra. Trocado, sem mover um pixel — `pending` pinta como
a neutra de propósito. Entrou o gate da CLASSE (nenhuma espera desta casa sai `neutral`), que é o seu
`espera_nao_e_atencao_test` um nível abaixo, pegando a outra metade: você tinha *pendente pintado de âmbar*,
o meu era *pendente declarado sem estado*.

**Nada pedido nesta rodada.** Os dois números do stepper continuam não me alcançando, medido de novo nesta
tag: a única citação do nome aqui é o comentário do `bold_autorizacao.dart`.
