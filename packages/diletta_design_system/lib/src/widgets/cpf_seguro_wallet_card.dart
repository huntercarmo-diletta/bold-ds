import 'package:flutter/widgets.dart';
import '../theme/cpf_seguro_theme.dart';
import '../theme/cpf_seguro_metrics.dart';
import '../theme/cpf_seguro_typography.dart';
import '../theme/diletta_absolute_colors.dart';
import 'cpf_seguro_icon_accessory.dart' show DilettaIconAccessory;
import 'cpf_seguro_logo.dart';
import 'cpf_seguro_dev_inspect.dart';
import '../theme/cpf_seguro_icon_tokens.dart';
import '../theme/diletta_brand_assets.dart';

/// CPF SEGURO — WalletCard (molécula).
///
/// Cartão visual da Carteira: 345×180 (width flexível), radius 24,
/// padding px 24 py 16. Figma 1152:21383.
///
/// Variantes (named constructors):
/// - [DilettaWalletCard.cpfSeguro] — azul primary-04: wordmark "CPF seguro"
///   branco topo-esquerda + mark Pix 25 topo-direita + "••• 1234" embaixo.
/// - [DilettaWalletCard.partner] — skin escura do cartão físico (cardDark):
///   logo do parceiro topo-direita + últimos dígitos e bandeira embaixo.
/// - [DilettaWalletCard.skeleton] — cinza com tarja, usado no fluxo de
///   adicionar cartão ("Aproxime do cartão" / "Adicionando cartão").
/// - [DilettaWalletCard.payment] — azul do fluxo Pagar: label
///   "Pix aproximação" topo-esquerda + wordmark topo-direita + mark 36
///   embaixo-esquerda.
///
/// **Composição** — Icon (átomo) + tokens.
class DilettaWalletCard extends StatelessWidget {
  const DilettaWalletCard.cpfSeguro({
    super.key,
    this.lastDigits = '7654',
  })  : _variant = _WalletVariant.cpfSeguro,
        label = null,
        partnerLogo = null,
        networkLogo = null;

  const DilettaWalletCard.partner({
    super.key,
    this.lastDigits = '7654',
    this.partnerLogo,
    this.networkLogo,
  })  : _variant = _WalletVariant.partner,
        label = null;

  const DilettaWalletCard.skeleton({super.key})
      : _variant = _WalletVariant.skeleton,
        lastDigits = null,
        label = null,
        partnerLogo = null,
        networkLogo = null;

  const DilettaWalletCard.payment({
    super.key,
    this.label = 'Pix aproximação',
  })  : _variant = _WalletVariant.payment,
        lastDigits = null,
        partnerLogo = null,
        networkLogo = null;

  /// Splash do NFC/aproximação: fundo primary, mark grande à esquerda +
  /// mark Pix à direita. Responsivo (AspectRatio 2), não altura fixa.
  const DilettaWalletCard.pixSplash({super.key})
      : _variant = _WalletVariant.pixSplash,
        lastDigits = null,
        label = null,
        partnerLogo = null,
        networkLogo = null;

  final _WalletVariant _variant;

  /// Últimos 4 dígitos ("7654") — renderizado como "••• 7654".
  final String? lastDigits;

  /// Label do fluxo Pagar ("Pix aproximação").
  final String? label;

  /// Asset do logo do parceiro (variante partner).
  ///
  /// `null` = usa o que o filho instalou em [DilettaBrandAssets.logoParceiro]. Os
  /// dois defaults eram `'assets/logos/swile.png'` e `'assets/logos/card-network.png'`
  /// escritos aqui — arquivo de um parceiro específico como padrão da linguagem.
  final String? partnerLogo;

  /// Asset da bandeira (variante partner). `null` = o que o filho instalou.
  final String? networkLogo;

  static const double height = 180;


