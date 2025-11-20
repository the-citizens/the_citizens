export "package:the_citizens/meta/site.dart";
export "package:the_citizens/meta/assets.dart";
export "package:the_citizens/meta/team.dart";


class Meta {
  static const SiteMeta site = SiteMeta(true);
  static const Assets assets = Assets._(Meta.site);
  static const TeamMeta team = TeamMeta();
}