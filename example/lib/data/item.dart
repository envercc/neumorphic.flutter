import 'package:flutter/widgets.dart';
import 'package:meta/meta.dart';
import 'package:neumorphic_example/widgets/section_neumorphic.dart';

class Item {
  Item({
    @required this.title,
    @required this.subtitle,
    this.section,
  });

  final String title;
  final String subtitle;
  final Widget section;
}

final List<Item> items = <Item>[
  Item(
    title: 'Neumorphic',
    subtitle: 'Main container',
    section: SectionNeumorphic(),
  ),
  Item(
    title: 'NeumorphicButton',
    subtitle: 'Button implementation',
  ),
  Item(
    title: 'NeumorphicSwitch',
    subtitle: 'Button implementation',
  ),
];
