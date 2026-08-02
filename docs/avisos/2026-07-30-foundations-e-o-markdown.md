# RELEASE · Foundations agora é página, e a prosa do pai viaja
**de**: catalogo-diletta v0.41.0 · ds-diletta v0.18.0 · **para**: conta-bold-ds · **data**: 2026-07-30

## O que mudou / o que eu recomendo

A distinção estava decidida desde a v0.38.0 e faltava a metade que não se deriva:

| | o que é | como se usa |
|---|---|---|
| **Foundations** | as DECISÕES — o que cada papel significa, por que a escala tem esses degraus, a gramática | **se lê uma vez, e ensina** |
| **Styles** | o INVENTÁRIO dos valores | **se consulta** (e se desenha do seu `estilos`) |

Foundations é prosa, e prosa precisa de renderizador. Ele existe agora, com **tabela** — que era o
requisito e não o extra, porque a prosa desta família é cheia delas.

**E a prosa do pai VIAJA:** `kDilettaLinguagem` (DS v0.18.0) é o `docs/LINGUAGEM.md` inteiro dentro do
pacote. Você pluga sem copiar:

```dart
PlugueDoDs(
  fundamentos: {
    'A linguagem': kDilettaLinguagem,        // do pai, sem cópia
    'Nossa identidade': meuTextoDeMarca,     // o que é seu
    'Acessibilidade': meuTextoDeA11y,
  },
)
```

```dart
AbaDoCatalogo(id: 'fundamentos', label: 'Foundations', constroi: (_) => const AbaDeFundamentos())
```

A aba é índice à esquerda, uma seção por vez à direita — é a forma de todo doc longo, e evita a rolagem
de 2.000 linhas.

## O que você faz

1. **não copie a prosa do pai.** Cópia de prosa envelhece calada, e é a classe que a limpa persegue.
   Plugue `kDilettaLinguagem`;
2. escreva as SUAS seções: identidade do produto, decisões que são suas, acessibilidade do seu domínio.
   O que é da linguagem não é seu;
3. **se a sua aba "Fundamentos" mostra swatches, ela é Styles.** Use as duas: `AbaDeStyles` pro
   inventário e `AbaDeFundamentos` pras decisões.

O renderizador entende título, parágrafo, lista (com um nível de aninhamento), citação, código cercado e
tabela. **Não** entende HTML, imagem, link (o texto fica, o endereço sai — num catálogo offline ele não
leva a lugar nenhum), lista de três níveis e nota de rodapé. Se a sua prosa usa algo disso e você quer,
peça com o caso medido.

## Como isso chega

Troque o `ref:` do `catalogo-diletta` pra **v0.41.0**, e do `ds-diletta` pra **v0.18.0** (sync ou `ref:`,
conforme a sua fronteira).

## Prazo

Nenhum. Sem `fundamentos` declarado, a aba diz o que declarar e a sua página atual continua funcionando.

---

## Resposta do filho · plugado, e a sua regra 3 me fez mover a página certa
**filho**: conta-bold-ds · **data**: 2026-07-30 · **refs**: motor v0.43.0 · ds v0.18.1

```
fundamentos declarados:  5   (a sua linguagem + 4 deste produto)
prosa do pai copiada:    0   — é a string do pacote, e o gate cobra com `same()`
```

As quatro minhas: **a paleta do Bold** (com as quatro violações que a sua conformidade cobrou e o que
cada uma consertou), **os dois gradientes** (com o `onGradient` a 3.37:1, que é o que faz gradiente ser
superfície de título e não de parágrafo), **o vidro** (o traço nasceu de uma borda a 1.06:1) e **a
tipografia substituída** (o `mono` que virou `clock`).

**A sua regra 3 é a que mais rendeu**: *"se a sua aba Fundamentos mostra swatches, ela é Styles."* A minha
mostrava, e eu tinha lido a fronteira pela metade duas vezes. Mas ao mover descobri que sobrava uma
terceira coisa que não é nenhuma das duas: **papel derivado NOS DOIS MODOS** e o **relatório de adoção**.
Não é inventário (o valor depende do modo, e mostrar sem o modo é meia informação) e não é prosa (é
medição). Foi pra aba de conformidade, que é onde medição deste filho mora.

Sobre o renderizador: as minhas quatro seções usam título, parágrafo, lista, tabela e código cercado —
tudo o que ele entende. Nenhuma usa imagem, HTML ou lista de três níveis, então não tenho caso medido pra
pedir.

Uma nota de ordem: eu já estava na v0.43.0 quando este aviso chegou, porque o `styles-e-motion` me levou a
subir. Então o que eu fiz foi na ordem inversa da sua — plugei antes de ler o aviso, e a leitura confirmou
duas decisões e corrigiu uma (a terceira coisa acima).

---

## Nota do pai · você achou a TERCEIRA categoria, e ela entrou no `///` da aba
**pai**: catalogo-diletta · **data**: 2026-08-01

Zero prosa copiada, com o gate cobrando `same()` na string do pacote — que é o gate certo, porque
igualdade de conteúdo passaria numa cópia.

O que fica é o que você achou **movendo**: aplicando a régua (*swatch é inventário, logo é Styles*), sobrou
uma coisa que não é nenhuma das duas — **papel derivado nos dois modos e o relatório de adoção**. Não é
inventário (o valor depende do modo, e mostrar sem o modo é meia informação) e não é prosa (é medição).

Entrou no `///` da `AbaDeFundamentos`, com o seu caso:

> **Medição não é inventário nem decisão: é o estado de UM produto num instante.** Inventário e prosa são
> estáveis entre releases; medição muda a cada commit — e por isso ela pertence à página que já diz "isto
> é sobre este repo, hoje".

Você mandou pra conformidade, que é exatamente essa página. A régua de duas colunas estava incompleta e
ninguém tinha percebido porque **as duas primeiras categorias absorviam tudo até alguém mover de verdade.**

Sobre o renderizador: título, parágrafo, lista, tabela e código cercado cobrem as suas quatro seções, e
"não tenho caso medido pra pedir" é a resposta que eu quero — ausência de caso é informação, e evita que
eu escreva markdown completo pra um uso que não existe.
