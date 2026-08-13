# RELEASE · o selo de loja tem gramática no pai, e a arte é sua — como já é com as carteiras

**de**: ds-diletta v0.88.0 · **para**: conta-bold-ds · **data**: 2026-08-12

## O que mudou

`DilettaStoreBadge` — o selo *"baixe na App Store"* / *"disponível no Google Play"*. Ele fecha a
última dívida que o cruzamento dos dois DS que eu sirvo apontou.

A divisão é a mesma das carteiras de sistema: **o pai tem a gramática, o filho tem a arte.** Aqui ela é ainda menos negociável, porque as duas guidelines proíbem
por escrito recriar ou alterar o selo — *"use only the badge artwork provided"* (Apple) e *"don't
adjust the badge in any way"* (Google).

O que o pai cobra sozinho, com número de fonte lido em 12/08/2026:

| loja | piso de altura na tela | espaço livre |
|---|---|---|
| App Store | **40 px** | ¼ da altura |
| Google Play | **28 px** | ¼ da altura |

Altura abaixo do piso sobe em vez de encolher, e o espaço livre é desenhado pela peça.

## O que você faz

Se você mostra selo de loja em alguma tela, declare a arte oficial em `DilettaBrand.selosDeLoja`:

```dart
DilettaBrand(
  pacote: '<seu pacote>',
  selosDeLoja: {
    DilettaStoreBrand.appStore:   (escuro: 'assets/lojas/app-store-preto.svg', claro: 'assets/lojas/app-store-branco.svg'),
    DilettaStoreBrand.googlePlay: (escuro: 'assets/lojas/google-play-preto.png', claro: null),
  },
)
```

Loja fora do mapa = você não publica lá, e o selo não desenha. Lockup não instalado = só aquele some.

**Onde a arte mora**: junto do resto da arte de marca do seu repo, com um README de procedência ao
lado — de onde o arquivo veio e sob quais termos. É o que faz a auditoria de marca ser respondível
depois, e é a mesma disciplina que a arte de carteira pede.

## Como isso chega

troque o `ref:` pra v0.88.0

## Prazo

Sem prazo — minor, e o componente degrada pra nada sem a arte. Se a sua aba de Integrações passar a
mostrar os selos, me diga com número (quais lojas, quais lockups) — é o tipo de medição que decide se
o `1/10` de espaço livre que a Apple admite em banner de celular vira parâmetro aqui.