  @override
  Widget build(BuildContext context) {
    final tema = DilettaTheme.of(context);
    final s = tema.scheme;
    return DilettaDevInfo(
      component: 'DilettaWalletCard',
      props: {
        'variant': _variant.name,
        if (lastDigits != null) 'lastDigits': lastDigits!,
        if (label != null) 'label': "'$label'",
      },
      tokens: [
        '345×180 · radius 24 · px 24 py 16',
        switch (_variant) {
          _WalletVariant.cpfSeguro ||
          _WalletVariant.payment ||
          _WalletVariant.pixSplash =>
            'bg: primary-04 · logo/mark white',
          _WalletVariant.partner => 'bg: cardDark (#272727)',
          _WalletVariant.skeleton => 'gradient neutral-07→08 + tarja neutral-06',
        },
      ],
      child: _wrapAspect(Container(
      height: _variant == _WalletVariant.pixSplash ? null : height,
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: switch (_variant) {
          _WalletVariant.cpfSeguro ||
          _WalletVariant.payment ||
          _WalletVariant.pixSplash =>
            s.primary,
          _WalletVariant.partner => s.partnerSurface,
          _WalletVariant.skeleton => null,
        },
        gradient: _variant == _WalletVariant.skeleton
            ? LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [s.palette.neutral07, s.palette.neutral08],
              )
            : null,
        borderRadius: DilettaRadius.all24,
      ),
      child: switch (_variant) {
        _WalletVariant.cpfSeguro => _buildCpf(),
        _WalletVariant.partner => _buildPartner(tema.brand),
        _WalletVariant.skeleton => _buildSkeleton(),
        _WalletVariant.payment => _buildPayment(),
        _WalletVariant.pixSplash => _buildPixSplash(),
      },
      )),
    );
  }

  /// pixSplash é responsivo (AspectRatio 2) em vez de altura fixa.
  Widget _wrapAspect(Widget card) {
    if (_variant == _WalletVariant.pixSplash) {
      return AspectRatio(aspectRatio: 2, child: card);
    }
    return card;
  }

  Widget _buildPixSplash() {
    return Padding(
      padding: const EdgeInsets.symmetric(
          horizontal: DilettaSpacing.s6, vertical: DilettaSpacing.s4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          DilettaLogo(
              variant: DilettaLogoVariant.mark,
              size: 68,
              color: DilettaAbsoluteColors.white),
          Spacer(),
          DilettaIconAccessory(
              icon: DilettaIcons.pixSolid,
              padding: 0,
              size: 50,
              color: DilettaAbsoluteColors.white),
        ],
      ),
    );
  }

  Widget _buildCpf() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: DilettaSpacing.s6, vertical: DilettaSpacing.s4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              DilettaLogo(variant: DilettaLogoVariant.full, size: 26, color: DilettaAbsoluteColors.white),
              DilettaIconAccessory(icon: DilettaIcons.pixMark, padding: 0, size: 25, color: DilettaAbsoluteColors.white),
            ],
          ),
          Text(
            '••• ${lastDigits ?? ''}',
            style: DilettaType.heading.copyWith(color: DilettaAbsoluteColors.white),
          ),
        ],
      ),
    );
  }

  Widget _buildPartner(DilettaBrand marca) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: DilettaSpacing.s6, vertical: DilettaSpacing.s4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          if (partnerLogo ?? marca.logoParceiro case final logo?)
            Image.asset(logo, height: 25, package: marca.pacote),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '••• ${lastDigits ?? ''}',
                style: DilettaType.heading.copyWith(color: DilettaAbsoluteColors.white),
              ),
              if (networkLogo ?? marca.bandeiraDoCartao case final bandeira?)
                Image.asset(bandeira, height: 30, package: marca.pacote),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSkeleton() {
    // Tarja magnética 44px a 16px do topo (fluxo adicionar cartão).
    return Column(
      children: [
        const SizedBox(height: 16),
        DilettaTheme.comEsquema((s) => Container(height: 44, color: s.surfaceLoadingStrong)),
      ],
    );
  }

  Widget _buildPayment() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: DilettaSpacing.s6, vertical: DilettaSpacing.s4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label ?? '',
                style: DilettaType.subheading.copyWith(color: DilettaAbsoluteColors.white),
              ),
              DilettaLogo(variant: DilettaLogoVariant.full, size: 26, color: DilettaAbsoluteColors.white),
            ],
          ),
          DilettaIconAccessory(icon: DilettaIcons.pixMark, padding: 0, size: 36, color: DilettaAbsoluteColors.white),
        ],
      ),
    );
  }
}

enum _WalletVariant { cpfSeguro, partner, skeleton, payment, pixSplash }
