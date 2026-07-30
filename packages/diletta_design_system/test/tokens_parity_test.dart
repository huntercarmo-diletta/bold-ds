import 'dart:io';

import 'package:diletta_design_system/diletta_design_system.dart';
import 'package:diletta_design_system/src/theme/generated/cps_dimension_tokens.g.dart';
import 'package:diletta_design_system/src/theme/generated/cps_elevation_tokens.g.dart';
import 'package:diletta_design_system/src/theme/generated/cps_type_tokens.g.dart';
import 'package:diletta_design_system/src/theme/generated/cps_duration_tokens.g.dart';
import 'package:diletta_design_system/src/theme/generated/cps_absolute_tokens.g.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

/// PARIDADE DA LINGUAGEM: o DTCG do PAI == os tokens vivos do PAI.
///
/// Este arquivo nasceu partindo `tokens_parity_test` em dois, e a linha do corte é a
/// mesma da arquitetura: **escala é linguagem, cor é marca.**
///
/// Aqui ficam breakpoint, radius, spacing, tipografia, duração, elevação e os
/// absolutos — nenhum deles muda de filho pra filho. A paridade de COR (a paleta, os
/// papéis resolvidos, os gradientes) ficou no filho, porque são os valores dele.
///
/// O que os dois arquivos garantem é a mesma coisa: **uma via de autoria.** Editar
/// cor ou escala é editar o DTCG e rodar `npm run tokens`; Dart escrito à mão que
/// discorde do JSON falha aqui.
void main() {
  test('breakpoints gerados (DTCG) == DilettaBreakpoints', () {
    expect(
      cpfSeguroBreakpointTokensGen,
      equals(<String, double>{
        'sm': DilettaBreakpoints.sm,
        'md': DilettaBreakpoints.md,
        'lg': DilettaBreakpoints.lg,
        'xl': DilettaBreakpoints.xl,
      }),
    );
  });

  test('radius gerado (DTCG) == DilettaRadius', () {
    expect(
      cpfSeguroRadiusTokensGen,
      equals(<String, double>{
        'r0': DilettaRadius.r0.x,
        'r2': DilettaRadius.r2.x,
        'r4': DilettaRadius.r4.x,
        'r8': DilettaRadius.r8.x,
        'r16': DilettaRadius.r16.x,
        'r24': DilettaRadius.r24.x,
        'r32': DilettaRadius.r32.x,
        'r40': DilettaRadius.r40.x,
        'r56': DilettaRadius.r56.x,
        'r200': DilettaRadius.r200.x,
      }),
    );
  });

  test('elevation gerada (DTCG shadow) == valores canônicos', () {
    void check(List<BoxShadow> s, int c, double dx, double dy, double b) {
      expect(s.length, 1);
      expect(s.first.color.toARGB32(), c);
      expect(s.first.offset.dx, dx);
      expect(s.first.offset.dy, dy);
      expect(s.first.blurRadius, b);
    }

    check(DilettaElevationConsts.low, 0x21000000, 0, 2, 8);
    check(DilettaElevationConsts.medium, 0x21000000, 5, 4, 20);
    check(DilettaElevationConsts.soft, 0x14000000, 0, 4, 10);
    check(DilettaElevationConsts.overlay, 0x33000000, 0, 4, 12);
    check(DilettaElevationConsts.overlayLg, 0x33000000, 0, 4, 16);
    check(DilettaElevationConsts.keyPress, 0x2D000000, 0, 1, 0);
    check(DilettaElevationConsts.subtle, 0x05000000, 0, 2, 5);
    check(DilettaElevationConsts.input, 0x1A000000, 5, 4, 20);
    check(DilettaElevationConsts.heavy, 0x80000000, 0, 4, 10);
  });

  test('nenhuma sombra do PAI carrega cor de marca', () {
    // As 6 que saíram daqui (brandLow/Medium/High/Soft, navGlow, footerUp) eram const
    // com o azul e o cinza do CPF SEGURO. Viraram forma (`brandLowDe(paleta)`), e este
    // teste é o que impede a volta — porque foi a AUSÊNCIA de gate que deixou entrar,
    // não a falta de regra escrita.
    //
    // O critério é o dono da cor, e ele se lê no hex: sombra do pai é preta ou cinza
    // absoluto (R==G==B). Qualquer matiz é a marca de ALGUÉM, e marca não mora aqui.
    final json = File('tokens/elevation.tokens.json').readAsStringSync();
    final coloridas = <String, String>{};
    for (final m in RegExp(r'"(\w+)":\s*\{\s*"\$value":\s*\{\s*"color":\s*"#([0-9A-Fa-f]{6})')
        .allMatches(json)) {
      final hex = m.group(2)!.toUpperCase();
      final r = hex.substring(0, 2), g = hex.substring(2, 4), b = hex.substring(4, 6);
      if (r != g || g != b) coloridas[m.group(1)!] = '#$hex';
    }
    expect(coloridas, isEmpty,
        reason: 'sombra com matiz no DTCG do pai: $coloridas.\n'
            'Se a sombra tem cor de marca, ela não é const daqui: é FORMA. '
            'Alpha/offset/blur ficam no Dart e a cor entra por paleta — '
            'ver DilettaElevation.brandLowDe.');
  });

  test('typography gerada (DTCG) == valores canônicos', () {
    void t2(TextStyle s, double size, FontWeight w, num lh, double ls) {
      expect(s.fontSize, size);
      expect(s.fontWeight, w);
      expect(s.height, lh / size);
      expect(s.letterSpacing, ls);
    }

    const w4 = FontWeight.w400, w5 = FontWeight.w500, w6 = FontWeight.w600, w7 = FontWeight.w700;

    t2(DilettaTypeConsts.displayLg, 57, w6, 64, -0.25);
    t2(DilettaTypeConsts.displayMd, 45, w6, 52, 0);
    t2(DilettaTypeConsts.displaySm, 36, w6, 44, 0);
    t2(DilettaTypeConsts.headlineLg, 32, w6, 40, 0);
    t2(DilettaTypeConsts.headlineMd, 28, w6, 36, 0);
    t2(DilettaTypeConsts.headlineSm, 24, w6, 32, 0);
    t2(DilettaTypeConsts.titleLg, 22, w5, 28, 0);
    t2(DilettaTypeConsts.titleMd, 16, w5, 24, 0.15);
    t2(DilettaTypeConsts.titleSm, 14, w5, 20, 0.1);
    t2(DilettaTypeConsts.bodyLg, 16, w4, 24, 0.5);
    t2(DilettaTypeConsts.bodyMd, 14, w4, 20, 0.25);
    t2(DilettaTypeConsts.bodySm, 12, w4, 16, 0.4);
    t2(DilettaTypeConsts.labelLg, 14, w6, 20, 1.4);
    t2(DilettaTypeConsts.labelMd, 12, w5, 16, 0.5);
    t2(DilettaTypeConsts.labelSm, 11, w5, 16, 0.5);
    t2(DilettaTypeConsts.display, 36, w7, 44, -0.5);
    t2(DilettaTypeConsts.title, 22, w6, 28, -0.2);
    t2(DilettaTypeConsts.heading, 16, w6, 22, 0);
    t2(DilettaTypeConsts.subheading, 14, w6, 20, 0);
    t2(DilettaTypeConsts.caption, 12, w4, 16, 0.2);
    t2(DilettaTypeConsts.label, 12, w6, 16, 0.5);
    t2(DilettaTypeConsts.overline, 11, w7, 16, 1.0);
    t2(DilettaTypeConsts.button, 15, w6, 20, -0.1);
  });

  test('durations geradas (DTCG) == DilettaMotion (ms)', () {
    expect(DilettaDurationConsts.micro.inMilliseconds, 120);
    expect(DilettaDurationConsts.short.inMilliseconds, 150);
    expect(DilettaDurationConsts.medium.inMilliseconds, 250);
    expect(DilettaDurationConsts.slow.inMilliseconds, 400);
    expect(DilettaDurationConsts.deliberate.inMilliseconds, 600);
    expect(DilettaDurationConsts.spinner.inMilliseconds, 700);
    expect(DilettaDurationConsts.shimmer.inMilliseconds, 1500);
  });

  test('spacing gerado (DTCG) == DilettaSpacing', () {
    expect(
      cpfSeguroSpaceTokensGen,
      equals(<String, double>{
        's0_5': DilettaSpacing.s0_5,
        's1': DilettaSpacing.s1,
        's1_5': DilettaSpacing.s1_5,
        's2': DilettaSpacing.s2,
        's3': DilettaSpacing.s3,
        's4': DilettaSpacing.s4,
        's5': DilettaSpacing.s5,
        's6': DilettaSpacing.s6,
        's8': DilettaSpacing.s8,
        's10': DilettaSpacing.s10,
        's12': DilettaSpacing.s12,
        's16': DilettaSpacing.s16,
        's20': DilettaSpacing.s20,
        's24': DilettaSpacing.s24,
        's32': DilettaSpacing.s32,
        's40': DilettaSpacing.s40,
        's48': DilettaSpacing.s48,
        's56': DilettaSpacing.s56,
        's64': DilettaSpacing.s64,
      }),
    );
  });

  test('os absolutos gerados == DilettaAbsoluteColors', () {
    // O pai é dono de branco, preto e das sombras. Se o gerado divergir da classe,
    // alguém editou Dart à mão em vez do DTCG.
    expect(DilettaAbsoluteColors.white.toARGB32(), DilettaAbsoluteColorConsts.white);
    expect(DilettaAbsoluteColors.blackAlpha40.toARGB32(),
        DilettaAbsoluteColorConsts.blackAlpha40);
    expect(DilettaAbsoluteColors.debugRuler.toARGB32(),
        DilettaAbsoluteColorConsts.debugRuler);
  });
}
