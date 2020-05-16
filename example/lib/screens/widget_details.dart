import 'package:flutter/material.dart';
import 'package:meta/meta.dart';
import 'package:neumorphic/neumorphic.dart';

import '../data/item.dart';

class WidgetDetailsScreen extends StatelessWidget {
  const WidgetDetailsScreen({
    @required this.isInTabletLayout,
    @required this.item,
  });

  final bool isInTabletLayout;
  final Item item;

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;
    Widget content;
    if (item?.section == null) {
      content = Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              item?.title ?? 'No item selected!',
              style: textTheme.headline5,
            ),
            Text(
              item?.subtitle ?? 'Please select one on the left.',
              style: textTheme.bodyText1,
            ),
          ],
        ),
      );
    } else {
      content = item.section;
    }

    content = Padding(
      padding: EdgeInsets.all(isInTabletLayout ? 32 : 16),
      child: content,
    );

    if (!isInTabletLayout) {
      content = Scaffold(
        appBar: NeuAppBar(
          title: Text(item.title),
        ),
        body: content,
      );
    }

    return content;
  }
}
