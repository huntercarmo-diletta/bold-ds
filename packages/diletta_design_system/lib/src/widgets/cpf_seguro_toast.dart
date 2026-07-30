import 'dart:ui';
import 'package:flutter/widgets.dart';
import '../theme/cpf_seguro_elevation.dart';
import '../theme/cpf_seguro_metrics.dart';
import '../theme/cpf_seguro_typography.dart';
import 'cpf_seguro_spot_icon.dart' show DilettaSpotIcon, DilettaSpotState;
import 'cpf_seguro_dev_inspect.dart';
import '../theme/cpf_seguro_scheme.dart';
import '../theme/cpf_seguro_theme.dart';

/// Estado semântico do Toast.
enum DilettaToastState { normal, success, error, warning }

/// CPF SEGURO — Toast.
///
/// Feedback temporário pós-ação. Renderiza inline — quem decide quando
/// aparecer/sumir é o caller (state local ou controlador global). Pra
/// animação de entrada, embrulhe num [AnimatedSwitcher] ou [Positioned]
/// + slide.
///
/// ```dart
/// DilettaToast(state: DilettaToastState.success, title: 'Senha alterada!'),
/// DilettaToast(
///   state: DilettaToastState.error,
///   title: 'Falha ao enviar',
///   subtitle: 'Verifique sua conexão e tente de novo.',
/// ),
/// ```
class DilettaToast extends StatelessWidget {
  const DilettaToast({
    super.key,
    required this.title,
    this.state = DilettaToastState.normal,
    this.subtitle,
    this.icon,
  });

  final String title;
  final DilettaToastState state;
  final String? subtitle;

  /// Sobrepõe o ícone default do state.
  final String? icon;

  @override
  Widget build(BuildContext context) {
    final s = DilettaTheme.schemeOf(context);
    final cfg = _toastConfig(state, s);
    return DilettaDevInfo(
      component: 'DilettaToast',
      props: {'title': "'$title'", 'state': state.name},
      tokens: const ['glass · radius 16 · spot por state · subheading 14/600'],
      child: ClipRRect(
      borderRadius: DilettaRadius.all8,
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Semantics(
          liveRegion: true,
          container: true,
          child: DecoratedBox(
            decoration: BoxDecoration(
              color: cfg.bg,
              border: Border.all(color: cfg.border, width: 1),
              borderRadius: DilettaRadius.all8,
              boxShadow: DilettaElevation.soft,
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: DilettaSpacing.s3, vertical: DilettaSpacing.s2),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  DilettaSpotIcon(
                    icon: icon ?? cfg.defaultIcon,
                    state: cfg.iconState,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          title,
                          style: DilettaType.subheading.copyWith(color: s.fg),
                        ),
                        if (subtitle != null) ...[
                          const SizedBox(height: 2),
                          Text(
                            subtitle!,
                            style: DilettaType.caption.copyWith(
                              color: s.textTertiary,
                              fontSize: 13,
                              letterSpacing: 0,
                              height: 16 / 13,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    ),
    );
  }
}

class _ToastConfig {
  const _ToastConfig({
    required this.bg,
    required this.border,
    required this.iconState,
    required this.defaultIcon,
  });
  final Color bg;
  final Color border;
  final DilettaSpotState iconState;
  final String defaultIcon;
}

/// O alpha do vidro do toast, como FRAÇÃO EXATA do canal de 8 bits.
///
/// Era `0xB3` num literal (`neutral10Alpha70`). `0.7` parece igual e não é:
/// 0xB3 é 0,70196, e o Flutter hoje guarda o canal em ponto flutuante — então
/// pintar com 0.7 mudou 3 pixels e o golden acusou. A fração diz de onde vem o
/// número e reproduz o valor original bit a bit.
const double _alpha70 = 179 / 255;

_ToastConfig _toastConfig(DilettaToastState st, DilettaScheme s) => switch (st) {
      DilettaToastState.normal => _ToastConfig(
          bg: s.surfaceSubtle.withValues(alpha: _alpha70),
          border: s.border,
          iconState: DilettaSpotState.normal,
          defaultIcon: 'hand-wave-light',
        ),
      DilettaToastState.success => _ToastConfig(
          bg: s.successSubtle.withValues(alpha: _alpha70),
          border: s.successBorder,
          iconState: DilettaSpotState.success,
          defaultIcon: 'check-light',
        ),
      DilettaToastState.error => _ToastConfig(
          bg: s.errorSubtle.withValues(alpha: _alpha70),
          border: s.errorBorder,
          iconState: DilettaSpotState.error,
          defaultIcon: 'xmark-light',
        ),
      DilettaToastState.warning => _ToastConfig(
          bg: s.warningSubtle.withValues(alpha: _alpha70),
          border: s.warningBorder,
          iconState: DilettaSpotState.warning,
          defaultIcon: 'triangle-exclamation-light',
        ),
    };
