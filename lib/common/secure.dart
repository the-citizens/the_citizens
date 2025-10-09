import "dart:typed_data";

export "package:pointycastle/macs/random/fortuna_random.dart";
export "package:pointycastle/macs/digests/sha3.dart";
export "package:pointycastle/macs/hmac.dart";
export "package:pointycastle/signers/ecdsa_signer.dart";

final FortunaRandom fortuna = FortunaRandom();
final SHA3Digest keccak256 = SHA3Digest(256);
final HMac keccak256hmac = HMac(keccak256, 512);
final ECDSASigner keccak256hmacECDSASigner = ECDSASigner(keccak256, keccak256hmac);