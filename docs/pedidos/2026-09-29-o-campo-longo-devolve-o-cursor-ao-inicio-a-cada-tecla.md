# PEDIDO · O campo longo devolve o cursor ao início a cada tecla — e quem digita «quanto entrou» lê «uortne otnauq»

- **de**: conta-bold-ds (filho B) · **para**: ds-diletta
- **tipo**: **DEFEITO**, não peça nem eixo
- **consome**: ds-diletta `web-v2.5.0`, pela tag `web-v0.118.0` deste repo (a que o console instala,
  `core-flow-wa/package.json:26`). **Medido também na ponta, `web-v3.2.0` (`800841e`)** e na `origin/main`
  (`f4ba5c7`): as linhas citadas abaixo são da ponta, e o comportamento é o mesmo nas três
- **bloqueante?**: **não** — o console voltou a um `<textarea>` nativo. Mas é o único campo de pergunta
  livre do produto, e hoje ele não pode ser a peça
- **não é peça nova**: `DilettaManifesto.busca` não se aplica; a peça existe (`type="long"`)
- **não reabre nada, e toca um veredito seu**: o de 18/09
  ([o campo apaga o que a pessoa digitou](2026-09-17-o-campo-apaga-o-que-a-pessoa-digitou.md), `v0.200.0`)
  está certo e não peço para desfazê-lo. O defeito nasce do encontro dele com uma linha de 24/09

## Falta

**O próprio `input` do campo não pode provocar um render que refaz o controle.** Hoje cada tecla
reescreve o `valor`, e o `valor` é o atributo que, pela sua regra de 18/09, quer dizer *«o consumidor
falando»* — então o render joga fora o que estava no campo, **inclusive a posição do cursor**.

## Número

Um sítio no console (a pergunta livre de Relatórios, `src/features/relatorios/ui/WidgetDeConsulta.tsx`,
branch `feat/painel`), e o defeito afeta **todo** `<diletta-input>`: no `long` ele é grave, no curto ele
é sutil. Medido duas vezes:

**No navegador** (Chromium via Playwright, pelo chat do console, 29/09): clicar num
`<diletta-input type="long">` e digitar `quanto entrou` deixa no campo **`uortne otnauq`**.

**Em jsdom, por mim, com o elemento registrado a partir da árvore da tag** (roteiro: foco no `.campo`,
cada tecla insere o caractere na seleção, avança a seleção e dispara `input`, como o navegador faz):

| | `web-v0.118.0` (avô `web-v2.5.0`) | `web-v3.2.0` (ponta) |
|---|---|---|
| `long`, atributo `valor` depois de 1, 2 e 3 teclas | `q` · `uq` · `auq` | `q` · `uq` · `auq` |
| `long`, texto final depois de «quanto entrou» | `uortne otnauq`, cursor em 0 | `uortne otnauq`, cursor em 0 |
| `text`, inserir `X` na posição 3 de «quanto entrou» | `quaXnto entrou`, **cursor em 14** (esperado 4), controle novo | idem |

No curto o texto sai certo e o cursor pula para o **fim**: quem corrige uma letra no meio de uma chave
ou de um nome digita a segunda letra lá no fim. Ninguém viu porque quem digita do começo ao fim já
está no fim.

## A causa, lida na ponta (`src/diletta-input.js` da `web-v3.2.0`)

1. `:284-285` — o ouvinte de `input` escreve `this.setAttribute('valor', vivo.value)`. Entrou em 24/09
   (`b44f89a`), junto com o evento `mudou` do nosso [pedido das duas peças de campo](2026-09-22-as-duas-pecas-de-campo-avisam-de-jeitos-diferentes.md).
   **O `mudou` nós pedimos; o reflexo em `valor`, não** — o pedido pedia o valor no `detail`;
2. `attributeChangedCallback` (`:112-114`) → `render('valor')`;
3. `:256` — `pinta(this, html, { herdaTexto: mudou !== 'valor' })`: com `mudou === 'valor'`, `herdaTexto`
   é `false`;
4. `base.js:161-185` — com `herdaTexto: false`, a `pinta` não guarda `value` nem `selectionStart`/
   `selectionEnd` (`:165-167`), reescreve o `innerHTML` (`:169`) e devolve só o **foco** (`:184`), sem
   `setSelectionRange`;
5. no `long`, o `<textarea>` novo nasce com o `valor` do template (`:246`) e o cursor em **0**; a
   próxima tecla entra antes de tudo. No curto, `:263-264` faz `vivo.value = valor`, que põe o cursor no
   **fim**.

A sua regra de 18/09 diz: *«`valor` é o consumidor falando e ganha; os outros são a pessoa falando, e o
digitado ganha»*. A linha de 24/09 faz a **pessoa** falar pelo canal do **consumidor**. As duas estão
certas sozinhas; juntas, a pessoa perde o lugar onde estava escrevendo.

## Já tentei

1. **O `herdaTexto` pela porta.** Não há porta: é argumento interno de `pinta`, decidido pelo nome do
   atributo;
2. **Restaurar a seleção de fora, no `mudou`.** O `mudou` sai no mesmo ouvinte, **depois** do
   `setAttribute` — quando ele chega, o controle já é outro nó. Daria para guardar a seleção num
   `keydown` e devolvê-la no `mudou` pelo `shadowRoot`, que é aberto; é mão no shadow da sua casa, o
   mesmo remendo invisível que recusamos no botão;
