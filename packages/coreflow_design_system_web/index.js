// A ENTRADA da instância WEB do DS do Conta BOLD.
//
//     import 'coreflow-design-system-web';                       // registra os 25 elementos
//     import 'coreflow-design-system-web/tokens.css';            // e pinta de Bold
//
// Este pacote NÃO reimplementa componente. Ele reexporta os custom elements do avô e acrescenta a
// TINTA deste produto — porque `--cps-*` é variável CSS, e variável se sobrescreve. A mesma peça, a
// nossa cor: é o white label do lado web, com o mesmo mecanismo que o Flutter usa com paleta.
//
// ## A ORDEM das folhas importa, e é a única pegadinha
//
//     <link rel="stylesheet" href=".../diletta-design-system-web/tokens/cps-tokens.css">
//     <link rel="stylesheet" href=".../diletta-design-system-web/tokens/cps-papeis.css">
//     <link rel="stylesheet" href=".../coreflow-design-system-web/tokens/bold-tokens.css">
//
// As duas primeiras são do avô e trazem primitivas e papéis na tinta de REFERÊNCIA. A terceira é a
// nossa, e declara os mesmos nomes com os valores do Bold. Fora de ordem, a referência ganha e a tela
// sai verde — sem erro nenhum no console, que é o modo de falhar que o README do avô conta ter
// custado semanas a ele.
//
// ## De onde vem a nossa folha
//
// De `BoldPalette.bold`, pela derivação do AVÔ (`dilettaCorDoPapelGen`), emitida por
// `coreflow_design_system/test/emite_o_css_do_bold.dart`. Nenhum hex é digitado, e um gate na suíte
// do filho reprova se o arquivo divergir da fonte.
//
// ## Por que `#avo` e não o nome do pacote
//
// Aqui no monorepo `#avo` resolve para a DEPENDÊNCIA (`imports` no `package.json`), porque quem
// desenvolve o DS tem a chave do avô. Na TAG publicada ele resolve para `./avo/index.js`, que é a
// cópia do pacote dele dentro do nosso — e aí quem nos consome não precisa de chave nenhuma do
// `ds-diletta`. O apelido é o que deixa esta linha ser a MESMA nos dois lados: sem ele, a emissão
// teria de reescrever o texto do import, que é divergência que ninguém vê.
//
// A razão está no adendo de 18/09 do `ADR-003` do avô: *«acesso ao artefato não é acesso à fonte —
// e usar git como registry funde os dois»*. Enquanto o transporte for tag de git, o artefato tem de
// EMBUTIR o que declara.
export * from '#avo';
export { elementos, prontos } from '#avo';
