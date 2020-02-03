import 'dart:ui';

extension ColorUtils on Color {
  Color mix(Color another, double amount) => Color.lerp(this, another, amount);
}

Color mixColor(Color firstColor, Color secondColor, double amount) {
  return Color.lerp(firstColor, secondColor, amount);
}
