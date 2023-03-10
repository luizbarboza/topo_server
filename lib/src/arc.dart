// ignore_for_file: avoid_equals_and_hash_code_on_mutable_classes

class Arc {
  int start, end;
  Arc? next;

  Arc(this.start, this.end, {this.next});

  @override
  operator ==(other) =>
      other is Arc && equalsIgnoringNext(this, other) && other.next == next;

  @override
  get hashCode => Object.hash(hashCodeIgnoringNext(this), next);

  static bool equalsIgnoringNext(Arc arcA, Arc arcB) {
    int ia = arcA.start, ja = arcA.end, ib = arcB.start, jb = arcB.end, t;
    if (ja < ia) {
      t = ia;
      ia = ja;
      ja = t;
    }
    if (jb < ib) {
      t = ib;
      ib = jb;
      jb = t;
    }
    return ia == ib && ja == jb;
  }

  static int hashCodeIgnoringNext(Arc arc) {
    int i = arc.start, j = arc.end, t;
    if (j < i) {
      t = i;
      i = j;
      j = t;
    }
    return Object.hash(i, j);
  }
}
