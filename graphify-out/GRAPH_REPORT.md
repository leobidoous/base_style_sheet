# Graph Report - base_style_sheet  (2026-10-26)

## Corpus Check
- 124 files · ~34,529 words
- Verdict: corpus is large enough that graph structure adds value.
- Unclassified: 60 file(s) not represented in the graph (top: (none) 13, .xcconfig 8, .xml 7)

## Summary
- 1967 nodes · 2598 edges · 118 communities (90 shown, 28 thin omitted)
- Extraction: 99% EXTRACTED · 1% INFERRED · 0% AMBIGUOUS · INFERRED: 17 edges (avg confidence: 0.85)
- Token cost: 0 input · 0 output

## Graph Freshness
- Built from commit: `453f1935`
- Run `git rev-parse HEAD` and compare to check if the graph is stale.
- Run `graphify update .` after code changes (no API cost).

## Community Hubs (Navigation)
- CHANGELOG.md
- custom_dropdown.dart
- custom_input_field.dart
- app_theme_factory.dart
- app_theme_base.dart
- custom_expansion.dart
- rating_bar.dart
- custom_pin_input.dart
- GeneratedPluginRegistrant.swift
- paged_table_view.dart
- paged_list_controller.dart
- custom_pdf_view.dart
- in_app_notification_banner.dart
- dashed_rect.dart
- dependencies
- rules
- custom_app_bar.dart
- my_application.cc
- custom_button.dart
- Catálogo de widgets
- custom_image.dart
- spacing.dart
- ../extensions/build_context_extensions.dart
- row_label_value.dart
- paged_list_view.dart
- State
- dropdown_hint_child.dart
- custom_alert.dart
- custom_web_view.dart
- dropdown_builder.dart
- rating_bar_indicator.dart
- Color?
- custom_scroll_content.dart
- paged_wrap_view.dart
- custom_loading.dart
- example/pubspec.yaml
- with
- custom_photo_view.dart
- win32_window.cpp
- typography_extension.dart
- column_label_value.dart
- animated_dot.dart
- image_url.dart
- custom_tooltip.dart
- FlutterWindow
- custom_refresh_indicator.dart
- size_config.dart
- tab_bar_item.dart
- custom_bottom_sheet.dart
- custom_dialog.dart
- custom_wrap.dart
- Win32Window
- custom_radio_tile.dart
- custom_card.dart
- inverse_border_shape.dart
- utils.cpp
- dashed_divider.dart
- ../../core/themes/spacing/spacing.dart
- package:flutter/material.dart
- dropdrown_list.dart
- list_empty.dart
- manifest.json
- custom_request_error.dart
- CustomDropdown Internal Search Integration
- custom_checkbox_tile.dart
- column_label_value_shimmer.dart
- image_error.dart
- row_label_value_shimmer.dart
- .MessageHandler
- StatelessWidget
- custom_shimmer.dart
- PagedListController Search Performance Improvements
- custom_masonry_wrap.dart
- base_style_sheet
- ../../core/themes/typography/typography_constants.dart
- double get
- EdgeInsets
- windows/flutter/generated_plugin_registrant.cc
- CustomDropdown sincroniza o valor recebido do pai
- typography_constants.dart
- typography_builder.dart
- Critical Bug Fixes
- theme_factory.dart
- Benefits
- Benefits
- analysis_options.yaml
- Point
- Implementation Details
- Architecture Impact
- Implementation Details
- Testing
- screen_size_type.dart
- MainActivity.kt
- example
- Architecture Impact
- List
- _CustomLoadingState
- AppBarThemeDataExtension
- .claude/CLAUDE.md
- _IndicatorClipper
- ElevatedButtonThemeDataExtension
- LaunchImage.imageset/README.md
- InputDecorationThemeExtension
- TextThemeExtension
- ThemeData
- ThemeModeExtension
- AppTextStyle
- CustomInputField
- RatingBar
- sonar.sh

## God Nodes (most connected - your core abstractions)
1. `Win32Window` - 21 edges
2. `_` - 19 edges
3. `dependencies` - 19 edges
4. `rules` - 18 edges
5. `Catálogo de widgets` - 15 edges
6. `CustomDropdown Internal Search Integration` - 11 edges
7. `PagedListController Search Performance Improvements` - 11 edges
8. `FlutterWindow` - 10 edges
9. `errors` - 8 edges
10. `WindowClassRegistrar` - 7 edges

