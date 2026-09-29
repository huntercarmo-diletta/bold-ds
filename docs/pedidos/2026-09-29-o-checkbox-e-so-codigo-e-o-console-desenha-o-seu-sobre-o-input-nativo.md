# PEDIDO · O checkbox é só código — e o console desenha o seu sobre o `<input>` nativo

- **de**: conta-bold-ds (filho B) · **para**: ds-diletta
- **consome**: ds-diletta `web-v2.5.0`, pela tag `web-v0.118.0` deste repo (a que o console instala,
  `core-flow-wa/package.json:26`); pino Dart do pai `v2.5.0` (`packages/coreflow/pubspec.yaml:23`).
  **Medido também na ponta, `v3.1.0` (`e480392`) e `web-v3.1.0` (`660e3f5`)**
- **bloqueante?**: **não** — o console tem uma ponte que funciona. É o quadro das [seis peças `ambos` de 28/09](2026-09-28-seis-pecas-declaradas-ambos-nao-tem-o-lado-web-e-o-console-escreve-as-suas.md),
  com uma diferença: esta nem está declarada `ambos`
- **irmão**: [a caixa vazia do checkbox e do rádio não passa 3:1](2026-09-29-a-caixa-vazia-do-checkbox-e-do-radio-nao-passa-3-para-1.md),
  da mesma tela. **Este espera aquele**: se o lado web nascer, que nasça com o contorno já decidido
- **não é peça nova**: `DilettaManifesto.busca('checkbox')` devolve
  `[design-system-checkbox, design-system-chat-input, design-system-radio-list, design-system-toggle-switch]`.
  `busca('caixa de seleção')` e `busca('seleção múltipla')` devolvem **vazio** (a lógica da `busca`
  reproduzida sobre as 128 specs da `origin/main`). O segundo vazio é do instrumento, não da linguagem:
  o `## Purpose` escreve *«a seleção **múltipla**»*, com o negrito no meio da expressão
- **não reabre nada**: não achei recusa sua sobre checkbox na web no seu `docs/PEDIDOS.md`

## Falta

**O `destino` do `design-system-checkbox` ir de `codigo` para `ambos`, e o `<diletta-checkbox>`
existir.** Hoje a spec declara `"destino": "codigo"` (`specs/design-system-checkbox/spec.md`, bloco
`Contrato`, na `v3.1.0`), e `packages/diletta_design_system_web/src/` não tem checkbox em versão
nenhuma: 0 arquivos na `origin/main` e na `web-v3.1.0`, e 0 nas tags `web-v0.118.0` e `web-v0.120.0`
deste repo. O pai (Coreflow) também não tem, na web nem no Dart. O único uso dele é o
`DilettaCheckbox` seu dentro do `coreflow_cartao_de_pedido.dart:163`.

## Número — onde o console escreve a sua (`core-flow-wa`, `feat/ligar-e-desligar-funcionalidades`, sobre `b3c427c`)

| sítio | o que está lá | o que a peça daria |
|---|---|---|
| `features/botoes/ui/TelaBotoes.tsx:455`, atalhos da Home | `WaCaixaDeSelecao`, com `desabilitada` quando os atalhos do servidor lotam | caixa `md` + rótulo + desligado |
| `features/botoes/ui/BotoesDoBanco.tsx:229`, «Onde aparece» | `WaCaixaDeSelecao`, grupo de 2+ | idem |
| `features/botoes/ui/BotoesDoBanco.tsx:244`, «Para quem» | `WaCaixaDeSelecao`, grupo de 2 | idem |
| `features/acessos/ui/EditorDePerfil.tsx:249` | `<input type="checkbox">` cru + `<label for>` + **descrição** por `aria-describedby` | rótulo **e descrição** |
| `features/login/ui/TelaPareamentoDe2FA.tsx:109` | cru, aceite (*«guardei os códigos»*) | o seu cenário *«Aceite de termos»* |
| `features/painel/ui/ConfigurarPainel.tsx:184`, `:215` | cru, **sem rótulo visível** na linha, nome por `aria-label` | caixa sem rótulo, com nome acessível |
| `features/painel/ui/ConfigurarPainel.tsx:264` | cru, `checked={false} disabled`, item previsto | desligado |

