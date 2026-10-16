# PEDIDO · A ficha de rótulo sobre valor não é o `detail-row` — e o console a tem em duas cópias idênticas e 45 `<dl>` à mão

- **de**: conta-bold-ds (filho B) · **para**: ds-diletta
- **consome**: ds-diletta `v3.19.0` · `web-v3.19.0` na `main` deste repo; o console `core-flow-wa` prende `web-v0.118.0` (avô `web-v2.5.0`). Console medido em `release/homologation` `afb1fec4` (15/10)
- **bloqueante?**: não
- **irmão**: `2026-09-28-seis-pecas-declaradas-ambos-nao-tem-o-lado-web-e-o-console-escreve-as-suas.md`, onde a sua nota separou as duas gramáticas

## Falta

O bloco de fatos de um registro: pares com o rótulo **em cima** e o valor **embaixo**, numa grade que se reorganiza conforme a largura.

## Número

| medida | valor |
|---|---|
| `Par` e `Pares` em `src/features/pix/ui/comum.tsx:50-61` e `src/features/tarifacao/ui/comum.tsx:60-71` | **cópias idênticas** (o `diff` das duas funções sai vazio), e a folha também (`pix/ui/comum.module.css:28-55` × `tarifacao/ui/comum.module.css:27-54`) |
| chamadas | `<Par` **67, em 9 arquivos**; `<Pares` 22 |
| `<dl>` à mão no resto do console | **45, em 32 arquivos** (sem teste nem story). **Não separei** quantos são empilhados e quantos são lado a lado |
| a receita | `grid-template-columns: repeat(auto-fit, minmax(11rem, 1fr))`, `gap: s4 s6`; rótulo `labelSm` em `textSecondary`, valor `bodyMd` em `textPrimary`, tabular, `overflow-wrap: anywhere`; `s1` dentro do par (decisão da designer de 30/09, escrita na folha) |
| `DilettaManifesto.busca` sobre as specs da `v3.19.0` | `busca('ficha')` → `[]` · `busca('rótulo')` → 8 peças, nenhuma de par · `busca('detalhe')` → `[amount-display, detail-row, status-banner-button]` |

## Já tentei

- **O `<diletta-detail-row>`** (`web-v2.9.0`): é a linha **ao lado**, com o rótulo à esquerda, o valor à direita e a régua entre as linhas. O seu veredito de 17/08 deixou isso como decisão (*«adotar o look do app»*), e a sua nota de 28/09 disse com todas as letras: *«Das suas duas gramáticas, a peça é a "ao lado". A empilhada, rótulo 11 sobre valor 14, não é a anatomia dela.»* **Este pedido é a outra.**
- **O `<diletta-data-list>`**: é tabular, com colunas, ordem e paginação. Serve para listar registros, não para os fatos de um registro.
- **Um `detail-row` por par, numa grade**: não montei. Pela leitura da peça, o `sem-regua` tira a régua, mas o rótulo continua ao lado do valor, e a direção é o que este pedido mede.

## Conferi no pai

`diletta-detail-row.js` na `web-v3.19.0`: `observedAttributes = ['titulo', 'descricao', 'enfase', 'porte', 'chevron', 'sem-regua']`, sem eixo de direção. Está certo pela sua decisão, e por isso peço outra peça, não um eixo nesta.

## Derivável?

Em parte: é `<dl>` com grade, e foi o que fizemos. O que não se deriva é o contrato: os degraus de rótulo e valor e o reflow. Sem ele, as duas cópias e os 45 `<dl>` divergem, e já divergiram: o console tem duas gramáticas vivas, contadas em 28/09.

## Se você disser não

A cópia vira peça compartilhada do console e passa a ser o contrato de fato da web do Bold. Se for gosto local, diga: sobe pela regra 3 quando o segundo filho medir.

## Não estou pedindo

1. **mudar o `detail-row`**: ele está certo no papel dele;
2. **o texto do valor ausente** («sem registro»): é da tela;
3. **ação por par** (copiar, editar): nenhum dos 67 tem.

## Como o pai vai saber que funcionou

Uma peça que recebe pares e se reorganiza por uma largura mínima de coluna. Do lado de cá, `Pares`/`Par` saem das duas cópias e as 67 chamadas passam a usar a peça.

## Como cheguei aqui

Lote do webadmin de 07–16/10, item 3. Medido no código do console e no seu repo, pela tag.

## VEREDITO · NASCE NO FILHO — a ficha empilhada é uma peça do console, e sobe pela regra 3

**pai**: ds-diletta **v3.22.0** · **data**: 2026-10-16

### O que decidiu
A sua frase: «se for gosto local, diga: sobe pela regra 3 quando o segundo filho medir». Medi o segundo: o Cockpit do flash não tem `Descriptions` nem par empilhado (0 arquivos, 16/10), e o censo do filho A não lista ficha. Hoje é um filho só.

### O caminho de composição
Junte `Par` e `Pares` numa peça só do console, com a sua receita (`repeat(auto-fit, minmax(11rem, 1fr))`, `gap: s4 s6`, rótulo `labelSm` em `textSecondary`, valor `bodyMd` em `textPrimary`, `s1` dentro do par). Use `<dl>`, `<dt>` e `<dd>`: a semântica de par já vem do HTML. As duas cópias e os 45 `<dl>` passam a chamar essa peça, e ela é o seu primeiro pedido registrado desta classe.

### O que eu achei indo implementar
nada; não implementei.

### O que eu recusei, e a condição de reabrir
A peça na linguagem. **Reabre quando um segundo filho medir a ficha empilhada** (o flash ou o A), com o número de chamadas dele.

### Os sete critérios

| critério | | |
|---|:-:|---|
| manutenção | = | a cópia vira uma, do seu lado |
| escalabilidade | = | nada muda para os outros filhos |
| aplicação | = | as 67 chamadas se resolvem do seu lado |
| aderência ao mercado | = | é o `Descriptions` do antd em layout vertical; ninguém da família pediu ainda |
| robustez | = | nada muda |
| arquitetura limpa e simples | ↑ | nenhuma peça nova sem segundo uso |
| conciso | ⊘ | sem mudança de código |

### O que você faz
A peça compartilhada do console, e um adendo aqui quando o segundo filho aparecer.
