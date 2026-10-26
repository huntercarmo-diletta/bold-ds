# PEDIDO · A mensagem do aviso que fica some no escuro — e o aviso que aparece depois de uma ação não se anuncia

- **de**: conta-bold-ds (filho B) · **para**: ds-diletta
- **consome**: ds-diletta `v3.24.0` (pino do pai); `diletta_inline_alert.dart` é igual na `v3.25.0`
- **bloqueante?**: não; **sim para a WCAG 1.4.3** no modo escuro e para a **4.1.3** nos avisos de erro
- **irmão**: `2026-10-19-a-etiqueta-no-tom-de-marca-escreve-em-primary-e-no-escuro-some.md` (**ENTRA** na `v3.24.2`: *«o texto da etiqueta é a tinta do contêiner»*), `2026-10-19-o-erro-do-campo-aparece-e-nao-se-anuncia.md` (**ENTRA** na `v3.24.2`, a mesma 4.1.3) e `2026-09-22-o-papel-que-carrega-texto-de-corpo-tem-piso-de-texto-grande.md` (**ENTRA** na `v2.5.0`, o piso do `textTertiary`)

## Falta

1. **A tinta da mensagem.** O `DilettaInlineAlert` escreve a linha de apoio em `textTertiary` sobre o
   contêiner do tom (`errorSubtle`, `warningSubtle`, `successSubtle`). O piso do `textTertiary` é medido
   contra a **página** (veredito de 24/09), e o aviso o põe sobre um **contêiner tingido**. No escuro, o
   contêiner é escuro e saturado, e a mensagem cai para 2 a 3:1.
2. **O anúncio.** A peça não tem `liveRegion`, por decisão escrita (`:76-79`): *«este já está na tela
   quando a pessoa chega»*. Serve ao aviso estático. Não serve ao aviso que **aparece** depois de um
   envio, enquanto a pessoa está no botão.

## Número

**1 · A tinta, medida no esquema real (teste no pino `v3.24.0`), mensagem 13/400:**

| paleta · modo | erro | aviso | sucesso | com o `on…Subtle` do tom |
|---|--:|--:|--:|---|
| Bold · claro | 4,60 | 4,65 | 4,82 | 6,05 · 6,09 · 5,19 |
| **Bold · escuro** | **2,87** | **2,09** | **2,16** | 4,82 · 4,77 · 5,11 |
| referência · claro | 8,43 | 9,17 | 8,98 | 7,73 · 8,33 · 5,52 |
| **referência · escuro** | 4,91 | **3,39** | **3,72** | 5,10 · 5,68 · 5,22 |

**A paleta de referência também reprova** no escuro (aviso e sucesso): não é declaração do filho. O
`textSecondary` também não resolve (Bold escuro: 4,69 · 3,41 · 3,53). Os papéis `onErrorSubtle`,
`onWarningSubtle` e `onSuccessSubtle` passam nos oito casos, e é o mesmo par que o veredito da etiqueta
adotou em 20/10.

O título (`fg`) passa em todos (≥ 6,54).

**2 · O anúncio, no app do filho B (`origin/development`):** **83** avisos (76 pelo `CoreflowAviso`, que é
casca do `DilettaInlineAlert`, e 7 diretos), 73 com mensagem. Pelo menos **11** só aparecem depois de uma
ação, dentro de `if (erro != null)` (limite de cartão, contato novo, meus aparelhos, importar e revisar
lote, alterar senha, convite de operador, token de convite, convidar usuário, perfis). Só 2 arquivos
anunciam por conta própria (parear aparelho, saldo bloqueado).

## Já tentei

Nada em aparelho. Os caminhos por fora, lidos no código, e por que não bastam:

- **Trocar a tinta por fora**: a mensagem é `DilettaText` interno, sem porta.
- **Anunciar por fora** com `SemanticsService.announce` ou uma região viva escondida: é o remendo dos 2
  arquivos acima, e repete o texto em dois lugares.

## Conferi no pai

- O veredito da etiqueta (20/10): *«os outros quatro tons coloridos já pintam o texto com o `on…Subtle`
  do seu contêiner»*. O aviso é a mesma anatomia: contêiner do tom e texto sobre ele.
- O veredito de 24/09 decidiu o piso do `textTertiary` contra a página, *«o fundo menos contrastante dos
  dois»*. No escuro, o contêiner do tom é **menos** contrastante que a página, e é essa a frase que não
  vale aqui.
- WCAG 1.4.3: 13/400 não é texto grande, o piso é 4,5. WCAG 4.1.3: mensagem de estado que aparece sem
  receber foco precisa chegar à tecnologia assistiva.
- O comentário de `:76-79` continua certo para o aviso estático. O pedido 2 não o desfaz: é um
  interruptor, desligado por padrão.

## Derivável?

Não. A tinta e o `Semantics` estão dentro da peça.

## Se você disser não

No escuro, a mensagem de 73 avisos fica abaixo de 3:1 nos tons de aviso e sucesso. Os 11 avisos de erro
pós-ação seguem mudos, ou ganham anúncio local um por um.

## Não estou pedindo

Mudar o contêiner, a borda, o glifo ou o título. Anunciar por padrão o aviso que já está na tela. Mudar o
toast.

## Como o pai vai saber que funcionou

1. A mensagem lê o `on…Subtle` do tom (ou o papel que o pai escolher), com ≥ 4,5 sobre o contêiner nos
   dois modos, em toda paleta. Um gate como o `a_etiqueta_escreve_com_o_par_do_tinte`.
2. `DilettaInlineAlert(anunciar: true)` → o nó do aviso com `liveRegion`. Sem o parâmetro → como hoje.

## Como cheguei aqui

A auditoria de acessibilidade da proposta de onboarding (Figma, 26/10) mediu 2,86 e 2,09 no desenho. O
código confirma os dois (2,87 e 2,09) e acrescenta o sucesso (2,16) e a paleta de referência.
