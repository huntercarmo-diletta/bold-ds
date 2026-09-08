import 'package:coreflow/coreflow.dart';
import 'package:flutter/material.dart' show Brightness;

/// O NETO — o produto-fixture dos testes do pai.
///
/// O pai não tem produto: não tem paleta, logo nem fonte. Pra montar uma peça em teste ele precisa
/// de UM tema, e o tema é o da paleta de REFERÊNCIA do avô (verde, mantida por ele) com a marca
/// `nenhuma` (sem logo). É a mesma fixture que o filho chama de "neto" nos gates dele — um produto
/// que não é o Bold e prova, pela própria existência, que a peça não precisa dele.
abstract final class Neto {
  static DilettaTheme _monta(Brightness b) {
    // Sem esta linha nenhum ícone do avô aparece: num pacote consumidor os assets moram em
    // `packages/diletta_design_system/…`, e o loader procura na raiz do bundle.
    DilettaAssets.assetPackage ??= DilettaAssets.package;
    return DilettaTheme.resolve(
        palette: DilettaPalette.referencia, brand: DilettaBrand.nenhuma, brightness: b);
  }

  static final DilettaTheme claro = _monta(Brightness.light);
  static final DilettaTheme escuro = _monta(Brightness.dark);
}
