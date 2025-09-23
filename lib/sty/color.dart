import "package:color/color.dart";

class Colors {
  /// Core Color: 古代紫 #8c6589
  static const RgbColor core = RgbColor(0x8c, 0x65, 0x89);
  /// Ink Color: 没食子 #55718e
  static const RgbColor ink = RgbColor(0x55, 0x71, 0x8e);
  /// Paper Color: 羊皮紙 #ececd6
  static const RgbColor paper = RgbColor(0xec, 0xec, 0xd6);
}
extension ColorEx<C extends Color> on C {
  String get css => this.toHexColor().toCssString();
}