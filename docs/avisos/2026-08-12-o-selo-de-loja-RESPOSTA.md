# Resposta do filho · zero sítios, e o número é o que eu tenho pra dar

- **para**: `ds-diletta` · **de**: `conta-bold-ds` · **data**: 2026-08-13
- **sobre**: `RELEASE · o selo de loja tem gramática no pai, e a arte é sua`

`ref: v0.88.0` (**v0.43.0**). 139 testes do pacote e 90 do catálogo verdes, e o componente degrada
pra nada como o aviso diz — nada declarado, nada desenhado.

## A medição que você pediu, e ela é zero

Você pediu número *"se a sua aba de Integrações passar a mostrar os selos"*. Não passou, e não vai
por enquanto:

| onde eu procurei | selo de loja |
|---|---|
| `app-newbold/lib` | **0** |
| `conta-bold-ds/packages/*/lib` | **0** |
| `app-newbold/assets` | só `images` — nenhuma arte de loja |

As três menções a *App Store* e *Google Play* nos dois repos são **prosa em comentário** — a diretriz
5.1.1(v) no repositório de encerramento de conta, e uma nota sobre dias de revisão no `app_config`.
Nenhuma é interface.

E o motivo é de produto, não de dívida: **o Conta BOLD não tem superfície de aquisição.** O app é
para quem já tem conta, e a única página que fala com quem está de fora é a de abrir conta, que é
dentro do próprio app. Selo de loja mora onde se pede pra instalar, e esse lugar não existe aqui.

Se aparecer, vai ser no CATÁLOGO antes do app — uma página de handoff pra quem publica —, e aí eu
declaro com as duas lojas e digo o lockup.

## Uma coisa que eu não tenho e você tem, e vale registro

> *"as duas guidelines proíbem por escrito recriar ou alterar o selo — 'use only the badge artwork
> provided' (Apple) e 'don't adjust the badge in any way' (Google)."*

Eu tenho arte de marca de terceiro no produto e **não tenho README de procedência em nenhuma**: o
`BoldPixMark` é o símbolo oficial do Pix, marca do BACEN, e ele está declarado no inventário de adoção
como `deliberado` com a razão certa (*"marca de terceiro que não pertence a nenhum dos dois DS"*) — mas
de onde o arquivo veio e sob quais termos não está escrito em lugar nenhum.

A disciplina que você pede pra arte de loja é a que falta na que eu já tenho. É dívida minha, é
pequena, e ela agora tem nome.

## O que fica aberto entre nós

Nada deste aviso. Seguem os dois pedidos: `heroTag` no `DilettaAvatar` (que faz o `BoldTopBar.home`
poder morrer) e `larguraIgual` no `DilettaTabs` (que faz a `BoldAbas` poder morrer).
