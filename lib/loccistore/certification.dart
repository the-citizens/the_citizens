import "dart:convert";
import "dart:typed_data";

import "package:symbol_sdk/utils/converter.dart";
import "package:es_compression/zstd.dart";
import "package:ini/ini.dart";

import "package:the_citizens/common/binary.dart";
import "package:the_citizens/common/secure.dart";

class LSCert {
  factory LSCert.fromIni(Config config){
    /// need impl.
    throw UnimplementedError();
  }
  factory LSCert.fromNukedBytes(List<int> bytes)
    => LSCert.fromIni(Config.fromString(utf8.decode(bytes)));
  factory LSCert.fromBytes(List<int> bytes, PublicKeyParameter<PublicKey> key){
  keccak256hmacECDSASigner.init(false, key);

  final List<int> hl = Uint8List.fromList(bytes.sublist(0, 2))
    .toUint(BinaryUnitWidth.half);
  final int version = <int>[hl[0] >> 2, (hl[0] & 3) << 2 + hl[1] >> 2].toUint(BinaryUnitWidth.half);
  final int padCnt = hl[1] & 3;
  final int byLen = Uint8List.fromList(bytes.sublist(2, 4))
    .toUint(BinaryUnitWidth.half) * 4;
  final int sigOffset = byLen + 4;

  ECSignature sig = ECSignature(uint8ListToBigInt(bytes.sublist(sigOffset, sigOffset + 32)), uint8ListToBigInt(bytes.sublist(sigOffset + 32, sigOffset + 64)));
  List<int> payload = bytes.sublist(4, sigOffset - padCnt);

  bool b = keccak256hmacECDSASigner
    .verifySignature(Uint8List.fromList(payload), sig);

  if(version == 1 && b) {
    return LSCert
      .fromNukedBytes(zstd.decode(payload));
    } else {
      throw Error();
    }
  }

  Config toIni() {
    /// need impl.
    throw UnimplementedError();
  }
  List<int> toNukedBytes() => utf8.encode(this.toIni().toString());
  List<int> toBytes(PrivateKeyParameter<PrivateKey> key){
    final priv = ParametersWithRandom<PrivateKeyParameter<PrivateKey>>(key, fortuna);

    const int version = 1;

    final List<int> zipped = zstd
      .encode(this.toNukedBytes());
    final List<int> encoded = BinaryUnitWidth.word
      .padded(zipped);
    final int len = BinaryUnitWidth.word.lengthOf(zipped);
    final int padCnt = BinaryUnitWidth.word
      .padLen(zipped.length);
    final List<int> vl = version.toHalf();
    final List<int> hl = <int>[vl[0] << 2 + vl[1] >> 2, vl[1] << 2 + padCnt];

    keccak256hmacECDSASigner.init(true, priv);
    final ECSignature sig = keccak256hmacECDSASigner
      .generateSignature(Uint8List.fromList(zipped));

    List<int> r = BinaryUnitWidth.long
        .padded(bigintToUint8List(sig.r));
    List<int> s = BinaryUnitWidth.long
        .padded(bigintToUint8List(sig.s));

    return hl + encoded + r + s;
  }
}