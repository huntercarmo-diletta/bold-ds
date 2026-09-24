# RELEASE · as duas peças que nunca tinham saído saíram — no mesmo dia em que você as listou
**pai**: ds-diletta **v0.205.0** · irmã **web-v0.205.0** · **data**: 2026-09-21 · **para**: você

Os vereditos de hoje diziam «fila da web» para as duas. Mudaram de ideia por um motivo só: elas
estavam na mesma fila, e juntas custam menos que separadas — mesmo gate, mesmo bloco de catálogo,
mesma rodada de medição. Os adendos estão nos arquivos dos pedidos.

**A fila da web caiu de 14 para 12.**

## `<diletta-dialog>`

Sobre o `<dialog>` NATIVO, com o seu argumento inteiro. E a sua ressalva virou desenho **antes de a
peça existir**: `aberto` é o único atributo que não redesenha, porque remontar o shadow com o modal
aberto destruiria o `<dialog>` que o navegador está segurando — e com ele o foco preso e a pilha de
modais.

```html
<diletta-dialog titulo="Revogar o acesso?" mensagem="Isso não volta atrás." aberto>
  <diletta-icon slot="icone" .../>
  <diletta-button slot="acoes" type="primary" state="error" rotulo="Revogar"></diletta-button>
  <diletta-button slot="acoes" type="tertiary" rotulo="Cancelar"></diletta-button>
</diletta-dialog>
```

- **a peça não tem uma linha de JS sobre foco**, e há gate lendo a própria fonte pra garantir que ela
  não passe a imitar. Onde `showModal` não existe — a sua bancada, provavelmente — ela cai no
  atributo `open`: desenha e **não finge a trava**;
- `Esc` e clique no scrim fecham no navegador; a peça reflete no atributo e emite `fechou`. Você não
  sincroniza nada à mão;
- `fecha-no-scrim="nao"` é o `barrierDismissible: false`, e pra confirmação destrutiva é
  provavelmente o que você quer;
- o scrim é `blackAlpha40`, a mesma tinta do `DilettaSheetOverlay` do Dart.

**O que continua seu**: a folha (o `coreflow_folha` mora no seu degrau) e o `exigirMotivo`, pela
razão que você mesmo escreveu.

## `<diletta-dropdown>`

Em volta do `<select>` NATIVO. A API é a que você pediu — as `<option>` na luz —, e a mecânica não
pôde ser slot: **`<option>` slotada não renderiza dentro de um `<select>` que mora no shadow**,
porque o controle só desenha os filhos da árvore dele. A peça ESPELHA a luz para dentro do controle a
cada `slotchange`, e o espelho se refaz inteiro.

```html
<diletta-dropdown label="País" placeholder="Escolha um" valor="br">
  <option value="br">Brasil</option>
  <option value="ar">Argentina</option>
</diletta-dropdown>
```

Veio junto: `moldura` (`caixa` e `silencioso`, os dois valores do eixo do Dart), o anel de foco na
lei de hoje, e `erro` com texto implicando o estado — a mesma regra do campo.

**Não veio a `ajuda`.** Eu tinha posto e tirei antes de publicar: o `DilettaDropdown` do Dart não tem
`helper`, e instância que declara o que a linguagem não declara é o começo de a web virar coisa
diferente. Se você precisar, é pedido com medição e o campo nasce nos dois lados.

## O que você faz

Apague a `WaCampoSelect` e o `WaConfirmDialog` quando puder, e escreva no `///` do que sobrar qual é a
peça da linguagem. As três coisas do seu diálogo que eu marquei como suas continuam suas.

## Uma nota de numeração

Esta saiu como **0.205.0** e não 0.204.0: a 0.204.0 foi publicada por outra mão enquanto eu
trabalhava, e as duas entradas ficam no CHANGELOG. Se você viu a 0.204.0 passar e não a reconheceu,
é isso — ela é de outro trilho, e a resolução foi a soma.
