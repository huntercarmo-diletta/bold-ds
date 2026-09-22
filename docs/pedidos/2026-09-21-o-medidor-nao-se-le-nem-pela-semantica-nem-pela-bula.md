# PEDIDO · O medidor não se lê — nem por quem usa leitor de tela, nem por quem lê a bula dele

- **de**: conta-bold-ds (filho A) · **para**: ds-diletta
- **consome**: ds-diletta `v0.204.0` · `web-v0.204.0`
- **bloqueante?**: **sim para um fluxo, não para a peça.** Uma auditoria WCAG 2.2 reprovou hoje o
  fluxo «Meus limites» — fluxo de dinheiro — e o 4.1.2 desta peça é um dos motivos que sobrevivem à
  medição.
- **não é peça nova**, por isso não abre com `DilettaManifesto.busca` (contrato, `v0.206.0`). É
  campo ausente e bula velha numa peça que existe e que esta casa já ajudou a consertar **duas
  vezes**: o `tone` (pedido de 09/08, `v0.63.0`) e o trilho (pedido de 10/08, `v0.64.0`).

## Falta

Duas coisas no mesmo arquivo, `diletta_progress_bar.dart`, e a segunda é a razão de a primeira ter
demorado a aparecer.

**(a) A barra não tem semântica.** Não há como um leitor de tela anunciar o progresso. O percentual
existe na tela apenas se o consumidor escrever no `caption`; na árvore de acessibilidade ele não
existe de jeito nenhum.

**(b) A tabela de contraste do `///` descreve um trilho que a peça não usa há seis semanas** — e
hoje essa tabela reprovou um fluxo por um defeito que já não existe.

## Número

**(a) Semântica ausente**

`Semantics` no arquivo inteiro, na `v0.204.0`: **zero ocorrências**. O `build` monta trilho e
preenchimento e não embrulha nada.

As três skins são atingidas — `.banner`, `.activity` e `.value` —, e o caso que dói é o medidor de
limite: numa lista de cinco linhas, quem ouve recebe *«Pix, R$ 1.200 de R$ 5.000»* do texto irmão e
**nunca o quanto disso já foi**. A barra é o único lugar onde essa fração está, e ela é muda.

**E isto é a deixa do veredito de 09/08, não um pedido novo em cima dele.** Ali o contraste do
`warning` fez o pai pôr o TEXTO junto nos dois medidores. O texto entrou — **na linha irmã**. Quem
vê, lê. Quem ouve, não: o texto irmão dá reais, e o percentual segue só na pintura.

**(b) A bula**

O `///` (linhas 83–91) diz, hoje, na tag que consumimos:

> «Elemento gráfico pede **3:1** (WCAG 1.4.11). Contra o trilho `neutral07`: […] `warning` **1,82** ·
> **1,17** […] **Nenhum alcança 3:1**»

O trilho não é `neutral07` desde a **`v0.64.0`**, que foi a sua resposta ao nosso pedido
[o trilho da barra é claro nos dois temas](2026-08-10-o-trilho-da-barra-e-claro-nos-dois-temas.md).
A linha 121 pinta `s.trilhoDeMedidor`, e o papel é derivado com piso:

```dart
// diletta_scheme.dart:504 (claro) e :714 (escuro)
warningGrafico: _primeiroQueAlcanca(3.0, trilho, [p.warning04, p.warning03, p.warning02, p.warning01])
```

Medido hoje com os hex reais das variáveis, contra `trilhoDeMedidor` = `#3D3939` nos dois modos:

| tom | claro | escuro |
|---|---|---|
| `normal` | **3,29** | **4,18** |
| `warning` | **5,48** | **6,39** |
| `error` | **3,10** | **3,51** |

**As seis passam.** E os números da bula não batem nem contra o trilho antigo: contra `neutral07`
dariam **1,22 e 1,04**, que são os números do nosso pedido de 10/08 — não os 1,82 e 1,17 que o texto
repete desde antes dele.

