# Meu Banco — um produto do Coreflow

Gerado por `dart run coreflow_design_system:novo_filho`. O que existe aqui é a IDENTIDADE:
uma cor, um nome e (quando você declarar) o logo. O resto — componentes, papéis de cor, tema
Material — vem do DS.

## Montar

```dart
import 'package:meu_banco_coreflow/meu_banco.dart';

MaterialApp(
  theme: meuBanco.materialClaro,
  darkTheme: meuBanco.materialEscuro,
  builder: (_, filho) => DilettaThemeScope(theme: meuBanco.claro, child: filho!),
);
```

## O que decidir depois, e onde

| decisão | onde |
|---|---|
| o logo e o mapa da arte | `marcaVisual:` no `meu_banco.dart` |
| discordar de um degrau derivado | `.comMaterial(...)` sobre a paleta |
| um papel que só este produto tem | `papeisExtras` da paleta |
| um componente que só este produto tem | nasce aqui; sobe pro DS quando um SEGUNDO produto pedir |

## O que NÃO se decide aqui

Erro, aviso, sucesso e a rampa neutra. Cor semântica é invariante nesta linguagem: vermelho de erro
derivado da sua marca daria um produto que não sabe dizer que algo deu errado.
