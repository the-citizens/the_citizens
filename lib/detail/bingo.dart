import "dart:math" show Point;
import "package:the_citizens/common/collection.dart";

abstract class Bingo {
  static int centerCo(int width)
    => width ~/ 2 + 1;
  static List<Point<int>> allHoles(int width, [bool withCenter = false])
    => List<List<Point<int>?>>
      .generate(width, (int x)
        => List<Point<int>?>
          .generate(width, (int y) {
            if (!withCenter) {
              if (
                x == Bingo.centerCo(width)
                || y == Bingo.centerCo(width)) {
                return null;
              }
            }
            return Point<int>(x, y);
          }))
      .flatten.whereType<Point<int>>();
  static int questionCount(int width)
    => width * width - 1;
  static List<int> questionRange(int width)
    => List<int>.generate(
      Bingo.questionCount(width),
      (int i)=> i);
}

enum CheckMark {
  yes("○", true),
  no("✗", false),
  uncertain("△", false);

  const CheckMark(this.symbol, this.canBeMarked);

  final String symbol;
  final bool canBeMarked;
}

enum Axis {
  x,y;
  
  List<Line> lines(int width)
    => List<Line>.generate(width, (int pos) => Line(this, pos));
}

class BingoSquare<B extends Bingo> {
  final int width;
  final List<Point<int>> _arrangement;
  List<BingoQuestion<B>> _questions;
  final String center;

  BingoSquare._(this.width, this._arrangement, this._questions, this.center);
  factory BingoSquare(int width, List<BingoQuestion<B>> questions, [List<Point<int>>? arrangement]){
    List<Point<int>> all = Bingo.allHoles(width, false);
    List<Point<int>> arr = arrangement ?? all;
    
    if (!all.every((Point<int> pe) => arr.contains(pe))) {
      throw IllegalBingoFmtError.point(arr, all);
    
    List<int> r = Bingo.questionRange(width);
    List<int> nrs = questions.map<int>((BingoQuestion<B> qe) => qe.number).toList();
    
    if (!r.every((int re) => nrs.contains(re))) {
      throw IllegalBingoFmtError.nr(nrs, r);
    }
    return BingoSquare._(width, questions, arr);
  }
  Point<int> get centerPos {
    int pos = Bingo.centerCo(this.width);
    return Point<int>(pos, pos);
  }
  bool isCenter(Point<int> pos)
    => pos == this.centerPos;
  bool isInternal(Point<int> pos)
    => pos.x >= 0
      && pos.y >= 0
      && pos.x < this.width
      && pos.y < this.width;

  List<Point<int>> get arrangement
    => [...(this._arrangement)];
  List<BingoQuestion<B>> get questions
    => [...(this._questions)];

  void update(BingoQuestion<B> question) {
    int pos = this._questions.indexWhere((BingoQuestion<B> qe) => qe.number == question.number);
    this._questions[pos] = question;
  }
  void switchHole(Point<int> a, Point<int> b) {
    if (this.isCenter(a) || this.isCenter(b)) {
      throw CenterIsNotSelectableError.move();
    }
    int aPos = this._arrangement
      .indexOf(a);
    int bPos = this._arrangement
      .indexOf(b);
    this._arrangement[aPos] = b;
    this._arrangement[bPos] = a;
  }

  BingoResult<B> answer(List<BingoAnswer<B>> answers) {
    return BingoResult<B>._(this, , this.center);
  }
}

class BingoResult<B extends Bingo> {
  final BingoSquare<B> base;
  final List<LocatedAnswer<B>> _answers;
  final String center;

  BingoResult._(this.base, this._answers, this.center);

  List<LocatedAnswer<B>> get answers
    => [...(this._answers)];
  BingoAnswer<B> answer(Point<int> pos) {
    if (this.base.isCenter(pos)) {
      throw CenterIsNotSelectableError.bundle();
    }
    if (!this.base.isInternal(pos)) {
      throw ExternalOfBingoError(pos, width);
    }
    return this._answers
      .where((LocatedAnswer<B> ae) => ae.position == pos)
      .single.answer;
  }

  bool isBingo(Line line)
    => line.points(this.base.width)
      .map<bool>((Point<int> pos) {
        if (this.base.isCenter(pos)) {
          return true;
        }
        return this._answers
          .where((LocatedAnswer<B> lae) => lae.position == pos)
          .single.answer
          .status.canBeMarked;
      })
      .reduce((bool prev, bool curr) => prev && curr);

  List<Line> bingoLines({bool x = false, bool y = false}) {
    if (!x && !y) {
      return <Line>[];
    }
    if (x && y) {
      return this.bingoLines(x: true)
        .followedBy(this.bingoLines(y: true))
        .toList();
    }
    return (x ? Axis.x : Axis.y, pos)
      .lines(this.base.width)
      .where((Line le) => this.isBingo(le))
      .toList();
  }
  int bingoCount({bool x = false, bool y = false})
    => this.bingoLines(x: x, y: y).length;
}

class BingoQuestion<B extends Bingo> {
  final int number;
  final String label;
  final String desc;

  const BingoQuestion(this.number, this.label, [this.desc = ""])
  
  BingoAnswer<B> answer(CheckMark status, [String addition = ""])
  => BingoAnswer<B>(this.number, status, addition);
}

class BingoAnswer<B extends Bingo> {
  final int number;
  final CheckMark status;
  final String addition;

  const BingoAnswer(this.number, this.status, [this.addition = ""]);
}

extension type LocatedAnswer<B extends Bingo>(Point<int> position, BingoAnswer<B> answer) {}

extension type Line (Axis axis, int pos) {
  List<Point<int>> points(int width)
   => List<Point<int>>.generate(width,
   (int con) => this.axis == Axis.x ? Point<int>(pos, con) : Point<int>(con, pos));
}

class IllegalBingoFmtError {
  final List<Object> target;
  final List<Object> expected;
  
  IllegalBingoFmtError.point(List<Point<int>> target, List<Point<int>> expected):
    this.target = target,
    this.expected = expected;
  IllegalBingoFmtError.nr(List<int> target, List<int> expected):
    this.target = target,
    this.expected = expected;
}

class CenterIsNotSelectableError {
  final String _op;
  CenterIsNotSelectableError.bundle():
    this._op = "bundle";
  CenterIsNotSelectableError.move():
    this._op = "move";
}

class ExternalOfBingoError {
  final Point<int> pos;
  final int width;
  
  ExternalOfBingoError(this.pos, this.width);
}