**8 caixas em 5 arquivos**, medidas por `grep 'type="checkbox"'` e `grep '<WaCaixaDeSelecao'` no `src/`,
sem teste nem story. **Estado parcial: 0 usos** (`grep indeterminate` vazio). Peço porque a spec já
tem, não porque o console usa.

## Já tentei

A ponte `src/design-system/atoms/WaCaixaDeSelecao.tsx` (+ `.module.css`, 56 + 83 linhas, ainda **fora
de commit** no console) desenha a sua anatomia sobre o `<input type="checkbox">` nativo: 20×20, visto
`M2 6 L5 9 L10 3` na grade de 12 (o seu `_CheckPainter`), traço 2, rótulo `bodyMd` `textSecondary` a
`s2`, marcada `primary`/`onPrimary`, desligada `surfaceMuted`/`borderSubtle`/`textDisabled`. O
formulário, o teclado e o leitor de tela vêm do nativo. Ela diverge da peça em três pontos, todos
declarados no arquivo:

1. **raio 4, não 6**: o 6 do `md` não está na escala de formas do console, e ele usou o 4 do `sm`;
2. **contorno `textSecondary`, não `border`**: é o pedido irmão;
3. **sem estado parcial nem descrição**: a ponte só cobre o que Botões usa.

Três consumidores olhando a mesma peça e três desenhos à mão: o das telas cruas, o da ponte e o seu.

## Conferi no pai

- O widget: `packages/diletta_design_system/lib/src/widgets/diletta_checkbox.dart`, igual na `v2.5.0`
  e na `v3.1.0` nas linhas que citei (`:108` o traço de 1, `:133-134` `Semantics checked/mixed`,
  `:187` e `:195` rótulo e descrição, `:216-239` a resolução da caixa).
- O lote do `formAssociated` nos campos (o seu CHANGELOG, `[2.6.0]`): *«sai quando `setFormValue`,
  `setValidity` com âncora, `formResetCallback` e `formStateRestoreCallback` estiverem juntos»*. E o
  seu veredito de 24/09: *«meia entrega aqui é campo que mente no reset»*. Um checkbox é campo de
  formulário do mesmo jeito.
- Os três precedentes de peça só-Dart pedida para a web, do mesmo filho: o **seletor** (21/09, *«nasce
  em volta do `<select>` NATIVO»*), o **diálogo** (21/09, *«a declaração dele estava ERRADA»*) e o
  **campo de data** (22/09, *«a spec é uma, o mecanismo de cada plataforma é o dela»*, e *«sai no lote
  do `formAssociated`»*).
- A sua nota de hoje na `v3.1.0` (os `aria-*`): *«`aria-controls` e `aria-describedby` ficam fora. São
  referência por `id`, e referência não atravessa o shadow»*. Isso decide onde mora a descrição (abaixo).

## Derivável?

Não. É instância de plataforma.

## O que peço, na forma — e o mecanismo é seu

- `destino: ambos` na spec, e o `<diletta-checkbox>` com `checked`, `indeterminate`, `disabled`,
  `size` (`sm`/`md`) e `variant` (`primary`/`neutral`), como o Dart;
- **rótulo e descrição DENTRO da peça**, como slot ou atributo. Pela sua nota de hoje, o
  `aria-describedby` que o `EditorDePerfil` usa não alcançaria o controle no shadow. Com descrição na
  peça, a ligação fica interna;
- **nome acessível sem rótulo visível** (`ConfigurarPainel.tsx:184`), pelo mesmo caminho do
  `rotulo-acessivel` do `<diletta-button>` (`diletta-button.js:59`, `:131`; na `origin/main` é o único
  elemento que o tem);
