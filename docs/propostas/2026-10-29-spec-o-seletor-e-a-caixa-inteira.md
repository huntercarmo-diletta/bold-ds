# Spec · o seletor é a caixa inteira, e a lista aberta tem a superfície da folha

- **para**: ds-diletta · delta de `specs/design-system-dropdown/spec.md`, instância web em `src/diletta-dropdown.js`
- **de**: conta-bold-ds (filho B)
- **nasce de**: [`pedidos/2026-10-29-a-caixa-do-seletor-nao-e-o-controle-e-a-lista-aberta-nao-tem-fundo.md`](../pedidos/2026-10-29-a-caixa-do-seletor-nao-e-o-controle-e-a-lista-aberta-nao-tem-fundo.md)
- **lido em**: `web-v3.25.0` (`src/diletta-dropdown.js`); avô `7f988b4` (`diletta_dropdown.dart`,
  `diletta_input.dart`); spec `design-system-dropdown` da `v3.24.0`, igual na `7f988b4`
- **estado**: **aplicada num clone local do avô, sem release** (29/10): branch
  `fix/o-seletor-e-a-caixa-inteira` sobre `7f988b4`, commit `8b33eaa`, sem push. O CHANGELOG, o ledger, o
  número (`patch` ou `minor`) e a tag são do avô. O que mudou do desenho e o que foi medido estão em
  «Aplicação», no fim. Os cenários são o que o filho precisa ver funcionando; o mecanismo é do avô,
  e as notas de desenho no fim não são lei

## O que muda na spec

Entram **dois requisitos** e nenhum outro muda. O «Gatilho readOnly + seleção em bottomsheet» continua
de pé: ele diz *o que* o toque abre, e o primeiro requisito novo diz *onde* o toque vale.

**O bloco `Contrato` não muda.** Os papéis que entram (`surface`, `fg`, `textPlaceholder`,
`textDisabled`) já estão em `papeis`; nenhum eixo nasce; o recuo muda de elemento, mas não de token.

---

## ADDED Requirements

### Requirement: O gatilho inteiro é o controle

O gatilho do `DilettaDropdown` SHALL abrir a seleção por qualquer ponto visível dele, nas duas molduras
e nas duas plataformas: na `caixa`, todo o interior da borda, com o texto, o recuo e a seta; no
`silencioso`, o valor, o respiro e a seta. Área de clique morta dentro de um controle é o defeito que a
pessoa sente e não sabe nomear: ela clica na seta, que é o desenho que diz «abre aqui», e nada acontece.

**No Dart isso já vale.** Na `caixa`, o `DilettaDropdown` é um `DilettaInput` `readOnly` com `onTap`
(`diletta_dropdown.dart:253-264`), e o `DilettaInput` envolve o contêiner inteiro num `DilettaTappable`
opaco, com o campo `readOnly` em `IgnorePointer` (`diletta_input.dart:266-284`, `:407-413`). No
`silencioso`, o `DilettaTappable` opaco envolve texto e seta juntos (`diletta_dropdown.dart:266-288`).
Este requisito escreve o que o Dart já faz, para a web ter o que cumprir.

**Na web, quem SHALL receber o clique em todo esse interior é o `<select>` nativo.** NÃO SHALL ser um
ouvinte na caixa que chama `showPicker()`: o clique no `<select>` traz de uma vez o cursor, o foco e a
abertura do sistema, e o `showPicker()` traz só a abertura, com suporte que varia entre navegadores. É o
mesmo argumento que mantém a peça em volta do `<select>` (`diletta-dropdown.js:7-15`): o que o sistema
faz de graça a peça não refaz à mão.

A peça SHALL fazer isso **sem mudar a vista fechada**, em nenhum porte, moldura ou tema, e **sem mudar a
largura intrínseca**: um seletor que ninguém dimensiona mede o mesmo de antes, porque é essa largura que
o põe numa fileira de filtros.

O que já vale SHALL continuar valendo: desabilitado não abre em ponto nenhum e tem cursor `default`; o
Tab para no controle; o anel de foco é o `outline` da caixa, inteiro, sem corte nos cantos; o nome
acessível vem do `<label for>`; a seta é `aria-hidden`.

#### Scenario: a seta abre a lista
- **WHEN** `moldura: caixa` e a pessoa clica no centro da seta
- **THEN** a lista abre e o foco está no `<select>`

#### Scenario: o recuo abre a lista
- **WHEN** `moldura: caixa`, `porte: lg`, e a pessoa clica no recuo à esquerda do texto, ou acima dele
- **THEN** a lista abre, como se o clique tivesse sido no texto

