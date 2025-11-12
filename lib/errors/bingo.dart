import "dart:math" show Point;
import "package:the_citizens/detail/bingo.dart" show Bingo;

abstract class BingoError<B extends Bingo> implements Exception {
  String get massage;

  @override
  String toString() => "Error on Bingo of type ${B}: ${this.massage}";
}

class IllegalBingoFmtError<B extends Bingo> extends BingoError<B> {
  final List<Object> target;
  final List<Object> expected;
  
  IllegalBingoFmtError.point(List<Point<int>> target, List<Point<int>> expected):
    this.target = target,
    this.expected = expected;
  IllegalBingoFmtError.nr(List<int> target, List<int> expected):
    this.target = target,
    this.expected = expected;
  String _elementStr(Object el) {
    if (el is Point<int>) {
      return "(${el.x}, ${el.y})";
    } else {
      return el.toString();
    }
  }

  @override
  String get massage {
    if (this.target is! List<int>
      || this.target is! List<Point<int>>
      || this.expected is! List<int>
      || this.expected is! List<Point<int>>) {
      throw 0;
    }
    return "${this.expected.map<String>((Object o) => this._elementStr).toList()}, but got ${this.target.map<String>((Object o) => this._elementStr).toList()}";
  }
}

class CenterIsNotSelectableError<B extends Bingo> extends BingoError<B> {
  final String _op;

  CenterIsNotSelectableError.bundle():
    this._op = "bundle";
  CenterIsNotSelectableError.move():
    this._op = "move";
  
  @override
  String get massage => "A kind of to ${this._op} is attempted, but center position is not operatable without reading";
}

class ExternalOfBingoError<B extends Bingo> extends BingoError<B> {
  final Point<int> pos;
  final int width;
  
  ExternalOfBingoError(this.pos, this.width);
  
  @override
  String get massage => "Position (${this.pos.x}, ${this.pos.y}) is out of Bingo area, from (0, 0) to (${this.width - 1}, ${this.width - 1})";
}

class NoSuchAsBingoNrError<B extends Bingo> extends BingoError<B> {
  final int number;

  NoSuchAsBingoNrError(this.number);
  
  @override
  String get massage => "Nr. ${this.number} is not exist on the questions";
}