- **o evento de mudança** no padrão das irmãs (o `mudou` que o `<diletta-input>` ganhou na `v2.5.0`);
- **participar de formulário**: `formAssociated` com o lote dos campos, **ou** o controle ser o
  `<input type="checkbox">` nativo, como o seletor é o `<select>`. A escolha é sua. Só registro que o
  nativo já dá teclado (espaço), `:checked`/`:indeterminate` e o papel ao leitor de tela.

## Se você disser não

A ponte vira peça do console, e o `WaCaixaDeSelecao` passa de provisório a desenho próprio. Ele sai do
quadrado de paridade e deriva sozinho a cada tag sua (o raio 6, o hover, o visto). As 5 caixas cruas
continuam com o desenho do navegador.

## Não estou pedindo

1. **que saia antes do lote do `formAssociated`**: se o checkbox entrar no mesmo lote do campo de data,
   é o certo;
2. **rádio e interruptor na web**: são `codigo` também, e o console não os usa hoje (não medi demanda);
3. **o `DilettaRightAccessory.checkbox`** da linha de lista: é outra peça;
4. **mudar o desenho Dart**: o contorno é o pedido irmão, e o resto fica.

## Como o pai vai saber que funcionou

- `design-system-checkbox` com `"destino": "ambos"`, e a régua de paridade cobrando `codigoWeb` dele;
- num `<form>`, um `<diletta-checkbox name="x" checked>` entra no `FormData`, e o `reset()` do
  formulário o devolve ao estado inicial;
- o leitor de tela anuncia rótulo, descrição e *«marcado / não marcado / misto»* pela própria peça,
  sem `aria-describedby` de fora;
- o console troca o miolo do `WaCaixaDeSelecao` pelo `<diletta-checkbox>` sem mudar as telas.

## Como cheguei aqui

A tela Ajustes › Botões do console (webadmin), branch `feat/ligar-e-desligar-funcionalidades`, precisou
de três grupos de caixas em 29/09. A peça estava na linguagem, e o lado web não. A designer autorizou a
entrega no mesmo dia.

---

## VEREDITO · ENTRA — em volta do input nativo, depois do contorno, e no lote do `formAssociated`

**pai**: ds-diletta **v3.2.0** · **data**: 2026-09-29

### O que decidiu

Os precedentes que você foi buscar: o seletor nasceu em volta do `<select>` nativo, e o campo de data
saiu *«no lote do `formAssociated`»*. Um checkbox é campo de formulário, e a frase de 24/09 vale para
ele: *«meia entrega aqui é campo que mente no reset»*. E a ordem é a sua: *«este vem antes»* está escrito
no irmão do contorno.

### A forma

`<diletta-checkbox>` em volta do `<input type="checkbox">` nativo, com a pintura da tabela de resolução
que o checkbox já tem, o rótulo pelo slot, e a descrição **dentro** do shadow, porque referência por `id`
não atravessa, como você leu na nota de hoje.

### A condição

- o papel de contorno de controle existe (o irmão);
- o lote do `formAssociated` dos campos sai, com o campo de data junto;
- a spec vai a `ambos`, e o quadrado fecha `codigoWeb` do checkbox.

### O que eu achei indo implementar

nada

### O que eu recusei, e a condição de reabrir

O estado parcial entra junto, porque a spec o tem, mesmo com zero usos seus. Nada recusado.

### Os sete critérios

| critério | | |
|---|:-:|---|
| manutenção | ↑ | três desenhos à mão viram uma peça |
| escalabilidade | ↑ | o próximo consumidor web não escreve a quarta caixa |
| aplicação | ↓ | **dívida declarada**: as 8 caixas seguem à mão até a condição |
| aderência ao mercado | ↑ | o input nativo traz formulário, teclado e leitor de tela |
| robustez | ↑ | sai com reset e validade juntos, e não pela metade |
| arquitetura limpa e simples | = | o arranjo do seletor, repetido |
| conciso | = | nada novo além da chamada |

### O que você faz

Nada até a condição. A `WaCaixaDeSelecao` fica como ponte, com as três divergências declaradas.
