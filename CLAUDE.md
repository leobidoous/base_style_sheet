# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Purpose

`base_style_sheet` é a biblioteca de componentes visuais do ecossistema PayPay. Fornece o sistema de tema, tokens de design (espaçamento, tipografia, bordas, sombras), responsividade e todos os widgets reutilizáveis. Nenhum app do ecossistema deve criar widgets genéricos sem antes verificar se já existe aqui.

**Localização no ecossistema:** `/Users/leobidoous/Projects/Packages/base_style_sheet`  
**Consumidores diretos:** `paypay_core`, `paypay_studio`, e todos os apps via `paypay_core`

## Estrutura

```
lib/src/
  core/themes/
    app_theme_base.dart      # Constantes base: radii, shadows, opacidades, alturas, fontes
    app_theme_factory.dart   # AppThemeFactory (singleton) + extensões ThemeData/TextTheme
    theme_factory.dart       # ThemeFactory.light() / .dark()
    responsive/              # SizeConfig + extension Responsive on num
    spacing/                 # Spacing (sistema 8pt)
    typography/              # AppFontSize, AppFontWeight, TypographyBuilder
  domain/enums/              # ScreenSizeType, CustomPdfViewMode
  presentation/
    controllers/             # PagedListController, FilePickerController
    extensions/              # BuildContextExt
    shapes/                  # CoupomBorderPainter, InverseBorderShape
    widgets/                 # Todos os widgets (ver catálogo abaixo)
```

## Setup do tema (uma vez na inicialização do app)

```dart
// 1. Construir o TextTheme a partir do ColorScheme
final textTheme = TypographyBuilder.buildAppTextStyle(colorScheme).toTextTheme();

// 2. Montar o ThemeData usando AppThemeBase para os tokens
final lightTheme = ThemeData(
  colorScheme: myColorScheme,
  textTheme: textTheme,
  // usar tokens de AppThemeBase diretamente:
  // AppThemeBase.borderRadiusMD, AppThemeBase.buttonHeightMD, etc.
);

// 3. Registrar no singleton
AppThemeFactory.instance.currentLightTheme = lightTheme;
AppThemeFactory.instance.currentDarkTheme = darkTheme;

// 4. Usar no MaterialApp
theme: ThemeFactory.light(),
darkTheme: ThemeFactory.dark(),

// 5. Inicializar SizeConfig (necessário para responsividade)
// Dentro do primeiro build com contexto:
SizeConfig().init(context);  // base: 430×932px
```

## Tokens de design

### Espaçamento — `Spacing` (8pt grid)

| Constante | px base |
|---|---|
| `Spacing.xxxs` | 2 |
| `Spacing.xxs` | 4 |
| `Spacing.xs` | 8 |
| `Spacing.sm` | 16 |
| `Spacing.nm` | 20 |
| `Spacing.md` | 24 |
| `Spacing.lg` | 32 |
| `Spacing.xl` | 40 |
| `Spacing.xxl` | 48 |
| `Spacing.xxxl` | 56 |

```dart
Spacing.sm.width     // double responsivo (horizontalmente)
Spacing.md.height    // double responsivo (verticalmente)
Spacing.xs.vertical  // SizedBox(height: ...)
Spacing.sm.horizontal // SizedBox(width: ...)

// Utilidades de teclado:
Spacing.keyboardHeigth(context)
Spacing.keyboardIsOpened(context)
Spacing.orKeyboardPadding(context, defaultValue)
```

### Tipografia

```dart
// Tamanhos (todos responsive via .fontSize)
AppFontSize.labelSmall   // 10
AppFontSize.labelMedium  // 12
AppFontSize.labelLarge   // 14
AppFontSize.bodySmall    // 12
AppFontSize.bodyMedium   // 14
AppFontSize.bodyLarge    // 16
AppFontSize.titleSmall   // 14
AppFontSize.titleMedium  // 18
AppFontSize.titleLarge   // 22
AppFontSize.headlineSmall  // 24
AppFontSize.headlineMedium // 28
AppFontSize.headlineLarge  // 32
AppFontSize.value          // double responsivo

// Pesos
AppFontWeight.light      // w300
AppFontWeight.normal     // w400
AppFontWeight.medium     // w500
AppFontWeight.semiBold   // w600
AppFontWeight.bold       // w700 (FontWeight.bold)
AppFontWeight.value      // FontWeight

// Famílias: Poppins (primary/body), Inter (secondary/titles)
AppThemeBase.primaryFontFamily   // 'Poppins'
AppThemeBase.secodaryFontFamily  // 'Inter'
```