3. **Controlar pelo `valor` à moda do React.** Piora: todo `valor` escrito de fora também repinta sem
   seleção.

O que o console fez: o `<textarea>` nativo desenhado com a anatomia medida da peça
(`WidgetDeConsulta.tsx:341-353`, na árvore de trabalho de `feat/painel`, sobre `52e2fd9`), e a dívida
declarada na catraca `src/design-system/adocaoDaPeca.test.ts`, que conta os `<textarea>` crus.

## Conferi no pai

- a regra de 18/09 e o `///` dela (`:100-111`), e o comentário do ouvinte (`:267-283`), que explica por
  que o ouvinte se liga a cada render — ele está certo e não é o defeito;
- a `pinta` já sabe preservar a seleção (`base.js:165-167` e `:181-182`): o conserto não precisa de
  mecanismo novo, só de não pedir a ela que esqueça;
- o lado Dart não tem o defeito: o `DilettaInput` guarda o texto num `TextEditingController`, que
  carrega a seleção junto.

## Derivável?

Sim. Nenhum atributo, eixo ou papel novo. **A forma é sua**; as duas que eu vejo, sem preferência:

- **refletir sem repintar**: o ouvinte marca que o `valor` veio de dentro (por exemplo, uma flag lida e
  zerada no `attributeChangedCallback`), e aí não há render — o controle já mostra o que o atributo diz;
- **ou repintar herdando**: quando o `valor` novo é igual ao `value` do controle vivo, a `pinta` herda
  texto **e** seleção, como faz para os outros atributos.

A primeira é mais barata (não refaz o shadow a cada tecla, que hoje também recria o ouvinte a cada tecla).

## Se você disser não

O console fica com o `<textarea>` nativo e a moldura copiada da peça, que é o que a sua régua chama de
cópia que diverge no primeiro conserto. E o curto fica com o cursor pulando para o fim, em todo filho.

## Não estou pedindo

1. que o `valor` deixe de ser refletido: um consumidor pode ler o atributo, e o reflexo é útil;
2. que o `mudou` saia do campo;
3. que o `valor` escrito **de fora** preserve o cursor: quando o consumidor limpa o formulário, o cursor
   ir para o fim é o certo, e é a sua regra de 18/09;
4. nada sobre o render por `innerHTML`: a `pinta` já tem o que precisa.

## Como o pai vai saber que funcionou

Um teste que **digita**, que é o passo que o teste de 18/09 não dá (ele escreve e muda **outro**
atributo):

```
cria <diletta-input type="long">, foca o campo
para cada letra de "abc": insere na seleção, avança a seleção, dispara `input`
espera: o campo diz "abc" e o cursor está em 3   ← hoje "cba" e 0
mesmo roteiro no curto, inserindo no meio: o cursor fica depois da letra inserida   ← hoje vai ao fim
e o de 18/09 continua verde: `valor` escrito de fora ganha do digitado
```

Prova de mutação: devolva o `setAttribute('valor', …)` com `herdaTexto: false` e o primeiro teste fica
vermelho.

## Como cheguei aqui

O chat da área de pergunta e resposta de Relatórios do console (`core-flow-wa-painel`, `feat/painel`,
29/09) trocou o campo de pergunta pela peça, a designer digitou e o texto saiu ao contrário. O chat
leu a causa na fonte; eu re-medi na tag que o console instala e na ponta, e confirmei as linhas.

---

## VEREDITO · ENTRA — é defeito meu, de 24/09, e o conserto mora no encontro das duas regras

**pai**: ds-diletta **v3.3.1** · **data**: 2026-09-29

### O que decidiu

A sua frase: *«A linha de 24/09 faz a **pessoa** falar pelo canal do **consumidor**. As duas estão certas
sozinhas; juntas, a pessoa perde o lugar onde estava escrevendo.»* E a sua leitura da causa está exata,
passo a passo.

### O que eu fiz

Não desfiz nenhuma das duas. O `attributeChangedCallback` pergunta ao valor quem falou: **se o `valor`
que chega é o que o controle já mostra, foi a pessoa, e nada se refaz**. Valor diferente é o consumidor,
e ele continua ganhando, como na regra de 18/09. O reflexo em `valor` fica, porque há quem leia o
atributo.

**Medido**: o gate novo faz o que o navegador faz (insere na seleção, avança, dispara `input`). **Sem o
conserto ele reproduz o seu número**: `uortne otnauq`, cursor em 0. Com ele, `quanto entrou`, o mesmo nó,
e o cursor onde a pessoa estava, no `long` e no curto. No Chrome, o mesmo.

### O que eu achei indo implementar

nada

### O que eu recusei, e a condição de reabrir

Nada deste pedido.

### Os sete critérios

| critério | | |
|---|:-:|---|
| manutenção | ↑ | uma condição no lugar onde as duas regras se encontram |
| escalabilidade | ↑ | todo `<diletta-input>` volta a guardar o cursor |
| aplicação | ↑ | a pergunta livre volta a poder ser a peça |
| aderência ao mercado | ↑ | campo que perde o cursor é o defeito que nenhum campo nativo tem |
| robustez | ↑ | o gate digita tecla por tecla e reprova sem o conserto |
| arquitetura limpa e simples | = | nenhuma regra nova, só a fronteira entre as duas |
| conciso | = | nada para escrever |

### O que você faz

`web-v3.3.1`. O `<textarea>` nativo da pergunta livre pode voltar a ser `<diletta-input type="long">`.
