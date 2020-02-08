import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:neumorphic/neumorphic.dart';

class SectionNeuSwitch extends StatefulWidget {
  @override
  _SectionNeuSwitchState createState() => _SectionNeuSwitchState();
}

class _SectionNeuSwitchState extends State<SectionNeuSwitch> {
  int switchValue = 0;

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
                  child: NeuSwitch<int>(
                    onValueChanged: (val) {
                      setState(() {
                        switchValue = val;
                      });
                    },
                    groupValue: switchValue,
                    children: {
                      0: Padding(
                        padding:
                            EdgeInsets.symmetric(vertical: 4, horizontal: 2),
                        child: AnimatedSwitcher(
                          duration: Duration(milliseconds: 150),
                          transitionBuilder: (child, animation) =>
                              SlideTransition(
                            position: Tween<Offset>(
                              begin: Offset(0.15, 0),
                              end: Offset(0, 0),
                            ).animate(animation),
                            child: FadeTransition(
                              opacity: animation,
                              child: child,
                            ),
                          ),
                          child: switchValue == 1
                              ? Icon(
                                  Icons.keyboard_backspace,
                                  key: UniqueKey(),
                                  color: Colors.blueGrey[500],
                                )
                              : Icon(
                                  Icons.apps,
                                  size: 30.0,
                                  color: Colors.blueGrey[200],
                                ),
                        ),
                      ),
                      1: Padding(
                        padding:
                            EdgeInsets.symmetric(vertical: 4, horizontal: 2),
                        child: AnimatedSwitcher(
                          duration: Duration(milliseconds: 150),
                          transitionBuilder: (child, animation) =>
                              SlideTransition(
                            position: Tween<Offset>(
                              begin: Offset(-0.15, 0),
                              end: Offset(0, 0),
                            ).animate(animation),
                            child: FadeTransition(
                              opacity: animation,
                              child: child,
                            ),
                          ),
                          child: switchValue == 1
                              ? Icon(
                                  Icons.apps,
                                  size: 30.0,
                                  color: Colors.blueGrey[200],
                                )
                              : Transform.rotate(
                                  angle: 180 * -math.pi / 180,
                                  child: Icon(
                                    Icons.keyboard_backspace,
                                    color: Colors.blueGrey[500],
                                  ),
                                ),
                        ),
                      ),
                    },
                  ),
                ),
                Text('Switch')
              ],
            ),
          ),
          SizedBox(height: 8),
        ],
      );
}
