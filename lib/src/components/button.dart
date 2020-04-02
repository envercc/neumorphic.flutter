import 'package:flutter/widgets.dart';

import '../../neumorphic.dart';

class NeuButton extends StatefulWidget {
  const NeuButton({
    @required this.onPressed,
    this.child,
    this.padding = const EdgeInsets.all(12.0),
    this.shape = BoxShape.rectangle,
    Key key,
  }) : super(key: key);

  final Widget child;
  final VoidCallback onPressed;
  final EdgeInsetsGeometry padding;
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
          curveType: _isPressed ? SurfaceType.concave : SurfaceType.flat,
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
