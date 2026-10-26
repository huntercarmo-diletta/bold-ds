# PEDIDO · A lista de rádio não nomeia o grupo — e a linha tem 32 de alvo

- **de**: conta-bold-ds (filho B) · **para**: ds-diletta
- **consome**: ds-diletta `v3.24.0` (pino do pai); `diletta_radio_list.dart` é igual na `v3.25.0`
- **bloqueante?**: não
- **irmão**: `2026-10-15-o-checkbox-e-o-interruptor-web-nao-tem-o-piso-de-44.md` — o veredito dele (`v3.16.0`) escreveu: *«a lista de rádio tem 32 de linha, fora do veredito porque ninguém pediu; reabre com pedido»*. **Este é o pedido.**

## Falta

1. **O grupo sem nome.** O `title` do `DilettaRadioList` é desenhado como `Text` solto
   (`diletta_radio_list.dart:86-89`). Ele não é cabeçalho e não nomeia o grupo: cada opção tem nome e estado, e o
   conjunto não tem nome nenhum.
2. **A linha de 32.** Cada opção tem `vertical: 6` de recuo (`:131`) em volta de uma linha de 20.

## Número

**Medido com teste de widget no pino `v3.24.0`, tema do Bold, título «Estado civil»:**

- o nó do título: `isHeader = false`, rótulo «Estado civil», irmão das opções e não pai delas;
- nenhum nó com o papel de grupo de rádio (`SemanticsRole.radioGroup`, que o Flutter instalado já tem e o
  `RadioGroup` dele usa em `widgets/radio_group.dart:214`);
- a linha da opção: **390 × 32**.

Cada opção já tem `inMutuallyExclusiveGroup: true` e `checked` (`:118-125`), então o que falta é só o
contêiner.

**No app do filho B (`origin/development`):** **9** listas de rádio em 9 arquivos, **1** com `title`. Entre
elas o documento de identidade do onboarding, os três passos da contestação Pix (MED) e o convite de
usuário. Nas outras 8 não medi onde a pergunta mora na tela.

## Já tentei

Nada em aparelho. Os caminhos por fora, lidos no código, e por que não bastam:

- **`Semantics(label:)` em volta da lista, no app**: nomeia, mas sem o papel de grupo e com a pergunta
  duas vezes quando a lista tem `title`.

## Conferi no pai

- WCAG 1.3.1 (Info and Relationships): a pergunta e as opções são uma relação que o olho vê e o leitor
  não recebe. Na web é o `<fieldset>` com `<legend>`, ou `role="radiogroup"` com `aria-labelledby`.
- O veredito do título do vazio (`v3.16.0`) e o do título do diálogo (`v3.10.0`): o que é título para o
  olho vira título para quem ouve.
- O piso de 44 é o da casa (`DilettaAlvoDeToque`), e o próprio veredito de 15/10 deixou a linha de 32
  esperando pedido.

## Derivável?

O nome, em parte (por fora, sem o papel de grupo). O alvo, não.

## Se você disser não

As 9 listas seguem com a pergunta solta e o alvo de 32.

## Não estou pedindo

Desenhar o `title` de outro jeito. Mudar o marcador. Um nome obrigatório: sem `title`, um parâmetro de
rótulo só para quem ouve (`rotulo`), como o `<diletta-input>` já tem na web.

## Como o pai vai saber que funcionou

`DilettaRadioList(title: 'Estado civil', …)` → um nó contêiner com o papel de grupo de rádio e o rótulo
«Estado civil», com as opções dentro. Sem `title` e com `rotulo:` → o mesmo nó, sem texto desenhado.
Cada linha com alvo ≥ 44 de altura, o marcador e o texto no mesmo lugar.

## Como cheguei aqui

A auditoria de acessibilidade da proposta de onboarding (Figma, 26/10) pediu o nome do grupo. A linha de
32 apareceu ao medir, e casa com a porta que o veredito de 15/10 deixou aberta.
