// Copyright 2015 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'dart:ui' show Color, hashList;

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:neumorphic/src/params.dart';

export 'package:flutter/services.dart' show Brightness;

// Deriving these values is black magic. The spec claims that pressed buttons
// have a highlight of 0x66999999, but that's clearly wrong. The videos in the
// spec show that buttons have a composited highlight of #E1E1E1 on a background
// of #FAFAFA. Assuming that the highlight really has an opacity of 0x66, we can
// solve for the actual color of the highlight:
const Color _kLightThemeHighlightColor = Color(0x66BCBCBC);

// The same video shows the splash compositing to #D7D7D7 on a background of
// #E1E1E1. Again, assuming the splash has an opacity of 0x66, we can solve for
// the actual color of the splash:
const Color _kLightThemeSplashColor = Color(0x66C8C8C8);

// Unfortunately, a similar video isn't available for the dark theme, which
// means we assume the values in the spec are actually correct.
const Color _kDarkThemeHighlightColor = Color(0x40CCCCCC);
const Color _kDarkThemeSplashColor = Color(0x40CCCCCC);

/// Configures the tap target and layout size of certain Nuemorphic widgets.
///
/// Changing the value in [NeuThemeData.materialTapTargetSize] will affect the
/// accessibility experience.
///
/// Some of the impacted widgets include:
///
///   * [FloatingActionButton], only the mini tap target size is increased.
///   * [MaterialButton]
///   * [OutlineButton]
///   * [FlatButton]
///   * [RaisedButton]
///   * [TimePicker]
///   * [SnackBar]
///   * [Chip]
///   * [RawChip]
///   * [InputChip]
///   * [ChoiceChip]
///   * [FilterChip]
///   * [ActionChip]
///   * [Radio]
///   * [Switch]
///   * [Checkbox]

