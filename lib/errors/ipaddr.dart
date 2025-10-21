typedef Checker<Source> = bool Function(Source);
typedef StrChecker = Checker<String>;

bool noChecker<S>(S _) => true;

enum IPAddrKind {
  /// v4 for IPv4, v6 for IPv6, unko for unknown.
  v4("IPv4", 4, IPAddr.isIPv4),
  v6("IPv6", 16, IPAddr.isIPv6),
  unko("unknown", 0, noChecker<String>);
  
  IPAddrKind(this.version, this.size, this.isIPvX);
  
  final String version;
  // byte length
  final int size;
  final StrChecker isIPvX;

  bool lenValidate(List<int> bytes) => bytes.isValidLen(this.size);
}
class IPAddr {
  final IPAddrKind kind;
  final List<int> addr;
  
  IPAddr._(this.kind, this.addr);
  factory IPAddr(IPAddrKind kind, List<int> addr){
    if ((kind == IPAddrKind.v4 && addr.isValidLen(4)) || (kind == IPAddrKind.v6 && addr.isValidLen(16)) || (kind == IPAddrKind.unko && addr.isValidLen(0))) {
      return IPAddr._(kind, addr);
    } else {
      throw InvalidIPAddrError(kind, addr);
    }
  }
  /// Address in 4 bytes of IPv4
  IPAddr.v4(List<int> addr):
    this.kind = IPAddrKind.v4,
    this.addr = addr.validateLen<InvalidIPAddrError>(4, () => InvalidIPAddrError(IPAddrKind.v4, addr));
  /// Address in 16 bytes of IPv6
  IPAddr.v6(List<int> addr):
    this.kind = IPAddrKind.v6,
    this.addr = addr.validateLen<InvalidIPAddrError>(16, () => InvalidIPAddrError(IPAddrKind.v6, addr));
  /// Voided Address of Unknown
  IPAddr.unko():
    this.kind = IPAddrKind.unko,
    this.addr = <int>[];
    
  static IPAddr parse(String src){
    if (IPAddr.isIP(src)) {
      if (IPAddr.isIPv4(src)) {
        //v4
        return IPAddr.v4(Uri.parseIPv4Address(src));
      } else {
        //v6
        return IPAddr.v6(Uri.parseIPv6Address(src));
      }
    } else {
      throw FormatException("Invalid Format as IPv4 or IPv6 Address", src);
    }
  }
  static IPAddr? tryParse(String src){
    try {
      return IPAddr.parse(src);
    } on FormatException catch (_) {
      return null;
    } on InvalidIPAddrError catch (_) {
      return null;
    }
  }
    
  static bool isIP(String src) => IPAddr.ip.hasMatch(src);
  static bool isIPv4(String src) => IPAddr.ipv4.hasMatch(src);
  static bool isIPv6(String src) => IPAddr.isIP(src) && !IPAddr.isIPv4(src);
  static RegExp ip = RegExp(r"((([0-9a-f]{1,4}:){7}([0-9a-f]{1,4}|:))|(([0-9a-f]{1,4}:){6}(:[0-9a-f]{1,4}|((25[0-5]|2[0-4]\d|1\d\d|[1-9]?\d)(\.(25[0-5]|2[0-4]\d|1\d\d|[1-9]?\d)){3})|:))|(([0-9a-f]{1,4}:){5}(((:[0-9a-f]{1,4}){1,2})|:((25[0-5]|2[0-4]\d|1\d\d|[1-9]?\d)(\.(25[0-5]|2[0-4]\d|1\d\d|[1-9]?\d)){3})|:))|(([0-9a-f]{1,4}:){4}(((:[0-9a-f]{1,4}){1,3})|((:[0-9a-f]{1,4})?:((25[0-5]|2[0-4]\d|1\d\d|[1-9]?\d)(\.(25[0-5]|2[0-4]\d|1\d\d|[1-9]?\d)){3}))|:))|(([0-9a-f]{1,4}:){3}(((:[0-9a-f]{1,4}){1,4})|((:[0-9a-f]{1,4}){0,2}:((25[0-5]|2[0-4]\d|1\d\d|[1-9]?\d)(\.(25[0-5]|2[0-4]\d|1\d\d|[1-9]?\d)){3}))|:))|(([0-9a-f]{1,4}:){2}(((:[0-9a-f]{1,4}){1,5})|((:[0-9a-f]{1,4}){0,3}:((25[0-5]|2[0-4]\d|1\d\d|[1-9]?\d)(\.(25[0-5]|2[0-4]\d|1\d\d|[1-9]?\d)){3}))|:))|(([0-9a-f]{1,4}:){1}(((:[0-9a-f]{1,4}){1,6})|((:[0-9a-f]{1,4}){0,4}:5[0-5]|2[0-4]\d|1\d\d|[1-9]?\d)(\.(25[0-5]|2[0-4]\d|1\d\d|[1-9]?\d)){3}))|:))|(:(((:[0-9a-f]{1,4}){1,7})|((:[0-9a-f]{1,4}){0,5}:((25[0-5]|2[0-4]\d|1\d\d|[1-9]?\d)(\.(25[0-5]|2[0-4]\d|1\d\d|[1-9]?\d)){3}))|:)))(%.+)?\s*$");
  static RegExp ipv4 = RegExp(r"^((25[0-5]|2[0-4][0-9]|1[0-9][0-9]|[1-9]?[0-9])\.){3}(25[0-5]|2[0-4][0-9]|1[0-9][0-9]|[1-9]?[0-9])$");
}

class InvalidIPAddrError implements Exception {
  final IPAddrKind kind;
  final List<int> addr;
  
  InvalidIPAddrError(this.kind, this.addr);
  
  @override
  String get massage => "The format of IP address is invalid: ${this.kind.version} expects ${this.kind.size} bytes of address, but got ${this.addr} (${this.addr.length})";
}

extension UnitValidate<I extends Iterable<int>> on I {
  I validateLen<E>(int len, E Function() onInvalid) => this.isValidLen(len) ? this : throw onInvalid();
  bool isValidLen(int len) => this.length == len;
}