## Surprising Connections (you probably didn't know these)
- `wWinMain()` --calls--> `CreateAndAttachConsole()`  [INFERRED]
  example/windows/runner/main.cpp → example/windows/runner/utils.cpp
- `my_application_activate()` --calls--> `fl_register_plugins()`  [INFERRED]
  example/linux/my_application.cc → example/linux/flutter/generated_plugin_registrant.cc
- `main()` --calls--> `my_application_new()`  [INFERRED]
  example/linux/main.cc → example/linux/my_application.cc
- `FlutterWindow` --inherits--> `Win32Window`  [EXTRACTED]
  example/windows/runner/flutter_window.h → example/windows/runner/win32_window.h
- `wWinMain()` --calls--> `GetCommandLineArguments()`  [INFERRED]
  example/windows/runner/main.cpp → example/windows/runner/utils.cpp

## Import Cycles
- None detected.

## Communities (118 total, 28 thin omitted)

### Community 0 - "CHANGELOG.md"
Cohesion: 0.02
Nodes (81): 1.0.0, 1.0.1, 1.0.10, 1.0.11, 1.0.12, 1.0.13, 1.0.14, 1.0.15 (+73 more)

### Community 1 - "custom_dropdown.dart"
Cohesion: 0.03
Nodes (64): _animationController, autovalidateMode, borderRadius, boxConstraints, _canForceValidator, childPadding, _closeDropdown, _container (+56 more)

### Community 3 - "custom_input_field.dart"
Cohesion: 0.04
Nodes (53): autocorrect, autofillHints, autofocus, autovalidateMode, _border, borderRadius, borderSide, build (+45 more)

### Community 4 - "app_theme_factory.dart"
Cohesion: 0.04
Nodes (46): appBarHeight, AppThemeFactory, borderNone, borderRadiusLG, borderRadiusMD, borderRadiusNM, borderRadiusNone, borderRadiusSM (+38 more)

### Community 5 - "app_theme_base.dart"
Cohesion: 0.04
Nodes (39): appBarHeight, AppThemeBase, borderRadiusLG, borderRadiusMD, borderRadiusNM, borderRadiusNone, borderRadiusSM, borderRadiusXLG (+31 more)

### Community 6 - "custom_expansion.dart"
Cohesion: 0.05
Nodes (35): BuildContextExt, colorScheme, fractionallyScreenHeight, fractionallyScreenWidth, isDarkMode, textTheme, theme, allowExpand (+27 more)

### Community 7 - "rating_bar.dart"
Cohesion: 0.05
Nodes (38): builder, _buildRating, child, build, createState, direction, initState, _isRTL (+30 more)

### Community 8 - "custom_pin_input.dart"
Cohesion: 0.05
Nodes (29): autofocus, autovalidateMode, boxConstraints, build, controller, createState, CustomPinField, _CustomPinFieldState (+21 more)

### Community 9 - "GeneratedPluginRegistrant.swift"
Cohesion: 0.06
Nodes (19): Cocoa, device_info_plus, AppDelegate, RunnerTests, RegisterGeneratedPlugins(), AppDelegate, MainFlutterWindow, RunnerTests (+11 more)

### Community 10 - "paged_table_view.dart"
Cohesion: 0.05
Nodes (34): DropdownHeightType, alignment, allowHorizontalScroll, allowRefresh, boxDecoration, build, clipBehavior, columns (+26 more)

### Community 11 - "paged_list_controller.dart"
Cohesion: 0.05
Nodes (35): clearError, clearSearch, config, dispose, _error, _executeSearch, fetchItemsPerPage, fetchNewItems (+27 more)

### Community 12 - "custom_pdf_view.dart"
Cohesion: 0.05
Nodes (27): CustomPdfViewMode, _, build, builder, custom, dark, inverted, light (+19 more)

### Community 13 - "in_app_notification_banner.dart"
Cohesion: 0.06
Nodes (25): filePath, FilePickerController, pickFile, pickFilePath, CustomSnackBar, SnackBarType, snackShowMessage, toastShowMessage (+17 more)

