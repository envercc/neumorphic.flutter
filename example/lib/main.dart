import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
// import 'package:neumorphic_example/screens/showcase.dart';

// import 'screen.dart';
import 'compare.dart';

void main() => runApp(NeumorphicApp());

class NeumorphicApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarBrightness: Brightness.light,
      statusBarIconBrightness: Brightness.dark,
      systemNavigationBarIconBrightness: Brightness.dark,
    ));

    return MaterialApp(
      title: 'Neumorphic App',
      home: Neumorphism(),
    );
  }
}
