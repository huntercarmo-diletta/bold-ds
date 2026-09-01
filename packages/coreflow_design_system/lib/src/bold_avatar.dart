import 'package:diletta_design_system/diletta_design_system.dart'
    show DilettaAvatar, DilettaAvatarVariant;
import 'bold_icone.dart' show CoreflowIcone;
import 'package:flutter/material.dart';
import 'bold_vidro.dart';
import 'bold_gradients.dart' show CoreflowGradients;
import 'bold_scheme.dart' show CoreflowScheme;

/// Conta BOLD — top-bar building blocks.
///
/// [CoreflowAvatar] é o que sobrou: o avatar do usuário dentro do [BoldTopBar],
/// theme-aware (light/dark) via [CoreflowScheme.of].
///
/// `BoldCircleButton`, `BoldAccountPill` e `BoldAccountSwitcher` saíram em 08/08 —
/// as três ficaram sem consumidor quando o perfil antigo e o cabeçalho de conta
/// morreram, e as três estavam de pé por causa de um comentário.

/// Profile avatar. Shows [image] if given, otherwise gradient [initials].
/// Set [gear] to attach a small settings badge (taps open the profile).
/// Conta BOLD — Avatar (átomo) UNIFICADO do usuário. Superfície de **vidro**
/// (default, o look do Redesenho: BoldGlass fill/stroke/blur + inicial em
/// textPrimary) OU **gradiente da marca** ([glass] = false, inicial branca);
/// [image] cobre o disco com a foto real. Badge de canto opcional ([badge]
/// custom — câmera/mini-avatar — ou [gear] legado).
class CoreflowAvatar extends StatelessWidget {
  const CoreflowAvatar({
    super.key,
    this.initials,
    this.image,
    this.size = 44,
    this.gear = false,
    this.onTap,
    this.glass = true,
    this.fontSize,
    this.badge,
  });

  final String? initials;
  final ImageProvider? image;
  final double size;

  /// Badge de engrenagem no canto (legado). Prefira [badge] pra custom.
  final bool gear;
  final VoidCallback? onTap;

  /// `true` (default) = disco de vidro (canônico do Redesenho); `false` =
  /// gradiente da marca + inicial branca.
  final bool glass;

  /// Override do tamanho da inicial.
  final double? fontSize;

  /// Acessório de canto custom (câmera, mini-avatar). Sobrepõe [gear].
  final Widget? badge;

  @override
  Widget build(BuildContext context) {
    final c = CoreflowScheme.of(context);
    // O DISCO É DO PAI (`DilettaAvatar`): iniciais, foto e a variante de fundo.
    // `glass: true` (o default daqui, 3 de 4 chamadas) é o `outlined` dele — círculo
    // claro com borda; `glass: false` é o `solid`, o cheio da marca.
    //
    // Uma coisa NÃO delega, e ela veio de campo: sem foto E sem iniciais o disco
    // ficava VAZIO (QA #48, perfil salvo sem nome). O fallback é o glifo de pessoa —
    // continua sendo um avatar, e não um buraco na tela. O pai exige `initials` e não
    // tem esse ramo, então ele fica aqui, e é UM caso: as 4 chamadas passam iniciais.
    final semIniciais = (initials ?? '').trim().isEmpty;
    Widget avatar = semIniciais && image == null
        ? Container(
            width: size,
            height: size,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: glass ? CoreflowVidro.tinte(c.paleta, escuro: c.isDark) : null,
              gradient: glass ? null : CoreflowGradients.primaryDoBold,
              border: glass
                  ? Border.all(
                      color: CoreflowVidro.traco(c.paleta, escuro: c.isDark), width: CoreflowVidro.espessuraDoTraco)
                  : null,
            ),
            child: CoreflowIcone('user-light',
                size: size * 0.44,
                color: glass ? c.textSecondary : CoreflowGradients.onGradientDoBold),
          )
        : DilettaAvatar(
            initials: initials ?? '',
            image: image,
            size: size,
            variant: glass
                ? DilettaAvatarVariant.outlined
                : DilettaAvatarVariant.solid,
          );

    // O ACESSÓRIO DE CANTO é composição do produto (câmera do perfil, mini-avatar
    // da home) e não desenho de avatar — por isso ele fica de fora do que delega.
    final acessorio = badge ?? (gear ? _engrenagem(c) : null);
    if (acessorio != null) {
      avatar = SizedBox(
        width: size,
        height: size,
        child: Stack(clipBehavior: Clip.none, children: [
          Positioned.fill(child: avatar),
          Positioned(right: -2, bottom: -2, child: acessorio),
        ]),
      );
    }
    if (onTap == null) return avatar;
    return GestureDetector(
        behavior: HitTestBehavior.opaque, onTap: onTap, child: avatar);
  }

  Widget _engrenagem(CoreflowScheme c) => Container(
        width: 16,
        height: 16,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: c.surface,
          shape: BoxShape.circle,
          border: Border.all(color: c.border, width: 0.75),
        ),
        child: CoreflowIcone('gear-light', size: 8, color: c.textSecondary),
      );
}
