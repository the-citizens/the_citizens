import "package:the_citizens/error/http.dart" show NoSuchHeaderError;

enum StarAllowLevel {
  all(4), sub(3), suffix(2), params(1), none(0);

  StarAllowLevel(this.level);

  final int level;

  bool get allowedOnTop => this.level >= 4;
  bool get allowedOnSub => this.level >= 3;
  bool get allowedOnSuffix => this.level >= 2;
  bool get allowedOnParam => this.level >= 1;
}

class MimeType {
  final String top;
  final String sub;
  final Map<String, String> param;
  final String suffix;
  final String ext;
  
  const MimeType(this.top, this.sub,{this.param = const <String, String>{}, this.suffix = "", this.ext = ""});
  const MimeType.text(this.sub,{this.param = const <String, String>{}, this.suffix = "", this.ext = ""}): this.top = "text";
  const MimeType.image(this.sub,{this.param = const <String, String>{}, this.suffix = "", this.ext = ""}) this.top = "image";
  const MimeType.audio(this.sub,{this.param = const <String, String>{}, this.suffix = "", this.ext = ""}) this.top = "audio";
  const MimeType.video(this.sub,{this.param = const <String, String>{}, this.suffix = "", this.ext = ""}) this.top = "video";
  const MimeType.app(this.sub,{this.param = const <String, String>{}, this.suffix = "", this.ext = ""}) this.top = "application";
  const MimeType.model(this.sub,{this.param = const <String, String>{}, this.suffix = "", this.ext = ""}) this.top = "model";
  const MimeType.font(this.sub,{this.param = const <String, String>{}, this.suffix = ""}) this.top = "font";
  const MimeType.multi(this.sub,{this.param = const <String, String>{}, this.suffix = "", this.ext = ""}) this.top = "multipart";
  const MimeType.massage(this.sub,{this.param = const <String, String>{}, this.suffix = "", this.ext = ""}) this.top = "massage";
  const MimeType.ex(this.sub,{this.param = const <String, String>{}, this.suffix = "", this.ext = ""}) this.top = "example";
  const MimeType.chem(this.sub,{this.param = const <String, String>{}, this.suffix = "", this.ext = ""}) this.top = "chemical";
  
  String suffixPlus = this.suffix == "" ? this.suffix : "+${this.suffix}";
  String paramAsString([bool verbose = false]) => (verbose ? "\n" : "; ") + this.param.entries.map<String>((MapEntry<String, String> e) => verbose ? "\t${e.key}: ${e.value}" : "; ${e.key}=${e.value}").join(verbose ? "\n" : "; ") + (verbose ? "\n" : "");
  @override
  bool operator ==(Object other){
    // type comparing 1 (String) & parse
    if (other is String) {
      return this == MimeType.parse(other);
    // type comparing 2 (same)
    } else if (other is MimeType) {
      // top comparing
      if (this.top != other.top) {
        return false;
      }
      // sub comparing
      if (this.sub != "*" && other.sub != "*") {
        if (this.sub != other.sub) {
          return false;
        }
      }
      // suffix comparing
      if (this.suffix != "" && other.suffix != "") {
        if (this.suffix != other.suffix) {
          return false;
        }
      }
      // param comparing
      if (
        this.param.entries
          .every((MapEntry<String, String> te)
            => other.param.entries
              .any((MapEntry<String, String> oe)
                => te.key == oe.key
                  && te.value == oe.value))) {
        return true;
      }
    } else {
      return false;
    }
  }
  
  @override
  String toString([bool verbose = false])
    => verbose ? "Top: ${this.top}\nSub: ${this.sub}\nSuffix: ${this.suffix}\nParams:${this.paramAsString(verbose)}" : "${this.top}/${this.sub}${this.suffixPlus}${this.paramAsString(verbose)}";
  static const List<String> acceptTops = <String>["text", "image", "audio", "video", "application", "model", "font", "multipart", "massage", "example", "chemical"];
  static const List<String> acceptSuffixes = <String>["tlv", "csv", "xml", "yaml", "json", "json-seq", "ber", "der", "cbor", "cbor-seq", "zstd", "zip", "gzip", "sqlite3", "jwt", "sd-jwt", "jer", "cwt", "fastinfoset", "wbxml", "cose", "uper"];
  static const KnownMimeTypes knowns = const KnownMimeTypes();
  
  static RegExp re = RegExp(r"^(?<top>[a-z](-?[a-z0-9]+)*)/(?<sub>([a-z](-?[a-z0-9]+)*\.)*[a-z](-?[a-z0-9]+)*)(+(?<suffix>[a-z](-?[a-z0-9]+)*))?(?<params>(; *([a-z](-?[a-z0-9]+)*)=([a-z](-?[a-z0-9]+)*)*))$");
  static RegExp unitRe = RegExp(r"^[a-z](-?[a-z0-9]+)*$");
  static RegExp paramsDlmRe = RegExp(r"; ?");
  
