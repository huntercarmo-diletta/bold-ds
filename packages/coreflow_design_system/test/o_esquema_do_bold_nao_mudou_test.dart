import 'package:coreflow_design_system/coreflow_design_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

/// O ESQUEMA DO BOLD NÃO MUDOU — a fotografia de antes dos cortes.
///
/// A fase 1 de `docs/2026-09-04-adr-o-coreflow-e-o-pai.md` tira dos componentes `Coreflow*` toda
/// leitura de constante do Bold e põe no lugar uma leitura da PALETA que veio (ou uma regra sobre
/// ela). A promessa é que **o Bold, montado depois dos cortes, sai idêntico** — pixel a pixel, papel a
/// papel — porque a paleta dele declara tudo o que as constantes diziam.
///
/// Promessa em prosa não se mede. Este arquivo é a medida: [foto] foi tirada em 04/09/2026 sobre a
/// `v0.98.1`, ANTES de qualquer corte, com o mesmo código que a compara hoje. São os 25 papéis do
/// `CoreflowScheme` nos dois modos, os 20 sítios de cor do `ThemeData`, as 8 paradas do lockup, o
/// vidro, os atalhos que o app chama e os 7 tons × 2 modos × 2 formas da etiqueta.
///
/// Se este teste ficar vermelho, um corte mudou o Bold. Não é pra ajustar a foto: é pra achar o corte.
void main() {
  String h(Color? c) =>
      c == null ? 'null' : '0x${c.toARGB32().toRadixString(16).padLeft(8, '0').toUpperCase()}';

  Map<String, String> papeis(CoreflowScheme s) => {
        'background': h(s.background), 'secondaryFlow': h(s.secondaryFlow), 'surface': h(s.surface),
        'surfaceRaised': h(s.surfaceRaised), 'field': h(s.field), 'surfacePressed': h(s.surfacePressed),
        'textPrimary': h(s.textPrimary), 'textSecondary': h(s.textSecondary), 'textMuted': h(s.textMuted),
        'border': h(s.border), 'borderSoft': h(s.borderSoft), 'borderStrong': h(s.borderStrong),
        'overlay': h(s.overlay), 'primary': h(s.primary), 'onPrimary': h(s.onPrimary),
        'primaryPressed': h(s.primaryPressed), 'primaryWash': h(s.primaryWash), 'danger': h(s.danger),
        'success': h(s.success), 'warning': h(s.warning), 'info': h(s.info), 'infoSubtle': h(s.infoSubtle),
        'vinho': h(s.vinho), 'vinhoTinta': h(s.vinhoTinta), 'vinhoLavagem': h(s.vinhoLavagem),
      };

  Color? borda(InputBorder? b) => b is OutlineInputBorder ? b.borderSide.color : null;

  Map<String, String> material(ThemeData t) => {
        'colorScheme.primary': h(t.colorScheme.primary), 'colorScheme.onPrimary': h(t.colorScheme.onPrimary),
        'colorScheme.secondary': h(t.colorScheme.secondary), 'colorScheme.surface': h(t.colorScheme.surface),
        'colorScheme.onSurface': h(t.colorScheme.onSurface), 'colorScheme.error': h(t.colorScheme.error),
        'colorScheme.onError': h(t.colorScheme.onError),
        'scaffoldBackgroundColor': h(t.scaffoldBackgroundColor), 'canvasColor': h(t.canvasColor),
        'dividerTheme.color': h(t.dividerTheme.color), 'iconTheme.color': h(t.iconTheme.color),
        'cardTheme.color': h(t.cardTheme.color),
        'bottomSheetTheme.backgroundColor': h(t.bottomSheetTheme.backgroundColor),
        'textButton.foreground': h(t.textButtonTheme.style?.foregroundColor?.resolve({})),
        'inputDecoration.fill': h(t.inputDecorationTheme.fillColor),
        'inputDecoration.focused': h(borda(t.inputDecorationTheme.focusedBorder)),
        'inputDecoration.hint': h(t.inputDecorationTheme.hintStyle?.color),
        'textTheme.bodyMedium': h(t.textTheme.bodyMedium?.color),
        'textTheme.labelSmall': h(t.textTheme.labelSmall?.color),
        'fontFamily': t.textTheme.bodyLarge?.fontFamily ?? 'null',
      };

  /// O que o Bold é HOJE, medido pelo mesmo código acima.
  Map<String, String> hoje() {
    final b = <String, String>{};
    final p = CoreflowProduto.bold;
    papeis(p.esquemaClaro).forEach((k, v) => b['claro.$k'] = v);
    papeis(p.esquemaEscuro).forEach((k, v) => b['escuro.$k'] = v);
    material(p.materialClaro).forEach((k, v) => b['materialClaro.$k'] = v);
    material(p.materialEscuro).forEach((k, v) => b['materialEscuro.$k'] = v);
    final g = p.gradientes;
    for (var i = 0; i < g.primary.colors.length; i++) {
      b['gradiente.primary.$i'] = h(g.primary.colors[i]);
      b['gradiente.primary.stop.$i'] = g.primary.stops![i].toString();
    }
    for (var i = 0; i < g.accent.colors.length; i++) {
      b['gradiente.accent.$i'] = h(g.accent.colors[i]);
    }
    b['gradiente.onGradient'] = h(g.onGradient);
    b['atalho.primaryDoBold.0'] = h(CoreflowGradients.primaryDoBold.colors.first);
    b['atalho.onGradientDoBold'] = h(CoreflowGradients.onGradientDoBold);
    final pal = p.paleta;
    for (final escuro in [false, true]) {
      final m = escuro ? 'escuro' : 'claro';
      b['vidro.$m.tinte'] = h(CoreflowVidro.tinte(pal, escuro: escuro));
      b['vidro.$m.traco'] = h(CoreflowVidro.traco(pal, escuro: escuro));
      b['vidro.$m.blur'] = CoreflowVidro.blur(pal).toString();
      b['vidroDeEntrada.$m.base'] = h(CoreflowVidroDeEntrada.base(pal, escuro: escuro));
      b['vidroDeEntrada.$m.traco'] = h(CoreflowVidroDeEntrada.traco(pal, escuro: escuro));
    }
    b['theme.light.bg'] = h(CoreflowTheme.light.scheme.bg);
    b['theme.dark.bg'] = h(CoreflowTheme.dark.scheme.bg);
    b['theme.light.primary'] = h(CoreflowTheme.light.scheme.primary);
    b['scheme.dark().surfaceRaised'] = h(CoreflowScheme.dark().surfaceRaised);
    b['scheme.light().surfaceRaised'] = h(CoreflowScheme.light().surfaceRaised);
    return b;
  }

  test('os papéis, o ThemeData, os gradientes e o vidro do Bold são os da foto', () {
    final agora = hoje();
    final diferentes = <String>[];
    for (final e in foto.entries) {
      if (e.key.startsWith('etiqueta.')) continue;
      if (agora[e.key] != e.value) diferentes.add('${e.key}: foto ${e.value} → hoje ${agora[e.key]}');
    }
    expect(diferentes, isEmpty, reason: 'um corte mudou o Bold:\n${diferentes.join("\n")}');
    // E a foto cobre tudo que o medidor mede: chave nova sem foto é medida que ninguém conferiu.
    expect(agora.keys.where((k) => !foto.containsKey(k)), isEmpty,
        reason: 'o medidor ganhou chave que a foto não tem');
  });

  testWidgets('e a etiqueta pinta os 7 tons como na foto, nos dois modos', (t) async {
    final diferentes = <String>[];
    for (final escuro in [false, true]) {
      for (final tone in DilettaStatusTone.values) {
        for (final dot in [false, true]) {
          await t.pumpWidget(MaterialApp(
            theme: escuro ? CoreflowTemaMaterial.escuro : CoreflowTemaMaterial.claro,
            home: Center(child: CoreflowEtiqueta(label: 'x', tone: tone, dot: dot)),
          ));
          final deco =
              t.widget<Container>(find.byType(Container).first).decoration as BoxDecoration;
          final txt = t.widget<Text>(find.text('x'));
          final k = 'etiqueta.${escuro ? 'escuro' : 'claro'}.${tone.name}${dot ? '.dot' : ''}';
          for (final par in [
            ('$k.fill', h(deco.color)),
            ('$k.stroke', h(deco.border!.top.color)),
            ('$k.fg', h(txt.style?.color)),
          ]) {
            if (foto[par.$1] != par.$2) diferentes.add('${par.$1}: foto ${foto[par.$1]} → hoje ${par.$2}');
          }
        }
      }
    }
    expect(diferentes, isEmpty, reason: 'um corte mudou a etiqueta do Bold:\n${diferentes.join("\n")}');
  });
}

