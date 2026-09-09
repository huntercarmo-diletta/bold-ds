# diletta_coreflow — a Diletta como produto do Coreflow

O segundo filho do pai, e o primeiro pela porta de **uma cor**: `CoreflowProduto.daMarca` com o
`#E60000` do símbolo. Rampa, papéis, vidro, vinho, gradiente e vocabulário derivam pela régua do avô.
O pacote declara três coisas — a cor, a marca (dois SVGs) e a fonte — e é isso que um white label é.

```dart
import 'package:diletta_coreflow/diletta_coreflow.dart';

MaterialApp(
  theme: Diletta.materialClaro,
  darkTheme: Diletta.materialEscuro,
  builder: (_, filho) => DilettaThemeScope(theme: Diletta.temaClaro, child: filho!),
);
```

`TelaDeExemploDiletta` é a prova em uma tela: nenhuma linha dela é da marca além do tema que a
envolve. A cor foi medida antes de escolhida — o `///` de `lib/src/diletta.dart` tem os números,
inclusive a distância do vermelho ao semáforo da linguagem e por que a resposta é forma, não matiz.

## O gate

```bash
flutter analyze && flutter test
```

Conformidade do avô com baseline vazia, a marca declarada e os arquivos virando com o tema, a fonte
empacotada e aplicada uma vez, e a régua das duas colunas: nada aqui cita outro produto, e o único hex
do pacote é o do símbolo.
