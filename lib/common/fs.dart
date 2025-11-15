import "dart:io";

import "package:the_citizens/errors/mime.dart";

extension UriCD on Uri {
  Uri cd(Iterable<String> path)
    => this.replace(pathSegments: (this.pathSegments.isEmpty || this.pathSegments.last != "" ? this.pathSegments : this.pathSegments.take(this.pathSegments.length - 1)).followedBy(path));
    String get name => this.uri.pathSegments.last;
    bool test(Iterable<MimeType> accepts) => accepts.any((MimeType m) => this.name.endsWith(".${m.ext}") || this.name.endsWith(".${m.ext2}"));
    List<MimeType> detect(Iterable<MimeType> accepts) => accepts.where((MimeType m) => this.name.endsWith(".${m.ext}") || this.name.endsWith(".${m.ext2}")).toList();
}

extension FSCD on Directory {
  FSE cd<FSE extends FileSystemEntity>(Iterable<String> path){
    final Uri u = this.uri.cd(path);
    late final FileSystemEntity fse;
    if(FileSystemEntity.isFileSync(u.path)){
      fse = File.fromUri(u);
    }else if(FileSystemEntity.isDirectorySync(u.path)){
      fse = Directory.fromUri(u);
    }else{
      throw Error();
    }
    return fse as FSE;
  }
  String get name => this.uri.name;
  bool test(Iterable<MimeType> accepts) => this.uri.test(accepts));
  bool detect(Iterable<MimeType> accepts) => this.uri.detect(accepts));
}