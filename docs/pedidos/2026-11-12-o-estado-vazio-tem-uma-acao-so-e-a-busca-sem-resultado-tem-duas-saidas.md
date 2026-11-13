# PEDIDO · O estado vazio tem uma ação só, e a busca sem resultado numa lista aberta tem duas saídas: afrouxar e criar

- **de**: conta-bold-ds (filho B) · **para**: ds-diletta
- **consome**: ds-diletta `v3.27.0` · `web-v3.27.0`, pela `web-v0.130.0` deste repo. É o que o Internet Banking `core-flow-ib` tem na homologação de 12/11 (`562bacbf`)
- **bloqueante?**: não. O IB troca o vazio local pela peça nos usos de uma ação só, e os dois daqui ficam com a peça local até o veredito
- **irmão**: `2026-11-12-o-estado-vazio-sempre-desenha-o-cartao-e-dentro-de-outra-moldura-vira-moldura-dupla.md`. Os dois saíram da mesma passada, a adoção do `<diletta-empty-state>` no IB, e um não depende do outro

## Falta

O `<diletta-empty-state>` (e o `DilettaEmptyState`) aceita uma ação. Quando a lista vazia tem dois caminhos, o segundo fica sem lugar na peça.

## Número

São dois sítios no IB, e o primeiro é o que importa.

**1. A busca sem resultado do Risco sacado** (`RiscoSacadoScreen.tsx:216`), nas visões de fornecedores e de notas:

| visão | título | legenda | as duas saídas |
|---|---|---|---|
| fornecedores | «Nenhum fornecedor encontrado para “{termo}”» | «Confira o nome ou o CNPJ/CPF. Se for um fornecedor novo, cadastre agora.» | «Limpar busca» e «Cadastrar fornecedor», que abre o cadastro com o termo já preenchido (no nome, ou no documento quando o termo é número) |
| notas | «Nenhuma nota encontrada para “{termo}”» | «Confira o número da nota ou o CNPJ do fornecedor. Se a nota ainda não foi enviada, cadastre agora.» | «Limpar busca» e «Cadastrar nota fiscal» |

É a situação `buscaSemResultado` da linguagem numa lista **aberta**, onde o item que falta pode ser criado ali. A regra da casa cobra as duas coisas: «a busca cita o filtro» e diz como afrouxar, e «toda situação abre caminho». Hoje são dois botões no mesmo vazio.

**2. O detalhe de lote fora do canal** (`LoteDetalheScreen.tsx:32`): «O detalhe do lote ainda não abre no Internet Banking», com «Ver em Lotes da conta» (principal) e «Ver em Pagamentos» (secundário, link). Conto à parte porque **pode não ser `vazio`**. Ninguém errou e a fonte não caiu: a rota não existe neste canal. Se o pai disser que essa tela não é da peça, o número fica em um.

**No console** (`core-flow-wa`, `release/homologation` de 12/11), o `EstadoVazio` local tem 140 chamadas em 73 arquivos, e nenhuma leva duas ações. Não conto o console aqui.

## Já tentei

- **A segunda ação fora da peça,** num botão logo abaixo do `<diletta-empty-state>`. Funciona, e põe a segunda saída fora do cartão, longe da legenda que a explica («Se for um fornecedor novo, cadastre agora.»). Na lista sem moldura, as duas saídas de um mesmo vazio passam a parecer de lugares diferentes.
- **Ficar só com «Cadastrar fornecedor».** O «Limpar busca» da linha de resultado só aparece quando há resultado. Sem o do vazio, a saída fica no próprio campo: apagar o texto, ou o ✕ do campo de busca nos navegadores que o mostram. É justamente a saída que a regra `escassez-busca-cita-o-filtro` manda mostrar junto do vazio.
- **Ficar só com «Limpar busca».** O cadastro continua no topo da página, mas em branco: perde-se o termo que a pessoa já digitou, e com ele o caminho curto que a legenda promete.
- **Pôr as duas no slot.** O `<diletta-empty-state>` só tem o slot `ilustracao`, no topo, e não um lugar para conteúdo depois da legenda.

## Conferi no pai

