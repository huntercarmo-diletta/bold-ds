# PEDIDO · O loop de adoção do filho B parou em 22/09 — 48 linhas em setembro, zero depois, e o pai cortou onze tags

- **de**: conta-bold-ds (filho B) · **para**: ds-diletta
- **consome**: ds-diletta `v0.207.0` · `web-v0.207.1`, pela tag `web-v0.114.0` deste repo; o pai está em `v2.1.0` · `web-v2.4.2`
- **bloqueante?**: **não bloqueia tela** — bloqueia a ADOÇÃO: dez pedidos escritos e dois ENTRA sem tag são dez remendos e duas cópias que continuam vivos no consumidor. É cobrança de entrega (critério #5), não de peça.

## Falta

O loop de adoção deste filho voltar a fechar: pedido escrito → recebido no ledger → julgado → o que
ENTRA sai em tag → o filho adota e mede → fechamento de quatro linhas. Cada elo existe no contrato
(`PEDIDO-DO-FILHO.md`, `FECHAMENTO-DE-CICLO.md`); o que falta é o loop rodar de novo para o B, como
rodou o mês inteiro e como roda para o A todo dia.

## Número

Contado no `ds-diletta/docs/PEDIDOS.md` (`main`, `4ce0bd3`, 24/09) e neste repo:

| medida | filho A | filho B |
|---|---|---|
| linhas no ledger do pai em setembro | 16 | **48** |
| «respondido no mesmo dia» em setembro | **9** | 0 |
| última linha no ledger do pai | **24/09** | **22/09** |
| linhas de B por dia, 14→22/09 | — | 4 · 3 · 4 · 6 · 7 · 2 · 6 · **9** |
| pedidos escritos e pushados por B depois de 22/09, sem linha no ledger | — | **10** (`docs/pedidos/2026-09-2{2,3,4}-*.md`) |
| vereditos ENTRA de 22/09 ainda sem tag web | — | **2** (porte `sm`/`md` do campo; `date-field` para `ambos`) |
| tags do pai de 23 a 24/09 | `v0.208.0` → `v2.1.0`, `web-v2.4.0` → `web-v2.4.2` | **11**, nenhuma cita B |

O loop de B não era lento: em 22/09 fechou nove linhas num dia. Parou no dia seguinte.

## Já tentei

- **Escrever no formato.** Os dez têm as oito seções, número medido, e pedem o problema; conferi um
  a um contra «o que invalida na entrada».
- **Consertar o que era nosso.** Cinco dos dez se assinavam `filho A` no cabeçalho até 23/09 —
  quem os lesse os tomaria pela CPF Seguro. Corrigido em `67233c1`. **Isto pode ser a causa do
  silêncio, e é culpa deste lado**; fica dito.
- **Medir a subida do pai.** A rotina `atualizacoes-ds` remediu os cinco defeitos na `v2.1.0`
  (`FILA-DOS-CHATS.md`, 23/09): continuam.
- **Preparar o sinal.** Há uma mensagem de sinal pronta com os dez caminhos, para a pessoa que dá
  o sinal. Ela ainda não foi dada; o contrato diz que é «alguém», e alguém ainda não foi.

O que **não** dá para tentar deste lado: fazer o ledger do pai ter linha, e fazer um ENTRA virar tag.

## Conferi no pai

- `PEDIDO-DO-FILHO.md`, «Como o pedido CHEGA»: o passo 2 é *«alguém dá o SINAL ao pai»*, e
  *«push não é entrega; entrega é a linha no ledger»*. O contrato prevê que o transporte perca
  pedido e diz que o filho pode mandar de novo sem constrangimento. Este pedido é o «mandar de
  novo», dos dez de uma vez.
- `PEDIDO-DO-FILHO.md`, critério #5: *«robustez… no código e na ENTREGA (tag, número, raiz,
  migração, aviso)»*, e a nota de 23/09: *«as falhas dos últimos dez dias não foram de código»*.
  Dois ENTRA sem tag em onze tags é exatamente essa classe.
- `PEDIDO-DO-FILHO.md`, veredito ENTRA: *«tag com CHANGELOG citando o pedido, e a linha no
  PEDIDOS.md»*. O porte do campo e o `date-field` têm a linha e não têm a tag.
- `FECHAMENTO-DE-CICLO.md`: o formato de quatro linhas para «pedido julgado, tag publicada, adoção
  feita». Existe; não foi usado com B desde 22/09.
- `PEDIDOS.md:129`: o pai roda «loop de melhoria» consigo mesmo — seis rodadas, medição própria. O
  mecanismo de rodada existe na casa.
- **Não há prazo no contrato**, nem para o filho nem para o pai, e não peço um (ver abaixo).

## Derivável?

Não. Um loop não se deriva de peça nenhuma; ou roda ou não roda.

## Se você disser não

O filho segue como está: dez pedidos com remendo declarado no consumidor (`::part`, cópias em TS
com gate, tokens de produto), e duas cópias do que já ENTROU. O webadmin entrega. O que se perde é
o que o ledger existe para garantir: a memória da família — «variante sobe no SEGUNDO pedido» não
dispara se o primeiro não tem linha, e o `ib` está escrevendo os mesmos pedidos em silêncio.

## Não estou pedindo

1. **prazo** — o contrato não dá prazo ao pai nem ao filho, e prazo vira cobrança disfarçada;
2. **prioridade sobre o A** — o A pediu e recebeu; está certo. Peço o mesmo loop, não a vez dele;
3. **um mecanismo** — canal, cron, rotina: é do pai decidir como o sinal deixa de depender de
   «alguém»;
4. **reabrir mérito** — os dez pedidos se defendem sozinhos; os dois ENTRA já foram julgados.

## Como o pai vai saber que funcionou

Três números, todos no ledger dele: linhas de B com data ≥ 24/09 (hoje zero); os dois ENTRA de 22/09
com tag citada na coluna «chegou em» (hoje `—`); e um fechamento de quatro linhas por rodada. O
filho responde com o dele: `breakpoints.ts` vira reexport, os `::part` somem, `nomes.test.ts` perde
os tokens que eram cópia — cada um é um `grep` que hoje devolve um número e passa a devolver zero.
