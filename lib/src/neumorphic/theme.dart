// Copyright 2015 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/cupertino.dart' show CupertinoTheme;
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart'
    show MaterialLocalizations, ScriptCategory, Theme, ThemeDataTween;
import 'theme_data.dart';

export 'theme_data.dart' show Brightness, NeumorphicThemeData;

/// The duration over which theme changes animate by default.
const Duration kThemeAnimationDuration = Duration(milliseconds: 200);

/// Applies a theme to descendant widgets.
///
/// A theme describes the colors and typographic choices of an application.
///
/// Descendant widgets obtain the current theme's [NeumorphicThemeData] object using
/// [NeumorphicTheme.of]. When a widget uses [NeumorphicTheme.of], it is automatically rebuilt if
/// the theme later changes, so that the changes can be applied.
///
/// The [NeumorphicTheme] widget implies an [IconTheme] widget, set to the value of the
/// [NeumorphicThemeData.iconTheme] of the [data] for the [NeumorphicTheme].
///
/// See also:
///
///  * [NeumorphicThemeData], which describes the actual configuration of a theme.
///  * [AnimatedNeumorphicTheme], which animates the [NeumorphicThemeData] when it changes rather
///    than changing the theme all at once.
///  * [NeumorphicApp], which includes an [AnimatedNeumorphicTheme] widget configured via
///    the [NeumorphicApp.theme] argument.
class NeumorphicTheme extends StatelessWidget {
  /// Applies the given theme [data] to [child].
  ///
  /// The [data] and [child] arguments must not be null.
  const NeumorphicTheme({
    Key key,
    @required this.data,
    this.isNeumorphicAppTheme = false,
    @required this.child,
  })  : assert(child != null),
        assert(data != null),
        super(key: key);

  /// Specifies the color and typography values for descendant widgets.
  final NeumorphicThemeData data;

  /// True if this theme was installed by the [NeumorphicApp].
  ///
  /// When an app uses the [Navigator] to push a route, the route's widgets
  /// will only inherit from the app's theme, even though the widget that
  /// triggered the push may inherit from a theme that "shadows" the app's
  /// theme because it's deeper in the widget tree. Apps can find the shadowing
  /// theme with `Theme.of(context, shadowThemeOnly: true)` and pass it along
  /// to the class that creates a route's widgets. Material widgets that push
  /// routes, like [PopupMenuButton] and [DropdownButton], do this.
  final bool isNeumorphicAppTheme;

  /// The widget below this widget in the tree.
  ///
  /// {@macro flutter.widgets.child}
  final Widget child;

  static final NeumorphicThemeData _kFallbackTheme =
      NeumorphicThemeData.fallback();

  /// The data from the closest [NeumorphicTheme] instance that encloses the given
  /// context.
  ///
  /// If the given context is enclosed in a [Localizations] widget providing
  /// [MaterialLocalizations], the returned data is localized according to the
  /// nearest available [MaterialLocalizations].
  ///
  /// Defaults to [new NeumorphicThemeData.fallback] if there is no [NeumorphicTheme] in the given
  /// build context.
  ///
  /// If [shadowThemeOnly] is true and the closest [NeumorphicTheme] ancestor was
  /// installed by the [NeumorphicApp] — in other words if the closest [NeumorphicTheme]
  /// ancestor does not shadow the application's theme — then this returns null.
  /// This argument should be used in situations where its useful to wrap a
  /// route's widgets with a [NeumorphicTheme], but only when the application's overall
  /// theme is being shadowed by a [NeumorphicTheme] widget that is deeper in the tree.
  /// See [isNeumorphicAppTheme].
  ///
  /// Typical usage is as follows:
  ///
  /// ```dart
  /// @override
  /// Widget build(BuildContext context) {
  ///   return Text(
  ///     'Example',
  ///     style: Theme.of(context).textTheme.title,
  ///   );
  /// }
  /// ```
  ///
  /// When the [NeumorphicTheme] is actually created in the same `build` function
  /// (possibly indirectly, e.g. as part of a [NeumorphicApp]), the `context`
  /// argument to the `build` function can't be used to find the [NeumorphicTheme] (since
  /// it's "above" the widget being returned). In such cases, the following
  /// technique with a [Builder] can be used to provide a new scope with a
  /// [BuildContext] that is "under" the [Theme]:
  ///
  /// ```dart
  /// @override
  /// Widget build(BuildContext context) {
  ///   return NeumorphicApp(
  ///     theme: ThemeData.light(),
  ///     body: Builder(
  ///       // Create an inner BuildContext so that we can refer to
  ///       // the Theme with Theme.of().
  ///       builder: (BuildContext context) {
  ///         return Center(
  ///           child: Text(
  ///             'Example',
  ///             style: Theme.of(context).textTheme.title,
  ///           ),
  ///         );
  ///       },
  ///     ),
  ///   );
  /// }
  /// ```
  static NeumorphicThemeData of(BuildContext context,
      {bool shadowThemeOnly = false}) {
    final _InheritedTheme inheritedTheme =
        context.dependOnInheritedWidgetOfExactType<_InheritedTheme>();
    if (shadowThemeOnly) {
      if (inheritedTheme == null || inheritedTheme.theme.isNeumorphicAppTheme)
        return null;
      return inheritedTheme.theme.data;
    }

    final MaterialLocalizations localizations =
        MaterialLocalizations.of(context);
    final ScriptCategory category =
        localizations?.scriptCategory ?? ScriptCategory.englishLike;
    final NeumorphicThemeData theme =
        inheritedTheme?.theme?.data ?? _kFallbackTheme;
    return NeumorphicThemeData.localize(
        theme, theme.typography.geometryThemeFor(category));
  }

