# PEDIDO · Duas das oito aparências do botão escrevem o rótulo num papel que reprova AA no claro

- **de**: conta-bold-ds (filho B) · **para**: ds-diletta
- **consome**: ds-diletta `v0.207.0` · `web-v0.207.0`, pela tag `web-v0.114.0` deste repo
- **bloqueante?**: **não** — eu desvio, e o desvio está escrito e datado no `WaBotao`. O
  custo do desvio é o que esta seção mede: a próxima tela que escolher `secondary` pelo
  NOME acerta o nome e erra a régua.
- **irmão**: `2026-09-22-o-botao-desabilitado-fica-com-a-borda-da-marca.md` — mesma peça,
  mesma tabela de pintura, defeito diferente. **JULGADO em 22/09: ENTRA, e a causa estava na
  EMISSÃO, não no Dart.** Este pedido NÃO tem essa saída — ver «Conferi no pai».
- **não é peça nova**, então a regra do `DilettaManifesto.busca` não se aplica.

> **Nota de procedência.** Achado no **core-flow-wa** em 21/09/2026, no dia em que o
> `WaBotao` deixou de desenhar. Eu fui traduzir os quatro papéis deste produto para o eixo
> de aparência da linguagem, medi antes de escolher, e o par óbvio pelo nome era o que
> reprovava.

## Falta

`secondary` e `tertiary` pintam o RÓTULO em `textTertiary`, que dá 3,77:1 e 4,17:1 no tema
claro — abaixo do piso de 4,5:1 da WCAG 2.2 §1.4.3 para texto.

## Número

**Medido nas folhas instaladas pela tag**, compondo contra cada fundo em que um botão
aparece:

```
                     textTertiary   fundo      razão
claro,  sobre bg       #80798d     #f4f3f6    3,77:1   ✗
claro,  sobre surface  #80798d     #ffffff    4,17:1   ✗
escuro, sobre bg       #8d91a0     #0a0b12    6,26:1   ✓
escuro, sobre surface  #8d91a0     #14151f    5,78:1   ✓
```

**É defeito do CLARO, e dos dois fundos.** No escuro passa com folga — o que torna a coisa
mais difícil de ver, porque quem confere no escuro aprova.

Varrida a `pintura.g.js` inteira (a tabela que o Dart MEDE no render), procurando
`pintura.color === 'textTertiary'`:

```
combinações que pintam TEXTO em textTertiary:  27

  design-system-button        18   secondary × {sm,md,lg} × {normal,hover,pressed}
                                   tertiary  × {sm,md,lg} × {normal,hover,pressed}
  design-system-icon-button    6   tertiary  × …            ← GLIFO, piso 3:1, passa
  design-system-spot-icon      3   fill/outline             ← GLIFO, piso 3:1, passa
```

**As 18 do botão são texto; as 9 restantes são glifo e estão certas.** O piso muda com o
que a tinta desenha, e por isso eu não estou pedindo que `textTertiary` mude de valor.

**Sítios deste console:** zero, e isso é o ponto — ver «Se você disser não».

## Já tentei

1. **Usar `secondary` e corrigir a cor por fora.** Não alcança: a cor mora na regra do
   shadow, e o botão não publica `part` para o rótulo (publica `part="botao"`, e a cor é
   declarada nele — reescrevê-la de fora seria reintroduzir a cópia de tinta que a adoção
   acabou de apagar, que é o mesmo argumento do pedido irmão do desabilitado).
2. **Ir para `secondaryPrimary`.** É o que eu fiz, e funciona: 7,26 no claro e 7,20 no
   escuro. Mas ele não é o mesmo papel — `secondaryPrimary` é «ação alternativa da marca»
   e `secondary` é «ação alternativa neutra». Eu perdi a distinção, e o meu `sutil`
   (`tertiaryPrimary`) e o meu `secundario` passaram a compartilhar a tinta, com a BORDA
   sendo a única coisa que os separa. Funciona porque a diferença entre eles sempre foi a
   moldura; não funcionaria num produto que precisasse de uma ação neutra ao lado de uma
   da marca.
3. **Subir o peso do rótulo para cair na régua de texto grande (3:1).** O degrau `button`
   é 15px/600 — 15px não é «texto grande» pela WCAG (o piso é 18,66px em negrito). Não
   fecha.

## Conferi no pai

- O **valor** de `textTertiary` está coerente com a rampa que você declarou em
  `2026-08-17-a-rampa-de-texto-do-escuro-nao-viaja-a-minha-e-azul`, e eu não o contesto.
  O problema é o mesmo do rótulo do campo, no pedido irmão: **papel de rampa baixa usado
  em conteúdo**.
- **Li o Dart, e a causa NÃO é a emissão — é a linguagem, dos dois lados.** O irmão da
  borda desabilitada achou o defeito no gerador; este não. Em
  `diletta_design_system/lib/src/widgets/diletta_button.dart`:

  ```dart
  case DilettaButtonType.secondary:   // linha 473
    final c = isError ? s.error : s.textTertiary;
    return DilettaPintura(bg: bg, color: c, border: c);
  case DilettaButtonType.tertiary:    // linha 499
    return DilettaPintura(bg: bg, color: isError ? s.error : s.textTertiary);
  ```

  A web só carrega fielmente o que o Dart decidiu. **Ressalva de fonte**: li o avô no clone
  local em `2bb8452e` (21/09), que é ANTERIOR à `v0.207.0` embutida na tag instalada — o
  commit exato dela (`e0020169`) não está no clone. O que liga as duas pontas é a tabela de
  pintura da `v0.207.0`, gerada da medição do Dart, que pinta o mesmo papel nas mesmas 18
  combinações.
