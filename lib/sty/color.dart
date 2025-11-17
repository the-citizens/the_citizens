import "package:color/color.dart";
import "package:jaspr/jaspr.dart" as j show Color;
import "package:image/image.dart" as im show Color;

class Colors {
  /// Core Color: 古代紫 #8c6589
  static const RgbColor core = RgbColor(0x8c, 0x65, 0x89);
  /// Ink Color: 没食子 #55718e
  static const RgbColor ink = RgbColor(0x55, 0x71, 0x8e);
  /// Paper Color: 羊皮紙 #ececd6
  static const RgbColor paper = RgbColor(0xec, 0xec, 0xd6);
  /// Marine Color: 海洋 #314e7a
  static const RgbColor marine = RgbColor(0x31, 0x4e, 0x7a);
  /// Cherry Color: 桜花 #ff94d1
  static const RgbColor cherry = RgbColor(0xff, 0x94, 0xd1);
  /// Hinomaru Color: 日章 #e73817
  static const RgbColor red = RgbColor(0xe7, 0x38, 0x17);
}

extension ColorEx<C extends Color> on C {
  String get css => this.toHexColor().toCssString();
  RgbColor get _rgb => this.toRgbColor();
  j.Color get jaspr => this._rgb.jaspr;
  j.Color jWithAlpha(int a) => this._rgb.jWithAlpha(a);
  im.Color get img => this._rgb.img;
  im.Color imWithAlpha(int a) => this._rgb.imWithAlpha(a);
}

extension ColorExRgb on RgbColor {
  j.Color get jaspr => j.Color.rgb(this.r as int, this.g as int, this.b as int);
  j.Color jWithAlpha(int a) => j.Color.rgba(this.r as int, this.g as int, this.b as int, a);
  im.Color get img {
    im.Color c = im.Color();
    c.setRgb(this.r, this.g, this.b);
    return c;
  }
  im.Color imWithAlpha(int a) {
    im.Color c = im.Color();
    c.setRgba(this.r, this.g, this.b, a);
    return c;
  }
}
}