**O custo, medido, não hipotético.** Hoje o comentário do componente `ProgressBar / valor` na
biblioteca Figma copiou essa tabela; a auditoria WCAG leu o comentário; e o 1.4.11 saiu como
**bloqueante** de um fluxo de dinheiro. Três saltos, e a origem é um `///` que não acompanhou o
próprio conserto. **De três bloqueantes que a auditoria levantou, dois eram falsos, e este é o que
nasceu aqui dentro.**

**(c) O degrau que achei medindo (b), e que não é (b)**

`_primeiroQueAlcanca` (`diletta_scheme.dart:1035`) **não garante o piso que o nome promete**:

```dart
Color _primeiroQueAlcanca(double piso, Color contra, List<Color> candidatos) {
  for (final c in candidatos) {
    if (dilettaContrastRatio(c, contra) >= piso) return c;
  }
  return candidatos.reduce((a, b) => ... );   // o melhor da lista, e segue calado
}
```

Se nenhum candidato alcança, devolve o melhor e não avisa ninguém. Na nossa paleta os seis passam.
**Em outra paleta, podem não passar, e nada acusa** — que é a mesma forma do defeito (b): um número
que se acredita verdadeiro porque alguém o escreveu uma vez.

## Já tentei

**Escrever o percentual no `caption` em cada chamada.** É o que a peça permite hoje, e é o que a
biblioteca Figma passou a fazer nesta semana (`showCaption` ligado por padrão). Resolve quem vê e
não resolve quem ouve: `caption` é um `Text`, não um valor semântico, e um leitor de tela o anuncia
como texto solto, depois da barra, sem relação declarada com ela.

**Embrulhar a barra em `Semantics` do nosso lado.** Funciona por chamada e não escala: são três
skins e cada consumidor teria de repetir a mesma expressão, incluindo a conversão de `0..1` para
percentual. E fica errado por construção — o consumidor não sabe se a peça já anuncia algo, então ou
duplica ou silencia com `ExcludeSemantics` às cegas.

**Corrigir a bula do nosso lado.** Não dá: o `///` é do pai, e é ele que a biblioteca Figma e as
auditorias leem.

## Conferi no pai

- `packages/diletta_design_system/lib/src/widgets/diletta_progress_bar.dart` — `Semantics`: **0**.
- Mesmo arquivo, `///` linhas 83–91 — a tabela de `neutral07`, intacta.
- Mesmo arquivo, linha 121 — `color: isBanner ? DilettaAbsoluteColors.whiteAlpha24 : s.trilhoDeMedidor`.
- `diletta_scheme.dart:504` e `:714` — a derivação com piso 3.0.
- `diletta_scheme.dart:1035` — o `reduce` de último recurso.
- Tudo lido em `git show v0.204.0:…`, que é a tag que consumimos, e não na ponta.

**A peça vizinha já tem o que peço.** `DilettaAppListRow` expõe `footer` (`diletta_app_list.dart:1450`)
e o próprio `///` da barra cita esse uso em `activityItem` — ou seja, a linguagem já prevê a barra
dentro de uma linha de lista. É justamente o arranjo em que a semântica ausente aparece.

## Derivável?

**Não.** Semântica não se deriva de fora: o widget é quem sabe o valor contínuo `0..1` e é o único
que pode declarar `value`. E a bula é do arquivo dele.

## Se você disser não

Para **(a)**, vamos embrulhar `DilettaProgressBar` numa casca nossa em `packages/coreflow` com o
`Semantics` que falta, e vai custar o de sempre: a casca envelhece, o dia em que a peça ganhar
semântica própria passamos a anunciar duas vezes, e o filho B não herda nada.

Para **(b)**, vamos escrever no nosso lado que a tabela do `///` está velha — o que conserta a
próxima auditoria **nossa** e não conserta a do filho B, nem o comentário da biblioteca Figma, nem a
próxima pessoa que abrir o arquivo.

**Para (c) não temos saída nenhuma**, e é por isso que ele está aqui: o silêncio do `_primeiroQueAlcanca`
só se conserta onde ele mora.

## Não estou pedindo

- **Não peço tom novo nem cor nova.** Os seis tons passam; o que está errado é o texto que diz que
  não passam.
- **Não peço o percentual visível obrigatório.** Cor sozinha não é informação (1.4.1), e o veredito
  de 09/08 já resolveu isso com o texto ao lado. O que falta é a leitura, não a pintura.
