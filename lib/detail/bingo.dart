import "dart:math" show Point;
import "package:the_citizens/common/collection.dart";
import "package:the_citizens/error/bingo.dart";

typedef LocatedQuestion<B extends Bingo> = LocatedQAPart<B, BingoQuestion<B>>;
typedef LocatedAnswer<B extends Bingo> = LocatedQAPart<B, BingoAnswer<B>>;

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
      throw IllegalBingoFmtError<B>.point(arr, all);
    
    List<int> r = Bingo.questionRange(width);
    List<int> nrs = questions.map<int>((BingoQuestion<B> qe) => qe.number).toList();
    
    if (!r.every((int re) => nrs.contains(re))) {
      throw IllegalBingoFmtError<B>.nr(nrs, r);
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
      throw CenterIsNotSelectableError<B>.move();
    }
    int aPos = this._arrangement
      .indexOf(a);
    int bPos = this._arrangement
      .indexOf(b);
    this._arrangement[aPos] = b;
    this._arrangement[bPos] = a;
  }

  BingoResult<B> answer(List<BingoAnswer<B>> answers) {
    List<int> qNrs = this._questions.map<int>((BingoQuestion<B> qe) => qe.number).toList();
    List<LocatedAnswer<B>> las = answers
      .map<LocatedAnswer<B>>((BingoAnswer<B> ae) {
        if (qNrs.exists(ae.number)) {
          return LocatedAnswer<B>(this._arrangement(ae.number), ae);
        } else {
          throw NoSuchAsBingoNrError<B>(ae.number);
        }
      }
      .toList();
    return BingoResult<B>._(this, las, this.center);
  }
}

class BingoResult<B extends Bingo> {
  final BingoSquare<B> base;
  final List<LocatedAnswer<B>> _answers;
  final String center;

  BingoResult._(this.base, this._answers, this.center);

  List<LocatedQuestion<B>> get _questions
    => this.base._questions
      .map<LocatedQuestion<B>>((BingoQuestion<B> qe) => LocatedQAPart<B, BingoQuestion<B>>(this.base._arrangement[qe.number], qe))
      .toList();
  List<LocatedQuestion<B>> get questions
    => <LocatedQuestion<B>>[...(this._questions)];
  List<LocatedAnswer<B>> get answers
    => <LocatedAnswer<B>>[...(this._answers)];
  P _qaPartOf<P extends BingoQAPart<B>>(List<P> qaPart, Point<int> pos) {
    if (this.base.isCenter(pos)) {
      throw CenterIsNotSelectableError<B>.bundle();
    }
    if (!this.base.isInternal(pos)) {
      throw ExternalOfBingoError<B>(pos, width);
    }
    return qaPart
      .where((LocatedQAPart<B, P> pe) => pe.position == pos)
      .single.qa;
    
  }
  BingoQuestion<B> questionOf(Point<int> pos)
    => this._qaPartOf<BingoQuestion<B>>(this._questions, pos);
  BingoAnswer<B> answerOf(Point<int> pos)
    => this._qaPartOf<BingoAnswer<B>>(this._answers, pos);
  
  ({String symbol, String label}) render(int x, int y)
    => (
        symbol: this.answerOf(Point<int>(x, y)).status.symbol,
        label: this.questionOf(Point<int>(x, y)).label
      );

  bool isBingo(Line line)
    => line.points(this.base.width)
      .map<bool>((Point<int> pos) {
        if (this.base.isCenter(pos)) {
          return true;
        }
        return this._answers
          .where((LocatedAnswer<B> lae) => lae.position == pos)
          .single.qa
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
sealed class BingoQAPart<B extends Bingo> {
  final int number;
}
class BingoQuestion<B extends Bingo> extends BingoQAPart<B> {
  final String label;
  final String desc;

  const BingoQuestion(super.number, this.label, [this.desc = ""]);
  
  BingoAnswer<B> answer(CheckMark status, [String addition = ""])
  => BingoAnswer<B>(this.number, status, addition);
}

class BingoAnswer<B extends Bingo> extends BingoQAPart<B> {
  final CheckMark status;
  final String addition;

  const BingoAnswer(super.number, this.status, [this.addition = ""]);
}

extension type LocatedQAPart<B extends Bingo, P extends BingoQAPart<B>>(Point<int> position, P qa) {}

extension type Line (Axis axis, int pos) {
  List<Point<int>> points(int width)
   => List<Point<int>>.generate(width,
   (int con) => this.axis == Axis.x ? Point<int>(pos, con) : Point<int>(con, pos));
}