### Community 14 - "dashed_rect.dart"
Cohesion: 0.06
Nodes (31): CouponBorderPainter, paint, shouldRepaint, all, borderColor, borderRadius, bottomLeft, bottomRight (+23 more)

### Community 15 - "dependencies"
Cohesion: 0.06
Nodes (34): dependencies, auto_size_text, cached_network_image, cached_network_image_platform_interface, custom_refresh_indicator, file_picker, flutter, flutter_cache_manager (+26 more)

### Community 16 - "rules"
Cohesion: 0.06
Nodes (33): analyzer, errors, exclude, strong-mode, always_declare_return_types, dead_code, missing_required_param, missing_return (+25 more)

### Community 17 - "custom_app_bar.dart"
Cohesion: 0.06
Nodes (30): actions, _animationController, automaticallyImplyLeading, backgroundColor, build, centerTitle, createState, _currentHeight (+22 more)

### Community 18 - "my_application.cc"
Cohesion: 0.08
Nodes (13): fl_register_plugins(), main(), my_application_activate(), my_application_class_init(), my_application_dispose(), my_application_init(), my_application_local_command_line(), my_application_new() (+5 more)

### Community 19 - "custom_button.dart"
Cohesion: 0.07
Nodes (26): alignment, borderColor, borderRadius, build, ButtonHeightType, child, color, createState (+18 more)

### Community 20 - "Catálogo de widgets"
Cohesion: 0.07
Nodes (27): Adicionando um novo widget, Alert, AppBar, Bottom sheet, Botões, BuildContext extensions, Catálogo de widgets, Containers (+19 more)

### Community 21 - "custom_image.dart"
Cohesion: 0.07
Nodes (23): asset, backgroundColor, border, borderRadius, build, cacheKey, cacheManager, enableGestures (+15 more)

### Community 22 - "spacing.dart"
Cohesion: 0.08
Nodes (23): factor, height, horizontal, _kDefaultSpacingFactor, keyboardHeigth, keyboardIsOpened, lg, md (+15 more)

### Community 23 - "../extensions/build_context_extensions.dart"
Cohesion: 0.09
Nodes (18): BottomSheetDragIcon, build, build, CustomItemTile, icon, title, build, color (+10 more)

### Community 24 - "row_label_value.dart"
Cohesion: 0.08
Nodes (21): build, crossAxisAlignment, flexLabel, flexValue, isAllBold, isLabelBold, isValueBold, label (+13 more)

### Community 25 - "paged_list_view.dart"
Cohesion: 0.08
Nodes (22): allowRefresh, build, createState, dispose, _errorOrLoading, _fetchItemsAndScroll, initState, listController (+14 more)

### Community 26 - "State"
Cohesion: 0.12
Nodes (18): CustomBottomSheet, _CustomBottomSheetState, CustomAppBar, _CustomAppBarState, CustomDialog, _CustomDialogState, CustomDropdown, _CustomDropdownState (+10 more)

### Community 27 - "dropdown_hint_child.dart"
Cohesion: 0.09
Nodes (23): boxDecoration, build, canSearch, createState, didUpdateWidget, dispose, heightType, icon (+15 more)

### Community 28 - "custom_alert.dart"
Cohesion: 0.09
Nodes (21): btnCancelKey, btnCancelLabel, btnConfirmKey, btnConfirmLabel, build, buttons, buttonsDirection, cancelIsLoading (+13 more)

### Community 29 - "custom_web_view.dart"
Cohesion: 0.10
Nodes (14): _androidFilePicker, build, createState, CustomWebView, CustomWebViewState, _filePickerController, hasError, headers (+6 more)

### Community 30 - "dropdown_builder.dart"
Cohesion: 0.10
Nodes (21): boxDecoration, build, createState, _DropdownBuilder, heightType, hintChild, initState, isOnTop (+13 more)

### Community 31 - "rating_bar_indicator.dart"
Cohesion: 0.10
Nodes (21): build, createState, direction, initState, _isRTL, itemBuilder, itemCount, itemPadding (+13 more)

### Community 32 - "Color?"
Cohesion: 0.10
Nodes (15): AppBarButton, borderRadius, build, child, isEnabled, isLastButtom, isLoading, padding (+7 more)

### Community 33 - "custom_scroll_content.dart"
Cohesion: 0.10
Nodes (16): alwaysScrollable, build, child, clipBehavior, createState, CustomScrollContent, _CustomScrollContentState, dispose (+8 more)

