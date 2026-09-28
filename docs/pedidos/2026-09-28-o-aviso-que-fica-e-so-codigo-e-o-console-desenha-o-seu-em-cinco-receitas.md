# PEDIDO · O aviso que fica é só código — e o console desenha o seu à mão, em cinco receitas

- **de**: conta-bold-ds (filho B) · **para**: ds-diletta
- **consome**: ds-diletta `web-v2.5.0`, pela tag `web-v0.118.0` deste repo; **medido também na `web-v2.6.0` (`82c8e63`) e na `origin/main` (`6a2b756`)**
- **bloqueante?**: **não** — cada tela pinta a sua caixa, e todas funcionam. O que falta é a peça, não a função
- **irmãos**: [a linguagem tem toast que some e não tem aviso que fica](2026-08-21-a-linguagem-tem-toast-que-some-e-nao-tem-aviso-que-fica.md) (a peça nasceu dele, `v0.143.0`, só no Dart) · [a família de banner tem cinco peças e nenhuma atravessa](2026-09-16-a-familia-de-banner-tem-cinco-pecas-e-nenhuma-atravessa.md) (só o botão atravessou, `v0.196.0`)
- **não é peça nova**: `design-system-inline-alert` existe, com `"destino": "codigo"` (`specs/design-system-inline-alert/spec.md:77`, `origin/main`). E `DilettaManifesto.busca('aviso que fica')` devolve `[design-system-inline-alert]` (`v2.5.0`, 28/09)

## Falta

A instância web do `DilettaInlineAlert`: `<diletta-inline-alert>` com o mesmo eixo de tom do toast
(`normal` · `success` · `error` · `warning`), título e mensagem — e a spec passando de `codigo` a
`ambos`.

## Número

**No `core-flow-wa` (`c928892`, 28/09), 28 caixas de aviso montadas à mão em 22 folhas, com cinco
receitas diferentes para a mesma coisa** — uma mensagem que fica na tela enquanto a pessoa decide:

| receita | onde (folha:linha) | quantas |
|---|---|---|
| fio de 3px no início + tinta `color-mix` 8–10% + `r8` | `TelaBotoes.module.css:77`, `:86`, `:99` · `TelaConfiguracao.module.css:338` (4 classes: `.recusa`, `.recusaDoCampo`, `.observacao`, `.confirmacao`) | 7 |
| fio de 3px à esquerda + superfície, sem tinta | `AvisoDeSenhaRedefinida.module.css:8` · `DetalheDoGestor.module.css:95` · `TelaGestores.module.css:64` · `TelaCliente.module.css:175` · `TelaKyc.module.css:81` · `MapaDoCliente.module.css:95` · `RecorteDeRegiao.module.css:61` | 7 |
| fio de **2px** à esquerda + superfície | `TelaConfiguracao.module.css:114`, `:131`, `:160` · `TelaLogin.module.css:212` · `TelaPareamentoDe2FA.module.css:105` · `DescidaAosLancamentos.module.css:24` · `WidgetDeConsulta.module.css:191` | 7 |
| borda cheia de 1px na cor do tom | `TelaAoVivo.module.css:270` · `AcoesDaMesa.module.css:87` · `FormularioDeSenha.module.css:66` · `TelaLogin.module.css:86` · `TelaMinhasChaves.module.css:126` · `TelaPareamentoDe2FA.module.css:145` · `UsoPorFuncionalidade.module.css:28` | 7 |
| borda **tracejada** âmbar | `DiagramaDoProcesso.module.css:303` · `PainelDeSuporte.module.css:45` · `ParadosNoPasso.module.css:85` · `TelaDaMesa.module.css:34` | 4 |

(São 32 linhas porque `TelaConfiguracao:338` pinta quatro classes; contadas como caixas, 28.) Mais
duas **neutras**, de borda `border` (`TelaAoVivo.module.css:166`, `AcompanharConversa.module.css:98`),
que são o tom `normal` da peça. Fora da conta, de propósito: os quatro **fios de ressalva sobre um
dado** (`CelulaDeMedida.module.css:20`, `:53`, `DescidaAConversa.module.css:38`,
`ConfigurarPainel.module.css:145`) — são marca num número, não mensagem, e a troca deles por
etiqueta é uma decisão aberta de outra pessoa do time.

Medido com uma varredura das folhas por `border(-left|-inline-start)` na cor `*OnSurface` e
`color-mix` de tom, cada ocorrência lida no seletor.

**E o avô já contou o mesmo no desenho**: `figma/fila-da-web.json` (`origin/main`) tem o conjunto
`Warning` com **15 instâncias visíveis** na fila da fase 4, marcado como local.

## Já tentei

