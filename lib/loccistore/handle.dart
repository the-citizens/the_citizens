import "package:the_citizens/common/binary.dart";
import "package:the_citizens/common/secure.dart";

extension type LSHandle._(String hl) {
  LSHandle(String handle): this.hl = LSHandle.validate(hl);

  factory LSHandle.generate(String screen, int id, DateTime createdAt, [DateTime? generatedAt]) {
  String sch = screen
      .split("")
      .map<int>((String chr) => chr.charCode)
      .where((int cc) => (65 <= cc && cc <= 90) || (97 <= cc && cc <= 122))
      .take(LSHandle.screenLen)
      .map<String>((int cc) => String.fromCharCode(cc))
      .join("");

  List<int> cat = createdAt
      .millisecondsSinceEpoch.toWord();
  List<int> gat = (generatedAt ?? DateTime.now())
      .millisecondsSinceEpoch.toWord();
  List<int> rd = fortuna.nextUint32().toWord();

  List<int> salt = <int>[
    cat[0] ^ rd[0], cat[1] ^ rd[1], cat[2] ^ 0, cat[3] ^ 0,
    gat[0] ^ rd[2], gat[1] ^ rd[3], gat[2] ^ 0, gat[3] ^ 0];

  List<int> hash = keccak256.process(
      Uint8List.fromList(
          id.toUint(BinaryUnitWidth.doub) + salt));
  String hah = hash.toRadixString(16)
       .substring(0, LSHandle.hashLen);

  return (sch + hah).toLowerCase();
}

  static LSHandle parse(String target) => LSHandle(target);
  static LSHandle? tryParse(String target) {
    try {
      return LSHandle.parse(target);
    } catch (_){
      return null;
    }
  }

  static String validate(String target) => LSHandle.isValid(target) ? target.toLowerCase() : throw Error("");
  static bool isValid(String target) => this.re.hasMatch(target.toLowerCase());
  static RegExp re = RegExp(r"^[a-z]{" + LSHandle.screenLen + r"}[a-z0-9]{" + LSHandle.hashLen + r"}$");

  static const int screenLen = 3;
  static const int hashLen = 3;
}