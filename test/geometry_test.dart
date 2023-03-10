// ignore_for_file: lines_longer_than_80_chars

import 'package:test/test.dart';
import 'package:topo_server/src/geometry.dart';

void main() {
  test("geometry replaces LineString Feature with LineString Geometry", () {
    expect(
        geometry({
          "foo": {
            "type": "Feature",
            "geometry": {
              "type": "LineString",
              "coordinates": [
                [0, 0]
              ]
            }
          }
        }),
        {
          "foo": {
            "type": "LineString",
            "arcs": [
              [0, 0]
            ]
          }
        });
  });

  test("geometry replaces GeometryCollection Feature with GeometryCollection",
      () {
    expect(
        geometry({
          "foo": {
            "type": "Feature",
            "geometry": {
              "type": "GeometryCollection",
              "geometries": [
                {
                  "type": "LineString",
                  "coordinates": [
                    [0, 0]
                  ]
                }
              ]
            }
          }
        }),
        {
          "foo": {
            "type": "GeometryCollection",
            "geometries": [
              {
                "type": "LineString",
                "arcs": [
                  [0, 0]
                ]
              }
            ]
          }
        });
  });

  test("geometry replaces FeatureCollection with GeometryCollection", () {
    expect(
        geometry({
          "foo": {
            "type": "FeatureCollection",
            "features": [
              {
                "type": "Feature",
                "geometry": {
                  "type": "LineString",
                  "coordinates": [
                    [0, 0]
                  ]
                }
              }
            ]
          }
        }),
        {
          "foo": {
            "type": "GeometryCollection",
            "geometries": [
              {
                "type": "LineString",
                "arcs": [
                  [0, 0]
                ]
              }
            ]
          }
        });
  });

  test("geometry replaces Feature with null Geometry with null-type Geometry",
      () {
    expect(
        geometry({
          "foo": {"type": "Feature", "geometry": null}
        }),
        {
          "foo": {"type": null}
        });
  });

  test("geometry replaces top-level null Geometry with null-type Geometry", () {
    expect(geometry({"foo": null}), {
      "foo": {"type": null}
    });
  });

  test(
      "geometry replaces null Geometry in GeometryCollection with null-type Geometry",
      () {
    expect(
        geometry({
          "foo": {
            "type": "GeometryCollection",
            "geometries": [null]
          }
        }),
        {
          "foo": {
            "type": "GeometryCollection",
            "geometries": [
              {"type": null}
            ]
          }
        });
  });

  test("geometry preserves id", () {
    expect(
        geometry({
          "foo": {
            "id": "foo",
            "type": "Feature",
            "geometry": {
              "type": "LineString",
              "coordinates": [
                [0, 0]
              ]
            }
          }
        }),
        {
          "foo": {
            "id": "foo",
            "type": "LineString",
            "arcs": [
              [0, 0]
            ]
          }
        });
  });

  test("geometry preserves properties if non-empty", () {
    expect(
        geometry({
          "foo": {
            "properties": {"foo": 42},
            "type": "Feature",
            "geometry": {
              "type": "LineString",
              "coordinates": [
                [0, 0]
              ]
            }
          }
        }),
        {
          "foo": {
            "properties": {"foo": 42},
            "type": "LineString",
            "arcs": [
              [0, 0]
            ]
          }
        });
  });

  test("geometry applies a shallow copy for properties", () {
    var input = {
          "foo": {
            "properties": {"foo": 42},
            "type": "Feature",
            "geometry": {
              "type": "LineString",
              "coordinates": [
                [0, 0]
              ]
            }
          }
        },
        output = geometry(input);
    expect(input["foo"]!["properties"], output["foo"]!["properties"]);
  });

  test("geometry deletes empty properties", () {
    expect(
        geometry({
          "foo": {
            "properties": {},
            "type": "Feature",
            "geometry": {
              "type": "LineString",
              "coordinates": [
                [0, 0]
              ]
            }
          }
        }),
        {
          "foo": {
            "type": "LineString",
            "arcs": [
              [0, 0]
            ]
          }
        });
  });

  test("geometry does not convert singular multipoints to points", () {
    expect(
        geometry({
          "foo": {
            "type": "MultiPoint",
            "coordinates": [
              [0, 0]
            ]
          }
        }),
        {
          "foo": {
            "type": "MultiPoint",
            "coordinates": [
              [0, 0]
            ]
          }
        });
  });

  test("geometry does not convert empty multipoints to null", () {
    expect(
        geometry({
          "foo": {"type": "MultiPoint", "coordinates": []}
        }),
        {
          "foo": {"type": "MultiPoint", "coordinates": []}
        });
  });

  test("geometry does not convert singular multilines to lines", () {
    expect(
        geometry({
          "foo": {
            "type": "MultiLineString",
            "coordinates": [
              [
                [0, 0],
                [0, 1]
              ]
            ]
          }
        }),
        {
          "foo": {
            "type": "MultiLineString",
            "arcs": [
              [
                [0, 0],
                [0, 1]
              ]
            ]
          }
        });
  });

  test("geometry does not convert empty lines to null", () {
    expect(
        geometry({
          "foo": {"type": "LineString", "coordinates": []}
        }),
        {
          "foo": {"type": "LineString", "arcs": []}
        });
  });

  test("geometry does not convert empty multilines to null", () {
    expect(
        geometry({
          "foo": {"type": "MultiLineString", "coordinates": []},
          "bar": {
            "type": "MultiLineString",
            "coordinates": [[]]
          }
        }),
        {
          "foo": {"type": "MultiLineString", "arcs": []},
          "bar": {
            "type": "MultiLineString",
            "arcs": [[]]
          }
        });
  });

  test("geometry does not strip empty rings in polygons", () {
    expect(
        geometry({
          "foo": {
            "type": "Polygon",
            "coordinates": [
              [
                [0, 0],
                [1, 0],
                [1, 1],
                [0, 0]
              ],
              []
            ]
          }
        }),
        {
          "foo": {
            "type": "Polygon",
            "arcs": [
              [
                [0, 0],
                [1, 0],
                [1, 1],
                [0, 0]
              ],
              []
            ]
          }
        });
  });

  test("geometry does not strip empty lines in multilines", () {
    expect(
        geometry({
          "foo": {
            "type": "MultiLineString",
            "coordinates": [
              [
                [0, 0],
                [1, 0],
                [1, 1],
                [0, 0]
              ],
              [],
              [
                [0, 0],
                [1, 0]
              ]
            ]
          }
        }),
        {
          "foo": {
            "type": "MultiLineString",
            "arcs": [
              [
                [0, 0],
                [1, 0],
                [1, 1],
                [0, 0]
              ],
              [],
              [
                [0, 0],
                [1, 0]
              ]
            ]
          }
        });
  });

  test("geometry does not convert empty polygons to null", () {
    expect(
        geometry({
          "foo": {"type": "Polygon", "coordinates": []},
          "bar": {
            "type": "Polygon",
            "coordinates": [[]]
          }
        }),
        {
          "foo": {"type": "Polygon", "arcs": []},
          "bar": {
            "type": "Polygon",
            "arcs": [[]]
          }
        });
  });

  test("geometry does not strip empty polygons in multipolygons", () {
    expect(
        geometry({
          "foo": {
            "type": "MultiPolygon",
            "coordinates": [
              [
                [
                  [0, 0],
                  [1, 0],
                  [1, 1],
                  [0, 0]
                ],
                []
              ],
              [],
              [[]]
            ]
          }
        }),
        {
          "foo": {
            "type": "MultiPolygon",
            "arcs": [
              [
                [
                  [0, 0],
                  [1, 0],
                  [1, 1],
                  [0, 0]
                ],
                []
              ],
              [],
              [[]]
            ]
          }
        });
  });

  test("geometry does not convert singular multipolygons to polygons", () {
    expect(
        geometry({
          "foo": {
            "type": "MultiPolygon",
            "coordinates": [
              [
                [
                  [0, 0],
                  [0, 1],
                  [1, 0],
                  [0, 0]
                ]
              ]
            ]
          }
        }),
        {
          "foo": {
            "type": "MultiPolygon",
            "arcs": [
              [
                [
                  [0, 0],
                  [0, 1],
                  [1, 0],
                  [0, 0]
                ]
              ]
            ]
          }
        });
  });
}