#### Scenario: o silencioso também
- **WHEN** `moldura: silencioso` e a pessoa clica na seta ou no respiro entre o valor e a seta
- **THEN** a lista abre

#### Scenario: a mãozinha na caixa toda
- **WHEN** o ponteiro passa sobre a seta ou o recuo de um seletor habilitado
- **THEN** o cursor é `pointer`, como sobre o texto

#### Scenario: a vista fechada não muda
- **WHEN** um seletor com a opção «Operador de atendimento de segundo nível» escolhida é desenhado nos
  três portes, nas duas molduras, no claro e no escuro
- **THEN** caixa, borda, raio, seta e posição do texto são os mesmos pixels de antes
- **AND** o texto comprido é cortado antes da seta, sem passar por baixo dela

#### Scenario: a largura de quem ninguém dimensiona
- **WHEN** o seletor está numa fileira flex sem largura declarada
- **THEN** ele mede o mesmo que media antes, com o mesmo conteúdo

#### Scenario: desabilitado
- **WHEN** `estado: desabilitado` e a pessoa clica na seta, no recuo ou no texto
- **THEN** a lista não abre, e o cursor é `default` em todos esses pontos

#### Scenario: teclado e foco
- **WHEN** a pessoa chega ao seletor com Tab
- **THEN** o anel aparece inteiro em volta da caixa, sem corte nos cantos arredondados
- **AND** o nome anunciado continua sendo o do rótulo

### Requirement: A lista aberta tem a superfície da folha

Onde o sistema pinta a lista aberta com o estilo da página (Chrome no Windows e no Linux), ela SHALL ter
fundo `surface` e opções em `fg`: os mesmos papéis da folha e da lista suspensa do Dart
(`diletta_dropdown.dart:418`, `:484`, `:706`). A web não inventa um papel para o painel; ela usa o que
a linguagem já usa para ele.

Os papéis SHALL ser **declarados pela peça**, e NÃO herdados por acaso. Hoje o `<select>` declara
`background: none; color: inherit` (`diletta-dropdown.js:173-174`): o fundo da caixa não chega à lista,
o painel sai no branco do sistema, e a cor que chega é o `fg` do tema. No escuro, isso é texto claro em
fundo claro.

A cor das opções NÃO SHALL seguir o marcador. Com o placeholder escolhido, o `<select>` se pinta em
`textPlaceholder` (`:179`), e as opções herdam essa cor pela cascata: a lista inteira abriria em cinza
de marcador. Na lista aberta, as opções SHALL estar em `fg`, e só a opção-marcador em `textPlaceholder`.

Na `caixa`, o fundo declarado é o mesmo papel da caixa (`:164`), e a vista fechada não muda. No
`silencioso` a caixa não pinta fundo (`:158-164`), e o gatilho fechado SHALL continuar transparente: o
fundo da lista NÃO SHALL aparecer na vista fechada, qualquer que seja a superfície em volta.

Onde o sistema desenha a lista com o próprio tema (macOS, iOS, Android), a peça não promete cor: o painel
é do sistema, e isso é o argumento da peça, não uma falha dela.

#### Scenario: a lista no escuro
- **WHEN** tema escuro, `moldura: caixa`, Chrome no Windows, e a pessoa abre a lista
- **THEN** o fundo da lista é `surface` e as opções estão em `fg`, legíveis, e não só a destacada

#### Scenario: o silencioso sobre outra superfície
- **WHEN** tema escuro, `moldura: silencioso` dentro de uma linha pintada em `bg`
- **THEN** o gatilho fechado não tem fundo próprio
- **AND** a lista aberta tem fundo `surface` e opções em `fg`

#### Scenario: o marcador escolhido não acinzenta a lista
- **WHEN** o seletor está no placeholder e a pessoa abre a lista
- **THEN** as opções estão em `fg`, e a opção-marcador em `textPlaceholder`

#### Scenario: o claro não muda
- **WHEN** tema claro, nas duas molduras
- **THEN** a vista fechada é a de antes, e a lista aberta tem fundo `surface` e opções em `fg`

---

## Gate proposto

O jsdom não calcula layout nem abre lista, então o gate tem três camadas, e cada uma pega o que as
outras não alcançam:

1. **No navegador (Chromium), a área de clique.** Para os três portes nas duas molduras, o
   `shadowRoot.elementFromPoint` devolve o `select` no centro da seta, no meio de cada recuo e a 2px
   da borda por dentro, nos quatro lados. É o número que o console mediu (27–32% da caixa hoje), e o
   gate só passa perto de 100%: o que sobra é a borda de 1px.
