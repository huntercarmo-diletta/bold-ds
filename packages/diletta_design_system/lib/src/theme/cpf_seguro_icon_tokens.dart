// Valores = nome do arquivo em assets/icons/ (nomes do DS/Figma, estáveis).
// 7 exports crus do Figma (Cover, Vector*, Proximity profile, Wallet-solid)
// ficaram de fora.
//
// ESTE ARQUIVO É MANTIDO À MÃO — e o cabeçalho antes dizia "GERADO … NÃO editar
// à mão", apontando pra uma geração que não existe em nenhum dos dois repos
// (procurado em 2026-07-29, respondendo um pedido de ícone novo). Banner que
// mente é pior que banner ausente: ele faz a próxima pessoa procurar um script
// por meia hora, ou editar com medo. Ícone novo = 2 consts + 2 linhas no mapa,
// e o `.vec` compilado por tool/gen_icons_vec.sh.
//
// A dívida de verdade está escrita nesse script: as 354 fontes SVG moram no
// PRIMEIRO FILHO, e o pai só tem o binário.

/// CPF SEGURO — tokens de ícone.
///
/// Ícone é TOKEN, não string mágica: `DilettaIcons.chevronDownLight`
/// em vez de `'chevron-down-light'`. O valor é o nome do SVG em
/// `assets/icons/`. Consumido sempre via [DilettaIcon] /
/// [DilettaIconAccessory] — o encapsulamento mora neles, os
/// componentes só referenciam o token.
///
/// ```dart
/// DilettaIcon(name: DilettaIcons.bellLight),
/// DilettaLeftAccessory.spotIcon(icon: DilettaIcons.userLight),
/// ```
class DilettaIcons {
  const DilettaIcons._();

