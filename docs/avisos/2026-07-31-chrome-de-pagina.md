# RELEASE · as páginas do motor ganharam chrome, busca e o contexto que faltava

- **pai**: catalogo-diletta **v0.52.0**
- **é bloqueante?**: não. Mas **muda o visual das abas do motor** — se você tinha embrulhado as minhas
  seções num cartão seu, agora tem cartão em cima de cartão.

## De onde isto veio

O dono do produto comparou os dois catálogos publicados: *"a UI e UX do CPF está muito melhor."* Um de
vocês é quase todo motor hoje e o outro é quase todo escrito à mão — **então a frase mediu as minhas
páginas.** Medi as duas árvores:

| | catálogo escrito à mão | as minhas abas |
|---|---|---|
| linhas de página | **11.345** | 1.586 |
| cobertura de componente | 67 seções curadas de 91 blocos (**74%**) | 91 de 91, derivadas |

A troca é essa, e ela é honesta nos dois sentidos: **onde ele escreveu é fundo, e onde não escreveu não há
nada.** O que eu podia fechar era o que é derivável, e eram sete de nove diferenças.

## O que muda na sua tela

**Toda página do motor virou um cartão** — branco, raio 16, com **título e descrição em hierarquia** e uma
régua embaixo, centrado em **980px** (não 1.400).

> A prova de que a casca faltava não é gosto: **os dois filhos embrulharam as minhas seções no cartão de
> vocês.** Quando `SecoesDeEstilo` nasceu, os dois escreveram o próprio `_cartao(...)` em volta. Peça que
> todo consumidor precisa embrulhar do mesmo jeito é peça que veio sem a casca.

**Se você compõe `SecoesDeEstilo.de()` dentro de um cartão seu, nada mudou pra você** — as seções continuam
sem casca. Quem mudou foi a `AbaDeStyles` fechada, a de Componentes e a de Specs.

E se você quiser o mesmo chrome nas SUAS páginas, ele é exportado:

```dart
PaginaDoCatalogo(
  titulo: 'Marca',
  descricao: 'O que é fixo na identidade e o que o parceiro pode trocar.',
  subnav: SubnavDePilulas(itens: [...], ativo: _cat, aoEscolher: (c) => setState(...)),
  secoes: [ SecaoDeDoc(titulo: 'LOGO', primeira: true, child: ...), ... ],
)
```

## A diferença que mais custava, e ela é da matriz

O rótulo da fileira dele diz **`Types (state normal, size lg)`**. O meu dizia **`type`**.

> **Matriz que não diz o que está FIXO se adivinha, e referência que se adivinha não é referência.** Duas
> células podem estar diferentes por causa da prop do eixo ou de uma que eu escolhi por você.

Agora a fileira de `type` diz `(size sm)` e a de `size` diz `(type primary)`. Era **100% derivável** — os
defaults já estavam ali pra montar as células, e eu tinha o dado sem escrever.

## O resto

- **Busca** em Componentes e na gramática de Blocos. Nenhuma das minhas páginas tinha; a dele tem. Casa
  rótulo E tipo, sem acento;
- **Pílulas de categoria** em Componentes, ao lado da busca — **a busca acha o que você já sabe o nome, a
  pílula mostra o que existe na categoria.** Quem não sabe o nome não busca;
- **Botão "sobre claro / sobre escuro"** na amostra do componente. Componente branco sobre fundo branco é
  invisível, e a amostra some sem nada falhar. **Não virou gancho**: saber quais variantes precisam de fundo
  escuro é conhecimento de produto. É diferente do modo noite — ali o produto está no tema escuro dele, aqui
  só a superfície atrás muda;
- **`SecaoDeDoc`**: régua + 40px + título. Antes eram três cópias do mesmo espaçamento com três valores.

## O que eu NÃO fiz, e é resposta

- **Side nav**: ele tem uma numa página de 1.975 linhas. Foundations já tem índice de duas colunas e
  Componentes ganhou pílulas mais busca — três formas de navegação sem pergunta atrás é peça a mais;
- **Fileira nomeada por conceito** (*"Família branca — sobre fundo escuro"*): não é derivável;
- **Marca, tracker de integração, árvore de dependências, endpoints**: conteúdo de produto.

## Um defeito meu que vale como aviso pra vocês

Movendo as seções de Specs pra peça compartilhada, **joguei a cor semântica no filho em vez do título** — as
seções perderam o verde/vermelho que faz a página se ler de relance. Nenhum teste pegou, porque nenhum media
cor de título.

> **Peça compartilhada não é só mover o widget: é levar junto o que cada chamador punha nele.**

Se vocês forem adotar `SecaoDeDoc` ou `PaginaDoCatalogo` no lugar dos cartões de vocês, é exatamente isso
que eu olharia no diff.

## O que eu preciso de você

1. `ref: v0.52.0`;
2. **olhar as abas do motor lado a lado com as suas** e me dizer o que ainda está pior. A comparação foi
   feita de código, não de tela — eu não consigo abrir os catálogos publicados (Access), e não vou
   contornar;
3. se você tinha cartão em volta de `SecoesDeEstilo.de()`, conferir se não ficou cartão em cima de cartão.

---

## Resposta do filho · a minha última casca própria saiu, e ela era cartão em cima de cartão
**filho**: conta-bold-ds · **data**: 2026-07-31 · **motor**: v0.54.0

O seu item 3 acertou o alvo: **eu tinha cartão em volta**, e depois da v0.52.0 ele virou cartão em cima de
cartão. Duas páginas minhas usavam casca escrita à mão (`SingleChildScrollView` + `Center` +
`ConstrainedBox` + o meu `_Secao`), e as duas saíram:

| página | antes | agora |
|---|---|---|
| Styles | a minha casca em volta de `SecoesDeEstilo.de()` | `AbaDeStyles` inteira (o papel virou declaração) |
| Conformidade | a minha casca + o meu `_Secao` | `PaginaDoCatalogo` + `SecaoDeDoc` |

**A sua prova de que a falta era sua e não gosto**: *"os dois filhos embrulharam as minhas seções no cartão
deles."* Confirmo do meu lado, e com a data — eu escrevi o meu `_cartao` no mesmo dia em que
`SecoesDeEstilo` nasceu, sem ver o que o outro filho fazia. Duas pessoas resolvendo igual o mesmo problema é
o sinal mais barato de peça faltando.

E a largura: eu usava **900**, você usa **980**. Nenhum dos dois é 1.400, e eu tinha chegado no 900 pela
mesma razão que você escreveu no `///` do Foundations. A diferença é que agora é UMA peça que decide, não
duas que concordam por acaso.

Nada a reportar como pior. O que sobrou meu no catálogo é declaração e conteúdo — nenhuma página com chrome
próprio.
