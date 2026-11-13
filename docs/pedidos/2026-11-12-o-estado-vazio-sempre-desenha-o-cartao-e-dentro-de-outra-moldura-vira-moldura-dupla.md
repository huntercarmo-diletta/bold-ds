# PEDIDO · O estado vazio sempre desenha o próprio cartão, e dentro de uma tabela, gaveta ou cartão ele vira moldura dentro de moldura

- **de**: conta-bold-ds (filho B) · **para**: ds-diletta
- **consome**: ds-diletta `v3.27.0` · `web-v3.27.0`, pela `web-v0.130.0` deste repo. É o que o Internet Banking `core-flow-ib` tem na homologação de 12/11 (`562bacbf`)
- **bloqueante?**: não. O IB troca o vazio local pela peça nos 40 sítios em que ele fica solto na página. Os 18 que moram dentro de outra moldura ficam com a peça local até o veredito
- **irmão**: `2026-11-12-o-estado-vazio-tem-uma-acao-so-e-a-busca-sem-resultado-tem-duas-saidas.md`. Os dois saíram da mesma passada, a adoção do `<diletta-empty-state>` no IB, e um não depende do outro

## Falta

O `<diletta-empty-state>` (e o `DilettaEmptyState`) sempre desenha o cartão: `surface`, borda `divider` e raio 24. O vazio que já mora numa superfície (a célula de uma tabela, uma gaveta, um cartão com título) não tem como recebê-lo sem a segunda moldura.

## Número

**No IB, 18 sítios de código, que dão 20 lugares na tela, desenham o vazio dentro de outra moldura:**

| a moldura de fora | onde | sítios |
|---|---|--:|
| célula de tabela (`<td colSpan>`) | a `vazio` da `BoldTable`, que serve três tabelas: Pagamentos, e Notas e Contratos da Antecipação | 1 |
| gaveta lateral | «Cobrança não encontrada.» no `<diletta-side-sheet>` da cobrança; «Nenhum pagador encontrado para “…”» na gaveta de Favoritos e recentes | 2 |
| cartão com título ou com outro conteúdo | Início (os widgets «Gráfico indisponível», «Nenhum contato salvo», «Sem lançamentos nos últimos 90 dias» e «Nada seu a caminho»); Extrato («Nenhum lançamento de …» e «Sem resultados»); Segurança («Nenhuma passkey» e «Nenhum aparelho autorizado»); Recebimentos («Quem você cobrar aparece aqui.» e «Nenhuma cobrança em …»); Aprovações e limites («Nenhum operador nesta conta»); Risco sacado (a busca sem resultado e «Nenhum fornecedor ainda») | 13 |
| painel de detalhe (superfície com borda) | Contatos: «Escolha um contato» e «Este contato não está mais na lista» | 2 |

**Como medi:** rodei a suíte inteira do IB (465 arquivos, 6.174 testes, todos verdes) com o vazio local instrumentado para registrar a moldura em volta de cada desenho. Foram 375 desenhos e 52 títulos distintos. Os sítios que nenhum teste desenha, li no código. Os outros 40 sítios do IB moram soltos na página e trocam pela peça já.

**Por que os testes não bastavam:** hoje o `BoldCard` do IB achata o cartão de dentro (`.card .card { background: transparent; border: 0; padding: 0 }`). Oito dos 18 sítios (os da Início, do Extrato e de Segurança) desenham o cartão do vazio dentro de outro cartão, e ninguém vê, porque a regra apaga o de dentro. O cartão da peça mora no shadow, e a regra não chega nele.

**No console** (`core-flow-wa`, `release/homologation` de 12/11), o `EstadoVazio` local tem 140 chamadas em 73 arquivos, todas sem cartão. Delas, 61 entram pela `vazio` de uma tabela (`WaDataTable` e `TabelaDoServidor`), que as embrulha numa `<td colSpan>`. O console não usa a peça da linguagem em nenhum lugar.

## Já tentei

- **O `semCartao` da peça local** (IB, desde 17/09). O cartão é da peça, como no `bold_empty_state` do app, que devolve um `BoldCard`, e quem já está dentro de um cartão passa `semCartao`. É o que funciona hoje nos 11 sítios que declaram a prop, e é o que a peça da linguagem não tem.
- **A regra `.card .card` do `BoldCard`.** Ela achata o cartão de dentro no DOM claro e cobre os outros 8. Não alcança o cartão que mora no shadow.
- **`::part(cartao)` por fora,** com `border: 0; background: transparent; padding: 0`. Funcionaria, e é redesenhar a peça do pai pelo lado de fora: o filho não conserta o pai localmente, e a próxima tag que mexer no cartão diverge em silêncio.
- **Tirar a moldura de fora.** Funciona onde ela só embrulha o vazio, e o IB faz isso em três telas: Agendados, Lotes da conta e Manutenção. Não serve na célula de tabela, na gaveta, nem no cartão que tem título e outro conteúdo (o «Passkey» de Segurança tem o botão de cadastrar ao lado do título).
- **O slot `ilustracao`.** Ele troca o topo da peça. O cartão continua.

## Conferi no pai

