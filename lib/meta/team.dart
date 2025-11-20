import "package:color/color.dart";

import "package:the_citizens/common/collection.dart";
import "package:the_citizens/sty/color.dart";
import "package:the_citizens/twitter/common.dart";

sealed class Contributor {
  final String name;
  final LeadSet<TwUser> twitter;
  final LeadSet<String> specify;
  final Color symbolColor;
  Contributor(this.name, this.twitter, this.specify, [Color? symbolColor]):
    super.symbolColor = symbolColor ?? Contributor.defaultSymbolColor;
  
  static Color defaultSymbolColor = Colors.paper;
}

final class Member extends Contributor {
  final bool isRepresentative;
  
  Member(this.isRepresentative, super.name, super.twitter, super.specify, [Color? symbolColor]):
    super.symbolColor = symbolColor ?? Contributor.defaultSymbolColor;
  Member.repr(super.name, super.twitter, super.specify, [Color? symbolColor]):
    super.symbolColor = symbolColor ?? Contributor.defaultSymbolColor,
    this.isRepresentative = true;
  Member.other(super.name, super.twitter, super.specify, [Color? symbolColor]):
    super.symbolColor = symbolColor ?? Contributor.defaultSymbolColor,
    this.isRepresentative = false;
}

final class Supporter extends Contributor {
  Supporter(super.name, super.twitter, super.specify, [Color? symbolColor]):
    super.symbolColor = symbolColor ?? Contributor.defaultSymbolColor;
}

final class Thanks extends Contributor {
  Thanks(super.name, super.twitter, super.specify, [Color? symbolColor]):
    super.symbolColor = symbolColor ?? Contributor.defaultSymbolColor;
}

class TeamMeta {
  
  const TeamMeta();
  
  String name = "";
  
  final TwUser portalBot = TwUser(
    Doub(0x1B494976, 0x805A3003),
    "地域民botをささえたい地域民ポータルbot＠半ば相馬・米沢市民＆大分県民ぼっと",
    "@Localmin_all",
    DateTime(2025, 09, 12, 01, 55, 36),
    Twimg.icon("1983450862317129728", "Oonpot9u.jpg"));

  // Representative and Other Members on Development & Management
  List<Member> members = <Member>[
    Member.repr("相馬人 (馬よ走れ)",
      LeadSet<TwUser>(0, <TwUser>[
        TwUser(Doub(0x1B4D3359, 0x68DA7000),
        "馬よ走れ・花よ咲け　相馬人ぼっと (相馬市＆南相馬市)　＠ 松川浦・馬陵城",
        "@Nma8s_Matsukawa",
        DateTime(2025, 09, 15, 02, 52, 25),
        Twimg.icon("1967288098234273792", "GsHkt3Tf.jpg")
        ),
        TwUser(Doub(0x121B3B9C, 0x6C14E001),
        "🍀眞󠄆磐姬󠄁 / 超越基底🕊️｜佐藤󠄁陽花󠄁/エヤイヌニタㇰ/藍徽󠄀陽/玻名城󠄀守珠",
        "@Distr_to_Yonder",
        DateTime(2020, 09, 12, 17, 43, 15),
        Twimg.icon("1597619078872858626", "aa3M1r0.jpg")
        ),
      ]),
      LeadSet<String>(-1, <String>[
        "",])),
    Member.repr("大分県民 (アツアツ)",
      LeadSet<TwUser>(0, <TwUser>[
        TwUser(Doub(0x1AA1B9EC, 0x601B7000),
        "アツアツな大分県民Bot",
        "@Hot_Oita_Bot",
        DateTime(2025, 05, 04, 22, 21, 03),
        Twimg.icon("1934240252685946881", "d_VQdKN0.jpg")
        ),
        TwUser(Doub(0x1687C34F, 0x835A2001),
        "めろんそーだ",
        "@mellllonsoda",
        DateTime(2023, 02, 09, 09, 37, 01),
        Twimg.icon("1939166091227353088", "jSV4_RG0.png")
        ),
      ]),
      LeadSet<String>(-1, <String>[
        "",""])),
    Member.other("大津市民 (南北に長すぎ)",
      LeadSet<TwUser>(0, <TwUser>[
        TwUser(Doub(0x1B01BE36, 0x5F5A7000),
        "南北に長すぎな大津市民ぼっと",
        "@Biwako_Otsu_bot",
        DateTime(2025, 07, 18, 12, 14, 03),
        Twimg.icon("1946971299252666369", "ebpHRFyo.jpg")
        ),
      ]),
      LeadSet<String>(-1, <String>[
        "データ作業マネジメント",])),
  ];

  // Supporters on Development & Management
  List<Supporter> supporters = <Supporter>[
    Supporter("岩国市民 (広島県民に)",
      LeadSet<TwUser>(0, <TwUser>[
        TwUser(Doub(0x1B30AA33, 0x48DB3001),
        "広島県民になりたかった岩国市民bot",
        "@Iwakuni_bot",
        DateTime(2025, 08, 23, 22, 55, 54),
        Twimg.icon("1965772698916913152", "fMHSatgv.jpg")
        ),
      ]),
      LeadSet<String>(-1, <String>[
        "データ作業",])),
    Supporter("郡上市民 (踊り明かす)",
      LeadSet<TwUser>(0, <TwUser>[
        TwUser(Doub(0x1A013C5B, 0xF0DB6003),
        "踊り明かす郡上市民bot",
        "@gujo_shimin_bot",
        DateTime(2024, 12, 31, 06, 35, 11),
        Twimg.icon("1873846164807946240", "cS92P_Xd.jpg")
        ),
      ]),
      LeadSet<String>(-1, <String>[
        "データ作業",])),
  ];