  static const String angleDownLight = 'angle-down-light';
  static const String angleDownSolid = 'angle-down-solid';
  static const String angleRightLight = 'angle-right-light';
  static const String angleRightSolid = 'angle-right-solid';
  static const String angleUpLight = 'angle-up-light';
  static const String angleUpSolid = 'angle-up-solid';
  static const String appleSolid = 'apple-solid';
  static const String arrowDownLight = 'arrow-down-light';
  static const String arrowDownSolid = 'arrow-down-solid';
  static const String arrowDownToBracketLight = 'arrow-down-to-bracket-light';
  static const String arrowDownToBracketSolid = 'arrow-down-to-bracket-solid';
  static const String arrowDownToLineLight = 'arrow-down-to-line-light';
  static const String arrowDownToLineSolid = 'arrow-down-to-line-solid';
  static const String arrowLeftLight = 'arrow-left-light';
  static const String arrowLeftSolid = 'arrow-left-solid';
  static const String arrowRightLight = 'arrow-right-light';
  static const String arrowRightSolid = 'arrow-right-solid';
  static const String arrowRightArrowLeftLight = 'arrow-right-arrow-left-light';
  static const String arrowRightArrowLeftSolid = 'arrow-right-arrow-left-solid';
  static const String arrowRightFromBracketLight = 'arrow-right-from-bracket-light';
  static const String arrowRightFromBracketSolid = 'arrow-right-from-bracket-solid';
  static const String arrowRightLongLight = 'arrow-right-long-light';
  static const String arrowRightLongSolid = 'arrow-right-long-solid';
  static const String arrowRightToBracketLight = 'arrow-right-to-bracket-light';
  static const String arrowRightToBracketSolid = 'arrow-right-to-bracket-solid';
  static const String arrowRotateLeftLight = 'arrow-rotate-left-light';
  static const String arrowRotateLeftSolid = 'arrow-rotate-left-solid';
  static const String arrowTrendDownLight = 'arrow-trend-down-light';
  static const String arrowTrendDownSolid = 'arrow-trend-down-solid';
  static const String arrowTrendUpLight = 'arrow-trend-up-light';
  static const String arrowTrendUpSolid = 'arrow-trend-up-solid';
  static const String arrowTurnDownLeftRegular = 'arrow-turn-down-left-regular';
  static const String arrowUpFromBracketLight = 'arrow-up-from-bracket-light';
  static const String arrowUpFromBracketSolid = 'arrow-up-from-bracket-solid';
  static const String arrowUpLight = 'arrow-up-light';
  static const String arrowUpRightFromSquareLight = 'arrow-up-right-from-square-light';
  static const String arrowUpRightFromSquareSolid = 'arrow-up-right-from-square-solid';
  static const String arrowUpSolid = 'arrow-up-solid';
  static const String asteriskLight = 'asterisk-light';
  static const String asteriskSolid = 'asterisk-solid';
  static const String banLight = 'ban-light';
  static const String banSolid = 'ban-solid';
  static const String barcodeLight = 'barcode-light';
  static const String barcodeSolid = 'barcode-solid';
  static const String barsFilterLight = 'bars-filter-light';
  static const String barsFilterSolid = 'bars-filter-solid';
  static const String barsLight = 'bars-light';
  static const String barsSolid = 'bars-solid';
  static const String bellLight = 'bell-light';
  static const String bellSolid = 'bell-solid';
  static const String boxArchiveLightFull = 'box-archive-light-full';
  static const String boxArchiveSolidFull = 'box-archive-solid-full';
  static const String brazilianRealSignLight = 'brazilian-real-sign-light';
  static const String brazilianRealSignSolid = 'brazilian-real-sign-solid';
  static const String briefcaseLight = 'briefcase-light';
  static const String briefcaseSolid = 'briefcase-solid';
  static const String buildingLight = 'building-light';
  static const String buildingSolid = 'building-solid';
  static const String burgerSodaDuotone = 'burger-soda-duotone';
  static const String burgerSodaLight = 'burger-soda-light';
  static const String busLight = 'bus-light';
  static const String busSolid = 'bus-solid';
  static const String calculatorLight = 'calculator-light';
  static const String calculatorSolid = 'calculator-solid';
  static const String calendarDayLight = 'calendar-day-light';
  static const String calendarDaySolid = 'calendar-day-solid';
  static const String calendarDaysLight = 'calendar-days-light';
  static const String calendarDaysSolid = 'calendar-days-solid';
  static const String calendarLight = 'calendar-light';
  static const String calendarRegular = 'calendar-regular';
  static const String cameraLight = 'camera-light';
  static const String cameraRotateLight = 'camera-rotate-light';
  static const String cameraRotateSolid = 'camera-rotate-solid';
  static const String cameraSolid = 'camera-solid';
  static const String carSideLight = 'car-side-light';
  static const String carSideSolid = 'car-side-solid';
  static const String cashRegisterLight = 'cash-register-light';
  static const String cashRegisterSolid = 'cash-register-solid';
  static const String chartLineLight = 'chart-line-light';
  static const String chartLineSolid = 'chart-line-solid';
  static const String checkLight = 'check-light';
  static const String checkSolid = 'check-solid';
  static const String checkToSlotSolid = 'check-to-slot-solid';
  static const String chevronDownLight = 'chevron-down-light';
  static const String chevronDownSolid = 'chevron-down-solid';
  static const String chevronLeftLight = 'chevron-left-light';
  static const String chevronLeftSolid = 'chevron-left-solid';
  static const String chevronRightLight = 'chevron-right-light';
  static const String chevronRightSolid = 'chevron-right-solid';
  static const String chevronUpLight = 'chevron-up-light';
  static const String chevronUpSolid = 'chevron-up-solid';
  static const String circleArrowUpLight = 'circle-arrow-up-light';
  static const String circleArrowUpSolid = 'circle-arrow-up-solid';
  static const String circleCheckLight = 'circle-check-light';
  static const String circleCheckSolid = 'circle-check-solid';
  static const String circleDollarLight = 'circle-dollar-light';
  static const String circleDollarSolid = 'circle-dollar-solid';
  static const String circleDollarToSlotSharpLight = 'circle-dollar-to-slot-sharp-light';
  static const String circleDollarToSlotSharpSolid = 'circle-dollar-to-slot-sharp-solid';
  static const String circleExclamationLight = 'circle-exclamation-light';
  static const String circleExclamationSolid = 'circle-exclamation-solid';
  static const String circleInfoLight = 'circle-info-light';
  static const String circleInfoSolid = 'circle-info-solid';
  static const String circleMinusLight = 'circle-minus-light';
  static const String circleMinusSolid = 'circle-minus-solid';
  static const String circlePlusLight = 'circle-plus-light';
  static const String circlePlusSolid = 'circle-plus-solid';
  static const String circleQuestionLight = 'circle-question-light';
  static const String circleQuestionSolid = 'circle-question-solid';
  static const String circleSmallLight = 'circle-small-light';
  static const String circleSmallSolid = 'circle-small-solid';
  static const String circleUserLight = 'circle-user-light';
  static const String circleUserSolid = 'circle-user-solid';
  static const String circleXmarkLight = 'circle-xmark-light';
  static const String circleXmarkSolid = 'circle-xmark-solid';
  static const String clipboardListCheckLight = 'clipboard-list-check-light';
  static const String clipboardListCheckSolid = 'clipboard-list-check-solid';
  static const String clockLight = 'clock-light';
  static const String clockRotateLeftLight = 'clock-rotate-left-light';
  static const String clockRotateLeftSolid = 'clock-rotate-left-solid';
  static const String clockSolid = 'clock-solid';
  static const String cloneLight = 'clone-light';
  static const String cloneSolid = 'clone-solid';
  static const String cloudSunLight = 'cloud-sun-light';
  static const String cloudSunSolid = 'cloud-sun-solid';
  static const String codeLight = 'code-light';
  static const String codeSolid = 'code-solid';
  static const String coinsLight = 'coins-light';
  static const String coinsSolid = 'coins-solid';
  static const String creditCardLight = 'credit-card-light';
  static const String creditCardSolid = 'credit-card-solid';
  static const String deleteLeftLight = 'delete-left-light';
  static const String deleteLeftSolid = 'delete-left-solid';
  static const String desktopLight = 'desktop-light';
  static const String desktopSolid = 'desktop-solid';
  static const String downloadLight = 'download-light';
  static const String downloadSolid = 'download-solid';
  static const String earthAmericasSolidFull = 'earth-americas-solid-full';
  static const String ellipsisVerticalLight = 'ellipsis-vertical-light';
  static const String ellipsisVerticalSolid = 'ellipsis-vertical-solid';
  static const String envelopeLight = 'envelope-light';
  static const String envelopeSolid = 'envelope-solid';
  static const String expandLight = 'expand-light';
  static const String expandSolid = 'expand-solid';
  static const String eyeLight = 'eye-light';
  static const String eyeSlashLightFull = 'eye-slash-light-full';
  static const String eyeSlashSolidFull = 'eye-slash-solid-full';
  static const String eyeSolid = 'eye-solid';
  static const String faceIdLight = 'face-id-light';
  static const String facebookF = 'facebook-f';
  static const String fileChartPieLight = 'file-chart-pie-light';
  static const String fileChartPieSolid = 'file-chart-pie-solid';
  static const String fileInvoiceDollarLight = 'file-invoice-dollar-light';
  static const String fileInvoiceDollarLight2 = 'file-invoice-dollar-light-2';
  static const String fileInvoiceDollarSolid = 'file-invoice-dollar-solid';
  static const String fileInvoiceDollarSolid2 = 'file-invoice-dollar-solid-2';
  static const String fileInvoiceLight = 'file-invoice-light';
  static const String fileInvoiceSolid = 'file-invoice-solid';
  static const String fileLight = 'file-light';
  static const String fileLinesLightFull = 'file-lines-light-full';
  static const String fileLinesSolidFull = 'file-lines-solid-full';
  static const String fileSlashLight = 'file-slash-light';
  static const String fileSlashSolid = 'file-slash-solid';
  static const String fileSolid = 'file-solid';
  static const String fingerprintLight = 'fingerprint-light';
  static const String fingerprintSolid = 'fingerprint-solid';
  static const String flagPennantLight = 'flag-pennant-light';
  static const String flagPennantSolid = 'flag-pennant-solid';
  static const String gaugeMaxLight = 'gauge-max-light';
  static const String gaugeMaxSolid = 'gauge-max-solid';
  static const String gearLight = 'gear-light';
  static const String gearSolid = 'gear-solid';
  static const String gearsLightFull = 'gears-light-full';
  static const String gearsSolidFull = 'gears-solid-full';
  static const String globe = 'globe';
  static const String googleSolid = 'google-solid';
  static const String handWaveLight = 'hand-wave-light';
  static const String handWaveSolid = 'hand-wave-solid';
  static const String handshakeLight = 'handshake-light';
  static const String handshakeSlashLight = 'handshake-slash-light';
  static const String handshakeSlashSolid = 'handshake-slash-solid';
  static const String handshakeSolid = 'handshake-solid';
  static const String hashtagLockLight = 'hashtag-lock-light';
  static const String hashtagLockSolid = 'hashtag-lock-solid';
  static const String hourglassStartLight = 'hourglass-start-light';
  static const String hourglassStartSolid = 'hourglass-start-solid';
  static const String houseLight = 'house-light';
  static const String houseSolid = 'house-solid';
  static const String idCardClipLight = 'id-card-clip-light';
  static const String idCardClipSolid = 'id-card-clip-solid';
  static const String idCardLight = 'id-card-light';
  static const String idCardSolid = 'id-card-solid';
  static const String imageLight = 'image-light';
  static const String imageSolid = 'image-solid';
  static const String instagram = 'instagram';
  static const String islandTropicalLight = 'island-tropical-light';
  static const String islandTropicalSolid = 'island-tropical-solid';
  static const String keyLight = 'key-light';
  static const String keySolid = 'key-solid';
  static const String landmarkLight = 'landmark-light';
  static const String landmarkSolid = 'landmark-solid';
  static const String lightbulbLight = 'lightbulb-light';
  static const String lightbulbSolid = 'lightbulb-solid';
  static const String linkLight = 'link-light';
  static const String linkSolid = 'link-solid';
  static const String linkedin = 'linkedin';
  static const String linkedinIn = 'linkedin-in';
  static const String listCheckLight = 'list-check-light';
  static const String listCheckSolid = 'list-check-solid';
  static const String lockLight = 'lock-light';
  static const String lockOpenLight = 'lock-open-light';
  static const String lockOpenSolid = 'lock-open-solid';
  static const String lockSolid = 'lock-solid';
  static const String magnifyingGlassLight = 'magnifying-glass-light';
  static const String magnifyingGlassSolid = 'magnifying-glass-solid';
  static const String menuFoldLight = 'menu-fold-light';
  static const String menuFoldSolid = 'menu-fold-solid';
  static const String menuUnfoldLight = 'menu-unfold-light';
  static const String menuUnfoldSolid = 'menu-unfold-solid';
  static const String messagesQuestionLightFull = 'messages-question-light-full';
  static const String messagesQuestionSolidFull = 'messages-question-solid-full';
  static const String minusLight = 'minus-light';
  static const String minusSolid = 'minus-solid';
  static const String mobileGearLight = 'mobile-gear-light';
  static const String mobileGearSolid = 'mobile-gear-solid';
  static const String mobileLight = 'mobile-light';
  static const String mobileSignalLight = 'mobile-signal-light';
  static const String mobileSignalSolid = 'mobile-signal-solid';
  static const String mobileSolid = 'mobile-solid';
  static const String moneyBillTransferInLight = 'money-bill-transfer-in-light';
  static const String moneyBillTransferLight = 'money-bill-transfer-light';
  static const String moneyBillTransferOutLight = 'money-bill-transfer-out-light';
  static const String moneyBillTransferSolid = 'money-bill-transfer-solid';
  static const String moneyBillTrendUpLight = 'money-bill-trend-up-light';
  static const String moneyBillTrendUpSolid = 'money-bill-trend-up-solid';
  static const String monitorWaveformLight = 'monitor-waveform-light';
  static const String monitorWaveformSolid = 'monitor-waveform-solid';
  static const String moonCloudSolid = 'moon-cloud-solid';
  static const String moonStarsLight = 'moon-stars-light';
  static const String moonStarsSolid = 'moon-stars-solid';
  static const String motorcycleLight = 'motorcycle-light';
  static const String motorcycleSolid = 'motorcycle-solid';
  static const String noteLightFull = 'note-light-full';
  static const String noteSolidFull = 'note-solid-full';
  static const String paperPlaneLight = 'paper-plane-light';
  static const String paperPlaneSolid = 'paper-plane-solid';
  static const String paperclipLight = 'paperclip-light';
  static const String paperclipSolid = 'paperclip-solid';
  static const String pauseLightFull = 'pause-light-full';
  static const String pauseSolidFull = 'pause-solid-full';
  static const String penToSquareLight = 'pen-to-square-light';
  static const String penToSquareLight2 = 'pen-to-square-light-2';
  static const String penToSquareSolid = 'pen-to-square-solid';
  static const String penToSquareSolid2 = 'pen-to-square-solid-2';
  static const String percentLight = 'percent-light';
  static const String percentLight2 = 'percent-light-2';
  static const String percentSolid = 'percent-solid';
  static const String percentSolid2 = 'percent-solid-2';
  static const String periodLight = 'period-light';
  static const String periodSolid = 'period-solid';
  static const String piggyBankLight = 'piggy-bank-light';
  static const String piggyBankSolid = 'piggy-bank-solid';
  static const String pixLight = 'pix-light';
  static const String pixMark = 'pix-mark';
  static const String pixSolid = 'pix-solid';
  static const String playRegularFull = 'play-regular-full';
  static const String playSolidFull = 'play-solid-full';
  static const String plusLight = 'plus-light';
  static const String plusSolid = 'plus-solid';
  static const String puzzleLight = 'puzzle-light';
  static const String puzzleSolid = 'puzzle-solid';
  static const String qrcodeLight = 'qrcode-light';
  static const String qrcodeSolid = 'qrcode-solid';
  static const String receiptLight = 'receipt-light';
  static const String receiptSolid = 'receipt-solid';
  static const String scaleBalancedLight = 'scale-balanced-light';
  static const String scaleBalancedSolid = 'scale-balanced-solid';
  static const String sendCpfSeguro = 'send-cpf-seguro';
  static const String shareLight = 'share-light';
  static const String shareSolid = 'share-solid';
  static const String shieldUserLightFull = 'shield-user-light-full';
  static const String shieldUserSolidFull = 'shield-user-solid-full';
  static const String shipLight = 'ship-light';
  static const String shipSolid = 'ship-solid';
  static const String sirenOnLight = 'siren-on-light';
  static const String sirenOnSolid = 'siren-on-solid';
  static const String sirenSolid = 'siren-solid';
  static const String slidersLight = 'sliders-light';
  static const String slidersSolid = 'sliders-solid';
  /// ASSISTENTE DE IA. O glifo é o convencional da década, não de um produto.
  static const String sparklesLightFull = 'sparkles-light-full';
  static const String sparklesSolidFull = 'sparkles-solid-full';
  static const String squareFacebook = 'square-facebook';
  static const String squareInstagram = 'square-instagram';
  static const String squareTwitter = 'square-twitter';
  static const String stampLight = 'stamp-light';
  static const String stampSolid = 'stamp-solid';
  static const String starLight = 'star-light';
  static const String starSolid = 'star-solid';
  static const String stopwatchLight = 'stopwatch-light';
  static const String stopwatchSolid = 'stopwatch-solid';
  static const String storeLight = 'store-light';
  static const String storeSolid = 'store-solid';
  static const String sunLight = 'sun-light';
  static const String sunSolid = 'sun-solid';
  static const String tableTreeLight = 'table-tree-light';
  static const String tableTreeSolid = 'table-tree-solid';
  static const String thumbtackLight = 'thumbtack-light';
  static const String thumbtackSlashLight = 'thumbtack-slash-light';
  static const String thumbtackSlashSolid = 'thumbtack-slash-solid';
  static const String thumbtackSolid = 'thumbtack-solid';
  static const String timerLight = 'timer-light';
  static const String timerSolid = 'timer-solid';
  static const String trashLight = 'trash-light';
  static const String trashSolid = 'trash-solid';
  static const String triangleExclamationLight = 'triangle-exclamation-light';
  static const String triangleExclamationSolid = 'triangle-exclamation-solid';
  static const String truckLight = 'truck-light';
  static const String truckLight2 = 'truck-light-2';
  static const String truckSolid = 'truck-solid';
  static const String truckSolid2 = 'truck-solid-2';
  static const String twitter = 'twitter';
  static const String uploadLight = 'upload-light';
  static const String uploadSolid = 'upload-solid';
  static const String userCircleMinusLightFull = 'user-circle-minus-light-full';
  static const String userCircleMinusSolidFull = 'user-circle-minus-solid-full';
  static const String userGearLight = 'user-gear-light';
  static const String userGearSolid = 'user-gear-solid';
  static const String userLight = 'user-light';
  static const String userLockLightFull = 'user-lock-light-full';
  static const String userLockSolidFull = 'user-lock-solid-full';
  static const String userPenLightFull = 'user-pen-light-full';
  static const String userPenSolidFull = 'user-pen-solid-full';
  static const String userPlusLight = 'user-plus-light';
  static const String userPlusSolid = 'user-plus-solid';
  static const String userSolid = 'user-solid';
  static const String userTieLight = 'user-tie-light';
  static const String userTieSolid = 'user-tie-solid';
  static const String userViewfinderLightFull = 'user-viewfinder-light-full';
  static const String userViewfinderSolidFull = 'user-viewfinder-solid-full';
  static const String usersLight = 'users-light';
  static const String usersRectangleLight = 'users-rectangle-light';
  static const String usersRectangleSolid = 'users-rectangle-solid';
  static const String usersSolid = 'users-solid';
  static const String walletLight = 'wallet-light';
  static const String waveLight = 'wave-light';
  static const String waveSolid = 'wave-solid';
  static const String whatsappSolid = 'whatsapp-solid';
  static const String wifiLight = 'wifi-light';
  static const String wifiSolid = 'wifi-solid';
  static const String xmarkLight = 'xmark-light';
  static const String xmarkSolid = 'xmark-solid';

