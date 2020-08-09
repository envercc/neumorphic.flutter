# Neumorphic Ui kit for flutter

|                                                                                                              |                                                                                                             |
| ------------------------------------------------------------------------------------------------------------ | ----------------------------------------------------------------------------------------------------------- |
| ![showcase](https://raw.githubusercontent.com/neumorphic/neumorphic.flutter/master/example/media/v0/all.gif) | ![cards](https://raw.githubusercontent.com/neumorphic/neumorphic.flutter/master/example/media/v0/cards.png) |

## Getting Started

In your flutter project add the dependency:

[![pub package](https://img.shields.io/pub/v/neumorphic.svg)](https://pub.dev/packages/neumorphic)

```yaml
dependencies:
  neumorphic: any
```

<!-- Below line only works in documentation-->

Check out [library documentation (latest stable)](https://pub.dev/documentation/neumorphic/latest/neumorphic/neumorphic-library.html).

## Api

Now implemented some widgets:

- NeuCard
- NeuButton
- NeuSwitch
- NeuText
- NeuTextField
- NeuBackButton
- NeuAppBar
- NeuApp

### NeuCard

It is container like a `Material` merged with `Container`, but implements Neumorphism

```dart
NeuCard(
  // State of Neumorphic (may be convex, flat & emboss)
  curveType: CurveType.concave,

  // Elevation relative to parent. Main constituent of Neumorphism
  bevel: 12,

  // Specified decorations, like `BoxDecoration` but only limited
  decoration: NeumorphicDecoration(
    borderRadius: BorderRadius.circular(8)
  ),

  // Other arguments such as margin, padding etc. (Like `Container`)
  child: Text('Container')
)
```

### NeuButton

Button automatically when pressed toggle the status of NeumorphicStatus from `concave` to `convex` and back

```dart
NeuButton(
  onPressed: () {
    print('Pressed !');
  },
  child: Text('Button'),
);
```

### NeuSwitch

Remade `CupertinoSlidingSegmentedControl` which follows Neumorphism

```dart
NeuSwitch<int>(
  onValueChanged: (val) {
    setState(() {
      switchValue = val;
    });
  },
  groupValue: switchValue,
  children: {
    0: Padding(
      padding: EdgeInsets.symmetric(vertical: 24, horizontal: 8),
      child: Text('First'),
    ),
    1: Padding(
      padding: EdgeInsets.symmetric(vertical: 24, horizontal: 8),
      child: Text('Second'),
    ),
  },
);
```

### NeuText

It is a Text Widget which can implement Neumorphism. `parentColor`, `spread`, `depth`, `style`, `emboss` are properties of this widget which can be modified to obtain different effects.

```dart
NeuText('Lorem Ipsum')
```

### NeuTextField

It is a Text editing widget like Material's TextField which has a few more properties like
the support to use a custom selection control.

```dart
NeuTextField(
  controller: _controller,
  decoration: InputDecoration(
    border: OutlineInputBorder(),
    labelText: 'Write',
  ),
)
```

### NeuBackButton

A Neumorphic design back button.

Used by NeuAppBar.

### NeuAppBar

A Neumorphic design appBar.
This app bar consists of a `leading` Widget & a `title` Widget.

App bars are typically used in the `Scaffold.appBar` property, which places the app bar as a fixed-height widget at the top of the screen.

```dart
NeuAppBar(
  title: Text('This is title'),
)
```

### NeuApp

NeumorphicApp implements instance of `WidgetsApp` which utilizes `NeuThemeData` for adding themes to your app.

The `NeuThemeData` also adds `ThemeData` to the widget tree, so you don't have to worry about using MaterialApp again. Material widgets won't have side-effects.

You can access the current Neumorphic `NeuThemeData` using `NeuTheme.of(context)`. You can also use
`Theme.of(context)` to get `ThemeData`.

```dart
NeumorphicApp(
  theme: NeumorphicThemeData(
    brightness: Brightness.dark,
    primaryColor: Colors.blueGrey,
    curveType: curveType.concave,
    lightSource: LightSource.topLeft, // Not implemented yet
  ),
  home: Scaffold(
    appBar: NeuAppBar(
      title: const Text('NeumorphicApp Theme'),
    ),
  ),
)
```

## Limitations

- Not all widgets currently utilize `NeuThemeData`. This will be changed in later updates of this package.
- `NeuTextField` currently isn't much different than material's `TextField`.

**You can make support requests or report problems here on [Neumorphic's github issue page.](https://github.com/neumorphic/neumorphic.flutter/issues)**

## Inspired by

1. [Alexander Plyuto (figma)](https://www.figma.com/file/J1uPSOY5k577mDpSfGFven/Skeuomorph-Small-Style-Guide)

2. [Ivan Cherepanov (medium)](https://medium.com/flutter-community/neumorphic-designs-in-flutter-eab9a4de2059)
