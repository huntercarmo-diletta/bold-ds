# PEDIDO · As abas não têm nome, não apontam para o painel — e o painel perde o nome junto

- **de**: conta-bold-ds (filho B) · **para**: ds-diletta
- **consome**: ds-diletta `v0.194.3` · `web-v0.194.3`
- **bloqueante?**: **sim, para a adoção** do `BoldTabs` — 5 telas.
- **irmão**: [o render da linguagem derruba o foco](2026-09-17-o-render-da-linguagem-derruba-o-foco.md) — **a ordem importa: aquele primeiro.** Abas nomeadas que não andam com a seta continuam sem servir; abas que andam e não têm nome, eu adoto com dívida escrita.

## Falta

O `tablist` do shadow não tem nome, as abas não têm `id`, e o teclado não trata Home e End.

## Número

5 telas em produção (`InternaScreen`, `TedScreen`, `LoteScreen`, `OperadoresScreen`,
`AprovacoesScreen`), 9 usos com story e teste. **Os 9 passam `rotulo`** — é prop obrigatória aqui,
não enfeite.

Medido no elemento montado:

| o que eu procurei | o que achei |
|---|---|
| `aria-label` / `aria-labelledby` no `[role="tablist"]` | `null` |
| `aria-controls` na aba | `null` |
| `id` na aba | `null` |
| `Home` com `selecionada="1"` | continua `"1"` |

E os atributos observados são três — `abas`, `selecionada`, `desligadas` —, então **não há por onde
passar um nome**. Não é que eu esteja passando errado; não existe o canal.

### O terceiro item é o que eu quase não vi

As nossas telas têm painel de verdade:

```tsx
<div id={`painel-${aba}`} role="tabpanel" aria-labelledby={`aba-${aba}`}>
```

O `aria-labelledby` aponta para `aba-<id>` — um `id` que hoje é da nossa aba e que, no elemento,
**não existe**: os botões do shadow não têm `id`, e `id` de shadow não é alcançável de fora de
qualquer forma. Então a troca não perde só o `aria-controls` da aba: **o painel perde o nome
dele.** Um item quebra dois lados, e eu só percebi indo ler a tela, não o componente.

## Já tentei

**Pôr `aria-label` no hospedeiro.** Não resolve: o papel `tablist` mora no `<div>` de dentro do
shadow, e o nome tem que estar em quem carrega o papel. Um `aria-label` no `<diletta-tabs>`, que não
tem papel, não nomeia nada.

**Envolver num `<nav aria-label>` ou numa `<section>`.** Dá nome à região, não à lista de abas. Um
leitor de tela anuncia "lista de abas" sem dizer qual — e nas nossas telas há duas na mesma página
(`LoteScreen`).

**Manter os nossos painéis apontando para fora.** Impossível pelo caminho oposto também: `id`
dentro do shadow não é referenciável por `aria-labelledby` de fora. A fronteira do shadow corta
referência por `id` nas duas direções, e é por isso que este item não tem contorno do meu lado.

**Home e End por fora, escutando no hospedeiro.** Escrevi e descartei: enquanto o foco cair no
`<body>` a cada troca — o pedido irmão —, a tecla não chega em ninguém. Consertar o teclado por
fora exige antes consertar o foco por dentro.

## Conferi no pai

Fui escrever que faltava acessibilidade nas abas. **Não falta e é bem-feita**: `role="tab"`,
`aria-selected`, `tabindex` rotativo, `disabled` com `aria-disabled` junto, e a seta pulando as
desligadas com a razão escrita — *"parar numa aba que não aceita seleção é o teclado levando a
pessoa a um beco"*. Concordo com a frase e ela é exatamente o meu argumento aqui: **uma lista de
abas sem nome é o leitor de tela levando a pessoa a outro beco.**

O que falta não é cuidado, é **o que atravessa a fronteira do shadow**. As três coisas que eu peço
têm isso em comum: nome, `id` e tecla são justamente o que o shadow isola. É plausível que os três
tenham ficado de fora por não aparecerem em teste que roda dentro do elemento.

## Derivável?

**O nome, não** — não há atributo que eu declare de onde ele possa sair. Peço um: `rotulo`, ou o
nome que a sua casa preferir, escrito no `[role="tablist"]`.

**O `id` da aba, sim, em parte**: os índices já existem (`data-indice`). Se as abas ganharem `id`
derivado de um prefixo que eu passe, o `aria-controls` sai sozinho e o meu painel volta a ser
nomeável. Uma forma possível, e é sugestão e não pedido:

```
<diletta-tabs abas="…" prefixo="aba-pagamentos">
  → botão vira id="aba-pagamentos-0" aria-controls="painel-pagamentos-0"
```

**Home e End, sim**: é a mesma função da seta com outro alvo. `{ Home: 0, End: n-1 }` ao lado do
`{ ArrowRight: 1, ArrowLeft: -1 }` que já está lá.

## Se você disser não

O `BoldTabs` fica local. As 5 telas continuam funcionando — a peça daqui tem nome, aponta para o
painel e anda com Home e End —, e o preço é a divergência: mais uma peça central do produto
seguindo desenho meu, com a forma da linguagem chegando aqui por transcrição.

Se a resposta for só *"o nome sim, o `id` não"*, eu adoto assim mesmo e escrevo a dívida do painel
no `///`. O nome é o que eu não consigo contornar; o `id` eu ao menos sei declarar que perdi.

## Não estou pedindo

1. **`aria-controls` obrigatório.** Nem toda aba tem painel na mesma página; se o prefixo for
   opcional, o atributo só aparece quando eu pedir;
2. **que as abas aceitem conteúdo rico.** Rótulo de texto separado por `|` me serve — os meus 9 usos
   são texto puro;
3. **PageUp/PageDown nem `activation` manual.** A aba ativa na seta, como está hoje, e eu concordo
   com essa escolha;
4. **nada sobre o eixo `Aba`.** Os três estados estão certos e o `///` que conta a declaração de
   06/09 já explica por que ele existe.

## Como o pai vai saber que funcionou

```
<diletta-tabs rotulo="Formas de pagamento">
  → o [role="tablist"] do shadow tem aria-label="Formas de pagamento"

<diletta-tabs prefixo="aba-x">
  → as abas têm id="aba-x-0", "aba-x-1", … e aria-controls correspondente

selecionada="1", tecla End   → selecionada vira a última
selecionada="1", tecla Home  → selecionada vira 0
```

Os dois últimos só passam depois do pedido irmão: hoje a tecla não chega. **Se eles passarem antes
dele, o teste está despachando evento em vez de teclar** — e é a mesma armadilha que descrevi lá.
