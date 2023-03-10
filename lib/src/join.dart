import 'dart:collection';
import 'dart:typed_data';

import 'arc.dart';
import 'hash/point_equal.dart';
import 'hash/point_hash.dart';

// Given an extracted (pre-)topology, identifies all of the junctions. These are
// the points at which arcs (lines or rings) will need to be cut so that each
// arc is represented uniquely.
//
// A junction is a point where at least one arc deviates from another arc going
// through the same point. For example, consider the point B. If there is a arc
// through ABC and another arc through CBA, then B is not a junction because in
// both cases the adjacent point pairs are {A,C}. However, if there is an
// additional arc ABD, then {A,D} != {A,C}, and thus B becomes a junction.
//
// For a closed ring ABCA, the first point A’s adjacent points are the second
// and last point {B,C}. For a line, the first and last point are always
// considered junctions, even if the line is closed; this ensures that a closed
// line is never rotated.
HashSet<List<num>> join(topology) {
  List<List<num>> coordinates = topology["coordinates"];
  List<Arc> lines = topology["lines"], rings = topology["rings"];

  hashIndex(int i) => hashPoint(coordinates[i]);

  equalIndex(int i, int j) => equalPoint(coordinates[i], coordinates[j]);

  index() {
    var indexByPoint =
            HashMap<int, int>(equals: equalIndex, hashCode: hashIndex),
        indexes = Int32List(coordinates.length);

    for (var i = 0, n = coordinates.length; i < n; ++i) {
      indexes[i] = indexByPoint.putIfAbsent(i, () => i);
    }

    return indexes;
  }

  var junctionByPoint = HashSet(equals: equalPoint, hashCode: hashPoint);

  var indexes = index();
  if (indexes.length <= 1) return junctionByPoint;

  var visitedByIndex = Int32List(coordinates.length),
      leftByIndex = Int32List(coordinates.length),
      rightByIndex = Int32List(coordinates.length),
      junctionByIndex = Int32List(coordinates.length);
  int // junctionCount = 0, // upper bound on number of junctions
      previousIndex,
      currentIndex,
      nextIndex;

  for (var i = 0, n = coordinates.length; i < n; ++i) {
    visitedByIndex[i] = leftByIndex[i] = rightByIndex[i] = -1;
  }

  void sequence(int i, int previousIndex, int currentIndex, int nextIndex) {
    if (visitedByIndex[currentIndex] == i) return; // ignore self-intersection
    visitedByIndex[currentIndex] = i;
    var leftIndex = leftByIndex[currentIndex];
    if (leftIndex >= 0) {
      var rightIndex = rightByIndex[currentIndex];
      if ((leftIndex != previousIndex || rightIndex != nextIndex) &&
          (leftIndex != nextIndex || rightIndex != previousIndex)) {
        // ++junctionCount;
        junctionByIndex[currentIndex] = 1;
      }
    } else {
      leftByIndex[currentIndex] = previousIndex;
      rightByIndex[currentIndex] = nextIndex;
    }
  }

  for (var i = 0, n = lines.length; i < n; ++i) {
    var line = lines[i], lineStart = line.start, lineEnd = line.end;
    currentIndex = indexes[lineStart];
    nextIndex = indexes[++lineStart];
    // ++junctionCount;
    junctionByIndex[currentIndex] = 1; // start
    while (++lineStart <= lineEnd) {
      sequence(i, previousIndex = currentIndex, currentIndex = nextIndex,
          nextIndex = indexes[lineStart]);
    }
    // ++junctionCount;
    junctionByIndex[nextIndex] = 1; // end
  }

  for (var i = 0, n = coordinates.length; i < n; ++i) {
    visitedByIndex[i] = -1;
  }

  for (var i = 0, n = rings.length; i < n; ++i) {
    var ring = rings[i], ringStart = ring.start + 1, ringEnd = ring.end;
    previousIndex = indexes[ringEnd - 1];
    currentIndex = indexes[ringStart - 1];
    nextIndex = indexes[ringStart];
    sequence(i, previousIndex, currentIndex, nextIndex);
    while (++ringStart <= ringEnd) {
      sequence(i, previousIndex = currentIndex, currentIndex = nextIndex,
          nextIndex = indexes[ringStart]);
    }
  }

  // Convert back to a standard hashset by point for caller convenience.
  for (int i = 0, j, n = coordinates.length; i < n; ++i) {
    if (junctionByIndex[j = indexes[i]] != 0) {
      junctionByPoint.add(coordinates[j]);
    }
  }

  return junctionByPoint;
}
