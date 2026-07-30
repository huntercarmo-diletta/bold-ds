// Style Dictionary — gera Dart (Flutter) + CSS vars (web) a partir da fonte
// DTCG em tokens/*.json. Fonte única -> várias plataformas (V2 do plano).
// Rodar: npm run tokens. Saídas commitadas (não são geradas no build do Vercel).
import StyleDictionary from 'style-dictionary';

const leaf = (t) => t.path[t.path.length - 1];
const raw = (t) => t.original?.$value ?? t.$value ?? t.value;
const typ = (t) => t.$type ?? t.type ?? t.original?.$type;
// Valor RESOLVIDO (refs {color.x} já viram hex). `raw` prioriza o original
// (a ref crua); roles precisam do resolvido.
const resolvedRaw = (t) => t.$value ?? t.value ?? t.original?.$value;
// Composite shadow: {color, offsetX, offsetY, blur, spread}.
const shadowVal = (t) => t.$value ?? t.value ?? t.original?.$value;
const num1 = (n) => Number(n).toFixed(1);

// Hex DTCG (#RRGGBB opaco) -> literal Dart ARGB 0xFFRRGGBB.
const toArgb = (hex) => {
  const h = String(hex).replace('#', '').toUpperCase();
  return h.length === 6 ? `0xFF${h}` : `0x${h.slice(6, 8)}${h.slice(0, 6)}`;
};

const banner = (c) =>
  `${c} GERADO por Style Dictionary a partir de tokens/*.json (DTCG).\n` +
  `${c} NÃO editar à mão. Regerar: npm run tokens\n`;

StyleDictionary.registerFormat({
  name: 'dart/cps-color-map',
  format: ({ dictionary }) => {
    const prims = dictionary.allTokens.filter(
      (t) => typ(t) === 'color' && t.path[0] === 'color',
    );
    const mapLines = prims
      .map((t) => `  '${leaf(t)}': ${toArgb(raw(t))},`)
      .join('\n');
    // Classe const de ints — pra Palette/tokens vivos CONSUMIREM o gerado
    // preservando `const` (Map[key] não é const; static const int é).
    const constLines = prims
      .map((t) => `  static const int ${leaf(t)} = ${toArgb(raw(t))};`)
      .join('\n');
    return (
      banner('//') +
      '// ignore_for_file: type=lint\n\n' +
      'const Map<String, int> cpfSeguroColorTokensGen = {\n' +
      mapLines +
      '\n};\n\n' +
      'abstract final class CpfSeguroColorConsts {\n' +
      constLines +
      '\n}\n'
    );
  },
});

// ABSOLUTOS (raiz `absolute`) — as cores que nenhuma marca é dona, então são do
// PAI. Classe separada de propósito: `CpfSeguroColorConsts` são os VALORES de um
// filho, e misturar os dois é o que fazia "widget lê cor estática" não distinguir
// o caso legítimo (branco) da dívida (o azul de um filho dentro do pai).
StyleDictionary.registerFormat({
  name: 'dart/cps-absolute-color-class',
  format: ({ dictionary }) => {
    const lines = dictionary.allTokens
      .filter((t) => typ(t) === 'color' && t.path[0] === 'absolute')
      .map((t) => `  static const int ${leaf(t)} = ${toArgb(raw(t))};`)
      .join('\n');
    return (
      banner('//') +
      '// ignore_for_file: type=lint\n\n' +
      'abstract final class DilettaAbsoluteColorConsts {\n' +
      lines +
      '\n}\n'
    );
  },
});

// Roles semânticos (tier 2) — refs pros primitivos resolvidas em hex. Um mapa
// por modo. Light primeiro (o que o app shippa); dark entra depois.
StyleDictionary.registerFormat({
  name: 'dart/cps-role-map',
  format: ({ dictionary }) => {
    const mapFor = (mode, varName) => {
      const lines = dictionary.allTokens
        .filter((t) => t.path[0] === mode)
        .map((t) => `  '${leaf(t)}': ${toArgb(resolvedRaw(t))},`)
        .join('\n');
      return `const Map<String, int> ${varName} = {\n${lines}\n};`;
    };
    return (
      banner('//') +
      '// ignore_for_file: type=lint\n\n' +
      mapFor('roleLight', 'cpfSeguroRoleLightTokensGen') +
      '\n\n' +
      mapFor('roleDark', 'cpfSeguroRoleDarkTokensGen') +
      '\n'
    );
  },
});

