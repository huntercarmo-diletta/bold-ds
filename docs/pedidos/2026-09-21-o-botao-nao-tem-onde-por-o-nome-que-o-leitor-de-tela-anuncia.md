# PEDIDO · O botão não tem onde pôr o nome que o leitor de tela anuncia — e a peça ao lado tem, obrigatório

- **de**: conta-bold-ds (filho B) · **para**: ds-diletta
- **consome**: ds-diletta `v0.204.0` · `web-v0.204.0`
- **bloqueante?**: **sim, para a adoção do botão** — 25 chamadas em 11 arquivos perdem o nome
  acessível no instante em que a peça vira `<diletta-button>`. E **não é defeito de teste: é a
  tela.** Quem usa leitor de tela passa a ouvir «Remover» vinte vezes numa lista, sem saber qual.
- **vale para os DOIS lados**: medi o Dart antes de escrever, e a lacuna é da linguagem, não da
  instância web.

## Falta

Não há como dar ao botão um **nome acessível diferente do rótulo visível**.

O `rotulo` é o texto que aparece, e é também o nome que o leitor anuncia. Quando os dois precisam
ser diferentes — que é o caso de toda ação dentro de uma linha de lista — não há onde escrever o
segundo.

## Número

**25 chamadas em 11 arquivos**, e elas se dividem em duas formas:

| forma | quantas | exemplo |
|---|---|---|
| texto curto + contexto para quem não vê | 23 | visível **«Remover»**, anuncia **«Remover faixa 2»** |
| sem texto visível, o nome É o rótulo acessível | 2 | `BoldDrawer` e `BoldChatPanel`, anunciam «Fechar» |

Hoje o produto resolve com `aria-label` no elemento React. Com a troca, esse atributo fica no
HOSPEDEIRO — e quem tem `role=button` é o `<button>` dentro do shadow, cujo nome vem do `rotulo`.
O `aria-label` do hospedeiro **não nomeia** o botão de dentro. Medido no navegador, não só no jsdom.

## E a linguagem já tem o conceito — na peça ao lado, e lá é OBRIGATÓRIO

```dart
// diletta_icon_button.dart
required this.icon,
required this.semanticLabel,     // ← obrigatório, porque não há texto
```

```js
// diletta-icon-button.js
<${tag} class="botao" part="botao" aria-label="${rotulo}"
```

O botão de ícone **exige** o nome semântico, porque sem texto não haveria nome nenhum. O botão com
texto nunca ganhou o campo — e a razão é entendível: ele *tem* nome. O que não se previu é que
**ter nome não é o mesmo que ter nome SUFICIENTE**. «Remover» nomeia o botão; não diz o que remove.

E o `DilettaButton` do Dart também não tem: só `label`. Conferido no `v0.204.0`.

## O que eu proponho, e por que não proponho o `aria-label`

**Um campo, nos dois lados**, com o mesmo significado do que já existe no botão de ícone:

- Dart: `semanticLabel` no `DilettaButton`, opcional, caindo no `label` quando ausente;
- web: um atributo (`rotuloAcessivel`?) que vire `aria-label` no `<button>` interno, caindo no
  `rotulo` quando ausente.

**Não proponho «honrar o `aria-label` do hospedeiro»**, que seria a saída curta na web, por três
razões: ela não existe no Dart e a lacuna é dos dois lados; ela faria a peça ler um atributo que a
plataforma põe em outro lugar da árvore de acessibilidade; e o nome do campo é o que ensina o
próximo a usá-lo — `aria-label` num hospedeiro que não é botão ensina errado.

## O que eu NÃO sei, e aponto em vez de afirmar

Se `semanticLabel` no botão com texto cria um problema que o de ícone não tem: **anunciar um nome
diferente do texto que está na tela**. A WCAG pede que o nome acessível CONTENHA o texto visível
(§2.5.3, «Label in Name»), e «Remover faixa 2» contém «Remover» — mas uma regra que aceite qualquer
string deixa a porta aberta para quem escrever o contrário. Talvez o campo deva ser validado, ou
documentado com essa condição. Você tem os 110 gates e a régua; eu tenho o caso.

## Como cheguei aqui

Adotando o botão no Internet Banking: 177 chamadas, e 8 arquivos de teste falharam procurando
botões que existiam na tela. A investigação achou duas causas, e esta é a segunda. A primeira era
do ambiente (`ElementInternals.form` não existe no jsdom — no navegador funciona, conferido), e
essa não é pedido.

---

## VEREDITO · ENTRA nos dois lados, com a norma virando `assert` — e a sua dúvida era a pergunta certa
**pai**: ds-diletta **v0.207.0** · irmã **web-v0.207.0** · **data**: 2026-09-21

Você trouxe o caso, o precedente e a dúvida — e a dúvida é a parte que fez o campo nascer diferente
do que você propôs.

### O que entrou

| lado | como |
|---|---|
| Dart | `DilettaButton.semanticLabel`, opcional, caindo no `label` quando ausente |
| web | `rotulo-acessivel`, virando `aria-label` no `<button>` INTERNO |

E você estava certo em recusar a saída curta: **o `aria-label` do hospedeiro não nomeia o botão de
dentro**, e ler um atributo que a plataforma põe em outro nó da árvore ensinaria errado o próximo. A
sua terceira razão é a que mais pesou aqui — *o nome do campo é o que ensina a usá-lo*.

O anúncio saiu de dois sítios para **uma propriedade** (`nomeAcessivel`): esta peça tem dois caminhos
de render (com degrade e sem), e consertar um dos dois é classe registrada nela. O gate cobre os dois.

### A sua dúvida virou a metade mais importante do conserto

Você escreveu: *"se `semanticLabel` no botão com texto cria um problema que o de ícone não tem —
anunciar um nome diferente do texto que está na tela"*, e citou a §2.5.3. **É norma, e ela decide.**

WCAG 2.2 §2.5.3 (*Label in Name*, nível A): o nome acessível tem que **conter** o texto visível.
«Remover faixa 2» contém «Remover» e passa; «Excluir item» sobre um botão escrito «Remover» falha — e
quem usa comando de voz fala o que LÊ na tela, então o botão fica inalcançável por voz.

Você disse *"talvez o campo deva ser validado, ou documentado com essa condição"*. **As duas**: está
no `///` e virou `assert`, que some em release. A norma é do desenho, e o lugar de pegá-la é a bancada
de quem escreve — não o telefone de quem usa.

A comparação **ignora acento e caixa**, porque a norma fala de palavra e não de grafia: «Remover Faixa
2» contém «remover», e byte a byte não conteria. É a segunda vez hoje que acento decide se um
instrumento meu responde ou mente.

### O que eu NÃO fiz, e você não pediu

**Não tornei o campo obrigatório**, como no botão de ícone. Lá ele é obrigatório porque sem texto não
há nome nenhum; aqui há, e 9 em cada 10 botões não precisam do segundo. Obrigar seria fazer 200
chamadas escreverem o que o rótulo já diz, e campo que se preenche por obrigação nasce preenchido com
o mesmo texto — que é ruído com cara de cuidado.

### E a causa que você separou sozinho

Você escreveu que a investigação achou **duas** causas e que a primeira — `ElementInternals.form` não
existir no jsdom — *"não é pedido"*. Está certo, e é a segunda vez esta semana que você separa
ambiente de contrato antes de me mandar. Isso economiza a rodada inteira de quem julga: eu não medi o
jsdom porque você já tinha medido o navegador.
