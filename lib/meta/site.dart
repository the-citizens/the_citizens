import "package:color/color.dart";

import "package:the_citizens/common/core.fs.dart";
import "package:the_citizens/sty/color.dart";

class SiteMeta {
  final bool interim;
  
  const SiteMeta(this.interim);
  
  final String name = "地域民botポータル";
  final String name2 = "LocalDB: Portal";
  final String desc = "地域民botに関する情報を纏めた、地域民botを一覧・検索出来る、地域民botのためのデータベース的ポータルサイト";
  final Uri fav = this.rawDomain.cd(<String>[]);
  final Color = Colors.core;

  // Domains & Urls
  final Uri hostDomain = interim ? Uri.https("localdb.dev-pack.org", "/portal/") : Uri.parse("portal.example.org", "/");
  Uri hostUrl(List<String> path)
  => hostDomain.cd(path);

  // https://raw.githubusercontent.com/the-citizens/the_citizens/refs/heads/
  final Uri rawDomain = Uri.https("raw.githubusercontent.com", "/the-citizens/the_citizens/refs/heads/");
  Uri rawUri(List<String> path)
    => rawDomain.cd(path);
}