import 'package:flutter/material.dart';
import 'package:meta/meta.dart';
import 'package:neumorphic_example/data/item.dart';
import 'package:neumorphic/neumorphic.dart';

class WidgetListingScreen extends StatelessWidget {
  const WidgetListingScreen({
    @required this.itemSelectedCallback,
    this.selectedItem,
  });

  final ValueChanged<Item> itemSelectedCallback;
  final Item selectedItem;

  @override
  Widget build(BuildContext context) => NeuCard(
        bevel: 8,
        decoration: NeumorphicDecoration(
          borderRadius: BorderRadius.circular(12),
        ),
        margin: EdgeInsets.all(16).copyWith(top: 8),
        curveType: CurveType.emboss,
        child: ListView.separated(
          itemBuilder: (_, index) => ListTile(
            title: Text(items[index].title),
            onTap: () => itemSelectedCallback(items[index]),
            selected: selectedItem == items[index],
          ),
          separatorBuilder: (context, index) => Divider(),
          itemCount: items.length,
        ),
      );
}
