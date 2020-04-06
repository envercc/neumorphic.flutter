import 'package:flutter/material.dart';
import 'package:neumorphic/neumorphic.dart';

class CheckScreen extends StatefulWidget {
  @override
  _CheckScreenState createState() => _CheckScreenState();
}

class _CheckScreenState extends State<CheckScreen> {
  @override
  Widget build(BuildContext context) {
    Widget content;
    content = Center(
      child: NeuCard(
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
          child: Image.network(
            'https://image.shutterstock.com/image-photo/white-transparent-leaf-on-mirror-260nw-1029171697.jpg',
            fit: BoxFit.fill,
          ),
        ),
      ),
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
