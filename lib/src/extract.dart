// ignore_for_file: prefer_foreach

import 'arc.dart';

// Extracts the lines and rings from the specified hash of geometry objects.
//
// Returns an object with three properties:
//
// * coordinates - shared buffer of [x, y] coordinates
// * lines - lines extracted from the hash, of the form [start, end]
// * rings - rings extracted from the hash, of the form [start, end]
//
// For each ring or line, start and end represent inclusive indexes into the
// coordinates buffer. For rings (and closed lines), coordinates[start] equals
// coordinates[end].
//
// For each line or polygon geometry in the input hash, including nested
// geometries as in geometry collections, the `coordinates` array is replaced
// with an equivalent `arcs` array that, for each line (for line string
// geometries) or ring (for polygon geometries), points to one of the above
// lines or rings.
Map<String?, dynamic> extract(Map<String?, Map<String?, dynamic>?> objects) {
  var index = -1, lines = <Arc>[], rings = <Arc>[], coordinates = <List<num>>[];

  Arc extractLine(List line) {
    for (final List p in line) {
      coordinates.add(p.cast());
    }
    var arc = Arc(index + 1, index += line.length);
    lines.add(arc);
    return arc;
  }

  Arc extractRing(List ring) {
    for (final List p in ring) {
      coordinates.add(p.cast());
    }
    var arc = Arc(index + 1, index += ring.length);
    rings.add(arc);
    return arc;
  }

  List<Arc> extractMultiRing(List rings) =>
      rings.cast<List>().map(extractRing).toList();

  void extractGeometry(Map<String?, dynamic>? o) {
    if (o != null) {
      switch (o["type"]) {
        case "GeometryCollection":
          for (final Map<String?, dynamic> geometry in o["geometries"]) {
            extractGeometry(geometry);
          }
          break;
        case "LineString":
          o["arcs"] = extractLine(o["arcs"]);
          break;
        case "MultiLineString":
          o["arcs"] =
              List.castFrom<dynamic, List>(o["arcs"]).map(extractLine).toList();
          break;
        case "Polygon":
          o["arcs"] =
              List.castFrom<dynamic, List>(o["arcs"]).map(extractRing).toList();
          break;
        case "MultiPolygon":
          o["arcs"] = List.castFrom<dynamic, List>(o["arcs"])
              .map(extractMultiRing)
              .toList();
          break;
      }
    }
  }

  for (final o in objects.values) {
    extractGeometry(o);
  }

  return {
    "type": "Topology",
    "coordinates": coordinates,
    "lines": lines,
    "rings": rings,
    "objects": objects
  };
}
