# RELEASE · o círculo de hover centra no glifo, e a barra de status ganhou dono

**de**: ds-diletta v0.176.0 · **para**: conta-bold-ds · **data**: 2026-09-08

## O que mudou

**É a segunda tag de hoje** — a
[v0.175.0](2026-09-08-tres-pixels-mudam-e-a-linguagem-ganhou-uma-segunda-instancia.md)
saiu antes, e vale adotar as duas de uma vez.

**1 · `DilettaIconButton` com `glifoNoInicio` ou `flush`: quem se desloca passa a ser
a CAIXA, não o glifo dentro dela.** A pintura de hover estava **11px** fora do ícone —
centro da pílula em 44, centro do glifo em 33. A premissa de quem escreveu era
*"acessório **sem superfície pintada**"*, e ela vale em repouso; em `hover` e em
`pressed` o terciário pinta, e aí a pílula fica para trás.

O glifo **não muda de lugar** e o alvo de toque também não: só a pintura, a borda e o
badge passam a andar junto com ele. Se você usa os acessórios de navegação da barra de
topo, nenhuma tela sua muda em repouso.

**2 · `DilettaScheme.overlayDaBarraDeStatus`**, derivado da polaridade do modo como
`brightness` já é: o estilo dos ícones da barra de status do sistema — relógio, wifi,
bateria. Se você crava `systemOverlayStyle` em alguma tela, troque por ele.

`SystemUiOverlayStyle.dark` quer dizer **glifo escuro**, não *"tema escuro"*: o nome
descreve a tinta, e é onde a leitura erra. Uma constante dessas escrita numa tela que
nasceu clara não sabe o dia em que o modo escuro chega.

## O que você faz

Adota quando quiser. Se você tem casca de topo própria com `systemOverlayStyle`
cravado, esse é o sítio.

## Como isso chega

    troque o `ref:` pra v0.176.0

em `packages/coreflow_design_system/pubspec.yaml`. Você está na `v0.163.0`: são treze.

## Prazo

Nenhum. É minor: nada removido, nada com assinatura trocada.
