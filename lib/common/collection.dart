extension EachInsertExtension<E> on Iterable<E> {
  Iterable<E> eachInsert(E insertee) sync* {
    final iterator = this.iterator;
    if (!iterator.moveNext()) return;

    yield iterator.current;
    while (iterator.moveNext()) {
      yield insertee;
      yield iterator.current;
    }
  }
}

extension Flatting<E> on Iterable<Iterable<E>>{
  Iterable<E> flatten() => this.expand((Iterable<E> es) => es);
}

class LeadSet<E>{
  int  _primary;
  List<E> _entries;

  LeadSet(int primary, Iterable<E> entries):
    this._entries = List.of<E>(entries),
    this._primary = LeadSet._validatePrimary(primary, entries);
  
  int get primary => this._primary;
  void set primary(int prim)
    => this._primary = LeadSet._validatePrimary(prim, this._entries);

  List<E> get  entries
    => <E>[...(this._entries)];
  E get entry {
    if(this._primary == -1){
      throw StateError("Single entry can not be returned because primary entry is not assigned.");
    }
  }
  E? get entryOr {
    try {
      return this.entry;
    } on StateError catch(_) {
      return null;
    }
  }

  void add(E entry)
    => this._entries.add(entry);
  void insert(int position, E entry) {
    this._entries.insert(position, entry);
    if(this._primary != -1 && position <= this._primary){
      this._primary += 1;
    }
  }
  void update(int position, E entry) {
    this._entries[position] = entry;
  }
  void remove(int position) {
    if(this._primary == position) {
      throw StateError("Primary entry can't be remove.");
    }
    this._entries.removeAt(position);
    if(this._primary != -1 && this._primary > position) {
      this._primary -= 1;
    }
  }
  void clear() {
    this._primary = -1;
    this._entries.clear();
  }
  void change(int posA, int postB){
    E temp = this._entries[posA];
    this._entries[posA] = this._entries[posB];
    this._entries[posB] = temp;

    if(this._primary == posA){
      this._primary = posB;
    } else if(this._primary == posB) {
      this._primary = posA;
    }
  }

  static bool _isValidPrimary(int prim, Iterable<E> list)
    => -1 <= prim && prim <= list.length;
  static void _checkPrimary<E>(int prim, Iterable<E> list){
    if(LeadSet._isValidPrimary(prim, list)){
      throw RangeError.range(prim, -1, list.length - 1, "primary");
    }
  }
  static int _validatePrimary<E>(int prim, Iterable<E> list){
    try{
      LeadSet._checkPrimary<E>(prim, list);
      return prim;
    } on RangeError catch(RangeError e){
      throw e;
    }
  }
}

class TaggedEntry<K extends Enum, E>{
  final E entry;
  final K kind;

  TaggedEntry(this.entry, this.kind);

  TaggedEntry<K, E> update(K newKind)
    => TaggedEntry(this.entry, newKind);
  bool isSameWith(TaggedEntry<K, E> other)
    => TaggedEntry.isIdentical<K, E>(this, other);

  @override
  bool operator ==(Object other)
    => other is TaggedEntry<K, E> && this.isSameWith(other);
  @override
  int hashCode => Object.hash(this.entry, this.kind.index);

  static bool isIdentical<K extends Enum, E>(TaggedEntry<K, E> a, TaggedEntry<K, E> b)
    => a.entry == b.entry && a.kind == b.kind;
}

extension TaggedEntryIterable<K extends Enum, E> on Iterable<TaggedEntry<K, E>> {
  Iterable<E> entries
    => this.map<E>((TaggedEntry<K, E> e) => e.entry);
}

class TaggedRoster<K extends Enum, E>{
  Set<TaggedEntry<K, E>> _entries;

