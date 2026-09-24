# PEDIDO · A peça web crava o raio que a paleta declara — e a spec do botão, desde a v2.0.0, diz que isso não pode

- **de**: conta-bold-ds (filho B) · **para**: ds-diletta
- **consome**: ds-diletta `v0.207.0` + `web-v0.207.1` (o que este repo pina); **medido também na
  `v2.1.0` / `web-v2.1.0`**, a ponta de 23/09, e o defeito está lá igual
- **bloqueante?**: **não bloqueia fluxo**, e o consumidor web já tem um remendo local (abaixo). É
  pedido porque o remendo conserta UM consumidor e a incoerência continua em todos os outros, e
  porque a própria spec do botão passou a reprovar a peça web
- **não é peça nova**, por isso não abre com `DilettaManifesto.busca` (contrato, `v0.206.0`). São
  três peças que existem, com `destino: ambos`, e um token que já viaja

## Falta

As seis famílias de forma sobem por família desde o veredito de 14/09 (`v0.194.0`,
[a forma do filho para em dois raios](2026-09-14-a-forma-do-filho-para-em-dois-raios.md)): o filho
declara na paleta, o Dart lê o esquema, e o emissor põe as seis na folha web. **A peça web não lê
nenhuma delas.** Ela crava o número.

| peça | Dart (lê a declaração) | web, `web-v2.1.0` | Bold declara | app desenha | web desenha |
|---|---|---|---|---|---|
| botão | `scheme.formaDoBotao` | `diletta-button.js:148` `border-radius: 999px` | `raioDeBotao: 16` (`bold_palette.dart:533`) | **16** | **pílula** |
| campo | `s.formaDoCampo` | `diletta-input.js:144` `border-radius: 8px` | default do pai, 16 | **16** | **8** |
| dropdown (caixa) | `all200` no controle | `diletta-dropdown.js:132` `border-radius: 8px` | — | **pílula** | **8** |

E o token está na folha, esperando quem o leia:
`coreflow_design_system_web/tokens/bold-tokens.css:244` `--diletta-formaDeBotao: 16px` e `:246`
`--diletta-formaDeCampo: 16px`. `grep formaDe` nas 29 peças de `diletta_design_system_web/src` na
`v2.1.0`: **zero**.

## Número

**A contradição que torna isto pedido e não preferência**: a `v2.0.0` apagou o `chatLift` e
escreveu, em `specs/design-system-button/spec.md:155`,

> *Requirement: a FORMA é a declarada, sem exceção — Nenhuma variante de `DilettaButton` SHALL
> sobrescrever `scheme.formaDoBotao`.*

A spec é uma e o botão tem `destino: ambos` (`spec.md:222`). **A instância web não sobrescreve a
forma declarada: ela nunca a lê.** O teste que a `v2.0.0` escreveu anda os oito tipos do botão
contra uma paleta que declara 16 — no Dart. Do lado web, ninguém anda.

**Medido no navegador** (consumidor web do Bold, `core-flow-wa`, pacote do filho `web-v0.114.0`
que embute `web-v0.207.0`, em 23/09): `--diletta-formaDeBotao` resolve `16px` no `:root`, e o
`border-radius` computado do `<button>` interno sai `999px`. Com o remendo abaixo, **27 botões da
linguagem numa tela, todos a 16px**.

## Já tentei

**O remendo existe, e é por isso que sei que ele não basta.** O consumidor web repinta pela porta
que as peças publicam: `diletta-input::part(caixa)` e `diletta-dropdown::part(caixa)` desde 22/09, e
`diletta-button::part(botao)` desde 23/09, lendo `var(--diletta-formaDe…)`, com gate próprio
(`src/design-system/tokens/formas.test.ts`). Funciona. Mas:

- ele vale para **um** consumidor. O Internet Banking lê as mesmas peças e continua com pílula;
- o pacote web deste filho se define por *«não redefine componente, troca a cor por variável
  CSS»* (`package.json`), e a cópia do avô que ele embute diz *«conserto de peça do avô se pede a
  ele»* (`avo/ORIGEM.json`). Repintar por `::part` na folha do filho seria redefinir componente;
- cada tag nova da peça pode mudar o que o `::part` alcança, e o consumidor só descobre no pixel.

## Conferi no pai

- `ADR-007-o-ds-na-web.md`, `O-QUE-A-WEB-USA.md` e o ledger: **nenhuma razão escrita** para a
  instância web cravar a forma. Pela régua da casa, lacuna sem razão escrita é pedido.
- O veredito de 14/09 pôs as famílias no plugue `DilettaMedida` e no emissor de CSS. **Ninguém pediu
  que a peça web as lesse** — este pedido não reabre aquele, completa.
- `diletta-dialog.js:102` já lê `var(--diletta-r24)`: a peça web sabe ler variável. O que falta é ler
  a da **família**, não a primitiva.
- A régua de paridade (`tool/o_web_carrega_o_que_o_dart_declara.py`, `v0.201.0`) compara **campos**
  com `observedAttributes`. Forma não é campo, é leitura do esquema — por isso ela não pegou.

