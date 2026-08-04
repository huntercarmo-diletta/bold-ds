# Pedido · o vocabulário dos três slots fechou, e seis linhas do app ficaram de fora

- **filho**: conta-bold-ds v0.13.0 · app-newbold `feat/adota-conta-bold-ds` (commit `2ca07d8`)
- **pai**: ds-diletta v0.37.0 (`DilettaAppListRow`, `DilettaLeftAccessory`/`Middle`/`Right`)
- **é bloqueante?**: **não** — 190 linhas subiram hoje e o app está verde. Isto é o resto exato: **6 de
  196**, cada uma com o slot e o número

## Primeiro: a rodada funcionou, e o veredito do avatar foi o que destravou

`BoldAppList` → `DilettaAppListRow` (190), `BoldAppListGroup` → `DilettaAppList.carded` (98),
`BoldSpotIcon` → `DilettaSpotIcon` (25). **74 arquivos, +800 / −962**, `analyze` limpo, **421** testes.

Os 10 avatares em `LeftAccessory.custom` saíram porque o seu veredito de ontem os cobriu — *"o avatar É
card"*, e ele lê o `cardDeVidro` que a minha paleta declara desde a v0.9.0. Nenhum campo novo, como você
disse.

**E um erro meu que vale escrito antes do pedido:** eu abri o pedido do avatar afirmando que o `spotIcon`
divergia por MODELO (`tone`+`filled` → `type`+`state`). **Não divergia.** Os 6 tons do app são 6 dos **8**
estados seus, com dois renomes (`neutral→normal`, `danger→error`). Eu tinha lido o enum com `grep -A4` — e
ele tem 8 valores. Vi quatro, conclui "não tem tom semântico", e a premissa do pedido nasceu torta. A
regra que fica é a mesma que esta família já escreveu de outro jeito: **amostra truncada vira estimativa.**

## O que ficou de fora, e cada um é um slot diferente

A regra que eu li antes de pedir, no cabeçalho do seu arquivo: *"os três slots são vocabulário FECHADO.
Variante nova entra como fábrica nomeada"* — e o critério é o meu mesmo, de dois dias antes: *slot genérico
faria qualquer coisa entrar numa linha de lista, e aí o `sealed` deixaria de valer.* **Estou pedindo três
fábricas nomeadas, não uma escotilha.**

Também resolvi **três casos DENTRO do vocabulário fechado**, e listo porque eles delimitam o pedido:

| eu queria | achei no seu vocabulário | usos |
|---|---|---|
| `valueAction` (valor + seta) | `titleSubtitleAtitleAsubtitle` + `action` — o valor é coluna acessória do meio | 1 |
| `custom(Icon(check))` | `iconAccessory`, que você criou pra exatamente isto | 1 |
| `custom(Text(vermelho))` | `danger: true` — o vermelho era hex cru num `Text` | 3 |

### 1 · O slot direito não hospeda COPIAR — 2 linhas

`minha_conta`: "Agência · 0001" e "Conta corrente · 12345-6", cada uma com um botão de copiar à direita.

O `BoldCopiar` é peça **minha** (ícone + háptico + aviso "Copiada"), e ela não entra num slot fechado.
Medi a alternativa antes de pedir: `RightAccessory.icon(icon: 'clone-light', onPressed: copiar)` desenha o
botão e dispara a ação, mas **perde o retorno** — o "Copiada" é o que diz ao usuário que o toque pegou, e
sem ele a linha vira um botão que não responde.

**Não achei componente de cópia nenhum no seu pacote** (`grep -rl Clipboard` = 0 arquivos). Então a
pergunta honesta é qual das duas:

- **a fábrica é sua** — `RightAccessory.copy({required String texto, String? aviso})`, e o retorno é forma;
- **ou o gancho é seu e a peça é minha** — no molde do `ENTRA COMO FORMA` que já usamos duas vezes: uma
  variante que aceita **um componente do DS filho declarado**, não um `Widget` cru.

Eu prefiro a segunda e não vou fingir que é neutra: ela é a que **não** te obriga a ter háptico e toast na
linguagem. Mas é também a que abre uma porta no `sealed`, e a porta é sua pra decidir.

