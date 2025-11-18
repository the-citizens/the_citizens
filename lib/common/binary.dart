import "dart:typed_data";

enum BinaryUnitWidth {
  byte(8), half(16), word(32),
  doub(64), quod(128), long(256),
  sedec(512), trigind(1024);

  BinaryUnitWidth(this.size);

  final int size;

  int get bytes => this.size ~/ 8;

  lengthOf(List<int> base) => (base.length ~/ this.bytes) + (base.length % this.bytes == 0 ? 0 : 1);
  int padLen(int baseLen) => this.bytes - (baseLen % this.bytes);
  List<int> padding(int baseLen) => List<int>.generate(this.padLen(baseLen), (_) => 0);
  List<int> padded(List<int> base) => base + this.padding(base.length);
}

extension Uint2List on int {
  Uint8List toBinary(BinaryUnitWidth unit, [int offset = 0]){
    final b = ByteData(unit.bytes);

    switch(unit){
      case BinaryUnitWidth.byte:
        b.setUint8(offset, this);
      case BinaryUnitWidth.half:
        b.setUint16(offset, this);
      case BinaryUnitWidth.word:
        b.setUint32(offset, this);
      case BinaryUnitWidth.doub:
        b.setUint64(offset, this);
      default:
        throw UnimplementedError();
    }

    return b.buffer.asUint8List();
  }

  Uint8List toByte([int offset = 0])
    => this.toBinary(BinaryUnitWidth.byte, offset);
  Uint8List toHalf([int offset = 0])
    => this.toBinary(BinaryUnitWidth.half, offset);
  Uint8List toWord([int offset = 0])
    => this.toBinary(BinaryUnitWidth.word, offset);
  Uint8List toDouble([int offset = 0])
    => this.toBinary(BinaryUnitWidth.doub, offset);
}

extension List2Uint on Uint8List {
  int toUint(BinaryUnitWidth unit, [int offset = 0]) 
    => switch(unit) {
      BinaryUnitWidth.byte
        => this.buffer.asByteData().getUint8(offset),
      BinaryUnitWidth.half
        => this.buffer.asByteData().getUint16(offset),
      BinaryUnitWidth.word
        => this.buffer.asByteData().getUint32(offset),
      BinaryUnitWidth.doub
        => this.buffer.asByteData().getUint64(offset),
      _ => throw UnimplementedError(),
    };
}

class Doub {
  final int high;
  final int low;
  
  const Doub(this.high, this.low);
  const Doub.from(int ui32):
    this.high = 0,
    this.low = ui32;
  static Doub parse(String input){
    late String base;
    late String highS;
    late String lowS;
    //0xffffffff
    final int hexWide = 8;
    
    bool isDec = decUInt.hasMatch(input);
    bool isHex = hexUInt.hasMatch(input);
    bool isHex2 = hexUInt2.hasMatch(input);
    
    if (isDec) {
      BigInt big = BigInt.parse(input);
      return Doub((big >> 32).toInt(), (big & BigInt.from(0xffffffff)).toInt());
    } else if(isHex || isHex2){
      if (isHex) {
        base = input.substring(2);
      } else {
        RegExpMatch m = isHex2.firstMatch(input)!;
        
        if(!m.groupNames.contains("val")){
          throw 0;
        }
        base = m.group("val")!.replaceAll(" ", "");
      }
      
      if (base.length <= hexWide) {
        highS = "0";
        lowS = base;
      } else {
        highS = base.substring(0, base.length - hexWide);
        lowS = base.substring(base.length - hexWide);
      }
      
      return Doub(int.parse(highS, radix: 16), int.parse(lowS, radix: 16));
    } else {
      throw FormatException("input string is not decimal or hex integer format");
    }
  }
  String toHexString([bool? useAltHead = false]){
    String head = useAltHead == null ? "" : (useAltHead ? "xh" : "0x");
    String highS = (this.high == 0 ? "" : this.high.toRadixString(16);
    Strong lowSN = this.low.toRadixString(16);
    String lowS = (this.high == 0 ? lowSN : lowSN.padLeft(8, "0"));
  }
  
  @override
  String toString() {
    BigInt big = (BigInt.from(high) << 32) | BigInt.from(low);
    return big.toString();
  }
  @override
  bool operator ==(Object other)
    => other is Doub && this.high == other.high && this.low == other.low;
  @override
  int hashCode => Object.hash(this.high, this.low);
}

final RegExp hexUInt = RegExp(r"^(xh|0x)[0-9a-fA-F]+$");
final RegExp hexUInt2 = RegExp(r"^(xh|x16)\{(?<val>[0-9a-fA-F]{1,3}( ?[0-9a-fA-F]{4})*)\}$");
final RegExp decUInt = RegExp(r"^([0-9]|([1-9][0-9]+))$");