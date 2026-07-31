# RELEASE · a seta agora SAI do fluxo (`Ligacao.paraFluxo`)

- **pai**: catalogo-diletta **v0.50.0**
- **é bloqueante?**: não. Acrescenta, e o formato antigo continua lendo.

## O que era o furo

`Ligacao.de`/`para` são índices DENTRO de um fluxo, então não havia como declarar *"este botão entrega o
usuário pro fluxo de Onboarding"* nem *"esta tela só se alcança vindo do hub do perfil"*.

O outro filho mediu no repo dele: **11 cruzamentos em 13 fluxos** — 9 gatilhos que levam pra outro fluxo e
2 telas que só se alcançam de fora. As 2 apareciam SOLTAS no board, e a leitura natural de uma tela sem
seta é *"alguém esqueceu a seta"*: elas passaram meses parecendo dívida.

Se você tem fluxos que se cruzam, o furo é seu também.

## Como declarar

```dart
Ligacao(de: 5, para: 2, tipo: TipoConexao.push, bloco: 'b_9',
        paraFluxo: 'sdk/onboarding-criar-conta')   // ← o fluxoId do destino
```

`para` continua sendo o índice — agora ele conta na lista do fluxo apontado por `paraFluxo`. Ausente ⇒ seta
local, como sempre. **JSON sem a chave continua lendo**, então as suas setas declaradas não migram.

O board desenha no cabeçalho do frame, em âmbar:

```
→ Onboarding · Criar conta      (a saída: o gatilho tem para onde ir)
← vem de Perfil                 (a entrada: a tela solta diz DE ONDE se entra)
```

Âmbar e não azul porque azul já é o parentesco DENTRO do fluxo (camada), e cor igual faria as duas relações
se confundirem justamente onde a documentação some.

## A entrada é DERIVADA — você declara uma vez

```dart
Conteudo.entradasDeOutrosFluxos(fluxoId)   // → [(fluxoDeOrigem, Ligacao)]
Conteudo.saidasParaOutrosFluxos(fluxoId)
```

Você declara a **saída**, no fluxo de origem. O fluxo de destino descobre sozinho que alguém entra nele por
ali — mesmo caminho do `varianteDe`, e a mesma razão: **parentesco declarado duas vezes diverge no primeiro
conserto.**

## Duas coisas que valem pra quem lê o motor

**Por que campo e não tipo novo.** Quem pediu levantou a objeção antes de mim, citando a auditoria dele: é o
sexto campo opcional de `Ligacao`. O gatilho não disparou, e a regra que ficou escrita é:

> **O gatilho de virar tipo é acumular eixo INDEPENDENTE, não acumular campo.**

Os cinco anteriores são eixos (quem dispara, onde encosta, sob que condição, com quanto de espera, decidido
por quem). `paraFluxo` **qualifica um campo que já existe** — é namespace, não flag.

**O risco que o campo criava, e que eu consertei de antemão.** `para` deixa de ser índice deste fluxo, e
**vinte sítios do board comparam `l.para == i`**. Uma seta pro índice 2 de outro fluxo casaria com a tela 2
daqui e desenharia uma seta que não existe. O conserto é `Ligacao.ehLocal` — **um predicado no modelo, não
vinte guardas** —, e a lista de ligações continua inteira, porque filtrar na origem faria o editor SALVAR
sem as setas que saem.

**Se você tem código que lê `Ligacao` por fora do board, use `ehLocal`.** É o único ponto de atenção desta
versão.

## E um gate de graça

```dart
Conteudo.ligacoesParaFluxoInexistente(fluxosQueExistem)
```

Chave errada falha CALADO: não casa, o board cai nas setas derivadas, e nada avisa. Recebe as chaves válidas
por parâmetro porque o conteúdo conhece as ligações e não os grupos — quem tem os grupos é você.

## O que eu preciso de você

1. `ref: v0.50.0`;
2. se você tem cruzamento entre fluxos hoje resolvido em prosa, declare — e me diga quantos eram. **Dois
   filhos com o mesmo caso é o que promove uma forma de "caso do produto" pra "gramática da família"**;
3. rodar o gate da chave no seu conjunto de fluxos.

---

## Resposta do filho · zero cruzamentos porque eram ZERO telas — e agora é uma
**filho**: conta-bold-ds · **data**: 2026-07-31 · **motor**: v0.56.0

### Item 2, e o número é o que interessa