/// A FOTO — tirada em 04/09/2026 sobre a `v0.98.1`, antes do primeiro corte. Não se edita.
const Map<String, String> foto = {
  'claro.background': '0xFFF4F3F6',
  'claro.secondaryFlow': '0xFFF6F3F5',
  'claro.surface': '0xFFFFFFFF',
  'claro.surfaceRaised': '0xFFFFFFFF',
  'claro.field': '0xFFF1F0F4',
  'claro.surfacePressed': '0xFFE8E7EE',
  'claro.textPrimary': '0xFF3D3939',
  'claro.textSecondary': '0xFF6B6678',
  'claro.textMuted': '0xFF8A8398',
  'claro.border': '0x12000000',
  'claro.borderSoft': '0x0D000000',
  'claro.borderStrong': '0x24000000',
  'claro.overlay': '0xD9F4F3F6',
  'claro.primary': '0xFF9E1241',
  'claro.onPrimary': '0xFFFFFFFF',
  'claro.primaryPressed': '0xFF600627',
  'claro.primaryWash': '0xFFFFEDF3',
  'claro.danger': '0xFFB42318',
  'claro.success': '0xFF0E9154',
  'claro.warning': '0xFFF6A21A',
  'claro.info': '0xFF3B82F6',
  'claro.infoSubtle': '0x1C3B82F6',
  'claro.vinho': '0xFF90093A',
  'claro.vinhoTinta': '0xFF16060A',
  'claro.vinhoLavagem': '0xFF420616',
  'escuro.background': '0xFF0A0B12',
  'escuro.secondaryFlow': '0xFF100913',
  'escuro.surface': '0xFF14151F',
  'escuro.surfaceRaised': '0xFF1A1B27',
  'escuro.field': '0xFF1E1F2D',
  'escuro.surfacePressed': '0xFF2A2C3A',
  'escuro.textPrimary': '0xFFFFFFFF',
  'escuro.textSecondary': '0xFFB7BBC8',
  'escuro.textMuted': '0xFF686D7E',
  'escuro.border': '0x14FFFFFF',
  'escuro.borderSoft': '0x12FFFFFF',
  'escuro.borderStrong': '0x2EFFFFFF',
  'escuro.overlay': '0xB30A0B12',
  'escuro.primary': '0xFFF66FA0',
  'escuro.onPrimary': '0xFF000000',
  'escuro.primaryPressed': '0xFF9E1241',
  'escuro.primaryWash': '0x33FE3976',
  'escuro.danger': '0xFFFF4D5E',
  'escuro.success': '0xFF2FD27A',
  'escuro.warning': '0xFFFDB43D',
  'escuro.info': '0xFF3B82F6',
  'escuro.infoSubtle': '0x1C3B82F6',
  'escuro.vinho': '0xFF90093A',
  'escuro.vinhoTinta': '0xFF16060A',
  'escuro.vinhoLavagem': '0xFF420616',
  'materialClaro.colorScheme.primary': '0xFFFE3976',
  'materialClaro.colorScheme.onPrimary': '0xFFFFFFFF',
  'materialClaro.colorScheme.secondary': '0xFFFE3976',
  'materialClaro.colorScheme.surface': '0xFFFFFFFF',
  'materialClaro.colorScheme.onSurface': '0xFF3D3939',
  'materialClaro.colorScheme.error': '0xFFEF4757',
  'materialClaro.colorScheme.onError': '0xFFFFFFFF',
  'materialClaro.scaffoldBackgroundColor': '0xFFF4F3F6',
  'materialClaro.canvasColor': '0xFFF4F3F6',
  'materialClaro.dividerTheme.color': '0x12000000',
  'materialClaro.iconTheme.color': '0xFF6B6678',
  'materialClaro.cardTheme.color': '0xFFFFFFFF',
  'materialClaro.bottomSheetTheme.backgroundColor': '0xFFFFFFFF',
  'materialClaro.textButton.foreground': '0xFFFE3976',
  'materialClaro.inputDecoration.fill': '0xFFF1F0F4',
  'materialClaro.inputDecoration.focused': '0xFFFE3976',
  'materialClaro.inputDecoration.hint': '0xFF8A8398',
  'materialClaro.textTheme.bodyMedium': '0xFF3D3939',
  'materialClaro.textTheme.labelSmall': '0xFF6B6678',
  'materialClaro.fontFamily': 'packages/coreflow_design_system/Inter',
  'materialEscuro.colorScheme.primary': '0xFFFE3976',
  'materialEscuro.colorScheme.onPrimary': '0xFF000000',
  'materialEscuro.colorScheme.secondary': '0xFFFE3976',
  'materialEscuro.colorScheme.surface': '0xFF14151F',
  'materialEscuro.colorScheme.onSurface': '0xFFFFFFFF',
  'materialEscuro.colorScheme.error': '0xFFEF4757',
  'materialEscuro.colorScheme.onError': '0xFFFFFFFF',
  'materialEscuro.scaffoldBackgroundColor': '0xFF0A0B12',
  'materialEscuro.canvasColor': '0xFF0A0B12',
  'materialEscuro.dividerTheme.color': '0x14FFFFFF',
  'materialEscuro.iconTheme.color': '0xFFB7BBC8',
  'materialEscuro.cardTheme.color': '0xFF14151F',
  'materialEscuro.bottomSheetTheme.backgroundColor': '0xFF14151F',
  'materialEscuro.textButton.foreground': '0xFFFE3976',
  'materialEscuro.inputDecoration.fill': '0xFF1E1F2D',
  'materialEscuro.inputDecoration.focused': '0xFFFE3976',
  'materialEscuro.inputDecoration.hint': '0xFF686D7E',
  'materialEscuro.textTheme.bodyMedium': '0xFFFFFFFF',
  'materialEscuro.textTheme.labelSmall': '0xFFB7BBC8',
  'materialEscuro.fontFamily': 'packages/coreflow_design_system/Inter',
  'gradiente.primary.0': '0xFFFE3976',
  'gradiente.primary.stop.0': '0.0',
  'gradiente.primary.1': '0xFFFE3D74',
  'gradiente.primary.stop.1': '0.14',
  'gradiente.primary.2': '0xFFFE4A70',
  'gradiente.primary.stop.2': '0.29',
  'gradiente.primary.3': '0xFFFE5E69',
  'gradiente.primary.stop.3': '0.45',
  'gradiente.primary.4': '0xFFFE7B5E',
  'gradiente.primary.stop.4': '0.6',
  'gradiente.primary.5': '0xFFFEA150',
  'gradiente.primary.stop.5': '0.75',
  'gradiente.primary.6': '0xFFFECE40',
  'gradiente.primary.stop.6': '0.91',
  'gradiente.primary.7': '0xFFFEED35',
  'gradiente.primary.stop.7': '1.0',
  'gradiente.accent.0': '0xFFC47C0A',
  'gradiente.accent.1': '0xFF85520A',
  'gradiente.onGradient': '0xFF16060A',
  'atalho.primaryDoBold.0': '0xFFFE3976',
  'atalho.onGradientDoBold': '0xFF16060A',
  'vidro.claro.tinte': '0x80FFFFFF',
  'vidro.claro.traco': '0xFFFFEDF3',
  'vidro.claro.blur': '15.0',
  'vidroDeEntrada.claro.base': '0xFFFFF6FA',
  'vidroDeEntrada.claro.traco': '0xFFFFB6CB',
  'vidro.escuro.tinte': '0x8016060A',
  'vidro.escuro.traco': '0x4DFF9898',
  'vidro.escuro.blur': '15.0',
  'vidroDeEntrada.escuro.base': '0xFF420616',
  'vidroDeEntrada.escuro.traco': '0xFF9E1241',
  'theme.light.bg': '0xFFF4F3F6',
  'theme.dark.bg': '0xFF0A0B12',
  'theme.light.primary': '0xFFFE3976',
  'scheme.dark().surfaceRaised': '0xFF1A1B27',
  'scheme.light().surfaceRaised': '0xFFFFFFFF',
  'etiqueta.claro.warning.fill': '0xFFFEF6E7',
  'etiqueta.claro.warning.stroke': '0xFFC47C0A',
  'etiqueta.claro.warning.fg': '0xFFC47C0A',
  'etiqueta.claro.warning.dot.fill': '0xFFFEF6E7',
  'etiqueta.claro.warning.dot.stroke': '0xFFC47C0A',
  'etiqueta.claro.warning.dot.fg': '0xFFC47C0A',
  'etiqueta.claro.neutral.fill': '0xFFF6F6F6',
  'etiqueta.claro.neutral.stroke': '0xFF737373',
  'etiqueta.claro.neutral.fg': '0xFF737373',
  'etiqueta.claro.neutral.dot.fill': '0xFFF6F6F6',
  'etiqueta.claro.neutral.dot.stroke': '0xFF737373',
  'etiqueta.claro.neutral.dot.fg': '0xFF737373',
  'etiqueta.claro.primary.fill': '0xFFFFEDF3',
  'etiqueta.claro.primary.stroke': '0xFFFE3976',
  'etiqueta.claro.primary.fg': '0xFFFE3976',
  'etiqueta.claro.primary.dot.fill': '0xFFFFEDF3',
  'etiqueta.claro.primary.dot.stroke': '0xFFFE3976',
  'etiqueta.claro.primary.dot.fg': '0xFFFE3976',
  'etiqueta.claro.success.fill': '0x66FFFFFF',
  'etiqueta.claro.success.stroke': '0xBDFFFFFF',
  'etiqueta.claro.success.fg': '0xFF0E9154',
  'etiqueta.claro.success.dot.fill': '0x66FFFFFF',
  'etiqueta.claro.success.dot.stroke': '0xBDFFFFFF',
  'etiqueta.claro.success.dot.fg': '0xFF0E9154',
  'etiqueta.claro.danger.fill': '0x66FFFFFF',
  'etiqueta.claro.danger.stroke': '0xBDFFFFFF',
  'etiqueta.claro.danger.fg': '0xFFEF4757',
  'etiqueta.claro.danger.dot.fill': '0x66FFFFFF',
  'etiqueta.claro.danger.dot.stroke': '0xBDFFFFFF',
  'etiqueta.claro.danger.dot.fg': '0xFFEF4757',
  'etiqueta.claro.secure.fill': '0xFFFBF3D6',
  'etiqueta.claro.secure.stroke': '0xFF8A6D1F',
  'etiqueta.claro.secure.fg': '0xFF8A6D1F',
  'etiqueta.claro.secure.dot.fill': '0xFFFBF3D6',
  'etiqueta.claro.secure.dot.stroke': '0xFF8A6D1F',
  'etiqueta.claro.secure.dot.fg': '0xFF8A6D1F',
  'etiqueta.claro.pending.fill': '0xFFFEF6E7',
  'etiqueta.claro.pending.stroke': '0xFFC47C0A',
  'etiqueta.claro.pending.fg': '0xFFC47C0A',
  'etiqueta.claro.pending.dot.fill': '0xFFFEF6E7',
  'etiqueta.claro.pending.dot.stroke': '0xFFC47C0A',
  'etiqueta.claro.pending.dot.fg': '0xFFC47C0A',
  'etiqueta.escuro.warning.fill': '0xFFFEF6E7',
  'etiqueta.escuro.warning.stroke': '0xFFC47C0A',
  'etiqueta.escuro.warning.fg': '0xFFC47C0A',
  'etiqueta.escuro.warning.dot.fill': '0xFFFEF6E7',
  'etiqueta.escuro.warning.dot.stroke': '0xFFC47C0A',
  'etiqueta.escuro.warning.dot.fg': '0xFFC47C0A',
  'etiqueta.escuro.neutral.fill': '0xFFF6F6F6',
  'etiqueta.escuro.neutral.stroke': '0xFF737373',
  'etiqueta.escuro.neutral.fg': '0xFF737373',
  'etiqueta.escuro.neutral.dot.fill': '0xFFF6F6F6',
  'etiqueta.escuro.neutral.dot.stroke': '0xFF737373',
  'etiqueta.escuro.neutral.dot.fg': '0xFF737373',
  'etiqueta.escuro.primary.fill': '0xFFFFEDF3',
  'etiqueta.escuro.primary.stroke': '0xFFFE3976',
  'etiqueta.escuro.primary.fg': '0xFFFE3976',
  'etiqueta.escuro.primary.dot.fill': '0xFFFFEDF3',
  'etiqueta.escuro.primary.dot.stroke': '0xFFFE3976',
  'etiqueta.escuro.primary.dot.fg': '0xFFFE3976',
  'etiqueta.escuro.success.fill': '0x66FFFFFF',
  'etiqueta.escuro.success.stroke': '0xBDFFFFFF',
  'etiqueta.escuro.success.fg': '0xFF0E9154',
  'etiqueta.escuro.success.dot.fill': '0x66FFFFFF',
  'etiqueta.escuro.success.dot.stroke': '0xBDFFFFFF',
  'etiqueta.escuro.success.dot.fg': '0xFF0E9154',
  'etiqueta.escuro.danger.fill': '0x66FFFFFF',
  'etiqueta.escuro.danger.stroke': '0xBDFFFFFF',
  'etiqueta.escuro.danger.fg': '0xFFEF4757',
  'etiqueta.escuro.danger.dot.fill': '0x66FFFFFF',
  'etiqueta.escuro.danger.dot.stroke': '0xBDFFFFFF',
  'etiqueta.escuro.danger.dot.fg': '0xFFEF4757',
  'etiqueta.escuro.secure.fill': '0xFFFBF3D6',
  'etiqueta.escuro.secure.stroke': '0xFF8A6D1F',
  'etiqueta.escuro.secure.fg': '0xFF8A6D1F',
  'etiqueta.escuro.secure.dot.fill': '0xFFFBF3D6',
  'etiqueta.escuro.secure.dot.stroke': '0xFF8A6D1F',
  'etiqueta.escuro.secure.dot.fg': '0xFF8A6D1F',
  'etiqueta.escuro.pending.fill': '0xFFFEF6E7',
  'etiqueta.escuro.pending.stroke': '0xFFC47C0A',
  'etiqueta.escuro.pending.fg': '0xFFC47C0A',
  'etiqueta.escuro.pending.dot.fill': '0xFFFEF6E7',
  'etiqueta.escuro.pending.dot.stroke': '0xFFC47C0A',
  'etiqueta.escuro.pending.dot.fg': '0xFFC47C0A',
};
