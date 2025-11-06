import "package:color/color.dart";

class GradientEntry {
  final num point;
  final Color color;
  
  GradientEntry(this.point, this.color);
  
  @override
  String toString()
    => "[${this.point},${this.color}]"
}

abstract class QROption<V> {
  final String key;
  final V value;
  
  Option(this.key, this.value);
  
  String get valueAsStr;
  List<Option> get asList => <Option>[this];
  
  @override
  String toString()
    => "${this.key}=${this.valueAsStr}";
  
  static QROptionString get str(String key, String value)
    => QROptionString(key, value);
  static QROptionNum get nr(String key, num value)
    => QROptionNum(key, value);
  static QROptionUri get uri(String key, Uri value)
    => QROptionUri(key, value);
  static QROptionColor get color(String key, Color value)
    => QROptionColor(key, value);
  static QROptionGrad get grad(String key, GradientEntry value)
    => QROptionGrad(key, value);
}

class QROptionString extends QROption<String> {
  QROption(super.key, super.value);
  
  @override
  String get valueAsStr => this.value;
}

class QROptionNum extends QROption<num> {
  QROption(super.key, super.value);
  
  @override
  String get valueAsStr => this.value.toString();
}

class QROptionUri extends QROption<Uri> {
  QROption(super.key, super.value);
  
  @override
  String get valueAsStr => this.value.toString();
}

class QROptionColor extends QROption<Color> {
  QROption(super.key, super.value);
  
  @override
  String get valueAsStr => this.value.toHexColor().toCssString();
}

class QROptionGrad extends QROption<List<GradientEntry>> {
  QROption(super.key, super.value);
  
  @override
  String get valueAsStr => "[" + this.value.map<String>((GradientEntry ge) => ge.toString()).join(",") + "]";
}

class DesignQR {
  // https://emn178.github.io/online-tools/qr-code/?input=https%3A%2F%2Flocaldb.dev-pack.org%2Fportal&type=svg&size=680&padding=16&ec=H&dot_option_type=classy&dot_option_color_type=linear&dot_option_gradient_color=%5B%5B6.021505376344086%2C%22%23314e7a%22%5D%2C%5B90.86021505376344%2C%22%234A76B9%22%5D%5D&dot_option_rotation=135&corners_square_option_type=dot&corners_square_option_color=%23314e7a&corners_dot_option_type=dot&corners_dot_option_color=%23e73817&background_option_color=%23fff&image_type=url&image=https%3A%2F%2Favatars.githubusercontent.com%2Fu%2F231417452%3Fs%3D400%26u%3Df80b4c33d7e6d109d4a327c9fce94f832de8c535%26v%3D4&image_size=0.2&image_margin=0.75&image_show_background=0
  final Uri targetUrl;
  final Uri? bgImageUrl;
  final ImageKind kind;
  final int size;
  final int padding;
  
  const DesignQR(this.targetUrl, {String? bgImage, this.kind = ImageKind.png, this.size = 680, this.padding = 16}):
    this.bgImageUrl　= bgImage;
  List<Option> get bgOptionsOr
    => this.bgImageUrl == null ? <Option>[] : DesignQR.bgOptions(this.bgImageUrl);
  String get nukedUrl
    => "${DesignQR.baseUrl}?${this._buildOptions()}";
  
  String call()
    => Uri.encodeFull(this.nukedUrl);
  Uri asUri() => Uri.parse(this());
  String _buildOptions()
    => DesignQR._optionsAsStr(
        <Option>[
          Option.uri("input", this.targetUrl),
          Option.str("type", this.kind.str),
          Option.nr("size", this.size),
          Option.nr("padding", this.padding),
        ]
        .followedBy(DesignQR.basicOptions)
        .followedBy(DesignQR.bgOptionsOr)
      );
  
  static Uri baseUrl = Uri.parse("https://emn178.github.io/online-tools/qr-code/");
  static String _optionsAsStr(List<Option> options)
    => options.map<String>((Option o) => o.toString()).join("&");
  static List<Option> basicOptions
    = <Option>[
        Option.str("ec", "H"),
        Option.str("dot_option_type", "classy"),
        Option.str("dot_option_color_type", "linear"),
        Option.grad("dot_option_gradient_color", [
          GradientEntry(6.021505376344086, "#314e7a"),
          GradientEntry(90.86021505376344, "#4A76B9")]),
        Option.nr("dot_option_rotation", 135),
        Option.str("corners_square_option_type", "dot"),
        Option.color("corners_square_option_color", HexColor("314e7a")),
        Option.str("corners_dot_option_type", "dot"),
        Option.color("corners_dot_option_color", HexColor("e73817")),
        Option.color("background_option_color", RgbColor.name("white")),
      ];
  static List<Option> bgOptions(Uri bgImage)
    = <Option>[
       Option.nr("image_show_background": 0),
        Option.uri("image", bgImage),
        Option.nr("image_size": 0.2),
        Option.nr("image_margin": 0.75),
      ];
}

enum ImageKind {
  svg("svg"), png("png"), jpg("jpg");
  
  ImageKind(this.str);
  
  final String str;
}

