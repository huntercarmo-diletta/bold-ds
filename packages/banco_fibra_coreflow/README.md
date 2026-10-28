# Banco Fibra — um produto do Coreflow

Gerado por `dart run coreflow:novo_filho`. O que existe aqui é a IDENTIDADE: uma cor, um nome e
(quando você declarar) o logo e a tipografia. O resto — componentes, papéis de cor, tema Material —
vem do Coreflow, e nada vem de outro produto.

## Montar

```dart
import 'package:banco_fibra_coreflow/banco_fibra.dart';

MaterialApp(
  theme: bancoFibra.materialClaro,
  darkTheme: bancoFibra.materialEscuro,
  builder: (_, filho) => DilettaThemeScope(theme: bancoFibra.claro, child: filho!),
);
```

## O que decidir depois, e onde

| decisão | onde |
|---|---|
| o logo e o mapa da arte | `marcaVisual:` no `banco_fibra.dart` |
| a família tipográfica e os degraus da escala | `tipografia:` no `banco_fibra.dart` (`CoreflowTipografia`) |
| discordar de um degrau derivado | `.comMaterial(...)` sobre a paleta |
| um papel que só este produto tem | `papeisExtras` da paleta |
| um componente que só este produto tem | nasce aqui; sobe pro DS quando um SEGUNDO produto pedir |

## O que NÃO se decide aqui

Erro, aviso, sucesso e a rampa neutra. Cor semântica é invariante nesta linguagem: vermelho de erro
derivado da sua marca daria um produto que não sabe dizer que algo deu errado.
