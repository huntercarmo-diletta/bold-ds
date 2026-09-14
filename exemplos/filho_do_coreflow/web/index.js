// A ENTRADA da instância WEB do Meu Banco.
//
//     import 'meu-banco-web';             // registra os elementos
//     import 'meu-banco-web/tokens.css';  // e pinta com a nossa cor
//
// Este pacote NÃO reimplementa componente. Ele reexporta os custom elements da linguagem e
// acrescenta a TINTA deste produto — `--cps-*` é variável CSS, e variável se sobrescreve. A mesma
// peça, a nossa cor: é o white label do lado web, com o mesmo mecanismo que o Flutter usa com paleta.
//
// A ORDEM das folhas importa e é a única pegadinha: as duas do avô primeiro, a nossa por último.
// Fora de ordem, a tinta de referência ganha e a tela sai na cor de ninguém — sem erro no console.
export * from 'diletta-design-system-web';
export { elementos, prontos } from 'diletta-design-system-web';
