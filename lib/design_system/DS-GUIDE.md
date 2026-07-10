# Conta BOLD — Design System · Guia de Operação

> **Fonte única de verdade do DS.** Substitui `ATOMIC_DESIGN.md` e `INTEGRATION.md`
> (aposentados). Escrito **agente-primeiro**: é o contrato que eu carrego pra
> usar, editar, expandir e manter o DS do jeito que a gente trabalha —
> construindo o DS à mão enquanto monto as telas.

---

## 1. Como usar este doc

- Ler antes de qualquer edição em `lib/design_system/` **ou** de montar/alterar tela.
- É lei operacional: as regras aqui vencem "gosto" ou atalho.
- O DS deste app é **construído à mão e iterativo** (isto derruba o antigo "não
  editar, é gerado"). A tela puxa o DS; o DS não nasce pronto.

---

## 2. Modelo mental — lógica atômica

```
TOKENS  →  ÁTOMOS  →  MOLÉCULAS  →  ORGANISMOS  →  TELAS
```

**Regra de ouro:** cada nível só compõe do nível **abaixo**, e **nada hardcoda um
valor** — cor, texto, raio, espaço, ícone e vidro vêm sempre de token.

- **Tokens** (`theme/`) — cor, tipografia, métrica (raio/espaço/ícone), gradiente, glass, tema.
- **Átomos** — primitivos indivisíveis; consomem só tokens (`BoldIcon`, `BoldCheckbox`, `BoldSpotIcon`…).
- **Moléculas** — combinações simples de átomos (`BoldButton`, `BoldAppList`, `BoldCard`…).
- **Organismos** — composições em superfície; consomem moléculas (`BoldTopBar`, `BoldBottomApp`, `BoldBalance`…).
- **Telas** — montadas de organismos/moléculas, **nunca** de `Container`/`Text`/`Padding` soltos.

O barrel (`bold_design_system.dart`) está agrupado exatamente nessa ordem. É o índice.

---

## 3. O loop de iteração (tela primeiro → extrai pro DS)

Este é o coração do fluxo. Ao montar/alterar uma tela:

1. **Monta de peças do DS.** Primeiro reflexo: já existe organismo/molécula pra isso? Usa.
2. **Faltou algo?** Decide *inline* vs *promover*:
   - **One-off** (visual único da tela, não repete, não é "peça") → pode ficar inline **na tela** — mas **ainda com tokens** (cor/typo/espaço/raio do DS). Inline nunca é desculpa pra hex solto ou `TextStyle` cru.
   - **Reutilizável** (vai repetir, é uma unidade nomeável) → **promove pro DS** no nível certo.
3. **Regra do 2×:** copiou/repetiu o mesmo padrão 2 vezes → extrai pro DS na hora. Terceira cópia é dívida.
4. **Ao promover:** escolhe o nível, compõe só do nível abaixo, roda o **checklist da seção 5**.

Objetivo: mudar um token ou um componente reflete em **todo** o app, sem varrer tela por tela.

---

## 4. Protocolo anti-redundância (antes de criar QUALQUER coisa)

1. **Busca primeiro.** `grep` no barrel + `widgets/` pelo conceito e sinônimos.
   Ex.: precisa de "chip"? já existem `BoldStatusTag`, `BoldInputChip`, `BoldFilterChip`, `BoldStatusBadge`. Precisa de "linha de lista"? `BoldAppList` / `BoldListTile`.
2. **Estender > criar.** Preferir uma nova **variante** (enum) ou **param opcional** num componente existente a um componente novo. Toda adição é **backwards-compatible** (não quebra call site).
3. **Token que falta vira token.** Se precisa de uma cor/tamanho que não existe, adiciona em `BoldColors`/`BoldType`/`BoldMetrics` — nunca um valor local. **Se não sabe qual token é, para e pergunta.**
4. **Nomear pra não duplicar.** Prefixo `Bold*`. Componente com encaixes → **sealed accessory** (padrão do `BoldAppList`: `BoldLeftAccessory`/`BoldMiddleAccessory`/`BoldRightAccessory`, cada variante = uma factory `const`).

---

## 5. Checklist anti-ponta-solta (Definition of Done de toda mudança no DS)

- [ ] **Só tokens.** Zero `Color(0x…)`, zero `TextStyle(…)` cru, raio de `BoldRadius`, espaço de `BoldSpace`, ícone de `BoldIconSize`, vidro de `BoldGlass`.
- [ ] **Theme-aware.** Ink e superfície via `BoldColors.of(context)` (`BoldScheme`), funcionando em **light E dark**. Constantes de marca (`primary04`, `accent04`) podem ser diretas; **ink/superfície não** — essas seguem o tema.
- [ ] **Doc-comment header:** `/// Conta BOLD — Nome (átomo|molécula|organismo).` seguido de `**Composição** — X + Y + tokens.`
- [ ] **Exportado no barrel**, na seção da camada certa, com comentário dos símbolos.
- [ ] **Aterrissado no catálogo** (projeto `conta-bold-ds`) com `formado por:` (tokens/widgets que o compõem).
- [ ] **Sem órfão.** Todo param novo tem call site real **ou** aparece no catálogo. Nada de API morta.
- [ ] Mexeu em token/spec de fundação? A **spec table** do catálogo reflete.

Sinal de que está integrado certo: `grep 'Color(0x'` **fora** de `lib/design_system/` retorna quase nada.

---

## 6. Como se constrói um componente

- **1 arquivo por componente** em `widgets/`, nome `bold_*.dart`.
- **Presentational puro.** O DS **não importa** riverpod/firebase/dio/plugins. Recebe dados por props, dispara callbacks. (É isto que deixa o DS portável pro catálogo standalone — quebrar isso quebra o build web.)
- **Controlado.** O estado mora no pai; o componente reflete props. Ex.: `BoldSwitch(value:, onChanged:)`, `BoldBalance(hidden:)`.
- **Variantes por enum** (`BoldButtonVariant`, `BoldStatusTone`); **tamanhos por enum** (`BoldButtonSize.sm/md/lg`).
- **Slots por sealed accessory** (Left/Middle/Right), com factories `const` nomeadas por variante.
- Sem lógica de negócio/IO. Formatação/estado global fica na tela, não no DS.

---

## 7. Disciplina de token (a fundação)

**Cor — `BoldColors`.** Escala por família `01–09` (base = `04`; `07–09` = wash/tint claro). Aliases de intenção: `primary`(=`primary04`), `accent`, `success`, `danger`, `warning`. Mode-aware via **`BoldScheme`** (`background`, `surface`, `field`, `textPrimary`, `textSecondary`, `textMuted`, `border`…) lido por `BoldColors.of(context)`. Marca é constante; superfície/ink seguem o tema.

**Intenção → cor (real do Bold):** rosa `primary` = marca/primário · coral `accent` = CTA/confirmar · verde = sucesso · vermelho = erro/destrutivo · âmbar = alerta · azul/indigo = info. *(Ignora "violet/orange" dos docs antigos — era paleta velha.)*

**Tipografia — `BoldType`.** Fonte oficial **Poppins** (token de runtime: `BoldType.fontFamily`). Escala canônica: `headlineMd`, `title`, `labelLg/Md/Sm`, `bodySmall`, `button`. `.copyWith(...)` só pra cor/peso one-off — **nunca** um `fontSize` fora da escala.

**Métrica — `bold_metrics`:**
- `BoldRadius`: `chip 10` · `field 16` · `card 24` · `sheet 22` · `pill 999`. Botão/switch/segmented/nav são sempre `pill`.
- `BoldSpace` (base 4): `x1 4` · `x2 8` · `x3 12` · `x4 16` · `x5 20` · `x6 24` · `x8 32` · `x10 40`. **Não existe `x7` nem `x9`.** Respiro de rodapé = `bottomBreath` (32).
- `BoldIconSize`: `xs 14` · `sm 16` · `md 18` · `lg 20` · `xl 24` · `xxl 28`.

**Glass — `BoldGlass`.** Vidro único do DS: **fill 26% + stroke 30% + blur 15**, theme-aware (dark `#4C0202`/`#FF9898`, light `#FFC8DC`/`#FFFFFF`). É característica de **container**, nunca de elemento. Encapsulado — não remontar à mão.

**Gradiente — `BoldGradients.brand`.**

---

## 8. Portabilidade — usar este DS pra semear outros

A **estrutura é o produto**, não só os widgets:

- Camadas (`theme/` + `widgets/`) + barrel agrupado por tier + doc-comment por nível + catálogo com `formado por:` + disciplina de token.
- **DS novo:** copia a estrutura, troca os **tokens** (cor/tipo/glass da marca nova), reescreve os widgets com **prefixo novo** (`CpfSeguro*`, `NovaMarca*`). Os **padrões** (sealed accessory, controlado, variante por enum, theme-aware, presentational puro) permanecem.
- **Prova viva:** CPF Seguro (`~/Desktop/cpf-seguro-flutter`) e Bold compartilham a mesma metodologia; o `BoldAppList` é portado do "App list" do CPF. Componente migra entre DSs trocando token + prefixo.

---

## 9. Fontes de verdade e sync

| Fonte | Papel | Direção |
|---|---|---|
| **Figma** | Design canônico (intenção visual) | Figma → Bold implementa |
| **CPF Seguro** (`cpf-seguro-flutter`) | Implementação de referência madura (catálogo, spec_tables, motion) | CPF ↔ Bold trocam padrões/portes |
| **Bold** (`app-newbold/lib/design_system`, branch `design/ds-enrich`) | O DS deste app, à mão, iterando com as telas — **editável** | fonte da vez |
| **Catálogo** (`~/Desktop/conta-bold-ds`, standalone) | Referência viva; espelha o DS do Bold | Bold → catálogo (re-copia) |

**Sync do catálogo** ao mexer no DS:
```
cp -R ~/Desktop/app-newbold/lib/design_system ~/Desktop/conta-bold-ds/lib/design_system
cd ~/Desktop/conta-bold-ds && flutter build web -t lib/main.dart --release
# deploy: cp -R build/web/. <stage>/ && cd <stage> && vercel deploy --prod --yes
```
No ar: **conta-bold-ds.vercel.app**.

---

*v1 — construído junto. Iterar aqui conforme o fluxo evoluir.*
