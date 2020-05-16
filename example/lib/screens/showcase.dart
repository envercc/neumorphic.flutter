import 'package:flutter/material.dart';
import 'package:neumorphic/neumorphic.dart';

import '../data/item.dart';
import 'widget_details.dart';
import 'widget_listing.dart';

class ShowcaseScreen extends StatefulWidget {
  @override
  _ShowcaseScreenState createState() => _ShowcaseScreenState();
}

class _ShowcaseScreenState extends State<ShowcaseScreen> {
  static const int kTabletBreakpoint = 600;

  Item _selectedItem;

  Widget _buildMobileLayout() => WidgetListingScreen(
        itemSelectedCallback: (item) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (BuildContext context) => WidgetDetailsScreen(
                isInTabletLayout: false,
                item: item,
              ),
            ),
          );
        },
      );

  Widget _buildTabletLayout() => Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            width: 200,
            child: WidgetListingScreen(
              itemSelectedCallback: (item) {
                setState(() {
                  _selectedItem = item;
                });
              },
              selectedItem: _selectedItem,
            ),
            color: Colors.white,
          ),
          Flexible(
            flex: 3,
            child: WidgetDetailsScreen(
              isInTabletLayout: true,
              item: _selectedItem,
            ),
          ),
        ],
      );

  @override
  Widget build(BuildContext context) {
    Widget content;
    final shortestSide = MediaQuery.of(context).size.shortestSide;

    if (shortestSide < kTabletBreakpoint) {
      content = _buildMobileLayout();
    } else {
      content = _buildTabletLayout();
    }

    return Scaffold(
      appBar: NeuAppBar(
        title: Text('UI Showcase'),
      ),
      body: content,
    );
  }
}
