import 'package:flutter/widgets.dart';
import '../theme/cpf_seguro_scheme.dart';
import '../theme/cpf_seguro_theme.dart';
import 'cpf_seguro_icon_accessory.dart' show DilettaIconAccessory;
import 'cpf_seguro_dev_inspect.dart';
import 'cpf_seguro_tappable.dart';
import '../theme/cpf_seguro_icon_tokens.dart';

/// Direção/tipo semântico da Action.
enum DilettaActionDirection {
  /// Chevron right (16px, neutral-04) — navegação ("tap to enter").
  right,

  /// Chevron up (16px, neutral-04) — colapsar.
  up,

  /// Chevron down (16px, neutral-04) — expandir.
  down,

  /// Ellipsis vertical (16px, neutral-04) — menu de opções.
  more,

  /// Círculo check preenchido (22px, success-04) — confirmação.
  check,

  /// Clock outline (22px, neutral-04) — pending/em andamento.
  clock,

  /// Círculo X preenchido (22px, error-04) — erro.
  error,
}

/// CPF SEGURO — Action.
///
/// Primitivo pro slot direito de AppList, banners, cards. 7 direções com
/// icon+size+color pré-configurados. Pode ser puramente decorativo ou
/// clicável (vira botão sem chrome).
///
/// ```dart
/// DilettaAction(direction: DilettaActionDirection.right),               // chevron
/// DilettaAction(direction: DilettaActionDirection.check),               // sucesso
/// DilettaAction(direction: DilettaActionDirection.more, onPressed: openMenu, semanticLabel: 'Mais opções'),
/// ```
class DilettaAction extends StatelessWidget {
  const DilettaAction({
    super.key,
    this.direction = DilettaActionDirection.right,
    this.onPressed,
    this.semanticLabel,
  });

  final DilettaActionDirection direction;
  final VoidCallback? onPressed;
  final String? semanticLabel;

  @override
  Widget build(BuildContext context) {
    final s = DilettaTheme.schemeOf(context);
    final cfg = _configFor(direction, s);
    final glyph = DilettaIconAccessory(icon: cfg.icon, padding: 0, size: cfg.size, color: cfg.color);

    if (onPressed == null) {
      return DilettaDevInfo(
      component: 'DilettaAction',
      props: {'direction': direction.name},
      tokens: const ['glifo direcional · cor/size por direção'],
      child: ExcludeSemantics(child: glyph),
    );
    }
    return DilettaDevInfo(
      component: 'DilettaAction',
      props: {'direction': direction.name},
      tokens: const ['glifo direcional · cor/size por direção'],
      child: Semantics(
      button: true,
      label: semanticLabel ?? direction.name,
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        child: DilettaTappable(
          onTap: onPressed,
          child: glyph,
        ),
      ),
    ),
    );
  }
}

class _ActionConfig {
  const _ActionConfig({required this.icon, required this.size, required this.color});
  final String icon;
  final double size;
  final Color color;
}

_ActionConfig _configFor(DilettaActionDirection d, DilettaScheme s) => switch (d) {
      DilettaActionDirection.right => _ActionConfig(icon: DilettaIcons.angleRightLight, size: 16, color: s.textMuted),
      DilettaActionDirection.up => _ActionConfig(icon: DilettaIcons.angleUpLight, size: 16, color: s.textMuted),
      DilettaActionDirection.down => _ActionConfig(icon: DilettaIcons.angleDownLight, size: 16, color: s.textMuted),
      DilettaActionDirection.more => _ActionConfig(icon: DilettaIcons.ellipsisVerticalLight, size: 16, color: s.textMuted),
      DilettaActionDirection.check => _ActionConfig(icon: DilettaIcons.circleCheckSolid, size: 22, color: s.palette.success04),
      DilettaActionDirection.clock => _ActionConfig(icon: DilettaIcons.clockLight, size: 22, color: s.textMuted),
      DilettaActionDirection.error => _ActionConfig(icon: DilettaIcons.circleXmarkSolid, size: 22, color: s.palette.error04),
    };
