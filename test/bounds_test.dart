import 'package:test/test.dart';
import 'package:topo_server/src/bounds.dart';

void main() {
  test("bounds computes the bounding box", () {
    expect(
        bounds({
          "foo": {
            "type": "LineString",
            "arcs": [
              [0, 0],
              [1, 0],
              [0, 2],
              [0, 0]
            ]
          }
        }),
        [0, 0, 1, 2]);
  });

  test("bounds considers points as well as arcs", () {
    expect(
        bounds({
          "foo": {
            "type": "MultiPoint",
            "coordinates": [
              [0, 0],
              [1, 0],
              [0, 2],
              [0, 0]
            ]
          }
        }),
        [0, 0, 1, 2]);
  });
}