  static void test({required List<MimeType> accept, required MimeType coming}){
    if (accept.every((MimeType cand) => coming != cand)) {
      throw MimeTypeError(accept: accept, coming: coming);
    }
  }
  static bool isValidFmtValue(String input, {bool allowVoided = false, bool allowStar, bool allowTree = false}){
    if (allowVoided && input == "") {
      return true;
    }
    if (allowStar && input == "*") {
      return true;
    }
    if (allowTree) {
      return input.split(".")
        .every((String el)
          => MimeType.isValidFmtValue(el,
            allowVoided: allowVoided, 
            allowStar: allowStar, 
            allowTree: false));
    return MimeType.unitRe
      .hasMatch(input.toLowerCase());
    }
  }
  static bool isValidFmtMime(MimeType mime, {StarAllowLevel allowStar = StarAllowLevel.none})
    => MimeTypeError.isValidFmtValue(mime.top, allowStar: allowStar.allowedOnTop)
      && MimeTypeError.isValidFmtValue(mime.sub, allowTree: true, allowStar: allowStar.allowedOnSub)
      && MimeTypeError.isValidFmtValue(mime.suffix, allowStar: allowStar.allowedOnSuffix)
      && mime.params.entries.every((MapEntry<String, String> pe)
        => MimeTypeError.isValidFmtValue(pe.key, allowVoided: true, allowStar: allowStar.allowedOnParam)
          && MimeTypeError.isValidFmtValue(pe.value, allowVoided: true, allowStar: allowStar.allowedOnParam));
  static bool isValidMime(MimeType mime, {bool valueTested = false, StarAllowLevel allowStar = StarAllowLevel.none}) {
    if (!valueTested) {
      if (!MimeType.isValidFmtMime(mime, allowStar: allowStar)) {
        return false;
      }
    }
    if (!MimeType.acceptTops.contains(mime.top)) {
      return false;
    }
    if (!MimeType.acceptSuffixes.contains(mime.suffix) && mime.suffix != "") {
      return false;
    }
    return true;
  }
  
  static MimeType parse(String input){
    Iterable<Match> allMatch = MimeType.re.allMatches(input);
    if (allMatch.length < 1) {
      throw FormatException("The input hasn't valid format for MIME Content Type: $input");
    }
   Match match = allMatch.first;
   
    List<String> groupNames = match.groupNames.toList();
    if (!groupNames.contains("top") || (!groupNames.contains("sub")) {
      throw 0;
    }
    
    Iterable<MapEntry<String, String>> p = <MapEntry<String, String>>[];
    if (groupNames.contains("params")) {
      p = input
        .split(MimeType.paramsDlmRe)
        .where((String s) => s.contains("="))
        .map<MapEntry<String, String>>((String s) {
          skv = s.split("=");
          return MapEntry<String, String>(skv[0], skv[1]);
        });
    }
    return MimeType(
        match.namedGroup("top"),
        match.namedGroup("sub"),
        suffix: groupNames.contains("suffix") ? match.namedGroup("suffix") : "",
        params: 
      );
  }
  static MimeType? tryParse(String input){
    try {
      return MimeType.parse(input);
    } on FormatException catch (_) {
      return null;
    }
  }
  static MimeType fromHeaders(Map<String, String> headers){
    if (headers.containsKey("Content-Type")) {
      return MimeType.parse(headers["Content-Type"]!);
    } else {
      throw NoSuchHeaderError("Content-Type");
    }
  }
}

class KnownMimeTypes {
  const KnownMimeTypes();
  
  // Documents
  const MimeType html = const MimeType.text("html", ext: "html");
  const MimeType md = const MimeType.text("markdown", ext: "md");
  const MimeType pdf = const MimeType.app("pdf", ext: "pdf");
  const MimeType text = const MimeType.text("plain", ext: "txt");
  // Styles & Programs
  const MimeType css = const MimeType.text("css", ext: "css");
  const MimeType js = const MimeType.text("javascript", ext: "js", ext2: "mjs");
  const MimeType dart = const MimeType.text("dart", ext: "dart", ext2: "dt");
  // Data Descriptions
  const MimeType json = const MimeType.app("json", ext: "json");
  const MimeType yaml = const MimeType.app("yaml", ext: "yaml", ext2 = "yml");
  const MimeType csv = const MimeType.text("csv", ext: "csv");
  const MimeType tsv = const MimeType.text("tab-separated-values", ext: "tsv");
  const MimeType xml = const MimeType.app("xml", ext: "xml");
  // Images
  const MimeType png = const MimeType.text("png", ext: "png");
  const MimeType jpg = const MimeType.text("jpeg", ext: "jpg", ext2: "jpeg");
  const MimeType svg = const MimeType.text("svg", suffix: "xml", ext: "svg");
  const MimeType webp = const MimeType.text("webp", ext: "webp");
  // Audios
  const MimeType wav = const MimeType.audio("wav", ext: "wav", ext2: "wave");
  const MimeType mp3 = MimeType.audio("mpeg", ext: "mpg", ext2: "mpeg");
  // Videos
  const MimeType mp4 = const MimeType.video("mp4", ext: "mp4");
  // Fonts
  const MimeType ttf = const MimeType.font("ttf", ext: "ttf");
  const MimeType otf = const MimeType.font("otf", ext: "otf");
  const MimeType woff = const MimeType.font("woff", ext: "woff");
  // MS Offices
  const MimeType excel = const MimeType.app("vnd.openxmlformats-officedocument.spreadsheetml.sheet", ext: "xslx");
  const MimeType word = const MimeType.app("vnd.openxmlformats-officedocument.wordprocessingml.document", ext: "docs");
  const MimeType powerpoint = const MimeType.app("vnd.openxmlformats-officedocument.presentationml.presentation", ext: "pptx");
  // Archives
  const MimeType zip = const MimeType.app("zip", ext: "zip");
  const MimeType xz = const MimeType.app("x-xz", ext: "xz");
  const MimeType zstd = const MimeType.app("zstd", ext: "zst");
  const MimeType gzip = const MimeType.app("x-gzip", ext: "gz");
  const MimeType bzip = const MimeType.app("x-bzip", ext: "bz");
  const MimeType tar = const MimeType.app("x-tar", ext: "tar");
  
}

class MimeTypeError implements Exception {
  final List<MimeType> accept;
  final MimeType coming;
  
  const MimeTypeError({required this.accept, required this.coming});
  
  @override
  String toString() => "Acceptable MIME Content Types are ${this.accept}, but the type of what came is ${this.coming} that is not match with acceptable ones.";
}