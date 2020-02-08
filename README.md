# Neumorphic Ui kit for flutter

|   |   |
|----------|:-------------:|------:|
|![showcase](https://raw.githubusercontent.com/neumorphic/neumorphic.flutter/master/example/media/v0/all.gif?raw=true)|![cards](https://raw.githubusercontent.com/neumorphic/neumorphic.flutter/master/example/media/v0/cards.png?raw=true)|


## Api
Now implemented some widgets:

 - NeuCard
 - NeuButton
 - NeuSwitch

### NeuCard
It is container like a `Material` merged with `Container`, but implement Neumorphism

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
Remade `CupertinoSlidingSegmentedControl`
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

## Getting Started

This project is a starting point for a Flutter
[plug-in package](https://flutter.dev/developing-packages/),
a specialized package that includes platform-specific implementation code for
Android and/or iOS.

For help getting started with Flutter, view our 
[online documentation](https://flutter.dev/docs), which offers tutorials, 
samples, guidance on mobile development, and a full API reference.

## Inspired by

1) [Alexander Plyuto (figma)](https://www.figma.com/file/J1uPSOY5k577mDpSfGFven/Skeuomorph-Small-Style-Guide)

2) [Ivan Cherepanov (medium)](https://medium.com/flutter-community/neumorphic-designs-in-flutter-eab9a4de2059)