2. **No navegador, a vista fechada.** Captura da peça fechada antes e depois, nos três portes × duas
   molduras × dois temas, com diferença zero. É o que prende «nenhum pixel» e a largura intrínseca.
3. **No jsdom, a catraca de papel.** As regras que a peça escreve declaram fundo e cor nas `<option>`
   (ou no `<select>`, se for esse o mecanismo) com `surface` e `fg`, e a `.seta` declara
   `pointer-events: none`. A lista nativa não entra em captura de tela, então a conferência visual da
   lista aberta no Chrome do Windows fica manual, uma vez, com o registro no veredito.

**No Dart**, um teste de widget que trave o que já vale: `tester.tapAt` no centro da seta e no recuo
da `caixa`, e na seta do `silencioso`, abre a folha. Hoje isso é leitura de código (a do pedido e a
desta spec); com o teste, vira contrato.

## Efeito em quem consome

- **A porta `controle` muda de tamanho.** Pelo desenho abaixo, o `::part(controle)` passa a cobrir a
  caixa inteira e a carregar o recuo. Quem estilizou essa porta com recuo ou margem precisa conferir na
  subida, e o veredito deve dizer isso no changelog. O avô decide se isso é `minor` ou `patch`.
- **A ponte do console sai na mesma subida.** Ela devolve o recuo por dentro do `<select>` com margem
  negativa (`core-flow-wa`, `src/design-system/tokens/index.css`); com a peça já fazendo isso, o recuo
  dobraria. Os dois gatilhos do `seletorClicavel.test.ts` (a `.seta` declara `pointer-events`; o
  `<select>` ganha recuo próprio) disparam com este desenho, e é de propósito. Se o avô escolher outro
  mecanismo, o veredito diz qual, e o console troca o gatilho.
- **Paridade**: nada muda na régua. O Dart já cumpre os dois requisitos.

## Notas de desenho (não normativas)

O desenho do pedido, posto em CSS sobre a montagem da `web-v3.25.0` (`:155-200`), para o avô julgar
com o custo à vista:

```css
.caixa {
  position: relative;
  overflow: hidden;            /* recorta o fundo do select nos cantos; não recorta o outline da própria caixa */
  /* na moldura caixa, o padding sai daqui; borda, raio, min-height e background ficam */
}
select {
  align-self: stretch;
  padding: var(--diletta-s2) <px do porte>;                               /* só na caixa; no silencioso, 0 */
  padding-inline-end: calc(<px do porte> + 16px + var(--diletta-s2));     /* recuo + seta + gap; no silencioso, 16px + gap */
  background-color: var(--diletta-surface);                               /* só na caixa; no silencioso, transparent */
}
option { background-color: var(--diletta-surface); color: var(--diletta-fg); }
option[value=""] { color: var(--diletta-textPlaceholder); }
.seta {
  position: absolute; inset-inline-end: <px do porte>; top: 50%; translate: 0 -50%;
  pointer-events: none;
}
```

As contas que fazem a vista fechada não mudar:

- **Posição do texto**: o recuo que era da caixa vira do `<select>`, com o mesmo valor; o texto começa
  no mesmo ponto.
- **Posição da seta**: antes, ela ficava no fim do flex, a `px` da borda; agora fica em
  `inset-inline-end: px`, centrada na altura. Mesmo lugar.
- **Largura intrínseca**: antes, `px + texto + s2 + 16 + px`; agora, o `<select>` mede
  `px + texto + (px + 16 + s2)`. Mesma soma. A seta sai do fluxo, mas o espaço dela continua reservado
  no recuo do fim.
- **Altura**: a caixa segue com `min-height` e o `<select>` estica até ela. **A conferir**: o
  centramento vertical do texto num `<select>` mais alto que a linha. O Chromium centra; no Firefox e no
  Safari, quem diz é a captura da camada 2 do gate.
- **Silencioso e lista aberta**: com o `<select>` transparente e as `<option>` em `surface`, **a
  conferir** no Chrome do Windows se a moldura do painel (a faixa fora das linhas) herda o branco. Se
  herdar, o caminho é outro, e é do avô.

## Fora desta spec

1. **O clique no rótulo abrir a lista**: o `<label for>` foca sem abrir, que é o comportamento nativo.
2. **Trocar o `<select>` nativo** por lista desenhada, ou pelo `appearance: base-select` do Chromium:
   o argumento de `:7-15` continua valendo, e o `base-select` só existe num navegador.
3. **Mudar a vista fechada**, em qualquer moldura ou tema.
4. **O glifo da biblioteca `sistema` carregado por `fetch` de `data:`**: se for o caso, é outro pedido.

## Aplicação (29/10, clone local do avô)

