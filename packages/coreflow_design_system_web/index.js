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
//     <link rel="stylesheet" href=".../coreflow-design-system-web/tokens/bold-papeis.css">
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
export * from 'diletta-design-system-web';
export { elementos, prontos } from 'diletta-design-system-web';
