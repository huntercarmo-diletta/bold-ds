/// OS CONTRATOS DESTE PRODUTO — o que o catálogo lê.
///
/// Dois mapas, um nome: `kCoreflowSpecs` são os contratos dos componentes da LINGUAGEM
/// (`bold_contratos.dart`, zero produto dentro) e `kSeloQuanticoSpec` é o do selo quântico, que é
/// marca e mora com o selo. O catálogo continua lendo `kBoldSpecs`, como sempre leu — a separação é
/// de casa, não de contrato.
library;

import 'bold_selo_quantico.dart';
import 'package:coreflow/coreflow.dart';

/// `slug → markdown`, os contratos de tudo que este pacote fornece ao catálogo.
const Map<String, String> kBoldSpecs = {
  ...kCoreflowSpecs,
  'seloQuantico': kSeloQuanticoSpec,
};