/// Holds the color and typography values for a material design theme.
///
/// Use this class to configure a [Theme] or [MaterialApp] widget.
///
/// To obtain the current theme, use [Theme.of].
///
/// {@tool sample}
///
/// This sample creates a [Theme] widget that stores the `ThemeData`. The
/// `ThemeData` can be accessed by descendant Widgets that use the correct
/// `context`. This example uses the [Builder] widget to gain access to a
/// descendant `context` that contains the `ThemeData`.
///
/// The [Container] widget uses [Theme.of] to retrieve the [primaryColor] from
/// the `ThemeData` to draw an amber square.
///
/// ![](https://flutter.github.io/assets-for-api-docs/assets/material/theme_data.png)
///
/// ```dart
/// Theme(
///   data: ThemeData(primaryColor: Colors.amber),
///   child: Builder(
///     builder: (BuildContext context) {
///       return Container(
///         width: 100,
///         height: 100,
///         color: Theme.of(context).primaryColor,
///       );
///     },
///   ),
/// )
/// ```
/// {@end-tool}
///
/// In addition to using the [Theme] widget, you can provide `ThemeData` to a
/// [MaterialApp]. The `ThemeData` will be used throughout the app to style
/// material design widgets.
///
/// {@tool sample}
///
/// This sample creates a [MaterialApp] widget that stores `ThemeData` and
/// passes the `ThemeData` to descendant widgets. The [AppBar] widget uses the
/// [primaryColor] to create a blue background. The [Text] widget uses the
/// [TextTheme.body1] to create purple text. The [FloatingActionButton] widget
/// uses the [accentColor] to create a green background.
///
/// ![](https://flutter.github.io/assets-for-api-docs/assets/material/material_app_theme_data.png)
///
/// ```dart
/// MaterialApp(
///   theme: ThemeData(
///     primaryColor: Colors.blue,
///     accentColor: Colors.green,
///     textTheme: TextTheme(body1: TextStyle(color: Colors.purple)),
///   ),
///   home: Scaffold(
///     appBar: AppBar(
///       title: const Text('ThemeData Demo'),
///     ),
///     floatingActionButton: FloatingActionButton(
///       child: const Icon(Icons.add),
///       onPressed: () {},
///     ),
///     body: Center(
///       child: Text(
///         'Button pressed 0 times',
///       ),
///     ),
///   ),
/// )
/// ```
/// {@end-tool}
// TODO(predatorx7): Change NeuThemeData to work more like MaterialBasedCupertinoThemeData to use less space
// TODO(Serge): add Diagnosticable
// Flutter > 1.13 `with Diagnosticable`
// FLutter <= 1.13 `extends Diagnosticable`
@immutable
class NeuThemeData {
  /// Create a [NeuThemeData] given a set of preferred values.
  ///
  /// You can access the theme using [NeuTheme.of(context)] which will be used by both
  /// properties for both Material & Neumorphic widgets or [Theme.of(context)] which
  /// has properties only used by Material widgets.
  ///
  /// Default values will be derived for arguments that are omitted.
  ///
  /// The most useful values to give are, in order of importance:
  ///
  ///  * The desired surface type with [curveType].
  ///
  ///  * [lightSource] to be simulated on [curveType].
  ///    (under development, not all Neumorphic widgets supports this.)
  ///
  ///  * The desired theme [brightness].
  ///
  ///  * The primary color palette (the [primarySwatch]), chosen from
  ///    one of the swatches defined by the material design spec. This
  ///    should be one of the maps from the [Colors] class that do not
  ///    have "accent" in their name.
  ///
  ///  * The [accentColor], sometimes called the secondary color, and,
  ///    if the accent color is specified, its brightness
  ///    ([accentColorBrightness]), so that the right contrasting text
  ///    color will be used over the accent color.
  ///
  /// Most of these parameters map to the [NeuThemeData] field with the same name,
  /// all of which are described in more detail on the fields themselves. The
  /// exceptions are:
  ///
  ///  * [primarySwatch] - used to configure default values for several fields,
  ///    including: [primaryColor], [primaryColorBrightness], [primaryColorLight],
  ///    [primaryColorDark], [toggleableActiveColor], [accentColor], [colorScheme],
  ///    [secondaryHeaderColor], [textSelectionColor], [backgroundColor], and
  ///    [buttonColor].
  ///
  ///  * [fontFamily] - sets the default fontFamily for any
  ///    [TextStyle.fontFamily] that isn't set directly in the [textTheme],
  ///    [primaryTextTheme], or [accentTextTheme].
  ///
  /// See <https://material.io/design/color/> for
  /// more discussion on how to pick the right colors.
  factory NeuThemeData({
    Brightness brightness,
    MaterialColor primarySwatch,
    Color primaryColor,
    Brightness primaryColorBrightness,
    Color primaryColorLight,
    Color primaryColorDark,
    Color accentColor,
    Brightness accentColorBrightness,
    Color canvasColor,
    Color scaffoldBackgroundColor,
    Color bottomAppBarColor,
    Color cardColor,
    Color dividerColor,
    Color focusColor,
    Color hoverColor,
    Color highlightColor,
    Color splashColor,
    InteractiveInkFeatureFactory splashFactory,
    Color selectedRowColor,
    Color unselectedWidgetColor,
    Color disabledColor,
    Color buttonColor,
    ButtonThemeData buttonTheme,
    ToggleButtonsThemeData toggleButtonsTheme,
    Color secondaryHeaderColor,
    Color textSelectionColor,
    Color cursorColor,
    Color textSelectionHandleColor,
    Color backgroundColor,
    Color dialogBackgroundColor,
    Color indicatorColor,
    Color hintColor,
    Color errorColor,
    Color toggleableActiveColor,
    String fontFamily,
    TextTheme textTheme,
    TextTheme primaryTextTheme,
    TextTheme accentTextTheme,
    InputDecorationTheme inputDecorationTheme,
    IconThemeData iconTheme,
    IconThemeData primaryIconTheme,
    IconThemeData accentIconTheme,
    SliderThemeData sliderTheme,
    TabBarTheme tabBarTheme,
    TooltipThemeData tooltipTheme,
    CardTheme cardTheme,
    ChipThemeData chipTheme,
    TargetPlatform platform,
    MaterialTapTargetSize materialTapTargetSize,
    bool applyElevationOverlayColor,
    PageTransitionsTheme pageTransitionsTheme,
    AppBarTheme appBarTheme,
    BottomAppBarTheme bottomAppBarTheme,
    ColorScheme colorScheme,
    DialogTheme dialogTheme,
    FloatingActionButtonThemeData floatingActionButtonTheme,
    Typography typography,
    CupertinoThemeData cupertinoOverrideTheme,
    SnackBarThemeData snackBarTheme,
    BottomSheetThemeData bottomSheetTheme,
    PopupMenuThemeData popupMenuTheme,
    MaterialBannerThemeData bannerTheme,
    DividerThemeData dividerTheme,
    ButtonBarThemeData buttonBarTheme,
    LightSource lightSource,
    CurveType curveType,
    TextSelectionControls selectionControls,
  }) {
    lightSource ??= LightSource.topLeft;
    curveType ??= CurveType.concave;
    brightness ??= Brightness.light;
    final bool isDark = brightness == Brightness.dark;
    primarySwatch ??= Colors.blue;
    primaryColor ??= isDark ? Colors.grey[900] : primarySwatch;
    primaryColorBrightness ??= estimateBrightnessForColor(primaryColor);
    primaryColorLight ??= isDark ? Colors.grey[500] : primarySwatch[100];
    primaryColorDark ??= isDark ? Colors.black : primarySwatch[700];
    final bool primaryIsDark = primaryColorBrightness == Brightness.dark;
    toggleableActiveColor ??=
        isDark ? Colors.tealAccent[200] : (accentColor ?? primarySwatch[600]);
    accentColor ??= isDark ? Colors.tealAccent[200] : primarySwatch[500];
    accentColorBrightness ??= estimateBrightnessForColor(accentColor);
    final bool accentIsDark = accentColorBrightness == Brightness.dark;
    canvasColor ??= isDark ? Colors.grey[850] : Colors.grey[50];
    scaffoldBackgroundColor ??= canvasColor;
    bottomAppBarColor ??= isDark ? Colors.grey[800] : Colors.white;
    cardColor ??= isDark ? Colors.grey[800] : Colors.white;
    dividerColor ??= isDark ? const Color(0x1FFFFFFF) : const Color(0x1F000000);

    // Create a ColorScheme that is backwards compatible as possible
    // with the existing default ThemeData color values.
    colorScheme ??= ColorScheme.fromSwatch(
      primarySwatch: primarySwatch,
      primaryColorDark: primaryColorDark,
      accentColor: accentColor,
      cardColor: cardColor,
      backgroundColor: backgroundColor,
      errorColor: errorColor,
      brightness: brightness,
    );

    // For agressive fast ripples
    splashFactory ??= InkRipple.splashFactory;
    selectedRowColor ??= Colors.grey[100];
    unselectedWidgetColor ??= isDark ? Colors.white70 : Colors.black54;
    // Spec doesn't specify a dark theme secondaryHeaderColor, this is a guess.
    secondaryHeaderColor ??= isDark ? Colors.grey[700] : primarySwatch[50];
    textSelectionColor ??= isDark ? accentColor : primarySwatch[200];
    // TODO(sandrasandeep): change to color provided by Material Design team
    cursorColor = cursorColor ?? const Color.fromRGBO(66, 133, 244, 1.0);
    textSelectionHandleColor ??=
        isDark ? Colors.tealAccent[400] : primarySwatch[300];
    backgroundColor ??= isDark ? Colors.grey[700] : primarySwatch[200];
    dialogBackgroundColor ??= isDark ? Colors.grey[800] : Colors.white;
    indicatorColor ??= accentColor == primaryColor ? Colors.white : accentColor;
    hintColor ??= isDark ? const Color(0x80FFFFFF) : const Color(0x8A000000);
    errorColor ??= Colors.red[700];
    inputDecorationTheme ??= const InputDecorationTheme();
    pageTransitionsTheme ??= const PageTransitionsTheme();
    primaryIconTheme ??= primaryIsDark
        ? const IconThemeData(color: Colors.white)
        : const IconThemeData(color: Colors.black);
    accentIconTheme ??= accentIsDark
        ? const IconThemeData(color: Colors.white)
        : const IconThemeData(color: Colors.black);
    iconTheme ??= isDark
        ? const IconThemeData(color: Colors.white)
        : const IconThemeData(color: Colors.black87);
    platform ??= defaultTargetPlatform;
    typography ??= Typography(platform: platform);
    TextTheme defaultTextTheme = isDark ? typography.white : typography.black;
    TextTheme defaultPrimaryTextTheme =
        primaryIsDark ? typography.white : typography.black;
    TextTheme defaultAccentTextTheme =
        accentIsDark ? typography.white : typography.black;
    if (fontFamily != null) {
      defaultTextTheme = defaultTextTheme.apply(fontFamily: fontFamily);
      defaultPrimaryTextTheme =
          defaultPrimaryTextTheme.apply(fontFamily: fontFamily);
      defaultAccentTextTheme =
          defaultAccentTextTheme.apply(fontFamily: fontFamily);
    }
    textTheme = defaultTextTheme.merge(textTheme);
    primaryTextTheme = defaultPrimaryTextTheme.merge(primaryTextTheme);
    accentTextTheme = defaultAccentTextTheme.merge(accentTextTheme);
    materialTapTargetSize ??= MaterialTapTargetSize.padded;
    applyElevationOverlayColor ??= false;

    // Used as the default color (fill color) for RaisedButtons. Computing the
    // default for ButtonThemeData for the sake of backwards compatibility.
    buttonColor ??= isDark ? primarySwatch[600] : Colors.grey[300];
    focusColor ??= isDark
        ? Colors.white.withOpacity(0.12)
        : Colors.black.withOpacity(0.12);
    hoverColor ??= isDark
        ? Colors.white.withOpacity(0.04)
        : Colors.black.withOpacity(0.04);
    buttonTheme ??= ButtonThemeData(
      colorScheme: colorScheme,
      buttonColor: buttonColor,
      disabledColor: disabledColor,
      focusColor: focusColor,
      hoverColor: hoverColor,
      highlightColor: highlightColor,
      splashColor: splashColor,
      materialTapTargetSize: materialTapTargetSize,
    );
    toggleButtonsTheme ??= const ToggleButtonsThemeData();
    disabledColor ??= isDark ? Colors.white38 : Colors.black38;
    highlightColor ??=
        isDark ? _kDarkThemeHighlightColor : _kLightThemeHighlightColor;
    splashColor ??= isDark ? _kDarkThemeSplashColor : _kLightThemeSplashColor;

    sliderTheme ??= const SliderThemeData();
    tabBarTheme ??= const TabBarTheme();
    tooltipTheme ??= const TooltipThemeData();
    appBarTheme ??= const AppBarTheme();
    bottomAppBarTheme ??= const BottomAppBarTheme();
    cardTheme ??= const CardTheme();
    chipTheme ??= ChipThemeData.fromDefaults(
      secondaryColor: primaryColor,
      brightness: brightness,
      labelStyle: textTheme.body2,
    );
    dialogTheme ??= const DialogTheme();
    floatingActionButtonTheme ??= const FloatingActionButtonThemeData();
    cupertinoOverrideTheme = cupertinoOverrideTheme?.noDefault();
    snackBarTheme ??= const SnackBarThemeData();
    bottomSheetTheme ??= const BottomSheetThemeData();
    popupMenuTheme ??= const PopupMenuThemeData();
    bannerTheme ??= const MaterialBannerThemeData();
    dividerTheme ??= const DividerThemeData();
    buttonBarTheme ??= const ButtonBarThemeData();

    return NeuThemeData.raw(
      curveType: curveType,
      lightSource: lightSource,
      brightness: brightness,
      primaryColor: primaryColor,
      primaryColorBrightness: primaryColorBrightness,
      primaryColorLight: primaryColorLight,
      primaryColorDark: primaryColorDark,
      accentColor: accentColor,
      accentColorBrightness: accentColorBrightness,
      canvasColor: canvasColor,
      scaffoldBackgroundColor: scaffoldBackgroundColor,
      bottomAppBarColor: bottomAppBarColor,
      cardColor: cardColor,
      dividerColor: dividerColor,
      focusColor: focusColor,
      hoverColor: hoverColor,
      highlightColor: highlightColor,
      splashColor: splashColor,
      splashFactory: splashFactory,
      selectedRowColor: selectedRowColor,
      unselectedWidgetColor: unselectedWidgetColor,
      disabledColor: disabledColor,
      buttonTheme: buttonTheme,
      buttonColor: buttonColor,
      toggleButtonsTheme: toggleButtonsTheme,
      toggleableActiveColor: toggleableActiveColor,
      secondaryHeaderColor: secondaryHeaderColor,
      textSelectionColor: textSelectionColor,
      cursorColor: cursorColor,
      textSelectionHandleColor: textSelectionHandleColor,
      backgroundColor: backgroundColor,
      dialogBackgroundColor: dialogBackgroundColor,
      indicatorColor: indicatorColor,
      hintColor: hintColor,
      errorColor: errorColor,
      textTheme: textTheme,
      primaryTextTheme: primaryTextTheme,
      accentTextTheme: accentTextTheme,
      inputDecorationTheme: inputDecorationTheme,
      iconTheme: iconTheme,
      primaryIconTheme: primaryIconTheme,
      accentIconTheme: accentIconTheme,
      sliderTheme: sliderTheme,
      tabBarTheme: tabBarTheme,
      tooltipTheme: tooltipTheme,
      cardTheme: cardTheme,
      chipTheme: chipTheme,
      platform: platform,
      materialTapTargetSize: materialTapTargetSize,
      applyElevationOverlayColor: applyElevationOverlayColor,
      pageTransitionsTheme: pageTransitionsTheme,
      appBarTheme: appBarTheme,
      bottomAppBarTheme: bottomAppBarTheme,
      colorScheme: colorScheme,
      dialogTheme: dialogTheme,
      floatingActionButtonTheme: floatingActionButtonTheme,
      typography: typography,
      cupertinoOverrideTheme: cupertinoOverrideTheme,
      snackBarTheme: snackBarTheme,
      bottomSheetTheme: bottomSheetTheme,
      popupMenuTheme: popupMenuTheme,
      bannerTheme: bannerTheme,
      dividerTheme: dividerTheme,
      buttonBarTheme: buttonBarTheme,
      selectionControls: selectionControls,
    );
  }

