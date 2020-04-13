import 'package:flutter/material.dart';
import 'package:neumorphic/neumorphic.dart';
import 'package:neumorphic/src/components/button.dart';

/// Neumorphic design back button
class NeuBackButton extends StatelessWidget {
  /// Creates an [IconButton] with the "back" icon. You can provide your own
  /// Widget through [icon] parameter.
  const NeuBackButton({Key key, this.color, this.onPressed, this.icon})
      : super(key: key);

  /// The color to use for the icon.
  ///
  /// Defaults to the [IconThemeData.color]
  /// specified in the ambient [IconTheme],
  /// which usually matches the ambient [Theme]'s [ThemeData.iconTheme].
  final Color color;

  /// An override callback to perform instead of the default behavior which is
  /// to pop the [Navigator].
  ///
  /// It can, for instance, be used to pop the platform's navigation stack
  /// via SystemNavigator instead of Flutter's [Navigator] in add-to-app
  /// situations.
  ///
  /// Defaults to null.
  final VoidCallback onPressed;

  /// The Widget to be used as [icon] in place of "back" icon for the current
  /// target platform. Usually an [Icon] widget.
  final Widget icon;

  @override
  Widget build(BuildContext context) {
    assert(debugCheckHasMaterialLocalizations(context));
    return Padding(
      padding: EdgeInsets.all(6).copyWith(left: 12),
      child: NeuButton(
        child: icon ?? Icon(Icons.arrow_back_ios),
        padding: EdgeInsets.all(6).copyWith(left: 2),
        decoration: NeumorphicDecoration(shape: BoxShape.circle),
        onPressed: () {
          if (onPressed != null) {
            onPressed();
          } else {
            Navigator.maybePop(context);
          }
        },
      ),
    );
  }
}
