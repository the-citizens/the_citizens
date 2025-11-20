import "package:the_citizens/common/fs.dart";

// Domains & Urls
final Uri hostDomain = interim ? ""
Uri hostUrl(List<String> path)
  => hostDomain.cd(path);

// https://raw.githubusercontent.com/the-citizens/the_citizens/refs/heads/
final Uri rawDomain = Uri.https("raw.githubusercontent.com", "/the-citizens/the_citizens/refs/heads/");
Uri rawUri(List<String> path)
  => rawDomain.cd(path);

// Representative Members on Development & Management