1. **O toast.** `<diletta-toast>` atravessa desde cedo, e a spec dele diz que é **transitório** — o
   contrário do caso. Foi a mesma razão que fez o `DilettaInlineAlert` nascer em 21/08.
2. **O banner de nível.** O veredito de 16/09 publicou o `<diletta-status-banner-button>` e deixou a
   família fora *«por demanda medida, uma a uma»*. Mas o `DilettaStatusBanner` é **estado da conta**
   (`specs/design-system-inline-alert/spec.md:7-8`), e nenhum dos 28 é estado de conta.
3. **O pai (Coreflow).** A primeira leitura da auditoria de 28/09 mandou este pedido ao Coreflow,
   porque o veredito de 16/09 disse que a faixa do banner *«é sua»*. **Medido, não é:** o
   `CoreflowAviso` é **casca do `DilettaInlineAlert` desde 22/08** — `packages/coreflow/lib/src/coreflow_aviso.dart:45-80`,
   o `build` devolve `DilettaInlineAlert(titulo:, mensagem:, state:)`. E a instância web deste repo
   não tem peça própria por desenho (`packages/coreflow_design_system_web/package.json`, `description`:
   *«Não redefine componente — troca a cor por variável CSS»*). O vocabulário é seu.

## Conferi no pai

- `packages/diletta_design_system_web/src/` na `origin/main`: 34 arquivos, nenhum de aviso além do
  `diletta-status-banner-button.js`. Idem na `web-v2.6.0` (`src/`) e no pino.
- `specs/design-system-inline-alert/spec.md`: `destino: codigo` (`:77`); o requisito do tom (*«o
  tom é o MESMO eixo do toast»*) e o do glifo (*«a cor NUNCA vai sozinha, e o glifo não é de quem
  chama»*) — e é justamente o que as cinco receitas não fazem: **nenhuma das 28 caixas tem glifo**;
  todas dizem o tom só pela cor do fio ou da borda.
- `packages/diletta_design_system/lib/src/widgets/diletta_inline_alert.dart` existe na `origin/main`.

## Derivável?

Não de fora. O glifo por tom, a caixa e a tipografia do par são o contrato da peça; o console
consegue imitar a caixa (é o que as cinco receitas fazem), e é por isso que há cinco.

## Duas condições de reabrir do 21/08 que agora têm sítio contado

O veredito de 21/08 recusou duas coisas e escreveu a condição de cada uma. As duas batem aqui — **não
é o pedido principal**, e fica a seu critério se entram junto ou depois:

1. **Ação dentro do aviso** — *«reabre no primeiro pedido com sítio contado»*. Dois:
   `TelaBotoes.tsx:242-249` e `TelaConfiguracao.tsx:269-276`, a recusa de gravação por conflito
   (409) com um botão **«Recarregar a configuração em vigor»** dentro da caixa.
2. **`liveRegion`** — *«se você medir um caso em que o aviso APARECE por mudança de estado»*. Todas
   as caixas de recusa do console aparecem depois de uma ação: `role="alert"` em `TelaBotoes.tsx:242`,
   `BotoesDoBanco.tsx:249`, `TelaConfiguracao.tsx:269`, `:389`, `:517`, `AcoesDaMesa.tsx:229`; e
   `role="status"` no feito da mesma Mesa (`AcoesDaMesa.tsx:223`). Na web o anúncio é o `role`, e hoje
   cada tela decide o seu.

## Se você disser não

O console escolhe uma das cinco receitas e a promove a peça local (`WaAviso`), sem glifo ou com um
glifo escolhido aqui — a terceira casa da mesma decisão, que foi o que o `CoreflowAviso` deixou de
ser em 22/08.

## Não estou pedindo

1. **a família de banner** — a recusa de 16/09 continua de pé; nada aqui é estado de conta;
2. **fechar o aviso** — zero sítios com fechar, como no Dart;
3. **peça no Coreflow** — o aviso do pai é a sua peça com outro nome, e continua sendo.

## Como o pai vai saber que funcionou

`<diletta-inline-alert tom="warning" titulo="…">` resolve no `node_modules`, com o glifo do tom e a
superfície da spec, e o quadrado para de cobrar `codigoWeb` de `inline-alert`. Do lado de cá: as 28
caixas viram chamada, e as cinco receitas saem das folhas.

## Como cheguei aqui

Pela passada «o DS em tudo» do webadmin (tarefa 1.12 de `arquitetura-de-informacao-do-console`,
`c928892`, 28/09): duas auditorias contaram «quatro desenhos» cada uma, em áreas diferentes (Marca e
Conversas; Cadastros e Acessos), e uma terceira achou mais quatro no login. Este pedido **funde as
três** e refaz a conta no código inteiro.
