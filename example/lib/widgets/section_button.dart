import 'package:flutter/material.dart';
import 'package:neumorphic/neumorphic.dart';

class SectionNeuButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Container(
            padding: EdgeInsets.all(16),
            child: Row(
              children: [
                Container(
                  width: 100,
                  height: 100,
                  margin: EdgeInsets.only(right: 16),
                  child: NeuButton(
                    child: Text('Click me!'),
                    onPressed: () {},
                  ),
                ),
                Text('Button')
              ],
            ),
          ),
          SizedBox(height: 8),
        ],
      );
}
