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
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: TextField(
            maxLines: 3,
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: NeuTextField(
            maxLines: 3,
          ),
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