  /// Create a [NeuThemeData] given a set of exact values. All the values must be
  /// specified. They all must also be non-null except for
  /// [cupertinoOverrideTheme].
  ///
  /// This will rarely be used directly. It is used by [lerp] to
  /// create intermediate themes based on two themes created with the
  /// [new ThemeData] constructor.
  const NeuThemeData.raw({
    // Warning: make sure these properties are in the exact same order as in
    // operator == and in the hashValues method and in the order of fields
    // in this class, and in the lerp() method.
    @required this.selectionControls,
    @required this.curveType,
    @required this.lightSource,
    @required this.brightness,
    @required this.primaryColor,
    @required this.primaryColorBrightness,
    @required this.primaryColorLight,
    @required this.primaryColorDark,
    @required this.canvasColor,
    @required this.accentColor,
    @required this.accentColorBrightness,
    @required this.scaffoldBackgroundColor,
    @required this.bottomAppBarColor,
    @required this.cardColor,
    @required this.dividerColor,
    @required this.focusColor,
    @required this.hoverColor,
    @required this.highlightColor,
    @required this.splashColor,
    @required this.splashFactory,
    @required this.selectedRowColor,
    @required this.unselectedWidgetColor,
    @required this.disabledColor,
    @required this.buttonTheme,
    @required this.buttonColor,
    @required this.toggleButtonsTheme,
    @required this.secondaryHeaderColor,
    @required this.textSelectionColor,
    @required this.cursorColor,
    @required this.textSelectionHandleColor,
    @required this.backgroundColor,
    @required this.dialogBackgroundColor,
    @required this.indicatorColor,
    @required this.hintColor,
    @required this.errorColor,
    @required this.toggleableActiveColor,
    @required this.textTheme,
    @required this.primaryTextTheme,
    @required this.accentTextTheme,
    @required this.inputDecorationTheme,
    @required this.iconTheme,
    @required this.primaryIconTheme,
    @required this.accentIconTheme,
    @required this.sliderTheme,
    @required this.tabBarTheme,
    @required this.tooltipTheme,
    @required this.cardTheme,
    @required this.chipTheme,
    @required this.platform,
    @required this.materialTapTargetSize,
    @required this.applyElevationOverlayColor,
    @required this.pageTransitionsTheme,
    @required this.appBarTheme,
    @required this.bottomAppBarTheme,
    @required this.colorScheme,
    @required this.dialogTheme,
    @required this.floatingActionButtonTheme,
    @required this.typography,
    @required this.cupertinoOverrideTheme,
    @required this.snackBarTheme,
    @required this.bottomSheetTheme,
    @required this.popupMenuTheme,
    @required this.bannerTheme,
    @required this.dividerTheme,
    @required this.buttonBarTheme,
  })  : assert(curveType != null),
        assert(lightSource != null),
        assert(brightness != null),
        assert(primaryColor != null),
        assert(primaryColorBrightness != null),
        assert(primaryColorLight != null),
        assert(primaryColorDark != null),
        assert(accentColor != null),
        assert(accentColorBrightness != null),
        assert(canvasColor != null),
        assert(scaffoldBackgroundColor != null),
        assert(bottomAppBarColor != null),
        assert(cardColor != null),
        assert(dividerColor != null),
        assert(focusColor != null),
        assert(hoverColor != null),
        assert(highlightColor != null),
        assert(splashColor != null),
        assert(splashFactory != null),
        assert(selectedRowColor != null),
        assert(unselectedWidgetColor != null),
        assert(disabledColor != null),
        assert(toggleableActiveColor != null),
        assert(buttonTheme != null),
        assert(toggleButtonsTheme != null),
        assert(secondaryHeaderColor != null),
        assert(textSelectionColor != null),
        assert(cursorColor != null),
        assert(textSelectionHandleColor != null),
        assert(backgroundColor != null),
        assert(dialogBackgroundColor != null),
        assert(indicatorColor != null),
        assert(hintColor != null),
        assert(errorColor != null),
        assert(textTheme != null),
        assert(primaryTextTheme != null),
        assert(accentTextTheme != null),
        assert(inputDecorationTheme != null),
        assert(iconTheme != null),
        assert(primaryIconTheme != null),
        assert(accentIconTheme != null),
        assert(sliderTheme != null),
        assert(tabBarTheme != null),
        assert(tooltipTheme != null),
        assert(cardTheme != null),
        assert(chipTheme != null),
        assert(platform != null),
        assert(materialTapTargetSize != null),
        assert(pageTransitionsTheme != null),
        assert(appBarTheme != null),
        assert(bottomAppBarTheme != null),
        assert(colorScheme != null),
        assert(dialogTheme != null),
        assert(floatingActionButtonTheme != null),
        assert(typography != null),
        assert(snackBarTheme != null),
        assert(bottomSheetTheme != null),
        assert(popupMenuTheme != null),
        assert(bannerTheme != null),
        assert(dividerTheme != null),
        assert(buttonBarTheme != null);

  /// Create a [NeuThemeData] based on the colors in the given [colorScheme] and
  /// text styles of the optional [textTheme].
  ///
  /// The [colorScheme] can not be null.
  ///
  /// If [colorScheme.brightness] is [Brightness.dark] then
  /// [NeuThemeData.applyElevationOverlayColor] will be set to true to support
  /// the Material dark theme method for indicating elevation by applying
  /// a semi-transparent onSurface color on top of the surface color.
  ///
  /// This is the recommended method to theme your application. As we move
  /// forward we will be converting all the widget implementations to only use
  /// colors or colors derived from those in [ColorScheme].
  ///
  /// {@tool sample}
  /// This example will set up an application to use the baseline Material
  /// Design light and dark themes.
  ///
  /// ```dart
  /// MaterialApp(
  ///   theme: ThemeData.from(colorScheme: ColorScheme.light()),
  ///   darkTheme: ThemeData.from(colorScheme: ColorScheme.dark()),
  /// )
  /// ```
  /// {@end-tool}
  ///
  /// See <https://material.io/design/color/> for
  /// more discussion on how to pick the right colors.
  factory NeuThemeData.from({
    @required ColorScheme colorScheme,
    TextTheme textTheme,
  }) {
    assert(colorScheme != null);

    final bool isDark = colorScheme.brightness == Brightness.dark;

    // For surfaces that use primary color in light themes and surface color in dark
    final Color primarySurfaceColor =
        isDark ? colorScheme.surface : colorScheme.primary;
    final Color onPrimarySurfaceColor =
        isDark ? colorScheme.onSurface : colorScheme.onPrimary;

    return NeuThemeData(
      curveType: CurveType.concave,
      lightSource: LightSource.topLeft,
      brightness: colorScheme.brightness,
      primaryColor: primarySurfaceColor,
      primaryColorBrightness:
          NeuThemeData.estimateBrightnessForColor(primarySurfaceColor),
      canvasColor: colorScheme.background,
      accentColor: colorScheme.secondary,
      accentColorBrightness:
          NeuThemeData.estimateBrightnessForColor(colorScheme.secondary),
      scaffoldBackgroundColor: colorScheme.background,
      bottomAppBarColor: colorScheme.surface,
      cardColor: colorScheme.surface,
      dividerColor: colorScheme.onSurface.withOpacity(0.12),
      backgroundColor: colorScheme.background,
      dialogBackgroundColor: colorScheme.background,
      errorColor: colorScheme.error,
      textTheme: textTheme,
      indicatorColor: onPrimarySurfaceColor,
      applyElevationOverlayColor: isDark,
      colorScheme: colorScheme,
    );
  }

  /// A default light blue theme.
  ///
  /// This theme does not contain text geometry. Instead, it is expected that
  /// this theme is localized using text geometry using [NeuThemeData.localize].
  factory NeuThemeData.light() => NeuThemeData(brightness: Brightness.light);

  /// A default dark theme with a teal accent color.
  ///
  /// This theme does not contain text geometry. Instead, it is expected that
  /// this theme is localized using text geometry using [NeuThemeData.localize].
  factory NeuThemeData.dark() => NeuThemeData(brightness: Brightness.dark);

  /// The default color theme. Same as [new NeuThemeData.light].
  ///
  /// This is used by [Theme.of] when no theme has been specified.
  ///
  /// This theme does not contain text geometry. Instead, it is expected that
  /// this theme is localized using text geometry using [NeuThemeData.localize].
  ///
  /// Most applications would use [Theme.of], which provides correct localized
  /// text geometry.
  factory NeuThemeData.fallback() => NeuThemeData.light();

  // Warning: make sure these properties are in the exact same order as in
  // hashValues() and in the raw constructor and in the order of fields in
  // the class and in the lerp() method.

  /// The brightness of the overall theme of the application. Used by widgets
  /// like buttons to determine what color to pick when not using the primary or
  /// accent color.
  ///
  /// When the [Brightness] is dark, the canvas, card, and primary colors are
  /// all dark. When the [Brightness] is light, the canvas and card colors
  /// are bright, and the primary color's darkness varies as described by
  /// primaryColorBrightness. The primaryColor does not contrast well with the
  /// card and canvas colors when the brightness is dark; when the brightness is
  /// dark, use Colors.white or the accentColor for a contrasting color.
  final Brightness brightness;

  /// A Selection UI, to be provided by the implementor of the toolbar widget.
  // TODO(predator): add
  final TextSelectionControls selectionControls;

  /// The [CurveType] of [Neumorphic] material.
  /// Can be [concave], [convex], [emboss] or [flat].
  final CurveType curveType;

  /// The [LightSource] direction to be simulated on [Neumorphic] material.
  final LightSource lightSource;

  /// The background color for major parts of the app (toolbars, tab bars, etc)
  ///
  /// The theme's [colorScheme] property contains [ColorScheme.primary], as
  /// well as a color that contrasts well with the primary color called
  /// [ColorScheme.onPrimary]. It might be simpler to just configure an app's
  /// visuals in terms of the theme's [colorScheme].
  final Color primaryColor;

