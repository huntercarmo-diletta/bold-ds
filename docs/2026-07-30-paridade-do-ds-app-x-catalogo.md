# Paridade DS — app-newbold (base) × conta-bold-ds (catálogo)

> **NOTA DE SUPERAÇÃO · 2026-07-30.** Este documento é HISTÓRIA, e os números dele descrevem o mundo de
> antes: ele comparava o DS do app com o DS antigo deste repo, quando a direção era "o app é a base,
> enriquecido pelo catálogo". **A arquitetura mudou**: hoje a linguagem mora nos dois pais
> (`ds-diletta`, `catalogo-diletta`) e este repo é filho dos dois — o app não é base de nada, ele é
> quem adota.
>
> O que está vivo mora em [`packages/conta_bold_design_system/2026-07-29-adocao-do-ds-do-bold.md`](../packages/conta_bold_design_system/2026-07-29-adocao-do-ds-do-bold.md):
> a classificação atual (rename puro · variante do filho · só do Bold), o que já nasceu e com quantos
> usos medidos.
>
> Fica aqui, e não apagado, porque a auditoria explica POR QUE algumas escolhas foram feitas — e quem
> reescreve histórico perde o registro da decisão.
>
> **Nota de 2026-07-30:** o "catálogo" que esta auditoria compara não existe mais. Ele era o app da raiz
> deste repo (`lib/`), que carregava um fork do DS e foi apagado — a medição está no README. Então as
> colunas "catálogo" abaixo descrevem código que não roda em lugar nenhum; ficam como registro do que
> foi comparado, não como inventário.

Auditoria da task 1 do change `bold-ds-package-e-adocao`.
Direção confirmada na época: **app é a base**, enriquecido pelo catálogo e pela CPF.

## Widgets (base app: 64 | catálogo: 59)

- **Idênticos (39)**: sem ação.
- **Só no app (5)** — trazidos pra o package:
  - `bold_select_field.dart` (BoldSelectField) — usado em 1 tela.
  - `bold_tab_bar.dart` (BoldTabItem) — usado em 1 tela (HomeFlatNav).
  - `bold_accordion.dart` (BoldAccordion) — 0 uso hoje (mantido no catálogo).
  - `bold_bottom_nav.dart` (BoldNavItem) — 0 uso hoje.
  - `bold_quick_action.dart` (BoldQuickAction) — 0 uso hoje.
- **Divergentes, app à frente (18)** — versão do app vence:
  promo_card, alert, app_bar, status_tag, chip, app_list, empty_state,
  top_bar, nav_top_bar, search_input, sheet, notice_row, illustration,
  controls, balance, background, card, button.
- **Divergentes, catálogo à frente (2)** — enriquecer a base app com o catálogo:
  `bold_glass_avatar.dart` (DS 65 > APP 29 linhas),
  `bold_icon_button.dart` (DS 302 > APP 285 linhas).

## Theme (7 arquivos nos dois; 3 divergem — app base)
- Divergentes: `bold_colors.dart` (contém `BoldScheme`), `bold_gradients.dart`,
  `bold_theme.dart`.
- Iguais: `bold_glass`, `bold_metrics`, `bold_motion`, `bold_typography`.

## Camada semântica
- `BoldScheme` (ThemeExtension mode-aware) já existe em ambos, dentro de
  `bold_colors.dart`. Adotado por ~10 widgets no app. Loop 1 task 2 consolida
  em palette/roles/scheme separados (molde CPF).

## Shell de package (só catálogo, preservar)
- `lib/main.dart`, `lib/ds_tree_screen.dart` (entry + Árvore do catálogo).
- Assets: catálogo (7.2M) ⊃ app (6.5M) → união.

## Baseline de uso
- App: 93 arquivos importam o DS interno direto; 0 com alias `as ds`.
- Alvo Loop 2: `package:conta_bold_ds/conta_bold_ds.dart as ds` + `ds.X`.
