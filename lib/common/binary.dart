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