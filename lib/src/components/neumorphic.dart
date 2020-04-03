/// Based on the code by Ivan Cherepanov
/// https://medium.com/flutter-community/neumorphic-designs-in-flutter-eab9a4de2059
import 'package:flutter/material.dart';
import 'package:neumorphic/src/helpers.dart';
import '../params.dart';
import 'neu_card.dart';

/// A [Neumorphic] design widget.
class Neumorphic extends StatelessWidget {
  Neumorphic({
    this.child,
    this.bevel = 12.0,
    this.status = CurveType.convex,
    this.color,
    NeumorphicDecoration decoration,
    this.alignment,
    this.width,
    this.height,
    BoxConstraints constraints,
    this.margin,
    this.padding,
    this.transform,
    this.clipBehavior = Clip.none,
    this.shape,
    Key key,
  })  : blurOffset = Offset(bevel / 2, bevel / 2),
        decoration = decoration ?? NeumorphicDecoration(color: color),
        constraints = (width != null || height != null)
            ? constraints?.tighten(width: width, height: height) ??
                BoxConstraints.tightFor(width: width, height: height)
            : constraints,
        super(key: key);

  final Widget child;

  /// Elevation relative to parent. Main constituent of Neumorphism
  final double bevel;
  final Offset blurOffset;
  final CurveType status;
  final Color color;

  /// The decoration to paint behind the [child].
  ///
  /// A shorthand for specifying just a solid color is available in the
  /// constructor: set the `color` argument instead of the `decoration`
  /// argument.
  final NeumorphicDecoration decoration;

  final AlignmentGeometry alignment;
  final double width;
  final double height;
  final BoxConstraints constraints;
  final EdgeInsetsGeometry margin;
  final EdgeInsets padding;
  final Matrix4 transform;
  final ShapeBorder shape;

  /// {@template flutter.widgets.Clip}
  /// The content will be clipped (or not) according to this option.
  ///
  /// See the enum [Clip] for details of all possible options and their common
  /// use cases.
  /// {@endtemplate}
  ///
  /// Defaults to [Clip.none], and must not be null.
  final Clip clipBehavior;

  @override
  Widget build(BuildContext context) {
    final color = decoration?.color ?? Theme.of(context).backgroundColor;
    final isConcave = status == CurveType.concave;
    Widget _child = AnimatedContainer(
      duration: const Duration(milliseconds: 150),
      alignment: alignment,
      width: width,
      height: height,
      constraints: constraints,
      margin: margin,
      padding: padding,
      transform: transform,
      decoration: BoxDecoration(
        borderRadius: decoration.borderRadius,
        gradient: RadialGradient(
          // begin: Alignment.topLeft,
          // end: Alignment.bottomRight,
          colors: [
            isConcave ? color.mix(Colors.black, .035) : color,
            isConcave
                ? color.mix(Colors.white, .01)
                : color.mix(Colors.black, .01),
            isConcave
                ? color.mix(Colors.white, .01)
                : color.mix(Colors.black, .01),
            isConcave ? color.mix(Colors.black, .035) : color,
          ],
          stops: [
            0.0,
            .3,
            .6,
            1.0,
          ],
        ),
        boxShadow: [
          BoxShadow(
            blurRadius: bevel,
            offset: -blurOffset,
            color: color.mix(Colors.white, 1),
          ),
          BoxShadow(
            blurRadius: bevel,
            offset: blurOffset,
            color: color.mix(Colors.black, .15),
          )
        ],
        shape: decoration.shape,
        border: decoration.border,
      ),
      child: child,
    );
    if (clipBehavior == Clip.none) {
      return child;
    }
    return ClipPath(
      child: _child,
      clipper: ShapeBorderClipper(
        shape: shape ?? const RoundedRectangleBorder(),
        textDirection: Directionality.of(context),
      ),
      clipBehavior: clipBehavior,
    );
  }
}
