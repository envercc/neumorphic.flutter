import 'package:flutter/material.dart';

/// A Text widget which uses Neumorphic design.
class NeuText extends StatelessWidget {
  /// Creates a Neumorphic Text widget [NeuText].
  ///
  /// [parentColor], [spread], [depth], [style], [emboss] are properties
  /// of this widget which can be modified to obtain
  /// different results.
  ///
  /// If the [style] argument is null, then the text will use default style.
  ///
  /// The [text] parameter must not be null.
  const NeuText(
    this.text, {
    this.parentColor,
    this.spread,
    this.depth,
    this.style,
    this.emboss,
  });

  /// The test to be displayed
  final String text;

  /// The color to put on as effect to parents
  final Color parentColor;

  /// The TextStyle to use for modifying styles of text.
  final TextStyle style;

  /// Amount of spread to apply on effects
  final double spread;

  /// The depth of colors, emboss, shadows under text
  final int depth;

  /// Parameter to control the whether to use [emboss] effect or not.
  final bool emboss;
  @override
  Widget build(BuildContext context) {
    final int depthValue = depth == null ? 40 : depth;

    final textStyle = style ?? DefaultTextStyle.of(context).style;
    Color colorValue = style?.color ?? Color(0xFFf0f0f0);
    final Color outerColorValue = parentColor ?? colorValue;

    double fontSizeValue = textStyle.fontSize;

    fontSizeValue =
        textStyle.fontSize != null ? textStyle.fontSize : fontSizeValue;
    final double spreadValue =
        spread == null ? _getSpread(fontSizeValue) : spread;
    final bool embossValue = emboss == null ? false : emboss;

    List<Shadow> shadowList = [
      Shadow(
        color: _getAdjustColor(
          outerColorValue,
          embossValue ? 0 - depthValue : depthValue,
        ),
        offset: Offset(0 - spreadValue / 2, 0 - spreadValue / 2),
        blurRadius: spreadValue,
      ),
      Shadow(
        color: _getAdjustColor(
          outerColorValue,
          embossValue ? depthValue : 0 - depthValue,
        ),
        offset: Offset(spreadValue / 2, spreadValue / 2),
        blurRadius: spreadValue,
      )
    ];

    if (embossValue) {
      shadowList = shadowList.reversed.toList();
      colorValue = _getAdjustColor(colorValue, 0 - depthValue);
    }

    return Text(
      text,
      style: textStyle.copyWith(
        color: colorValue,
        shadows: shadowList,
        fontSize: fontSizeValue,
      ),
    );
  }

  Color _getAdjustColor(Color baseColor, amount) {
    Map colors = {
      'r': baseColor.red,
      'g': baseColor.green,
      'b': baseColor.blue
    };
    colors = colors.map((key, value) {
      if (value + amount < 0) {
        return MapEntry(key, 0);
      }
      if (value + amount > 255) {
        return MapEntry(key, 255);
      }
      return MapEntry(key, value + amount);
    });
    return Color.fromRGBO(colors['r'], colors['g'], colors['b'], 1);
  }

  double _getSpread(base) {
    final double calculated = (base / 10).floor().toDouble();
    return calculated == 0 ? 1 : calculated;
  }
}