  /// TODOS os tokens, por nome. Existe porque o CATÁLOGO precisa oferecer a
  /// lista inteira no seletor de ícone: ele expunha 19 de 347 porque a lista
  /// era mantida à mão do outro lado. Vocabulário que o consumidor não
  /// consegue ENUMERAR vira vocabulário pela metade.
  ///
  /// Gerado junto dos tokens — some e volta com a pasta de SVG.
  static const Map<String, String> all = {
    'angleDownLight': angleDownLight,
    'angleDownSolid': angleDownSolid,
    'angleRightLight': angleRightLight,
    'angleRightSolid': angleRightSolid,
    'angleUpLight': angleUpLight,
    'angleUpSolid': angleUpSolid,
    'appleSolid': appleSolid,
    'arrowDownLight': arrowDownLight,
    'arrowDownSolid': arrowDownSolid,
    'arrowDownToBracketLight': arrowDownToBracketLight,
    'arrowDownToBracketSolid': arrowDownToBracketSolid,
    'arrowDownToLineLight': arrowDownToLineLight,
    'arrowDownToLineSolid': arrowDownToLineSolid,
    'arrowLeftLight': arrowLeftLight,
    'arrowLeftSolid': arrowLeftSolid,
    'arrowRightLight': arrowRightLight,
    'arrowRightSolid': arrowRightSolid,
    'arrowRightArrowLeftLight': arrowRightArrowLeftLight,
    'arrowRightArrowLeftSolid': arrowRightArrowLeftSolid,
    'arrowRightFromBracketLight': arrowRightFromBracketLight,
    'arrowRightFromBracketSolid': arrowRightFromBracketSolid,
    'arrowRightLongLight': arrowRightLongLight,
    'arrowRightLongSolid': arrowRightLongSolid,
    'arrowRightToBracketLight': arrowRightToBracketLight,
    'arrowRightToBracketSolid': arrowRightToBracketSolid,
    'arrowRotateLeftLight': arrowRotateLeftLight,
    'arrowRotateLeftSolid': arrowRotateLeftSolid,
    'arrowTrendDownLight': arrowTrendDownLight,
    'arrowTrendDownSolid': arrowTrendDownSolid,
    'arrowTrendUpLight': arrowTrendUpLight,
    'arrowTrendUpSolid': arrowTrendUpSolid,
    'arrowTurnDownLeftRegular': arrowTurnDownLeftRegular,
    'arrowUpFromBracketLight': arrowUpFromBracketLight,
    'arrowUpFromBracketSolid': arrowUpFromBracketSolid,
    'arrowUpLight': arrowUpLight,
    'arrowUpRightFromSquareLight': arrowUpRightFromSquareLight,
    'arrowUpRightFromSquareSolid': arrowUpRightFromSquareSolid,
    'arrowUpSolid': arrowUpSolid,
    'asteriskLight': asteriskLight,
    'asteriskSolid': asteriskSolid,
    'banLight': banLight,
    'banSolid': banSolid,
    'barcodeLight': barcodeLight,
    'barcodeSolid': barcodeSolid,
    'barsFilterLight': barsFilterLight,
    'barsFilterSolid': barsFilterSolid,
    'barsLight': barsLight,
    'barsSolid': barsSolid,
    'bellLight': bellLight,
    'bellSolid': bellSolid,
    'boxArchiveLightFull': boxArchiveLightFull,
    'boxArchiveSolidFull': boxArchiveSolidFull,
    'brazilianRealSignLight': brazilianRealSignLight,
    'brazilianRealSignSolid': brazilianRealSignSolid,
    'briefcaseLight': briefcaseLight,
    'briefcaseSolid': briefcaseSolid,
    'buildingLight': buildingLight,
    'buildingSolid': buildingSolid,
    'burgerSodaDuotone': burgerSodaDuotone,
    'burgerSodaLight': burgerSodaLight,
    'busLight': busLight,
    'busSolid': busSolid,
    'calculatorLight': calculatorLight,
    'calculatorSolid': calculatorSolid,
    'calendarDayLight': calendarDayLight,
    'calendarDaySolid': calendarDaySolid,
    'calendarDaysLight': calendarDaysLight,
    'calendarDaysSolid': calendarDaysSolid,
    'calendarLight': calendarLight,
    'calendarRegular': calendarRegular,
    'cameraLight': cameraLight,
    'cameraRotateLight': cameraRotateLight,
    'cameraRotateSolid': cameraRotateSolid,
    'cameraSolid': cameraSolid,
    'carSideLight': carSideLight,
    'carSideSolid': carSideSolid,
    'cashRegisterLight': cashRegisterLight,
    'cashRegisterSolid': cashRegisterSolid,
    'chartLineLight': chartLineLight,
    'chartLineSolid': chartLineSolid,
    'checkLight': checkLight,
    'checkSolid': checkSolid,
    'checkToSlotSolid': checkToSlotSolid,
    'chevronDownLight': chevronDownLight,
    'chevronDownSolid': chevronDownSolid,
    'chevronLeftLight': chevronLeftLight,
    'chevronLeftSolid': chevronLeftSolid,
    'chevronRightLight': chevronRightLight,
    'chevronRightSolid': chevronRightSolid,
    'chevronUpLight': chevronUpLight,
    'chevronUpSolid': chevronUpSolid,
    'circleArrowUpLight': circleArrowUpLight,
    'circleArrowUpSolid': circleArrowUpSolid,
    'circleCheckLight': circleCheckLight,
    'circleCheckSolid': circleCheckSolid,
    'circleDollarLight': circleDollarLight,
    'circleDollarSolid': circleDollarSolid,
    'circleDollarToSlotSharpLight': circleDollarToSlotSharpLight,
    'circleDollarToSlotSharpSolid': circleDollarToSlotSharpSolid,
    'circleExclamationLight': circleExclamationLight,
    'circleExclamationSolid': circleExclamationSolid,
    'circleInfoLight': circleInfoLight,
    'circleInfoSolid': circleInfoSolid,
    'circleMinusLight': circleMinusLight,
    'circleMinusSolid': circleMinusSolid,
    'circlePlusLight': circlePlusLight,
    'circlePlusSolid': circlePlusSolid,
    'circleQuestionLight': circleQuestionLight,
    'circleQuestionSolid': circleQuestionSolid,
    'circleSmallLight': circleSmallLight,
    'circleSmallSolid': circleSmallSolid,
    'circleUserLight': circleUserLight,
    'circleUserSolid': circleUserSolid,
    'circleXmarkLight': circleXmarkLight,
    'circleXmarkSolid': circleXmarkSolid,
    'clipboardListCheckLight': clipboardListCheckLight,
    'clipboardListCheckSolid': clipboardListCheckSolid,
    'clockLight': clockLight,
    'clockRotateLeftLight': clockRotateLeftLight,
    'clockRotateLeftSolid': clockRotateLeftSolid,
    'clockSolid': clockSolid,
    'cloneLight': cloneLight,
    'cloneSolid': cloneSolid,
    'cloudSunLight': cloudSunLight,
    'cloudSunSolid': cloudSunSolid,
    'codeLight': codeLight,
    'codeSolid': codeSolid,
    'coinsLight': coinsLight,
    'coinsSolid': coinsSolid,
    'creditCardLight': creditCardLight,
    'creditCardSolid': creditCardSolid,
    'deleteLeftLight': deleteLeftLight,
    'deleteLeftSolid': deleteLeftSolid,
    'desktopLight': desktopLight,
    'desktopSolid': desktopSolid,
    'downloadLight': downloadLight,
    'downloadSolid': downloadSolid,
    'earthAmericasSolidFull': earthAmericasSolidFull,
    'ellipsisVerticalLight': ellipsisVerticalLight,
    'ellipsisVerticalSolid': ellipsisVerticalSolid,
    'envelopeLight': envelopeLight,
    'envelopeSolid': envelopeSolid,
    'expandLight': expandLight,
    'expandSolid': expandSolid,
    'eyeLight': eyeLight,
    'eyeSlashLightFull': eyeSlashLightFull,
    'eyeSlashSolidFull': eyeSlashSolidFull,
    'eyeSolid': eyeSolid,
    'faceIdLight': faceIdLight,
    'facebookF': facebookF,
    'fileChartPieLight': fileChartPieLight,
    'fileChartPieSolid': fileChartPieSolid,
    'fileInvoiceDollarLight': fileInvoiceDollarLight,
    'fileInvoiceDollarLight2': fileInvoiceDollarLight2,
    'fileInvoiceDollarSolid': fileInvoiceDollarSolid,
    'fileInvoiceDollarSolid2': fileInvoiceDollarSolid2,
    'fileInvoiceLight': fileInvoiceLight,
    'fileInvoiceSolid': fileInvoiceSolid,
    'fileLight': fileLight,
    'fileLinesLightFull': fileLinesLightFull,
    'fileLinesSolidFull': fileLinesSolidFull,
    'fileSlashLight': fileSlashLight,
    'fileSlashSolid': fileSlashSolid,
    'fileSolid': fileSolid,
    'fingerprintLight': fingerprintLight,
    'fingerprintSolid': fingerprintSolid,
    'flagPennantLight': flagPennantLight,
    'flagPennantSolid': flagPennantSolid,
    'gaugeMaxLight': gaugeMaxLight,
    'gaugeMaxSolid': gaugeMaxSolid,
    'gearLight': gearLight,
    'gearSolid': gearSolid,
    'gearsLightFull': gearsLightFull,
    'gearsSolidFull': gearsSolidFull,
    'globe': globe,
    'googleSolid': googleSolid,
    'handWaveLight': handWaveLight,
    'handWaveSolid': handWaveSolid,
    'handshakeLight': handshakeLight,
    'handshakeSlashLight': handshakeSlashLight,
    'handshakeSlashSolid': handshakeSlashSolid,
    'handshakeSolid': handshakeSolid,
    'hashtagLockLight': hashtagLockLight,
    'hashtagLockSolid': hashtagLockSolid,
    'hourglassStartLight': hourglassStartLight,
    'hourglassStartSolid': hourglassStartSolid,
    'houseLight': houseLight,
    'houseSolid': houseSolid,
    'idCardClipLight': idCardClipLight,
    'idCardClipSolid': idCardClipSolid,
    'idCardLight': idCardLight,
    'idCardSolid': idCardSolid,
    'imageLight': imageLight,
    'imageSolid': imageSolid,
    'instagram': instagram,
    'islandTropicalLight': islandTropicalLight,
    'islandTropicalSolid': islandTropicalSolid,
    'keyLight': keyLight,
    'keySolid': keySolid,
    'landmarkLight': landmarkLight,
    'landmarkSolid': landmarkSolid,
    'lightbulbLight': lightbulbLight,
    'lightbulbSolid': lightbulbSolid,
    'linkLight': linkLight,
    'linkSolid': linkSolid,
    'linkedin': linkedin,
    'linkedinIn': linkedinIn,
    'listCheckLight': listCheckLight,
    'listCheckSolid': listCheckSolid,
    'lockLight': lockLight,
    'lockOpenLight': lockOpenLight,
    'lockOpenSolid': lockOpenSolid,
    'lockSolid': lockSolid,
    'magnifyingGlassLight': magnifyingGlassLight,
    'magnifyingGlassSolid': magnifyingGlassSolid,
    'menuFoldLight': menuFoldLight,
    'menuFoldSolid': menuFoldSolid,
    'menuUnfoldLight': menuUnfoldLight,
    'menuUnfoldSolid': menuUnfoldSolid,
    'messagesQuestionLightFull': messagesQuestionLightFull,
    'messagesQuestionSolidFull': messagesQuestionSolidFull,
    'minusLight': minusLight,
    'minusSolid': minusSolid,
    'mobileGearLight': mobileGearLight,
    'mobileGearSolid': mobileGearSolid,
    'mobileLight': mobileLight,
    'mobileSignalLight': mobileSignalLight,
    'mobileSignalSolid': mobileSignalSolid,
    'mobileSolid': mobileSolid,
    'moneyBillTransferInLight': moneyBillTransferInLight,
    'moneyBillTransferLight': moneyBillTransferLight,
    'moneyBillTransferOutLight': moneyBillTransferOutLight,
    'moneyBillTransferSolid': moneyBillTransferSolid,
    'moneyBillTrendUpLight': moneyBillTrendUpLight,
    'moneyBillTrendUpSolid': moneyBillTrendUpSolid,
    'monitorWaveformLight': monitorWaveformLight,
    'monitorWaveformSolid': monitorWaveformSolid,
    'moonCloudSolid': moonCloudSolid,
    'moonStarsLight': moonStarsLight,
    'moonStarsSolid': moonStarsSolid,
    'motorcycleLight': motorcycleLight,
    'motorcycleSolid': motorcycleSolid,
    'noteLightFull': noteLightFull,
    'noteSolidFull': noteSolidFull,
    'paperPlaneLight': paperPlaneLight,
    'paperPlaneSolid': paperPlaneSolid,
    'paperclipLight': paperclipLight,
    'paperclipSolid': paperclipSolid,
    'pauseLightFull': pauseLightFull,
    'pauseSolidFull': pauseSolidFull,
    'penToSquareLight': penToSquareLight,
    'penToSquareLight2': penToSquareLight2,
    'penToSquareSolid': penToSquareSolid,
    'penToSquareSolid2': penToSquareSolid2,
    'percentLight': percentLight,
    'percentLight2': percentLight2,
    'percentSolid': percentSolid,
    'percentSolid2': percentSolid2,
    'periodLight': periodLight,
    'periodSolid': periodSolid,
    'piggyBankLight': piggyBankLight,
    'piggyBankSolid': piggyBankSolid,
    'pixLight': pixLight,
    'pixMark': pixMark,
    'pixSolid': pixSolid,
    'playRegularFull': playRegularFull,
    'playSolidFull': playSolidFull,
    'plusLight': plusLight,
    'plusSolid': plusSolid,
    'puzzleLight': puzzleLight,
    'puzzleSolid': puzzleSolid,
    'qrcodeLight': qrcodeLight,
    'qrcodeSolid': qrcodeSolid,
    'receiptLight': receiptLight,
    'receiptSolid': receiptSolid,
    'scaleBalancedLight': scaleBalancedLight,
    'scaleBalancedSolid': scaleBalancedSolid,
    'sendCpfSeguro': sendCpfSeguro,
    'shareLight': shareLight,
    'shareSolid': shareSolid,
    'shieldUserLightFull': shieldUserLightFull,
    'shieldUserSolidFull': shieldUserSolidFull,
    'shipLight': shipLight,
    'shipSolid': shipSolid,
    'sirenOnLight': sirenOnLight,
    'sirenOnSolid': sirenOnSolid,
    'sirenSolid': sirenSolid,
    'slidersLight': slidersLight,
    'slidersSolid': slidersSolid,
    'sparklesLightFull': sparklesLightFull,
    'sparklesSolidFull': sparklesSolidFull,
    'squareFacebook': squareFacebook,
    'squareInstagram': squareInstagram,
    'squareTwitter': squareTwitter,
    'stampLight': stampLight,
    'stampSolid': stampSolid,
    'starLight': starLight,
    'starSolid': starSolid,
    'stopwatchLight': stopwatchLight,
    'stopwatchSolid': stopwatchSolid,
    'storeLight': storeLight,
    'storeSolid': storeSolid,
    'sunLight': sunLight,
    'sunSolid': sunSolid,
    'tableTreeLight': tableTreeLight,
    'tableTreeSolid': tableTreeSolid,
    'thumbtackLight': thumbtackLight,
    'thumbtackSlashLight': thumbtackSlashLight,
    'thumbtackSlashSolid': thumbtackSlashSolid,
    'thumbtackSolid': thumbtackSolid,
    'timerLight': timerLight,
    'timerSolid': timerSolid,
    'trashLight': trashLight,
    'trashSolid': trashSolid,
    'triangleExclamationLight': triangleExclamationLight,
    'triangleExclamationSolid': triangleExclamationSolid,
    'truckLight': truckLight,
    'truckLight2': truckLight2,
    'truckSolid': truckSolid,
    'truckSolid2': truckSolid2,
    'twitter': twitter,
    'uploadLight': uploadLight,
    'uploadSolid': uploadSolid,
    'userCircleMinusLightFull': userCircleMinusLightFull,
    'userCircleMinusSolidFull': userCircleMinusSolidFull,
    'userGearLight': userGearLight,
    'userGearSolid': userGearSolid,
    'userLight': userLight,
    'userLockLightFull': userLockLightFull,
    'userLockSolidFull': userLockSolidFull,
    'userPenLightFull': userPenLightFull,
    'userPenSolidFull': userPenSolidFull,
    'userPlusLight': userPlusLight,
    'userPlusSolid': userPlusSolid,
    'userSolid': userSolid,
    'userTieLight': userTieLight,
    'userTieSolid': userTieSolid,
    'userViewfinderLightFull': userViewfinderLightFull,
    'userViewfinderSolidFull': userViewfinderSolidFull,
    'usersLight': usersLight,
    'usersRectangleLight': usersRectangleLight,
    'usersRectangleSolid': usersRectangleSolid,
    'usersSolid': usersSolid,
    'walletLight': walletLight,
    'waveLight': waveLight,
    'waveSolid': waveSolid,
    'whatsappSolid': whatsappSolid,
    'wifiLight': wifiLight,
    'wifiSolid': wifiSolid,
    'xmarkLight': xmarkLight,
    'xmarkSolid': xmarkSolid,
  };
}
