import 'package:test/test.dart';
import 'package:topo_server/src/delta.dart';

void main() {
  test("delta converts arcs to delta encoding", () {
    expect(
        delta([
          [
            [0, 0],
            [9999, 0],
            [0, 9999],
            [0, 0]
          ]
        ]),
        [
          [
            [0, 0],
            [9999, 0],
            [-9999, 9999],
            [0, -9999]
          ]
        ]);
  });

  test("delta skips coincident points", () {
    expect(
        delta([
          [
            [0, 0],
            [9999, 0],
            [9999, 0],
            [0, 9999],
            [0, 0]
          ]
        ]),
        [
          [
            [0, 0],
            [9999, 0],
            [-9999, 9999],
            [0, -9999]
          ]
        ]);
  });

  test("delta preserves at least two positions", () {
    expect(
        delta([
          [
            [12345, 12345],
            [12345, 12345],
            [12345, 12345],
            [12345, 12345]
          ]
        ]),
        [
          [
            [12345, 12345],
            [0, 0]
          ]
        ]);
  });
}
