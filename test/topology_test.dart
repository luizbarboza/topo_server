// ignore_for_file: lines_longer_than_80_chars

import 'package:test/test.dart';
import 'package:topo_client/topo_client.dart' as client;
import 'package:topo_server/topo_server.dart' as topojson;

void main() {
  test("topology exact duplicate lines ABC & ABC share the arc ABC", () {
    var topology = topojson.topology({
      "foo": {
        "type": "LineString",
        "coordinates": [
          [0, 0],
          [1, 0],
          [2, 0]
        ]
      },
      "bar": {
        "type": "LineString",
        "coordinates": [
          [0, 0],
          [1, 0],
          [2, 0]
        ]
      }
    });
    expect(topology, {
      "type": "Topology",
      "bbox": [0, 0, 2, 0],
      "arcs": [
        [
          [0, 0],
          [1, 0],
          [2, 0]
        ]
      ],
      "objects": {
        "foo": {
          "type": "LineString",
          "arcs": [0]
        },
        "bar": {
          "type": "LineString",
          "arcs": [0]
        }
      }
    });
  });

  test("topology reversed duplicate lines ABC & CBA share the arc ABC", () {
    var topology = topojson.topology({
      "foo": {
        "type": "LineString",
        "coordinates": [
          [0, 0],
          [1, 0],
          [2, 0]
        ]
      },
      "bar": {
        "type": "LineString",
        "coordinates": [
          [2, 0],
          [1, 0],
          [0, 0]
        ]
      }
    });
    expect(topology, {
      "type": "Topology",
      "bbox": [0, 0, 2, 0],
      "arcs": [
        [
          [0, 0],
          [1, 0],
          [2, 0]
        ]
      ],
      "objects": {
        "foo": {
          "type": "LineString",
          "arcs": [0]
        },
        "bar": {
          "type": "LineString",
          "arcs": [~0]
        }
      }
    });
  });

  test(
      "topology when an old arc ABC extends a new arc AB, they share the arc AB",
      () {
    var topology = topojson.topology({
      "foo": {
        "type": "LineString",
        "coordinates": [
          [0, 0],
          [1, 0],
          [2, 0]
        ]
      },
      "bar": {
        "type": "LineString",
        "coordinates": [
          [0, 0],
          [1, 0]
        ]
      }
    });
    expect(topology, {
      "type": "Topology",
      "bbox": [0, 0, 2, 0],
      "arcs": [
        [
          [0, 0],
          [1, 0]
        ],
        [
          [1, 0],
          [2, 0]
        ]
      ],
      "objects": {
        "foo": {
          "type": "LineString",
          "arcs": [0, 1]
        },
        "bar": {
          "type": "LineString",
          "arcs": [0]
        }
      }
    });
  });

  test(
      "topology when a reversed old arc CBA extends a new arc AB, they share the arc BA",
      () {
    var topology = topojson.topology({
      "foo": {
        "type": "LineString",
        "coordinates": [
          [2, 0],
          [1, 0],
          [0, 0]
        ]
      },
      "bar": {
        "type": "LineString",
        "coordinates": [
          [0, 0],
          [1, 0]
        ]
      }
    });
    expect(topology, {
      "type": "Topology",
      "bbox": [0, 0, 2, 0],
      "arcs": [
        [
          [2, 0],
          [1, 0]
        ],
        [
          [1, 0],
          [0, 0]
        ]
      ],
      "objects": {
        "foo": {
          "type": "LineString",
          "arcs": [0, 1]
        },
        "bar": {
          "type": "LineString",
          "arcs": [~1]
        }
      }
    });
  });

  test(
      "topology when a new arc ADE shares its start with an old arc ABC, they don’t share arcs",
      () {
    var topology = topojson.topology({
      "foo": {
        "type": "LineString",
        "coordinates": [
          [0, 0],
          [1, 0],
          [2, 0]
        ]
      },
      "bar": {
        "type": "LineString",
        "coordinates": [
          [0, 0],
          [1, 1],
          [2, 1]
        ]
      }
    });
    expect(topology, {
      "type": "Topology",
      "bbox": [0, 0, 2, 1],
      "arcs": [
        [
          [0, 0],
          [1, 0],
          [2, 0]
        ],
        [
          [0, 0],
          [1, 1],
          [2, 1]
        ]
      ],
      "objects": {
        "foo": {
          "type": "LineString",
          "arcs": [0]
        },
        "bar": {
          "type": "LineString",
          "arcs": [1]
        }
      }
    });
  });

  test(
      "topology when a new arc DEC shares its start with an old arc ABC, they don’t share arcs",
      () {
    var topology = topojson.topology({
      "foo": {
        "type": "LineString",
        "coordinates": [
          [0, 0],
          [1, 0],
          [2, 0]
        ]
      },
      "bar": {
        "type": "LineString",
        "coordinates": [
          [0, 1],
          [1, 1],
          [2, 0]
        ]
      }
    });
    expect(topology, {
      "type": "Topology",
      "bbox": [0, 0, 2, 1],
      "arcs": [
        [
          [0, 0],
          [1, 0],
          [2, 0]
        ],
        [
          [0, 1],
          [1, 1],
          [2, 0]
        ]
      ],
      "objects": {
        "foo": {
          "type": "LineString",
          "arcs": [0]
        },
        "bar": {
          "type": "LineString",
          "arcs": [1]
        }
      }
    });
  });

  test(
      "topology when a new arc ABC extends an old arc AB, they share the arc AB",
      () {
    var topology = topojson.topology({
      "foo": {
        "type": "LineString",
        "coordinates": [
          [0, 0],
          [1, 0]
        ]
      },
      "bar": {
        "type": "LineString",
        "coordinates": [
          [0, 0],
          [1, 0],
          [2, 0]
        ]
      }
    });
    expect(topology, {
      "type": "Topology",
      "bbox": [0, 0, 2, 0],
      "arcs": [
        [
          [0, 0],
          [1, 0]
        ],
        [
          [1, 0],
          [2, 0]
        ]
      ],
      "objects": {
        "foo": {
          "type": "LineString",
          "arcs": [0]
        },
        "bar": {
          "type": "LineString",
          "arcs": [0, 1]
        }
      }
    });
  });

  test(
      "topology when a new arc ABC extends a reversed old arc BA, they share the arc BA",
      () {
    var topology = topojson.topology({
      "foo": {
        "type": "LineString",
        "coordinates": [
          [1, 0],
          [0, 0]
        ]
      },
      "bar": {
        "type": "LineString",
        "coordinates": [
          [0, 0],
          [1, 0],
          [2, 0]
        ]
      }
    });
    expect(topology, {
      "type": "Topology",
      "bbox": [0, 0, 2, 0],
      "arcs": [
        [
          [1, 0],
          [0, 0]
        ],
        [
          [1, 0],
          [2, 0]
        ]
      ],
      "objects": {
        "foo": {
          "type": "LineString",
          "arcs": [0]
        },
        "bar": {
          "type": "LineString",
          "arcs": [~0, 1]
        }
      }
    });
  });

  test(
      "topology when a new arc starts BC in the middle of an old arc ABC, they share the arc BC",
      () {
    var topology = topojson.topology({
      "foo": {
        "type": "LineString",
        "coordinates": [
          [0, 0],
          [1, 0],
          [2, 0]
        ]
      },
      "bar": {
        "type": "LineString",
        "coordinates": [
          [1, 0],
          [2, 0]
        ]
      }
    });
    expect(topology, {
      "type": "Topology",
      "bbox": [0, 0, 2, 0],
      "arcs": [
        [
          [0, 0],
          [1, 0]
        ],
        [
          [1, 0],
          [2, 0]
        ]
      ],
      "objects": {
        "foo": {
          "type": "LineString",
          "arcs": [0, 1]
        },
        "bar": {
          "type": "LineString",
          "arcs": [1]
        }
      }
    });
  });

  test(
      "topology when a new arc BC starts in the middle of a reversed old arc CBA, they share the arc CB",
      () {
    var topology = topojson.topology({
      "foo": {
        "type": "LineString",
        "coordinates": [
          [2, 0],
          [1, 0],
          [0, 0]
        ]
      },
      "bar": {
        "type": "LineString",
        "coordinates": [
          [1, 0],
          [2, 0]
        ]
      }
    });
    expect(topology, {
      "type": "Topology",
      "bbox": [0, 0, 2, 0],
      "arcs": [
        [
          [2, 0],
          [1, 0]
        ],
        [
          [1, 0],
          [0, 0]
        ]
      ],
      "objects": {
        "foo": {
          "type": "LineString",
          "arcs": [0, 1]
        },
        "bar": {
          "type": "LineString",
          "arcs": [~0]
        }
      }
    });
  });

  test(
      "topology when a new arc ABD deviates from an old arc ABC, they share the arc AB",
      () {
    var topology = topojson.topology({
      "foo": {
        "type": "LineString",
        "coordinates": [
          [0, 0],
          [1, 0],
          [2, 0]
        ]
      },
      "bar": {
        "type": "LineString",
        "coordinates": [
          [0, 0],
          [1, 0],
          [3, 0]
        ]
      }
    });
    expect(topology, {
      "type": "Topology",
      "bbox": [0, 0, 3, 0],
      "arcs": [
        [
          [0, 0],
          [1, 0]
        ],
        [
          [1, 0],
          [2, 0]
        ],
        [
          [1, 0],
          [3, 0]
        ]
      ],
      "objects": {
        "foo": {
          "type": "LineString",
          "arcs": [0, 1]
        },
        "bar": {
          "type": "LineString",
          "arcs": [0, 2]
        }
      }
    });
  });

  test(
      "topology when a new arc ABD deviates from a reversed old arc CBA, they share the arc BA",
      () {
    var topology = topojson.topology({
      "foo": {
        "type": "LineString",
        "coordinates": [
          [2, 0],
          [1, 0],
          [0, 0]
        ]
      },
      "bar": {
        "type": "LineString",
        "coordinates": [
          [0, 0],
          [1, 0],
          [3, 0]
        ]
      }
    });
    expect(topology, {
      "type": "Topology",
      "bbox": [0, 0, 3, 0],
      "arcs": [
        [
          [2, 0],
          [1, 0]
        ],
        [
          [1, 0],
          [0, 0]
        ],
        [
          [1, 0],
          [3, 0]
        ]
      ],
      "objects": {
        "foo": {
          "type": "LineString",
          "arcs": [0, 1]
        },
        "bar": {
          "type": "LineString",
          "arcs": [~1, 2]
        }
      }
    });
  });

  test(
      "topology when a new arc DBC merges into an old arc ABC, they share the arc BC",
      () {
    var topology = topojson.topology({
      "foo": {
        "type": "LineString",
        "coordinates": [
          [0, 0],
          [1, 0],
          [2, 0]
        ]
      },
      "bar": {
        "type": "LineString",
        "coordinates": [
          [3, 0],
          [1, 0],
          [2, 0]
        ]
      }
    });
    expect(topology, {
      "type": "Topology",
      "bbox": [0, 0, 3, 0],
      "arcs": [
        [
          [0, 0],
          [1, 0]
        ],
        [
          [1, 0],
          [2, 0]
        ],
        [
          [3, 0],
          [1, 0]
        ]
      ],
      "objects": {
        "foo": {
          "type": "LineString",
          "arcs": [0, 1]
        },
        "bar": {
          "type": "LineString",
          "arcs": [2, 1]
        }
      }
    });
  });

  test(
      "topology when a new arc DBC merges into a reversed old arc CBA, they share the arc CB",
      () {
    var topology = topojson.topology({
      "foo": {
        "type": "LineString",
        "coordinates": [
          [2, 0],
          [1, 0],
          [0, 0]
        ]
      },
      "bar": {
        "type": "LineString",
        "coordinates": [
          [3, 0],
          [1, 0],
          [2, 0]
        ]
      }
    });
    expect(topology, {
      "type": "Topology",
      "bbox": [0, 0, 3, 0],
      "arcs": [
        [
          [2, 0],
          [1, 0]
        ],
        [
          [1, 0],
          [0, 0]
        ],
        [
          [3, 0],
          [1, 0]
        ]
      ],
      "objects": {
        "foo": {
          "type": "LineString",
          "arcs": [0, 1]
        },
        "bar": {
          "type": "LineString",
          "arcs": [2, ~0]
        }
      }
    });
  });

  test(
      "topology when a new arc DBE shares a single midpoint with an old arc ABC, they share the point B, but no arcs",
      () {
    var topology = topojson.topology({
      "foo": {
        "type": "LineString",
        "coordinates": [
          [0, 0],
          [1, 0],
          [2, 0]
        ]
      },
      "bar": {
        "type": "LineString",
        "coordinates": [
          [0, 1],
          [1, 0],
          [2, 1]
        ]
      }
    });
    expect(topology, {
      "type": "Topology",
      "bbox": [0, 0, 2, 1],
      "arcs": [
        [
          [0, 0],
          [1, 0]
        ],
        [
          [1, 0],
          [2, 0]
        ],
        [
          [0, 1],
          [1, 0]
        ],
        [
          [1, 0],
          [2, 1]
        ]
      ],
      "objects": {
        "foo": {
          "type": "LineString",
          "arcs": [0, 1]
        },
        "bar": {
          "type": "LineString",
          "arcs": [2, 3]
        }
      }
    });
  });

  test(
      "topology when a new arc ABDE skips a point with an old arc ABCDE, they share arcs AB and DE",
      () {
    var topology = topojson.topology({
      "foo": {
        "type": "LineString",
        "coordinates": [
          [0, 0],
          [1, 0],
          [2, 0],
          [3, 0],
          [4, 0]
        ]
      },
      "bar": {
        "type": "LineString",
        "coordinates": [
          [0, 0],
          [1, 0],
          [3, 0],
          [4, 0]
        ]
      }
    });
    expect(topology, {
      "type": "Topology",
      "bbox": [0, 0, 4, 0],
      "arcs": [
        [
          [0, 0],
          [1, 0]
        ],
        [
          [1, 0],
          [2, 0],
          [3, 0]
        ],
        [
          [3, 0],
          [4, 0]
        ],
        [
          [1, 0],
          [3, 0]
        ]
      ],
      "objects": {
        "foo": {
          "type": "LineString",
          "arcs": [0, 1, 2]
        },
        "bar": {
          "type": "LineString",
          "arcs": [0, 3, 2]
        }
      }
    });
  });

  test(
      "topology when a new arc ABDE skips a point with a reversed old arc EDCBA, they share arcs BA and ED",
      () {
    var topology = topojson.topology({
      "foo": {
        "type": "LineString",
        "coordinates": [
          [4, 0],
          [3, 0],
          [2, 0],
          [1, 0],
          [0, 0]
        ]
      },
      "bar": {
        "type": "LineString",
        "coordinates": [
          [0, 0],
          [1, 0],
          [3, 0],
          [4, 0]
        ]
      }
    });
    expect(topology, {
      "type": "Topology",
      "bbox": [0, 0, 4, 0],
      "arcs": [
        [
          [4, 0],
          [3, 0]
        ],
        [
          [3, 0],
          [2, 0],
          [1, 0]
        ],
        [
          [1, 0],
          [0, 0]
        ],
        [
          [1, 0],
          [3, 0]
        ]
      ],
      "objects": {
        "foo": {
          "type": "LineString",
          "arcs": [0, 1, 2]
        },
        "bar": {
          "type": "LineString",
          "arcs": [~2, 3, ~0]
        }
      }
    });
  });

  test("topology when an arc ABCDBE self-intersects, it is still one arc", () {
    var topology = topojson.topology({
      "foo": {
        "type": "LineString",
        "coordinates": [
          [0, 0],
          [1, 0],
          [2, 0],
          [3, 0],
          [1, 0],
          [4, 0]
        ]
      }
    });
    expect(topology, {
      "type": "Topology",
      "bbox": [0, 0, 4, 0],
      "arcs": [
        [
          [0, 0],
          [1, 0],
          [2, 0],
          [3, 0],
          [1, 0],
          [4, 0]
        ]
      ],
      "objects": {
        "foo": {
          "type": "LineString",
          "arcs": [0]
        }
      }
    });
  });

  test(
      "topology when an old arc ABCDBE self-intersects and shares a point B, the old arc has multiple cuts",
      () {
    var topology = topojson.topology({
      "foo": {
        "type": "LineString",
        "coordinates": [
          [0, 0],
          [1, 0],
          [2, 0],
          [3, 0],
          [1, 0],
          [4, 0]
        ]
      },
      "bar": {
        "type": "LineString",
        "coordinates": [
          [0, 1],
          [1, 0],
          [2, 1]
        ]
      }
    });
    expect(topology, {
      "type": "Topology",
      "bbox": [0, 0, 4, 1],
      "arcs": [
        [
          [0, 0],
          [1, 0]
        ],
        [
          [1, 0],
          [2, 0],
          [3, 0],
          [1, 0]
        ],
        [
          [1, 0],
          [4, 0]
        ],
        [
          [0, 1],
          [1, 0]
        ],
        [
          [1, 0],
          [2, 1]
        ]
      ],
      "objects": {
        "foo": {
          "type": "LineString",
          "arcs": [0, 1, 2]
        },
        "bar": {
          "type": "LineString",
          "arcs": [3, 4]
        }
      }
    });
  });

  test("topology when an arc ABCA is closed, it has one arc", () {
    var topology = topojson.topology({
      "foo": {
        "type": "LineString",
        "coordinates": [
          [0, 0],
          [1, 0],
          [0, 1],
          [0, 0]
        ]
      }
    });
    expect(topology, {
      "type": "Topology",
      "bbox": [0, 0, 1, 1],
      "arcs": [
        [
          [0, 0],
          [1, 0],
          [0, 1],
          [0, 0]
        ]
      ],
      "objects": {
        "foo": {
          "type": "LineString",
          "arcs": [0]
        }
      }
    });
  });

  test("topology exact duplicate closed lines ABCA & ABCA share the arc ABCA",
      () {
    var topology = topojson.topology({
      "foo": {
        "type": "LineString",
        "coordinates": [
          [0, 0],
          [1, 0],
          [0, 1],
          [0, 0]
        ]
      },
      "bar": {
        "type": "LineString",
        "coordinates": [
          [0, 0],
          [1, 0],
          [0, 1],
          [0, 0]
        ]
      }
    });
    expect(topology, {
      "type": "Topology",
      "bbox": [0, 0, 1, 1],
      "arcs": [
        [
          [0, 0],
          [1, 0],
          [0, 1],
          [0, 0]
        ]
      ],
      "objects": {
        "foo": {
          "type": "LineString",
          "arcs": [0]
        },
        "bar": {
          "type": "LineString",
          "arcs": [0]
        }
      }
    });
  });

  test(
      "topology reversed duplicate closed lines ABCA & ACBA share the arc ABCA",
      () {
    var topology = topojson.topology({
      "foo": {
        "type": "LineString",
        "coordinates": [
          [0, 0],
          [1, 0],
          [0, 1],
          [0, 0]
        ]
      },
      "bar": {
        "type": "LineString",
        "coordinates": [
          [0, 0],
          [0, 1],
          [1, 0],
          [0, 0]
        ]
      }
    });
    expect(topology, {
      "type": "Topology",
      "bbox": [0, 0, 1, 1],
      "arcs": [
        [
          [0, 0],
          [1, 0],
          [0, 1],
          [0, 0]
        ]
      ],
      "objects": {
        "foo": {
          "type": "LineString",
          "arcs": [0]
        },
        "bar": {
          "type": "LineString",
          "arcs": [~0]
        }
      }
    });
  });

  test("topology coincident closed polygons ABCA & BCAB share the arc BCAB",
      () {
    var topology = topojson.topology({
      "abca": {
        "type": "Polygon",
        "coordinates": [
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
        "coordinates": [
          [
            [1, 0],
            [0, 1],
            [0, 0],
            [1, 0]
          ]
        ]
      }
    });
    expect(topology, {
      "type": "Topology",
      "bbox": [0, 0, 1, 1],
      "arcs": [
        [
          [0, 0],
          [1, 0],
          [0, 1],
          [0, 0]
        ]
      ],
      "objects": {
        "abca": {
          "type": "Polygon",
          "arcs": [
            [0]
          ]
        },
        "bcab": {
          "type": "Polygon",
          "arcs": [
            [0]
          ]
        }
      }
    });
  });

  test(
      "topology coincident reversed closed polygons ABCA & BACB share the arc BCAB",
      () {
    var topology = topojson.topology({
      "abca": {
        "type": "Polygon",
        "coordinates": [
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
        "coordinates": [
          [
            [1, 0],
            [0, 0],
            [0, 1],
            [1, 0]
          ]
        ]
      }
    });
    expect(topology, {
      "type": "Topology",
      "bbox": [0, 0, 1, 1],
      "arcs": [
        [
          [0, 0],
          [1, 0],
          [0, 1],
          [0, 0]
        ]
      ],
      "objects": {
        "abca": {
          "type": "Polygon",
          "arcs": [
            [0]
          ]
        },
        "bacb": {
          "type": "Polygon",
          "arcs": [
            [~0]
          ]
        }
      }
    });
  });

  test("topology coincident closed polygons ABCA & DBED share the point B", () {
    var topology = topojson.topology({
      "abca": {
        "type": "Polygon",
        "coordinates": [
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
        "coordinates": [
          [
            [2, 1],
            [1, 0],
            [2, 2],
            [2, 1]
          ]
        ]
      }
    });
    expect(topology, {
      "type": "Topology",
      "bbox": [0, 0, 2, 2],
      "arcs": [
        [
          [1, 0],
          [0, 1],
          [0, 0],
          [1, 0]
        ],
        [
          [1, 0],
          [2, 2],
          [2, 1],
          [1, 0]
        ]
      ],
      "objects": {
        "abca": {
          "type": "Polygon",
          "arcs": [
            [0]
          ]
        },
        "dbed": {
          "type": "Polygon",
          "arcs": [
            [1]
          ]
        }
      }
    });
  });

// The topology `objects` is a map of geometry objects by name, allowing
// multiple GeoJSON geometry objects to share the same topology. When you
// pass multiple input files to bin/topojson, the basename of the file is
// used as the key, but you're welcome to edit the file to change it.
  test("topology input objects are mapped to topology.objects", () {
    var topology = topojson.topology({
      "foo": {
        "type": "LineString",
        "coordinates": [
          [.1, .2],
          [.3, .4]
        ]
      },
      "bar": {
        "type": "Polygon",
        "coordinates": [
          [
            [.5, .6],
            [.7, .8]
          ]
        ]
      }
    });
    expect(topology["objects"]["foo"]["type"], "LineString");
    expect(topology["objects"]["bar"]["type"], "Polygon");
  });

// TopoJSON doesn't use features because you can represent the same
// information more compactly just by using geometry objects.
  test("topology features are mapped to geometries", () {
    var topology = topojson.topology({
      "foo": {
        "type": "Feature",
        "geometry": {
          "type": "LineString",
          "coordinates": [
            [.1, .2],
            [.3, .4]
          ]
        }
      },
      "bar": {
        "type": "Feature",
        "geometry": {
          "type": "Polygon",
          "coordinates": [
            [
              [.5, .6],
              [.7, .8]
            ]
          ]
        }
      }
    });
    expect(topology["objects"]["foo"]["type"], "LineString");
    expect(topology["objects"]["bar"]["type"], "Polygon");
  });

  test("topology feature collections are mapped to geometry collections", () {
    var topology = topojson.topology({
      "collection": {
        "type": "FeatureCollection",
        "features": [
          {
            "type": "Feature",
            "geometry": {
              "type": "LineString",
              "coordinates": [
                [.1, .2],
                [.3, .4]
              ]
            }
          },
          {
            "type": "Feature",
            "geometry": {
              "type": "Polygon",
              "coordinates": [
                [
                  [.5, .6],
                  [.7, .8]
                ]
              ]
            }
          }
        ]
      }
    });
    expect(topology["objects"]["collection"]["type"], "GeometryCollection");
    expect(topology["objects"]["collection"]["geometries"].length, 2);
    expect(topology["objects"]["collection"]["geometries"][0]["type"],
        "LineString");
    expect(
        topology["objects"]["collection"]["geometries"][1]["type"], "Polygon");
  });

  test("topology nested geometry collections", () {
    var topology = topojson.topology({
      "collection": {
        "type": "GeometryCollection",
        "geometries": [
          {
            "type": "GeometryCollection",
            "geometries": [
              {
                "type": "LineString",
                "coordinates": [
                  [.1, .2],
                  [.3, .4]
                ]
              }
            ]
          },
          {
            "type": "Polygon",
            "coordinates": [
              [
                [.5, .6],
                [.7, .8]
              ]
            ]
          }
        ]
      }
    });
    expect(
        topology["objects"]["collection"]["geometries"][0]["geometries"][0]
                ["arcs"]
            .length,
        1);
  });

  test("topology null geometry objects are preserved in geometry collections",
      () {
    var topology = topojson.topology({
      "collection": {
        "type": "GeometryCollection",
        "geometries": [
          null,
          {
            "type": "Polygon",
            "coordinates": [
              [
                [.5, .6],
                [.7, .8]
              ]
            ]
          }
        ]
      }
    });
    expect(topology["objects"]["collection"]["type"], "GeometryCollection");
    expect(topology["objects"]["collection"]["geometries"].length, 2);
    expect(topology["objects"]["collection"]["geometries"][0]["type"], null);
    expect(
        topology["objects"]["collection"]["geometries"][1]["type"], "Polygon");
  });

  test(
      "topology features with null geometry objects are preserved in feature collections",
      () {
    var topology = topojson.topology({
      "collection": {
        "type": "FeatureCollection",
        "features": [
          {"type": "Feature", "geometry": null},
          {
            "type": "Feature",
            "geometry": {
              "type": "Polygon",
              "coordinates": [
                [
                  [.5, .6],
                  [.7, .8]
                ]
              ]
            }
          }
        ]
      }
    });
    expect(topology["objects"]["collection"]["type"], "GeometryCollection");
    expect(topology["objects"]["collection"]["geometries"].length, 2);
    expect(topology["objects"]["collection"]["geometries"][0]["type"], null);
    expect(
        topology["objects"]["collection"]["geometries"][1]["type"], "Polygon");
  });

  test("topology top-level features with null geometry objects are preserved",
      () {
    var topology = topojson.topology({
      "feature": {"type": "Feature", "geometry": null}
    });
    expect(topology["objects"], {
      "feature": {"type": null}
    });
  });

// To know what a geometry object represents, specify an id. I prefer
// numeric identifiers, such as ISO 3166-1 numeric, but strings work too.
  test("topology converting a feature to a geometry preserves its id", () {
    var topology = topojson.topology({
      "foo": {
        "type": "Feature",
        "id": 42,
        "properties": {},
        "geometry": {
          "type": "LineString",
          "coordinates": [
            [.1, .2],
            [.3, .4]
          ]
        }
      }
    });
    expect(topology["objects"]["foo"]["type"], "LineString");
    expect(topology["objects"]["foo"]["id"], 42);
  });

  test("topology converting a feature to a geometry preserves its bbox", () {
    var topology = topojson.topology({
      "foo": {
        "type": "Feature",
        "bbox": [0, 0, 10, 10],
        "properties": {},
        "geometry": {
          "type": "LineString",
          "coordinates": [
            [.1, .2],
            [.3, .4]
          ]
        }
      }
    });
    expect(topology["objects"]["foo"]["bbox"], [0, 0, 10, 10]);
    topology = topojson.topology({
      "foo": {
        "type": "Feature",
        "properties": {},
        "geometry": {
          "type": "LineString",
          "bbox": [0, 0, 10, 10],
          "coordinates": [
            [.1, .2],
            [.3, .4]
          ]
        }
      }
    });
    expect(topology["objects"]["foo"]["bbox"], [0, 0, 10, 10]);
  });

  test(
      "topology converting a feature to a geometry preserves its properties, but only if non-empty",
      () {
    var topology = topojson.topology({
      "foo": {
        "type": "Feature",
        "id": "Foo",
        "properties": {"name": "George"},
        "geometry": {
          "type": "LineString",
          "coordinates": [
            [.1, .2],
            [.3, .4]
          ]
        }
      }
    });
    expect(topology["objects"]["foo"]["properties"], {"name": "George"});
    topology = topojson.topology({
      "foo": {
        "type": "Feature",
        "id": "Foo",
        "properties": {"name": "George"},
        "geometry": {
          "type": "GeometryCollection",
          "geometries": [
            {
              "type": "LineString",
              "coordinates": [
                [.1, .2],
                [.3, .4]
              ]
            }
          ]
        }
      }
    });
    expect(topology["objects"]["foo"]["properties"], {"name": "George"});
    topology = topojson.topology({
      "foo": {
        "type": "Feature",
        "id": "Foo",
        "properties": {"name": "George", "demeanor": "curious"},
        "geometry": {
          "type": "LineString",
          "coordinates": [
            [.1, .2],
            [.3, .4]
          ]
        }
      }
    });
    expect(topology["objects"]["foo"]["properties"],
        {"name": "George", "demeanor": "curious"});
    topology = topojson.topology({
      "foo": {
        "type": "Feature",
        "id": "Foo",
        "properties": {},
        "geometry": {
          "type": "LineString",
          "coordinates": [
            [.1, .2],
            [.3, .4]
          ]
        }
      }
    });
    expect(topology["objects"]["foo"]["properties"], null);
  });

// It's not required by the specification that the transform exactly
// encompass the input geometry, but this is a good test that the reference
// implementation is working correctly.
  test("topology the returned transform exactly encompasses the input geometry",
      () {
    var topology = topojson.topology({
      "foo": {
        "type": "LineString",
        "coordinates": [
          [1 / 8, 1 / 16],
          [1 / 2, 1 / 4]
        ]
      }
    }, 2);
    expect(topology["transform"], {
      "scale": [3 / 8, 3 / 16],
      "translate": [1 / 8, 1 / 16]
    });
    topology = topojson.topology({
      "foo": {
        "type": "Polygon",
        "coordinates": [
          [
            [1 / 8, 1 / 16],
            [1 / 2, 1 / 16],
            [1 / 2, 1 / 4],
            [1 / 8, 1 / 4],
            [1 / 8, 1 / 16]
          ]
        ]
      }
    }, 2);
    expect(topology["transform"], {
      "scale": [3 / 8, 3 / 16],
      "translate": [1 / 8, 1 / 16]
    });
  });

// TopoJSON uses integers with delta encoding to represent geometry
// efficiently. (Quantization is necessary for simplification anyway, so
// that we can identify which points are shared by contiguous geometry
// objects.) The delta encoding works particularly well because line strings
// are not random: most points are very close to their neighbors!
  test("topology arc coordinates are integers with delta encoding", () {
    // var topology = topojson.topology({"foo": {"type": "LineString", "coordinates": [[1/8, 1/16], [1/2, 1/16], [1/8, 1/4], [1/2, 1/4]]}}, 2);
    // expect(topology["arcs"][0], [[0, 0], [1, 0], [-1, 1], [1, 0]]);
    var topology = topojson.topology({
      "foo": {
        "type": "Polygon",
        "coordinates": [
          [
            [1 / 8, 1 / 16],
            [1 / 2, 1 / 16],
            [1 / 2, 1 / 4],
            [1 / 8, 1 / 4],
            [1 / 8, 1 / 16]
          ]
        ]
      }
    }, 2);
    expect(topology["arcs"][0], [
      [0, 0],
      [1, 0],
      [0, 1],
      [-1, 0],
      [0, -1]
    ]);
  });

// TopoJSON uses integers with for points, also. However, there’s no delta-
// encoding, even for MultiPoints. And, unlike other geometry objects,
// points are still defined with coordinates rather than arcs.
  test("topology points coordinates are integers with delta encoding", () {
    var topology = topojson.topology({
      "foo": {
        "type": "Point",
        "coordinates": [1 / 8, 1 / 16]
      },
      "bar": {
        "type": "Point",
        "coordinates": [1 / 2, 1 / 4]
      }
    }, 2);
    expect(topology["arcs"], []);
    expect(topology["objects"]["foo"], {
      "type": "Point",
      "coordinates": [0, 0]
    });
    expect(topology["objects"]["bar"], {
      "type": "Point",
      "coordinates": [1, 1]
    });
    topology = topojson.topology({
      "foo": {
        "type": "MultiPoint",
        "coordinates": [
          [1 / 8, 1 / 16],
          [1 / 2, 1 / 4]
        ]
      }
    }, 2);
    expect(topology["arcs"], []);
    expect(topology["objects"]["foo"], {
      "type": "MultiPoint",
      "coordinates": [
        [0, 0],
        [1, 1]
      ]
    });
  });

// Rounding is more accurate than flooring.
  test(
      "topology quantization rounds to the closest integer coordinate to minimize error",
      () {
    var topology = topojson.topology({
      "foo": {
        "type": "LineString",
        "coordinates": [
          [0.0, 0.0],
          [0.5, 0.5],
          [1.6, 1.6],
          [3.0, 3.0],
          [4.1, 4.1],
          [4.9, 4.9],
          [5.9, 5.9],
          [6.5, 6.5],
          [7.0, 7.0],
          [8.4, 8.4],
          [8.5, 8.5],
          [10, 10]
        ]
      }
    }, 11);
    expect(
        client.feature(topology, topology["objects"]["foo"])["geometry"]
            ["coordinates"],
        [
          [0, 0],
          [1, 1],
          [2, 2],
          [3, 3],
          [4, 4],
          [5, 5],
          [6, 6],
          [7, 7],
          [8, 8],
          [9, 9],
          [10, 10]
        ]);
    expect(topology["arcs"], [
      [
        [0, 0],
        [1, 1],
        [1, 1],
        [1, 1],
        [1, 1],
        [1, 1],
        [1, 1],
        [1, 1],
        [1, 1],
        [1, 1],
        [1, 1]
      ]
    ]);
    expect(topology["transform"], {
      "scale": [1, 1],
      "translate": [0, 0]
    });
  });

// When rounding, we must be careful not to exceed [±180°, ±90°]!
  test("topology quantization precisely preserves minimum and maximum values",
      () {
    var topology = topojson.topology({
      "foo": {
        "type": "LineString",
        "coordinates": [
          [-180, -90],
          [0, 0],
          [180, 90]
        ]
      }
    }, 3);
    expect(
        client.feature(topology, topology["objects"]["foo"])["geometry"]
            ["coordinates"],
        [
          [-180, -90],
          [0, 0],
          [180, 90]
        ]);
    expect(topology["arcs"], [
      [
        [0, 0],
        [1, 1],
        [1, 1]
      ]
    ]);
    expect(topology["transform"], {
      "scale": [180, 90],
      "translate": [-180, -90]
    });
  });

// GeoJSON inputs are in floating point format, so some error may creep in
// that prevents you from using exact match to determine shared points. The
// default quantization, 1e4, allows for 10,000 differentiable points in
// both dimensions. If you're using TopoJSON to represent especially high-
// precision geometry, you might want to increase the precision; however,
// this necessarily increases the output size and the likelihood of seams
// between contiguous geometry after simplification. The quantization factor
// should be a power of ten for the most efficient representation, since
// JSON uses base-ten encoding for numbers.
  test("topology precision of quantization is configurable", () {
    var topology = topojson.topology({
      "foo": {
        "type": "LineString",
        "coordinates": [
          [1 / 8, 1 / 16],
          [1 / 2, 1 / 16],
          [1 / 8, 1 / 4],
          [1 / 2, 1 / 4]
        ]
      }
    }, 3);
    expect(topology["arcs"][0], [
      [0, 0],
      [2, 0],
      [-2, 2],
      [2, 0]
    ]);
    topology = topojson.topology({
      "foo": {
        "type": "Polygon",
        "coordinates": [
          [
            [1 / 8, 1 / 16],
            [1 / 2, 1 / 16],
            [1 / 2, 1 / 4],
            [1 / 8, 1 / 4],
            [1 / 8, 1 / 16]
          ]
        ]
      }
    }, 5);
    expect(topology["arcs"][0], [
      [0, 0],
      [4, 0],
      [0, 4],
      [-4, 0],
      [0, -4]
    ]);
  });

// Quantization may introduce coincident points, so these are removed.
  test("topology coincident points are removed", () {
    var topology = topojson.topology({
      "foo": {
        "type": "LineString",
        "coordinates": [
          [1 / 8, 1 / 16],
          [1 / 8, 1 / 16],
          [1 / 2, 1 / 4],
          [1 / 2, 1 / 4]
        ]
      }
    }, 2);
    expect(topology["arcs"], [
      [
        [0, 0],
        [1, 1]
      ]
    ]);
    topology = topojson.topology({
      "foo": {
        "type": "Polygon",
        "coordinates": [
          [
            [1 / 8, 1 / 16],
            [1 / 2, 1 / 16],
            [1 / 2, 1 / 16],
            [1 / 2, 1 / 4],
            [1 / 8, 1 / 4],
            [1 / 8, 1 / 4],
            [1 / 8, 1 / 16]
          ]
        ]
      }
    }, 2);
    expect(topology["arcs"][0], [
      [0, 0],
      [1, 0],
      [0, 1],
      [-1, 0],
      [0, -1]
    ]);
  });

// Quantization may introduce degenerate features which have collapsed onto a single point.
  test("topology collapsed lines are preserved", () {
    var topology = topojson.topology({
      "foo": {
        "type": "LineString",
        "coordinates": [
          [0, 0],
          [1, 1],
          [2, 2]
        ]
      },
      "bar": {
        "type": "LineString",
        "coordinates": [
          [-80, -80],
          [0, 0],
          [80, 80]
        ]
      }
    }, 3);
    expect(topology["objects"]["foo"], {
      "type": "LineString",
      "arcs": [0]
    });
    expect(topology["arcs"][0], [
      [1, 1],
      [0, 0]
    ]);
  });

  test("topology collapsed lines in a MultiLineString are preserved", () {
    var topology = topojson.topology({
      "foo": {
        "type": "MultiLineString",
        "coordinates": [
          [
            [1 / 8, 1 / 16],
            [1 / 2, 1 / 4]
          ],
          [
            [1 / 8, 1 / 16],
            [1 / 8, 1 / 16]
          ],
          [
            [1 / 2, 1 / 4],
            [1 / 8, 1 / 16]
          ]
        ]
      }
    }, 2);
    expect(topology["arcs"].length, 2);
    expect(topology["arcs"][1], [
      [0, 0],
      [0, 0]
    ]);
    expect(topology["arcs"][0], [
      [0, 0],
      [1, 1]
    ]);
    expect(topology["objects"]["foo"]["arcs"], [
      [0],
      [1],
      [~0]
    ]);
  });

  test("topology collapsed polygons are preserved", () {
    var topology = topojson.topology({
      "foo": {
        "type": "Polygon",
        "coordinates": [
          [
            [0, 0],
            [0, 1],
            [1, 1],
            [1, 0],
            [0, 0]
          ]
        ]
      },
      "bar": {
        "type": "Polygon",
        "coordinates": [
          [
            [0, 0],
            [0, 1],
            [1, 1],
            [0, 0]
          ]
        ]
      },
      "baz": {
        "type": "MultiPoint",
        "coordinates": [
          [-80, -80],
          [0, 0],
          [80, 80]
        ]
      }
    }, 3);
    expect(topology["objects"]["foo"], {
      "type": "Polygon",
      "arcs": [
        [0]
      ]
    });
    expect(topology["objects"]["bar"], {
      "type": "Polygon",
      "arcs": [
        [0]
      ]
    });
    expect(topology["arcs"][0], [
      [1, 1],
      [0, 0]
    ]);
  });

  test("topology collapsed polygons in a MultiPolygon are preserved", () {
    var topology = topojson.topology({
      "foo": {
        "type": "MultiPolygon",
        "coordinates": [
          [
            [
              [1 / 8, 1 / 16],
              [1 / 2, 1 / 16],
              [1 / 2, 1 / 4],
              [1 / 8, 1 / 4],
              [1 / 8, 1 / 16]
            ]
          ],
          [
            [
              [1 / 8, 1 / 16],
              [1 / 8, 1 / 16],
              [1 / 8, 1 / 16],
              [1 / 8, 1 / 16]
            ]
          ],
          [
            [
              [1 / 8, 1 / 16],
              [1 / 8, 1 / 4],
              [1 / 2, 1 / 4],
              [1 / 2, 1 / 16],
              [1 / 8, 1 / 16]
            ]
          ]
        ]
      }
    }, 2);
    expect(topology["arcs"].length > 0, true);
    expect(topology["arcs"][0].length >= 2, true);
    expect(topology["objects"]["foo"]["arcs"].length == 3, true);
  });

  test("topology collapsed geometries in a GeometryCollection are preserved",
      () {
    var topology = topojson.topology({
      "collection": {
        "type": "FeatureCollection",
        "features": [
          {
            "type": "Feature",
            "geometry": {"type": "MultiPolygon", "coordinates": []}
          }
        ]
      }
    }, 2);
    expect(topology["arcs"].length, 0);
    expect(topology["objects"]["collection"], {
      "type": "GeometryCollection",
      "geometries": [
        {"type": "MultiPolygon", "arcs": []}
      ]
    });
  });

// If one of the top-level objects in the input is empty, however, it is
// still preserved in the output.
  test("topology empty geometries are not removed", () {
    var topology = topojson.topology({
      "foo": {"type": "MultiPolygon", "coordinates": []}
    }, 2);
    expect(topology["arcs"].length, 0);
    expect(topology["objects"]["foo"], {"type": "MultiPolygon", "arcs": []});
  });

  test("topology empty polygons are not removed", () {
    var topology = topojson.topology({
      "foo": {
        "type": "FeatureCollection",
        "features": [
          {
            "type": "Feature",
            "geometry": {
              "type": "MultiPolygon",
              "coordinates": [[]]
            }
          }
        ]
      },
      "bar": {"type": "Polygon", "coordinates": []}
    });
    expect(topology["arcs"].length, 0);
    expect(topology["objects"]["foo"], {
      "type": "GeometryCollection",
      "geometries": [
        {
          "type": "MultiPolygon",
          "arcs": [[]]
        }
      ]
    });
    expect(topology["objects"]["bar"], {"type": "Polygon", "arcs": []});
  });

//
// A-----B
//
  test("topology the lines AB and AB share the same arc", () {
    var topology = topojson.topology({
      "ab": {
        "type": "LineString",
        "coordinates": [
          [0, 0],
          [0, 1]
        ]
      },
      "ba": {
        "type": "LineString",
        "coordinates": [
          [0, 0],
          [0, 1]
        ]
      }
    });
    expect(topology["objects"]["ab"], {
      "type": "LineString",
      "arcs": [0]
    });
    expect(topology["objects"]["ba"], {
      "type": "LineString",
      "arcs": [0]
    });
  });

//
// A-----B
//
  test("topology the lines AB and BA share the same arc", () {
    var topology = topojson.topology({
      "ab": {
        "type": "LineString",
        "coordinates": [
          [0, 0],
          [0, 1]
        ]
      },
      "ba": {
        "type": "LineString",
        "coordinates": [
          [0, 1],
          [0, 0]
        ]
      }
    });
    expect(topology["objects"]["ab"], {
      "type": "LineString",
      "arcs": [0]
    });
    expect(topology["objects"]["ba"], {
      "type": "LineString",
      "arcs": [~0]
    });
  });

//
// A
//  \
//   \
//    \
//     \
//      \
// B-----C-----D
//
  test("topology the lines ACD and BCD share three arcs", () {
    var topology = topojson.topology({
      "acd": {
        "type": "LineString",
        "coordinates": [
          [0, 0],
          [1, 1],
          [2, 1]
        ]
      },
      "bcd": {
        "type": "LineString",
        "coordinates": [
          [0, 1],
          [1, 1],
          [2, 1]
        ]
      }
    });
    expect(topology["objects"]["acd"], {
      "type": "LineString",
      "arcs": [0, 1]
    });
    expect(topology["objects"]["bcd"], {
      "type": "LineString",
      "arcs": [2, 1]
    });
  });

//
// A
//  \
//   \
//    \
//     \
//      \
// B-----C-----D
//
  test("topology the lines ACD and DCB share three arcs", () {
    var topology = topojson.topology({
      "acd": {
        "type": "LineString",
        "coordinates": [
          [0, 0],
          [1, 1],
          [2, 1]
        ]
      },
      "dcb": {
        "type": "LineString",
        "coordinates": [
          [2, 1],
          [1, 1],
          [0, 1]
        ]
      }
    }, 3);
    expect(topology["arcs"], [
      [
        [0, 0],
        [1, 2]
      ], // AC
      [
        [1, 2],
        [1, 0]
      ], // CD
      [
        [1, 2],
        [-1, 0]
      ], // CB
    ]);
    expect(topology["objects"]["acd"], {
      "type": "LineString",
      "arcs": [0, 1]
    });
    expect(topology["objects"]["dcb"], {
      "type": "LineString",
      "arcs": [~1, 2]
    });
  });

//
// A
//  \
//   \
//    \
//     \
//      \
// B-----C-----D-----F
//
  test("topology the lines ACDF and BCDF share three arcs", () {
    var topology = topojson.topology({
      "acdf": {
        "type": "LineString",
        "coordinates": [
          [0, 0],
          [1, 1],
          [2, 1],
          [3, 1]
        ]
      },
      "bcdf": {
        "type": "LineString",
        "coordinates": [
          [0, 1],
          [1, 1],
          [2, 1],
          [3, 1]
        ]
      }
    }, 4);
    expect(topology["arcs"], [
      [
        [0, 0],
        [1, 3]
      ], // AC
      [
        [1, 3],
        [1, 0],
        [1, 0]
      ], // CDF
      [
        [0, 3],
        [1, 0]
      ] // BC
    ]);
    expect(topology["objects"]["acdf"], {
      "type": "LineString",
      "arcs": [0, 1]
    });
    expect(topology["objects"]["bcdf"], {
      "type": "LineString",
      "arcs": [2, 1]
    });
  });

//
//                   E
//                  /
//                 /
//                /
//               /
//              /
// B-----C-----D-----F
//
  test("topology the lines BCDE and BCDF share three arcs", () {
    var topology = topojson.topology({
      "bcde": {
        "type": "LineString",
        "coordinates": [
          [0, 1],
          [1, 1],
          [2, 1],
          [3, 0]
        ]
      },
      "bcdf": {
        "type": "LineString",
        "coordinates": [
          [0, 1],
          [1, 1],
          [2, 1],
          [3, 1]
        ]
      }
    }, 4);
    expect(topology["arcs"], [
      [
        [0, 3],
        [1, 0],
        [1, 0]
      ], // BCD
      [
        [2, 3],
        [1, -3]
      ], // DE
      [
        [2, 3],
        [1, 0]
      ] // DF
    ]);
    expect(topology["objects"]["bcde"], {
      "type": "LineString",
      "arcs": [0, 1]
    });
    expect(topology["objects"]["bcdf"], {
      "type": "LineString",
      "arcs": [0, 2]
    });
  });

//
// A                 E
//  \               /
//   \             /
//    \           /
//     \         /
//      \       /
//       C-----D
//
  test("topology the lines ACDE and CD share three arcs", () {
    var topology = topojson.topology({
      "acde": {
        "type": "LineString",
        "coordinates": [
          [0, 0],
          [1, 1],
          [2, 1],
          [3, 0]
        ]
      },
      "cd": {
        "type": "LineString",
        "coordinates": [
          [1, 1],
          [2, 1]
        ]
      }
    }, 4);
    expect(topology["arcs"], [
      [
        [0, 0],
        [1, 3]
      ], // AC
      [
        [1, 3],
        [1, 0]
      ], // CD
      [
        [2, 3],
        [1, -3]
      ] // DE
    ]);
    expect(topology["objects"]["acde"], {
      "type": "LineString",
      "arcs": [0, 1, 2]
    });
    expect(topology["objects"]["cd"], {
      "type": "LineString",
      "arcs": [1]
    });
  });

//
// A                 E
//  \               /
//   \             /
//    \           /
//     \         /
//      \       /
// B-----C-----D
//
  test("topology the lines ACDE and BCD share four arcs", () {
    var topology = topojson.topology({
      "acde": {
        "type": "LineString",
        "coordinates": [
          [0, 0],
          [1, 1],
          [2, 1],
          [3, 0]
        ]
      },
      "bcd": {
        "type": "LineString",
        "coordinates": [
          [0, 1],
          [1, 1],
          [2, 1]
        ]
      }
    }, 4);
    expect(topology["arcs"], [
      [
        [0, 0],
        [1, 3]
      ], // AC
      [
        [1, 3],
        [1, 0]
      ], // CD
      [
        [2, 3],
        [1, -3]
      ], // DE
      [
        [0, 3],
        [1, 0]
      ] // BC
    ]);
    expect(topology["objects"]["acde"], {
      "type": "LineString",
      "arcs": [0, 1, 2]
    });
    expect(topology["objects"]["bcd"], {
      "type": "LineString",
      "arcs": [3, 1]
    });
  });

//
// A                 E
//  \               /
//   \             /
//    \           /
//     \         /
//      \       /
//       C-----D-----F
//
  test("topology the lines ACDE and CDF share four arcs", () {
    var topology = topojson.topology({
      "acde": {
        "type": "LineString",
        "coordinates": [
          [0, 0],
          [1, 1],
          [2, 1],
          [3, 0]
        ]
      },
      "cdf": {
        "type": "LineString",
        "coordinates": [
          [1, 1],
          [2, 1],
          [3, 1]
        ]
      }
    }, 4);
    expect(topology["arcs"], [
      [
        [0, 0],
        [1, 3]
      ], // AC
      [
        [1, 3],
        [1, 0]
      ], // CD
      [
        [2, 3],
        [1, -3]
      ], // DE
      [
        [2, 3],
        [1, 0]
      ] // CF
    ]);
    expect(topology["objects"]["acde"], {
      "type": "LineString",
      "arcs": [0, 1, 2]
    });
    expect(topology["objects"]["cdf"], {
      "type": "LineString",
      "arcs": [1, 3]
    });
  });

//
// A                 E
//  \               /
//   \             /
//    \           /
//     \         /
//      \       /
// B-----C-----D-----F
//
  test("topology the lines ACDE and BCDF share five arcs", () {
    var topology = topojson.topology({
      "acde": {
        "type": "LineString",
        "coordinates": [
          [0, 0],
          [1, 1],
          [2, 1],
          [3, 0]
        ]
      },
      "bcdf": {
        "type": "LineString",
        "coordinates": [
          [0, 1],
          [1, 1],
          [2, 1],
          [3, 1]
        ]
      }
    }, 4);
    expect(topology["arcs"], [
      [
        [0, 0],
        [1, 3]
      ], // AC
      [
        [1, 3],
        [1, 0]
      ], // CD
      [
        [2, 3],
        [1, -3]
      ], // DE
      [
        [0, 3],
        [1, 0]
      ], // BC
      [
        [2, 3],
        [1, 0]
      ] // DF
    ]);
    expect(topology["objects"]["acde"], {
      "type": "LineString",
      "arcs": [0, 1, 2]
    });
    expect(topology["objects"]["bcdf"], {
      "type": "LineString",
      "arcs": [3, 1, 4]
    });
  });

//
// A                 E
//  \               /
//   \             /
//    \           /
//     \         /
//      \       /
//       C-----D-----F
//
  test("topology the lines ACDE, EDCA and ACDF share three arcs", () {
    var topology = topojson.topology({
      "acde": {
        "type": "LineString",
        "coordinates": [
          [0, 0],
          [1, 1],
          [2, 1],
          [3, 0]
        ]
      },
      "edca": {
        "type": "LineString",
        "coordinates": [
          [3, 0],
          [2, 1],
          [1, 1],
          [0, 0]
        ]
      },
      "acdf": {
        "type": "LineString",
        "coordinates": [
          [0, 0],
          [1, 1],
          [2, 1],
          [3, 1]
        ]
      }
    }, 4);
    expect(topology["arcs"], [
      [
        [0, 0],
        [1, 3],
        [1, 0]
      ], // ACD
      [
        [2, 3],
        [1, -3]
      ], // DE
      [
        [2, 3],
        [1, 0]
      ] // DF
    ]);
    expect(topology["objects"]["acde"], {
      "type": "LineString",
      "arcs": [0, 1]
    });
    expect(topology["objects"]["acdf"], {
      "type": "LineString",
      "arcs": [0, 2]
    });
    expect(topology["objects"]["edca"], {
      "type": "LineString",
      "arcs": [~1, ~0]
    });
  });

//
// A                 E
//  \               /
//   \             /
//    \           /
//     \         /
//      \       /
//       C-----D-----F
//
  test("topology the lines ACDE, ACDF and EDCA share three arcs", () {
    var topology = topojson.topology({
      "acde": {
        "type": "LineString",
        "coordinates": [
          [0, 0],
          [1, 1],
          [2, 1],
          [3, 0]
        ]
      },
      "acdf": {
        "type": "LineString",
        "coordinates": [
          [0, 0],
          [1, 1],
          [2, 1],
          [3, 1]
        ]
      },
      "edca": {
        "type": "LineString",
        "coordinates": [
          [3, 0],
          [2, 1],
          [1, 1],
          [0, 0]
        ]
      }
    }, 4);
    expect(topology["arcs"], [
      [
        [0, 0],
        [1, 3],
        [1, 0]
      ], // ACD
      [
        [2, 3],
        [1, -3]
      ], // DE
      [
        [2, 3],
        [1, 0]
      ] // DF
    ]);
    expect(topology["objects"]["acde"], {
      "type": "LineString",
      "arcs": [0, 1]
    });
    expect(topology["objects"]["acdf"], {
      "type": "LineString",
      "arcs": [0, 2]
    });
    expect(topology["objects"]["edca"], {
      "type": "LineString",
      "arcs": [~1, ~0]
    });
  });

//
// A                 E
//  \               /
//   \             /
//    \           /
//     \         /
//      \       /
// B-----C-----D-----F
//
  test(
      "topology the lines ACDE, ACDF, BCDE and BCDF and their reversals share five arcs",
      () {
    var topology = topojson.topology({
      "acde": {
        "type": "LineString",
        "coordinates": [
          [0, 0],
          [1, 1],
          [2, 1],
          [3, 0]
        ]
      },
      "acdf": {
        "type": "LineString",
        "coordinates": [
          [0, 0],
          [1, 1],
          [2, 1],
          [3, 1]
        ]
      },
      "bcde": {
        "type": "LineString",
        "coordinates": [
          [0, 1],
          [1, 1],
          [2, 1],
          [3, 0]
        ]
      },
      "bcdf": {
        "type": "LineString",
        "coordinates": [
          [0, 1],
          [1, 1],
          [2, 1],
          [3, 1]
        ]
      },
      "edca": {
        "type": "LineString",
        "coordinates": [
          [3, 0],
          [2, 1],
          [1, 1],
          [0, 0]
        ]
      },
      "fdca": {
        "type": "LineString",
        "coordinates": [
          [3, 1],
          [2, 1],
          [1, 1],
          [0, 0]
        ]
      },
      "edcb": {
        "type": "LineString",
        "coordinates": [
          [3, 0],
          [2, 1],
          [1, 1],
          [0, 1]
        ]
      },
      "fdcb": {
        "type": "LineString",
        "coordinates": [
          [3, 1],
          [2, 1],
          [1, 1],
          [0, 1]
        ]
      }
    }, 4);
    expect(topology["arcs"], [
      [
        [0, 0],
        [1, 3]
      ], // AC
      [
        [1, 3],
        [1, 0]
      ], // CD
      [
        [2, 3],
        [1, -3]
      ], // DE
      [
        [2, 3],
        [1, 0]
      ], // DF
      [
        [0, 3],
        [1, 0]
      ] // BC
    ]);
    expect(topology["objects"]["acde"], {
      "type": "LineString",
      "arcs": [0, 1, 2]
    });
    expect(topology["objects"]["acdf"], {
      "type": "LineString",
      "arcs": [0, 1, 3]
    });
    expect(topology["objects"]["bcde"], {
      "type": "LineString",
      "arcs": [4, 1, 2]
    });
    expect(topology["objects"]["bcdf"], {
      "type": "LineString",
      "arcs": [4, 1, 3]
    });
    expect(topology["objects"]["edca"], {
      "type": "LineString",
      "arcs": [~2, ~1, ~0]
    });
    expect(topology["objects"]["fdca"], {
      "type": "LineString",
      "arcs": [~3, ~1, ~0]
    });
    expect(topology["objects"]["edcb"], {
      "type": "LineString",
      "arcs": [~2, ~1, ~4]
    });
    expect(topology["objects"]["fdcb"], {
      "type": "LineString",
      "arcs": [~3, ~1, ~4]
    });
  });

//
// A-----B-----E
// |     |     |
// |     |     |
// |     |     |
// |     |     |
// |     |     |
// D-----C-----F
//
  test("topology the polygons ABCDA and BEFCB share three arcs", () {
    var topology = topojson.topology({
      "abcda": {
        "type": "Polygon",
        "coordinates": [
          [
            [0, 0],
            [1, 0],
            [1, 1],
            [0, 1],
            [0, 0]
          ]
        ]
      },
      "befcb": {
        "type": "Polygon",
        "coordinates": [
          [
            [1, 0],
            [2, 0],
            [2, 1],
            [1, 1],
            [1, 0]
          ]
        ]
      }
    }, 3);
    expect(topology["arcs"], [
      [
        [1, 0],
        [0, 2]
      ], // BC
      [
        [1, 2],
        [-1, 0],
        [0, -2],
        [1, 0]
      ], // CDAB
      [
        [1, 0],
        [1, 0],
        [0, 2],
        [-1, 0]
      ] // BEFC
    ]);
    expect(topology["objects"]["abcda"], {
      "type": "Polygon",
      "arcs": [
        [0, 1]
      ]
    });
    expect(topology["objects"]["befcb"], {
      "type": "Polygon",
      "arcs": [
        [2, ~0]
      ]
    });
  });

//
// A-----B
// |\    |
// | \   |
// |  \  |
// |   \ |
// |    \|
// D-----C
//
  test("topology the polygons ABCDA and ABCA share three arcs", () {
    var topology = topojson.topology({
      "abcda": {
        "type": "Polygon",
        "coordinates": [
          [
            [0, 0],
            [1, 0],
            [1, 1],
            [0, 1],
            [0, 0]
          ]
        ]
      },
      "abca": {
        "type": "Polygon",
        "coordinates": [
          [
            [0, 0],
            [1, 0],
            [1, 1],
            [0, 0]
          ]
        ]
      }
    }, 2);
    expect(topology["arcs"], [
      [
        [0, 0],
        [1, 0],
        [0, 1]
      ], // ABC
      [
        [1, 1],
        [-1, 0],
        [0, -1]
      ], // CDA
      [
        [1, 1],
        [-1, -1]
      ] // CA
    ]);
    expect(topology["objects"]["abcda"], {
      "type": "Polygon",
      "arcs": [
        [0, 1]
      ]
    });
    expect(topology["objects"]["abca"], {
      "type": "Polygon",
      "arcs": [
        [0, 2]
      ]
    });
  });

//
//             C
//            / \
//           /   \
//          /     \
//         /       \
//        /         \
// A-----B-----------D-----E
//
  test("topology the lines ABCDE and ABDE share two arcs", () {
    var topology = topojson.topology({
      "abcde": {
        "type": "LineString",
        "coordinates": [
          [0, 0],
          [1, 0],
          [2, 0],
          [3, 0],
          [4, 0]
        ]
      },
      "abde": {
        "type": "LineString",
        "coordinates": [
          [0, 0],
          [1, 0],
          [3, 0],
          [4, 0]
        ]
      }
    }, 5);
    expect(topology["arcs"], [
      [
        [0, 0],
        [1, 0]
      ], // AB
      [
        [1, 0],
        [1, 0],
        [1, 0]
      ], // BCD
      [
        [3, 0],
        [1, 0]
      ], // DE
      [
        [1, 0],
        [2, 0]
      ] // BD
    ]);
    expect(topology["objects"]["abcde"], {
      "type": "LineString",
      "arcs": [0, 1, 2]
    });
    expect(topology["objects"]["abde"], {
      "type": "LineString",
      "arcs": [0, 3, 2]
    });
  });

//
// A-----B
// |\    |\
// | \   | \
// |  \  |  \
// |   \ |   \
// |    \|    \
// D-----C-----F
//
  test("topology the polygons ABCA, ACDA and BFCB share five arcs", () {
    var topology = topojson.topology({
      "abca": {
        "type": "Polygon",
        "coordinates": [
          [
            [0, 0],
            [1, 0],
            [1, 1],
            [0, 0]
          ]
        ]
      },
      "acda": {
        "type": "Polygon",
        "coordinates": [
          [
            [0, 0],
            [1, 1],
            [0, 1],
            [0, 0]
          ]
        ]
      },
      "bfcb": {
        "type": "Polygon",
        "coordinates": [
          [
            [1, 0],
            [2, 1],
            [1, 1],
            [1, 0]
          ]
        ]
      }
    }, 3);
    expect(topology["arcs"], [
      [
        [0, 0],
        [1, 0]
      ], // AB
      [
        [1, 0],
        [0, 2]
      ], // BC
      [
        [1, 2],
        [-1, -2]
      ], // CA
      [
        [1, 2],
        [-1, 0],
        [0, -2]
      ], // CDA
      [
        [1, 0],
        [1, 2],
        [-1, 0]
      ] // BFC
    ]);
    expect(topology["objects"]["abca"], {
      "type": "Polygon",
      "arcs": [
        [0, 1, 2]
      ]
    });
    expect(topology["objects"]["acda"], {
      "type": "Polygon",
      "arcs": [
        [~2, 3]
      ]
    });
    expect(topology["objects"]["bfcb"], {
      "type": "Polygon",
      "arcs": [
        [4, ~1]
      ]
    });
  });

//
// A-----B-----E
//  \    |     |\
//   \   |     | \
//    \  |     |  \
//     \ |     |   \
//      \|     |    \
//       C-----F-----G
//
  test("topology the polygons ABCA, BEFCB and EGFE share six arcs", () {
    var topology = topojson.topology({
      "abca": {
        "type": "Polygon",
        "coordinates": [
          [
            [0, 0],
            [1, 0],
            [1, 1],
            [0, 0]
          ]
        ]
      },
      "befcb": {
        "type": "Polygon",
        "coordinates": [
          [
            [1, 0],
            [2, 0],
            [2, 1],
            [1, 1],
            [1, 0]
          ]
        ]
      },
      "egfe": {
        "type": "Polygon",
        "coordinates": [
          [
            [2, 0],
            [3, 1],
            [2, 1],
            [2, 0]
          ]
        ]
      }
    }, 4);
    expect(topology["arcs"], [
      [
        [1, 0],
        [0, 3]
      ], // BC
      [
        [1, 3],
        [-1, -3],
        [1, 0]
      ], // CAB
      [
        [1, 0],
        [1, 0]
      ], // BE
      [
        [2, 0],
        [0, 3]
      ], // EF
      [
        [2, 3],
        [-1, 0]
      ], // FC
      [
        [2, 0],
        [1, 3],
        [-1, 0]
      ] // EGF
    ]);
    expect(topology["objects"]["abca"], {
      "type": "Polygon",
      "arcs": [
        [0, 1]
      ]
    });
    expect(topology["objects"]["befcb"], {
      "type": "Polygon",
      "arcs": [
        [2, 3, 4, ~0]
      ]
    });
    expect(topology["objects"]["egfe"], {
      "type": "Polygon",
      "arcs": [
        [5, ~3]
      ]
    });
  });

//
// A-----B-----E
// |     |     |
// |     |     |
// D-----C     |
// |           |
// |           |
// G-----------F
//
  test("topology the polygons ABCDA, ABEFGDA and BEFGDCB share three arcs", () {
    var topology = topojson.topology({
      "abcda": {
        "type": "Polygon",
        "coordinates": [
          [
            [0, 0],
            [1, 0],
            [1, 1],
            [0, 1],
            [0, 0]
          ]
        ]
      },
      "abefgda": {
        "type": "Polygon",
        "coordinates": [
          [
            [0, 0],
            [1, 0],
            [2, 0],
            [2, 2],
            [0, 2],
            [0, 1],
            [0, 0]
          ]
        ]
      },
      "befgdcb": {
        "type": "Polygon",
        "coordinates": [
          [
            [1, 0],
            [2, 0],
            [2, 2],
            [0, 2],
            [0, 1],
            [1, 1],
            [1, 0]
          ]
        ]
      }
    }, 3);
    expect(topology["arcs"], [
      [
        [1, 0],
        [0, 1],
        [-1, 0]
      ], // BCD
      [
        [0, 1],
        [0, -1],
        [1, 0]
      ], // DAB
      [
        [1, 0],
        [1, 0],
        [0, 2],
        [-2, 0],
        [0, -1]
      ] // BEFGD
    ]);
    expect(topology["objects"]["abcda"], {
      "type": "Polygon",
      "arcs": [
        [0, 1]
      ]
    });
    expect(topology["objects"]["abefgda"], {
      "type": "Polygon",
      "arcs": [
        [2, 1]
      ]
    });
    expect(topology["objects"]["befgdcb"], {
      "type": "Polygon",
      "arcs": [
        [2, ~0]
      ]
    });
  });

//
// A-----B
// |     |
// |     |
// D-----C
//
  test("topology the polygons ABCDA and BCDAB share one arc", () {
    var topology = topojson.topology({
      "abcda": {
        "type": "Polygon",
        "coordinates": [
          [
            [0, 0],
            [1, 0],
            [1, 1],
            [0, 1],
            [0, 0]
          ]
        ]
      },
      "bcdab": {
        "type": "Polygon",
        "coordinates": [
          [
            [1, 0],
            [1, 1],
            [0, 1],
            [0, 0],
            [1, 0]
          ]
        ]
      }
    }, 2);
    expect(topology["arcs"], [
      [
        [0, 0],
        [1, 0],
        [0, 1],
        [-1, 0],
        [0, -1]
      ]
    ]);
    expect(topology["objects"]["abcda"], {
      "type": "Polygon",
      "arcs": [
        [0]
      ]
    });
    expect(topology["objects"]["bcdab"], {
      "type": "Polygon",
      "arcs": [
        [0]
      ]
    });
  });

//
// A-----------------B
// |                 |
// |                 |
// |     E-----F     |
// |     |     |     |
// |     |     |     |
// |     H-----G     |
// |                 |
// |                 |
// D-----------------C
//
  test("topology the polygons ABCDA-EHGFE and EFGHE share two arcs", () {
    var topology = topojson.topology({
      "abcda": {
        "type": "Polygon",
        "coordinates": [
          [
            [0, 0],
            [3, 0],
            [3, 3],
            [0, 3],
            [0, 0]
          ],
          [
            [1, 1],
            [1, 2],
            [2, 2],
            [2, 1],
            [1, 1]
          ]
        ]
      },
      "efghe": {
        "type": "Polygon",
        "coordinates": [
          [
            [1, 1],
            [2, 1],
            [2, 2],
            [1, 2],
            [1, 1]
          ]
        ]
      }
    }, 4);
    expect(topology["arcs"], [
      [
        [0, 0],
        [3, 0],
        [0, 3],
        [-3, 0],
        [0, -3]
      ], // ABCDA
      [
        [1, 1],
        [0, 1],
        [1, 0],
        [0, -1],
        [-1, 0]
      ] // EHGFE
    ]);
    expect(topology["objects"]["abcda"], {
      "type": "Polygon",
      "arcs": [
        [0],
        [1]
      ]
    });
    expect(topology["objects"]["efghe"], {
      "type": "Polygon",
      "arcs": [
        [~1]
      ]
    });
  });

//
// A-----------------B
// |                 |
// |                 |
// |     E-----F     |
// |     |     |     |
// |     |     |     |
// |     H-----G     |
// |                 |
// |                 |
// D-----------------C
//
  test("topology the polygons ABCDA-EHGFE and FGHEF share two arcs", () {
    var topology = topojson.topology({
      "abcda": {
        "type": "Polygon",
        "coordinates": [
          [
            [0, 0],
            [3, 0],
            [3, 3],
            [0, 3],
            [0, 0]
          ],
          [
            [1, 1],
            [1, 2],
            [2, 2],
            [2, 1],
            [1, 1]
          ]
        ]
      },
      "fghef": {
        "type": "Polygon",
        "coordinates": [
          [
            [2, 1],
            [2, 2],
            [1, 2],
            [1, 1],
            [2, 1]
          ]
        ]
      }
    }, 4);
    expect(topology["arcs"], [
      [
        [0, 0],
        [3, 0],
        [0, 3],
        [-3, 0],
        [0, -3]
      ], // ABCDA
      [
        [1, 1],
        [0, 1],
        [1, 0],
        [0, -1],
        [-1, 0]
      ] // EHGFE
    ]);
    expect(topology["objects"]["abcda"], {
      "type": "Polygon",
      "arcs": [
        [0],
        [1]
      ]
    });
    expect(topology["objects"]["fghef"], {
      "type": "Polygon",
      "arcs": [
        [~1]
      ]
    });
  });

//
//    C-----D
//     \   /
//      \ /
// A-----B-----E
//
  test("topology the polygon BCDB and the line string ABE share three arcs",
      () {
    var topology = topojson.topology({
      "abe": {
        "type": "LineString",
        "coordinates": [
          [0, 1],
          [2, 1],
          [4, 1]
        ]
      },
      "bcdb": {
        "type": "Polygon",
        "coordinates": [
          [
            [2, 1],
            [1, 0],
            [3, 0],
            [2, 1]
          ]
        ]
      }
    }, 5);
    expect(topology["arcs"], [
      [
        [0, 4],
        [2, 0]
      ], // AB
      [
        [2, 4],
        [2, 0]
      ], // BE
      [
        [2, 4],
        [-1, -4],
        [2, 0],
        [-1, 4]
      ] // BCDB
    ]);
    expect(topology["objects"]["abe"], {
      "type": "LineString",
      "arcs": [0, 1]
    });
    expect(topology["objects"]["bcdb"], {
      "type": "Polygon",
      "arcs": [
        [2]
      ]
    });
  });
}