## Derivável?

**Sim, e sem decisão de desenho.** A peça lê `var(--diletta-formaDeBotao, 999px)`,
`var(--diletta-formaDeCampo, 8px)` — o fallback é o número de hoje, então quem não declara não muda
um pixel. Isso é o `formaDoBotao` do Dart, que também cai em pílula quando o filho não declara
(`diletta_scheme.dart:908`, `v2.1.0`).

O dropdown tem uma pergunta que é sua e não minha: no Dart o controle é `all200` e o painel é
`formaDaFolha`. Na web o painel é o `<select>` do sistema (o `///` da própria peça diz por quê),
então só a caixa se desenha — e ela hoje é 8, nem pílula nem campo.

## Se você disser não

O consumidor web do Bold fica com o remendo e o gate dele, e o próximo consumidor web de qualquer
filho descobre a pílula no pixel. A spec do botão continua dizendo «sem exceção» com uma exceção por
plataforma, e a régua da forma continua medindo metade da peça.

## Não estou pedindo

- Mudar o valor de nenhuma família — os números do Bold já batem com o app, com gate
  (`coreflow_design_system/test/o_desenho_da_web_e_o_do_mobile_test.dart:170`).
- Mexer nas peças que já batem por primitiva ou por pílula (dialog, toast, tooltip, status-tag,
  icon-button, input-chip).
- Instância web das peças que o app usa e a web não tem — é outra conversa, de vocabulário, e o
  ledger já tem a fila dela (tabela · paginação · trilho).

## Como o pai vai saber que funcionou

```js
// do lado do pai: a mesma régua da v2.0.0, nas duas instâncias — montar <diletta-button>
// sob uma folha que declara --diletta-formaDeBotao: 16px e ler getComputedStyle(part).borderRadius
// === '16px' nos oito tipos; sem a declaração, '999px' (fallback, nada muda).
// do lado do filho: o consumidor web apaga o ::part(botao) e o formas.test.ts continua verde.
```

## Como cheguei aqui

A Tatiana escreveu em 23/09 um handoff medido (*«o raio e a forma do app contra os da web»*), a
partir da pergunta *«os componentes mobile e web estão bem diferentes, raio e outros tokens»*. A
conclusão dele: o que o Bold controla já bate e tem gate; a diferença mora na peça web do avô, e o
pedido não existia. No mesmo dia a Agatha escolheu remendar no consumidor web por `::part` — o
remendo entrou, e é a prova de que a porta existe e de que o conserto não é dela. Esta rotina
remediu as três linhas na `v2.1.0` antes de escrever.

---

## Veredito · ENTRA — e você achou a peça reprovada pela lei da própria casa
**pai**: ds-diletta **v2.5.0** · **web-v2.5.0** · **data**: 2026-09-24

As três peças passam a ler a família: `var(--diletta-formaDeBotao)` no botão,
`var(--diletta-formaDeCampo)` no campo e no controle do seletor.

**O argumento que torna isto defeito e não preferência é o seu**, e é a `specs/design-system-button/spec.md`
desde a v2.0.0: *«Nenhuma variante de `DilettaButton` SHALL sobrescrever `scheme.formaDoBotao`»*.
Ela foi escrita ao apagar o `chatLift`, que fazia exatamente isso — e a peça web, que é instância
do mesmo contrato, estava fazendo o mesmo com um número cravado. **A lei pegou a casa que a
escreveu.**

### O que eu achei indo consertar, e faltava metade

A emissão da linguagem **não publicava nenhuma das seis formas**. Você viu
`--diletta-formaDeBotao: 16px` na sua folha porque o seu emissor as acrescenta; a referência não
tinha nenhuma, então a peça não teria o que ler mesmo se quisesse. Entrou
`tokens/forma.tokens.json` com os seis defaults da referência, e agora o fallback da peça é o
default da linguagem, não uma escolha dela.

### O campo divergia no DEFAULT, e ninguém tinha medido

A linguagem diz **16** para `formaDeCampo`; a peça web pintava **8**. Não era o seu 16 contra a
pílula: era a referência contra si mesma, nos dois lados da mesma peça.

### O que eu NÃO fiz

As outras 17 crases de raio nas peças web **ficam**. O disco do avatar é 50%, a pílula da etiqueta
é a geometria dela, e o botão de ícone crava pílula **nos dois lados** — conferido no Dart. Cobrar
delas seria cobrar o que a linguagem não declara, e varredura em massa conserta um padrão e
destrói outro. O gate nomeia as três peças pareadas e confere **os dois lados**: se o Dart parar de
ler a família, a linha da régua vira mentira e ela acusa.

**Os sete**: manutenção ↑ · escalabilidade ↑ o filho N declara e as duas instâncias obedecem ·
**aplicação ↑ decide** — o seu 16 chega na web · aderência ao mercado ↑ · **robustez ↑ decide** — o
gate é pareado · **arquitetura ↑ decide** — a peça deixa de decidir o que é do esquema · conciso =.
