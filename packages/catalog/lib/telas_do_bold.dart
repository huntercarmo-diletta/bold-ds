/// AS TELAS DO BOLD — e até agora eram ZERO.
///
/// O pai mediu a frase que abre este arquivo, na v0.55.0 do motor: *"um filho tem 124 telas, o outro tem
/// ZERO."* Ele está certo, e o custo é o que ele diz na linha seguinte — **todo o pipeline de tela tinha um
/// usuário só**, então cada defeito daquele caminho era invisível por construção deste lado.
///
/// A HOME é a primeira, e a escolha não é por ser fácil: é a tela mais montada deste produto (topo + saldo
/// + duas coleções + destaque + barra), a que mais componentes atravessa, e a única cujo fundo é o mood de
/// imagem — que era o componente mais usado do DS aparecendo degradado no catálogo até anteontem.
///
/// ## Ela é DECLARAÇÃO, e passa pela validação do pai
///
/// O JSON vai por `montaDaAutoria`, que reprova prop inexistente, enum fora do vocabulário, slot que não
/// existe e id repetido — tudo de uma vez. Prop com nome errado é o erro mais barato de cometer e o mais
/// caro de achar, porque ela é **ignorada em silêncio** e a tela renderiza com o valor normal.
///
/// ## Os bindings são o ponto, e não enfeite
///
/// Cinco props saem como `bindings` em vez de texto: saldo, entradas, saídas, nome e conta. A regra do
/// contrato de autoria é dura e está certa — *"placeholder escrito à mão vira mock silencioso: o dev copia o
/// código e leva o texto fixo"*. Com binding, a tela **diz qual dado ela quer**, e a seção CONSOME do
/// contrato responde por ela.
///
/// E isso me deu o que devolver ao pai: a v0.55.0 dele consertou a seção CONSOME, que estava **vazia pra
/// toda tela real** porque a fixture usava a representação que o compositor não produz. Esta tela é escrita
/// na representação do produtor (`bindings` no bloco), então ela é o caso de verdade — e o gate deste repo
/// mede que a seção não volta a esvaziar.
library;

import 'package:diletta_catalog_core/diletta_catalog_core.dart';

import 'builder/screen_specs.g.dart';

/// ## O rodapé da home são as ABAS, e isso só ficou possível hoje
///
/// Até a v0.7.2 a home mostrava uma barra de CTA escrito "Continuar" no rodapé — não porque alguém quis,
/// mas porque o meu bloco `barraDeBaixo` expunha **1 das 7 variantes** do `DilettaBottomApp` do pai, e a
/// única era a de botão. A cobrança dele (motor v0.77.0) mediu isso, o dono do produto escolheu as cinco
/// sem chat, e a `nav` fechou o buraco: a home declara `variante: nav` com os três itens que o app tem de
/// verdade — `Início`, `Câmera` e `Lia`, o terceiro condicional por feature flag lá.
///
/// ## Uma divergência DECLARADA entre o board e o aparelho: o card de lista é sólido aqui
///
/// No app, o card que agrupa linhas de lista é **vidro** (`BoldAppListGroup` → `BoldCard(glass: true)`,
/// **96 sítios**) — e vidro é o que deixa a arte do fundo passar, que é regra escrita no DS do app antes de
/// eu existir. No board ele aparece **sólido**, porque o `DilettaAppList.carded` do pai crava
/// `color: s.surface` e não há como pedir outro material.
///
/// Não é defeito meu e não tem contorno honesto deste lado: envolver o card do pai num
/// `DilettaGlassSurface` faria o board desenhar vidro que o componente não desenha, e pintar cor
/// translúcida não é vidro — vidro é `BackdropFilter`, e sobre cor lisa não desfoca nada.
///
/// Está pedido em `docs/pedidos/2026-08-03-o-card-de-conteudo-nao-sabe-ser-vidro.md`, com o número dos dois
/// lados: 25 arquivos do pai cravam `surface`, e os 4 que usam o vidro dele são todos chrome. Fica escrito
/// aqui enquanto durar, porque **divergência declarada é melhor que divergência silenciosa** — quem abre o
/// board e conhece o app tem que saber que a diferença é conhecida.
///
/// O slug é a chave estável — é por ele que fluxo, seta e deep-link apontam.
///
/// A HOME da conta PF, medida em `home_tab_redesign.dart`.
///
/// A ordem é a do app: barra de topo com saudação, saldo com entradas e saídas, atalhos, o que precisa de
/// atenção, e o destaque da conta PJ.
///
/// ## O chrome de aparelho NÃO se declara aqui, e isso foi medido no board
///
/// As cinco telas declaravam `barraDeStatus` no `top` e `indicadorDeHome` no `bottom`. As duas peças já
/// vêm de dentro das cascas do pai: `DilettaTopAppBar.defaultVariant` e `.comConteudo` compõem
/// `DilettaStatusBar`, e **toda** variante de `DilettaBottomApp` termina em `DilettaBottomHomeIndicator`.
/// O resultado no board era **dois relógios de 9:41 empilhados** e dois traços de home — o print veio de
/// quem estava olhando a aba Telas.
///
/// A regra que sai disso: *quem declara a casca não declara o chrome que ela traz.* O `barraDeStatus` e o
/// `indicadorDeHome` continuam no vocabulário pra tela SEM casca, e o gate
/// `as_telas_nao_duplicam_o_chrome_test` reprova a coexistência.
///
/// O que eu NÃO reproduzi, e é decisão: o app tem uma fileira de avatares (`BoldAvatarRow`) e um carrossel
/// horizontal de promo. Nenhum dos dois é bloco deste registro, porque nenhum dos dois passou a medição de
/// uso que este DS exige — e inventar bloco pra completar um desenho é a ordem inversa da que este repo
/// segue. A tela declara o que o vocabulário tem; a falta aparece aqui em vez de virar widget solto.
const String kSlugDaHome = 'pf1-home';

