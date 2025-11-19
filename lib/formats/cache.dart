class _LgDig {
  static const int _demarc = 1000;
  static final _lgDig = _LgDig._inter();
  
  final List<_LgDigCache> _cache = <_LgDigCache>[];
  
  _LgDig._inter();
  factory _LgDig() => _lgDig;
  
  int _high(int value) => this._cache[value]._high;
  int _low(int value) => this._cache[value]._low;
  int _mult(int value) => this._cache[value]._mult;
  _LgDigCache _addAndRet(int value) {
    try {
      return this._cache[value];
    } on RangeError　catch (_) {
      this._cache[value] = _LgDigCache(value ~/ _LgDig._demarc, value % _LgDig._demarc, value * _LgDig._demarc);
      return this._cache[value];
    }
  }
  int operator [](int value) => this._addAndRet(value);
}

class _LgDigCache {
  final int _high;
  final int _low;
  final int _mult;
  const _LgDigCache(this._high, this._low, this._mult);
}

final _LgDig _lgDig = _LgDig();