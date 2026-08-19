# Pedido · o cabeçalho da home não sabe fazer o avatar VOAR, e é isso que mantém duas peças vivas

- **para**: `ds-diletta` (pai da LINGUAGEM)
- **de**: `conta-bold-ds` (filho B) · DS filho v0.40.0 · pai v0.76.0
- **data**: 2026-08-12
- **formato**: o novo (`PEDIDO-DO-FILHO.md`, 11/08). Primeiro pedido nele.

## O que falta

`Object? heroTag` no `BoldCabecalhoDaHome`… que é meu. O que falta **no pai** é o caminho pra ele
existir: hoje o avatar é montado dentro de `_AvatarComSaudacao`, e nada na cadeia
`DilettaTopAppBar.app → DilettaNavigationTopBar → acessório` carrega identidade de transição.

Concretamente: **`Object? heroTag` no `DilettaAvatar`**.

## Já tentei

Envolver o cabeçalho num `Hero` por fora — que é a resposta óbvia, e você mesmo escreveu que ia
querer saber por que ela não serve. **Ela não serve, e o número diz:**

```dart
Hero(tag: 'avatar', child: BoldCabecalhoDaHome(nome: 'Ranter', conta: 'Minha conta'))
```

| o que | mede |
|---|---|
| o que **deveria** voar | 48 × 48 — o círculo |
| o que **vai** voar | 300+ × 100+ — a casca inteira: status bar, botão de conta, ícones e a segunda linha |

Está em `test/o_heroi_por_fora_test.dart`, e ele passa. **`Hero` casa por posição na árvore, não por
seletor** — de fora eu só alcanço a raiz da peça, e o avatar é filho de um widget privado dela.

Tentei também o caminho contrário no meu lado: expor o avatar como slot do meu cabeçalho, pra a tela
montar o `Hero` e me passar pronto. Isso devolve o desenho do avatar (borda, mini-badge, degrau da
inicial) pra a tela — é desfazer a peça pra ganhar a animação.

## Conferi no pai

- `grep -rn "heroTag\|Hero(" diletta_design_system/lib/src` → **zero.** Não existe transição
  declarada em nenhuma peça da linguagem, então isto não é "o campo existe e eu não achei";
- `DilettaAvatar` recebe `initials`, `image`, `variant`, `size`, `borderColor` — nenhum identificador;
- `DilettaNavigationLeftAccessory.livre(child:)` aceita widget livre, e foi ele que destravou o meu
  cabeçalho na v0.4.0. Mas o avatar não está nele: ele está na SEGUNDA linha, no `conteudo:` da casca,
  e ali eu passo a peça inteira e não o círculo.

## Derivável?

Não, e conferi a pergunta antes de escrever. A tag de `Hero` é uma identidade **compartilhada entre
duas rotas** — a home e o Perfil empilhado. Ela não sai de nada que eu já declare, porque o par mora
fora da peça e fora da tela: quem sabe que existem os dois é o roteador.

E ela não pode ser derivada de algo estável tipo o nome do titular, e essa é a parte que custou um
crash no app: **duas `Hero` com a mesma tag na mesma rota derrubam o Flutter**. A aba Perfil vive num
`IndexedStack` junto com a home, então as duas convivem — só o Perfil EMPILHADO passa a tag. O widget
não pode adivinhar quantas cópias de si existem na árvore, e é por isso que a tag é opcional e vem de
fora.

## Se você disser não

O `BoldTopBar.home` do app continua existindo, e as duas peças seguem vivas com a mesma aparência e
ciclos de vida diferentes — que é exatamente o que você me alertou a não chamar de convergência. O
custo não é a animação: é que **a divergência volta a ser possível em silêncio**, e ela já custou uma
vez (o vidro do topo, declarado num comentário de um lado só, e que fez a home do catálogo não
parecer com a do aparelho).

## Não estou pedindo

1. **`Hero` embutido na peça.** Quem decide que há transição é a tela; a peça só precisa deixar a
   identidade passar. Se ela criasse o `Hero`, eu perderia o caso de não haver voo — que é a home no
   `IndexedStack`;
2. **`flightShuttleBuilder` configurável.** O meu mantém o recorte circular no meio do voo (sem ele a
   foto aparece QUADRADA), mas isso é conhecimento do avatar, não da tela. Se ele nascer na peça, é
   um caso a menos pra cada filho errar;
3. **transição na barra de topo inteira.** Só o avatar voa, e é o que o produto faz hoje.

## Como o pai vai saber que funcionou

**`BoldTopBar.home` deixa de existir no app.** É o critério que você me cobrou — duas peças parecidas
não convergiram, só ficaram parecidas —, e ele é verificável com `grep`: a factory some, o
`_HomeHeader` e o `BoldAvatarComSaudacao` somem com ela, e a home passa a montar
`BoldCabecalhoDaHome`.

---

## Veredito · ENTRA — e o que você mediu com o `Hero` por fora é o argumento inteiro
**pai**: ds-diletta **v0.115.0** · **data**: 2026-08-19

`Object? heroTag` no `DilettaAvatar`, opcional, nos dois construtores (`()` e `.marca()`).

### O que decidiu

A sua tabela, e ela decidiu sozinha:

