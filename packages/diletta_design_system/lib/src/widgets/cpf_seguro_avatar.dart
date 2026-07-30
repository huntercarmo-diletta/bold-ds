import '../theme/cpf_seguro_theme.dart';
import 'package:flutter/widgets.dart';
import '../theme/cpf_seguro_typography.dart';

/// Variante do Avatar.
enum DilettaAvatarVariant {
  /// Círculo branco + borda; iniciais em primary-03.
  outlined,

  /// Círculo cheio da marca (primary-04); iniciais brancas.
  solid,
}

/// CPF SEGURO — Avatar.
///
/// Iniciais em círculo (default 40) — pessoa/contato sem foto. Componente
/// **standalone**: vive por conta própria e é usado em vários contextos. A
/// [DilettaAppList] apenas o CONSOME (via `DilettaLeftAccessory.avatar`),
/// não o define.
///
/// ```dart
/// DilettaAvatar(initials: 'JC'),
/// DilettaAvatar(initials: 'CR', variant: DilettaAvatarVariant.solid, size: 48),
/// ```
class DilettaAvatar extends StatelessWidget {
  const DilettaAvatar({
    super.key,
    required this.initials,
    this.variant = DilettaAvatarVariant.outlined,
    this.size = 40,
    this.borderColor,
  });

  final String initials;
  final DilettaAvatarVariant variant;

  /// Diâmetro do círculo (default 40). O texto escala junto (~40% do size).
  final double size;
  /// `null` = a borda do tema (papel `border`), que reage ao claro/escuro.
  final Color? borderColor;

  @override
  Widget build(BuildContext context) {
    final s = DilettaTheme.schemeOf(context);
    final solid = variant == DilettaAvatarVariant.solid;
    return Container(
      width: size,
      height: size,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: solid ? s.primary : s.surface,
        border: solid
            ? null
            : Border.all(color: borderColor ?? s.borderSubtle, width: 1),
      ),
      child: Text(
        initials,
        style: DilettaType.heading.copyWith(
          fontSize: size * 0.4,
          color: solid ? s.palette.white : s.primaryOnSurface,
          letterSpacing: 0,
        ),
      ),
    );
  }
}
