import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import '../../neumorphic.dart';

/// A Neumorphic design button.
/// 
/// The Button automatically when pressed toggle the status of [CurveType]
/// from [CurveType.concave] to [CurveType.convex] and back.
class NeuButton extends StatefulWidget {
  /// Creates a button following Neumorphic design.
  /// A [NeuButton] button is based on a [NeuCard] widget
  /// whose [CurveType] changes when the button is pressed.
  ///
  /// If the [onPressed] is null than the button will be rendered as disabled.
  const NeuButton({
    @required this.onPressed,
    this.child,
    this.padding = const EdgeInsets.all(12.0),
    this.shape = BoxShape.rectangle,
    Key key,
  }) : super(key: key);

  /// The widget to be shown on the button, usually a [Text] widget or an [Icon]
  final Widget child;

  /// An override callback to perform when the button is pressed.
  ///
  /// It can, for instance, be used to push a Route to platform's navigation stack.
  ///
  /// Defaults to [EdgeInsets.all(12.0)].
  final VoidCallback onPressed;

  /// The padding insets to add around the [child]
  final EdgeInsetsGeometry padding;

  /// The shape of the button. Defaults to  [BoxShape.rectangle]
  final BoxShape shape;
  @override
  _NeuButtonState createState() => _NeuButtonState();
}

class _NeuButtonState extends State<NeuButton> {
  bool _isPressed = false;

  void _toggle(bool value) {
    if (_isPressed != value) {
      setState(() {
        _isPressed = value;
      });
    }
  }

  void _tapDown() => _toggle(true);

  void _tapUp() => _toggle(false);

  @override
  Widget build(BuildContext context) => GestureDetector(
        onTapDown: (_) => _tapDown(),
        onTapUp: (_) => _tapUp(),
        onTapCancel: _tapUp,
        onTap: widget.onPressed,
        child: NeuCard(
          curveType: _isPressed ? CurveType.concave : CurveType.flat,
          padding: widget.padding,
          child: widget.child,
          alignment: Alignment.center,
          decoration: NeumorphicDecoration(
            borderRadius: widget.shape == BoxShape.circle
                ? null
                : BorderRadius.circular(16),
            shape: widget.shape,
          ),
        ),
      );
}
