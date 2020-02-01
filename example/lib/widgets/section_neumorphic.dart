import 'package:flutter/material.dart';
import 'package:neumorphic/neumorphic.dart';

class SectionNeumorphic extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          SizedBox(
            width: 100,
            height: 100,
            child: Neumorphic(
              padding: EdgeInsets.all(8),
              status: NeumorphicStatus.concave,
              decoration: NeumorphicDecoration(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
          SizedBox(height: 16),
          SizedBox(
            width: 100,
            height: 100,
            child: Neumorphic(
              padding: EdgeInsets.all(8),
              status: NeumorphicStatus.convex,
              decoration: NeumorphicDecoration(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
        ],
      );
}
