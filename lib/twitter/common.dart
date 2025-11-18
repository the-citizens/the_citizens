import "package:twitter_api_v2/twitter_api_v2.dart";

import "package:the_citizens/common/binary.dart";


extension type TwUser{
  final Doub id;
  final String display;
  final String screen;
  final DateTime createdAt;
  final Uri iconImage;
  TwUser(this.id, this.display, this.screen, this.createdAt, this.iconImage);
  TwUser.from(UserData udata):
    this.id = Doub.parse(udata.id),
    this.display = udata.name,
    this.screen = udata.username,
    this.createdAt = udata.createdAt,
    this.iconImage = udata.profileImageUrl
  static Future<TwUser> fetchById(int id){
    
  }
  static Future<TwUser> fetchByScreen(String screen) async {
    throw UnimplementedError();
  }
  static Future<TwUser> fetchById(String screen) async {
    throw UnimplementedError();
  }
}

typedef TwUserGroup = ({String name, Iterable<TwUser> users});

class TwitterTool {
  static bool isValidHashTag(String tag){
    bool reject = (tag == "") 
    || (tag.length > TwitterTool.hashTagMaxLen) 
    || (TwitterTool.unavailableHashTagChars.any((String c) => tag.contains(c)))
    || (TwitterTool.onlyNumberRe.hasMatch(tag));
    return !reject;
  }
  static String validateHashTag(String tag){
    if (TwitterTool.isValidHashTag(tag)) {
      return tag;
    } else {
      throw Error();
    }
  }
  static bool isValidScreen(String screen){
    throw UnimplementedError();
  }
  static String validateScreen(String screen){
    if (TwitterTool.isValidScreen(screen)) {
      return screen;
    } else {
      throw Error();
    }
  }

  static RegExp onlyNumberRe = RegExp(r"^\d+$");
  static const int hashTagMaxLen = ;
  static const List<String> unavailableHashTagChars = const <String>["!", "&", "。", "、"];
}

class Twimg {
  static Uri base = Uri.https("pbs.twimg.com", "/");
  static Uri icon(String cls, String file) = Twimg.base.cd(<String>["profile_images", cls, file]);
  static Uri header(String high, String low, {int width = 1500, int height = 500}) = Twimg.base.cd(<String>["profile_banners", high, low, "${width}x$height"]);
}