import 'package:flutter/foundation.dart';

/// OS ASSETS DE MARCA — identidade, e por isso viajam no TEMA.
///
/// A divisão de assets segue a regra do dono do produto: **ou o filho herda tudo, ou
/// oferece o mínimo pra herdar.** Na prática ela cai em dois grupos:
///
/// - **ícone e ilustração** viajam no PAI. São vocabulário, não marca: um botão de
///   fechar precisa de um X, e o X é o mesmo em qualquer produto. Um filho que queira
///   outra família aponta [DilettaAssets.package] pro pacote dele, cobrindo os nomes
///   que os componentes usam (`minimo_de_assets_test` cobra a lista);
/// - **logo e fonte** viajam no FILHO. Não existe "logo padrão": é a identidade.
///
/// O problema que isto resolve: o WIDGET do logo é do pai — todo produto tem um logo
/// num header — e o ARQUIVO é do filho. O pai precisa saber em que pacote procurar.
///
/// ## Por que no tema, e não num singleton configurável
///
/// A primeira versão disto era uma classe com `static` mutável e um `configurar()`,
/// chamado pelo inicializador do tema do filho. Funcionava, e o teste que eu escrevi
/// pra ela **falhou na segunda asserção** — porque `static final` em Dart inicializa
/// UMA vez: depois de um reset, tocar o tema de novo não reinstalava nada. O
/// resultado passava a depender da ordem de execução.
///
/// Isso não era um bug do teste, era o desenho avisando. Identidade global mutável
/// tem sempre esse problema; identidade que viaja no tema não tem nenhum. E o resto
/// do sistema já funcionava assim: a PALETA de um filho chega pelo
/// [DilettaThemeScope], não por um setter. A marca é a mesma categoria de coisa.
///
/// Agora é um valor imutável dentro do [DilettaTheme]: trocar de marca é trocar o
/// scope, exatamente como trocar de paleta ou de modo.
@immutable
class DilettaBrand {
  const DilettaBrand({
    required this.pacote,
    this.logo = 'assets/logos/logo.svg',
    this.logoFull = 'assets/logos/logo-full.svg',
    this.logoParceiro,
    this.bandeiraDoCartao,
  });

  const DilettaBrand._nenhuma()
      : pacote = null,
        logo = 'assets/logos/logo.svg',
        logoFull = 'assets/logos/logo-full.svg',
        logoParceiro = null,
        bandeiraDoCartao = null;

  /// MARCA NENHUMA — o default da linguagem.
  ///
  /// Um tema sem marca desenha os componentes todos, menos os que precisam de um
  /// arquivo de marca: esses somem em vez de quebrar. Um cartão sem logo de parceiro
  /// é um cartão; um crash é um app fechado.
  static const DilettaBrand nenhuma = DilettaBrand._nenhuma();

  /// Pacote que hospeda estes arquivos. `null` = nenhuma marca instalada.
  final String? pacote;

  /// Símbolo (marca d'água) e logo completo (símbolo + palavra).
  ///
  /// Têm default de CONVENÇÃO, então um filho que siga a convenção só informa o
  /// [pacote].
  final String logo;
  final String logoFull;

  /// Logo do PARCEIRO no cartão cobranded. `null` = este produto não tem cobrand.
  final String? logoParceiro;

  /// Bandeira do cartão (Visa, Elo…). `null` = não desenha.
  final String? bandeiraDoCartao;

  bool get instalada => pacote != null;

  @override
  bool operator ==(Object other) =>
      other is DilettaBrand &&
      other.pacote == pacote &&
      other.logo == logo &&
      other.logoFull == logoFull &&
      other.logoParceiro == logoParceiro &&
      other.bandeiraDoCartao == bandeiraDoCartao;

  @override
  int get hashCode =>
      Object.hash(pacote, logo, logoFull, logoParceiro, bandeiraDoCartao);
}