### Community 34 - "paged_wrap_view.dart"
Cohesion: 0.10
Nodes (18): build, createState, dispose, _errorAndLoading, _fetchItemsAndScroll, initState, listController, _listItem (+10 more)

### Community 35 - "custom_loading.dart"
Cohesion: 0.10
Nodes (18): borderRadius, build, _circle, createState, dispose, duration, height, initState (+10 more)

### Community 36 - "example/pubspec.yaml"
Cohesion: 0.10
Nodes (19): path, dependencies, base_style_sheet, cupertino_icons, flutter, storybook_flutter, description, dev_dependencies (+11 more)

### Community 37 - "with"
Cohesion: 0.10
Nodes (19): runs-on, steps, jobs, checking-push, name, branches, branches, name (+11 more)

### Community 38 - "custom_photo_view.dart"
Cohesion: 0.11
Nodes (15): actions, animation, build, controller, createState, CustomPhotoView, _CustomPhotoViewState, dispose (+7 more)

### Community 39 - "win32_window.cpp"
Cohesion: 0.16
Nodes (6): EnableNonClientDpiScaling, Scale(), Win32Window::Win32Window(), WindowClassRegistrar, class_registered_, instance_

### Community 40 - "typography_extension.dart"
Cohesion: 0.11
Nodes (17): bodyLarge, bodyMedium, bodySmall, copyWith, displayLarge, displayMedium, displaySmall, headlineLarge (+9 more)

### Community 41 - "column_label_value.dart"
Cohesion: 0.11
Nodes (17): build, ColumnLabelValue, crossAxisAlignment, isAllBold, isLabelBold, isValueBold, label, labelStyle (+9 more)

### Community 42 - "animated_dot.dart"
Cohesion: 0.12
Nodes (15): AnimatedDot, _AnimatedDotState, build, controller, createState, currentState, didUpdateWidget, dispose (+7 more)

### Community 43 - "image_url.dart"
Cohesion: 0.11
Nodes (11): build, cacheKey, cacheManager, fit, headers, imageSize, maxHeightDiskCache, maxWidthDiskCache (+3 more)

### Community 44 - "custom_tooltip.dart"
Cohesion: 0.11
Nodes (13): border, boxShadow, build, child, color, globalKey, margin, message (+5 more)

### Community 45 - "FlutterWindow"
Cohesion: 0.12
Nodes (4): FlutterWindow, flutter_controller_, FlutterWindow::FlutterWindow(), project_

### Community 46 - "custom_refresh_indicator.dart"
Cohesion: 0.12
Nodes (13): _animation, _animationController, build, child, createState, CustomRefreshIndicator, _CustomRefreshIndicatorState, dispose (+5 more)

### Community 47 - "size_config.dart"
Cohesion: 0.12
Nodes (13): config, designScreenHeight, designScreenWidth, heightMultiplier, imageSizeMultiplier, init, isMobilePortrait, isPortrait (+5 more)

### Community 48 - "tab_bar_item.dart"
Cohesion: 0.13
Nodes (14): build, controller, createState, currentState, didUpdateWidget, dispose, duration, initState (+6 more)

### Community 49 - "custom_bottom_sheet.dart"
Cohesion: 0.12
Nodes (14): backgroundColor, build, child, closeMode, constraints, createState, CustomBottomSheetCloseMode, _decoration (+6 more)

### Community 50 - "custom_dialog.dart"
Cohesion: 0.12
Nodes (13): backgroundColor, build, child, closeMode, constraints, createState, CustomDialogCloseMode, _decoration (+5 more)

### Community 51 - "custom_wrap.dart"
Cohesion: 0.12
Nodes (12): alignment, build, crossAxisAlignment, CustomWrap, flexChilds, items, nCols, padding (+4 more)

### Community 52 - "Win32Window"
Cohesion: 0.16
Nodes (7): Size, height, width, Win32Window, child_content_, quit_on_close_, window_handle_

### Community 53 - "custom_radio_tile.dart"
Cohesion: 0.14
Nodes (11): build, controlAffinity, crossAxisAlignment, CustomRadioTile, isEnabled, isSelected, padding, _radioCheck (+3 more)

