import 'arc.dart';
import 'join.dart';

// Given an extracted (pre-)topology, cuts (or rotates) arcs so that all shared
// point sequences are identified. The topology can then be subsequently deduped
// to remove exact duplicate arcs.
Map<String?, dynamic> cut(Map<String?, dynamic> topology) {
  var junctions = join(topology);
  List<List<num>> coordinates = topology["coordinates"];
  List<Arc> lines = topology["lines"], rings = topology["rings"];
  Arc next;

  for (var line in lines) {
    var lineMid = line.start, lineEnd = line.end;
    while (++lineMid < lineEnd) {
      if (junctions.contains(coordinates[lineMid])) {
        next = Arc(lineMid, line.end);
        line.end = lineMid;
        line = line.next = next;
      }
    }
  }

  for (var ring in rings) {
    var ringStart = ring.start,
        ringMid = ringStart,
        ringEnd = ring.end,
        ringFixed = junctions.contains(coordinates[ringStart]);
    while (++ringMid < ringEnd) {
      if (junctions.contains(coordinates[ringMid])) {
        if (ringFixed) {
          next = Arc(ringMid, ring.end);
          ring.end = ringMid;
          ring = ring.next = next;
        } else {
          // For the first junction, we can rotate rather than cut.
          _rotateArray(coordinates, ringStart, ringEnd, ringEnd - ringMid);
          coordinates[ringEnd] = coordinates[ringStart];
          ringFixed = true;
          ringMid = ringStart; // restart; we may have skipped junctions
        }
      }
    }
  }

  return topology;
}

void _rotateArray(List<List<num>> array, int start, int end, int offset) {
  _reverse(array, start, end);
  _reverse(array, start, start + offset);
  _reverse(array, start + offset, end);
}

void _reverse(List<List<num>> array, int start, int end) {
  List<num> t;
  for (var mid = start + ((end-- - start) >> 1); start < mid; ++start, --end) {
    t = array[start];
    array[start] = array[end];
    array[end] = t;
  }
}