  @override
  Widget build(BuildContext context) {
    return _InheritedTheme(
      theme: this,
      child: CupertinoTheme(
        // We're using a MaterialBasedCupertinoThemeData here instead of a
        // CupertinoThemeData because it defers some properties to the Material
        // ThemeData.
        data: MaterialBasedCupertinoThemeData(
          materialTheme: data,
        ),
        child: IconTheme(
          data: data.iconTheme,
          child: child,
        ),
      ),
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty<NeumorphicThemeData>('data', data,
        showName: false));
  }
}

class _InheritedTheme extends InheritedTheme {
  const _InheritedTheme({
    Key key,
    @required this.theme,
    @required Widget child,
  })  : assert(theme != null),
        super(key: key, child: child);

  final NeumorphicTheme theme;

  @override
  Widget wrap(BuildContext context, Widget child) {
    final _InheritedTheme ancestorTheme =
        context.findAncestorWidgetOfExactType<_InheritedTheme>();
    return identical(this, ancestorTheme)
        ? child
        : NeumorphicTheme(data: theme.data, child: child);
  }

  @override
  bool updateShouldNotify(_InheritedTheme old) => theme.data != old.theme.data;
}

/// An interpolation between two [NeumorphicThemeData]s.
///
/// This class specializes the interpolation of [Tween<ThemeData>] to call the
/// [NeumorphicThemeData.lerp] method.
///
/// See [Tween] for a discussion on how to use interpolation objects.
class NeumorphicThemeDataTween extends Tween<NeumorphicThemeData> {
  /// Creates a [NeumorphicThemeData] tween.
  ///
  /// The [begin] and [end] properties must be non-null before the tween is
  /// first used, but the arguments can be null if the values are going to be
  /// filled in later.
  NeumorphicThemeDataTween({NeumorphicThemeData begin, NeumorphicThemeData end})
      : super(begin: begin, end: end);

  @override
  NeumorphicThemeData lerp(double t) => NeumorphicThemeData.lerp(begin, end, t);
}

/// Animated version of [NeumorphicTheme] which automatically transitions the colors,
/// etc, over a given duration whenever the given theme changes.
///
/// Here's an illustration of what using this widget looks like, using a [curve]
/// of [Curves.elasticInOut].
/// {@animation 250 266 https://flutter.github.io/assets-for-api-docs/assets/widgets/animated_theme.mp4}
///
/// See also:
///
///  * [NeumorphicTheme], which [AnimatedNeumorphicTheme] uses to actually apply the interpolated
///    theme.
///  * [NeumorphicThemeData], which describes the actual configuration of a theme.
///  * [NeumorphicApp], which includes an [AnimatedNeumorphicTheme] widget configured via
///    the [NeumorphicApp.theme] argument.
class AnimatedNeumorphicTheme extends ImplicitlyAnimatedWidget {
  /// Creates an animated theme.
  ///
  /// By default, the theme transition uses a linear curve. The [data] and
  /// [child] arguments must not be null.
  const AnimatedNeumorphicTheme({
    Key key,
    @required this.data,
    this.isNeumorphicAppTheme = false,
    this.isMaterialAppTheme = false,
    Curve curve = Curves.linear,
    Duration duration = kThemeAnimationDuration,
    VoidCallback onEnd,
    @required this.child,
  })  : assert(child != null),
        assert(data != null),
        super(key: key, curve: curve, duration: duration, onEnd: onEnd);

  /// Specifies the color and typography values for descendant widgets.
  final NeumorphicThemeData data;

  /// True if this theme was created by the [NeumorphicApp]. See [NeumorphicTheme.isNeumorphicAppTheme].
  final bool isNeumorphicAppTheme;

  /// True if this theme was created by the [MaterialApp]. See [NeumorphicTheme.isNeumorphicAppTheme].
  final bool isMaterialAppTheme;

  /// The widget below this widget in the tree.
  ///
  /// {@macro flutter.widgets.child}
  final Widget child;

  @override
  _AnimatedThemeState createState() => _AnimatedThemeState();
}

class _AnimatedThemeState
    extends AnimatedWidgetBaseState<AnimatedNeumorphicTheme> {
  NeumorphicThemeDataTween _data;
  ThemeDataTween _mData;
  @override
  void forEachTween(TweenVisitor<dynamic> visitor) {
    // TODO(ianh): Use constructor tear-offs when it becomes possible
    _data = visitor(_data, widget.data,
        (dynamic value) => NeumorphicThemeDataTween(begin: value));
    _mData = visitor(_mData, widget.data.themeData,
        (dynamic value) => ThemeDataTween(begin: value));
    assert(_data != null);
    assert(_mData != null);
  }

  @override
  Widget build(BuildContext context) {
    return Theme(
      isMaterialAppTheme: widget.isMaterialAppTheme,
      data: _mData.evaluate(animation),
      child: NeumorphicTheme(
        isNeumorphicAppTheme: widget.isNeumorphicAppTheme,
        child: widget.child,
        data: _data.evaluate(animation),
      ),
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder description) {
    super.debugFillProperties(description);
    description.add(DiagnosticsProperty<NeumorphicThemeDataTween>('data', _data,
        showName: false, defaultValue: null));
  }
}