### Community 54 - "custom_card.dart"
Cohesion: 0.15
Nodes (10): border, borderRadius, build, child, color, constraints, isEnabled, isSelected (+2 more)

### Community 55 - "inverse_border_shape.dart"
Cohesion: 0.15
Nodes (10): _createBevels, _createPath, dimensions, getInnerPath, getOuterPath, InverseBorderShape, paint, pathWidth (+2 more)

### Community 56 - "utils.cpp"
Cohesion: 0.19
Nodes (4): wWinMain(), CreateAndAttachConsole(), GetCommandLineArguments(), Utf8FromUtf16()

### Community 57 - "dashed_divider.dart"
Cohesion: 0.17
Nodes (10): build, color, DashedDivider, direction, height, lineSize, paint, shouldRepaint (+2 more)

### Community 58 - "../../core/themes/spacing/spacing.dart"
Cohesion: 0.18
Nodes (6): BottomNavBarBlurContainer, build, child, padding, build, ExpansionShimmer

### Community 59 - "package:flutter/material.dart"
Cohesion: 0.17
Nodes (5): build, main, MyApp, main, main

### Community 60 - "dropdrown_list.dart"
Cohesion: 0.17
Nodes (11): build, heightType, items, itemSelectedStyle, itemStyle, listController, scrollController, valueSelected (+3 more)

### Community 61 - "list_empty.dart"
Cohesion: 0.18
Nodes (8): btnLabel, build, content, header, isSafeArea, ListEmpty, message, padding

### Community 63 - "manifest.json"
Cohesion: 0.18
Nodes (10): background_color, description, display, icons, name, orientation, prefer_related_applications, short_name (+2 more)

### Community 64 - "custom_request_error.dart"
Cohesion: 0.18
Nodes (9): ButtonType, btnLabel, btnType, build, CustomRequestError, isSafeArea, maxHeight, message (+1 more)

### Community 65 - "CustomDropdown Internal Search Integration"
Cohesion: 0.18
Nodes (9): CustomDropdown Internal Search Integration, Files Modified, Manual Testing Performed, Next Steps, Notes, Related Documentation, Summary, Test Scenarios (+1 more)

### Community 66 - "custom_checkbox_tile.dart"
Cohesion: 0.18
Nodes (9): _boxCheck, build, controlAffinity, CustomCheckboxTile, isSelected, padding, subtitle, textTitle (+1 more)

### Community 67 - "column_label_value_shimmer.dart"
Cohesion: 0.22
Nodes (8): build, ColumnLabelValueShimmer, _ColumnLabelValueShimmerState, createState, crossAxisAlignment, nLabelLines, nValueLines, _random

### Community 68 - "image_error.dart"
Cohesion: 0.22
Nodes (6): build, _buildErrorDialog, createState, error, ImageError, _ImageErrorState

### Community 69 - "row_label_value_shimmer.dart"
Cohesion: 0.22
Nodes (7): build, createState, factor1, factor2, _random, RowLabelValueShimmer, _RowLabelValueShimmerState

### Community 71 - "StatelessWidget"
Cohesion: 0.20
Nodes (9): CustomAlert, _EmptyChild, CustomCard, DashedRect, CustomTooltip, CustomImage, ImageUrl, RowLabelValue (+1 more)

### Community 72 - "custom_shimmer.dart"
Cohesion: 0.22
Nodes (5): borderRadius, build, CustomShimmer, height, width

### Community 73 - "PagedListController Search Performance Improvements"
Cohesion: 0.22
Nodes (9): Controllers, Example Usage, Files Deleted, Files Modified, Next Steps, Notes, PagedListController Search Performance Improvements, Related Documentation (+1 more)

### Community 74 - "custom_masonry_wrap.dart"
Cohesion: 0.22
Nodes (7): build, CustomMasonryWrap, items, nCols, padding, runSpacing, spacing

### Community 75 - "base_style_sheet"
Cohesion: 0.22
Nodes (8): base_style_sheet, 👉 Como Usar, 👉 Contribuição, Exemplo Básico de Uso, 👉 Instalação, 👉 Licença, 👉 Recursos, Uso com `ThemeData` no Flutter

### Community 76 - "../../core/themes/typography/typography_constants.dart"
Cohesion: 0.25
Nodes (6): build, color, hasError, InputLabel, isRequired, label

