/// Conta BOLD — Design System (barrel raiz do package `conta_bold_ds`).
///
/// Superfície pública única. O app consome com alias:
/// ```dart
/// import 'package:conta_bold_ds/conta_bold_ds.dart' as ds;
/// // ...
/// ds.Button(...); ds.Icon('home'); ds.AppList.plain(children: [...]);
/// ```
/// Os `typedef` abaixo são a superfície curta (`ds.X`); a implementação vem do
/// barrel interno e mantém os nomes longos `Bold*` também válidos.
/// Espelha o padrão do `cpf_seguro_design_system`.
library;

import 'design_system/bold_design_system.dart';
export 'design_system/bold_design_system.dart';

// Camada de compat (tokens/widgets legados App*: AppColors, AppTextStyles,
// AppSpacing, AppRadius, AppButton, appIcon, AtmosphericBackground…). Absorvida
// no package pra o app consumir tudo via ds.X sem mudar render.
export 'ds_compat/conta_bold_theme.dart';

// ── Aliases curtos (ds.X) — gerados a partir dos tipos públicos Bold* ─────────
typedef Accordion = BoldAccordion;
typedef AccountPill = BoldAccountPill;
typedef AccountSwitcher = BoldAccountSwitcher;
typedef Alert = BoldAlert;
typedef AmountDisplay = BoldAmountDisplay;
typedef AnimateIn = BoldAnimateIn;
typedef AppList = BoldAppList;
typedef AppListDayGroup = BoldAppListDayGroup;
typedef AppListGroup = BoldAppListGroup;
typedef Avatar = BoldAvatar;
typedef AvatarRow = BoldAvatarRow;
typedef AvatarStack = BoldAvatarStack;
typedef Backdrop = BoldBackdrop;
typedef BackdropScope = BoldBackdropScope;
typedef Background = BoldBackground;
typedef Badge = BoldBadge;
typedef Balance = BoldBalance;
typedef BottomApp = BoldBottomApp;
typedef BottomNav = BoldBottomNav;
typedef Button = BoldButton;
typedef ButtonSize = BoldButtonSize;
typedef ButtonVariant = BoldButtonVariant;
typedef Card = BoldCard;
typedef CardSurface = BoldCardSurface;
typedef Checkbox = BoldCheckbox;
typedef CheckboxSize = BoldCheckboxSize;
typedef CheckboxVariant = BoldCheckboxVariant;
typedef CircleButton = BoldCircleButton;
typedef Colors = BoldColors;
typedef CopyButton = BoldCopyButton;
typedef CurrencyField = BoldCurrencyField;
typedef DetailRow = BoldDetailRow;
typedef Dialog = BoldDialog;
typedef Elevation = BoldElevation;
typedef EmptyState = BoldEmptyState;
typedef FilterChip = BoldFilterChip;
typedef Glass = BoldGlass;
typedef GlassAvatar = BoldGlassAvatar;
typedef GlassSurface = BoldGlassSurface;
typedef Gradients = BoldGradients;
typedef HomeBackground = BoldHomeBackground;
typedef HomeIndicator = BoldHomeIndicator;
typedef Icon = BoldIcon;
typedef IconAccessory = BoldIconAccessory;
typedef IconButton = BoldIconButton;
typedef IconButtonSize = BoldIconButtonSize;
typedef IconButtonState = BoldIconButtonState;
typedef IconButtonType = BoldIconButtonType;
typedef IconChip = BoldIconChip;
typedef IconFlush = BoldIconFlush;
typedef IconSize = BoldIconSize;
typedef Illustration = BoldIllustration;
typedef InputChip = BoldInputChip;
typedef InputChipTone = BoldInputChipTone;
typedef Intent = BoldIntent;
typedef Keypad = BoldKeypad;
typedef LeftAccessory = BoldLeftAccessory;
typedef ListAmount = BoldListAmount;
typedef ListGroup = BoldListGroup;
typedef ListTile = BoldListTile;
typedef ListTime = BoldListTime;
typedef ListTimeStatus = BoldListTimeStatus;
typedef Logo = BoldLogo;
typedef MenuTile = BoldMenuTile;
typedef MenuTileSize = BoldMenuTileSize;
typedef MiddleAccessory = BoldMiddleAccessory;
typedef MoneyInputFormatter = BoldMoneyInputFormatter;
typedef Motion = BoldMotion;
typedef MotionPreset = BoldMotionPreset;
typedef NavAction = BoldNavAction;
typedef NavItem = BoldNavItem;
typedef NavLeftAccessory = BoldNavLeftAccessory;
typedef NavRightAccessory = BoldNavRightAccessory;
typedef NavRightIcon = BoldNavRightIcon;
typedef NavTopBar = BoldNavTopBar;
typedef NavigationButton = BoldNavigationButton;
typedef NoticeRow = BoldNoticeRow;
typedef OtpInput = BoldOtpInput;
typedef PageDots = BoldPageDots;
typedef PageTitle = BoldPageTitle;
typedef PasswordSheet = BoldPasswordSheet;
typedef PinDots = BoldPinDots;
typedef PixMark = BoldPixMark;
typedef ProgressBar = BoldProgressBar;
typedef PromoBanner = BoldPromoBanner;
typedef PromoCard = BoldPromoCard;
typedef QuantumCore = BoldQuantumCore;
typedef QuantumPairingScreen = BoldQuantumPairingScreen;
typedef QuantumSeal = BoldQuantumSeal;
typedef QuickAction = BoldQuickAction;
typedef RadioList = BoldRadioList;
typedef RadioOption = BoldRadioOption;
typedef Radius = BoldRadius;
typedef Receipt = BoldReceipt;
typedef ReceiptRow = BoldReceiptRow;
typedef ReceiptSection = BoldReceiptSection;
typedef RightAccessory = BoldRightAccessory;
typedef Scheme = BoldScheme;
typedef SearchInput = BoldSearchInput;
typedef SecondaryBackground = BoldSecondaryBackground;
typedef SectionHeader = BoldSectionHeader;
typedef SeeAllLink = BoldSeeAllLink;
typedef SegmentedControl = BoldSegmentedControl;
typedef SelectField = BoldSelectField;
typedef Sheet = BoldSheet;
typedef Skeleton = BoldSkeleton;
typedef Space = BoldSpace;
typedef Spinner = BoldSpinner;
typedef SpinnerSize = BoldSpinnerSize;
typedef SpotIcon = BoldSpotIcon;
typedef SpotTone = BoldSpotTone;
typedef StatusBadge = BoldStatusBadge;
typedef StatusTag = BoldStatusTag;
typedef StatusTagData = BoldStatusTagData;
typedef StatusTone = BoldStatusTone;
typedef Stepper = BoldStepper;
typedef SummaryAction = BoldSummaryAction;
typedef SummaryRow = BoldSummaryRow;
typedef SummarySection = BoldSummarySection;
typedef Switch = BoldSwitch;
typedef TabBar<T> = BoldTabBar<T>;
typedef TabItem<T> = BoldTabItem<T>;
typedef TextField = BoldTextField;
typedef Theme = BoldTheme;
typedef Toast = BoldToast;
typedef Tooltip = BoldTooltip;
typedef TooltipSide = BoldTooltipSide;
typedef TooltipSize = BoldTooltipSize;
typedef TooltipStyle = BoldTooltipStyle;
typedef TopBar = BoldTopBar;
typedef TransactionSummary = BoldTransactionSummary;
typedef Type = BoldType;
