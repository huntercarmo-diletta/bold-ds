# CONSELHO · o gate que trava o Cloudflare em zero, e ele roda no seu repo
**de**: ds-diletta v0.20.0 · **para**: conta-bold-ds · **data**: 2026-07-30

## O que eu recomendo

Pedido do dono do produto: *"trave o que precisar pra o que ele recebe nunca ser a mais do que o free."*

A trava que importa é ESTRUTURAL, e você já a tem: a sua `wrangler.jsonc` é **assets-only** — tem
`assets.directory` e **não tem `main`**.

| o que é servido | como conta |
|---|---|
| asset estático (sem `main`) | não é invocação de Worker: servir a página não depende de volume |
| script de Worker (`main:`) | cada requisição é invocação, e invocação tem cota diária no free |

**O momento em que isso deixaria de ser grátis por construção é o momento em que alguém acrescenta
`main:`.** É essa linha que o gate vigia — e ele reprova também binding de armazenamento (KV, D1, R2,
Durable Objects, Queues), produto pago (Hyperdrive, Vectorize, AI, Browser), `placement: smart`,
`usage_model` de plano pago e `assets.run_worker_first`.

## O que você faz

Rode antes de publicar, junto do build:

```bash
python3 <ds-diletta>/tool/nunca_pagar.py .
```

De brinde ele mede o que faria o **deploy falhar** (não cobra — impede publicar): número de arquivos
contra o limite de 20.000 do Workers Assets, e arquivo acima de 25 MB. Medido hoje no seu repo, os dois
estão longe do teto.

Se você tem um gate de publicação (`ci_test.sh` ou equivalente), esta é uma linha nova nele: um commit
pode introduzir `main` e o `wrangler deploy` publicaria sem reclamar.

## O que o gate NÃO vê, e é o que eu quero que você saiba

**A conta.** Plano, uso do mês, assentos do Zero Trust e faturamento vivem no dashboard, e nenhuma
checagem local sabe se alguém clicou em "upgrade" no navegador. A lista de conferência do dashboard está
em `ds-diletta/docs/NUNCA-PAGAR.md`, seção 4 — e ela é pra ser lida na conta de TRABALHO, não na pessoal.

## Como isso chega

Nada a sincronizar: é ferramenta do pai, roda apontando pro seu repo. Igual à limpa e à auditoria.

## Prazo

Nenhum, e nada a migrar. A sua config passa hoje.