  /// The brightness of the [primaryColor]. Used to determine the color of text and
  /// icons placed on top of the primary color (e.g. toolbar text).
  final Brightness primaryColorBrightness;

  /// A lighter version of the [primaryColor].
  final Color primaryColorLight;

  /// A darker version of the [primaryColor].
  final Color primaryColorDark;

  /// The default color of [MaterialType.canvas] [Material].
  final Color canvasColor;

  /// The foreground color for widgets (knobs, text, overscroll edge effect, etc).
  ///
  /// Accent color is also known as the secondary color.
  ///
  /// The theme's [colorScheme] property contains [ColorScheme.secondary], as
  /// well as a color that contrasts well with the secondary color called
  /// [ColorScheme.onSecondary]. It might be simpler to just configure an app's
  /// visuals in terms of the theme's [colorScheme].
  final Color accentColor;

  /// The brightness of the [accentColor]. Used to determine the color of text
  /// and icons placed on top of the accent color (e.g. the icons on a floating
  /// action button).
  final Brightness accentColorBrightness;

  /// The default color of the [Material] that underlies the [Scaffold]. The
  /// background color for a typical material app or a page within the app.
  final Color scaffoldBackgroundColor;

  /// The default color of the [BottomAppBar].
  ///
  /// This can be overridden by specifying [BottomAppBar.color].
  final Color bottomAppBarColor;

  /// The color of [Material] when it is used as a [Card].
  final Color cardColor;

  /// The color of [Divider]s and [PopupMenuDivider]s, also used
  /// between [ListTile]s, between rows in [DataTable]s, and so forth.
  ///
  /// To create an appropriate [BorderSide] that uses this color, consider
  /// [Divider.createBorderSide].
  final Color dividerColor;

  /// The focus color used indicate that a component has the input focus.
  final Color focusColor;

  /// The hover color used to indicate when a pointer is hovering over a
  /// component.
  final Color hoverColor;

  /// The highlight color used during ink splash animations or to
  /// indicate an item in a menu is selected.
  final Color highlightColor;

  /// The color of ink splashes. See [InkWell].
  final Color splashColor;

  /// Defines the appearance of ink splashes produces by [InkWell]
  /// and [InkResponse].
  ///
  /// See also:
  ///
  ///  * [InkSplash.splashFactory], which defines the default splash.
  ///  * [InkRipple.splashFactory], which defines a splash that spreads out
  ///    more aggressively than the default.
  final InteractiveInkFeatureFactory splashFactory;

  /// The color used to highlight selected rows.
  final Color selectedRowColor;

  /// The color used for widgets in their inactive (but enabled)
  /// state. For example, an unchecked checkbox. Usually contrasted
  /// with the [accentColor]. See also [disabledColor].
  final Color unselectedWidgetColor;

  /// The color used for widgets that are inoperative, regardless of
  /// their state. For example, a disabled checkbox (which may be
  /// checked or unchecked).
  final Color disabledColor;

  /// Defines the default configuration of button widgets, like [RaisedButton]
  /// and [FlatButton].
  final ButtonThemeData buttonTheme;

  /// Defines the default configuration of [ToggleButtons] widgets.
  final ToggleButtonsThemeData toggleButtonsTheme;

  /// The default fill color of the [Material] used in [RaisedButton]s.
  final Color buttonColor;

  /// The color of the header of a [PaginatedDataTable] when there are selected rows.
  // According to the spec for data tables:
  // https://material.io/archive/guidelines/components/data-tables.html#data-tables-tables-within-cards
  // ...this should be the "50-value of secondary app color".
  final Color secondaryHeaderColor;

  /// The color of text selections in text fields, such as [TextField].
  final Color textSelectionColor;

  /// The color of cursors in Material-style text fields, such as [TextField].
  final Color cursorColor;

  /// The color of the handles used to adjust what part of the text is currently selected.
  final Color textSelectionHandleColor;

  /// A color that contrasts with the [primaryColor], e.g. used as the
  /// remaining part of a progress bar.
  final Color backgroundColor;

  /// The background color of [Dialog] elements.
  final Color dialogBackgroundColor;

  /// The color of the selected tab indicator in a tab bar.
  final Color indicatorColor;

  /// The color to use for hint text or placeholder text, e.g. in
  /// [TextField] fields.
  final Color hintColor;

  /// The color to use for input validation errors, e.g. in [TextField] fields.
  final Color errorColor;

  /// The color used to highlight the active states of toggleable widgets like
  /// [Switch], [Radio], and [Checkbox].
  final Color toggleableActiveColor;

  /// Text with a color that contrasts with the card and canvas colors.
  final TextTheme textTheme;

  /// A text theme that contrasts with the primary color.
  final TextTheme primaryTextTheme;

  /// A text theme that contrasts with the accent color.
  final TextTheme accentTextTheme;

  /// The default [InputDecoration] values for [InputDecorator], [TextField],
  /// and [TextFormField] are based on this theme.
  ///
  /// See [InputDecoration.applyDefaults].
  final InputDecorationTheme inputDecorationTheme;

  /// An icon theme that contrasts with the card and canvas colors.
  final IconThemeData iconTheme;

  /// An icon theme that contrasts with the primary color.
  final IconThemeData primaryIconTheme;

  /// An icon theme that contrasts with the accent color.
  final IconThemeData accentIconTheme;

  /// The colors and shapes used to render [Slider].
  ///
  /// This is the value returned from [SliderTheme.of].
  final SliderThemeData sliderTheme;

  /// A theme for customizing the size, shape, and color of the tab bar indicator.
  final TabBarTheme tabBarTheme;

  /// A theme for customizing the visual properties of [Tooltip]s.
  ///
  /// This is the value returned from [TooltipTheme.of].
  final TooltipThemeData tooltipTheme;

  /// The colors and styles used to render [Card].
  ///
  /// This is the value returned from [CardTheme.of].
  final CardTheme cardTheme;

  /// The colors and styles used to render [Chip]s.
  ///
  /// This is the value returned from [ChipTheme.of].
  final ChipThemeData chipTheme;

  /// The platform the material widgets should adapt to target.
  ///
  /// Defaults to the current platform, as exposed by [defaultTargetPlatform].
  /// This should be used in order to style UI elements according to platform
  /// conventions.
  ///
  /// Widgets from the material library should use this getter (via [Theme.of])
  /// to determine the current platform for the purpose of emulating the
  /// platform behavior (e.g. scrolling or haptic effects). Widgets and render
  /// objects at lower layers that try to emulate the underlying platform
  /// platform can depend on [defaultTargetPlatform] directly, or may require
  /// that the target platform be provided as an argument. The
  /// [dart.io.Platform] object should only be used directly when it's critical
  /// to actually know the current platform, without any overrides possible (for
  /// example, when a system API is about to be called).
  ///
  /// In a test environment, the platform returned is [TargetPlatform.android]
  /// regardless of the host platform. (Android was chosen because the tests
  /// were originally written assuming Android-like behavior, and we added
  /// platform adaptations for iOS later). Tests can check iOS behavior by
  /// setting the [platform] of the [Theme] explicitly to [TargetPlatform.iOS],
  /// or by setting [debugDefaultTargetPlatformOverride].
  final TargetPlatform platform;

  /// Configures the hit test size of certain Material widgets.
  final MaterialTapTargetSize materialTapTargetSize;

  /// Apply a semi-transparent overlay color on Material surfaces to indicate
  /// elevation for dark themes.
  ///
  /// Material drop shadows can be difficult to see in a dark theme, so the
  /// elevation of a surface should be portrayed with an "overlay" in addition
  /// to the shadow. As the elevation of the component increases, the
  /// overlay increases in opacity. [applyElevationOverlayColor] turns the
  /// application of this overlay on or off.
  ///
  /// If [true] a semi-transparent version of [colorScheme.onSurface] will be
  /// applied on top of the color of [Material] widgets when their [Material.color]
  /// is [colorScheme.surface]. The level of transparency is based on
  /// [Material.elevation] as per the Material Dark theme specification.
  ///
  /// If [false] the surface color will be used unmodified.
  ///
  /// Defaults to [false].
  ///
  /// Note: this setting is here to maintain backwards compatibility with
  /// apps that were built before the Material Dark theme specification
  /// was published. New apps should set this to [true] for any themes
  /// where [brightness] is [Brightness.dark].
  ///
  /// See also:
  ///
  ///  * [Material.elevation], which effects how transparent the white overlay is.
  ///  * [Material.color], the white color overlay will only be applied of the
  ///    material's color is [colorScheme.surface].
  ///  * <https://material.io/design/color/dark-theme.html>, which specifies how
  ///    the overlay should be applied.
  final bool applyElevationOverlayColor;

  /// Default [MaterialPageRoute] transitions per [TargetPlatform].
  ///
  /// [MaterialPageRoute.buildTransitions] delegates to a [PageTransitionsBuilder]
  /// whose [PageTransitionsBuilder.platform] matches [platform]. If a matching
  /// builder is not found, a builder whose platform is null is used.
  final PageTransitionsTheme pageTransitionsTheme;

  /// A theme for customizing the color, elevation, brightness, iconTheme and
  /// textTheme of [AppBar]s.
  final AppBarTheme appBarTheme;

  /// A theme for customizing the shape, elevation, and color of a [BottomAppBar].
  final BottomAppBarTheme bottomAppBarTheme;

