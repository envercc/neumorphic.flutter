import 'package:flutter/material.dart';
import 'package:meta/meta.dart';
import 'package:neumorphic_example/data/item.dart';

class WidgetListingScreen extends StatelessWidget {
  const WidgetListingScreen({
    @required this.itemSelectedCallback,
    this.selectedItem,
  });

  final ValueChanged<Item> itemSelectedCallback;
  final Item selectedItem;

  @override
  Widget build(BuildContext context) => ListView(
        children: items
            .map((item) => ListTile(
                  title: Text(item.title),
                  onTap: () => itemSelectedCallback(item),
                  selected: selectedItem == item,
                ))
            .toList(),
      );
}
