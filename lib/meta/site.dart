import "package:color/color.dart";

import "package:the_citizens/common/core.fs.dart";
import "package:the_citizens/sty/color.dart";

class SiteMeta {
  final bool interim;
  
  const SiteMeta(this.interim);
  
  final String name = "地域民botポータル";
  final String name2 = "LocalDB: Portal";
  final String desc = "地域民botに関する情報を纏めた、地域民botを一覧・検索出来る、地域民botのためのデータベース的ポータルサイト";
  final Uri fav = Meta.assets.favicon;
  final Color = Colors.core;

  // Domains & Urls
  Uri get portalDomain = this.hostDomain(this.portalSub);
  String get mailDomain = this.hostDomainStr(this.mailSub);
  String get siteDomain = this.hostDomainStr(this.siteSub);
  
  final String domainBase = "example.net";
  
  final String portalSub = "portal";
  final String mailSub = "ms";
  final String siteSub = "site";
  
  Uri hostDomain(String sub)
    => interim ? Uri.https("localdb.dev-pack.org", "/$sub/") : Uri.https("$sub.${this.domainBase}", "/");
  String hostDomainStr(String sub)
    => this.hostDomain(sub).authority;

  Uri hostUrl(List<String> path)
  => this.portalDomain.cd(path);

  // https://raw.githubusercontent.com/the-citizens/the_citizens/refs/heads/
  final Uri rawDomain = Uri.https("raw.githubusercontent.com", "/the-citizens/the_citizens/refs/heads/");
  Uri rawUri(List<String> path)
    => rawDomain.cd(path);
}