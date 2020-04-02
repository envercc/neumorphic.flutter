import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:neumorphic/neumorphic.dart';
import 'utils/size_config.dart';

class Neumorphism extends StatefulWidget {
  @override
  _NeumorphismState createState() => _NeumorphismState();
}

class _NeumorphismState extends State<Neumorphism> {
  Widget sample = Padding(
    padding: const EdgeInsets.all(8.0),
    child: Text('Hello World!'),
  );
  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Neumorphic(
                  bevel: 15,
                  child: sample,
                ),
                Neumorphic(
                  bevel: 5,
                  child: sample,
                ),
                Neumorphic(
                  bevel: 10,
                  child: sample,
                ),
              ],
            ),
            SizedBox(height: 50),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Material(
                  elevation: 15,
                  child: sample,
                ),
                Material(
                  elevation: 5,
                  child: sample,
                ),
                Material(
                  elevation: 10,
                  child: sample,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