/// A segunda tela, e ela é da conta PJ — o outro eixo macro deste produto.
///
/// AS AUTORIZAÇÕES da conta PJ, medidas em `autorizacoes_screen.dart` (1.216 linhas no app).
///
/// A segunda tela, e a escolha tem duas razões medidas. A primeira: ela é do **outro eixo macro** (PJ), e
/// com uma tela só de PF o board não tinha o que agrupar. A segunda pesa mais — **ela é a única que usa os
/// três componentes que eu construí pra alçada** (`progressoDeAprovacao`, `prazoDaPendencia`,
/// `escadaDeAlcadas`). Eles existiam com uso medido no app e **zero uso em tela declarada aqui**, que é o
/// caso mais fácil de um componente apodrecer sem ninguém ver.
///
/// ## O que eu mudei do app, e por quê
///
/// No app os dois botões são uma LINHA (`Rejeitar` | `Aprovar`). Aqui eles empilham na base, e não é
/// preguiça: este registro **não tem container de linha** — a gramática de superfície do motor é
/// `top`/`blocks`/`bottom`, e linha de botões seria bloco novo. Empilhar é o que o vocabulário permite hoje,
/// e a diferença fica escrita aqui em vez de virar componente inventado pra fechar um desenho.
///
/// A tela do app também repete o cartão por pedido, num `ListView`. A spec declara **um** — o board mostra
/// a forma da tela, não o volume de dados. Repetição vem de `listBindings` no dia em que eu declarar a
/// lista vinculada, e aí é uma linha.
const String kSlugDasAutorizacoes = 'pj1-autorizacoes';

/// A terceira, e a primeira que fica no MESMO fluxo de outra: `pf1-home` → esta.
///
/// O VALOR DO PIX, medida em `pix_valor_screen.dart`.
///
/// A terceira tela, e a primeira que existe **por causa da seta**: `pf1-home` leva a ela pelo atalho de Pix,
/// e é a primeira vez que este produto tem duas telas no mesmo fluxo. Sem isso, `motionDaTransicao` era
/// declaração sobre nada — eu tinha ligado `push` ao token `slow` e **zero setas** pra provar.
///
/// ## O título vazio da barra é do app, e é decisão
///
/// `pix_valor_screen.dart` passa `title: ''`. Não é esquecimento: o contexto está no corpo (*"Transferir
/// para <nome>"*), e repetir no topo seria o mesmo texto duas vezes na mesma dobra. Declaro vazio porque é
/// o que a tela faz — inventar um título aqui faria a doc divergir do produto no primeiro olhar.
const String kSlugDoValorDoPix = 'pf2-pix-valor';

