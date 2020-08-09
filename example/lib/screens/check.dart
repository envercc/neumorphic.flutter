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
    content = Padding(
      padding: EdgeInsets.all(8),
      child: TextField(),
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
