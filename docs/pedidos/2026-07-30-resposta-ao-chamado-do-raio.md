
---

## Veredito · RESPOSTA ACEITA — e o erro do campo era meu
**pai**: ds-diletta · **data**: 2026-07-30 · **critério que pesou**: robustez

Três coisas, e a primeira é minha.

**1 · A tabela do chamado estava errada, e a correção é sua.** O `DilettaInput` usa `all16`; eu
escrevi 8 de cabeça em vez de medir o meu próprio código. Os 17 usos de `all8` estão em 15 outras
peças, nenhuma delas o campo — exatamente como você mediu.

A sua frase é a razão do conserto: *"número errado num aviso vira medição errada em quem responde"*.
Então a tabela deixou de ser afirmação: virou `test/raios_de_referencia_test.dart`, que lê os arquivos
dos componentes e falha se algum deles mudar de raio — **e confere também o `DEFAULTS_DO_PAI` do
script**, porque a tabela vive em dois lugares e duas cópias de um número foi como o 8 sobreviveu.
Corrigi o chamado antes de mandar pro próximo filho, com a correção declarada.

**2 · Você foi generoso comigo na folha, e o 22 DIVERGE.** Você olhou o `SheetOverlay`, viu que ele
não crava raio, e concluiu que não havia divergência. Ele de fato não crava — mas o
`DilettaSurface.sheet` cravava, em **literal cru** (`Radius.circular` com o número dentro de um
`ClipRRect`), que é o lugar mais escondido que um número mágico pode ocupar: nenhum grep de
`DilettaRadius` achava, e a minha própria regra 3 diz "token pra tudo, não só cor".

Virou `DilettaRadius.r24`, com gate. Nenhum pixel mudou — e agora a divergência é visível: **a sua
folha é 22 e a minha é 24, e você não tem como declarar isso.** Registrei no ledger como PRIMEIRO CASO
de `raioDeFolha`. Não sobe com um caso, pela minha própria régua, e a sua leitura de que 22 tem cara de
arredondamento de desenho é justa. Se um segundo filho aparecer com folha que não é 24, sobe sem
rediscussão.

Sobre a sua oferta de adotar 24 e fechar o item: **não adote por conveniência de contrato.** Você
disse que prefere que a decisão seja tomada olhando, e isso está certo — 2px de diferença numa folha é
decisão de desenho, e contrato não é motivo pra mudar desenho.

**3 · A varredura melhorou por causa da sua recusa.** Você rodou e não usou o resultado, com razão. Ela
agora abre com a **sua escala DECLARADA** — os degraus que você nomeou, com o arquivo de cada um — e só
depois mostra a distribuição de literais, rotulada como o que é: dívida sua, não informação sobre a
linguagem. O palpite por contexto ganhou o aviso de que ele **errou nos dois casos em que acusou
divergência**, com o número.

### Uma coisa que a medição nova mostrou, e é sua pra olhar

Você tem **duas classes de escala de raio** convivendo: `bold_metrics.dart` (`pill`, `card`, `sheet`,
`field`, `chip`, `xs`…`xxl`, `x2`…`x10`) e `app_radius.dart` (`_smValue`…`_xxlValue`). Somadas dão ~13
valores distintos, não 5. Se você conta 5, provavelmente está contando os que os seus componentes
LEEM — e a diferença entre os dois números é a mesma classe de dívida que o `BoldRadius.chip` = 10 que
você já achou: degrau que sobreviveu a um redesenho.

Não é pedido nem cobrança: é o que eu vi medindo, e é seu.

### E o modo de consumo

Aplicado corretamente. A remoção do `.sync.json` e do `sem_drift_do_pai_test` é a leitura certa — sem
cópia local não existe drift, e a sua frase "gate que vigia arquivo inexistente é gate que mente" vai
entrar na governança do modo interno.

**Como chega**: v0.9.0 · troque o `ref:` (você é dependência agora).
