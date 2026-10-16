# Proposta · a camada web do Coreflow — o degrau que falta entre o avô e os filhos

**Estado:** aprovada pela Agatha em 16/10/2026 — passo 1 em andamento · **data:** 2026-10-16 · **de:** o chat do webadmin (console da Conta BOLD) · **toca:** `packages/coreflow`, `packages/coreflow_design_system_web`, `packages/*/web`, `tool/espelha_o_web.sh`, `packages/coreflow/bin/novo_filho.dart`.

## O fato, medido em 16/10

No Flutter a casa tem **três degraus**: o avô (`diletta_design_system`) → o pai (`coreflow`, 60+ widgets em `lib/src/coreflow_*.dart`: saldo, etiqueta, autorização, comprovante, campo de valor…) → o filho (`coreflow_design_system` do Bold, `norte_benk_coreflow`, `confia_capital_coreflow`), que só declara a paleta.

Na web há **dois**: o avô (`diletta-design-system-web`) → o filho. `packages/coreflow_design_system_web/index.js` tem 39 linhas e faz `export * from '#avo'`; a Norte Benk e a Confia Capital têm o mesmo arquivo. O pai não tem nada web (`packages/coreflow/example/web/` são os ícones do exemplo Flutter). Logo, **todo veredito «nasce no filho» não tem onde nascer na web** — o chip neutro (29/09) está parado por isso — e tudo o que o console precisou além do avô foi montado à mão no próprio console: gaveta lateral (30 chamadas), ficha rótulo-sobre-valor (67 + 45 `<dl>`), linha do tempo (4 lugares), cartão de total (3), barra fixa (3), gráficos (24 chamadas), a pílula do trilho. Oito desses viraram pedido ao avô em 16/10; o que ele recusar («é do produto») não tem casa.

## A proposta

Criar **`packages/coreflow_web`** (nome npm `coreflow-web`), o pai na web, com o mesmo contrato do pai em Dart:

- **Importa o avô** (`#avo` → `diletta-design-system-web`) e **reexporta tudo** — quem pina o Coreflow continua recebendo todos os custom elements do avô.
- **Acrescenta peças com prefixo `<coreflow-*>`**, só as que (a) o avô recusou ou declarou «do produto» e (b) mais de um produto da casa usa ou vai usar. A primeira fila, pela medição: `coreflow-ficha` (rótulo sobre valor), `coreflow-linha-do-tempo`, `coreflow-total` (número grande + rótulo + detalhe), `coreflow-chip` com tom neutro (o veredito de 29/09), e a receita do item do trilho ativo. A gaveta, a barra fixa, a data com hora e os gráficos **esperam o veredito do avô** (pedidos de 16/10) antes de entrar aqui.
- **Não pinta.** As peças leem só papéis (`--cps-*`); a tinta continua vindo da folha do filho, como hoje. Sem um único hex.
- **Lê o código do console como fonte**: cada peça nasce da versão já revisada em `core-flow-wa/src/design-system/` (WaDetailPanel, Pares, Tentativas/LinhaDoTempoMed, QuadroDeTotais, WaBarrasHorizontais…) — e o console passa a **consumir em vez de manter**; é o mesmo movimento do app com o Coreflow em Dart (ADR «Coreflow é o pai», 04/09).

Os filhos mudam uma linha: `#avo` deixa de apontar para o avô e passa a apontar para `coreflow-web` (que já traz o avô dentro). `novo_filho.dart` gera o `web/` do filho já assim; `espelha_o_web.sh` copia o pai **e** o avô para a tag órfã (hoje copia o avô em `avo/`; passaria a copiar `coreflow-web/` com o avô embutido), e o gate «uma língua, um número» passa a conferir três pinos web em vez de dois.

## O que NÃO é

- Não é um DS paralelo nem um fork do avô: nada do avô é reescrito, e peça que o avô aceitar **sai daqui** quando ele a publicar (a mesma regra do Dart: o pai encolhe quando o avô cresce).
- Não é o lugar de receita de uma tela só (campo de pergunta do Perguntar, faixa de passos de Cadastros): essas ficam no console.
- Não mexe nos tokens: `bold-tokens.css` e irmãs continuam sendo o que são.

## Custo e ordem

1. Esqueleto do pacote + reexport do avô + gate (um dia): os filhos já podem apontar para ele sem mudar nada do que veem.
2. As peças da primeira fila, uma por PR, cada uma com teste de contrato (atributos, eventos `mudou`, nenhum hex) e a troca correspondente no console no mesmo dia da tag.
3. Tag `coreflow-web-v0.1.0`; o console sobe o pino (junto com o salto de `web-v0.118.0` para a `web-v0.125.0`, que já está atrasado).

## Decisões que ficam com a Agatha

- Aprovar a existência do degrau (é isto que o veredito de 29/09 pede implicitamente).
- O nome: `coreflow-web` (proposto) ou `coreflow-design-system-web` — este último hoje é o do Bold e **não pode** ser reaproveitado sem quebrar o console.
- Se as peças da primeira fila esperam os vereditos de 16/10 ou se `coreflow-ficha` e `coreflow-total` (que o avô já recusou/postergou) começam agora.
