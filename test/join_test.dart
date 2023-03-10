// ignore_for_file: lines_longer_than_80_chars

import 'package:test/test.dart';
import 'package:topo_server/src/extract.dart';
import 'package:topo_server/src/join.dart';

void main() {
  test("join the returned hashmap has true for junction points", () {
    var junctions = join(extract({
      "cba": {
        "type": "LineString",
        "arcs": [
          [2, 0],
          [1, 0],
          [0, 0]
        ]
      },
      "ab": {
        "type": "LineString",
        "arcs": [
          [0, 0],
          [1, 0]
        ]
      }
    }));
    expect(junctions, contains([2, 0]));
    expect(junctions, contains([0, 0]));
  });

  test("join the returned hashmap has undefined for non-junction points", () {
    var junctions = join(extract({
      "cba": {
        "type": "LineString",
        "arcs": [
          [2, 0],
          [1, 0],
          [0, 0]
        ]
      },
      "ab": {
        "type": "LineString",
        "arcs": [
          [0, 0],
          [2, 0]
        ]
      }
    }));
    expect(junctions, isNot(contains([1, 0])));
  });

  test(
      "join exact duplicate lines ABC & ABC have junctions at their end points",
      () {
    var junctions = join(extract({
      "abc": {
        "type": "LineString",
        "arcs": [
          [0, 0],
          [1, 0],
          [2, 0]
        ]
      },
      "abc2": {
        "type": "LineString",
        "arcs": [
          [0, 0],
          [1, 0],
          [2, 0]
        ]
      }
    }));
    expect(
        junctions,
        unorderedEquals([
          [0, 0],
          [2, 0]
        ]));
  });

  test(
      "join reversed duplicate lines ABC & CBA have junctions at their end points",
      () {
    var junctions = join(extract({
      "abc": {
        "type": "LineString",
        "arcs": [
          [0, 0],
          [1, 0],
          [2, 0]
        ]
      },
      "cba": {
        "type": "LineString",
        "arcs": [
          [2, 0],
          [1, 0],
          [0, 0]
        ]
      }
    }));
    expect(
        junctions,
        unorderedEquals([
          [0, 0],
          [2, 0]
        ]));
  });

  test("join exact duplicate rings ABCA & ABCA have no junctions", () {
    var junctions = join(extract({
      "abca": {
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
      "abca2": {
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
    }));
    expect(junctions, isEmpty);
  });

  test("join reversed duplicate rings ACBA & ABCA have no junctions", () {
    var junctions = join(extract({
      "abca": {
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
      "acba": {
        "type": "Polygon",
        "arcs": [
          [
            [0, 0],
            [2, 0],
            [1, 0],
            [0, 0]
          ]
        ]
      }
    }));
    expect(junctions, isEmpty);
  });

  test("join rotated duplicate rings BCAB & ABCA have no junctions", () {
    var junctions = join(extract({
      "abca": {
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
      "bcab": {
        "type": "Polygon",
        "arcs": [
          [
            [1, 0],
            [2, 0],
            [0, 0],
            [1, 0]
          ]
        ]
      }
    }));
    expect(junctions, isEmpty);
  });

  test("join ring ABCA & line ABCA have a junction at A", () {
    var junctions = join(extract({
      "abcaLine": {
        "type": "LineString",
        "arcs": [
          [0, 0],
          [1, 0],
          [2, 0],
          [0, 0]
        ]
      },
      "abcaPolygon": {
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
    }));
    expect(
        junctions,
        unorderedEquals([
          [0, 0]
        ]));
  });

  test("join ring BCAB & line ABCA have a junction at A", () {
    var junctions = join(extract({
      "abcaLine": {
        "type": "LineString",
        "arcs": [
          [0, 0],
          [1, 0],
          [2, 0],
          [0, 0]
        ]
      },
      "bcabPolygon": {
        "type": "Polygon",
        "arcs": [
          [
            [1, 0],
            [2, 0],
            [0, 0],
            [1, 0]
          ]
        ]
      },
    }));
    expect(
        junctions,
        unorderedEquals([
          [0, 0]
        ]));
  });

  test("join ring ABCA & line BCAB have a junction at B", () {
    var junctions = join(extract({
      "bcabLine": {
        "type": "LineString",
        "arcs": [
          [1, 0],
          [2, 0],
          [0, 0],
          [1, 0]
        ]
      },
      "abcaPolygon": {
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
    }));
    expect(
        junctions,
        unorderedEquals([
          [1, 0]
        ]));
  });

  test(
      "join when an old arc ABC extends a new arc AB, there is a junction at B",
      () {
    var junctions = join(extract({
      "abc": {
        "type": "LineString",
        "arcs": [
          [0, 0],
          [1, 0],
          [2, 0]
        ]
      },
      "ab": {
        "type": "LineString",
        "arcs": [
          [0, 0],
          [1, 0]
        ]
      }
    }));
    expect(
        junctions,
        unorderedEquals([
          [0, 0],
          [1, 0],
          [2, 0]
        ]));
  });

  test(
      "join when a reversed old arc CBA extends a new arc AB, there is a junction at B",
      () {
    var junctions = join(extract({
      "cba": {
        "type": "LineString",
        "arcs": [
          [2, 0],
          [1, 0],
          [0, 0]
        ]
      },
      "ab": {
        "type": "LineString",
        "arcs": [
          [0, 0],
          [1, 0]
        ]
      }
    }));
    expect(
        junctions,
        unorderedEquals([
          [0, 0],
          [1, 0],
          [2, 0]
        ]));
  });

  test(
      "join when a new arc ADE shares its start with an old arc ABC, there is a junction at A",
      () {
    var junctions = join(extract({
      "ade": {
        "type": "LineString",
        "arcs": [
          [0, 0],
          [1, 0],
          [2, 0]
        ]
      },
      "abc": {
        "type": "LineString",
        "arcs": [
          [0, 0],
          [1, 1],
          [2, 1]
        ]
      }
    }));
    expect(
        junctions,
        unorderedEquals([
          [0, 0],
          [2, 0],
          [2, 1]
        ]));
  });

  test("join ring ABA has no junctions", () {
    var junctions = join(extract({
      "aba": {
        "type": "Polygon",
        "arcs": [
          [
            [0, 0],
            [1, 0],
            [0, 0]
          ]
        ]
      },
    }));
    expect(junctions, isEmpty);
  });

  test("join ring AA has no junctions", () {
    var junctions = join(extract({
      "aa": {
        "type": "Polygon",
        "arcs": [
          [
            [0, 0],
            [0, 0]
          ]
        ]
      },
    }));
    expect(junctions, isEmpty);
  });

  test("join degenerate ring A has no junctions", () {
    var junctions = join(extract({
      "a": {
        "type": "Polygon",
        "arcs": [
          [
            [0, 0]
          ]
        ]
      },
    }));
    expect(junctions, isEmpty);
  });

  test(
      "join when a new line DEC shares its end with an old line ABC, there is a junction at C",
      () {
    var junctions = join(extract({
      "abc": {
        "type": "LineString",
        "arcs": [
          [0, 0],
          [1, 0],
          [2, 0]
        ]
      },
      "dec": {
        "type": "LineString",
        "arcs": [
          [0, 1],
          [1, 1],
          [2, 0]
        ]
      }
    }));
    expect(
        junctions,
        unorderedEquals([
          [0, 0],
          [2, 0],
          [0, 1]
        ]));
  });

  test(
      "join when a new line ABC extends an old line AB, there is a junction at B",
      () {
    var junctions = join(extract({
      "ab": {
        "type": "LineString",
        "arcs": [
          [0, 0],
          [1, 0]
        ]
      },
      "abc": {
        "type": "LineString",
        "arcs": [
          [0, 0],
          [1, 0],
          [2, 0]
        ]
      }
    }));
    expect(
        junctions,
        unorderedEquals([
          [0, 0],
          [1, 0],
          [2, 0]
        ]));
  });

  test(
      "join when a new line ABC extends a reversed old line BA, there is a junction at B",
      () {
    var junctions = join(extract({
      "ba": {
        "type": "LineString",
        "arcs": [
          [1, 0],
          [0, 0]
        ]
      },
      "abc": {
        "type": "LineString",
        "arcs": [
          [0, 0],
          [1, 0],
          [2, 0]
        ]
      }
    }));
    expect(
        junctions,
        unorderedEquals([
          [0, 0],
          [1, 0],
          [2, 0]
        ]));
  });

  test(
      "join when a new line starts BC in the middle of an old line ABC, there is a junction at B",
      () {
    var junctions = join(extract({
      "abc": {
        "type": "LineString",
        "arcs": [
          [0, 0],
          [1, 0],
          [2, 0]
        ]
      },
      "bc": {
        "type": "LineString",
        "arcs": [
          [1, 0],
          [2, 0]
        ]
      }
    }));
    expect(
        junctions,
        unorderedEquals([
          [0, 0],
          [1, 0],
          [2, 0]
        ]));
  });

  test(
      "join when a new line BC starts in the middle of a reversed old line CBA, there is a junction at B",
      () {
    var junctions = join(extract({
      "cba": {
        "type": "LineString",
        "arcs": [
          [2, 0],
          [1, 0],
          [0, 0]
        ]
      },
      "bc": {
        "type": "LineString",
        "arcs": [
          [1, 0],
          [2, 0]
        ]
      }
    }));
    expect(
        junctions,
        unorderedEquals([
          [0, 0],
          [1, 0],
          [2, 0]
        ]));
  });

  test(
      "join when a new line ABD deviates from an old line ABC, there is a junction at B",
      () {
    var junctions = join(extract({
      "abc": {
        "type": "LineString",
        "arcs": [
          [0, 0],
          [1, 0],
          [2, 0]
        ]
      },
      "abd": {
        "type": "LineString",
        "arcs": [
          [0, 0],
          [1, 0],
          [3, 0]
        ]
      }
    }));
    expect(
        junctions,
        unorderedEquals([
          [0, 0],
          [2, 0],
          [1, 0],
          [3, 0]
        ]));
  });

  test(
      "join when a new line ABD deviates from a reversed old line CBA, there is a junction at B",
      () {
    var junctions = join(extract({
      "cba": {
        "type": "LineString",
        "arcs": [
          [2, 0],
          [1, 0],
          [0, 0]
        ]
      },
      "abd": {
        "type": "LineString",
        "arcs": [
          [0, 0],
          [1, 0],
          [3, 0]
        ]
      }
    }));
    expect(
        junctions,
        unorderedEquals([
          [2, 0],
          [0, 0],
          [1, 0],
          [3, 0]
        ]));
  });

  test(
      "join when a new line DBC merges into an old line ABC, there is a junction at B",
      () {
    var junctions = join(extract({
      "abc": {
        "type": "LineString",
        "arcs": [
          [0, 0],
          [1, 0],
          [2, 0]
        ]
      },
      "dbc": {
        "type": "LineString",
        "arcs": [
          [3, 0],
          [1, 0],
          [2, 0]
        ]
      }
    }));
    expect(
        junctions,
        unorderedEquals([
          [0, 0],
          [2, 0],
          [1, 0],
          [3, 0]
        ]));
  });

  test(
      "join when a new line DBC merges into a reversed old line CBA, there is a junction at B",
      () {
    var junctions = join(extract({
      "cba": {
        "type": "LineString",
        "arcs": [
          [2, 0],
          [1, 0],
          [0, 0]
        ]
      },
      "dbc": {
        "type": "LineString",
        "arcs": [
          [3, 0],
          [1, 0],
          [2, 0]
        ]
      }
    }));
    expect(
        junctions,
        unorderedEquals([
          [2, 0],
          [0, 0],
          [1, 0],
          [3, 0]
        ]));
  });

  test(
      "join when a new line DBE shares a single midpoint with an old line ABC, there is a junction at B",
      () {
    var junctions = join(extract({
      "abc": {
        "type": "LineString",
        "arcs": [
          [0, 0],
          [1, 0],
          [2, 0]
        ]
      },
      "dbe": {
        "type": "LineString",
        "arcs": [
          [0, 1],
          [1, 0],
          [2, 1]
        ]
      }
    }));
    expect(
        junctions,
        unorderedEquals([
          [0, 0],
          [2, 0],
          [2, 1],
          [1, 0],
          [0, 1]
        ]));
  });

  test(
      "join when a new line ABDE skips a point with an old line ABCDE, there is a junction at B and D",
      () {
    var junctions = join(extract({
      "abcde": {
        "type": "LineString",
        "arcs": [
          [0, 0],
          [1, 0],
          [2, 0],
          [3, 0],
          [4, 0]
        ]
      },
      "abde": {
        "type": "LineString",
        "arcs": [
          [0, 0],
          [1, 0],
          [3, 0],
          [4, 0]
        ]
      }
    }));
    expect(
        junctions,
        unorderedEquals([
          [0, 0],
          [4, 0],
          [1, 0],
          [3, 0]
        ]));
  });

  test(
      "join when a new line ABDE skips a point with a reversed old line EDCBA, there is a junction at B and D",
      () {
    var junctions = join(extract({
      "edcba": {
        "type": "LineString",
        "arcs": [
          [4, 0],
          [3, 0],
          [2, 0],
          [1, 0],
          [0, 0]
        ]
      },
      "abde": {
        "type": "LineString",
        "arcs": [
          [0, 0],
          [1, 0],
          [3, 0],
          [4, 0]
        ]
      }
    }));
    expect(
        junctions,
        unorderedEquals([
          [4, 0],
          [0, 0],
          [1, 0],
          [3, 0]
        ]));
  });

  test(
      "join when a line ABCDBE self-intersects with its middle, there are no junctions",
      () {
    var junctions = join(extract({
      "abcdbe": {
        "type": "LineString",
        "arcs": [
          [0, 0],
          [1, 0],
          [2, 0],
          [3, 0],
          [1, 0],
          [4, 0]
        ]
      }
    }));
    expect(
        junctions,
        unorderedEquals([
          [0, 0],
          [4, 0]
        ]));
  });

  test(
      "join when a line ABACD self-intersects with its start, there are no junctions",
      () {
    var junctions = join(extract({
      "abacd": {
        "type": "LineString",
        "arcs": [
          [0, 0],
          [1, 0],
          [0, 0],
          [3, 0],
          [4, 0]
        ]
      }
    }));
    expect(
        junctions,
        unorderedEquals([
          [0, 0],
          [4, 0]
        ]));
  });

  test(
      "join when a line ABCDBD self-intersects with its end, there are no junctions",
      () {
    var junctions = join(extract({
      "abcdbd": {
        "type": "LineString",
        "arcs": [
          [0, 0],
          [1, 0],
          [4, 0],
          [3, 0],
          [4, 0]
        ]
      }
    }));
    expect(
        junctions,
        unorderedEquals([
          [0, 0],
          [4, 0]
        ]));
  });

  test(
      "join when an old line ABCDBE self-intersects and shares a point B, there is a junction at B",
      () {
    var junctions = join(extract({
      "abcdbe": {
        "type": "LineString",
        "arcs": [
          [0, 0],
          [1, 0],
          [2, 0],
          [3, 0],
          [1, 0],
          [4, 0]
        ]
      },
      "fbg": {
        "type": "LineString",
        "arcs": [
          [0, 1],
          [1, 0],
          [2, 1]
        ]
      }
    }));
    expect(
        junctions,
        unorderedEquals([
          [0, 0],
          [4, 0],
          [1, 0],
          [0, 1],
          [2, 1]
        ]));
  });

  test("join when a line ABCA is closed, there is a junction at A", () {
    var junctions = join(extract({
      "abca": {
        "type": "LineString",
        "arcs": [
          [0, 0],
          [1, 0],
          [0, 1],
          [0, 0]
        ]
      }
    }));
    expect(
        junctions,
        unorderedEquals([
          [0, 0]
        ]));
  });

  test("join when a ring ABCA is closed, there are no junctions", () {
    var junctions = join(extract({
      "abca": {
        "type": "Polygon",
        "arcs": [
          [
            [0, 0],
            [1, 0],
            [0, 1],
            [0, 0]
          ]
        ]
      }
    }));
    expect(junctions, isEmpty);
  });

  test("join exact duplicate rings ABCA & ABCA share the arc ABCA", () {
    var junctions = join(extract({
      "abca": {
        "type": "Polygon",
        "arcs": [
          [
            [0, 0],
            [1, 0],
            [0, 1],
            [0, 0]
          ]
        ]
      },
      "abca2": {
        "type": "Polygon",
        "arcs": [
          [
            [0, 0],
            [1, 0],
            [0, 1],
            [0, 0]
          ]
        ]
      }
    }));
    expect(junctions, isEmpty);
  });

  test("join reversed duplicate rings ABCA & ACBA share the arc ABCA", () {
    var junctions = join(extract({
      "abca": {
        "type": "Polygon",
        "arcs": [
          [
            [0, 0],
            [1, 0],
            [0, 1],
            [0, 0]
          ]
        ]
      },
      "acba": {
        "type": "Polygon",
        "arcs": [
          [
            [0, 0],
            [0, 1],
            [1, 0],
            [0, 0]
          ]
        ]
      }
    }));
    expect(junctions, isEmpty);
  });

  test("join coincident rings ABCA & BCAB share the arc BCAB", () {
    var junctions = join(extract({
      "abca": {
        "type": "Polygon",
        "arcs": [
          [
            [0, 0],
            [1, 0],
            [0, 1],
            [0, 0]
          ]
        ]
      },
      "bcab": {
        "type": "Polygon",
        "arcs": [
          [
            [1, 0],
            [0, 1],
            [0, 0],
            [1, 0]
          ]
        ]
      }
    }));
    expect(junctions, isEmpty);
  });

  test("join coincident rings ABCA & BACB share the arc BCAB", () {
    var junctions = join(extract({
      "abca": {
        "type": "Polygon",
        "arcs": [
          [
            [0, 0],
            [1, 0],
            [0, 1],
            [0, 0]
          ]
        ]
      },
      "bacb": {
        "type": "Polygon",
        "arcs": [
          [
            [1, 0],
            [0, 0],
            [0, 1],
            [1, 0]
          ]
        ]
      }
    }));
    expect(junctions, isEmpty);
  });

  test("join coincident rings ABCA & DBED share the point B", () {
    var junctions = join(extract({
      "abca": {
        "type": "Polygon",
        "arcs": [
          [
            [0, 0],
            [1, 0],
            [0, 1],
            [0, 0]
          ]
        ]
      },
      "dbed": {
        "type": "Polygon",
        "arcs": [
          [
            [2, 1],
            [1, 0],
            [2, 2],
            [2, 1]
          ]
        ]
      }
    }));
    expect(
        junctions,
        unorderedEquals([
          [1, 0]
        ]));
  });

  test("join coincident ring ABCA & line DBE share the point B", () {
    var junctions = join(extract({
      "abca": {
        "type": "Polygon",
        "arcs": [
          [
            [0, 0],
            [1, 0],
            [0, 1],
            [0, 0]
          ]
        ]
      },
      "dbe": {
        "type": "LineString",
        "arcs": [
          [2, 1],
          [1, 0],
          [2, 2]
        ]
      }
    }));
    expect(
        junctions,
        unorderedEquals([
          [2, 1],
          [2, 2],
          [1, 0]
        ]));
  });
}
