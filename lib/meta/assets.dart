import "package:the_citizens/meta/site.dart";

class Assets {
  final SiteMeta _site;
  final Uri dir = this._site.rawUri(<String>["assets", ""]);
  
  const Assets._(this._site);
  
  Uri file(String name, [String? group])
    => group == null ? this._site.rawUri(<String>["assets", name]) : this._site.rawUri(<String>["assets", group, name]);
  
  final favicon = this.file("favicon.ico", "logo");
  final logoSvg = this.file("Localmin_logo.svg", "logo");
  final logoPng = this.file("Localmin_logo.png", "logo");
}