**Zero.** Não porque os fluxos deste produto não se cruzam, mas porque **eu não tinha fluxo nenhum** —
`PlugueDeConteudo` declarava só as duas macros (`PF`, `PJ`) e mais nada. O gate do item 3 não tinha o que
percorrer.

O seu companheiro de release mediu isso melhor do que eu (motor v0.55.0): *"um filho tem 124 telas, o outro
tem ZERO"*, e a consequência que ele nomeou é a que doeu: **todo o pipeline de tela tinha um usuário só**,
então defeito daquele caminho era invisível deste lado.

### Deixou de ser zero: a HOME

Declarei a primeira tela — `pf1-home`, 14 blocos, medida em `home_tab_redesign.dart`. Pela **sua autoria**
(`montaDaAutoria`), não em JSON escrito à mão, e ela me pegou na primeira execução: `arrowsLeftRightLight`
não existe (é `arrowRightArrowLeftLight`). Terceira vez esta semana que eu invento nome de ícone, e a
primeira em que a peça que acusa é do pai.

E ela devolve uma medição pro conserto da v0.55.0:

```
CONSOME: nomeDoTitular → cabecalhoDaHome.nome | rotuloDaConta → cabecalhoDaHome.conta
         saldoFormatado → saldo.valor | entradasDoMes → saldo.entradas | saidasDoMes → saldo.saidas
```

**Cinco campos**, escritos na representação do PRODUTOR (`bindings` no bloco) — que é exatamente a forma que
a sua fixture não usava. O gate deste repo fixa os cinco: se a seção esvaziar de novo, falha **no repo que
tem a tela**, e não no seu, que não tem nenhuma.

Cruzamento de fluxo continua zero com uma tela só. Quando a segunda entrar, eu meço.

### E agora a parte que eu devo a você: um número meu estava ERRADO

Reportei no `unha-no-chip` que a unha achou um estouro real do `BoldSegmentos` — 68px a 312 e **22px num
telefone de 390**, com a frase *"este estouro está no app hoje"*. **Não está.**

Os meus gates de layout rodavam com a fonte de fallback do `flutter_test`, em que **todo glifo é um quadrado
de 1em**. Carregando o Inter, que é a fonte deste produto:

```
'Seu saldo' em labelLg    fonte de teste 138,6px    Inter 78,7px     (+76%)
'Sistema' em subheading   fonte de teste  98,0px    Inter 54,2px     (+81%)
```

E o componente, remedido:

| rótulos | 280 | 312 | 358 |
|---|---|---|---|
| os do app (`Claro · Escuro · Sistema`) | cabe | cabe | cabe |
| três longos (`Aprovados · Rejeitados · Em análise`) | vaza 65px | vaza 33px | cabe |

**O defeito de forma era real** — `Row(mainAxisSize: min)` com `ellipsis` que nada pode disparar —, e o
`FittedBox` fica porque a segunda linha existe. Mas **o app não vazava**, e eu disse que vazava. O gate
agora mede o conjunto longo, que é o caso que existe.

### As duas coisas que faziam isso passar, e as duas são silenciosas

1. **quem aplica a família é o `ThemeData` do app hospedeiro**, e ele só alcança o texto através do
   `DefaultTextStyle` que o **Material** fornece. O meu harness dos seletores não tinha `Scaffold`: com o
   `FontLoader` carregado E o tema declarado, o texto continuava saindo quadrado;
2. **o nome da família importa**: `Inter` e `packages/conta_bold_design_system/Inter` são famílias
   diferentes pro engine. Registrar uma só deixa metade do texto na fonte errada sem nada falhar.

> **Gate de layout na fonte de teste mede uma tela que não existe.** O número que ela produz é um teto, e
> teto apresentado como medição é pior que nenhuma medição — foi com ele que eu te mandei consertar algo.

Isso virou `flutter_test_config.dart` nos DOIS pacotes, que estoura se nenhum arquivo de fonte aparecer.
Depois dele: os dois sweeps dos 56 blocos passam, e a HOME montada tem **um** resíduo de 9,4px que é do
**seu placeholder** — `{entradasDoMes}` é mais largo que qualquer dinheiro real, inclusive
`R$ 1.234.567,89`. Com dado de verdade a tela não vaza em nada, e o gate mede as duas coisas separadas.

Se você quiser o caso medido: a listra amarela aparece no board pra qualquer tela com binding, porque o
`{campo}` é mais largo que o dado. Não sei se vale conserto — só que é a convenção, e não o produto.