/// A revisão, e o passo em que o usuário confirma. Terceiro degrau do fluxo de Pix.
///
/// A REVISÃO DO PIX, medida em `pix_revisar_screen.dart`.
///
/// O passo em que o desenho para de pedir dado e passa a pedir CONFIRMAÇÃO — e é por isso que ele existe
/// separado do valor: o mesmo Pix com o mesmo dado, numa tela que só mostra e num CTA que compromete.
///
/// O app usa `BoldBackdrop.solido` aqui, e não a imagem: fluxo secundário troca o fundo de mood pelo sólido.
/// Isso **não** é declarável na spec — o fundo do frame é gancho do catálogo (`fundoDoFrame`), um por
/// produto. Fica na nota, porque é diferença real entre esta tela no board e a mesma no aparelho.
const String kSlugDaRevisaoDoPix = 'pf3-pix-revisar';

/// O comprovante. Fim do fluxo, e a única tela deste produto em estado CONCLUÍDO.
///
/// O PIX ENVIADO, medido em `pix_enviado_screen.dart`.
///
/// A única tela deste produto em estado **concluído**, e a única que usa o `resumoDaTransacao` — o
/// componente que eu construí pro cabeçalho de recibo e que até agora não aparecia em tela nenhuma.
///
/// O rodapé tem DOIS botões (primário + secundário), que é o que o app faz: `BoldBottomApp.button` com
/// `primary` e `secondary` — e eles vão DENTRO da barra de baixo, que é quem empilha (gap 12) e quem traz o
/// indicador de home. Botão solto no `bottom` era o defeito: no aparelho ele flutuava sobre a arte, sem a
/// superfície de vidro que separa a ação do conteúdo.
const String kSlugDoPixEnviado = 'pf4-pix-enviado';

/// AS TELAS DE LOJA — as quatro que o dono pediu pra virar screenshot de App Store e Play Store,
/// mais a de aprovação que ele pediu junto.
///
/// Elas existem por um pedido de marketing e acabaram sendo a maior auditoria de adoção deste repo,
/// porque **as cinco travavam em peças que só existiam dentro do aparelho**. Quatro eram lacuna do
/// inventário (ladrilho de menu, chip de filtro, linha de aviso, cartão promocional); duas eram
/// peças adotadas do lado errado da fronteira (fileira de avatares, grupo do dia); e duas eram
/// classes PRIVADAS dentro das telas (`_AccountHeader`, `_PendingCard`) — a quarta classe de
/// dívida deste repo, e a única que nenhum gate via.
///
/// A frase do dono é a régua: *"era pra tudo estar no catálogo porque era pra tudo estar no DS."*
///
/// A ÁREA PIX, medida em `pix_hub_redesign.dart`. É a mesma tela em dois papéis — a aba Pix do
/// shell e a rota `/pix/hub` —, e o que muda entre eles é só a casca de topo.
const String kSlugDoHubDePix = 'pf5-pix-hub';

/// A GESTÃO DA CONTA, medida em `minha_conta_screen.dart`.
///
/// O cabeçalho dela era `_AccountHeader`, privado dentro do arquivo da tela: funcionava, tinha uso,
/// e não existia pra ninguém de fora. Virou `BoldCartaoDaConta` no pacote.
const String kSlugDaConta = 'pf6-conta';

/// O EXTRATO, medido em `extrato_tab_redesign.dart` — e a tela que abriu esta rodada.
///
/// O dono mandou um print dela no tema claro: dois lançamentos no mesmo dia, sem linha entre eles.
/// A regra do divisor estava certa e a COR estava errada — branco a 12% cravado. O grupo do dia
/// veio pro pacote junto com o conserto, e agora tem gate nos dois temas e nos três tamanhos.
const String kSlugDoExtrato = 'pf7-extrato';

/// A APROVAÇÃO vista por QUEM APROVA, medida em `autorizacoes_screen.dart`.
///
/// Ela é a irmã da `pj1-autorizacoes` e não a mesma tela: aquela mostra a alçada da conta — quem
/// pode mandar quanto —, e esta mostra a FILA, com os cartões que esperam assinatura. O cartão era
/// `_PendingCard`, privado, e é o organismo mais denso do produto: ele responde quem pediu e
/// quanto, quanto falta pra sair, por que precisa de mim, e o que eu faço.
const String kSlugDaAprovacao = 'pj2-aprovacao';






