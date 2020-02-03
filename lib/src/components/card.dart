import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart'
    show Brightness, CardTheme, Material, Theme;

import '../constants.dart';
import '../params.dart';

/// A Neumorphic design based material card.
///
/// A card is a sheet of [Material] used to represent some related information,
/// for example an album, a geographical location, a meal, contact details, etc.
class Card extends StatelessWidget {
  /// Creates a Neumorphic design card.
  ///
  /// Compatible with Material Card.
  ///
  /// The [borderOnForeground] must not be null.
  const Card({
    Key key,
    this.color,
    this.shape,
    this.surface = SurfaceShape.concave,
    this.lightSource,
    this.borderOnForeground = true,
    this.margin,
    this.clipBehavior,
    this.child,
    this.allowGradient = true,
    this.semanticContainer = true,
  })  : assert(borderOnForeground != null),
        super(key: key);

  /// The card's background color.
  ///
  /// Defines the card's [Material.color].
  ///
  /// If this property is null then [ThemeData.cardTheme.color] is used,
  /// if that's null then [ThemeData.cardColor] is used.
  final Color color;

  /// Applies gradient effect when true.
  /// Default is true.
  final bool allowGradient;

  /// The shape of the card's [Material].
  ///
  /// Defines the card's [Material.shape].
  ///
  /// If this property is null then [ThemeData.cardTheme.shape] is used.
  /// If that's null then the shape will be a [RoundedRectangleBorder] with a
  /// circular corner radius of 4.0.
  final ShapeBorder shape;

  /// The surface shape type of the card's surface.
  ///
  /// Defines the card's [SurfaceShape].
  ///
  /// If this property is null then [SurfaceShape.concave] is used.
  final SurfaceShape surface;

  /// Point to emulate light from.
  ///
  /// Defines the card's [LightSource].
  ///
  /// If this property is on default then [LightSource.topLefft] is used.
  final LightSource lightSource;

  /// Whether to paint the [shape] border in front of the [child].
  ///
  /// The default value is true.
  /// If false, the border will be painted behind the [child].
  final bool borderOnForeground;

  /// {@macro flutter.widgets.Clip}
  ///
  /// If this property is null then [ThemeData.cardTheme.clipBehavior] is used.
  /// If that's null then the behavior will be [Clip.none].
  final Clip clipBehavior;

  /// The empty space that surrounds the card.
  ///
  /// Defines the card's outer [Container.margin].
  ///
  /// If this property is null then [ThemeData.cardTheme.margin] is used,
  /// if that's null, the default margin is 4.0 logical pixels on all sides:
  /// `EdgeInsets.all(4.0)`.
  final EdgeInsetsGeometry margin;

  /// Whether this widget represents a single semantic container, or if false
  /// a collection of individual semantic nodes.
  ///
  /// Defaults to true.
  ///
  /// Setting this flag to true will attempt to merge all child semantics into
  /// this node. Setting this flag to false will force all child semantic nodes
  /// to be explicit.
  ///
  /// This flag should be false if the card contains multiple different types
  /// of content.
  final bool semanticContainer;

  /// The widget below this widget in the tree.
  ///
  /// {@macro flutter.widgets.child}
  final Widget child;

  @override
  Widget build(BuildContext context) {
    // Checks if dark theme is enabled for application.
    // Instead of checking platform's brightness using
    // MediaQuery.of(context).platformBrightness, Theme's brightness is used
    // if material is dark
    bool _isDarkThemeOn = Theme.of(context).brightness == Brightness.dark;

    // Assigns `SurfaceShape.concave` if surface is provided null
    SurfaceShape surface = this.surface ?? SurfaceShape.concave;

    bool isConcave = (surface != SurfaceShape.convex);

    final CardTheme cardTheme = CardTheme.of(context);
    final Color mainCardColor = color ?? Theme.of(context).cardColor;

    final double blurRadius = 12;
    final double blurOffset = blurRadius / 2;

    // Mixing colors with mainCardColor to obtain proper shades & gradients
    // Didn't use dart extensions to make this code compatible
    // with dart 2.2 & above
    Color lightShade = Color.lerp(mainCardColor, cLightColor, 0.6);
    Color darkShade = Color.lerp(mainCardColor, cDarkColor, 0.3);
    Color lightGradient = Color.lerp(mainCardColor, cLightColor, 0.1);
    Color darkGradient = Color.lerp(mainCardColor, cDarkColor, 0.5);
    bool isLightOnTop = (lightSource == LightSource.topLeft ||
        lightSource == LightSource.topRight);

    Color topShade,
        bottomShade,
        topGradient = mainCardColor,
        bottomGradient = mainCardColor;

    // Handling how and where will light and dark effects should happen
    // depending upon Surface & Position of light source.
    if (isLightOnTop) {
      if (!_isDarkThemeOn) {
        topShade = lightShade;
        bottomShade = darkShade;
      }

      if (allowGradient) {
        topGradient = isConcave ? lightGradient : darkGradient;
        bottomGradient = isConcave ? darkGradient : lightGradient;
      }
    } else {
      if (!_isDarkThemeOn) {
        topShade = darkShade;
        bottomShade = lightShade;
      }
      if (allowGradient) {
        topGradient = isConcave ? darkGradient : lightGradient;
        bottomGradient = isConcave ? lightGradient : darkGradient;
      }
    }

    return Semantics(
      container: semanticContainer,
      child: Container(
        margin: margin ?? cardTheme.margin ?? const EdgeInsets.all(4.0),
        decoration: new BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(4.0)),
          border: Border.all(
            width: 0.1,
            color: mainCardColor.withAlpha(51),
          ),
          // Show box shadows only if `dark theme` is `off`
          boxShadow: _isDarkThemeOn
              ? null
              : [
                  BoxShadow(
                    color: topShade,
                    blurRadius:
                        blurRadius, // has the effect of softening the shadow
                    // spreadRadius: -12.0, // has the effect of extending the shadow
                    offset: Offset(
                      -blurOffset, // horizontal, move right -6
                      -blurOffset, // vertical, move down -6
                    ),
                  ),
                  BoxShadow(
                    color: bottomShade,
                    blurRadius:
                        blurRadius, // has the effect of softening the shadow
                    // spreadRadius: -12.0, // has the effect of extending the shadow
                    offset: Offset(
                      blurOffset, // horizontal, move right -6
                      blurOffset, // vertical, move down -6
                    ),
                  )
                ],
          gradient: allowGradient
              ? LinearGradient(
                  colors: [
                      topGradient,
                      mainCardColor,
                      bottomGradient,
                    ],
                  stops: [
                      0.0,
                      0.5,
                      1.0
                    ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  tileMode: TileMode.repeated)
              : null,
        ),
        child: Semantics(
          explicitChildNodes: !semanticContainer,
          child: child,
        ),
      ),
    );
  }
}
