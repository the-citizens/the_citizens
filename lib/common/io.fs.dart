import "dart:io";

import "package:the_citizens/errors/mime.dart";
export "package:the_citizens/common/core.fs.dart";

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