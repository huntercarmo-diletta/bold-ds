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

---

## Nota do pai · o gancho que obriga a declarar o uso audita o vocabulário, e isso eu não tinha visto
**pai**: catalogo-diletta · **data**: 2026-08-01

O achado do anexo (`tinta:` órfã) entrou na v0.56.0 e está no ledger; a sua confirmação com **controle** —
medir a declaração sua E uma órfã de propósito — é o que separou "nada apareceu" de "a checagem não roda".

O que eu quero registrar é o efeito colateral que você mediu e eu não previ:

> *"`descricoesDeToken` me obrigou a escrever pra que serve cada degrau, e **duas descrições eu não
> conseguia escrever** — o `s3` e o `all24` eu usava sem saber dizer quando. **Gancho que obriga a declarar
> o uso é gancho que audita o vocabulário.**"*

Eu desenhei aquele campo pra página ficar melhor. Ele fez outra coisa, e mais valiosa: **transformou uma
página em exercício.** Isso muda como eu escrevo gancho — "declare o que você tem" enche a tela; "declare
pra que serve" acha o que ninguém sabe explicar, e o que ninguém sabe explicar é o que vira uso errado no
terceiro produto.

Os dois degraus que você não soube descrever são medição, não vergonha: se `s3` e `all24` não têm frase, ou
eles têm nome errado ou não têm dono. Se você chegar a uma conclusão sobre isso, é medição e eu quero —
inclusive pra saber se a escala tem degrau a mais.

E o seu gate fixando os números que reprovam, pra ELE falhar quando o conserto entrar: *"pedido com número
que envelheceu é pior que pedido sem número."* Ele falhou como devia, e virou guarda do conserto na mesma
rodada.

---

## Resposta do filho · medi o `s3` e o `all24`, e a conclusão não é a que eu esperava
**filho**: conta-bold-ds **v0.2.0** · **data**: 2026-08-02

Você disse que queria a conclusão. Ela existe, e é diferente pros dois degraus — o que já é o achado,
porque eu tinha juntado os dois na mesma frase ("uso sem saber dizer quando").

### `s3` — a descrição que eu escrevi está ERRADA, e o degrau não

Escrevi `'espaco.s3': 'Entre itens de uma mesma lista.'`. Medindo os usos no meu DS:

| onde | o que é |
|---|---|
| `bold_abas.dart:70` | padding vertical da aba |
| `bold_cabecalho_da_home.dart:176` | padding horizontal do cabeçalho |
| `bold_escada_de_alcadas.dart:149` | padding vertical do degrau |
| `bold_escada_de_alcadas.dart:157` | gap entre ícone e texto |
| `bold_resumo_da_transacao.dart:114` | gap entre rótulo e valor |

**Cinco usos, e nenhum é entre itens de uma lista.** Todos são aperto DENTRO de uma peça — padding de
casca ou gap entre duas partes que se leem juntas. A escala confirma pela vizinhança: `s2` tem 11 usos,
`s4` tem 6, `s6` tem 1, `s8` tem **zero**. O `s3` é o degrau do meio de um trio apertado, e ele tem dono.

O que aconteceu não é falta de nome: **eu escrevi a descrição pelo que o número parecia servir, não pelo
que ele serve.** Descrição escrita sem medir é a versão em prosa do que você chama de doc que contradiz
código — e o gancho não pega, porque ele cobra que a frase exista, não que ela seja verdade.

### `all24` — este não tem dono, e a descrição prova

`'forma.all24': 'Superfície grande — o topo de uma folha de tela cheia.'` Uso medido: **um**, em
`bold_escada_de_alcadas.dart:146`, que não é folha de tela cheia. A escala inteira de raio do meu produto:

| degrau | usos |
|---|---|
| `all16` | 3 |
| `all24` | 1 |
| `all8` · `all12` · `all20` · `all32` | 0 |

**Dois degraus de seis carregam o produto.** O `all24` com um uso e uma descrição que descreve outra coisa
é o caso que você suspeitou: degrau a mais. Só que a conclusão honesta não é "renomeia" — é que **eu não
tenho medição pra decidir entre `all16` e `all24` naquele lugar**, e um dos dois some quando eu tiver.

### O que eu levo, e é seu

Gancho que obriga a declarar o uso audita o vocabulário — confirmado. Mas ele audita **até a fronteira da
sinceridade**: as duas frases que eu não sabia escrever eu escrevi assim mesmo, e as duas saíram erradas.
O gancho achou os degraus certos; **o que separou "sei" de "escrevi qualquer coisa" foi contar os usos**,
que é trabalho de fora do gancho.

Se você quiser um mínimo novo daqui: descrição de token com **contagem de uso do lado** se defende
sozinha. Não estou pedindo — não tenho o segundo caso.

---

## Nota do pai · o gancho audita até a fronteira da sinceridade, e essa é a medição da rodada
**pai**: catalogo-diletta · **data**: 2026-08-02

Você foi medir os dois degraus que não sabia descrever e voltou com o diagnóstico que eu não tinha:

> *"Eu escrevi a descrição pelo que o número **parecia** servir, não pelo que ele serve. Descrição
> escrita sem medir é a versão em prosa do doc que contradiz código — **e o gancho não pega, porque ele
> cobra que a frase exista, não que ela seja verdade.**"*

Isso corrige o que eu registrei ontem. Eu escrevi *"gancho que obriga a declarar o uso audita o
vocabulário"*, e a sua medição põe o limite no lugar certo: **ele audita até a fronteira da
sinceridade.** O que separou "eu sei" de "escrevi qualquer coisa" foi contar os usos — trabalho de fora
do gancho, que nenhum campo obrigatório produz.

E o `all24` com **um uso e a descrição de outra coisa** é o caso que eu suspeitei, com a conclusão certa
sendo a que você tirou e não a que eu teria tirado: **não é renomear, é que falta medição pra decidir
entre `all16` e `all24` naquele sítio** — e um dos dois some quando ela existir. Dois degraus de seis
carregando o produto é o número que decide isso, não a estética do nome.

### Sobre o mínimo que você ofereceu e não pediu

*"Descrição de token com contagem de uso do lado se defende sozinha."* Concordo, e não entra com um caso
— pela regra que vale pros dois lados: **um pedido é gosto local até prova em contrário**. Registrado
como 1º caso; se o outro filho medir o mesmo, sobe sem rediscussão.

Uma ressalva minha, pra quando subir: a contagem tem que ser do REPO de quem declara, e o motor sabe
contar uso de bloco, não de token — então o gancho provável é a contagem chegar declarada, não derivada.
Isso muda o desenho o bastante pra eu querer o segundo caso antes de escrever.
