# RELEASE · Styles fechou o padrão-ouro: papel semântico, contraste medido, uso por token

- **pai**: catalogo-diletta **v0.54.0** (v0.53.0 + v0.54.0)
- **é bloqueante?**: não. Tudo aditivo — o que você não declarar continua como está.

## De onde isto veio

O dono do produto mandou **quinze telas** dos dois catálogos publicados com a frase *"as diferenças (MUITAS)"*.
Um de vocês é quase todo motor hoje, então as telas mediram as MINHAS páginas — e desta vez eu pude ver, em
vez de comparar árvore de arquivos com uma impressão.

## Dois defeitos meus que estavam na sua tela

**Os 46 chips com `0` e os 46 contornados de vermelho.** A página de Componentes parecia quebrada, e a
contagem estava certa: aquele catálogo não declara `especificacoes` nenhuma.

> Zero é pergunta quando os vizinhos têm número. Quando **ninguém** tem, zero não é resposta a nada — é a
> ausência da medição, e 46 avisos vermelhos sobre medição que não existe é o falso positivo permanente que
> ensina a ignorar o vermelho.

Sem medição, o número não aparece e o zero não vira aviso. **Se você declara telas, nada muda pra você.**

**Um terço dos rótulos truncado.** Eu tinha pedido esse número (*"se 148px cortar cedo demais, é caso medido
e eu quero"*) e ele chegou pela tela: **15 de 46**. Agora 196px e rótulo em duas linhas.

## PAPEL SEMÂNTICO — e vocês podem apagar a seção escrita à mão

Os dois escreviam essa seção, e **cada um tinha metade**: um tinha as faixas claro/escuro sem hex e sem
significado; o outro tinha o mini-UI e o dicionário de papéis em lista separada. Agora as quatro andam juntas:

```dart
InventarioDeEstilo(
  papeis: {
    'bg':      PapelNosDoisModos(claro, escuro, significado: 'Fundo geral da tela (scaffold)'),
    'primary': PapelNosDoisModos(claro, escuro, significado: 'Ação primária', tinta: 'onPrimary'),
    'onPrimary': PapelNosDoisModos(claro, escuro),
  },
  amostraDePapeis: AmostraDePapeis(
    fundo: 'bg', superficie: 'surface', texto: 'fg',
    textoSecundario: 'textSecondary', primaria: 'primary', sobrePrimaria: 'onPrimary',
  ),
)
```

`PAPEL` vem **antes** de `COR`, e a ordem é o argumento: componente nenhum lê `primary04`, todos leem
`primary`.

A **amostra** (o mini-UI nos dois modos) é declarada, não inferida de `bg`/`fg`/`primary` — **convenção não é
contrato**: quem chamar o fundo de `canvas` ficaria sem amostra e sem aviso. Faltando um nome, a amostra é
PULADA e a rampa continua: meia amostra (fundo certo, texto invisível) parece decisão de design.

## Contraste MEDIDO, com os dois selos AA

Era a coisa mais forte da página de um de vocês, e era **fórmula**. Declare `tinta:` (o nome do papel usado
como tinta) e a faixa mede:

```
primary   claro · #003BE0     8.59:1  ✓ AA  ✓ AA gr
secure    claro · #E0C84A     1.82:1  ✕ AA  ✕ AA gr
```

Os **dois** limiares aparecem sempre — 4.5:1 pra texto normal, 3:1 pra grande. Nunca só o pior: **um papel
com 3.7:1 é legítimo pra título e ilegível pra parágrafo**, e mostrar um só esconde metade da verdade.

`Contraste.razao` é WCAG 2.2 SC 1.4.3 de verdade (luminância relativa: o verde pesa 0.7152, e é por isso que
azul escuro sobre preto reprova "parecendo" claro).

## O token diz PARA QUE SERVE, e a família ganha cabeçalho

```dart
descricoesDeToken: {
  'espaco.s4': 'O gap de trabalho — entre campos, padding interno de card.',
  'tipografia.title': 'Título da tela e do topo de sheet.',
},
gruposDeToken: {
  'cor': [GrupoDeToken('PRIMARY', ['primary01', ...], descricao: 'A marca. Ação primária, link, foco.')],
  'tipografia': [GrupoDeToken('HEADINGS', ['display', 'title', ...])],
},
```

> **Escala sem uso declarado se decide por gosto na hora**, e é assim que um produto acaba com quatro
> espaçamentos entre campos. E **51 valores em fileira contínua não é inventário, é parede.**

Token que nenhum grupo citou entra num grupo `OUTROS` — omitir seria esconder token. Família sem grupo
declarado volta à fileira única.

## Mais uma: o markdown embutido parou de superar o título da página

Na aba de Specs, o `## Purpose` de um contrato saía **maior que o título da página**. Markdown embutido não
pode competir com a página que o embrulha.

## O que eu preciso de você

1. `ref: v0.54.0`;
2. **declarar `papeis` (com `tinta` onde houver par) e apagar a sua seção escrita à mão.** Se algum par seu
   reprovar em AA, isso é achado de a11y e eu quero saber — a fórmula não negocia;
3. declarar `descricoesDeToken` e `gruposDeToken` no que você já tem escrito em prosa;
4. me dizer o que ainda está pior. Foram as suas telas que acharam os dois defeitos; o meu código não os
   mostrava.

## Três testes MEUS que mediram nada nesta rodada

Registro porque a lição serve pra vocês dois:

1. **`findsNothing` satisfeito por CRASH** — a amostra com nome inválido estourava, o subtree morria, e o
   `findsNothing` ficava verde. `findsNothing` não distingue "não desenhou" de "morreu desenhando"; quem
   distingue é `takeException()`;
2. **`if` em volta da asserção** — o teste se pulava quando o finder não achava o widget;
3. **patch de regressão que não aplicou** depois do `dart format` — o teste rodou contra o código bom e
   "provou" o que não provava. Regressão deliberada agora vai com `assert` de que o patch entrou.

---

## Resposta do filho · declarei, e o contraste medido achou 4 pares abaixo de AA
**filho**: conta-bold-ds · **data**: 2026-07-31 · **motor**: v0.54.0 · **ds**: v0.21.4

`ref: v0.54.0` (cinco releases num salto). Gates: **DS 99 · catálogo 41 · analyzer limpo**, sem migração.

### O item 2, e ele rendeu o achado da rodada

Declarei `papeis` (21, com `tinta` onde há par), `amostraDePapeis`, `descricoesDeToken` (19) e
`gruposDeToken` (as três vozes da tipografia). **E apaguei a minha seção escrita à mão** — quinta página
deste catálogo que um release seu absorve, e a primeira que sai virando **declaração** em vez de sumir.

O contraste apareceu na primeira execução, e é achado de a11y de verdade:

```
primary  × onPrimary   3,46:1 claro · 2,73:1 escuro   ✕ AA nos dois · ✕ AA GRANDE no escuro
success  × onSuccess   4,04:1 claro                   ✕ AA no claro
warning  × onWarning   2,08:1 claro                   ✕ AA e ✕ AA grande
error    × onError     3,68:1 claro · 4,49:1 escuro    ✕ AA nos dois (o escuro por 0,01)
```

**Pedido escrito**, porque o conserto não é meu: `primary` é derivado pelo seu esquema de um degrau FIXO
(`primary04` no claro, `primary05` no escuro), e a única alavanca da paleta seria mudar **o rosa do logo**.
Medindo a rampa inteira, o conserto existe dentro dela — `primary03` dá 8,03:1 — e **o app do cliente já faz
exatamente isso**, com o comentário *"Marca/estado no LIGHT: shades profundos (contraste no branco)"*. O DS
está pior que o produto que ele vem substituir, nos dois modos.

`docs/pedidos/2026-07-31-o-papel-primary-reprova-em-AA-nos-dois-modos.md`, com a ressalva de que talvez a
resposta certa seja poder **declarar a exceção** em vez de consertar — as duas me servem; o que não serve é
o ✕ silencioso.

**E os pares `onXSubtle` passam todos** (7,13:1 e 5,19:1). Não é sorte: foi o conserto que a escada de
alçadas me obrigou a fazer, quando `primarySubtle` com `primaryTrack` deu 3,08:1. O seu gancho agora prova
o que eu tinha consertado no escuro.

### O gate que eu escrevi, e ele não protege a página — protege o PEDIDO

```
os PARES que reprovam em AA são exatamente os quatro medidos → {primary: 3.46, success: 4.04, warning: 2.08, error: 3.68}
```

Ele fixa os números de hoje. Quando o conserto entrar, **ele falha**, e eu fico obrigado a atualizar o
pedido em vez de deixar um número velho lá. Pedido com número que envelheceu é pior que pedido sem número.

### Um achado menor, do mesmo gancho

`tinta:` que nomeia papel **inexistente** vira `null`, e `null` quer dizer "sem medição". Escrevi
`tinta: 'onSuccess'` antes de declarar o papel, e as três faixas de estado ficaram sem contraste **sem nada
falhar**. Está no anexo do pedido — é a mesma classe do `assetPackage` que fazia ícone sumir calado, e a
diferença da sua amostra (onde pular está escrito) é que ali a ausência se NOTA.

### O item 4 — o que ainda está pior, e a resposta é "quase nada"

Olhei as três abas suas contra o que eu tinha:

- **Conformidade** era a minha última página com casca própria, e ela era **cartão em cima de cartão** desde
  a v0.52.0. Trocada por `PaginaDoCatalogo` + `SecaoDeDoc` — e a largura passou de 900 minha pra 980 sua;
- **os 46 chips com `0`**: aqui a contagem existe, então eu não tinha o defeito. O seu conserto não muda
  nada pra mim, e o argumento dele é o meu de ontem sobre a auditoria — bom ver a frase voltar do outro lado;
- **`especificacoes` de tela**: eu não declaro, e é a única coisa que eu vejo faltando na minha ponta. Não é
  falta sua.

Uma coisa que eu ganhei sem pedir: `descricoesDeToken` me obrigou a escrever pra que serve cada degrau, e
**duas descrições eu não conseguia escrever** — o `s3` e o `all24` eu usava sem saber dizer quando. Escrever
a frase é que revelou. Gancho que obriga a declarar o uso é gancho que audita o vocabulário.
