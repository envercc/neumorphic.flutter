import 'package:flutter/widgets.dart';
import 'package:meta/meta.dart';
import 'package:neumorphic_example/widgets/section_button.dart';
import 'package:neumorphic_example/widgets/section_neumorphic.dart';
import 'package:neumorphic_example/widgets/section_switch.dart';

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
    title: 'NeuCard',
    subtitle: 'Main container',
    section: SectionNeumorphic(),
  ),
  Item(
    title: 'NeuButton',
    subtitle: 'Button implementation',
    section: SectionNeuButton(),
  ),
  Item(
    title: 'NeuSwitch',
    subtitle: 'Button implementation',
    section: SectionNeuSwitch(),
  ),
];
