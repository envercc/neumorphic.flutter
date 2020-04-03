import 'package:flutter/material.dart';
import 'package:neumorphic/neumorphic.dart';

class SectionNeumorphic extends StatelessWidget {
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
                  child: NeuCard(
                    padding: EdgeInsets.all(8),
                    curveType: CurveType.concave,
                    decoration: NeumorphicDecoration(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
                Text('Concave')
              ],
            ),
          ),
          SizedBox(height: 8),
          Divider(),
          SizedBox(height: 8),
          Container(
            padding: EdgeInsets.all(16),
            child: Row(
              children: [
                Container(
                  width: 100,
                  height: 100,
                  margin: EdgeInsets.only(right: 16),
                  child: NeuCard(
                    padding: EdgeInsets.all(8),
                    curveType: CurveType.flat,
                    decoration: NeumorphicDecoration(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
                Text('Flat')
              ],
            ),
          ),
          SizedBox(height: 8),
          Divider(),
          SizedBox(height: 8),
          Container(
            padding: EdgeInsets.all(16),
            child: Row(
              children: [
                Container(
                  width: 100,
                  height: 100,
                  margin: EdgeInsets.only(right: 16),
                  child: NeuCard(
                    padding: EdgeInsets.all(8),
                    curveType: CurveType.convex,
                    decoration: NeumorphicDecoration(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
                Text('Convex')
              ],
            ),
          ),
          SizedBox(height: 8),
          Divider(),
          SizedBox(height: 8),
          Container(
            padding: EdgeInsets.all(16),
            child: Row(
              children: [
                Container(
                  width: 100,
                  height: 100,
                  margin: EdgeInsets.only(right: 16),
                  child: NeuCard(
                    curveType: CurveType.emboss,
                    padding: EdgeInsets.all(8),
                    decoration: NeumorphicDecoration(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
                Text('Emboss')
              ],
            ),
          ),
        ],
      );
}