  // Special Thanks on Development & Management
  List<Thanks> thanks = <Thanks>[
    Thanks("広島市内民 (平和を愛する)",
      LeadSet<TwUser>(0, <TwUser>[
        TwUser(Doub(0x1ACD7787, 0x0D5B4000),
        "平和を愛する広島「市内」bot🍁 (広島市中区民bot)",
        "@hiroshinai_bot",
        DateTime(2025, 06, 07, 21, 44, 02),
        Twimg.icon("1931347098940940288", "4r4HDi38.jpg")
        ),
      ]),
      LeadSet<String>(-1, <String>[
        "シンボルマーク/アイコンの作成・提供",])),
    Thanks("久留米市民 (やわ麺育ち)",
      LeadSet<TwUser>(0, <TwUser>[
        TwUser(Doub(0x1AAD3302, 0xF49B0000),
        "やわ麺育ちな久留米市民bot",
        "@kurume_live0942",
        DateTime(2025, 05, 13, 20, 13, 07),
        Twimg.icon("1922263629229129730", "hgN29g72.jpg")
        ),
      ]),
      LeadSet<String>(-1, <String>[
        "地域民bot自己紹介フォーマットの作成・提供",])),
    Thanks("江東区民 (都会気取り)",
      LeadSet<TwUser>(0, <TwUser>[
        TwUser(Doub(0x1A14CEF0, 0xD8DA3000),
        "都会気取りの東京･江東区民bot🏙",
        "@koto_city_bot",
        DateTime(2025, 01, 15, 11, 26, 56),
        Twimg.icon("1947173216654401536", "vmgOePep.jpg")
        ),
      ]),
      LeadSet<String>(-1, <String>[
        "地域民botビンゴの作成・提供",])),
    Thanks("宮城県民 (いつも牛タンを)",
      LeadSet<TwUser>(0, <TwUser>[
        TwUser(Doub(0x1957D881, 0xC69A3005),
        "いつも牛タンを食べてるわけではない宮城県民bot🐂",
        "@miyagikenbot",
        DateTime(2024, 08, 21, 16, 56, 02),
        Twimg.icon("1967217084204789760", "JERgojWo.jpg")
        ),
      ]),
      LeadSet<String>(-1, <String>[
        "地域民botリスト (全国全員版) の作成・提供",])),
    Thanks("滋賀湖西民 (溺れかけ)",
      LeadSet<TwUser>(0, <TwUser>[
        TwUser(Doub(0x1AB7BC99, 0x38DBB000),
        "おぼれかけ/滋賀湖西民bot",
        "@shiga_koseimin",
        DateTime(2025, 05, 22, 00, 39, 15),
        Twimg.icon("1980224678275710976", "6CtfrzGo.jpg")
        ),
      ]),
      LeadSet<String>(-1, <String>[
        "地域民botリスト (地域分類版) の作成・提供",])),
  ];
  List<Thanks> frontiers = <Thanks>[
    Thanks("京都人 (みえっぱり)",
      LeadSet<TwUser>(0, <TwUser>[
        TwUser(Doub(0x13596CB1, 0x6955A007),
        "みえっぱりな京都人bot",
        "@kyoutojin_bot",
        DateTime(2021, 05, 17, 21, 15, 06),
        Twimg.icon("1394274836344578049", "AvaobxZU.jpg")
        ),
      ]),
      LeadSet<String>(-1, <String>[
        "地域民botの先駆者",])),
    Thanks("奈良県民 (卑屈)",
      LeadSet<TwUser>(0, <TwUser>[
        TwUser(Doub.from(0x6479966A),
        "卑屈な奈良県民bot🦌",
        "@nntnarabot",
        DateTime(2013, 08, 20, 21, 48, 07),
        Twimg.icon("1350670130448007169", "tvOMPVxc.jpg")
        ),
      ]),
      LeadSet<String>(-1, <String>[
        "地域民botの先駆者",])),
    Thanks("福岡市民 (バリカタ)",
      LeadSet<TwUser>(0, <TwUser>[
        TwUser(Doub(0x15199B54, 0xCB9A9001),
        "バリカタな福岡市民bot🍜",
        "@Barikata_FUK",
        DateTime(2022, 04, 30, 23, 57, 57),
        Twimg.icon("1538535113516265472", "HNBk_SIh.jpg")
        ),
      ]),
      LeadSet<String>(0, <String>[
        "地域民bot達の纏め役",
        "地域民bot達のDMグループ & Discordサーバの運営"])),
    Thanks("地域民bot広めたいbot",
      LeadSet<TwUser>(0, <TwUser>[
        TwUser(Doub(0x1491E952, 0x92DA4000),
        "地域民botを広めたい○○民bot",
        "@Somewhere_local",
        DateTime(2022, 01, 15, 14, 25, 21),
        Twimg.icon("1940691452897775620", "5aDcco96.jpg")
        ),
        TwUser(Doub(0x1974371F, 0x641B8002),
        "栃木県もしくは埼玉県の古河市民bot",
        "@Koganese",
        DateTime(2024, 09, 12, 17, 46, 40),
        Twimg.icon("1969391511411572747", "dczleFgl.jpg")
        ),
        TwUser(Doub(0x16E8F1C2, 0xD8DA3004),
        "すもふぃー",
        "@Smofy_bass",
        DateTime(2023, 04, 25, 21, 12, 26),
        Twimg.icon("1871789358757609472", "BGWSVJc_.jpg")
        ),
      ]),
      LeadSet<String>(0, <String>[
        "地域民bot達の歓迎・広報役",
        "地域民bot地図の作成"])),
  ];
  
  List<Contributor> get all = <Contributor>[]
    .followedBy(this.members)
    .followedBy(this.supporters)
    .followedBy(this.thanks)
    .followedBy(this.frontiers)
    .toList();
}