  /// A set of thirteen colors that can be used to configure the
  /// color properties of most components.
  ///
  /// This property was added much later than the theme's set of highly
  /// specific colors, like [cardColor], [buttonColor], [canvasColor] etc.
  /// New components can be defined exclusively in terms of [colorScheme].
  /// Existing components will gradually migrate to it, to the extent
  /// that is possible without significant backwards compatibility breaks.
  final ColorScheme colorScheme;

  /// A theme for customizing colors, shape, elevation, and behavior of a [SnackBar].
  final SnackBarThemeData snackBarTheme;

  /// A theme for customizing the shape of a dialog.
  final DialogTheme dialogTheme;

  /// A theme for customizing the shape, elevation, and color of a
  /// [FloatingActionButton].
  final FloatingActionButtonThemeData floatingActionButtonTheme;

  /// The color and geometry [TextTheme] values used to configure [textTheme],
  /// [primaryTextTheme], and [accentTextTheme].
  final Typography typography;

  /// Components of the [CupertinoThemeData] to override from the Material
  /// [NeuThemeData] adaptation.
  ///
  /// By default, [cupertinoOverrideTheme] is null and Cupertino widgets
  /// descendant to the Material [Theme] will adhere to a [CupertinoTheme]
  /// derived from the Material [NeuThemeData]. e.g. [NeuThemeData]'s [ColorTheme]
  /// will also inform the [CupertinoThemeData]'s `primaryColor` etc.
  ///
  /// This cascading effect for individual attributes of the [CupertinoThemeData]
  /// can be overridden using attributes of this [cupertinoOverrideTheme].
  final CupertinoThemeData cupertinoOverrideTheme;

  /// A theme for customizing the color, elevation, and shape of a bottom sheet.
  final BottomSheetThemeData bottomSheetTheme;

  /// A theme for customizing the color, shape, elevation, and text style of
  /// popup menus.
  final PopupMenuThemeData popupMenuTheme;

  /// A theme for customizing the color and text style of a [MaterialBanner].
  final MaterialBannerThemeData bannerTheme;

  /// A theme for customizing the color, thickness, and indents of [Divider]s,
  /// [VerticalDivider]s, etc.
  final DividerThemeData dividerTheme;

  /// A theme for customizing the appearance and layout of [ButtonBar] widgets.
  final ButtonBarThemeData buttonBarTheme;

  /// Creates a copy of this theme but with the given fields replaced with the new values.
  NeuThemeData copyWith({
    Brightness brightness,
    Color primaryColor,
    Brightness primaryColorBrightness,
    Color primaryColorLight,
    Color primaryColorDark,
    Color accentColor,
    Brightness accentColorBrightness,
    Color canvasColor,
    Color scaffoldBackgroundColor,
    Color bottomAppBarColor,
    Color cardColor,
    Color dividerColor,
    Color focusColor,
    Color hoverColor,
    Color highlightColor,
    Color splashColor,
    InteractiveInkFeatureFactory splashFactory,
    Color selectedRowColor,
    Color unselectedWidgetColor,
    Color disabledColor,
    ButtonThemeData buttonTheme,
    ToggleButtonsThemeData toggleButtonsTheme,
    Color buttonColor,
    Color secondaryHeaderColor,
    Color textSelectionColor,
    Color cursorColor,
    Color textSelectionHandleColor,
    Color backgroundColor,
    Color dialogBackgroundColor,
    Color indicatorColor,
    Color hintColor,
    Color errorColor,
    Color toggleableActiveColor,
    TextTheme textTheme,
    TextTheme primaryTextTheme,
    TextTheme accentTextTheme,
    InputDecorationTheme inputDecorationTheme,
    IconThemeData iconTheme,
    IconThemeData primaryIconTheme,
    IconThemeData accentIconTheme,
    SliderThemeData sliderTheme,
    TabBarTheme tabBarTheme,
    TooltipThemeData tooltipTheme,
    CardTheme cardTheme,
    ChipThemeData chipTheme,
    TargetPlatform platform,
    MaterialTapTargetSize materialTapTargetSize,
    bool applyElevationOverlayColor,
    PageTransitionsTheme pageTransitionsTheme,
    AppBarTheme appBarTheme,
    BottomAppBarTheme bottomAppBarTheme,
    ColorScheme colorScheme,
    DialogTheme dialogTheme,
    FloatingActionButtonThemeData floatingActionButtonTheme,
    Typography typography,
    CupertinoThemeData cupertinoOverrideTheme,
    SnackBarThemeData snackBarTheme,
    BottomSheetThemeData bottomSheetTheme,
    PopupMenuThemeData popupMenuTheme,
    MaterialBannerThemeData bannerTheme,
    DividerThemeData dividerTheme,
    ButtonBarThemeData buttonBarTheme,
    CurveType curveType,
    LightSource lightSource,
    TextSelectionControls selectionControls,
  }) {
    cupertinoOverrideTheme = cupertinoOverrideTheme?.noDefault();
    return NeuThemeData.raw(
      curveType: curveType ?? this.curveType,
      lightSource: lightSource ?? this.lightSource,
      brightness: brightness ?? this.brightness,
      primaryColor: primaryColor ?? this.primaryColor,
      primaryColorBrightness:
          primaryColorBrightness ?? this.primaryColorBrightness,
      primaryColorLight: primaryColorLight ?? this.primaryColorLight,
      primaryColorDark: primaryColorDark ?? this.primaryColorDark,
      accentColor: accentColor ?? this.accentColor,
      accentColorBrightness:
          accentColorBrightness ?? this.accentColorBrightness,
      canvasColor: canvasColor ?? this.canvasColor,
      scaffoldBackgroundColor:
          scaffoldBackgroundColor ?? this.scaffoldBackgroundColor,
      bottomAppBarColor: bottomAppBarColor ?? this.bottomAppBarColor,
      cardColor: cardColor ?? this.cardColor,
      dividerColor: dividerColor ?? this.dividerColor,
      focusColor: focusColor ?? this.focusColor,
      hoverColor: hoverColor ?? this.hoverColor,
      highlightColor: highlightColor ?? this.highlightColor,
      splashColor: splashColor ?? this.splashColor,
      splashFactory: splashFactory ?? this.splashFactory,
      selectedRowColor: selectedRowColor ?? this.selectedRowColor,
      unselectedWidgetColor:
          unselectedWidgetColor ?? this.unselectedWidgetColor,
      disabledColor: disabledColor ?? this.disabledColor,
      buttonColor: buttonColor ?? this.buttonColor,
      buttonTheme: buttonTheme ?? this.buttonTheme,
      toggleButtonsTheme: toggleButtonsTheme ?? this.toggleButtonsTheme,
      secondaryHeaderColor: secondaryHeaderColor ?? this.secondaryHeaderColor,
      textSelectionColor: textSelectionColor ?? this.textSelectionColor,
      cursorColor: cursorColor ?? this.cursorColor,
      textSelectionHandleColor:
          textSelectionHandleColor ?? this.textSelectionHandleColor,
      backgroundColor: backgroundColor ?? this.backgroundColor,
      dialogBackgroundColor:
          dialogBackgroundColor ?? this.dialogBackgroundColor,
      indicatorColor: indicatorColor ?? this.indicatorColor,
      hintColor: hintColor ?? this.hintColor,
      errorColor: errorColor ?? this.errorColor,
      toggleableActiveColor:
          toggleableActiveColor ?? this.toggleableActiveColor,
      textTheme: textTheme ?? this.textTheme,
      primaryTextTheme: primaryTextTheme ?? this.primaryTextTheme,
      accentTextTheme: accentTextTheme ?? this.accentTextTheme,
      inputDecorationTheme: inputDecorationTheme ?? this.inputDecorationTheme,
      iconTheme: iconTheme ?? this.iconTheme,
      primaryIconTheme: primaryIconTheme ?? this.primaryIconTheme,
      accentIconTheme: accentIconTheme ?? this.accentIconTheme,
      sliderTheme: sliderTheme ?? this.sliderTheme,
      tabBarTheme: tabBarTheme ?? this.tabBarTheme,
      tooltipTheme: tooltipTheme ?? this.tooltipTheme,
      cardTheme: cardTheme ?? this.cardTheme,
      chipTheme: chipTheme ?? this.chipTheme,
      platform: platform ?? this.platform,
      materialTapTargetSize:
          materialTapTargetSize ?? this.materialTapTargetSize,
      applyElevationOverlayColor:
          applyElevationOverlayColor ?? this.applyElevationOverlayColor,
      pageTransitionsTheme: pageTransitionsTheme ?? this.pageTransitionsTheme,
      appBarTheme: appBarTheme ?? this.appBarTheme,
      bottomAppBarTheme: bottomAppBarTheme ?? this.bottomAppBarTheme,
      colorScheme: colorScheme ?? this.colorScheme,
      dialogTheme: dialogTheme ?? this.dialogTheme,
      floatingActionButtonTheme:
          floatingActionButtonTheme ?? this.floatingActionButtonTheme,
      typography: typography ?? this.typography,
      cupertinoOverrideTheme:
          cupertinoOverrideTheme ?? this.cupertinoOverrideTheme,
      snackBarTheme: snackBarTheme ?? this.snackBarTheme,
      bottomSheetTheme: bottomSheetTheme ?? this.bottomSheetTheme,
      popupMenuTheme: popupMenuTheme ?? this.popupMenuTheme,
      bannerTheme: bannerTheme ?? this.bannerTheme,
      dividerTheme: dividerTheme ?? this.dividerTheme,
      buttonBarTheme: buttonBarTheme ?? this.buttonBarTheme,
      selectionControls: selectionControls ?? this.selectionControls,
    );
  }

