import 'dart:collection';

import 'arc.dart';
import 'hash/point_equal.dart';
import 'hash/point_hash.dart';

// Given a cut topology, combines duplicate arcs.
Map<String?, dynamic> dedup(Map<String?, dynamic> topology) {
  List<List<num>> coordinates = topology["coordinates"];
  List<Arc> lines = topology["lines"], rings = topology["rings"];
  // int arcCount = lines.length + rings.length;

  topology
    ..remove("lines")
    ..remove("rings");

  // Count the number of (non-unique) arcs to initialize the hashmap safely.
  // for (Arc? line in lines) while ((line = line!.next) != null) ++arcCount;

  // for (Arc? ring in rings) while ((ring = ring!.next) != null) ++arcCount;

  var arcsByEnd = HashMap<List<num>, List<Arc>>(
          equals: equalPoint, hashCode: hashPoint),
      arcs = topology["arcs"] = <Arc>[];

  bool equalLine(Arc arcA, Arc arcB) {
    var ia = arcA.start, ib = arcB.start, ja = arcA.end, jb = arcB.end;
    if (ia - ja != ib - jb) return false;
    for (; ia <= ja; ++ia, ++ib) {
      if (!equalPoint(coordinates[ia], coordinates[ib])) return false;
    }
    return true;
  }

  bool reverseEqualLine(Arc arcA, Arc arcB) {
    var ia = arcA.start, ib = arcB.start, ja = arcA.end, jb = arcB.end;
    if (ia - ja != ib - jb) return false;
    for (; ia <= ja; ++ia, --jb) {
      if (!equalPoint(coordinates[ia], coordinates[jb])) return false;
    }
    return true;
  }

  // Rings are rotated to a consistent, but arbitrary, start point.
  // This is necessary to detect when a ring and a rotated copy are dupes.
  int findMinimumOffset(Arc arc) {
    var start = arc.start,
        end = arc.end,
        mid = start,
        minimum = mid,
        minimumPoint = coordinates[mid];
    while (++mid < end) {
      var point = coordinates[mid];
      if (point[0] < minimumPoint[0] ||
          point[0] == minimumPoint[0] && point[1] < minimumPoint[1]) {
        minimum = mid;
        minimumPoint = point;
      }
    }
    return minimum - start;
  }

  bool equalRing(Arc arcA, Arc arcB) {
    var ia = arcA.start,
        ib = arcB.start,
        ja = arcA.end,
        jb = arcB.end,
        n = ja - ia;
    if (n != jb - ib) return false;
    var ka = findMinimumOffset(arcA), kb = findMinimumOffset(arcB);
    for (var i = 0; i < n; ++i) {
      if (!equalPoint(
          coordinates[ia + (i + ka) % n], coordinates[ib + (i + kb) % n])) {
        return false;
      }
    }
    return true;
  }

  bool reverseEqualRing(Arc arcA, Arc arcB) {
    var ia = arcA.start,
        ib = arcB.start,
        ja = arcA.end,
        jb = arcB.end,
        n = ja - ia;
    if (n != jb - ib) return false;
    var ka = findMinimumOffset(arcA), kb = n - findMinimumOffset(arcB);
    for (var i = 0; i < n; ++i) {
      if (!equalPoint(
          coordinates[ia + (i + ka) % n], coordinates[jb - (i + kb) % n])) {
        return false;
      }
    }
    return true;
  }

  void dedupLine(Arc arc) {
    List<num> startPoint, endPoint;
    List<Arc>? startArcs, endArcs;

    // Does this arc match an existing arc in order?
    if ((startArcs = arcsByEnd[startPoint = coordinates[arc.start]]) != null) {
      for (final startArc in startArcs!) {
        if (equalLine(startArc, arc)) {
          arc
            ..start = startArc.start
            ..end = startArc.end;
          return;
        }
      }
    }

    // Does this arc match an existing arc in reverse order?
    if ((endArcs = arcsByEnd[endPoint = coordinates[arc.end]]) != null) {
      for (final endArc in endArcs!) {
        if (reverseEqualLine(endArc, arc)) {
          arc
            ..end = endArc.start
            ..start = endArc.end;
          return;
        }
      }
    }

    if (startArcs != null) {
      startArcs.add(arc);
    } else {
      arcsByEnd[startPoint] = [arc];
    }
    if (endArcs != null) {
      endArcs.add(arc);
    } else {
      arcsByEnd[endPoint] = [arc];
    }
    arcs.add(arc);
  }

  void dedupRing(Arc arc) {
    List<num> endPoint;
    List<Arc>? endArcs;

    // Does this arc match an existing line in order, or reverse order?
    // Rings are closed, so their start point and end point is the same.
    if ((endArcs = arcsByEnd[endPoint = coordinates[arc.start]]) != null) {
      for (final endArc in endArcs!) {
        if (equalRing(endArc, arc)) {
          arc
            ..start = endArc.start
            ..end = endArc.end;
          return;
        }
        if (reverseEqualRing(endArc, arc)) {
          arc
            ..start = endArc.end
            ..end = endArc.start;
          return;
        }
      }
    }

    // Otherwise, does this arc match an existing ring in order, or reverse
    // order?
    if ((endArcs = arcsByEnd[endPoint =
            coordinates[arc.start + findMinimumOffset(arc)]]) !=
        null) {
      for (final endArc in endArcs!) {
        if (equalRing(endArc, arc)) {
          arc
            ..start = endArc.start
            ..end = endArc.end;
          return;
        }
        if (reverseEqualRing(endArc, arc)) {
          arc
            ..start = endArc.end
            ..end = endArc.start;
          return;
        }
      }
    }

    if (endArcs != null) {
      endArcs.add(arc);
    } else {
      arcsByEnd[endPoint] = [arc];
    }
    arcs.add(arc);
  }

  for (Arc? line in lines) {
    do {
      dedupLine(line!);
    } while ((line = line.next) != null);
  }

  for (Arc? ring in rings) {
    if (ring!.next != null) {
      // arc is no longer closed
      do {
        dedupLine(ring!);
      } while ((ring = ring.next) != null);
    } else {
      dedupRing(ring);
    }
  }

  return topology;
}
