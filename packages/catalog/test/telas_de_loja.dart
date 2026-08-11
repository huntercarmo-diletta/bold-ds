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
"top":[{"id":"b_1","type":"cabecalhoDaHome","props":{"nome":"Ranter","conta":"Minha conta"}}],
"blocks":[
{"id":"b_2","type":"saldo","props":{"valor":"R$ 0,14","entradas":"R$ 2.925,49","saidas":"R$ 2.925,70","oculto":false}},
{"id":"b_3","type":"cabecalhoDeSecao","props":{"rotulo":"Menu","verTodos":true}},
{"id":"b_4","type":"grade","props":{"colunas":"2","vao":"s4"},"slots":{"itens":[
  {"id":"b_5","type":"ladrilhoDeMenu","props":{"icone":"pixLight","rotulo":"Área Pix","porte":"largo"}},
  {"id":"b_6","type":"ladrilhoDeMenu","props":{"icone":"arrowDownToLineLight","rotulo":"Receber","porte":"largo"}},
  {"id":"b_7","type":"ladrilhoDeMenu","props":{"icone":"barcodeLight","rotulo":"Pagar contas","porte":"largo"}},
  {"id":"b_8","type":"ladrilhoDeMenu","props":{"icone":"fileInvoiceDollarLight","rotulo":"Cobrar","porte":"largo"}}
]}},
{"id":"b_9","type":"cartaoPromocional","props":{"titulo":"Habilite sua passkey","subtitulo":"Login sem senha, resistente a phishing.","fecha":true}}
],
"bottom":[{"id":"b_10","type":"barraDeBaixo","props":{"variante":"nav","label":"","labelSecundario":"","abas":"Início:houseLight, Câmera:cameraLight, Letti:sparklesLightFull","abaAtiva":"0"}}],
"notes":[
{"kind":"decisao","text":"Redesenhada contra o PRINT do aparelho, não contra a leitura do código. A primeira versão tinha \"Enviar para\" e a linha de Autorizações, e o aparelho não tem NENHUMA das duas: as seções da home somem quando não há dado, e esta conta não tem favorito nem pendência. Ler o código dá o que a tela PODE mostrar; o print dá o que ela mostra."},
{"kind":"regra","text":"O menu é 2×2 porque a home comporta QUATRO atalhos (`kHomeMenuSlots`), e a Área Pix é fixa no primeiro (`kHomeMenuMandatoryId`). Os outros três a pessoa escolhe na personalização — no aparelho medido são Receber, Pagar contas e Cobrar."},
{"kind":"borda","text":"Com favoritos, entra a fileira \"Enviar para\" logo abaixo do saldo; com pendência, entra a linha de Autorizações. Em conta PJ a linha fica mesmo zerada, porque governança é rotina ali."},
{"kind":"a11y","text":"O olho de ocultar é o PRIMEIRO ícone da direita do cabeçalho, antes do sino, e não mora no card de saldo: é ação de tela. Ocultar cobre o saldo E os totais — meia máscara não esconde nada."}
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
{"id":"b_4","type":"cabecalhoDeSecao","props":{"rotulo":"Menu","verTodos":false}},
{"id":"b_5","type":"grade","props":{"colunas":"fluida","vao":"s2"},"slots":{"itens":[
  {"id":"b_6","type":"ladrilhoDeMenu","props":{"icone":"arrowRightArrowLeftLight","rotulo":"Transferir","porte":"compacto"}},
  {"id":"b_7","type":"ladrilhoDeMenu","props":{"icone":"qrcodeLight","rotulo":"Ler QR Code","porte":"compacto"}},
  {"id":"b_8","type":"ladrilhoDeMenu","props":{"icone":"fileInvoiceLight","rotulo":"Cobrar","porte":"compacto"}},
  {"id":"b_9","type":"ladrilhoDeMenu","props":{"icone":"cloneLight","rotulo":"Copia e cola","porte":"compacto"}},
  {"id":"b_10","type":"ladrilhoDeMenu","props":{"icone":"arrowDownToLineLight","rotulo":"Depositar","porte":"compacto"}},
  {"id":"b_11","type":"ladrilhoDeMenu","props":{"icone":"landmarkLight","rotulo":"Agência e conta","porte":"compacto"}}
]}},
{"id":"b_12","type":"cabecalhoDeSecao","props":{"rotulo":"OUTROS","verTodos":false}},
{"id":"b_13","type":"lista","props":{"titulo":"","idioma":"carded"},"slots":{"itens":[
  {"id":"b_14","type":"linha","props":{"icone":"keyLight","titulo":"Minhas chaves Pix","subtitulo":""}},
  {"id":"b_15","type":"linha","props":{"icone":"arrowRotateLeftLight","titulo":"PIX Automático","subtitulo":""}},
  {"id":"b_16","type":"linha","props":{"icone":"slidersLight","titulo":"Meus limites Pix","subtitulo":""}},
  {"id":"b_17","type":"linha","props":{"icone":"userLight","titulo":"Contatos","subtitulo":""}},
  {"id":"b_18","type":"linha","props":{"icone":"messagesQuestionLightFull","titulo":"Contestar transações Pix","subtitulo":""}}
]}}
],
"bottom":[],
"notes":[
{"kind":"decisao","text":"A busca e o QR são UMA linha, não dois blocos: o campo ocupa o que sobra e o botão vive ao lado. Declarar como blocos vizinhos empilharia o QR debaixo da busca, que não é o que a tela faz."},
{"kind":"regra","text":"O menu é FLUXO e não grade de colunas: os seis ladrilhos têm 85 de largura PRÓPRIA e quebram quando não cabem. Coluna com `Expanded` estica cada um pra um terço da tela, que é outro desenho — foi o argumento que fez o `DilettaFrame.flow` entrar na linguagem (`ds v0.67.0`)."},
{"kind":"borda","text":"Sem favoritos a tela não tem a fileira de contatos, que é o estado do print. Com favoritos ela entra entre a busca e o Menu, com \"Ver todos\" no cabeçalho."},
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
{"id":"b_2","type":"saldo","props":{"valor":"R$ 0,14","entradas":"R$ 2.925,49","saidas":"R$ 2.925,70","oculto":false}},
{"id":"b_3","type":"texto","props":{"conteudo":"Transações","preset":"headlineSm"}},
{"id":"b_4","type":"campoDeBusca","props":{"placeholder":"Buscar","acaoDireita":"slidersLight"}},
{"id":"b_5","type":"grupoDoDia","props":{"rotulo":"Sexta","acessorio":"Saldo R$ 0,14"},"slots":{"itens":[
  {"id":"b_6","type":"linhaDeValor","props":{"icone":"pixLight","titulo":"RANTER SOARES DO CARMO","origem":"Pix","hora":"06:12","valor":"R$ 634,00","saida":true}},
  {"id":"b_7","type":"linhaDeValor","props":{"icone":"pixLight","titulo":"GRPQA LTDA","origem":"Pix","hora":"06:07","valor":"R$ 2.291,70","saida":true}}
]}},
{"id":"b_8","type":"grupoDoDia","props":{"rotulo":"Quinta","acessorio":"Saldo R$ 2.925,84"},"slots":{"itens":[
  {"id":"b_9","type":"linhaDeValor","props":{"icone":"arrowRightArrowLeftLight","titulo":"DILETTA APLICATIVOS E","origem":"Interno","hora":"18:47","valor":"R$ 2.925,49","saida":false}}
]}},
{"id":"b_10","type":"grupoDoDia","props":{"rotulo":"24 de jul","acessorio":"Saldo R$ 0,35"},"slots":{"itens":[
  {"id":"b_11","type":"linhaDeValor","props":{"icone":"pixLight","titulo":"RANTER SOARES DO CARMO","origem":"Pix","hora":"16:38","valor":"R$ 0,35","saida":false}}
]}}
],
"bottom":[],
"notes":[
{"kind":"decisao","text":"O saldo é o MESMO componente da home, e não uma versão de extrato: quem abre o extrato veio do saldo, e um segundo desenho do mesmo número cria duas fontes de verdade visual."},
{"kind":"regra","text":"O rótulo do dia é o DIA DA SEMANA enquanto ele está na semana corrente (\"Sexta\", \"Quinta\") e vira data quando sai dela (\"24 de jul\"). O acessório à direita diz \"Saldo\" por extenso — é o consolidado DAQUELE dia, não do mês."},
{"kind":"borda","text":"N lançamentos no dia dão N-1 fios, E o dia de lançamento ÚNICO leva fio — ali ele fecha o grupo por baixo. Foi um print do dono que achou o defeito: a regra estava certa e a COR estava errada, branco a 12% cravado, invisível no claro."},
{"kind":"a11y","text":"A fila de filtros (Tudo · Entradas · Saídas) só existe com filtro ATIVO, e por isso não está aqui: ela nasce da folha de filtro. O chip escolhido inverte fundo E peso — cor sozinha não é informação."}
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
