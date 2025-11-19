import "package:the_citizens/formats/areaCodes.dart";
import "package:the_citizens/formats/cache.dart";

// 自治体コード(総務省コード)
extension type SLgCode._(int code){
  SLgCode(int code): this._(SLgCode.validate(code));
  SLgCode.parse(String input): this(int.parse(input));
  
  PrefCode get pref => PrefCode._(_lgDig._high(this.code));
  
  static const digits = 5;
  
  static int validate(int value){
    if (SLgCode.isValid(value)) {
      return value;
    } else {
      throw Error();
    }
  }
  static bool isValid(int value)
    => PrefCode.isValid(_lgDig._high(value))
    && (_lgDig._low(value) == 0
      || (100 <= _lgDig._low(value)
        && _lgDig._low(value) <= 799));
}