  TaggedRoster():
    this._entries = <TaggedEntry<K, E>>{};
  // like Map.fromEntries
  TaggedRoster.fromEntries(Iterable<TaggedEntry<K, E>> entries):
    this._entries = TaggedRoster._unique(entries);
  Set<TaggedEntry<K, E>> get entries
    => <TaggedEntry<K, E>>{}
      ..addAll(this._entries);
  // like Set.add
  bool add(TaggedEntry<K, E> entry){
    if(this._entries.every((TaggedEntry<K, E> e) => e.entry != entry)){
      this._entries.add(entry);
      return true;
    } else {
      return false;
    }
  }
  bool addAll(Iterable<TaggedEntry<K, E>> entries)
    => entries
      .map<bool>((TaggedEntry<K, E> entry) => this.add(entry))
      .reduce((bool prev, bool curr) => prev && curr);

  // like Map.update
  void update(TaggedEntry<K, E> Function(E, K) updater)
    => this.entries = this.entries
      .map<TaggedEntry<K, E>>((TaggedEntry<K, E> e) => updater(e.entry, e.kind))
      .toSet();
  void updateKind(K Function(E, K) updater)
    => this.entries = this.entries
      .map<TaggedEntry<K, E>>((TaggedEntry<K, E> e) => e.update(updater(e.entry, e.kind)))
      .toSet();

  TaggedEntry<K, E> lookup(E entry)
    => this._entries
      .where((TaggedEntry<K, E> e) => e.entry == entry)
      .single;
  bool contains(Object? value)
    => this._entries.entries.contains(value);
  bool containsAll(Iterable<Object?> other)
    => other
      .map<bool>((Object? o) => this.contains(o))
      .reduce((bool prev, bool curr) => prev && curr);

  bool any(bool Function(E,K) test)
    => this._entries
      .any((TaggedEntry<K, E> e) => test(e.entry, e.kind));
  bool every(bool Function(E,K) test)
    => this._entries
      .every((TaggedEntry<K, E> e) => test(e.entry, e.kind));
  TaggedRoster<K, E> _di(TaggedRoster<K, E> other, bool Function(bool) ref) {
    final r = TaggedRoster<K, E>();
    
    for (final e in this._entries){
      if(ref(other.contains(e))){
        r.add(e);
      }
    }
    
    return r;
  }
  // this - other
  TaggedRoster<K, E> difference(TaggedRoster<K, E> other)
    => this._di(other, (bool c) => !c);
  // this + other
  TaggedRoster<K, E> union(TaggedRoster<K, E> other)
    => TaggedRoster<K, E>()
      ..addAll(this._entries)
      ..addAll(other._entries);
  // this * other
  TaggedRoster<K, E> intersection(TaggedRoster<K, E> other)
    => this._di(other, (bool c) => c);

  Set<TaggedEntry<K, E>> where(K kind)
    => this._entries.where((TaggedEntry<K, E> e) => e.kind == kind);
  Set<E> entryWhere(K kind)
    => this.where(kind)
      .map<E>((TaggedEntry<K, E> e) => e.entry)
      .toSet();
  void remove(E entry)
    => this._entries
      .removeWhere((TaggedEntry<K, E> e) => e.entry == entry);
  void removeAll(Iterable<E> entries)
    => entries.forEach((E e) => this.remove(e));
  void removeWhere(K kind)
    => this._entries
      .removeWhere((TaggedEntry<K, E> entry) => entry.kind == kind);
  void retainAll(Iterable<E> entries)
    => this._entries
      .retainWhere((TaggedEntry<K, E> e) => entries.contains(e.entry));
  void retainWhere(Iterable<Kind> kinds)
    => this._entries
      .retainWhere((TaggedEntry<K, E> e) => kinds.contains(e.kind));
  void clear() => this._entries.clear();
  // like Map.map
  TaggedRoster<K2, E2> map<K2 extends Enum, E2>(TaggedEntry<K2, E2> Function(E, K) converter)
    => TaggedRoster<K2, E2>.fromEntries(this._entries.map<TaggedEntry<K2, E2>>(converter));

  static Set<TaggedEntry<K, E>> _unique(Iterable<TaggedEntry<K, E>> entries){
    Set<TaggedEntry<K, E>> ret = <TaggedEntry<K, E>>{};
    late TaggedEntry<K, E> ei;

    for(int i == 0; i < entries.length; i++){
      ei = entries.elementAt(i);
      if(ret.every((TaggedEntry<K, E> re) => ei.entry != re.entry)){
        ret.add(ei);
      }
    }
    return re;
  }
}