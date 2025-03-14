import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

/// The [AppTheme] defines light and dark themes for the app.
///
/// Theme setup for FlexColorScheme package v8.
/// Use in [MaterialApp] like this:
///
/// MaterialApp(
///   theme: AppTheme.light,
///   darkTheme: AppTheme.dark,
/// );
abstract final class AppTheme {
  // The defined light theme.
  static ThemeData light = FlexThemeData.light(
    colors: lightColorScheme,
    subThemesData: const FlexSubThemesData(
      interactionEffects: true,
      tintedDisabledControls: true,
      useM2StyleDividerInM3: true,
      inputDecoratorIsFilled: true,
      inputDecoratorBorderType: FlexInputBorderType.outline,
      alignedDropdown: true,
      navigationRailUseIndicator: true,
      navigationRailLabelType: NavigationRailLabelType.all,
    ),
    visualDensity: FlexColorScheme.comfortablePlatformDensity,
    cupertinoOverrideTheme: const CupertinoThemeData(applyThemeToAll: true),
  );

  // The defined dark theme.
  static ThemeData dark = FlexThemeData.dark(
    colors: darkColorScheme,
    subThemesData: const FlexSubThemesData(
      interactionEffects: true,
      tintedDisabledControls: true,
      blendOnColors: true,
      useM2StyleDividerInM3: true,
      inputDecoratorIsFilled: true,
      inputDecoratorBorderType: FlexInputBorderType.outline,
      alignedDropdown: true,
      navigationRailUseIndicator: true,
      navigationRailLabelType: NavigationRailLabelType.all,
    ),
    visualDensity: FlexColorScheme.comfortablePlatformDensity,
    cupertinoOverrideTheme: const CupertinoThemeData(applyThemeToAll: true),
  );
}

/// Light [ColorScheme] for the app.
const FlexSchemeColor lightColorScheme = FlexSchemeColor(
  primary: Color(0xFF64558F),
  primaryContainer: Color(0xFFE8DDFF),
  secondary: Color(0xFF4A635F),
  secondaryContainer: Color(0xFFCCE8E2),
  tertiary: Color(0xFF386665),
  tertiaryContainer: Color(0xFFBBECEA),
  appBarColor: Color(0xFFC8DCF8),
  error: Color(0xFFBC1127),
);

/// Dark [ColorScheme] for the app.
const FlexSchemeColor darkColorScheme = FlexSchemeColor(
  primary: Color(0xFFCFBDFE),
  primaryContainer: Color(0xFF4C3E75),
  secondary: Color(0xFFB1CCC6),
  secondaryContainer: Color(0xFF334B47),
  tertiary: Color(0xFFA0CFCE),
  tertiaryContainer: Color(0xFF1E4E4D),
  appBarColor: Color(0xFF00102B),
  error: Color(0xFFFFB2BC),
);
