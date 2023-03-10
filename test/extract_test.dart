// ignore_for_file: lines_longer_than_80_chars

import 'package:test/test.dart';
import 'package:topo_server/src/arc.dart';
import 'package:topo_server/src/extract.dart';

void main() {
  test("extract copies coordinates sequentially into a buffer", () {
    var topology = extract({
      "foo": {
        "type": "LineString",
        "arcs": [
          [0, 0],
          [1, 0],
          [2, 0]
        ]
      },
      "bar": {
        "type": "LineString",
        "arcs": [
          [0, 0],
          [1, 0],
          [2, 0]
        ]
      }
    });
    expect(topology["coordinates"], [
      [0, 0],
      [1, 0],
      [2, 0],
      [0, 0],
      [1, 0],
      [2, 0]
    ]);
  });

  test("extract does not copy point geometries into the coordinate buffer", () {
    var topology = extract({
      "foo": {
        "type": "Point",
        "arcs": [0, 0]
      },
      "bar": {
        "type": "MultiPoint",
        "arcs": [
          [0, 0],
          [1, 0],
          [2, 0]
        ]
      }
    });
    expect(topology["coordinates"], []);
    expect(topology["objects"]["foo"]["arcs"], [0, 0]);
    expect(topology["objects"]["bar"]["arcs"], [
      [0, 0],
      [1, 0],
      [2, 0]
    ]);
  });

  test("extract includes closing coordinates in polygons", () {
    var topology = extract({
      "foo": {
        "type": "Polygon",
        "arcs": [
          [
            [0, 0],
            [1, 0],
            [2, 0],
            [0, 0]
          ]
        ]
      }
    });
    expect(topology["coordinates"], [
      [0, 0],
      [1, 0],
      [2, 0],
      [0, 0]
    ]);
  });

  test("extract represents lines as contiguous slices of the coordinate buffer",
      () {
    var topology = extract({
      "foo": {
        "type": "LineString",
        "arcs": [
          [0, 0],
          [1, 0],
          [2, 0]
        ]
      },
      "bar": {
        "type": "LineString",
        "arcs": [
          [0, 0],
          [1, 0],
          [2, 0]
        ]
      }
    });
    expect(topology["objects"], {
      "foo": {"type": "LineString", "arcs": Arc(0, 2)},
      "bar": {"type": "LineString", "arcs": Arc(3, 5)}
    });
  });

  test("extract represents rings as contiguous slices of the coordinate buffer",
      () {
    var topology = extract({
      "foo": {
        "type": "Polygon",
        "arcs": [
          [
            [0, 0],
            [1, 0],
            [2, 0],
            [0, 0]
          ]
        ]
      },
      "bar": {
        "type": "Polygon",
        "arcs": [
          [
            [0, 0],
            [1, 0],
            [2, 0],
            [0, 0]
          ]
        ]
      }
    });
    expect(topology["objects"], {
      "foo": {
        "type": "Polygon",
        "arcs": [Arc(0, 3)]
      },
      "bar": {
        "type": "Polygon",
        "arcs": [Arc(4, 7)]
      }
    });
  });

  test(
      "extract exposes the constructed lines and rings in the order of construction",
      () {
    var topology = extract({
      "line": {
        "type": "LineString",
        "arcs": [
          [0, 0],
          [1, 0],
          [2, 0]
        ]
      },
      "multiline": {
        "type": "MultiLineString",
        "arcs": [
          [
            [0, 0],
            [1, 0],
            [2, 0]
          ]
        ]
      },
      "polygon": {
        "type": "Polygon",
        "arcs": [
          [
            [0, 0],
            [1, 0],
            [2, 0],
            [0, 0]
          ]
        ]
      }
    });
    expect(topology["lines"], [Arc(0, 2), Arc(3, 5)]);
    expect(topology["rings"], [Arc(6, 9)]);
  });

  test("extract supports nested geometry collections", () {
    var topology = extract({
      "foo": {
        "type": "GeometryCollection",
        "geometries": [
          {
            "type": "GeometryCollection",
            "geometries": [
              {
                "type": "LineString",
                "arcs": [
                  [0, 0],
                  [0, 1]
                ]
              }
            ]
          }
        ]
      }
    });
    expect(topology["objects"]["foo"], {
      "type": "GeometryCollection",
      "geometries": [
        {
          "type": "GeometryCollection",
          "geometries": [
            {"type": "LineString", "arcs": Arc(0, 1)}
          ]
        }
      ]
    });
  });
}
