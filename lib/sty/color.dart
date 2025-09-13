import "package:color/color.dart";

class Colors {
  /// Core Color: 古代紫 #8c6589
  static const RgbColor core = RgbColor(0x8c, 0x65, 0x89);
  static String get cssCore => Colors.core.toHexColor().toCssString();
  /// Ink Color: 没食子 #55718e
  static const RgbColor ink = RgbColor(0x55, 0x71, 0x8e);
  static String get cssInk => Colors.ink.toHexColor().toCssString();
  /// Paper Color: 羊皮紙 #ececd6
  static const RgbColor paper = RgbColor(0xec, 0xec, 0xd6);
  static String get cssPaper => Colors.paper.toHexColor().toCssString();
}