  // The number 5 was chosen without any real science or research behind it. It
  // just seemed like a number that's not too big (we should be able to fit 5
  // copies of ThemeData in memory comfortably) and not too small (most apps
  // shouldn't have more than 5 theme/localization pairs).
  static const int _localizedThemeDataCacheSize = 5;

  /// Caches localized themes to speed up the [localize] method.
  static final _FifoCache<_IdentityThemeDataCacheKey, NeuThemeData>
      _localizedThemeDataCache =
      _FifoCache<_IdentityThemeDataCacheKey, NeuThemeData>(
          _localizedThemeDataCacheSize);

  /// Returns a new theme built by merging the text geometry provided by the
  /// [localTextGeometry] theme with the [baseTheme].
  ///
  /// For those text styles in the [baseTheme] whose [TextStyle.inherit] is set
  /// to true, the returned theme's text styles inherit the geometric properties
  /// of [localTextGeometry]. The resulting text styles' [TextStyle.inherit] is
  /// set to those provided by [localTextGeometry].
  static NeuThemeData localize(
      NeuThemeData baseTheme, TextTheme localTextGeometry) {
    // WARNING: this method memoizes the result in a cache based on the
    // previously seen baseTheme and localTextGeometry. Memoization is safe
    // because all inputs and outputs of this function are deeply immutable, and
    // the computations are referentially transparent. It only short-circuits
    // the computation if the new inputs are identical() to the previous ones.
    // It does not use the == operator, which performs a costly deep comparison.
    //
    // When changing this method, make sure the memoization logic is correct.
    // Remember:
    //
    // There are only two hard things in Computer Science: cache invalidation
    // and naming things. -- Phil Karlton
    assert(baseTheme != null);
    assert(localTextGeometry != null);

    return _localizedThemeDataCache.putIfAbsent(
      _IdentityThemeDataCacheKey(baseTheme, localTextGeometry),
      () {
        return baseTheme.copyWith(
          primaryTextTheme: localTextGeometry.merge(baseTheme.primaryTextTheme),
          accentTextTheme: localTextGeometry.merge(baseTheme.accentTextTheme),
          textTheme: localTextGeometry.merge(baseTheme.textTheme),
        );
      },
    );
  }

  /// Determines whether the given [Color] is [Brightness.light] or
  /// [Brightness.dark].
  ///
  /// This compares the luminosity of the given color to a threshold value that
  /// matches the material design specification.
  static Brightness estimateBrightnessForColor(Color color) {
    final double relativeLuminance = color.computeLuminance();

    // See <https://www.w3.org/TR/WCAG20/#contrast-ratiodef>
    // The spec says to use kThreshold=0.0525, but Material Design appears to bias
    // more towards using light text than WCAG20 recommends. Material Design spec
    // doesn't say what value to use, but 0.15 seemed close to what the Material
    // Design spec shows for its color palette on
    // <https://material.io/go/design-theming#color-color-palette>.
    const double kThreshold = 0.15;
    if ((relativeLuminance + 0.05) * (relativeLuminance + 0.05) > kThreshold)
      return Brightness.light;
    return Brightness.dark;
  }

  /// Mix with this theme with other theme.
  /// Performs Linear interpolation with this theme & ThemeData.
  NeuThemeData mix(NeuThemeData other, double t) => lerp(this, other, t);

  /// Linearly interpolate between two themes.
  ///
  /// The arguments must not be null.
  ///
  /// {@macro dart.ui.shadow.lerp}
  static NeuThemeData lerp(NeuThemeData a, NeuThemeData b, double t) {
    assert(a != null);
    assert(b != null);
    assert(t != null);
    // Warning: make sure these properties are in the exact same order as in
    // hashValues() and in the raw constructor and in the order of fields in
    // the class and in the lerp() method.
    return NeuThemeData.raw(
      curveType: t < 0.5 ? a.curveType : b.curveType,
      selectionControls: t < 0.5 ? a.selectionControls : b.selectionControls,
      lightSource: t < 0.5 ? a.lightSource : b.lightSource,
      brightness: t < 0.5 ? a.brightness : b.brightness,
      primaryColor: Color.lerp(a.primaryColor, b.primaryColor, t),
      primaryColorBrightness:
          t < 0.5 ? a.primaryColorBrightness : b.primaryColorBrightness,
      primaryColorLight:
          Color.lerp(a.primaryColorLight, b.primaryColorLight, t),
      primaryColorDark: Color.lerp(a.primaryColorDark, b.primaryColorDark, t),
      canvasColor: Color.lerp(a.canvasColor, b.canvasColor, t),
      accentColor: Color.lerp(a.accentColor, b.accentColor, t),
      accentColorBrightness:
          t < 0.5 ? a.accentColorBrightness : b.accentColorBrightness,
      scaffoldBackgroundColor:
          Color.lerp(a.scaffoldBackgroundColor, b.scaffoldBackgroundColor, t),
      bottomAppBarColor:
          Color.lerp(a.bottomAppBarColor, b.bottomAppBarColor, t),
      cardColor: Color.lerp(a.cardColor, b.cardColor, t),
      dividerColor: Color.lerp(a.dividerColor, b.dividerColor, t),
      focusColor: Color.lerp(a.focusColor, b.focusColor, t),
      hoverColor: Color.lerp(a.hoverColor, b.hoverColor, t),
      highlightColor: Color.lerp(a.highlightColor, b.highlightColor, t),
      splashColor: Color.lerp(a.splashColor, b.splashColor, t),
      splashFactory: t < 0.5 ? a.splashFactory : b.splashFactory,
      selectedRowColor: Color.lerp(a.selectedRowColor, b.selectedRowColor, t),
      unselectedWidgetColor:
          Color.lerp(a.unselectedWidgetColor, b.unselectedWidgetColor, t),
      disabledColor: Color.lerp(a.disabledColor, b.disabledColor, t),
      buttonTheme: t < 0.5 ? a.buttonTheme : b.buttonTheme,
      toggleButtonsTheme: ToggleButtonsThemeData.lerp(
          a.toggleButtonsTheme, b.toggleButtonsTheme, t),
      buttonColor: Color.lerp(a.buttonColor, b.buttonColor, t),
      secondaryHeaderColor:
          Color.lerp(a.secondaryHeaderColor, b.secondaryHeaderColor, t),
      textSelectionColor:
          Color.lerp(a.textSelectionColor, b.textSelectionColor, t),
      cursorColor: Color.lerp(a.cursorColor, b.cursorColor, t),
      textSelectionHandleColor:
          Color.lerp(a.textSelectionHandleColor, b.textSelectionHandleColor, t),
      backgroundColor: Color.lerp(a.backgroundColor, b.backgroundColor, t),
      dialogBackgroundColor:
          Color.lerp(a.dialogBackgroundColor, b.dialogBackgroundColor, t),
      indicatorColor: Color.lerp(a.indicatorColor, b.indicatorColor, t),
      hintColor: Color.lerp(a.hintColor, b.hintColor, t),
      errorColor: Color.lerp(a.errorColor, b.errorColor, t),
      toggleableActiveColor:
          Color.lerp(a.toggleableActiveColor, b.toggleableActiveColor, t),
      textTheme: TextTheme.lerp(a.textTheme, b.textTheme, t),
      primaryTextTheme:
          TextTheme.lerp(a.primaryTextTheme, b.primaryTextTheme, t),
      accentTextTheme: TextTheme.lerp(a.accentTextTheme, b.accentTextTheme, t),
      inputDecorationTheme:
          t < 0.5 ? a.inputDecorationTheme : b.inputDecorationTheme,
      iconTheme: IconThemeData.lerp(a.iconTheme, b.iconTheme, t),
      primaryIconTheme:
          IconThemeData.lerp(a.primaryIconTheme, b.primaryIconTheme, t),
      accentIconTheme:
          IconThemeData.lerp(a.accentIconTheme, b.accentIconTheme, t),
      sliderTheme: SliderThemeData.lerp(a.sliderTheme, b.sliderTheme, t),
      tabBarTheme: TabBarTheme.lerp(a.tabBarTheme, b.tabBarTheme, t),
      tooltipTheme: TooltipThemeData.lerp(a.tooltipTheme, b.tooltipTheme, t),
      cardTheme: CardTheme.lerp(a.cardTheme, b.cardTheme, t),
      chipTheme: ChipThemeData.lerp(a.chipTheme, b.chipTheme, t),
      platform: t < 0.5 ? a.platform : b.platform,
      materialTapTargetSize:
          t < 0.5 ? a.materialTapTargetSize : b.materialTapTargetSize,
      applyElevationOverlayColor:
          t < 0.5 ? a.applyElevationOverlayColor : b.applyElevationOverlayColor,
      pageTransitionsTheme:
          t < 0.5 ? a.pageTransitionsTheme : b.pageTransitionsTheme,
      appBarTheme: AppBarTheme.lerp(a.appBarTheme, b.appBarTheme, t),
      bottomAppBarTheme:
          BottomAppBarTheme.lerp(a.bottomAppBarTheme, b.bottomAppBarTheme, t),
      colorScheme: ColorScheme.lerp(a.colorScheme, b.colorScheme, t),
      dialogTheme: DialogTheme.lerp(a.dialogTheme, b.dialogTheme, t),
      floatingActionButtonTheme: FloatingActionButtonThemeData.lerp(
          a.floatingActionButtonTheme, b.floatingActionButtonTheme, t),
      typography: Typography.lerp(a.typography, b.typography, t),
      cupertinoOverrideTheme:
          t < 0.5 ? a.cupertinoOverrideTheme : b.cupertinoOverrideTheme,
      snackBarTheme:
          SnackBarThemeData.lerp(a.snackBarTheme, b.snackBarTheme, t),
      bottomSheetTheme:
          BottomSheetThemeData.lerp(a.bottomSheetTheme, b.bottomSheetTheme, t),
      popupMenuTheme:
          PopupMenuThemeData.lerp(a.popupMenuTheme, b.popupMenuTheme, t),
      bannerTheme:
          MaterialBannerThemeData.lerp(a.bannerTheme, b.bannerTheme, t),
      dividerTheme: DividerThemeData.lerp(a.dividerTheme, b.dividerTheme, t),
      buttonBarTheme:
          ButtonBarThemeData.lerp(a.buttonBarTheme, b.buttonBarTheme, t),
    );
  }