StyleDictionary.registerFormat({
  name: 'dart/cps-dimension-map',
  format: ({ dictionary }) => {
    const nums = dictionary.allTokens.filter((t) => typ(t) === 'number');
    const groups = {};
    for (const t of nums) (groups[t.path[0]] ??= []).push(t);
    const cap = (s) => s.charAt(0).toUpperCase() + s.slice(1);
    const blocks = Object.entries(groups)
      .map(([g, toks]) => {
        const lines = toks
          .map((t) => `  '${leaf(t)}': ${Number(raw(t)).toFixed(1)},`)
          .join('\n');
        return `const Map<String, double> cpfSeguro${cap(g)}TokensGen = {\n${lines}\n};`;
      })
      .join('\n\n');
    return banner('//') + '// ignore_for_file: type=lint\n\n' + blocks + '\n';
  },
});

// Elevation (composite shadow) — classe const de List<BoxShadow> pra o
// DilettaElevation consumir. Só as estáticas light; dark/funções ficam no Dart.
StyleDictionary.registerFormat({
  name: 'dart/cps-shadow-class',
  format: ({ dictionary }) => {
    const boxShadow = (v) => {
      const spread = Number(v.spread) || 0;
      const parts = [
        `color: Color(${toArgb(v.color)})`,
        `offset: Offset(${num1(v.offsetX)}, ${num1(v.offsetY)})`,
        `blurRadius: ${num1(v.blur)}`,
      ];
      if (spread !== 0) parts.push(`spreadRadius: ${num1(spread)}`);
      return `BoxShadow(${parts.join(', ')})`;
    };
    const lines = dictionary.allTokens
      .filter((t) => typ(t) === 'shadow')
      .map((t) => `  static const List<BoxShadow> ${leaf(t)} = [\n    ${boxShadow(shadowVal(t))},\n  ];`)
      .join('\n');
    return (
      banner('//') +
      "import 'package:flutter/widgets.dart';\n\n" +
      '// ignore_for_file: type=lint\n\n' +
      'abstract final class DilettaElevationConsts {\n' +
      lines +
      '\n}\n'
    );
  },
});

// Gradient (composite) — LinearGradient const. Cores são refs resolvidas.
// Número cru (preserva precisão: -0.62 não vira -0.6). Int vira literal double válido.
const alignmentDart = (p) => `Alignment(${p.x}, ${p.y})`;
// Ângulo CSS (0deg = pra cima, horário) do vetor begin->end (y pra baixo).
const cssAngle = (v) =>
  Math.round((Math.atan2(v.end.x - v.begin.x, -(v.end.y - v.begin.y)) * 180) / Math.PI);
StyleDictionary.registerFormat({
  name: 'dart/cps-gradient-class',
  format: ({ dictionary }) => {
    const one = (v) => {
      const colors = v.colors.map((c) => `Color(${toArgb(c)})`).join(', ');
      const stops = v.stops ? `\n    stops: [${v.stops.join(', ')}],` : '';
      return (
        `LinearGradient(\n    begin: ${alignmentDart(v.begin)},\n` +
        `    end: ${alignmentDart(v.end)},${stops}\n    colors: [${colors}],\n  )`
      );
    };
    const lines = dictionary.allTokens
      .filter((t) => typ(t) === 'gradient')
      .map((t) => `  static const LinearGradient ${leaf(t)} = ${one(shadowVal(t))};`)
      .join('\n');
    return (
      banner('//') +
      "import 'package:flutter/widgets.dart';\n\n" +
      '// ignore_for_file: type=lint\n\n' +
      'abstract final class DilettaGradientConsts {\n' +
      lines +
      '\n}\n'
    );
  },
});

// Typography (composite) — TextStyle const. height = lineHeight/fontSize como
// EXPRESSÃO (preserva o ratio exato, ex.: 64 / 57). Estilos com fontFeatures/cor
// (numeric/mono/chatBody/numpad) ficam hand-written no Dart.
StyleDictionary.registerFormat({
  name: 'dart/cps-type-class',
  format: ({ dictionary }) => {
    const one = (v) =>
      `TextStyle(fontSize: ${v.fontSize}, fontWeight: FontWeight.w${v.fontWeight}, ` +
      `height: ${v.lineHeight} / ${v.fontSize}, letterSpacing: ${v.letterSpacing})`;
    const lines = dictionary.allTokens
      .filter((t) => typ(t) === 'typography')
      .map((t) => `  static const TextStyle ${leaf(t)} = ${one(shadowVal(t))};`)
      .join('\n');
    return (
      banner('//') +
      "import 'package:flutter/widgets.dart';\n\n" +
      '// ignore_for_file: type=lint\n\n' +
      'abstract final class DilettaTypeConsts {\n' +
      lines +
      '\n}\n'
    );
  },
});