- **Não peço `caption` colorido por tom.** Ele apareceu na mesma varredura e é pequeno demais para
  vir sozinho; se você mexer no arquivo, ele pega carona, e se não mexer, ele espera.
- **Não peço peça nova.** A linha de limite com medidor se monta com o `footer` que já existe, e ela
  é nossa.

## Como o pai vai saber que funcionou

**(a)** Um teste que renderiza `DilettaProgressBar.value(0.24)` e lê a árvore de semântica, exigindo
um nó com `value` não nulo — e que o trilho e o preenchimento **não** apareçam como nós próprios.
Proposta de API: `Semantics(value: '<n>%', container: true)` no `build`, com um `semanticValue`
opcional para o consumidor sobrescrever (o caso em que o medidor conta reais, não percentual).

**(b)** Um teste que **recalcula** a tabela em vez de repeti-la: para cada tom, `dilettaContrastRatio`
contra `trilhoDeMedidor` nos dois modos, comparado com o que o `///` afirma. Se a bula e a medição
divergirem, vermelho. É o degrau que faltava — a tabela de 10/08 estava certa quando foi escrita, e
envelheceu sem que nada perguntasse.

**(c)** Um `assert` (ou um gate sobre as paletas conhecidas) em `_primeiroQueAlcanca`: quando a lista
se esgota sem alcançar o piso, dizer qual papel, qual paleta e qual foi o melhor. **Você tem as
paletas dos três filhos e a régua; eu tenho uma só** — se o degrau valer mais como gate de paleta do
que como `assert` em runtime, a escolha é sua.

## Como cheguei aqui

Ela pediu um fluxo de design para os grupos de limite que o back abriu, e o caminho foi inteiro:
crítico de UX → redator → protótipo no Figma com as peças da biblioteca → `auditor-acessibilidade`
sobre os 14 frames. A auditoria reprovou o fluxo com três bloqueantes.

Depois o `construtor-biblioteca-figma` foi criar as peças que faltavam e **mediu os hex reais**, e as
duas medições discordaram. Fui ao Dart da `v0.204.0` desempatar: o contraste passa, a bula mente, e
a semântica — que ninguém tinha olhado, porque a bula dizia que o problema era a cor — está mesmo
ausente.

**O bloqueante verdadeiro estava escondido atrás do falso.**

---

## Nota do filho · 2026-09-22 — o remendo saiu, e ele está no app

Este pedido ainda não foi enviado, e nesse meio-tempo o fluxo virou código. **O contorno previsto na
seção «Se você disser não» deixou de ser hipótese: ele existe, medido, no app.**

`lib/features/limites/presentation/widgets/medidor_de_teto.dart` (commit `b8a0a44e`, 22/09 14h35),
**172 linhas**, faz exatamente o que este pedido dizia que teria de fazer:

```dart
ExcludeSemantics(                       // :62  — a barra sai da árvore inteira
  child: DilettaProgressBar.value(
```

```dart
return Semantics(                       // :96  — e a linha reconstrói o anúncio à mão
  ...
  excludeSemantics: true,               // :107 — apagando também o que o AppListRow diria
  child: DilettaAppListRow(
```

Três coisas que este arquivo prova e que o pedido original só supunha:

1. **o contorno não é «escrever o percentual no `caption`»** — é apagar a árvore de acessibilidade
   de duas peças suas (`DilettaProgressBar` e `DilettaAppListRow`) e reescrever o nó por cima. O
   consumidor não contorna a falta: ele desliga a peça;
2. **ele não viaja.** A frase anunciada é montada no widget do produto, com as palavras deste
   fluxo. A segunda tela que usar o medidor escreve a dela;
3. **o `ExcludeSemantics` vira dívida no dia em que o campo chegar.** Quando `DilettaProgressBar`
   ganhar semântica, este arquivo passa a escondê-la, e nada acusa — o app fica com o anúncio
   antigo e a peça calada, que é o pior dos dois mundos.

Nada mudou no mérito do pedido. O que mudou é o número da seção «Se você disser não»: o preço
deixou de ser estimado e passou a ter arquivo, linha e data.