  /// Returns a [ThemeData] from properties & fields of this [NeuThemeData]
  NeuThemeData get themeData => NeuThemeData.raw(
        curveType: curveType,
        lightSource: lightSource,
        brightness: brightness,
        primaryColor: primaryColor,
        primaryColorBrightness: primaryColorBrightness,
        primaryColorLight: primaryColorLight,
        primaryColorDark: primaryColorDark,
        accentColor: accentColor,
        accentColorBrightness: accentColorBrightness,
        canvasColor: canvasColor,
        scaffoldBackgroundColor: scaffoldBackgroundColor,
        bottomAppBarColor: bottomAppBarColor,
        cardColor: cardColor,
        dividerColor: dividerColor,
        focusColor: focusColor,
        hoverColor: hoverColor,
        highlightColor: highlightColor,
        splashColor: splashColor,
        splashFactory: splashFactory,
        selectedRowColor: selectedRowColor,
        unselectedWidgetColor: unselectedWidgetColor,
        disabledColor: disabledColor,
        buttonTheme: buttonTheme,
        buttonColor: buttonColor,
        toggleButtonsTheme: toggleButtonsTheme,
        toggleableActiveColor: toggleableActiveColor,
        secondaryHeaderColor: secondaryHeaderColor,
        textSelectionColor: textSelectionColor,
        cursorColor: cursorColor,
        textSelectionHandleColor: textSelectionHandleColor,
        backgroundColor: backgroundColor,
        dialogBackgroundColor: dialogBackgroundColor,
        indicatorColor: indicatorColor,
        hintColor: hintColor,
        errorColor: errorColor,
        textTheme: textTheme,
        primaryTextTheme: primaryTextTheme,
        accentTextTheme: accentTextTheme,
        inputDecorationTheme: inputDecorationTheme,
        iconTheme: iconTheme,
        primaryIconTheme: primaryIconTheme,
        accentIconTheme: accentIconTheme,
        sliderTheme: sliderTheme,
        tabBarTheme: tabBarTheme,
        tooltipTheme: tooltipTheme,
        cardTheme: cardTheme,
        chipTheme: chipTheme,
        platform: platform,
        materialTapTargetSize: materialTapTargetSize,
        applyElevationOverlayColor: applyElevationOverlayColor,
        pageTransitionsTheme: pageTransitionsTheme,
        appBarTheme: appBarTheme,
        bottomAppBarTheme: bottomAppBarTheme,
        colorScheme: colorScheme,
        dialogTheme: dialogTheme,
        floatingActionButtonTheme: floatingActionButtonTheme,
        typography: typography,
        cupertinoOverrideTheme: cupertinoOverrideTheme,
        snackBarTheme: snackBarTheme,
        bottomSheetTheme: bottomSheetTheme,
        popupMenuTheme: popupMenuTheme,
        bannerTheme: bannerTheme,
        dividerTheme: dividerTheme,
        buttonBarTheme: buttonBarTheme,
      );

  /// Mix with this NeumorphicThemeData theme & a Material's ThemeData theme.
  /// Performs Linear interpolation with this theme & ThemeData.
  NeuThemeData mixWithThemeData(ThemeData b, double t) =>
      lerpWithThemeData(this, b, t);

  /// Linearly interpolate between a NeumorphicThemeData theme & Material's ThemeData theme.
  ///
  /// The arguments must not be null.
  ///
  /// {@macro dart.ui.shadow.lerp}
  static NeuThemeData lerpWithThemeData(NeuThemeData a, ThemeData b, double t) {
    assert(a != null);
    assert(b != null);
    assert(t != null);
    // Warning: make sure these properties are in the exact same order as in
    // hashValues() and in the raw constructor and in the order of fields in
    // the class and in the lerp() method.
    return NeuThemeData.raw(
      selectionControls: a.selectionControls,
      curveType: a.curveType,
      lightSource: a.lightSource,
      brightness: t < 0.5 ? a.brightness : b.brightness,
      primaryColor: Color.lerp(a.primaryColor, b.primaryColor, t),
      primaryColorBrightness:
          t < 0.5 ? a.primaryColorBrightness : b.primaryColorBrightness,
      primaryColorLight:
          Color.lerp(a.primaryColorLight, b.primaryColorLight, t),
      primaryColorDark: Color.lerp(a.primaryColorDark, b.primaryColorDark, t),
      canvasColor: Color.lerp(a.canvasColor, b.canvasColor, t),
      accentColor: Color.lerp(a.accentColor, b.accentColor, t),
      accentColorBrightness:
          t < 0.5 ? a.accentColorBrightness : b.accentColorBrightness,
      scaffoldBackgroundColor:
          Color.lerp(a.scaffoldBackgroundColor, b.scaffoldBackgroundColor, t),
      bottomAppBarColor:
          Color.lerp(a.bottomAppBarColor, b.bottomAppBarColor, t),
      cardColor: Color.lerp(a.cardColor, b.cardColor, t),
      dividerColor: Color.lerp(a.dividerColor, b.dividerColor, t),
      focusColor: Color.lerp(a.focusColor, b.focusColor, t),
      hoverColor: Color.lerp(a.hoverColor, b.hoverColor, t),
      highlightColor: Color.lerp(a.highlightColor, b.highlightColor, t),
      splashColor: Color.lerp(a.splashColor, b.splashColor, t),
      splashFactory: t < 0.5 ? a.splashFactory : b.splashFactory,
      selectedRowColor: Color.lerp(a.selectedRowColor, b.selectedRowColor, t),
      unselectedWidgetColor:
          Color.lerp(a.unselectedWidgetColor, b.unselectedWidgetColor, t),
      disabledColor: Color.lerp(a.disabledColor, b.disabledColor, t),
      buttonTheme: t < 0.5 ? a.buttonTheme : b.buttonTheme,
      toggleButtonsTheme: ToggleButtonsThemeData.lerp(
          a.toggleButtonsTheme, b.toggleButtonsTheme, t),
      buttonColor: Color.lerp(a.buttonColor, b.buttonColor, t),
      secondaryHeaderColor:
          Color.lerp(a.secondaryHeaderColor, b.secondaryHeaderColor, t),
      textSelectionColor:
          Color.lerp(a.textSelectionColor, b.textSelectionColor, t),
      cursorColor: Color.lerp(a.cursorColor, b.cursorColor, t),
      textSelectionHandleColor:
          Color.lerp(a.textSelectionHandleColor, b.textSelectionHandleColor, t),
      backgroundColor: Color.lerp(a.backgroundColor, b.backgroundColor, t),
      dialogBackgroundColor:
          Color.lerp(a.dialogBackgroundColor, b.dialogBackgroundColor, t),
      indicatorColor: Color.lerp(a.indicatorColor, b.indicatorColor, t),
      hintColor: Color.lerp(a.hintColor, b.hintColor, t),
      errorColor: Color.lerp(a.errorColor, b.errorColor, t),
      toggleableActiveColor:
          Color.lerp(a.toggleableActiveColor, b.toggleableActiveColor, t),
      textTheme: TextTheme.lerp(a.textTheme, b.textTheme, t),
      primaryTextTheme:
          TextTheme.lerp(a.primaryTextTheme, b.primaryTextTheme, t),
      accentTextTheme: TextTheme.lerp(a.accentTextTheme, b.accentTextTheme, t),
      inputDecorationTheme:
          t < 0.5 ? a.inputDecorationTheme : b.inputDecorationTheme,
      iconTheme: IconThemeData.lerp(a.iconTheme, b.iconTheme, t),
      primaryIconTheme:
          IconThemeData.lerp(a.primaryIconTheme, b.primaryIconTheme, t),
      accentIconTheme:
          IconThemeData.lerp(a.accentIconTheme, b.accentIconTheme, t),
      sliderTheme: SliderThemeData.lerp(a.sliderTheme, b.sliderTheme, t),
      tabBarTheme: TabBarTheme.lerp(a.tabBarTheme, b.tabBarTheme, t),
      tooltipTheme: TooltipThemeData.lerp(a.tooltipTheme, b.tooltipTheme, t),
      cardTheme: CardTheme.lerp(a.cardTheme, b.cardTheme, t),
      chipTheme: ChipThemeData.lerp(a.chipTheme, b.chipTheme, t),
      platform: t < 0.5 ? a.platform : b.platform,
      materialTapTargetSize:
          t < 0.5 ? a.materialTapTargetSize : b.materialTapTargetSize,
      applyElevationOverlayColor:
          t < 0.5 ? a.applyElevationOverlayColor : b.applyElevationOverlayColor,
      pageTransitionsTheme:
          t < 0.5 ? a.pageTransitionsTheme : b.pageTransitionsTheme,
      appBarTheme: AppBarTheme.lerp(a.appBarTheme, b.appBarTheme, t),
      bottomAppBarTheme:
          BottomAppBarTheme.lerp(a.bottomAppBarTheme, b.bottomAppBarTheme, t),
      colorScheme: ColorScheme.lerp(a.colorScheme, b.colorScheme, t),
      dialogTheme: DialogTheme.lerp(a.dialogTheme, b.dialogTheme, t),
      floatingActionButtonTheme: FloatingActionButtonThemeData.lerp(
          a.floatingActionButtonTheme, b.floatingActionButtonTheme, t),
      typography: Typography.lerp(a.typography, b.typography, t),
      cupertinoOverrideTheme:
          t < 0.5 ? a.cupertinoOverrideTheme : b.cupertinoOverrideTheme,
      snackBarTheme:
          SnackBarThemeData.lerp(a.snackBarTheme, b.snackBarTheme, t),
      bottomSheetTheme:
          BottomSheetThemeData.lerp(a.bottomSheetTheme, b.bottomSheetTheme, t),
      popupMenuTheme:
          PopupMenuThemeData.lerp(a.popupMenuTheme, b.popupMenuTheme, t),
      bannerTheme:
          MaterialBannerThemeData.lerp(a.bannerTheme, b.bannerTheme, t),
      dividerTheme: DividerThemeData.lerp(a.dividerTheme, b.dividerTheme, t),
      buttonBarTheme:
          ButtonBarThemeData.lerp(a.buttonBarTheme, b.buttonBarTheme, t),
    );
  }

