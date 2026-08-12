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
