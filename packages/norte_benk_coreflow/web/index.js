// A ENTRADA da instância WEB do Norte Benk.
//
//     import 'norte-benk-web';             // registra os elementos
//     import 'norte-benk-web/tokens.css';  // e pinta com a nossa cor
//
// Este pacote NÃO reimplementa componente. Ele reexporta os custom elements da linguagem e
// acrescenta a TINTA deste produto — `--cps-*` é variável CSS, e variável se sobrescreve. A mesma
// peça, a nossa cor: é o white label do lado web, com o mesmo mecanismo que o Flutter usa com paleta.
//
// A ORDEM das folhas importa e é a única pegadinha: as duas do avô primeiro, a nossa por último.
// Fora de ordem, a tinta de referência ganha e a tela sai na cor de ninguém — sem erro no console.
// ## Por que `#avo` e não o nome do pacote
//
// Aqui no repositório o apelido resolve para a DEPENDÊNCIA, porque quem desenvolve o DS tem a chave
// do avô. Na TAG publicada ele resolve para `./avo/index.js`, que é a cópia do pacote dele dentro do
// nosso — e aí quem consome não precisa de chave nenhuma. O apelido é o que deixa esta linha ser a
// MESMA nos dois lados: sem ele, a emissão teria de reescrever o texto do import, que é divergência
// que ninguém vê.
//
// A razão está no adendo de 18/09 do `ADR-003` do avô: «acesso ao artefato não é acesso à fonte — e
// usar git como registry funde os dois». Enquanto o transporte for tag de git, o artefato tem de
// EMBUTIR o que declara. O `tool/espelha_o_web.sh` cobra este apelido com um assert: sem ele, o
// pacote não é publicável.
export * from '#avo';
export { elementos, prontos } from '#avo';
