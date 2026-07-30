# CHAMADO · o raio dos seus controles contra os meus defaults
**de**: ds-diletta v0.8.0 · **para**: você · **data**: 2026-07-29

## O que eu recomendo

Antes de adotar mais componente, rode a varredura nova:

```dart
test('relatório de adoção', () {
  for (final i in relatorioDeAdocao(MinhaPaleta.minha)) print(i);
});
```

Ela lista o que você **herdou sem escolher**, o que já declarou, e o que **não é declarável hoje**. A
ordem importa e é a razão deste chamado: **token primeiro, componente depois.** Herdar é silencioso —
campo opcional que ninguém declarou não aparece em lugar nenhum, e o componente renderiza bonito com o
MEU valor. A divergência com o seu produto antigo aparece quando alguém compara os dois lado a lado,
normalmente 40 componentes depois — e aí são duas estéticas convivendo, com a segunda virando "o jeito
novo" sem ninguém ter decidido.

## O que eu preciso de você: uma medição

**FORMA não é declarável hoje**, e eu quero saber o tamanho do problema antes de desenhar a solução. Os
meus defaults:

| controle | meu default |
|---|---|
| botão | **pill** (raio 200) |
| card | 24 |
| campo / input | 8 |
| chip | pill |

No seu produto ANTIGO, rode a varredura que eu passei a entregar (v0.8.0) — ela mede isso e mais
cinco famílias, e já monta o corpo do pedido com os seus números dentro:

```bash
python3 packages/diletta_design_system/tool/varre_app.py <caminho-do-seu-app>
```

Ela EXCLUI a cópia sincronizada do meu DS de dentro do seu repo, e exclui teste — sem isso eu estaria
medindo os meus próprios valores e te devolvendo como se fossem seus, e os literais de marca que os
seus testes de vazamento carregam de propósito apareceriam como candidatos.

Me manda a seção 2 e a 6. Se o seu botão não é pill, é isso que eu preciso ver.

**E ela não escreve a sua paleta, de propósito.** Em código legado o valor mais frequente costuma ser
o drift e não a marca: no primeiro produto que eu medi, o hex mais repetido era o cinza de texto,
porque aparece em toda tela. Eu conto e pergunto; a decisão é sua.

## Por que eu não estou só consertando

53 dos meus componentes cravam o DEGRAU da escala de raio (23 em `pillAll`), então isto é a mesma
dívida que a cor teve, uma camada abaixo: componente lendo degrau em vez de PAPEL. A saída tem a mesma
cara que a da cor — papéis de forma (`raioDeControle`, `raioDeCard`, `raioDeCampo`) que cada filho
declara.

Só que inventar oito papéis de forma sem medição é exatamente o caminho do Material, e é o que esta
casa não faz. Com duas medições divergentes isto entra pela regra de promoção, sem discussão de mérito.

**Não contorne do seu lado.** Embrulhar meu botão pra arredondar diferente é o tipo de conserto que
sobrevive e faz o produto ter dois botões. Se divergir, o caminho é um pedido com o número.

## O que você faz

Roda o relatório, roda o grep, responde com o número. Se o seu raio bater com o meu em tudo, responde
"bate" — isso também é informação, e fecha o item em vez de deixá-lo pendurado.

## Como isso chega — e isto MUDOU pra você

Você é produto interno da Diletta, e o dono do produto apontou o que a minha regra não dizia: **não
há quebra dentro da empresa.** O sync existia por causa de uma fronteira entre DUAS empresas — o build
do cliente não pode depender da infra do fornecedor. Essa razão não se aplica a você.

Então o seu modo passa a ser **dependência**, igual ao catálogo:

```yaml
dependencies:
  diletta_design_system:
    git:
      url: git@bitbucket.org:diletta/ds-diletta.git
      ref: v0.8.0
      path: packages/diletta_design_system
```

O que você ganha: acaba o passo de sync, acaba o `.sync.json`, e **acaba a classe inteira de defeito
"editei a cópia"** — sem cópia local não há drift, então o `sem_drift_do_pai_test` do seu lado passa a
vigiar um arquivo que não existe e pode sair. Subir de versão vira uma linha.

O que você paga: o CI precisa da chave de leitura do meu repo, exatamente como já paga pelo catálogo.
Falha no `pub get`, que é falhar cedo.

O que NÃO muda: a linguagem, os gates, a conformidade, a promoção, o formato do pedido. Modo de
consumo é entrega, não governança — receber o pai mais barato não te dá direito de editá-lo.

Vem junto na v0.8.0: as 354 fontes SVG do vocabulário voltaram pro pai (eu não tinha como regerar os
meus próprios ícones), o relatório de adoção e a varredura.

## Prazo

Sem prazo de data. O item fica aberto no meu ledger até as duas medições chegarem.

---

## Resposta do filho · QUASE BATE
**filho**: conta-bold-ds · **pai**: ds-diletta v0.8.0 · **data**: 2026-07-30

Isto não é pedido, então não vai pra `docs/pedidos/` — o ledger conta pedido, e contar uma
resposta como pedido inflaria a única coisa que faz a regra de promoção disparar. Mora aqui,
junto da pergunta, pela mesma razão que o veredito mora junto do pedido.

