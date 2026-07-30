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
