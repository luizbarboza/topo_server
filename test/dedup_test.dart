// ignore_for_file: lines_longer_than_80_chars

import 'package:test/test.dart';
import 'package:topo_server/src/arc.dart';
import 'package:topo_server/src/cut.dart';
import 'package:topo_server/src/dedup.dart';
import 'package:topo_server/src/extract.dart';

void main() {
  test("dedup exact duplicate lines ABC & ABC share an arc", () {
    var topology = dedup(cut(extract({
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
    })));
    expect(topology["objects"], {
      "abc": {"type": "LineString", "arcs": Arc(0, 2)},
      "abc2": {"type": "LineString", "arcs": Arc(0, 2)}
    });
  });

  test("dedup reversed duplicate lines ABC & CBA share an arc", () {
    var topology = dedup(cut(extract({
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
    })));
    expect(topology["objects"], {
      "abc": {"type": "LineString", "arcs": Arc(0, 2)},
      "cba": {"type": "LineString", "arcs": Arc(2, 0)}
    });
  });

  test("dedup exact duplicate rings ABCA & ABCA share an arc", () {
    var topology = dedup(cut(extract({
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
    })));
    expect(topology["objects"], {
      "abca": {
        "type": "Polygon",
        "arcs": [Arc(0, 3)]
      },
      "abca2": {
        "type": "Polygon",
        "arcs": [Arc(0, 3)]
      }
    });
  });

  test("dedup reversed duplicate rings ACBA & ABCA share an arc", () {
    var topology = dedup(cut(extract({
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
    })));
    expect(topology["objects"], {
      "abca": {
        "type": "Polygon",
        "arcs": [Arc(0, 3)]
      },
      "acba": {
        "type": "Polygon",
        "arcs": [Arc(3, 0)]
      }
    });
  });

  test("dedup rotated duplicate rings BCAB & ABCA share an arc", () {
    var topology = dedup(cut(extract({
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
    })));
    expect(topology["objects"], {
      "abca": {
        "type": "Polygon",
        "arcs": [Arc(0, 3)]
      },
      "bcab": {
        "type": "Polygon",
        "arcs": [Arc(0, 3)]
      }
    });
  });

  test("dedup ring ABCA & line ABCA have no cuts", () {
    var topology = dedup(cut(extract({
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
    })));
    expect(topology["objects"], {
      "abcaLine": {"type": "LineString", "arcs": Arc(0, 3)},
      "abcaPolygon": {
        "type": "Polygon",
        "arcs": [Arc(0, 3)]
      }
    });
  });

  test("dedup ring BCAB & line ABCA have no cuts", () {
    var topology = dedup(cut(extract({
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
    })));
    expect(topology["objects"], {
      "abcaLine": {"type": "LineString", "arcs": Arc(0, 3)},
      "bcabPolygon": {
        "type": "Polygon",
        "arcs": [Arc(0, 3)]
      }
    });
    expect(topology["coordinates"].sublist(4, 8), [
      [0, 0],
      [1, 0],
      [2, 0],
      [0, 0]
    ]);
  });

  test("dedup ring ABCA & line BCAB have no cuts", () {
    var topology = dedup(cut(extract({
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
      }, // rotated to BCAB
    })));
    expect(topology["objects"], {
      "bcabLine": {"type": "LineString", "arcs": Arc(0, 3)},
      "abcaPolygon": {
        "type": "Polygon",
        "arcs": [Arc(0, 3)]
      }
    });
  });

  test("dedup when an old arc ABC extends a new arc AB, ABC is cut into AB-BC",
      () {
    var topology = dedup(cut(extract({
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
    })));
    expect(topology["objects"], {
      "abc": {"type": "LineString", "arcs": Arc(0, 1, next: Arc(1, 2))},
      "ab": {"type": "LineString", "arcs": Arc(0, 1)}
    });
  });

  test(
      "dedup when a reversed old arc CBA extends a new arc AB, CBA is cut into CB-BA",
      () {
    var topology = dedup(cut(extract({
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
    })));
    expect(topology["objects"], {
      "cba": {"type": "LineString", "arcs": Arc(0, 1, next: Arc(1, 2))},
      "ab": {"type": "LineString", "arcs": Arc(2, 1)}
    });
  });

  test(
      "dedup when a new arc ADE shares its start with an old arc ABC, there are no cuts",
      () {
    var topology = dedup(cut(extract({
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
    })));
    expect(topology["objects"], {
      "ade": {"type": "LineString", "arcs": Arc(0, 2)},
      "abc": {"type": "LineString", "arcs": Arc(3, 5)}
    });
  });

  test("dedup ring ABA has no cuts", () {
    var topology = dedup(cut(extract({
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
    })));
    expect(topology["objects"], {
      "aba": {
        "type": "Polygon",
        "arcs": [Arc(0, 2)]
      }
    });
  });

  test("dedup ring AA has no cuts", () {
    var topology = dedup(cut(extract({
      "aa": {
        "type": "Polygon",
        "arcs": [
          [
            [0, 0],
            [0, 0]
          ]
        ]
      },
    })));
    expect(topology["objects"], {
      "aa": {
        "type": "Polygon",
        "arcs": [Arc(0, 1)]
      }
    });
  });

  test("dedup degenerate ring A has no cuts", () {
    var topology = dedup(cut(extract({
      "a": {
        "type": "Polygon",
        "arcs": [
          [
            [0, 0]
          ]
        ]
      },
    })));
    expect(topology["objects"], {
      "a": {
        "type": "Polygon",
        "arcs": [Arc(0, 0)]
      }
    });
  });

  test(
      "dedup when a new line DEC shares its end with an old line ABC, there are no cuts",
      () {
    var topology = dedup(cut(extract({
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
    })));
    expect(topology["objects"], {
      "abc": {"type": "LineString", "arcs": Arc(0, 2)},
      "dec": {"type": "LineString", "arcs": Arc(3, 5)}
    });
  });

  test(
      "dedup when a new line ABC extends an old line AB, ABC is cut into AB-BC",
      () {
    var topology = dedup(cut(extract({
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
    })));
    expect(topology["objects"], {
      "ab": {"type": "LineString", "arcs": Arc(0, 1)},
      "abc": {"type": "LineString", "arcs": Arc(0, 1, next: Arc(3, 4))}
    });
  });

  test(
      "dedup when a new line ABC extends a reversed old line BA, ABC is cut into AB-BC",
      () {
    var topology = dedup(cut(extract({
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
    })));
    expect(topology["objects"], {
      "ba": {"type": "LineString", "arcs": Arc(0, 1)},
      "abc": {"type": "LineString", "arcs": Arc(1, 0, next: Arc(3, 4))}
    });
  });

  test(
      "dedup when a new line starts BC in the middle of an old line ABC, ABC is cut into AB-BC",
      () {
    var topology = dedup(cut(extract({
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
    })));
    expect(topology["objects"], {
      "abc": {"type": "LineString", "arcs": Arc(0, 1, next: Arc(1, 2))},
      "bc": {"type": "LineString", "arcs": Arc(1, 2)}
    });
  });

  test(
      "dedup when a new line BC starts in the middle of a reversed old line CBA, CBA is cut into CB-BA",
      () {
    var topology = dedup(cut(extract({
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
    })));
    expect(topology["objects"], {
      "cba": {"type": "LineString", "arcs": Arc(0, 1, next: Arc(1, 2))},
      "bc": {"type": "LineString", "arcs": Arc(1, 0)}
    });
  });

  test(
      "dedup when a new line ABD deviates from an old line ABC, ABD is cut into AB-BD and ABC is cut into AB-BC",
      () {
    var topology = dedup(cut(extract({
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
    })));
    expect(topology["objects"], {
      "abc": {"type": "LineString", "arcs": Arc(0, 1, next: Arc(1, 2))},
      "abd": {"type": "LineString", "arcs": Arc(0, 1, next: Arc(4, 5))}
    });
  });

  test(
      "dedup when a new line ABD deviates from a reversed old line CBA, CBA is cut into CB-BA and ABD is cut into AB-BD",
      () {
    var topology = dedup(cut(extract({
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
    })));
    expect(topology["objects"], {
      "cba": {"type": "LineString", "arcs": Arc(0, 1, next: Arc(1, 2))},
      "abd": {"type": "LineString", "arcs": Arc(2, 1, next: Arc(4, 5))}
    });
  });

  test(
      "dedup when a new line DBC merges into an old line ABC, DBC is cut into DB-BC and ABC is cut into AB-BC",
      () {
    var topology = dedup(cut(extract({
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
    })));
    expect(topology["objects"], {
      "abc": {"type": "LineString", "arcs": Arc(0, 1, next: Arc(1, 2))},
      "dbc": {"type": "LineString", "arcs": Arc(3, 4, next: Arc(1, 2))}
    });
  });

  test(
      "dedup when a new line DBC merges into a reversed old line CBA, DBC is cut into DB-BC and CBA is cut into CB-BA",
      () {
    var topology = dedup(cut(extract({
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
    })));
    expect(topology["objects"], {
      "cba": {"type": "LineString", "arcs": Arc(0, 1, next: Arc(1, 2))},
      "dbc": {"type": "LineString", "arcs": Arc(3, 4, next: Arc(1, 0))}
    });
  });

  test(
      "dedup when a new line DBE shares a single midpoint with an old line ABC, DBE is cut into DB-BE and ABC is cut into AB-BC",
      () {
    var topology = dedup(cut(extract({
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
    })));
    expect(topology["objects"], {
      "abc": {"type": "LineString", "arcs": Arc(0, 1, next: Arc(1, 2))},
      "dbe": {"type": "LineString", "arcs": Arc(3, 4, next: Arc(4, 5))}
    });
  });

  test(
      "dedup when a new line ABDE skips a point with an old line ABCDE, ABDE is cut into AB-BD-DE and ABCDE is cut into AB-BCD-DE",
      () {
    var topology = dedup(cut(extract({
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
    })));
    expect(topology["objects"], {
      "abcde": {
        "type": "LineString",
        "arcs": Arc(0, 1, next: Arc(1, 3, next: Arc(3, 4)))
      },
      "abde": {
        "type": "LineString",
        "arcs": Arc(0, 1, next: Arc(6, 7, next: Arc(3, 4)))
      }
    });
  });

  test(
      "dedup when a new line ABDE skips a point with a reversed old line EDCBA, ABDE is cut into AB-BD-DE and EDCBA is cut into ED-DCB-BA",
      () {
    var topology = dedup(cut(extract({
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
    })));
    expect(topology["objects"], {
      "edcba": {
        "type": "LineString",
        "arcs": Arc(0, 1, next: Arc(1, 3, next: Arc(3, 4)))
      },
      "abde": {
        "type": "LineString",
        "arcs": Arc(4, 3, next: Arc(6, 7, next: Arc(1, 0)))
      }
    });
  });

  test(
      "dedup when a line ABCDBE self-intersects with its middle, it is not cut",
      () {
    var topology = dedup(cut(extract({
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
    })));
    expect(topology["objects"], {
      "abcdbe": {"type": "LineString", "arcs": Arc(0, 5)}
    });
  });

  test(
      "dedup when a line ABACD self-intersects with its start, it is cut into ABA-ACD",
      () {
    var topology = dedup(cut(extract({
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
    })));
    expect(topology["objects"], {
      "abacd": {"type": "LineString", "arcs": Arc(0, 2, next: Arc(2, 4))}
    });
  });

  test(
      "dedup when a line ABDCD self-intersects with its end, it is cut into ABD-DCD",
      () {
    var topology = dedup(cut(extract({
      "abdcd": {
        "type": "LineString",
        "arcs": [
          [0, 0],
          [1, 0],
          [4, 0],
          [3, 0],
          [4, 0]
        ]
      }
    })));
    expect(topology["objects"], {
      "abdcd": {"type": "LineString", "arcs": Arc(0, 2, next: Arc(2, 4))}
    });
  });

  test(
      "dedup when an old line ABCDBE self-intersects and shares a point B, ABCDBE is cut into AB-BCDB-BE and FBG is cut into FB-BG",
      () {
    var topology = dedup(cut(extract({
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
    })));
    expect(topology["objects"], {
      "abcdbe": {
        "type": "LineString",
        "arcs": Arc(0, 1, next: Arc(1, 4, next: Arc(4, 5)))
      },
      "fbg": {"type": "LineString", "arcs": Arc(6, 7, next: Arc(7, 8))}
    });
  });

  test("dedup when a line ABCA is closed, there are no cuts", () {
    var topology = dedup(cut(extract({
      "abca": {
        "type": "LineString",
        "arcs": [
          [0, 0],
          [1, 0],
          [0, 1],
          [0, 0]
        ]
      }
    })));
    expect(topology["objects"], {
      "abca": {"type": "LineString", "arcs": Arc(0, 3)}
    });
  });

  test("dedup when a ring ABCA is closed, there are no cuts", () {
    var topology = dedup(cut(extract({
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
    })));
    expect(topology["objects"], {
      "abca": {
        "type": "Polygon",
        "arcs": [Arc(0, 3)]
      }
    });
  });

  test("dedup exact duplicate rings ABCA & ABCA have no cuts", () {
    var topology = dedup(cut(extract({
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
    })));
    expect(topology["objects"], {
      "abca": {
        "type": "Polygon",
        "arcs": [Arc(0, 3)]
      },
      "abca2": {
        "type": "Polygon",
        "arcs": [Arc(0, 3)]
      }
    });
  });

  test("dedup reversed duplicate rings ABCA & ACBA have no cuts", () {
    var topology = dedup(cut(extract({
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
    })));
    expect(topology["objects"], {
      "abca": {
        "type": "Polygon",
        "arcs": [Arc(0, 3)]
      },
      "acba": {
        "type": "Polygon",
        "arcs": [Arc(3, 0)]
      }
    });
  });

  test("dedup coincident rings ABCA & BCAB have no cuts", () {
    var topology = dedup(cut(extract({
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
    })));
    expect(topology["objects"], {
      "abca": {
        "type": "Polygon",
        "arcs": [Arc(0, 3)]
      },
      "bcab": {
        "type": "Polygon",
        "arcs": [Arc(0, 3)]
      }
    });
  });

  test("dedup coincident reversed rings ABCA & BACB have no cuts", () {
    var topology = dedup(cut(extract({
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
    })));
    expect(topology["objects"], {
      "abca": {
        "type": "Polygon",
        "arcs": [Arc(0, 3)]
      },
      "bacb": {
        "type": "Polygon",
        "arcs": [Arc(3, 0)]
      }
    });
  });

  test(
      "dedup coincident rings ABCDA, EFAE & GHCG are cut into ABC-CDA, EFAE and GHCG",
      () {
    var topology = dedup(cut(extract({
      "abcda": {
        "type": "Polygon",
        "arcs": [
          [
            [0, 0],
            [1, 0],
            [1, 1],
            [0, 1],
            [0, 0]
          ]
        ]
      },
      "efae": {
        "type": "Polygon",
        "arcs": [
          [
            [0, -1],
            [1, -1],
            [0, 0],
            [0, -1]
          ]
        ]
      },
      "ghcg": {
        "type": "Polygon",
        "arcs": [
          [
            [0, 2],
            [1, 2],
            [1, 1],
            [0, 2]
          ]
        ]
      }
    })));
    expect(topology["objects"], {
      "abcda": {
        "type": "Polygon",
        "arcs": [Arc(0, 2, next: Arc(2, 4))]
      },
      "efae": {
        "type": "Polygon",
        "arcs": [Arc(5, 8)]
      },
      "ghcg": {
        "type": "Polygon",
        "arcs": [Arc(9, 12)]
      }
    });
  });

  test(
      "dedup coincident rings ABCA & DBED have no cuts, but are rotated to share B",
      () {
    var topology = dedup(cut(extract({
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
    })));
    expect(topology["objects"], {
      "abca": {
        "type": "Polygon",
        "arcs": [Arc(0, 3)]
      },
      "dbed": {
        "type": "Polygon",
        "arcs": [Arc(4, 7)]
      }
    });
    expect(topology["coordinates"].sublist(0, 4), [
      [1, 0],
      [0, 1],
      [0, 0],
      [1, 0]
    ]);
    expect(topology["coordinates"].sublist(4, 8), [
      [1, 0],
      [2, 2],
      [2, 1],
      [1, 0]
    ]);
  });

  test(
      "dedup overlapping rings ABCDA and BEFCB are cut into BC-CDAB and BEFC-CB",
      () {
    var topology = dedup(cut(extract({
      "abcda": {
        "type": "Polygon",
        "arcs": [
          [
            [0, 0],
            [1, 0],
            [1, 1],
            [0, 1],
            [0, 0]
          ]
        ]
      }, // rotated to BCDAB, cut BC-CDAB
      "befcb": {
        "type": "Polygon",
        "arcs": [
          [
            [1, 0],
            [2, 0],
            [2, 1],
            [1, 1],
            [1, 0]
          ]
        ]
      },
    })));
    expect(topology["objects"], {
      "abcda": {
        "type": "Polygon",
        "arcs": [Arc(0, 1, next: Arc(1, 4))]
      },
      "befcb": {
        "type": "Polygon",
        "arcs": [Arc(5, 8, next: Arc(1, 0))]
      }
    });
  });
}
