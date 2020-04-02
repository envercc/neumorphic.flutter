import 'dart:ui';

extension ColorUtils on Color {
  /// Mix this [Color] with another [Color] in [amount]
  Color mix(Color another, double amount) => Color.lerp(this, another, amount);
}