### Extensões de ThemeData (via import base_style_sheet)

```dart
theme.borderRadiusNone  // BorderRadius.zero
theme.borderRadiusXSM   // circular(4)
theme.borderRadiusSM    // circular(8)
theme.borderRadiusNM    // circular(12)
theme.borderRadiusMD    // circular(16)
theme.borderRadiusLG    // circular(24)
theme.borderRadiusXLG   // circular(32)

theme.shadowLightmodeLevel0  // blur 10, spread 0
theme.shadowLightmodeLevel1  // grey.shade200, blur 8
theme.shadowLightmodeLevel2  // blur 24, offset (0,8)
theme.shadowLightmodeLevel3  // blur 32, offset (0,16)
theme.shadowLightmodeLevel4  // blur 18, offset (0,16)
theme.shadowLightmodeLevel5  // blur 8, offset (2,0)

theme.opacityLevelSemiopaque      // 0.8
theme.opacityLevelIntense         // 0.64
theme.opacityLevelMedium          // 0.32
theme.opacityLevelLight           // 0.16
theme.opacityLevelSemiTransparent // 0.08

theme.borderWidthSM  // 1.5 responsivo
theme.borderWidthXS  // 1.0 responsivo
theme.borderNone     // Border.all(width:0, color:transparent)

// ElevatedButtonTheme extensions:
theme.elevatedButtonTheme.heightDefault // 38
theme.elevatedButtonTheme.heightSmall   // 32
theme.elevatedButtonTheme.heightMedium  // 48
theme.elevatedButtonTheme.heightLarge   // 56
```

### Responsividade

```dart
// extension Responsive on num (requer SizeConfig inicializado)
16.responsiveWidth   // escala relativa a 430px (largura de design)
24.responsiveHeight  // escala relativa a 932px (altura de design)
14.fontSize          // escala de fonte
```

### BuildContext extensions

```dart
context.theme        // ThemeData
context.textTheme    // TextTheme
context.colorScheme  // ColorScheme
context.isDarkMode   // bool
context.screenWidth  // double
context.screenHeight // double
context.mediaQuery   // MediaQueryData
context.kSize        // Size (via MediaQuery.sizeOf — sem rebuild no resize)
context.fractionallyScreenWidth(0.5)   // metade da largura
context.fractionallyScreenHeight(0.3)  // 30% da altura
```

## Catálogo de widgets

### Botões

```dart
// CustomButton — 5 factories:
CustomButton.text(text: 'Confirmar', onPressed: _confirmar, type: .primary)
CustomButton.icon(icon: Icons.add, onPressed: _adicionar)
CustomButton.child(child: MeuWidget(), onPressed: _acao)
CustomButton.iconText(icon: Icons.save, text: 'Salvar', onPressed: _salvar)
CustomButton.textIcon(text: 'Próximo', icon: Icons.arrow_forward, onPressed: _proximo)

// type: primary | secondary | tertiary | background | noShape
// heightType: medium(48) | normal(40) | small(32)
// isLoading: true → mostra CustomLoading, bloqueia tap
// isEnabled: false → opacity 0.5 + absorb pointer
// isSafe: true → achata border radius inferior (safe area)
```

### Inputs

```dart
CustomInputField(
  controller: _ctrl,
  inputLabel: InputLabel(label: 'E-mail'),  // widget acima do campo
  hint: 'nome@exemplo.com',
  validators: [(v) => v!.isEmpty ? 'Obrigatório' : null],
  onChanged: (v) => setState(() => _valor = v),
  heightType: .normal,
  fillColor: colorScheme.surface,
  keyboardType: TextInputType.emailAddress,
  textInputAction: TextInputAction.next,
  // + todos os params de TextFormField
)
```

### Bottom sheet

```dart
final fechou = await CustomBottomSheet.show(
  context,
  MeuConteudoWidget(),
  routeName: '/minha-rota',   // para navegação programática
  isDismissible: true,
  showDragHandle: true,
  showClose: true,
  closeMode: .outside,        // botão X acima do sheet
  padding: EdgeInsets.all(Spacing.md.height),
);
// Retorna Future<bool>; back gesture bloqueado por PopScope
```

### Dialog