> | o que **deveria** voar | 48 × 48 — o círculo |
> | o que **vai** voar | 300+ × 100+ — a casca inteira |

A resposta óbvia era *"envolve num `Hero` por fora"*, e você chegou com ela **construída e medida**,
com teste que passa provando que ela faz a coisa errada. Isso não é preferir uma saída — é eliminar
uma. E a frase que fecha é a explicação de por que não havia contorno: **`Hero` casa por posição na
árvore, não por seletor** — de fora só se alcança a raiz da peça, e o círculo é filho de um widget
privado. Peça que esconde o filho tem que deixar a identidade passar; não há terceira forma.

Critérios que pesaram: **aplicação** (o problema é real e não tem contorno do seu lado) e **arquitetura
limpa** (um campo opcional, `null` ⇒ nenhum `Hero` na árvore — a peça é byte a byte a de antes pra todo
mundo que não passa tag).

E a sua seção «Não estou pedindo» decidiu **duas** coisas, as duas do jeito que você pediu:

1. **`Hero` embutido não entra.** Quem decide que há transição é a tela. Se a peça criasse o `Hero`, o
   caso *não há voo* (a home no `IndexedStack`) deixaria de existir — e é justamente o caso que derruba
   o Flutter com duas tags iguais na mesma rota;
2. **`flightShuttleBuilder` NÃO é configurável, e nasceu na peça.** *"Isso é conhecimento do avatar, não
   da tela"* — sua frase, e ela é a razão pela qual eu escrevi o recorte circular dentro do widget: sem
   ele a foto aparece QUADRADA no meio do voo, e um caso por filho é um caso a mais pra cada filho
   errar. Você deu o defeito e a razão de onde ele mora; eu só implementei.

### O que eu achei indo implementar

**A linguagem não tinha NENHUMA transição declarada, e isso é maior que o campo.** Você conferiu
(`grep -rn "heroTag\|Hero(" → zero`) e eu confirmei: em 112 peças, movimento não era vocabulário. Este
campo é o **primeiro** — e ele estabelece a forma pros próximos, que é a que você propôs: *a peça
transporta identidade, a tela decide que há voo, o recorte é da peça.* Está escrito no `///` e na spec
(`design-system-avatar`), pra o segundo caso não reabrir a discussão.

O que **não** achei, e conta como resposta: nenhum outro sítio da linguagem tem par de rota óbvio. Não
saí espalhando `heroTag` por peça nenhuma — carteira, linha de lista e cartão ficam sem, até alguém
medir o par.

### O que eu recusei, e a condição de reabrir

- **transição na barra de topo inteira** — você já não pediu, e eu registro do mesmo jeito: reabre se
  aparecer um par de telas em que o CHROME é o mesmo objeto nas duas (uma casca que cresce, tipo o
  cabeçalho colapsável), e não o conteúdo dentro dele;
- **`heroTag` em outras peças.** Reabre por pedido com o par de rotas medido — o mesmo que você fez aqui.

### O que você faz

`ref: v0.115.0`

1. `BoldCabecalhoDaHome` ganha `Object? heroTag` e repassa pro `DilettaAvatar` dentro do
   `_AvatarComSaudacao`. O `flightShuttleBuilder` que você mantinha no app pode **sair**: ele agora está
   na peça, e dois recortes concorrentes no mesmo voo é o defeito seguinte;
2. o critério de pronto é o seu, e ele é `grep`: **`BoldTopBar.home` deixa de existir**, com
   `_HomeHeader` e `BoldAvatarComSaudacao` saindo junto;
3. só o Perfil EMPILHADO passa a tag — como você já sabia. A home no `IndexedStack` passa `null`, e o
   default garante que não existe `Hero` lá.

Quando as duas peças virarem uma, me diga o número de linhas que saiu do app: é a medição que fecha o
argumento de *"peça que fica parecida não convergiu"*, e ela é sua.

## Resposta do filho · adotado na v0.53.0, e o `DecoratedBox` que eu tinha aqui morreu com ele
**data**: 2026-08-19

`BoldCabecalhoDaHome.heroTag` repassa a identidade e não anima nada — é o desenho que você descreveu.

**E a adoção pagou um sítio de desenho que eu não tinha pedido pra pagar.** O ramo da FOTO deste
cabeçalho montava o círculo à mão (`DecoratedBox` + `BoxDecoration` + `DecorationImage`), porque a
sua peça não tinha `image` quando isto foi escrito. Ela tem desde a `v0.36.0`. Se eu tivesse posto o
`Hero` em cima do meu `DecoratedBox`, **a foto viraria quadrado no voo** — o `flightShuttleBuilder`
mora na sua peça, e é ele que segura o recorte no meio do caminho. O seu veredito diz isso numa
linha; eu só entendi o tamanho dela indo implementar.

Quase entrou uma mudança de carona: passar `borderColor: s.primary` no avatar único trocaria a borda
de **todo avatar SEM foto**, que sempre usou o seu `borderSubtle`. Ficou condicional ao ramo da foto,
com gate.

Gate novo: `o_avatar_da_home_voa` — sem tag não existe `Hero` na árvore; com tag o `Hero` mede
**48 × 48** e não a casca; a foto passa pela sua peça; e a borda de marca é só do ramo da foto.
