// ignore_for_file: prefer_foreach

List<num>? bounds(Map<String?, dynamic> objects) {
  num x0 = double.infinity,
      y0 = double.infinity,
      x1 = double.negativeInfinity,
      y1 = double.negativeInfinity;

  void boundPoint(List coordinates) {
    num x = coordinates[0], y = coordinates[1];
    if (x < x0) x0 = x;
    if (x > x1) x1 = x;
    if (y < y0) y0 = y;
    if (y > y1) y1 = y;
  }

  void boundLine(List<dynamic> coordinates) {
    for (final List point in coordinates) {
      boundPoint(point);
    }
  }

  void boundMultiLine(List coordinates) {
    for (final List line in coordinates) {
      boundLine(line);
    }
  }

  void boundGeometry(Map<String?, dynamic>? o) {
    if (o != null) {
      switch (o["type"]) {
        case "GeometryCollection":
          for (final Map<String?, dynamic>? geometry in o["geometries"]) {
            boundGeometry(geometry);
          }
          break;
        case "Point":
          boundPoint(o["coordinates"]);
          break;
        case "MultiPoint":
          for (final List point in o["coordinates"]) {
            boundPoint(point);
          }
          break;
        case "LineString":
          boundLine(o["arcs"]);
          break;
        case "MultiLineString":
          for (final List line in o["arcs"]) {
            boundLine(line);
          }
          break;
        case "Polygon":
          for (final List line in o["arcs"]) {
            boundLine(line);
          }
          break;
        case "MultiPolygon":
          for (final List multiLine in o["arcs"]) {
            boundMultiLine(multiLine);
          }
          break;
      }
    }
  }

  for (final o in objects.values) {
    boundGeometry(o);
  }

  return x1 >= x0 && y1 >= y0 ? [x0, y0, x1, y1] : null;
}