- **E o próprio gate do Bold trata `textTertiary` como papel DISCRETO.**
  `coreflow_design_system/test/o_piso_de_contraste_vale_nos_dois_modos_test.dart` cobra dos
  papéis de texto um piso de **3,0**, e diz por quê: *«o `mudo` é metadado e é pra ser
  discreto — 4,5 o transformaria em corpo»*. O `textTertiary` passa nesse piso (4,17). O
  defeito é o botão usar um papel de metadado como **rótulo de controle**, que pede 4,5.
  É a mesma tese do `2026-09-22-o-rotulo-do-campo-e-metadado-e-eu-nao-alcanco`, aberto no mesmo dia.
- Conferi que o **desabilitado é isento** (§1.4.3 não se aplica), então as combinações
  `disabled` ficam fora desta conta de propósito. As 18 são estados interativos:
  `normal`, `hover`, `pressed`.

## Derivável?

**Não, e é aqui que dói.** Do meu lado eu só declaro `type`, `size`, `state` e `acao`.
Nada do que eu declaro me diz que `secondary` vai reprovar no claro — o nome promete
«secundário» e entrega uma rampa de metadado. **O nome é o que engana**, e nenhum
consumidor descobre isso sem compor o alfa e medir, que é o que três produtos desta
família já erraram no mesmo mês com o anel de foco.

## Se você disser não

Eu não pago preço nenhum HOJE: o `WaBotao` traduz `secundario → secondaryPrimary`, com a
tabela de contraste escrita no arquivo, e o desvio está datado.

**Quem paga é o próximo.** O custo real de um não é que a aparência continua publicada com
o nome certo e a régua errada, e a maneira de descobrir isso é a que eu usei: ler
`pintura.g.js`, extrair o papel, compor contra dois fundos em dois temas. Nenhum filho vai
fazer isso antes de escrever `type="secondary"` — ele vai fazer o que eu quase fiz, que é
escolher pelo nome.

Se a resposta for não, **peça que ela venha com a razão escrita**, porque aí a régua desta
casa passa a ser «a linguagem publica aparência que reprova AA e o filho contorna», e isso
é uma regra, não um caso.

## Não estou pedindo

1. **Que `textTertiary` mude de valor.** Ele está certo no papel dele, e as 9 combinações
   de GLIFO que o leem passam no piso delas;
2. **que `secondary` vire `secondaryPrimary`.** São papéis diferentes e os dois precisam
   existir — o que eu peço é que o neutro leia um degrau que passe, e `textSecondary` dá
   5,00 e 5,53 no claro;
3. **nada sobre o escuro.** Lá passa, e mexer nele seria consertar o que não está
   quebrado;
4. **nada sobre o desabilitado.** Isso é o pedido irmão, e ele já está escrito.

## Como o pai vai saber que funcionou

```
para cada combinação de `pintura.g.js` cujo slot `color` desenha TEXTO:
  compor a tinta sobre `bg` e sobre `surface`, nos dois temas
  razão >= 4,5:1

hoje: 18 combinações do botão em 3,77 e 4,17 no claro
```

O gate precisa distinguir **texto de glifo** — senão ele reprova o `icon-button` e o
`spot-icon`, que estão certos. Se essa distinção não existir na sua tabela hoje, ela é a
informação que falta, e vale mais que o conserto: sem ela nenhum gate de contraste da
família consegue medir a coisa certa.

---

## Veredito · RESOLVIDO PELO IRMÃO — e sem tocar na tabela de pintura
**pai**: ds-diletta **v2.5.0** · **data**: 2026-09-24

Os seus dois números — 3,77 sobre o `bg` e 4,17 sobre a superfície — não são defeito do botão. São
o `textTertiary` chegando errado no botão, e você mesmo escreveu o irmão que o mede:
[o papel que carrega texto de corpo](2026-09-22-o-papel-que-carrega-texto-de-corpo-tem-piso-de-texto-grande.md).

Aquele entrou nesta tag: `textTertiary` passa a derivar com **piso 4,5 contra a página**, caminhando
na direção da sua tinta secundária. As duas aparências do botão recebem o degrau corrigido **sem
uma linha na `pintura.g.js`** — e isso importa, porque consertar aqui teria posto um número na
tabela de pintura para tapar um defeito de derivação. A tabela diz *qual papel*; ela não é o lugar
de contornar *qual cor o papel virou*.

**A sua observação sobre o escuro é a parte que fica no ledger**: 6,26 e 5,78 passam com folga, e é
isso que torna o defeito difícil de ver — *quem confere no escuro aprova*. Está registrado junto
com a classe irmã, a de 31/07: **medir só uma paleta não mede a classe**; aqui, medir só um modo
não mede o defeito.

**Os sete**: manutenção ↑ um conserto, dois pedidos · escalabilidade ↑ · aplicação ↑ ·
aderência ao mercado ↑ · **robustez ↑ decide** — o conserto foi na causa e não no sintoma ·
**arquitetura ↑ decide** — zero linha nova na tabela de pintura · conciso ↑.
