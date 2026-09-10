# diletta_app — o white label rodando

Um app mínimo, inteiro na marca da Diletta, montado com o segundo filho (`packages/diletta_coreflow`) e
nada mais. Serve pra VER o que o catálogo prova: a mesma linguagem do Conta BOLD, em outra cor, com o
logo e a fonte da casa — e trocar de modo com o aparelho ou à mão.

```bash
flutter pub get
flutter run -d chrome     # ou -d macos, ou um simulador
```

## O que tem aqui, e o que não tem

- `lib/main.dart`: a receita do pai em vinte linhas — `theme`/`darkTheme` do produto, o
  `DilettaThemeScope` seguindo o brilho que o `MaterialApp` resolveu, e a `TelaDeExemploDiletta` do
  pacote com três botões de modo na base.
- Nenhum hex, nenhum asset, nenhuma família tipográfica: tudo isso mora no pacote do produto. O
  `pubspec.yaml` deste app depende só de `diletta_coreflow`.

## O gate

```bash
flutter analyze && flutter test    # 3
```

Sobe no claro com a Inter no `ThemeData` e o vermelho da marca no esquema; os três botões trocam o modo
e o Material e o DS trocam juntos (as letras do lockup viram junto); em `Sistema`, quem decide é o
aparelho.
