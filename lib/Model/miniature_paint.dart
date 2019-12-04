import 'package:flutter/material.dart';
import 'package:saladin/Model/HexColor.dart';

class MiniaturePaint {
  final String name;
  final String manufacturer;
  final String range;
  final String sku;
  //refactor this, colorSourceString is a quick fix hack
  final String colorSourceString;
  final HexColor color;
  final Gradient gradient;

  MiniaturePaint._(this.name, this.manufacturer, this.range, this.sku, this.colorSourceString, this.color, this.gradient);

  factory MiniaturePaint(String name, String manufacturer, String range, String sku, String color) {
    HexColor hexColor;
    Gradient gradient;

    if (color.startsWith("gradient")) {
      try {
        List<String> split = color.split("_");
        Color colorOne = HexColor(split[1]);
        Color colorTwo = HexColor(split[2]);
        gradient = LinearGradient(
            begin: Alignment.topLeft, end: Alignment.bottomRight, stops: [0.5, 1], colors: [colorOne, colorTwo]);
      } catch (e) {
        hexColor = HexColor.white();
      }
    } else {
      hexColor = HexColor(color);
    }

    return MiniaturePaint._(name, manufacturer, range, sku, color, hexColor, gradient);
  }

  String colorOrGradientToString() {
    return colorSourceString;
  }

}
