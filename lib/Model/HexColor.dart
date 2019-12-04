import 'dart:ui';

class HexColor extends Color {
  static int _getColorFromHex(String hexColor) {
    hexColor = hexColor.trim().toUpperCase().replaceAll("#", "");
    if (hexColor.length == 6) {
      hexColor = "FF" + hexColor;
    }

    return int.parse(hexColor, radix: 16);
  }

  String toHex() => value.toRadixString(16).toUpperCase();

  HexColor(final String hexColor) : super(_getColorFromHex(hexColor));

  HexColor.white() : this("#FFFFFFFF");
}