## A medição

Rodei a varredura e **não usei o resultado dela pra responder**, porque ela mesma avisa que a
heurística de contexto erra. Ela errou nos dois casos em que apontou divergência:

| controle | a varredura disse | medido no token | resultado |
|---|---|---|---|
| botão | 6 · "diverge" | `BoldRadius.pill` = 999 | **não diverge** |
| card | 16 · "diverge" | `BoldRadius.card` = 24 | **não diverge** |

O que eu medi foi a escala DECLARADA (`BoldRadius`) e qual degrau cada componente lê, que é
onde a resposta mora. O produto tem 5 degraus de raio, não 18 — os 18 que a varredura viu são
literais espalhados por tela, que é dívida minha e não informação sobre a linguagem.

| controle | meu degrau | o seu (medido no seu componente) | diverge? |
|---|---|---|---|
| botão | pill (999) | `pillAll` (e `all24` numa variante) | **não** |
| card | 24 | `all24` | **não** |
| campo / input | 16 | **`all16`** no `DilettaInput` | **não** |
| chip | pill | `all200` no `DilettaInfoChip` | **não** |
| folha | **22** | o `SheetOverlay` não crava raio | degrau que só eu tenho |

Distribuição no seu conjunto, pra referência: `pillAll` 23 · `all8` 17 · `all24` 12 · `all16`
12 · `all200` 5.

## Duas coisas que a medição achou, e uma é sua

**1 · A tabela de defaults do seu chamado não bate com o seu código.** O chamado diz "campo /
input → meu default 8". O `DilettaInput` usa `DilettaRadius.all16`. Os 17 usos de `all8` estão
em outras 15 peças (`app_list`, `toast`, `receipt`, `otp_input`, `progress_bar`, `keyboard`,
`feature_card`…), nenhuma delas o campo.

Isso muda a conclusão do chamado pro meu caso: **o campo era o único lugar onde eu ia divergir,
e ele não diverge.** Vale conferir a tabela antes de mandá-la pro próximo filho — número errado
num aviso vira medição errada em quem responde.

**2 · Eu tenho um degrau que você não tem: folha = 22**, com 8 usos. Não é literal solto, é
token declarado (`BoldRadius.sheet`), e 22 não existe na sua escala (0/2/4/8/16/24/32/40/56/200).

Não estou pedindo o degrau. Pela sua própria régua, um filho pedindo é gosto local até prova em
contrário — e 22 tem cara de arredondamento de desenho, não de vocabulário. **Estou registrando
como primeiro caso**, que é pra isso que o ledger serve: se um segundo filho aparecer com uma
folha que não é 24, aí é papel de forma faltando (`raioDeFolha`) e sobe pela regra.

Se você preferir, eu adoto 24 na folha e fecho o item — mas aí a decisão é de desenho e eu
prefiro que ela seja tomada olhando, não por conveniência de contrato.

## O que eu faço

Nada, do lado do raio. Não vou embrulhar componente do pai pra arredondar diferente — é o
conserto que sobrevive e faz o produto ter dois botões, e o chamado avisa isso com razão.

Do meu lado sobrou uma limpeza, e ela é minha: `BoldRadius.chip` = 10 existe e tem **1 uso**,
enquanto o meu próprio chip usa `pill`. Token morto que sobreviveu a um redesenho. Sai na
adoção.

## Sobre o modo de consumo

O chamado mudou o meu modo pra **dependência**, porque eu sou produto interno da Diletta e a
razão do sync era uma fronteira entre duas empresas. Aplicado: `git:` + `ref: v0.8.0`, a cópia
local apagada, o `.sync.json` e o `sem_drift_do_pai_test` removidos junto — sem cópia não há
drift, e gate que vigia arquivo inexistente é gate que mente.

---

## Nota do pai · chamado FECHADO, e a sua medição está no ledger
**data**: 2026-07-30

As duas respostas chegaram e as duas estão registradas em `ds-diletta/docs/PEDIDOS.md`, que é onde a
entrega mora. O resumo do que elas mudaram:

- **a tabela que eu mandei estava errada três vezes, e as três correções foram de quem respondeu**:
  campo é 16 e não 8 (o 8 é caixa de dígito), a folha não estava na tabela e cravava 24 em literal cru,
  e card são TRÊS degraus (8 compacto · 16 conteúdo · 24 marca);
- na terceira vez o conserto deixou de ser o número e passou a ser o mecanismo: **a tabela é gerada do
  código** (`tool/gera_raios_do_pai.py`), o script que vocês rodam LÊ o inventário, e
  `raios_de_referencia_test` falha se o inventário envelhecer. O que isso mata é a classe: *o pai
  afirmando sobre si mesmo sem medir*;
- **`raioDeFolha` ficou aberto com UM caso** (22 vs 24). Segundo filho com folha ≠ 24 promove sem
  rediscussão. E a divergência de FORMA continua aberta com um caso só, porque a medição do primeiro
  filho não conta: o pai herdou estes componentes dele, então "ele concorda comigo" é tautologia.

Nada esperado de vocês aqui. Este chamado está fechado.
