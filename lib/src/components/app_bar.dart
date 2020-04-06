import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import '../constants.dart';
import 'back_button.dart';

/// A Neumorphic design appBar.
class NeuAppBar extends StatelessWidget implements PreferredSizeWidget {
  /// A Neumorphic design appBar.
  /// This app bar consists of a [leading] Widget & a [title] Widget.
  ///
  /// App bars are typically used in the [Scaffold.appBar] property,
  /// which places the app bar as a fixed-height widget at the top of the screen.
  const NeuAppBar({
    this.leading,
    this.title,
    Key key,
  }) : super(key: key);

  /// The [leading] widget placed on the left side of appBar.
  /// Usually a back button or a menu button.
  final Widget leading;

  /// The [title] widget displayed after the [leading] on AppBar.
  final Widget title;

  @override
  Widget build(BuildContext context) {
    final MediaQueryData media = MediaQuery.of(context);
    final TextTheme textTheme = Theme.of(context).textTheme;
    final ModalRoute<dynamic> parentRoute = ModalRoute.of(context);
    final ScaffoldState scaffold = Scaffold.of(context, nullOk: true);
    final bool hasDrawer = scaffold?.hasDrawer ?? false;
    final bool canPop = parentRoute?.canPop ?? false;
    final bool useCloseButton =
        parentRoute is PageRoute<dynamic> && parentRoute.fullscreenDialog;

    Widget leading = this.leading;
    if (leading == null) {
      if (hasDrawer) {
        leading = IconButton(
          icon: const Icon(Icons.menu),
          onPressed: () => Scaffold.of(context).openDrawer(),
          tooltip: MaterialLocalizations.of(context).openAppDrawerTooltip,
        );
      } else if (canPop) {
        leading = useCloseButton ? const CloseButton() : const NeuBackButton();
      }
    }
    if (leading != null) {
      leading = ConstrainedBox(
        constraints: const BoxConstraints.tightFor(width: cToolbarHeight),
        child: leading,
      );
    }

    return Container(
      margin: EdgeInsets.only(top: media.padding.top),
      child: Row(
        children: [
          if (leading != null) leading,
          Expanded(
            child: Padding(
              padding: EdgeInsets.all(16)
                  .copyWith(right: (leading != null) ? cToolbarHeight : 0),
              child: DefaultTextStyle(
                style: textTheme.headline.copyWith(
                  /// TODO(noname): (ISSUE) Causes part of text below baseline to not show
                  fontSize: 24,
                  fontWeight: FontWeight.w600,
                ),
                textAlign: TextAlign.center,
                child: title,
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(cToolbarHeight);
}
