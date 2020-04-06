import 'package:flutter/material.dart';
import 'package:neumorphic/neumorphic.dart';

class CheckScreen extends StatefulWidget {
  @override
  _CheckScreenState createState() => _CheckScreenState();
}

class _CheckScreenState extends State<CheckScreen> {
  int switchValue = 0;
  @override
  Widget build(BuildContext context) {
    Widget content;
    content = Column(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        NeuCard(
          curveType: CurveType.concave,
          bevel: 8,
          decoration: NeumorphicDecoration(
            borderRadius: BorderRadius.circular(12.0),
          ),
          child: Container(
            height: 100,
            width: 100,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12.0),
            ),
            // padding: EdgeInsets.all(10),
          ),
        ),
        NeuButton(
          bevel: 10,
          color: Colors.red[200],
          onPressed: () {},
          child: Text('Hello'),
        ),
      ],
    );
    return Scaffold(
      backgroundColor: Colors.grey[300],
      appBar: NeuAppBar(
        title: Text('UI Check page'),
      ),
      body: content,
    );
  }
}
