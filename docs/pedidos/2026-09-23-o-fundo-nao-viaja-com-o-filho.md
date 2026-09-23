# PEDIDO · o fundo não viaja com o filho — e a escolha do cliente é transcrita à mão duas vezes

## O caso, em uma linha

Os tokens viajam com o filho; o FUNDO não. A lista de fundos que o cliente marcou no Berço é
copiada à mão para o tenant do app e, agora, para o do Internet Banking — e a arte de cada um é
calculada num terceiro lugar, que se declara andaime.

## Medido, e é o que dá o tamanho do problema

O gerador não conhece o Berço. `dart run coreflow:novo_filho` recebe `--id --nome --cor --saida`, e
nenhuma das três palavras — `manifesto`, `fundosOferecidos`, `berco` — aparece no
`packages/coreflow/bin/novo_filho.dart`.

O caminho de hoje, para UMA decisão do cliente:

```
Berço          manifesto.material.fundosOferecidos, material.fundo   (a escolha, com auditoria)
  ↓ à mão
app-newbold    lib/core/tenant/tenants/nortebenk.dart
               backdrops: [OpcaoDeFundo(…, 'Brilho'), OpcaoDeFundo(…, 'Vidro frio'), …]
  ↓ à mão
ib             src/config/tenants/nortebenk.ts
               fundos: [{ id: 'brilho-rosa', rotulo: 'Brilho' }, …]
```

E a ARTE, que o Berço calcula, é recalculada em `app-newbold`:
`lib/core/theme/arte_de_fundo_gerada.dart` — que diz de si mesmo, na primeira linha, que é **andaime**
do pedido de 18/09 e *«quando o pai desenhar os fundos, este arquivo sai»*.

## O que aconteceu quando o segundo consumidor chegou

O IB foi implementar fundo por marca em 23/09 e reproduziu o padrão inteiro: transcreveu a lista,
e **começou a escrever o quarto cálculo** — uma reimplementação em TypeScript do `tetoDeAlpha` do
auditor do Berço (11/09), para poder aplicar o teto de contraste que o app aplica em Dart.

Isso foi revertido antes de subir, e a reversão é o que motiva este pedido: **não é o consumidor que
tem de recalcular a arte.** Quando o terceiro filho nascer, a conta estaria em cinco lugares.

O que ficou de pé no IB é só o que não depende de ninguém: cada marca declara os fundos que oferece,
a preferência gravada é aparada para essa lista, e um gate confere se a folha daquela marca publica
os tokens que os fundos oferecidos pedem.

## O que pedimos

**Que o fundo viaje com o filho, como os tokens viajam.** A forma é sua; o que falta é o dado
existir do nosso lado:

- **a lista** — quais fundos aquele filho oferece, na ordem do cliente, com o rótulo que ele
  escolheu («Brilho» e não «Brilho rosa», numa marca azul) e qual é o padrão;
- **a receita de cada um** — base, brilhos, posições e alfas, já passados pelo auditor. O teto de
  contraste é do Berço e é aplicado na origem, onde a paleta e a base foram escolhidas juntas.

Com isso, app e IB **consomem**. Hoje os dois transcrevem, e o único que calcula diz que não deveria.

## O que NÃO pedimos

Não pedimos que o pai desenhe os três fundos do Berço que ele ainda não tem (`degradeSimples`,
`harmoniaAnaloga`, `harmoniaComplementar`) — isso já é o pedido de 18/09 e está em curso. Este é o
degrau anterior: que a ESCOLHA e a RECEITA cheguem ao filho, seja qual for o conjunto desenhado.

## O que não sabemos

**Se o manifesto do Berço é acessível ao gerador.** Vemos o nome dele citado no app e no
`coreflow_scheme.dart`, e não sabemos se ele é arquivo, serviço ou passo manual — nem se a ligação
que falta é técnica ou de processo. Dizemos o que medimos.

## Os seis critérios

| critério | | |
|---|:-:|---|
| manutenção | ↑ | uma decisão do cliente em um lugar, contra duas transcrições e um recálculo hoje |
| escalabilidade | ↑ | o terceiro filho recebe o fundo dele sem ninguém transcrever nada; sem isto, a conta vai a cinco lugares |
| aplicação | ↑ | o fundo que a pessoa vê passa a ser o que o cliente aprovou, e não a cópia mais recente que alguém fez |
| aderência ao mercado | ↑ | é o que o resto do DS já faz: o token viaja no pacote, o consumidor não recalcula |
| robustez | ↑ | o teto de contraste passa a ser aplicado UMA vez, na origem, com a paleta e a base escolhidas juntas — hoje um consumidor pode aplicá-lo com a base errada e não saber |
| arquitetura limpa e simples | ↑ | some o andaime do app, e não nasce o do IB |

Nenhum `↓`, e vale dizer por quê: não estamos pedindo capacidade nova. Estamos pedindo que um dado
que já existe, já auditado, atravesse a fronteira em vez de ser copiado nela.
