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

## [0.3.0] — 2026-08-02

### Adicionado — **`BoldColors`: a rampa vira a FONTE**, e a paleta se monta dela

- Os 46 degraus saíram de dentro do construtor de `BoldPalette.bold` e viraram
  `static const Color` em **`BoldColors`**. A paleta continua igual, e agora é **derivada**;
- **é o que o consumidor ganha, e era o que faltava**: `static const Color acao =
  BoldColors.primary04;` compila. `BoldPalette.bold.primary04` nunca compilou em posição
  const — acesso a campo de instância não é expressão constante em Dart, mesmo com a
  instância `const`;
- veio do veredito **ENTRA COMO FORMA** do pai (`ds v0.25.0`, `O-QUE-O-FILHO-FORNECE.md` §1):
  *"a rampa é a fonte; a paleta é derivada dela"*. O pedido saiu daqui com o custo medido no
  app real — 84 constantes copiadas, 51 linhas `const` que `static final` quebraria, 427
  chamadas que perderiam o `const`;
- **o gate quase não tem corpo**, e é de propósito: `a_rampa_e_legivel_em_const_test` declara
  `static const BoxDecoration caixa = BoxDecoration(color: BoldColors.primary08);` — **a
  asserção é a compilação.** Se a rampa voltar pra dentro do construtor, o arquivo não
  compila. A segunda metade compara paleta com rampa campo a campo, pra a paleta não virar
  uma cópia que combina por enquanto;
- nada some: `BoldPalette.bold` tem a mesma forma e os mesmos valores. **Minor** porque um
  símbolo público nasceu.

### Alterado — em dia com os dois pais, e a razão de subir é a quinta pergunta deles

- `ds-diletta` **v0.24.0 → v0.24.4** · `catalogo-diletta` **v0.73.0 → v0.74.1**;
- **nada aqui muda pra quem adota.** As sete releases são ferramenta e arrumação do lado do pai: a
  limpa deixou de acusar arquivo gerado e o próprio ledger, a varredura passou a enxergar
  `## Nota do filho`, e o compositor do motor foi cortado por método em três passos;
- o motivo de subir mesmo sem ganhar nada é a **quinta pergunta** que a varredura do pai ganhou na
  `ds v0.24.4` — *que filho está ATRÁS*. Eu estava: 4 releases no DS e 3 no motor.

  > **Tag publicada não é tag adotada** — a frase é do pai, e do lado de quem usa, um conserto que não
  > chegou é indistinguível de um que não existe.

Gates: DS analyze limpo e **102 testes** · catálogo limpo e **66**.

## [0.2.0] — 2026-08-02

### Alterado — os dois pais sobem, e o que chega é CONTEÚDO das specs

- `ds-diletta` **v0.23.4 → v0.24.0** · `catalogo-diletta` **v0.70.0 → v0.73.0**;
- o que o app ganha ao subir: **`## Compõe` em 69 das 71 specs** do pai (era 8). As specs viajam no
  pacote (`kDilettaSpecs`), então isto é conteúdo novo chegando em quem adota — não é só versão;
- no catálogo, a **Árvore de dependências** aparece sozinha: a aba de Fundamentos aqui é a do motor
  inteira, e a quarta vista entra assim que houver composição declarada;
- **os 12 contratos deste filho já declaravam `## Compõe`** — medido, 12 de 12. O aviso do pai
  supunha que eles teriam nó sem aresta; não é o caso, e a árvore nasce ligada dos dois lados;
- `DilettaWalletCard.cpfSeguro` virou `.brand` no pai nesse intervalo. **Zero linha aqui** — este
  filho não usa o componente, e os dois gates confirmam.

Sem mudança de API deste pacote. Gates no commit: DS analyze limpo e **99 testes** · catálogo limpo e
**66** · `build_web.sh` fecha com o gate do Cloudflare em zero.

## [0.1.0] — 2026-08-01

**A primeira tag.** É a versão que os dois `pubspec.yaml` declaram, e agora `v0.1.0` é o commit que o app
pode pedir por `git:` — antes disso não havia nada pra pedir. Ela aparece aqui como número, e não como
"não lançado", porque é assim que o gate da limpa compara o pubspec com este arquivo — e um pubspec que
ninguém consegue conferir é a classe que ele existe pra pegar.

Medido no commit da tag, não afirmado: DS `flutter analyze` limpo e **99 testes** passando · catálogo
`analyze` limpo e **66** passando · a limpa do pai com as classes 1, 5, 7, 8 e 9 em **nada**.

- **19 arquivos de componente**, 23 tipos públicos `Bold*`, medidos por uso no app — não por catálogo de
  desejo. Oito componentes do pai com uso ZERO não foram declarados, de propósito;
- **5 TELAS declaradas** — o fluxo de Pix inteiro (`home → valor → revisar → enviado`, com **3 setas**
  `push`) e as autorizações da PJ. Eram zero até 2026-07-31; a aba **Telas** mostra fluxo, doc e código;
- **4 slots** declarados (2 fechados por medição, 2 abertos por decisão) — os containers COMPÕEM;
- **56 blocos** no plugue do catálogo, todos em grupo, todos desenhando com os próprios defaults, e o
  emitido de cada um compilando — em **135 variações** de opção de enum, não só no default;
- **paleta como INSTÂNCIA** do tipo do pai, com ~51 papéis derivados. O filho fornece a paleta e mais nada
  obrigatório;
- **99 testes** no DS, **66** no catálogo, analyzer limpo. Conformidade do pai com baseline vazia no DS e
  uma linha declarada no catálogo (`teclado`, componente do pai ainda sem spec);
- **dois sweeps de layout** sobre os 56 blocos, a 900 e a 320 de largura;
- **a montagem da tela conferida contra a geometria pintada** — a doc do contrato contra o `dy` real de
  cada bloco, e o slot contra o retângulo do pai;
- pais: `ds-diletta` **v0.23.4** · `catalogo-diletta` **v0.70.0**.

### O que ainda NÃO é entrega

O app **não adotou**. `ADOCAO.md` tem o caminho, e a decisão é de quem cuida do app — nada aqui mexeu em
`app-newbold`. Enquanto isso, este pacote é medido contra o app, não instalado nele.