### Community 77 - "double get"
Cohesion: 0.25
Nodes (4): fontSize, Responsive, responsiveHeight, responsiveWidth

### Community 78 - "EdgeInsets"
Cohesion: 0.25
Nodes (5): build, createState, padding, tabs, tabSelected

### Community 80 - "CustomDropdown sincroniza o valor recebido do pai"
Cohesion: 0.25
Nodes (7): Architecture Impact, CustomDropdown sincroniza o valor recebido do pai, Files Created, Files Deleted, Files Modified, Summary, Testing

### Community 81 - "typography_constants.dart"
Cohesion: 0.29
Nodes (4): AppFontSize, AppFontWeight, AppLineHeight, value

### Community 83 - "Critical Bug Fixes"
Cohesion: 0.33
Nodes (6): Critical Bug Fixes, Issue 1: Requests During Dispose, Issue 2: Accessing Disposed Controller in onClear, Root Cause, Solution, Why This Works

### Community 84 - "theme_factory.dart"
Cohesion: 0.40
Nodes (3): dark, light, ThemeFactory

### Community 85 - "Benefits"
Cohesion: 0.40
Nodes (5): Benefits, Bug Fixes, Code Simplification, Developer Experience, Maintainability

### Community 86 - "Benefits"
Cohesion: 0.40
Nodes (5): Benefits, Developer Experience, Maintainability, Performance, User Experience

### Community 87 - "analysis_options.yaml"
Cohesion: 0.50
Nodes (3): analyzer, exclude, include

### Community 88 - "Point"
Cohesion: 0.50
Nodes (3): Point, x, y

### Community 89 - "Implementation Details"
Cohesion: 0.50
Nodes (4): After (Internal Search Management), Before (External Search Management), Implementation Details, Internal Logic (CustomDropdown)

### Community 90 - "Architecture Impact"
Cohesion: 0.50
Nodes (4): Architecture Impact, Breaking Changes, Key Architectural Decisions, Problems Solved

### Community 91 - "Implementation Details"
Cohesion: 0.50
Nodes (4): Implementation Details, Internal Implementation, New API, Usage Pattern

### Community 92 - "Testing"
Cohesion: 0.50
Nodes (4): Manual Testing Steps, Metrics, Performance Improvements, Testing

### Community 93 - "screen_size_type.dart"
Cohesion: 0.67
Nodes (3): getScreenSizeType, ScreenSizeType, ScreenSizeTypeExt

### Community 96 - "Architecture Impact"
Cohesion: 0.67
Nodes (3): Architecture Impact, Benefits, Presentation Layer

## Knowledge Gaps
- **987 isolated node(s):** `main`, `build`, `parent_instance`, `dart_entrypoint_arguments`, `Foundation` (+982 more)
  These have ≤1 connection - possible missing edges or undocumented components. (Counts symbols only; 1530 node(s) total have ≤1 connection when file, concept and rationale nodes are included.)
- **28 thin communities (<3 nodes) omitted from report** — run `graphify query` to explore isolated nodes.

## Suggested Questions
_Questions this graph is uniquely positioned to answer:_

- **Why does `Win32Window` connect `Win32Window` to `.MessageHandler`, `win32_window.cpp`, `FlutterWindow`, `Point`, `string`?**
  _High betweenness centrality (0.035) - this node is a cross-community bridge._
- **What connects `main`, `build`, `parent_instance` to the rest of the system?**
  _987 weakly-connected nodes found - possible documentation gaps or missing edges._
- **Should `CHANGELOG.md` be split into smaller, more focused modules?**
  _Cohesion score 0.024390243902439025 - nodes in this community are weakly interconnected._
- **Why does `wWinMain()` connect `utils.cpp` to `string`?**
  _High betweenness centrality (0.009) - this node is a cross-community bridge._
- **Should `custom_dropdown.dart` be split into smaller, more focused modules?**
  _Cohesion score 0.028169014084507043 - nodes in this community are weakly interconnected._
- **Should `base_style_sheet.dart` be split into smaller, more focused modules?**
  _Cohesion score 0.030303030303030304 - nodes in this community are weakly interconnected._
- **Should `custom_input_field.dart` be split into smaller, more focused modules?**
  _Cohesion score 0.03508771929824561 - nodes in this community are weakly interconnected._