// Duration (motion) — Duration const (ms). Curvas (Curves.*) e specs
// (duração+curva) ficam hand-written no Dart. Duration é dart:core, sem import.
StyleDictionary.registerFormat({
  name: 'dart/cps-duration-class',
  format: ({ dictionary }) => {
    const lines = dictionary.allTokens
      .filter((t) => typ(t) === 'duration')
      .map((t) => `  static const Duration ${leaf(t)} = Duration(milliseconds: ${Number(resolvedRaw(t))});`)
      .join('\n');
    return (
      banner('//') +
      '// ignore_for_file: type=lint\n\n' +
      'abstract final class DilettaDurationConsts {\n' +
      lines +
      '\n}\n'
    );
  },
});

StyleDictionary.registerFormat({
  name: 'css/cps-vars',
  format: ({ dictionary }) => {
    const vars = dictionary.allTokens
      .map((t) => {
        if (typ(t) === 'shadow') {
          const s = shadowVal(t);
          const v = `${s.offsetX}px ${s.offsetY}px ${s.blur}px ${Number(s.spread) || 0}px ${s.color}`;
          return `  --cps-elevation-${leaf(t)}: ${v};`;
        }
        if (typ(t) === 'gradient') {
          const g = shadowVal(t);
          const stops = g.stops;
          const cols = g.colors
            .map((c, i) => (stops ? `${c} ${(stops[i] * 100).toFixed(2)}%` : c))
            .join(', ');
          return `  --cps-gradient-${leaf(t)}: linear-gradient(${cssAngle(g)}deg, ${cols});`;
        }
        if (typ(t) === 'typography') {
          const y = shadowVal(t);
          const n = leaf(t);
          return (
            `  --cps-type-${n}-size: ${y.fontSize}px;\n` +
            `  --cps-type-${n}-weight: ${y.fontWeight};\n` +
            `  --cps-type-${n}-line-height: ${y.lineHeight}px;\n` +
            `  --cps-type-${n}-spacing: ${y.letterSpacing}px;`
          );
        }
        if (typ(t) === 'duration') {
          return `  --cps-duration-${leaf(t)}: ${Number(resolvedRaw(t))}ms;`;
        }
        const v = typ(t) === 'number' ? `${resolvedRaw(t)}px` : resolvedRaw(t);
        const name = t.path[0] === 'roleLight'
            ? `role-light-${leaf(t)}`
            : t.path[0] === 'roleDark'
                ? `role-dark-${leaf(t)}`
                : leaf(t);
        return `  --cps-${name}: ${v};`;
      })
      .join('\n');
    return banner('/*') + ':root {\n' + vars + '\n}\n';
  },
});

// Os FORMATOS ficam exportados: o filho importa daqui em vez de duplicar 200 linhas
// de configuração. Uma via de autoria pros dois.
export const formatos = StyleDictionary;

export default {
  source: ['tokens/*.json'],
  platforms: {
    dart: {
      buildPath: 'lib/src/theme/generated/',
      files: [
        // Só o que é LINGUAGEM. Cor de marca, papéis e gradiente são gerados pelo
        // filho, com o config dele (que importa os formatos deste arquivo).
        { destination: 'cps_absolute_tokens.g.dart', format: 'dart/cps-absolute-color-class' },
        { destination: 'cps_dimension_tokens.g.dart', format: 'dart/cps-dimension-map' },
        { destination: 'cps_elevation_tokens.g.dart', format: 'dart/cps-shadow-class' },
        { destination: 'cps_type_tokens.g.dart', format: 'dart/cps-type-class' },
        { destination: 'cps_duration_tokens.g.dart', format: 'dart/cps-duration-class' },
      ],
    },
    css: {
      buildPath: 'tokens/generated/',
      files: [{ destination: 'cps-tokens.css', format: 'css/cps-vars' }],
    },
  },
};
