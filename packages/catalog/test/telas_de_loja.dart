/// AS TELAS DE LOJA — as cinco que o dono pediu pra virar screenshot de App Store e Play Store.
///
/// Elas são escritas AQUI e gravadas por `escreve_as_telas_de_loja.dart` no arquivo gerado. O
/// compositor continua sendo o dono do arquivo; esta é a porta de entrada de tela que nasce escrita.
///
/// Cada uma foi medida no arquivo do app que a implementa, e o que não coube está escrito na spec
/// como nota — divergência declarada é melhor que divergência silenciosa.
library;

const Map<String, String> kTelasDeLoja = {
  // ── HOME ────────────────────────────────────────────────────────────────────
  // Medida em `home_tab_redesign.dart`. A ordem é a do app: cabeçalho com saudação, saldo, "Enviar
  // para", autorizações, menu 2×2 e o carrossel de sugestão.
  //
  // A versão anterior desta tela usava lista de menu no lugar do menu 2×2 e não tinha nem a fileira
  // de avatares nem o cartão do carrossel — as três peças eram lacuna do inventário. Foi ela que
  // pagou o preço mais visível de a adoção parar em 99%.
  'pf1-home': r'''
{"formato":1,"name":"PF1 · Home","form":"phone","contentGap":"s5","scrollableContent":true,
"top":[{"id":"b_1","type":"cabecalhoDaHome","props":{"nome":"Ranter","conta":"Conta PF"},"bindings":{"nome":"nomeDoTitular","conta":"rotuloDaConta"}}],
"blocks":[
{"id":"b_2","type":"saldo","props":{"valor":"R$ 2.912,47","entradas":"R$ 4.180,00","saidas":"R$ 1.267,53","oculto":false},"bindings":{"valor":"saldoFormatado","entradas":"entradasDoMes","saidas":"saidasDoMes"}},
{"id":"b_3","type":"cabecalhoDeSecao","props":{"rotulo":"Enviar para","verTodos":true}},
{"id":"b_4","type":"fileiraDeAvatares","props":{"iniciais":"AM, BL, RS, CF","rotulos":"Ana, Bruno, Rita, Caio","subrotulos":"BOLD, Nubank, Itaú, Inter","adiciona":true}},
{"id":"b_5","type":"linhaDeAviso","props":{"icone":"paperPlaneLight","titulo":"Autorizações","subtitulo":"Veja o que está esperando você.","contagem":"2"},"bindings":{"contagem":"pendenciasAbertas"}},
{"id":"b_6","type":"cabecalhoDeSecao","props":{"rotulo":"Menu","verTodos":true}},
{"id":"b_7","type":"grade","props":{"colunas":"2","vao":"s4"},"slots":{"itens":[
  {"id":"b_8","type":"ladrilhoDeMenu","props":{"icone":"pixLight","rotulo":"Área Pix","porte":"largo"}},
  {"id":"b_9","type":"ladrilhoDeMenu","props":{"icone":"arrowDownToLineLight","rotulo":"Receber","porte":"largo"}},
  {"id":"b_10","type":"ladrilhoDeMenu","props":{"icone":"barcodeLight","rotulo":"Pagar contas","porte":"largo"}},
  {"id":"b_11","type":"ladrilhoDeMenu","props":{"icone":"clipboardListCheckLight","rotulo":"Autorizações","porte":"largo"}}
]}},
{"id":"b_12","type":"cartaoPromocional","props":{"titulo":"Habilite sua passkey","subtitulo":"Login sem senha, resistente a phishing.","fecha":true}}
],
"bottom":[{"id":"b_13","type":"barraDeBaixo","props":{"variante":"nav","label":"","labelSecundario":"","abas":"Início:houseLight, Câmera:cameraLight, Lia:sparklesLightFull","abaAtiva":"0"}}],
"notes":[
{"kind":"decisao","text":"O saldo, o nome, o rótulo da conta e a contagem de pendências são BINDING e não texto. Placeholder escrito à mão vira mock silencioso — o dev copia o código e leva o valor fixo pro app."},
{"kind":"regra","text":"O menu é 2×2 porque a home comporta QUATRO atalhos (`kHomeMenuSlots`), e a Área Pix é fixa no primeiro (`kHomeMenuMandatoryId`). Os outros três a pessoa escolhe na personalização."},
{"kind":"borda","text":"Zero pendências: em conta PF a linha de aviso SOME; em PJ ela fica, mesmo zerada, porque governança é rotina ali e o atalho sumindo obrigava a caçar o item no menu."},
{"kind":"a11y","text":"O olho de ocultar mora no cabeçalho e não no card de saldo: é ação de TELA, e ocultar cobre o saldo E os totais — meia máscara não esconde nada."}
]}
''',

  // ── ÁREA PIX ────────────────────────────────────────────────────────────────
  // Medida em `pix_hub_redesign.dart`. A tela é as DUAS coisas — a aba Pix do shell e a rota
  // `/pix/hub` —, e o que muda entre elas é só a casca de topo.
  'pf5-pix-hub': r'''
{"formato":1,"name":"PF5 · Área Pix","form":"phone","contentGap":"s5","scrollableContent":true,
"top":[{"id":"b_1","type":"cascaDeTopo","props":{"titulo":"Área Pix","esquerda":"voltar","direita":""}}],
"blocks":[
{"id":"b_2","type":"tituloDaPagina","props":{"titulo":"Para quem você vai transferir?","subtitulo":""}},
{"id":"b_3","type":"campoDeBusca","props":{"placeholder":"Chave Pix, nome ou Pix copia e cola","acaoDireita":"qrcodeLight"}},
{"id":"b_4","type":"cabecalhoDeSecao","props":{"rotulo":"Contatos","verTodos":true}},
{"id":"b_5","type":"fileiraDeAvatares","props":{"iniciais":"AM, BL, RS, CF, LT","rotulos":"Ana, Bruno, Rita, Caio, Lia","subrotulos":"BOLD, Nubank, Itaú, Inter, C6","adiciona":true}},
{"id":"b_6","type":"cabecalhoDeSecao","props":{"rotulo":"Menu","verTodos":false}},
{"id":"b_7","type":"grade","props":{"colunas":"fluida","vao":"s2"},"slots":{"itens":[
  {"id":"b_8","type":"ladrilhoDeMenu","props":{"icone":"arrowRightArrowLeftLight","rotulo":"Transferir","porte":"compacto"}},
  {"id":"b_9","type":"ladrilhoDeMenu","props":{"icone":"qrcodeLight","rotulo":"Ler QR Code","porte":"compacto"}},
  {"id":"b_10","type":"ladrilhoDeMenu","props":{"icone":"fileInvoiceLight","rotulo":"Cobrar","porte":"compacto"}},
  {"id":"b_11","type":"ladrilhoDeMenu","props":{"icone":"cloneLight","rotulo":"Copia e cola","porte":"compacto"}},
  {"id":"b_12","type":"ladrilhoDeMenu","props":{"icone":"arrowDownToLineLight","rotulo":"Depositar","porte":"compacto"}},
  {"id":"b_13","type":"ladrilhoDeMenu","props":{"icone":"landmarkLight","rotulo":"Agência e conta","porte":"compacto"}}
]}},
{"id":"b_14","type":"lista","props":{"titulo":"Outros","idioma":"menu"},"slots":{"itens":[
  {"id":"b_15","type":"linha","props":{"icone":"keyLight","titulo":"Minhas chaves Pix","subtitulo":""}},
  {"id":"b_16","type":"linha","props":{"icone":"arrowRotateLeftLight","titulo":"PIX Automático","subtitulo":""}},
  {"id":"b_17","type":"linha","props":{"icone":"slidersLight","titulo":"Meus limites Pix","subtitulo":""}},
  {"id":"b_18","type":"linha","props":{"icone":"userLight","titulo":"Contatos","subtitulo":""}},
  {"id":"b_19","type":"linha","props":{"icone":"messagesQuestionLightFull","titulo":"Contestar transações Pix","subtitulo":""}}
]}}
],
"bottom":[{"id":"b_20","type":"barraDeBaixo","props":{"variante":"nav","label":"","labelSecundario":"","abas":"Início:houseLight, Câmera:cameraLight, Lia:sparklesLightFull","abaAtiva":"0"}}],
"notes":[
{"kind":"decisao","text":"A busca e o QR são UMA linha, não dois blocos: o campo ocupa o que sobra e o botão vive ao lado. Declarar como blocos vizinhos empilharia o QR debaixo da busca, que não é o que a tela faz."},
{"kind":"regra","text":"O menu compacto é 3 colunas porque o rótulo mais longo (\"Agência e conta\") precisa de duas linhas em 85 de largura. Em 2 colunas os ladrilhos ficariam largos demais pro que carregam."},
{"kind":"borda","text":"Digitando: a tela troca contatos por RESULTADOS e, quando reconhece chave ou copia-e-cola, acende a CTA no rodapé. É o mesmo campo — o estado é da busca, não da tela."},
{"kind":"a11y","text":"O que não coube: a sugestão de COLAR do clipboard. O ícone dela é o `clipboard-list-check-light`, que diz *documento conferido* em 7 sítios do app e não corresponde a nada aqui — o conserto é o `clipboard-light`, pedido aceito e travado na arte."}
]}
''',

  // ── GESTÃO DA CONTA ─────────────────────────────────────────────────────────
  // Medida em `minha_conta_screen.dart`. O cabeçalho era `_AccountHeader`, classe privada dentro da
  // tela — ela virou `BoldCartaoDaConta` pra esta tela poder existir aqui.
  'pf6-conta': r'''
{"formato":1,"name":"PF6 · Gestão da conta","form":"phone","contentGap":"s6","scrollableContent":true,
"top":[{"id":"b_1","type":"cascaDeTopo","props":{"titulo":"Conta","esquerda":"voltar","direita":""}}],
"blocks":[
{"id":"b_2","type":"cartaoDaConta","props":{"nomeDaConta":"Minha conta","tipo":"Conta PF","numero":"12345-6","linhaDeApoio":"Ag 0001 · 655 – BOLD"},"bindings":{"nomeDaConta":"nomeDaConta","numero":"numeroDaConta","linhaDeApoio":"agenciaEBanco"}},
{"id":"b_3","type":"cabecalhoDeSecao","props":{"rotulo":"Dados bancários","verTodos":false}},
{"id":"b_4","type":"lista","props":{"titulo":"","idioma":"carded"},"slots":{"itens":[
  {"id":"b_5","type":"linha","props":{"icone":"landmarkLight","titulo":"655 – BOLD","subtitulo":"Banco"}},
  {"id":"b_6","type":"linha","props":{"icone":"cloneLight","titulo":"0001","subtitulo":"Agência"}},
  {"id":"b_7","type":"linha","props":{"icone":"cloneLight","titulo":"12345-6","subtitulo":"Conta corrente"}}
]}},
{"id":"b_8","type":"cabecalhoDeSecao","props":{"rotulo":"Gestão da conta","verTodos":false}},
{"id":"b_9","type":"lista","props":{"titulo":"","idioma":"menu"},"slots":{"itens":[
  {"id":"b_10","type":"linha","props":{"icone":"slidersLight","titulo":"Aprovações e limites","subtitulo":"Regras de aprovação e limites da conta"}},
  {"id":"b_11","type":"linha","props":{"icone":"usersLight","titulo":"Operadores","subtitulo":"Quem pode agir nesta conta"}},
  {"id":"b_12","type":"linha","props":{"icone":"idCardLight","titulo":"Perfis de acesso","subtitulo":"Conjuntos de permissões para atribuir"}},
  {"id":"b_13","type":"linha","props":{"icone":"idCardClipLight","titulo":"Contatos de pagamento","subtitulo":"Favorecidos desta conta"}}
]}},
{"id":"b_14","type":"cabecalhoDeSecao","props":{"rotulo":"Encerramento","verTodos":false}},
{"id":"b_15","type":"lista","props":{"titulo":"","idioma":"menu"},"slots":{"itens":[
  {"id":"b_16","type":"linha","props":{"icone":"trashLight","titulo":"Encerrar conta digital","subtitulo":"Excluir sua conta de forma definitiva"}}
]}}
],
"bottom":[],
"notes":[
{"kind":"decisao","text":"Os dados do USUÁRIO não moram aqui — eles ficam no Perfil. Esta tela é a identidade e a governança da CONTA, e misturar as duas faz a pessoa procurar o CPF dela no lugar errado."},
{"kind":"regra","text":"Operando conta de TERCEIRO o hub encolhe: governança e encerramento saem, e a lista de operadores fica oculta. Quem opera vê uma seção só, \"Seu acesso\", com \"Minhas regras aqui\" — sem item bloqueado, porque item que não abre é ruído."},
{"kind":"borda","text":"Agência e conta têm ação de COPIAR na direita da linha. O que a linha do vocabulário não declara é o acessório de ação com callback — no app é `DilettaRightAccessory.icon`, e aqui a linha mostra o dado sem o botão."},
{"kind":"a11y","text":"O encerramento é a única linha destrutiva da tela, e o tom vem do ESTADO `error` sobre a peça normal — não de um tipo próprio. São 16 sítios de destrutivo no app e nenhum é um tipo."}
]}
''',

  // ── EXTRATO ─────────────────────────────────────────────────────────────────
  // Medido em `extrato_tab_redesign.dart`. É a tela do print que abriu esta rodada: o divisor entre
  // lançamentos do mesmo dia era branco a 12% cravado e sumia no tema claro.
  'pf7-extrato': r'''
{"formato":1,"name":"PF7 · Extrato","form":"phone","contentGap":"s4","scrollableContent":true,
"top":[{"id":"b_1","type":"cascaDeTopo","props":{"titulo":"Extrato","esquerda":"voltar","direita":"fileInvoiceLight, eyeLight"}}],
"blocks":[
{"id":"b_2","type":"saldo","props":{"valor":"R$ 2.912,47","entradas":"R$ 4.180,00","saidas":"R$ 1.267,53","oculto":false},"bindings":{"valor":"saldoFormatado","entradas":"entradasDoMes","saidas":"saidasDoMes"}},
{"id":"b_3","type":"texto","props":{"conteudo":"Transações","preset":"headlineSm"}},
{"id":"b_4","type":"campoDeBusca","props":{"placeholder":"Buscar","acaoDireita":"slidersLight"}},
{"id":"b_5","type":"grade","props":{"colunas":"fileira","vao":"s2"},"slots":{"itens":[
  {"id":"b_6","type":"chipDeFiltro","props":{"rotulo":"Tudo","escolhido":true}},
  {"id":"b_7","type":"chipDeFiltro","props":{"rotulo":"Entradas","escolhido":false}},
  {"id":"b_8","type":"chipDeFiltro","props":{"rotulo":"Saídas","escolhido":false}}
]}},
{"id":"b_9","type":"grupoDoDia","props":{"rotulo":"Hoje, 11 de agosto","acessorio":"R$ 2.912,47"},"slots":{"itens":[
  {"id":"b_10","type":"linhaDeValor","props":{"icone":"pixLight","titulo":"Ana Maria Silva","origem":"Pix recebido","hora":"14:32","valor":"R$ 1.240,00","saida":false}},
  {"id":"b_11","type":"linhaDeValor","props":{"icone":"barcodeLight","titulo":"Enel Distribuição","origem":"Boleto pago","hora":"11:07","valor":"R$ 318,44","saida":true}},
  {"id":"b_12","type":"linhaDeValor","props":{"icone":"pixLight","titulo":"Bruno Lopes","origem":"Pix enviado","hora":"09:15","valor":"R$ 120,00","saida":true}}
]}},
{"id":"b_13","type":"grupoDoDia","props":{"rotulo":"Ontem, 10 de agosto","acessorio":"R$ 2.110,91"},"slots":{"itens":[
  {"id":"b_14","type":"linhaDeValor","props":{"icone":"arrowRightArrowLeftLight","titulo":"Rita Souza","origem":"TED recebida","hora":"16:48","valor":"R$ 2.940,00","saida":false}},
  {"id":"b_15","type":"linhaDeValor","props":{"icone":"mobileLight","titulo":"Recarga de celular","origem":"Recarga","hora":"08:22","valor":"R$ 30,00","saida":true}}
]}}
],
"bottom":[{"id":"b_16","type":"barraDeBaixo","props":{"variante":"nav","label":"","labelSecundario":"","abas":"Início:houseLight, Câmera:cameraLight, Lia:sparklesLightFull","abaAtiva":"0"}}],
"notes":[
{"kind":"decisao","text":"O saldo é o MESMO componente da home, e não uma versão de extrato: quem abre o extrato veio do saldo, e um segundo desenho do mesmo número cria duas fontes de verdade visual."},
{"kind":"regra","text":"N lançamentos no dia dão N-1 fios, E o dia de lançamento ÚNICO leva fio — ali ele fecha o grupo por baixo em vez de separar dois itens. Foi um print do dono que achou o defeito: a regra estava certa e a COR estava errada, branco a 12% cravado, invisível no claro."},
{"kind":"borda","text":"Buscando ou com filtro ativo, a seção \"Próximos pagamentos\" some: agendado não é histórico, e mostrá-lo dentro de um filtro de período mente sobre o recorte."},
{"kind":"a11y","text":"O chip escolhido inverte fundo E peso (400 → 600). Cor sozinha não é informação, e a fila inteira muda de tom entre os temas."}
]}
''',

  // ── APROVAÇÃO ───────────────────────────────────────────────────────────────
  // Medida em `autorizacoes_screen.dart` (1.216 linhas). O cartão era `_PendingCard`, classe privada
  // dentro da tela — virou `BoldCartaoDePedido` pra esta tela poder existir aqui.
  //
  // É a tela vista por QUEM APROVA, e não a do solicitante: os dois cartões são diferentes, e o que
  // muda é a pergunta que cada um responde.
  'pj2-aprovacao': r'''
{"formato":1,"name":"PJ2 · Aprovando","form":"phone","contentGap":"s4","scrollableContent":true,
"top":[
{"id":"b_1","type":"cascaDeTopo","props":{"titulo":"Autorizações","esquerda":"voltar","direita":""}},
{"id":"b_2","type":"abas","props":{"abas":"Pendentes, Histórico, Minhas","selecionada":"0"}}
],
"blocks":[
{"id":"b_3","type":"grade","props":{"colunas":"fileira","vao":"s2"},"slots":{"itens":[
  {"id":"b_4","type":"chipDeFiltro","props":{"rotulo":"Todas","escolhido":true}},
  {"id":"b_5","type":"chipDeFiltro","props":{"rotulo":"Pix","escolhido":false}},
  {"id":"b_6","type":"chipDeFiltro","props":{"rotulo":"Boleto","escolhido":false}}
]}},
{"id":"b_7","type":"cartaoDePedido","props":{"quemPediu":"Marcos Almeida","detalhe":"Pix · para Ana Maria Silva · 14:32","valor":"R$ 8.400,00","icone":"pixLight","colhidas":"1","exigidas":"2","exigeMaster":true,"idade":"há 3 horas","aprovadaPor":"Marcos Almeida","motivo":"Limite por transação (GLOBAL · 2 aprovações · Master)","justificativa":"Pagamento do fornecedor de embalagens, NF 4471.","jaAprovei":false},"bindings":{"quemPediu":"nomeDoSolicitante","valor":"valorDoPedido","colhidas":"assinaturasColhidas","exigidas":"assinaturasExigidas","idade":"idadeDaPendencia"}},
{"id":"b_8","type":"cartaoDePedido","props":{"quemPediu":"Você","detalhe":"Boleto · Enel Distribuição · ontem","valor":"R$ 12.980,00","icone":"barcodeLight","colhidas":"1","exigidas":"3","exigeMaster":false,"idade":"há 1 dia","aprovadaPor":"Você","motivo":"Limite diário (GLOBAL · 3 aprovações)","justificativa":"","jaAprovei":true}}
],
"bottom":[],
"notes":[
{"kind":"decisao","text":"O CRIADOR é o protagonista do cartão e o destinatário vai no detalhe. Quem aprova decide por quem PEDIU — o destinatário é consequência do pedido, não o assunto dele."},
{"kind":"regra","text":"Quem já assinou não vê botão desabilitado: vê uma linha de estado. Não há o que fazer, e botão cinza convida a tentar. Assinatura colhida não se retira por aqui."},
{"kind":"borda","text":"Sem `expiresAt` no contrato do backend, o cartão mostra a IDADE da pendência em vez de inventar contagem regressiva. É a decisão que o app já tomou, e ela vem junto."},
{"kind":"a11y","text":"O progresso anuncia a frase inteira (\"1 de 2 assinaturas, exige master\") em vez de dois números soltos, e o motivo diz a ORIGEM e o ESCOPO da regra — é ele que responde \"por que eu?\"."}
]}
''',
};
