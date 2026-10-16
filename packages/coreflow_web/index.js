// A ENTRADA do PAI na web — `coreflow-web`.
//
//     import 'coreflow-web';          // registra os custom elements do avô e as peças <coreflow-*>
//
// No Flutter a casa tem TRÊS degraus: o avô (`diletta_design_system`) → o pai (`coreflow`, a
// linguagem de produto sem produto) → o filho (Bold, Norte Benk, Confia Capital), que só declara a
// paleta. Na web, até 16/10/2026, tinha dois: o avô → o filho. Todo veredito «nasce no filho» não
// tinha onde nascer, e o que o console precisou além do avô foi montado à mão dentro do console.
// Este pacote é o degrau que faltava — a proposta está em
// `docs/propostas/2026-10-16-a-camada-web-do-coreflow.md`, aprovada pela Agatha em 16/10.
//
// ## O que ele faz, e o que NÃO faz
//
// Reexporta TUDO do avô: quem pina o Coreflow continua recebendo cada custom element dele, com o
// mesmo nome. E acrescenta `coreflow/`, o ponto de extensão das peças `<coreflow-*>` — vazio hoje,
// e a regra de entrada está escrita lá.
//
// NÃO pinta. Nenhuma folha sai daqui: as peças do pai leem papéis da linguagem (`--diletta-*`) e a
// tinta continua vindo da folha do filho, como hoje. É o mesmo contrato do `coreflow` em Dart — sem
// cor, sem degrau, sem asset, sem família (`docs/2026-09-04-adr-o-coreflow-e-o-pai.md`).
//
// ## Por que `#avo` e não o nome do pacote
//
// Aqui no monorepo `#avo` resolve para a DEPENDÊNCIA (`imports` no `package.json`), porque quem
// desenvolve o DS tem a chave do avô. Na TAG publicada ele resolve para `./avo/index.js`, que é a
// cópia do pacote dele dentro do nosso — e aí quem nos consome não precisa de chave nenhuma do
// `ds-diletta`. O apelido é o que deixa esta linha ser a MESMA nos dois lados; o
// `tool/espelha_o_web.sh` cobra isso com um assert. A razão está no adendo de 18/09 do `ADR-003` do
// avô: *«acesso ao artefato não é acesso à fonte — e usar git como registry funde os dois»*.
export * from '#avo';
export { elementos, prontos } from '#avo';
export { pecasDoCoreflow } from './coreflow/index.js';