- **`diletta-empty-state.js` da `web-v3.27.0`:** `acao` é um atributo de texto que vira um `<diletta-button size="md">` e emite `acao`. Não há segunda ação nem slot depois da legenda. A régua dos dois lados declara `acao = actionLabel` e `onAction` como evento.
- **`diletta_empty_state.dart` da `v3.27.0`:** `actionLabel` + `onAction`, um `DilettaButton` primário. O `///` diz «empty-state acionável (ex.: "Tentar de novo", "Adicionar")», com uma ação.
- **`docs/OS-QUATRO-ESTADOS.md`:** a seção da escassez traz as três funções da NN/g para um vazio: contar o estado, ensinar no contexto e **abrir caminho para a próxima tarefa**. O exemplo do Loggly tem duas saídas, «adicionar fonte» ou «explorar dado de demonstração».
- **`_NadaComOTermo` em `diletta_dropdown.dart`:** o pai já resolveu a busca sem resultado numa lista **fechada**, onde a única saída é apagar o texto: «não há filtro pra limpar, há texto pra apagar». O nosso caso é a lista aberta, e nela a segunda saída existe.

## Derivável?

Não do que declaro. A peça recebe um rótulo e emite um evento. O segundo caminho não sai do primeiro.

## Se você disser não

O IB tem dois caminhos.
- **Fica com o vazio local nesses dois sítios,** e a família do IB passa a ter dois desenhos de vazio, o da peça e o local.
- **Reduz a uma ação:** a que sai é o «Limpar busca», e o «Cadastrar fornecedor» fica com o termo preenchido.

A decisão entre os dois é do IB. O custo de qualquer um é o mesmo: a busca sem resultado deixa de mostrar uma das saídas que a regra da casa cobra.

## Não estou pedindo

1. **Uma forma específica.** Pode ser uma segunda ação com peso menor (texto ou link), um slot depois da legenda, ou outra coisa. No mercado, o `EmptyState` do Polaris tem `action` e `secondaryAction`, e o do Atlassian tem `primaryAction`, `secondaryAction` e `tertiaryAction`. A escolha é da linguagem.
2. **Duas ações primárias.** A segunda tem que pesar menos que a primeira, senão a pessoa não sabe qual é o caminho principal.
3. **Mudar o botão que já existe.** O `md` primário fica.

## Como o pai vai saber que funcionou

No teste do pai, um vazio com as duas saídas da busca sem resultado («Limpar busca» e «Cadastrar fornecedor»):
1. as duas aparecem depois da legenda, com pesos diferentes;
2. cada uma avisa por evento ou callback próprio;
3. as duas entram na ordem do Tab, a principal antes da secundária.

Do lado do IB, o vazio da busca do Risco sacado vira a peça.

## Como cheguei aqui

Na adoção do `<diletta-empty-state>` no IB, em 12/11. A Tatiana decidiu trocar o vazio local pela peça da linguagem, revendo o «fica local» de 16/10. O levantamento varreu as 59 chamadas do `BoldEmptyState`, em 42 arquivos, e separou as que têm conteúdo depois da legenda. Das 4 que têm, 2 são um link só (viram a `acao`), e 2 são os sítios acima.

## VEREDITO · ENTRA — a segunda saída, `tertiary`, ao lado da principal
**pai**: ds-diletta **v3.28.0** · `web-v3.28.0` · **data**: 2026-11-13

### O que decidiu
`acao-secundaria` e o evento `acao-secundaria` (Dart: `secondaryActionLabel` + `onSecondaryAction`). A forma é do
Hunter: `tertiary` `md` na mesma linha, depois da principal no Tab, e a linha quebra no estreito.

### O que eu achei indo implementar
O lote fora do canal (`LoteDetalheScreen`) não é `vazio`: ninguém pode criar nada ali, e a rota só não existe.
Ele cabe na peça com as duas ações, mas a escolha de peça é sua.

### Os sete critérios

| critério | | |
|---|:-:|---|
| manutenção | = | dois parâmetros, sem slot livre |
| escalabilidade | ↑ | toda lista aberta com busca |
| aplicação | ↑ | Risco sacado do IB; adota o filho B |
| aderência ao mercado | ↑ | Polaris `secondaryAction`, Atlassian |
| robustez | = | um evento por saída |
| arquitetura limpa e simples | = | um `Wrap` no Dart, um `flex` na web |
| conciso | = | um requisito na spec |

### O que você faz
`ref: web-v3.28.0`. «Cadastrar fornecedor» em `acao` e «Limpar busca» em `acao-secundaria`.
