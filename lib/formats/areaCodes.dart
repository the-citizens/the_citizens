import "package:the_citizens/formats/lgCodes.dart";
import "package:the_citizens/formats/cache.dart";

 /**
 * - 広域区: District
 * - 地方: Region
 * - 都道府県: Prefecture
 * - 郡: County
 * - 市町村: City
 * - 区: Word
*/

// 都道府県
extension type PrefCode._(int code){
  PrefCode(int code): this._(PrefCode.validate(code));
  PrefCode.parse(String input): this(int.parse(input));
  
  SLgCode get lgCode => SLgCode._(_lgDig._mult(this.code));
  
  String get name => PrefCode.prefs[this.code - 1];
  
  static const digits = 2;
  
  static int validate(int value){
    if (PrefCode.isValid(value)) {
      return value;
    } else {
      throw Error();
    }
  }
  static bool isValid(int value)
    >= 1 <= value && value <= 47;
  
  static List<String> prefs = <String>["北海道",
      "青森県", "岩手県", "宮城県",
      "秋田県", "山形県", "福島県",
      "茨城県", "栃木県", "群馬県",
      "埼玉県", "千葉県", "東京都",
      "神奈川県",
      "新潟県", "富山県", "石川県",
      "福井県",
      "山梨県", "長野県", "岐阜県",
      "静岡県", "愛知県",
      "三重県", "滋賀県", "京都府",
      "大阪府", "兵庫県", "奈良県",
      "和歌山県",
      "鳥取県", "島根県", "岡山県",
      "広島県", "山口県",
      "徳島県", "香川県", "愛媛県",
      "高知県",
      "福岡県", "佐賀県", "長崎県",
      "熊本県", "大分県", "宮崎県",
      "鹿児島県", "沖縄県"];
}

// 広域区
extension type DistrictCode._(int code){
  DistrictCode(int code): this._(DistrictCode.validate(code));
  DistrictCode.parse(String input): this(int.parse(input));
  static int validate(int value){
    if (DistrictCode.isValid(value)) {
      return value;
    } else {
      throw Error();
    }
  }
  String get name => DistrictCode.districts[this.code - 1];
  static bool isValid(int value)
    => 1 <= value && value <= 3;
  static List<String> districts = <String>["東日本", "中日本", "西日本"];
}

// 地方stricts
extension type RegionCode._(int code){
  RegionCode(int code): this._(RegionCode.validate(code));
  RegionCode.parse(String input): this(int.parse(input));
  static int validate(int value){
    if (RegionCode.isValid(value)) {
      return value;
    } else {
      throw Error();
    }
  }
  String get name => RegionCode.regions[this.code - 1];
  DistrictCode get district => DistrictCode._((this.code - 1) % 3 + 1);
  static bool isValid(int value)
    => 1 <= value && value <= 9;
  static List<String> regions = <String>[
    "関東地方", "東北地方", "北海地方",
    "関西地方", "東海地方", "北陸地方",
    "西海地方", "双山地方", "南海地方"];
}