Branch `fix/o-seletor-e-a-caixa-inteira` sobre `7f988b4`, num clone do espelho do pub
(`Design-System/ds-diletta`). O que entrou:

| arquivo | o que é |
|---|---|
| `specs/design-system-dropdown/spec.md` | os dois requisitos, com os cenários como estão acima; o `Contrato` não muda |
| `packages/diletta_design_system_web/src/diletta-dropdown.js` | o recuo sai da `.caixa` e vai para o `<select>`, que estica até a borda; a seta fica `absolute` com `pointer-events: none`; `option, optgroup` em `surface`/`fg`, o marcador em `textPlaceholder` |
| `packages/diletta_design_system_web/test/o_seletor_e_a_caixa_inteira.test.js` | camada 3, a catraca de papel (10 testes) |
| `tool/o_seletor_e_a_caixa_inteira.py` | camadas 1 e 2, no Chromium sem cabeça; sem Chromium, pula e diz. Entrou na linha web do gate do `CLAUDE.md` |
| `packages/diletta_design_system/test/o_seletor_abre_pela_caixa_inteira_test.dart` | o lado Dart: `tapAt` na seta e no recuo da `caixa`, na seta e no respiro do `silencioso`, e desabilitado que não abre (5 testes) |
| `manifesto.json`, `diletta_specs.g.dart` | regerados da spec; o `spec-publicada.json` confere sem mudança |

**Uma diferença do desenho das notas.** O `<select>` da `caixa` declara `background-color: surface`,
como proposto, mas com `background-clip: content-box`. Com o fundo chegando até a borda e o `overflow`
recortando, **1.067 pixels mudavam no claro e 1.296 no escuro**, todos no antisserrilhado da borda dos
cantos arredondados (Δ ≤ 9/255): o fundo opaco repintava a parte de dentro da curva. O recuo já é
`surface` por baixo (é o fundo da caixa), então pintar o fundo só no conteúdo não muda nada à vista, e o
painel continua lendo a cor declarada. O `overflow: hidden` ficou, para o clique fora da curva não abrir
a lista.

**Medido no Chrome 156 do Windows (`156.0.8078.48`), sem cabeça** (`python tool/o_seletor_e_a_caixa_inteira.py --contra v3.25.0`):

| | antes (`v3.25.0`) | depois |
|---|---|---|
| área da caixa que abre a lista, `caixa` sm · md · lg | 48,9 · 48,2 · 37,3% | 95,4 · 95,4 · 96,3% (o resto é a borda de 1px e as quinas fora da curva) |
| idem, `silencioso` | 92,1% (a seta engolia) | 100% |
| seta, recuo esquerdo, recuo acima, 2px por dentro nos quatro lados | `diletta-icon` / `div.caixa` | `select`, nos 6 casos |
| cursor habilitado / desabilitado | `auto` na seta e no recuo | `pointer` / `default` |
| largura intrínseca, fileira flex sem largura | — | a mesma nos 6 casos |
| vista fechada, claro e escuro, com e sem anel de foco | — | **0 pixels** diferentes |
| cor das `<option>` com o marcador escolhido | `textPlaceholder` em todas, fundo transparente | `fg` em `surface`; só o marcador em `textPlaceholder` |

A ferramenta reprova a peça antiga (testado pondo a `v3.25.0` no lugar), e o teste Dart reprova um
`silencioso` com `deferToChild` no toque: os dois gates pegam o defeito que existem para pegar.

**As suítes**: web 291 de 307 no Windows, e as 16 que caem são as mesmas da `main` (caminho
`C:\C:\` nos testes que leem fonte); com o caminho consertado numa cópia, 307 de 307. Dart 1056 de
1057, e a que cai (`barril_entrega_tudo_test`, separador `\`) é a mesma na `main`. A catraca
`o_valor_mudo_so_diminui` já cai na `main` (47 mudos contra teto 44, em outras peças).

**O que ficou aberto**:

1. **A lista aberta no Chrome do Windows, à mão**: o painel não sai em captura sem cabeça. Abrir no
   claro e no escuro, nas duas molduras, e conferir se a faixa do painel fora das linhas (no
   `silencioso`, onde o `<select>` é transparente) herda o branco. Se herdar, o caminho é do avô.
2. **Firefox e Safari**: não há na máquina. O centramento vertical do texto no `<select>` esticado só
   foi medido no Chromium.
3. **O release**: CHANGELOG, ledger do avô, número e tag. Pelo que muda para quem consome, a porta
   `::part(controle)` passa a cobrir a caixa inteira e a carregar o recuo — quem estilizou recuo ou
   margem nela precisa conferir na subida —, e a ponte do console sai na mesma subida, senão o recuo
   dobra.
