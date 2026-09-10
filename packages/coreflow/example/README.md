# example/ — a Diletta, o Coreflow vestido com a marca da casa

É a **cara do Coreflow**. O pai não declara valor de produto (nenhum hex, asset ou família — o gate
cobra), então a identidade da casa mora aqui, no `example/` do pacote, que é o lugar que o pub reserva
pra "como este pacote se veste quando usado". Nasce pela porta de **uma cor**: `CoreflowProduto.daMarca`
com o `#E60000` do símbolo. Rampa, papéis, vidro, vinho, gradiente e vocabulário derivam pela régua do
avô. O pacote declara três coisas — a cor, a marca (dois SVGs) e a fonte — e é isso que um white label é.

É também um app: `flutter run -d chrome` (ou macOS, ou um simulador) sobe a tela de exemplo com três
botões de modo. O catálogo abre nesta marca, com o Conta BOLD — o primeiro cliente — selecionável.

```dart
import 'package:diletta_coreflow/diletta_coreflow.dart';

MaterialApp(
  theme: Diletta.materialClaro,
  darkTheme: Diletta.materialEscuro,
  builder: (_, filho) => DilettaThemeScope(theme: Diletta.temaClaro, child: filho!),
);
```

`TelaDeExemploDiletta` é a prova em uma tela: nenhuma linha dela é da marca além do tema que a
envolve. `kDilettaFundamentos` é a prosa das decisões (paleta, semáforo, vinho e vidro, Inter, logo) no
formato que o catálogo plunga — a aba de Fundamentos mostra a dela quando a Diletta está escolhida. A cor foi medida antes de escolhida — o `///` de `lib/src/diletta.dart` tem os números,
inclusive a distância do vermelho ao semáforo da linguagem e por que a resposta é forma, não matiz.

## O gate

```bash
flutter analyze && flutter test    # 12
```

Conformidade do avô com baseline vazia, a marca declarada e os arquivos virando com o tema, a fonte
empacotada e aplicada uma vez, e a régua das duas colunas: nada aqui cita outro produto, e o único hex
do pacote é o do símbolo.