  @override
  bool operator ==(Object other) {
    if (other.runtimeType != runtimeType) {
      return false;
    }
    final NeuThemeData otherData = other;
    // Warning: make sure these properties are in the exact same order as in
    // hashValues() and in the raw constructor and in the order of fields in
    // the class and in the lerp() method.
    return (otherData.selectionControls == selectionControls) &&
        (otherData.curveType == curveType) &&
        (otherData.lightSource == lightSource) &&
        (otherData.brightness == brightness) &&
        (otherData.primaryColor == primaryColor) &&
        (otherData.primaryColorBrightness == primaryColorBrightness) &&
        (otherData.primaryColorLight == primaryColorLight) &&
        (otherData.primaryColorDark == primaryColorDark) &&
        (otherData.accentColor == accentColor) &&
        (otherData.accentColorBrightness == accentColorBrightness) &&
        (otherData.canvasColor == canvasColor) &&
        (otherData.scaffoldBackgroundColor == scaffoldBackgroundColor) &&
        (otherData.bottomAppBarColor == bottomAppBarColor) &&
        (otherData.cardColor == cardColor) &&
        (otherData.dividerColor == dividerColor) &&
        (otherData.highlightColor == highlightColor) &&
        (otherData.splashColor == splashColor) &&
        (otherData.splashFactory == splashFactory) &&
        (otherData.selectedRowColor == selectedRowColor) &&
        (otherData.unselectedWidgetColor == unselectedWidgetColor) &&
        (otherData.disabledColor == disabledColor) &&
        (otherData.buttonTheme == buttonTheme) &&
        (otherData.buttonColor == buttonColor) &&
        (otherData.toggleButtonsTheme == toggleButtonsTheme) &&
        (otherData.secondaryHeaderColor == secondaryHeaderColor) &&
        (otherData.textSelectionColor == textSelectionColor) &&
        (otherData.cursorColor == cursorColor) &&
        (otherData.textSelectionHandleColor == textSelectionHandleColor) &&
        (otherData.backgroundColor == backgroundColor) &&
        (otherData.dialogBackgroundColor == dialogBackgroundColor) &&
        (otherData.indicatorColor == indicatorColor) &&
        (otherData.hintColor == hintColor) &&
        (otherData.errorColor == errorColor) &&
        (otherData.toggleableActiveColor == toggleableActiveColor) &&
        (otherData.textTheme == textTheme) &&
        (otherData.primaryTextTheme == primaryTextTheme) &&
        (otherData.accentTextTheme == accentTextTheme) &&
        (otherData.inputDecorationTheme == inputDecorationTheme) &&
        (otherData.iconTheme == iconTheme) &&
        (otherData.primaryIconTheme == primaryIconTheme) &&
        (otherData.accentIconTheme == accentIconTheme) &&
        (otherData.sliderTheme == sliderTheme) &&
        (otherData.tabBarTheme == tabBarTheme) &&
        (otherData.tooltipTheme == tooltipTheme) &&
        (otherData.cardTheme == cardTheme) &&
        (otherData.chipTheme == chipTheme) &&
        (otherData.platform == platform) &&
        (otherData.materialTapTargetSize == materialTapTargetSize) &&
        (otherData.applyElevationOverlayColor == applyElevationOverlayColor) &&
        (otherData.pageTransitionsTheme == pageTransitionsTheme) &&
        (otherData.appBarTheme == appBarTheme) &&
        (otherData.bottomAppBarTheme == bottomAppBarTheme) &&
        (otherData.colorScheme == colorScheme) &&
        (otherData.dialogTheme == dialogTheme) &&
        (otherData.floatingActionButtonTheme == floatingActionButtonTheme) &&
        (otherData.typography == typography) &&
        (otherData.cupertinoOverrideTheme == cupertinoOverrideTheme) &&
        (otherData.snackBarTheme == snackBarTheme) &&
        (otherData.bottomSheetTheme == bottomSheetTheme) &&
        (otherData.popupMenuTheme == popupMenuTheme) &&
        (otherData.bannerTheme == bannerTheme) &&
        (otherData.dividerTheme == dividerTheme) &&
        (otherData.buttonBarTheme == buttonBarTheme);
  }

  @override
  int get hashCode {
    // Warning: For the sanity of the reader, please make sure these properties
    // are in the exact same order as in operator == and in the raw constructor
    // and in the order of fields in the class and in the lerp() method.
    final List<Object> values = <Object>[
      selectionControls,
      curveType,
      lightSource,
      brightness,
      primaryColor,
      primaryColorBrightness,
      primaryColorLight,
      primaryColorDark,
      accentColor,
      accentColorBrightness,
      canvasColor,
      scaffoldBackgroundColor,
      bottomAppBarColor,
      cardColor,
      dividerColor,
      focusColor,
      hoverColor,
      highlightColor,
      splashColor,
      splashFactory,
      selectedRowColor,
      unselectedWidgetColor,
      disabledColor,
      buttonTheme,
      buttonColor,
      toggleButtonsTheme,
      toggleableActiveColor,
      secondaryHeaderColor,
      textSelectionColor,
      cursorColor,
      textSelectionHandleColor,
      backgroundColor,
      dialogBackgroundColor,
      indicatorColor,
      hintColor,
      errorColor,
      textTheme,
      primaryTextTheme,
      accentTextTheme,
      inputDecorationTheme,
      iconTheme,
      primaryIconTheme,
      accentIconTheme,
      sliderTheme,
      tabBarTheme,
      tooltipTheme,
      cardTheme,
      chipTheme,
      platform,
      materialTapTargetSize,
      applyElevationOverlayColor,
      pageTransitionsTheme,
      appBarTheme,
      bottomAppBarTheme,
      colorScheme,
      dialogTheme,
      floatingActionButtonTheme,
      typography,
      cupertinoOverrideTheme,
      snackBarTheme,
      bottomSheetTheme,
      popupMenuTheme,
      bannerTheme,
      dividerTheme,
      buttonBarTheme,
    ];
    return hashList(values);
  }
}

class _IdentityThemeDataCacheKey {
  _IdentityThemeDataCacheKey(this.baseTheme, this.localTextGeometry);

  final NeuThemeData baseTheme;
  final TextTheme localTextGeometry;

  // Using XOR to make the hash function as fast as possible (e.g. Jenkins is
  // noticeably slower).
  @override
  int get hashCode =>
      identityHashCode(baseTheme) ^ identityHashCode(localTextGeometry);

  @override
  bool operator ==(Object other) {
    // We are explicitly ignoring the possibility that the types might not
    // match in the interests of speed.
    final _IdentityThemeDataCacheKey otherKey = other;
    return identical(baseTheme, otherKey.baseTheme) &&
        identical(localTextGeometry, otherKey.localTextGeometry);
  }
}

/// Cache of objects of limited size that uses the first in first out eviction
/// strategy (a.k.a least recently inserted).
///
/// The key that was inserted before all other keys is evicted first, i.e. the
/// one inserted least recently.
class _FifoCache<K, V> {
  _FifoCache(this._maximumSize)
      : assert(_maximumSize != null && _maximumSize > 0);

  /// In Dart the map literal uses a linked hash-map implementation, whose keys
  /// are stored such that [Map.keys] returns them in the order they were
  /// inserted.
  final Map<K, V> _cache = <K, V>{};

  /// Maximum number of entries to store in the cache.
  ///
  /// Once this many entries have been cached, the entry inserted least recently
  /// is evicted when adding a new entry.
  final int _maximumSize;

  /// Returns the previously cached value for the given key, if available;
  /// if not, calls the given callback to obtain it first.
  ///
  /// The arguments must not be null.
  V putIfAbsent(K key, V loader()) {
    assert(key != null);
    assert(loader != null);
    final V result = _cache[key];
    if (result != null) {
      return result;
    }
    if (_cache.length == _maximumSize) {
      _cache.remove(_cache.keys.first);
    }
    return _cache[key] = loader();
  }
}
