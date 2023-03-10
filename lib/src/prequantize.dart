// ignore_for_file: prefer_foreach

Map<String, List<num>> prequantize(
    Map<String?, Map<String?, dynamic>?> objects, List<num> bbox, num n) {
  var x0 = bbox[0],
      y0 = bbox[1],
      x1 = bbox[2],
      y1 = bbox[3],
      kx = x1 - x0 != 0 ? (n - 1) / (x1 - x0) : 1,
      ky = y1 - y0 != 0 ? (n - 1) / (y1 - y0) : 1;

  List<num> quantizePoint(List input) => [
        (((input[0] as num) - x0) * kx).round(),
        (((input[1] as num) - y0) * ky).round()
      ];

  List<List<num>> quantizePoints(List<List> input, int m) {
    var i = -1, n = input.length;
    var output = <List<num>>[];
    List<num> pi;
    num? px, py, x, y;

    while (++i < n) {
      pi = input[i].cast();
      x = ((pi[0] - x0) * kx).round();
      y = ((pi[1] - y0) * ky).round();
      if (x != px || y != py) {
        output.add([px = x, py = y]); // non-coincident points
      }
    }

    while (output.length < m) {
      output.add([output[0][0], output[0][1]]);
    }
    return output;
  }

  List<List<num>> quantizeLine(List input) => quantizePoints(input.cast(), 2);

  List<List<num>> quantizeRing(List input) => quantizePoints(input.cast(), 4);

  List<List<List<num>>> quantizePolygon(List input) =>
      input.cast<List>().map(quantizeRing).toList();

  void quantizeGeometry(Map<String?, dynamic>? o) {
    if (o != null) {
      switch (o["type"]) {
        case "GeometryCollection":
          for (final Map<String?, dynamic> geometry in o["geometries"]) {
            quantizeGeometry(geometry);
          }
          break;
        case "Point":
          o["coordinates"] = quantizePoint(o["coordinates"]);
          break;
        case "MultiPoint":
          o["coordinates"] =
              List.castFrom<dynamic, List>(o["coordinates"]).map(quantizePoint);
          break;
        case "LineString":
          o["arcs"] = quantizeLine(o["arcs"]);
          break;
        case "MultiLineString":
          o["arcs"] = List.castFrom<dynamic, List>(o["arcs"])
              .map(quantizeLine)
              .toList();
          break;
        case "Polygon":
          o["arcs"] = quantizePolygon(o["arcs"]);
          break;
        case "MultiPolygon":
          o["arcs"] = List.castFrom<dynamic, List>(o["arcs"])
              .map(quantizePolygon)
              .toList();
          break;
      }
    }
  }

  for (final o in objects.values) {
    quantizeGeometry(o);
  }

  return {
    "scale": [1 / kx, 1 / ky],
    "translate": [x0, y0]
  };
}
