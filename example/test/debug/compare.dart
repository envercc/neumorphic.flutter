import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:neumorphic/neumorphic.dart';
import 'package:neumorphic_example/utils/size_config.dart';

class CompareScreen extends StatefulWidget {
  @override
  _CompareScreenState createState() => _CompareScreenState();
}

class _CompareScreenState extends State<CompareScreen> {
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
                NeuCard(
                  bevel: 15,
                  child: sample,
                ),
                NeuCard(
                  bevel: 5,
                  child: sample,
                ),
                NeuCard(
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