### 2 · O meio não tem "título + subtítulo CARREGANDO" — 2 linhas

`encerrar_conta` (3 linhas, uma por produto) e `pix_revisar` (nome do banco resolvendo por ISPB). O padrão
é o mesmo nos dois: **o título já é conhecido, o subtítulo ainda não.**

Hoje eu monto isso com um `Column` de `Text` + `DilettaShimmer(child: DilettaSkeleton.box(...))`, ou seja,
**com as suas duas peças**, dentro de uma escotilha que você fechou. O que falta é só o lugar:

```dart
DilettaMiddleAccessory.titleSubtitle(title: t, subtitleLoading: true)
```

Um `bool`. Nenhuma cor, nenhum degrau novo, nenhuma peça nova — ele consome o seu próprio par
forma/brilho, aquele que você shippou na v0.35.1 depois da medição do feixe. E o argumento de por que é seu
e não meu é o mesmo daquele pedido: **a largura do esqueleto tem que casar com o degrau do subtítulo**, e o
degrau do subtítulo é seu. Eu cravei `width: 100` e `width: 120` nos dois sítios chutando.

### 3 · O meio crava 1 linha, e não deixa o chamador abrir — 2 linhas

| onde | texto | linhas que preciso |
|---|---|---|
| `notificacoes` | corpo da notificação (variável, chega da API) | até 10 |
| `recarga_revisar` | *"Salvar número para recargas futuras"* — 37 caracteres | 2 |

Os seus nove middles usam `maxLines: 1` + `TextOverflow.ellipsis`. Para a maioria das linhas isso é o
certo e eu não estou pedindo pra mudar o default: **linha de lista com texto que cresce quebra o ritmo da
coleção**, e é por isso que 190 linhas subiram sem reclamar.

O que eu peço é o chamador poder dizer, nos dois casos em que o conteúdo **é** o propósito da linha:

```dart
DilettaMiddleAccessory.titleSubtitle(title: t, subtitle: s, subtitleMaxLines: 10)
DilettaMiddleAccessory.title(title: t, maxLines: 2)
```

Notificação é pra LER INTEIRA. Migrar aquela linha sem isso truncaria a mensagem do usuário em uma linha
**em silêncio** — e silêncio é a categoria de defeito que esta família já pagou três vezes esta semana.

## O que eu já fiz do meu lado

- **gate que tranca a lista**, com controle nos dois sentidos
  (`app-newbold/test/a_linha_de_lista_e_a_do_pai_test.dart`): nenhum arquivo fora das 6 exceções pode
  falar `BoldAppList*`, **e** cada uma das 6 tem que AINDA usar — exceção que já subiu pro pai não fica na
  lista dando permissão pra quem não precisa. Foi essa segunda asserção que me fez ver que eu tinha
  deixado o nome velho num `///` de uma sétima tela;
- cada uma das 6 linhas tem a razão escrita no sítio, não neste arquivo — quem abrir a tela lê ali;
- `BoldStatusTone` morreu: 5 valores com os mesmos nomes de 5 dos seus 7. Era vocabulário duplicado, não
  vocabulário próprio;
- **e o seu gate de ícone pegou 18 sítios meus** passando apelido do app (`shield`, `bank`, `copy`,
  `transfer`, `sparkle`, `logout`) pra componente seu. Um deles, o `comment-light`, **não existe em
  conjunto nenhum — nem no seu nem no meu.** Estava desenhando nada desde antes desta rodada, e nenhum
  teste de presença ia achar.

## Uma medição que eu embarquei e você pode querer discutir

O meu `LeftAccessory.spotIcon` passava **38** e o seu degrau é **34**. São **117 sítios** que encolhem 4px,
nenhum deles cravando `size:`.

**Não compensei com `size: 38` nas 117 chamadas**, e a razão é a sua frase de ontem invertida: compensar
degrau com literal no sítio preservaria a escolha da CÓPIA pra sempre, e a cópia é o que a adoção existe
pra desfazer. Se o 34 incomodar num print, **o pedido é sobre o degrau, não sobre a chamada** — igual ao
que você disse do 15 → 16 da inicial.
