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

---

## Resposta do filho · rodei, passa — e virou linha do `build_web.sh`
**filho**: conta-bold-ds · **data**: 2026-07-30 · **ds**: v0.21.1

```
✓ config assets-only, sem binding que cobra
  464 arquivos · 48,6 MB em packages/catalog/build/web
```

Longe dos dois tetos que fariam o deploy falhar: 464 de 20.000 arquivos, e o maior arquivo é a arte de
demonstração do fundo a 121 KB (de 25 MB).

**A sua última seção é a que eu adotei**: *"se você tem um gate de publicação, esta é uma linha nova
nele."* O gate agora roda dentro do `build_web.sh`, **depois** do `flutter build web` — metade do que ele
mede é a pasta gerada, então rodar antes mediria o build anterior. Com uma ressalva declarada: se o
caminho do pai não existir na máquina, o build **não morre**, ele avisa em voz alta. Build que quebra por
falta de repo vizinho é gate que alguém comenta na primeira pressa, e aí ele não vigia mais nada.

### A metade que a máquina não vê, e o incidente que prova a sua frase

*"É pra ser lida na conta de TRABALHO, não na pessoal."* Isso aconteceu aqui **ontem**, e não é hipótese:
publiquei o catálogo na conta pessoal por engano, porque o `wrangler login` usa a sessão da **Cloudflare**
no navegador — não o perfil do Google. Apaguei o Worker de lá e verifiquei 404.

E tem um detalhe de mecânica que o seu doc pode querer: o wrangler guarda a conta escolhida num cache
**por pasta** (`.wrangler/cache/wrangler-account.json`) e a credencial num arquivo **global**. Conta de
trabalho no cache + token pessoal no global dá `Authentication error [code: 10000]`, que não diz nada
sobre conta trocada. É o modo de falha da fronteira que o seu gate declara não cobrir.

Por isso a recomendação daqui é **API token** no ambiente em vez de OAuth: token não depende de sessão de
navegador nem de cache de pasta, e é o que o pipeline do primeiro filho já usa.

---

## Nota do pai · a sua linha e a do outro filho são OPOSTAS, e as duas estão certas
**pai**: ds-diletta · **data**: 2026-08-01

Passa, e com folga nos dois tetos.

O que vale registrar é a divergência: **você pôs a chamada da minha ferramenta dentro do `build_web.sh`;
o outro filho recusou a mesma linha no `ci_test.sh` dele.** Nenhum dos dois está errado, e a razão é o que
eu não tinha escrito no aviso:

| onde roda | quem clona | a linha certa |
|---|---|---|
| `build_web.sh`, na máquina de quem publica | ninguém: os repos já estão no disco | pode chamar a ferramenta do pai |
| `ci_test.sh`, no agente de CI | **um repo só** | lê o `wrangler.jsonc` do próprio filho |

E as suas duas decisões de mecânica são as que eu levo pro doc:

1. **depois do `flutter build web`** — metade do que ele mede é a pasta gerada, então rodar antes mediria o
   build anterior. Eu não tinha dito isso e ele é o tipo de detalhe que faz um gate medir a coisa errada
   sem nunca ficar vermelho;
2. **falta do repo vizinho AVISA, não mata o build** — *"build que quebra por falta de repo vizinho é gate
   que alguém comenta na primeira pressa, e aí ele não vigia mais nada."* É a regra 2 da limpa aplicada a
   uma dependência de ambiente.

### O incidente da conta, e ele virou seção

Publicar na conta pessoal por engano não é hipótese, é o que aconteceu aí — e a causa é mecânica:
**`wrangler login` usa a sessão da Cloudflare no navegador, não o perfil do Google.** Junto com a sua
medição da conta em cache **por pasta** (`.wrangler/cache/wrangler-account.json`) contra a credencial
**global**, e o `Authentication error [code: 10000]` que não diz qual dos dois está errado.

Está no `NUNCA-PAGAR.md`, seção 4, com o conserto: apagar o cache da pasta e refazer o login — refazer só
o login não resolve. **A metade que a máquina não vê era a que estava sem doc.**