- **`diletta-empty-state.js` da `web-v3.27.0`:** o `.cartao` é sempre desenhado, com `part="cartao"`, e nenhum atributo mexe na moldura. O comentário diz que a anatomia foi medida no Dart.
- **`diletta_empty_state.dart` da `v3.27.0`:** sempre `DilettaCardSurface(corSolida: s.surface, bordaSolida: s.divider, radius: all24)`. O `///` descreve um «Card de estado vazio de uma lista (ex: Atividade Recente sem eventos)», Figma 15:15620.
- **A spec `design-system-empty-state`:** `"eixos": {}`, e nenhum requisito sobre a moldura.
- **O próprio pai põe o vazio numa superfície:** o `_NadaComOTermo` de `diletta_dropdown.dart` desenha o `DilettaEmptyState` dentro da folha do seletor, com recuo em volta. Não rodei o Dart. Pelo código, o cartão com borda aparece dentro da folha.
- **Um achado à parte, que não é este pedido:**
  - O `Purpose` da spec diz «o estado **vazio ou de erro**», e a web repete («estados vazio e de erro»).
  - O verbete do `DilettaEmptyState` e o `docs/OS-QUATRO-ESTADOS.md` dizem «serve `vazio`, e só ele». Pela tabela deles, a falha (`indisponivel`) «não passa pelo `DilettaEmptyState`».
  - O IB tem três falhas no vazio: «Internet Banking indisponível», «Gráfico indisponível» e «Não foi possível abrir esta tela». Seguindo a spec, as duas soltas trocam pela peça junto com as outras, e a do gráfico está entre os 18. Se for o verbete que vale, as três mudam de peça.

## Derivável?

Não do que declaro. O consumidor sabe que o vazio está dentro de uma superfície, e a peça não. Na web, o CSS da peça não alcança o fundo em que ela mora.

## Se você disser não

O IB fica com a peça local nos 18 sítios, e as telas passam a ter dois desenhos de vazio: o da linguagem, solto na página, e o local, dentro das molduras. É o «coisas diferentes em dois lugares» do ADR-007. A outra saída seria o `::part(cartao)` por fora, que recuso pelo motivo acima. O console, com 61 vazios dentro de tabela, fica com o `EstadoVazio` dele.

## Não estou pedindo

1. **Uma forma específica.** Pode ser um eixo, uma peça só com o miolo do vazio, ou a peça perguntar à superfície em que mora. No mercado, o `EmptyState` do Polaris e o do Atlassian não desenham moldura: quem os põe num cartão é quem chama. A escolha é da linguagem.
2. **Mudar o padrão.** O cartão continua sendo o desenho de quem não diz nada. O IB decidiu o mesmo em 17/09: «o padrão tem que ser o certo: quem esquecer a prop recebe o cartão».
3. **Outra cor ou outro raio para o cartão.**

## Como o pai vai saber que funcionou

No teste do pai, nas duas instâncias, o mesmo vazio em dois lugares:
1. solto na página: cartão com `surface`, borda `divider` e raio 24, como hoje;
2. dentro de uma superfície (a folha do seletor, um cartão, uma `<td>`): sem segunda borda e sem segundo fundo, com o miolo igual (spot, título, legenda e ação).

Do lado do IB, os 18 sítios trocam pela peça, e o `BoldEmptyState` local sai do repositório quando o último uso for embora.

## Como cheguei aqui

Na adoção do `<diletta-empty-state>` no IB, em 12/11. A Tatiana decidiu trocar o vazio local pela peça da linguagem, revendo o «fica local» de 16/10. O levantamento varreu as 59 chamadas do `BoldEmptyState`, em 42 arquivos. A medida pela suíte mostrou que os 11 sítios com `semCartao` não eram todos: a regra `.card .card` escondia outros 8.

## VEREDITO · ENTRA — o eixo `Moldura`, com `cartao` de default
**pai**: ds-diletta **v3.28.0** · `web-v3.28.0` · **data**: 2026-11-13

### O que decidiu
`moldura="nenhuma"` (Dart: `DilettaEmptyStateMoldura.nenhuma`) tira borda, fundo e raio, e mantém o recuo e o
miolo. O default continua o cartão. O segundo consumidor é o próprio pai: o `_NadaComOTermo` do seletor passou
a `nenhuma`, e a folha perdeu a borda dupla.

### O que eu achei indo implementar
O achado à parte procede. A spec segue o verbete agora: a peça serve `vazio`, e só ele. «Internet Banking
indisponível» e «Não foi possível abrir esta tela» são falha, e não trocam por esta peça. «Gráfico
indisponível» também é falha.

### Os sete critérios

| critério | | |
|---|:-:|---|
| manutenção | ↑ | sem `::part(cartao)` por fora |
| escalabilidade | ↑ | 61 vazios em tabela no console |
| aplicação | ↑ | 18 sítios do IB e o seletor do pai |
| aderência ao mercado | ↑ | Polaris e Atlassian não desenham moldura |
| robustez | = | o default desenha igual a hoje |
| arquitetura limpa e simples | ↑ | eixo, e não uma peça nova |
| conciso | = | um requisito e duas linhas de escolha |

### O que você faz
`ref: web-v3.28.0`. `moldura="nenhuma"` nos 18 sítios, menos as três falhas. A regra `.card .card` pode sair
quando o último vazio local for embora.
