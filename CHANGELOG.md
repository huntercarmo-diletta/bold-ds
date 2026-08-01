# CHANGELOG · Conta BOLD DS

Quem consome este pacote é o **app do Conta BOLD**, e a entrega é por tag. Sem este arquivo, subir de
versão é aceitar mudança sem saber qual — e a regra é do pai, com o número dele: *"filho que não consegue
ler o que ganha ao subir de versão não sobe"*, escrita depois de um DS da família chegar à tag 44 sem
changelog nenhum.

**Ele começa aqui, e isso é declarado**: `version: 0.1.0` nos dois pacotes desde o primeiro commit, **zero
tags** em 113 commits. Não existe histórico de versão pra recuperar, e inventar entradas retroativas a
partir de assunto de commit seria precisão de mentira. A primeira linha real é a próxima.

Formato: [Keep a Changelog](https://keepachangelog.com/pt-BR/1.1.0/) ·
versionamento: [SemVer](https://semver.org/lang/pt-BR/).

O que cada degrau significa **pro app que adota**:

| degrau | o que muda | o que o app faz |
|---|---|---|
| **major** | símbolo removido ou assinatura trocada | lê a nota de migração antes de subir |
| **minor** | componente novo, papel novo, token novo | sobe sem mexer em nada |
| **patch** | conserto que não muda API | sobe sem ler |

## [0.1.0] — ainda NÃO tagueada

É a versão que os dois `pubspec.yaml` declaram hoje, e o estado que a **primeira tag** vai carregar. Ela
aparece aqui como número, e não como "não lançado", porque é assim que o gate da limpa compara o pubspec
com este arquivo — e um pubspec que ninguém consegue conferir é a classe que ele existe pra pegar.

- **19 arquivos de componente**, 23 tipos públicos `Bold*`, medidos por uso no app — não por catálogo de
  desejo. Oito componentes do pai com uso ZERO não foram declarados, de propósito;
- **3 TELAS declaradas** (`pf1-home` → `pf2-pix-valor` e `pj1-autorizacoes`) com a **primeira seta** do
  produto — eram zero até 2026-07-31 —, na aba **Telas** com fluxo, doc e código de cada uma;
- **4 slots** declarados (2 fechados por medição, 2 abertos por decisão) — os containers COMPÕEM;
- **56 blocos** no plugue do catálogo, todos em grupo, todos desenhando com os próprios defaults, e o
  emitido de cada um compilando — em **135 variações** de opção de enum, não só no default;
- **paleta como INSTÂNCIA** do tipo do pai, com ~51 papéis derivados. O filho fornece a paleta e mais nada
  obrigatório;
- **99 testes** no DS, **61** no catálogo, analyzer limpo. Conformidade do pai com baseline vazia no DS e
  uma linha declarada no catálogo (`teclado`, componente do pai ainda sem spec);
- **dois sweeps de layout** sobre os 56 blocos, a 900 e a 320 de largura;
- **a montagem da tela conferida contra a geometria pintada** — a doc do contrato contra o `dy` real de
  cada bloco, e o slot contra o retângulo do pai;
- pais: `ds-diletta` **v0.23.1** · `catalogo-diletta` **v0.66.0**.

### O que ainda NÃO é entrega

O app **não adotou**. `ADOCAO.md` tem o caminho, e a decisão é de quem cuida do app — nada aqui mexeu em
`app-newbold`. Enquanto isso, este pacote é medido contra o app, não instalado nele.
