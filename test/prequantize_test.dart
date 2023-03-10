import 'package:test/test.dart';
import 'package:topo_server/src/prequantize.dart';

void main() {
  test("prequantize returns the quantization transform", () {
    expect(prequantize({}, [0, 0, 1, 1], 1e4), {
      "scale": [1 / 9999, 1 / 9999],
      "translate": [0, 0]
    });
  });

  test("prequantize converts coordinates to fixed precision", () {
    var objects = {
      "foo": {
        "type": "LineString",
        "arcs": [
          [0, 0],
          [1, 0],
          [0, 1],
          [0, 0]
        ]
      }
    };
    prequantize(objects, [0, 0, 1, 1], 1e4);
    expect(objects["foo"]!["arcs"], [
      [0, 0],
      [9999, 0],
      [0, 9999],
      [0, 0]
    ]);
  });

  test("prequantize observes the quantization parameter", () {
    var objects = {
      "foo": {
        "type": "LineString",
        "arcs": [
          [0, 0],
          [1, 0],
          [0, 1],
          [0, 0]
        ]
      }
    };
    prequantize(objects, [0, 0, 1, 1], 10);
    expect(objects["foo"]!["arcs"], [
      [0, 0],
      [9, 0],
      [0, 9],
      [0, 0]
    ]);
  });

  test("prequantize observes the bounding box", () {
    var objects = {
      "foo": {
        "type": "LineString",
        "arcs": [
          [0, 0],
          [1, 0],
          [0, 1],
          [0, 0]
        ]
      }
    };
    prequantize(objects, [-1, -1, 2, 2], 10);
    expect(objects["foo"]!["arcs"], [
      [3, 3],
      [6, 3],
      [3, 6],
      [3, 3]
    ]);
  });

  test("prequantize applies to points as well as arcs", () {
    var objects = {
      "foo": {
        "type": "MultiPoint",
        "coordinates": [
          [0, 0],
          [1, 0],
          [0, 1],
          [0, 0]
        ]
      }
    };
    prequantize(objects, [0, 0, 1, 1], 1e4);
    expect(objects["foo"]!["coordinates"], [
      [0, 0],
      [9999, 0],
      [0, 9999],
      [0, 0]
    ]);
  });

  test("prequantize skips coincident points in lines", () {
    var objects = {
      "foo": {
        "type": "LineString",
        "arcs": [
          [0, 0],
          [0.9, 0.9],
          [1.1, 1.1],
          [2, 2]
        ]
      }
    };
    prequantize(objects, [0, 0, 2, 2], 3);
    expect(objects["foo"]!["arcs"], [
      [0, 0],
      [1, 1],
      [2, 2]
    ]);
  });

  test("prequantize skips coincident points in polygons", () {
    var objects = {
      "foo": {
        "type": "Polygon",
        "arcs": [
          [
            [0, 0],
            [0.9, 0.9],
            [1.1, 1.1],
            [2, 2],
            [0, 0]
          ]
        ]
      }
    };
    prequantize(objects, [0, 0, 2, 2], 3);
    expect(objects["foo"]!["arcs"], [
      [
        [0, 0],
        [1, 1],
        [2, 2],
        [0, 0]
      ]
    ]);
  });

  test("prequantize does not skip coincident points in points", () {
    var objects = {
      "foo": {
        "type": "MultiPoint",
        "coordinates": [
          [0, 0],
          [0.9, 0.9],
          [1.1, 1.1],
          [2, 2],
          [0, 0]
        ]
      }
    };
    prequantize(objects, [0, 0, 2, 2], 3);
    expect(objects["foo"]!["coordinates"], [
      [0, 0],
      [1, 1],
      [1, 1],
      [2, 2],
      [0, 0]
    ]);
  });

  test("prequantize includes closing point in degenerate lines", () {
    var objects = {
      "foo": {
        "type": "LineString",
        "arcs": [
          [1, 1],
          [1, 1],
          [1, 1]
        ]
      }
    };
    prequantize(objects, [0, 0, 2, 2], 3);
    expect(objects["foo"]!["arcs"], [
      [1, 1],
      [1, 1]
    ]);
  });

  test("prequantize includes closing point in degenerate polygons", () {
    var objects = {
      "foo": {
        "type": "Polygon",
        "arcs": [
          [
            [0.9, 1],
            [1.1, 1],
            [1.01, 1],
            [0.9, 1]
          ]
        ]
      }
    };
    prequantize(objects, [0, 0, 2, 2], 3);
    expect(objects["foo"]!["arcs"], [
      [
        [1, 1],
        [1, 1],
        [1, 1],
        [1, 1]
      ]
    ]);
  });
}