```dart
CustomDialog.show(context, MeuConteudoWidget(), showClose: true);
CustomDialog.error(context, message: 'Algo deu errado', onPressed: _tentar);
```

### Alert

```dart
CustomAlert(
  title: 'Confirmar',
  subtitle: 'Tem certeza?',
  onConfirm: _confirmar,
  onCancel: _cancelar,
  btnConfirmLabel: 'Sim',
  btnCancelLabel: 'Não',
  buttonsDirection: .horizontal,  // ou .vertical
  confirmIsLoading: _carregando,
  // header: CustomAlert.iconHeader(context, Icons.warning, iconColor: Colors.red),
)
```

### Containers

```dart
CustomCard(
  child: MeuWidget(),
  onTap: _acao,
  borderRadius: theme.borderRadiusMD,
  shaddow: [theme.shadowLightmodeLevel1],
  isSelected: _selecionado,  // muda bg para colorScheme.primary
  isEnabled: true,
)

CustomShimmer(height: 48, width: double.infinity, borderRadius: theme.borderRadiusSM)
```

### AppBar

```dart
CustomAppBar(
  title: 'Título',
  actions: [IconButton(...)],
  onBackTap: () => Nav.to.pop(),
  progress: _progresso,         // 0.0–1.0 → LinearProgressIndicator
  enableShadow: true,
  toolbarHeight: AppThemeBase.appBarHeight,
)
CustomAppBar.zero(context)  // altura zero (só safe area)
```

### Estados de lista

```dart
// Erro com retry
CustomRequestError(
  message: failure.message,
  onPressed: _recarregar,
  btnLabel: 'Tentar novamente',
)

// Lista vazia
ListEmpty(
  message: 'Nenhum item encontrado',
  onPressed: _recarregar,
)
```

### Lista paginada

```dart
// Controller
final _listCtrl = PagedListController<MeuFailure, MeuItem>(
  pageSize: 20,
  initWithRequest: true,
  searchPercent: 80,  // fetch próxima página aos 80% do scroll
);

// Na inicialização:
_listCtrl.setListener((pageKey, pageSize) async {
  return await usecase.buscar(page: pageKey, size: pageSize);
});

// Widget
PagedListView<MeuFailure, MeuItem>(
  listController: _listCtrl,
  itemBuilder: (ctx, item, index) => MeuItemTile(item: item),
  separatorBuilder: (ctx, i) => CustomDivider(),
  allowRefresh: true,
  mode: .normal,  // ou .wrap para grid
)

// Busca
_listCtrl.search('termo');
_listCtrl.clearSearch();
_listCtrl.refresh();
```

### Loading

```dart
CustomLoading()                              // dois círculos orbitando
CustomLoading(type: .linear)                 // LinearProgressIndicator
CustomLoading(type: .linear, value: 0.6)     // determinado (60%)
CustomLoading(width: 24, height: 24)
```

### Imagem

```dart
CustomImage(url: 'https://...', fit: BoxFit.cover, borderRadius: theme.borderRadiusMD)
CustomImage(asset: 'assets/images/logo.png')
CustomImage(urlSvg: 'https://.../icon.svg', imageSize: Size(40, 40))
// enableGestures: true → toque abre CustomPhotoView fullscreen
```

### Snackbar / Toast

```dart
CustomSnackBar.snackShowMessage(context, 'Salvo com sucesso', type: .success);
CustomSnackBar.toastShowMessage(context, 'Erro ao carregar', type: .error, showClose: true);
// type: info | success | error
```

### Scroll

```dart
CustomScrollContent(
  child: MeuConteudo(),
  expanded: true,        // wrap em Expanded (preenche espaço disponível)
  padding: EdgeInsets.all(Spacing.md.height),
  onRefresh: _recarregar,
)
```

### Tiles

```dart
CustomItemTile(title: 'Configurações', icon: Icons.settings, onTap: _navegar)

CustomCheckboxTile(
  title: 'Aceito os termos',
  isSelected: _aceito,
  onChanged: (v) => setState(() => _aceito = v),
  controlAffinity: .leading,
)
```

## Adicionando um novo widget

1. Criar em `lib/src/presentation/widgets/<categoria>/meu_widget.dart`
2. Exportar em `lib/base_style_sheet.dart`
3. Usar tokens de `AppThemeBase` / `Spacing` / `AppFontSize` — nunca hardcodar valores

## Linting

```yaml
# Em qualquer package do ecossistema:
include: package:base_style_sheet/linter_rules.yaml
```