/// As telas montadas, a partir do arquivo GERADO — e este arquivo deixou de ser a fonte delas.
///
/// A `v0.76.0` do motor fechou o transporte do "editar tela e salvar no repo", e o passo que o pai não podia
/// decidir por mim é este: **o arquivo alvo é gerado por inteiro a partir do estado**, então apontar
/// `caminhoDoArquivoDeSpecs` pra cá apagaria a prosa na primeira gravação. Duas coisas viviam no mesmo
/// arquivo porque só havia um.
///
/// Agora são dois, com papéis que não se confundem:
///
/// - **a fonte** é `builder/screen_specs.g.dart` (`kScreenSpecsJson`), escrito pelo compositor e
///   versionado. Editar tela é editar no compositor e salvar — não é digitar JSON aqui;
/// - **o registro** é este arquivo: os slugs e a RAZÃO de cada tela. Nada aqui é lido pelo board, e é de
///   propósito — prosa que o gerador sobrescreve é prosa que se perde no primeiro salvamento.
///
/// A validação da autoria (`montaDaAutoria`, que já me pegou um ícone inventado) não desapareceu: ela roda
/// no compositor a cada edição, e o gate deste repo mede o que ficou no arquivo.
Map<String, ScreenSpec> telasDoBold() => {
      for (final e in kScreenSpecsJson.entries)
        // O registro vem do plugue (`Ds.blocos`) porque decodificar precisa dos DEFAULTS de cada tipo, e
        // isso é conhecimento do DS — o motor não pode nomear o design system de ninguém. Ele exige o
        // registro como parâmetro justamente por isso.
        e.key: decodeSpecCom(e.value, registro: Ds.blocos),
    };

/// As telas agrupadas pelo eixo MACRO, que é como o board as mostra.
///
/// O macro sai do prefixo do slug (`pf1-…`, `pj1-…`) e não de um campo novo: o contrato de autoria já manda
/// o slug começar com o prefixo do fluxo, então declarar o macro de novo seria a mesma informação em dois
/// lugares — e duas fontes divergem no primeiro conserto.
///
/// ## Cada tela declara o `specId`, e sem ele metade do board fica muda
///
/// Antes eu usava o `handoffFromSpec(spec)` do motor, que monta a tela com a spec INLINE e um `child`
/// renderizado na hora. Funciona pra tela publicada do compositor, e é a coisa errada pra tela que mora no
/// repo: **o `specId` é a chave da tela na FONTE**, e é por ele que o board sabe qual entrada do
/// `screen_specs.g.dart` uma edição substitui.
///
/// O custo de não declarar apareceu clicando, e em duas portas diferentes:
///
/// - **Anotar** respondia *"Selecione uma tela spec-first pra anotar"* — a nota se guarda por slug, e sem
///   slug não há onde guardar;
/// - **salvar no repo** não teria como saber qual das cinco entradas trocar.
///
/// E o `child` do helper era pior que inútil: ele é um SNAPSHOT do render feito no momento em que o grupo é
/// montado, e o preview prefere o `child` à spec. Tela spec-first não tem mock — ela renderiza a fonte,
/// que é o que faz o board mostrar o que o arquivo diz e não o que estava na tela quando alguém montou a
/// lista.
List<HandoffGroup> gruposDeTelasDoBold() {
  final porMacro = <String, List<HandoffScreen>>{};
  telasDoBold().forEach((slug, spec) {
    final macro = slug.startsWith('pj') ? 'PJ' : 'PF';
    (porMacro[macro] ??= []).add(HandoffScreen(
      label: spec.name,
      // A legenda é derivada da própria spec: contar blocos à mão é número que envelhece no primeiro
      // bloco novo.
      caption: '${spec.blocks.length} '
          '${spec.blocks.length == 1 ? 'bloco' : 'blocos'} · fonte: $slug',
      specId: slug,
    ));
  });
  return [
    for (final e in porMacro.entries)
      HandoffGroup(
        title: e.key == 'PJ' ? 'Conta PJ' : 'Conta PF',
        subtitle: e.key == 'PJ'
            ? 'Alçada, operadores e aprovação em duas mãos.'
            : 'O dia a dia da conta pessoa física.',
        macro: e.key,
        screens: e.value,
      ),
  ];
}
