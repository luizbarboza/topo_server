// ignore_for_file: prefer_foreach

import 'dart:collection';

import 'arc.dart';
import 'bounds.dart';
import 'cut.dart';
import 'dedup.dart';
import 'delta.dart';
import 'extract.dart';
import 'geometry.dart';
import 'prequantize.dart';

// Constructs the TopoJSON Topology for the specified hash of features.
// Each object in the specified hash must be a GeoJSON object,
// meaning FeatureCollection, a Feature or a geometry object.

/// Returns a TopoJSON topology for the specified
/// [GeoJSON *objects*](http://geojson.org/geojson-spec.html#geojson-objects).
///
/// The returned topology makes a shallow copy of the input [objects] the
/// identifier, bounding box, properties and coordinates of input objects may be
/// shared with the output topology.
///
/// If a [quantization] parameter is specified, the input geometry is quantized
/// prior to computing the topology, the returned topology is quantized, and its
/// arcs are
/// [delta-encoded](https://github.com/topojson/topojson-specification/blob/master/README.md#213-arcs).
/// Quantization is recommended to improve the quality of the topology if the
/// input geometry is messy (*i.e.*, small floating point error means that
/// adjacent boundaries do not have identical values); typical values are powers
/// of ten, such as 1e4, 1e5 or 1e6. See also
/// [quantize](https://pub.dev/documentation/topo_client/latest/topo_client/quantize.html)
/// to quantize a topology after it has been constructed, without altering the
/// topological relationships.
Map<String?, dynamic> topology(Map<String?, Map<String?, dynamic>?> objects,
    [num quantization = 0]) {
  var bbox = bounds(objects = geometry(objects)),
      transform = quantization > 0 && bbox != null
          ? prequantize(objects, bbox, quantization)
          : null,
      topology = dedup(cut(extract(objects))),
      indexByArc = HashMap<Arc, int>(
          equals: Arc.equalsIgnoringNext, hashCode: Arc.hashCodeIgnoringNext);
  List<List<num>>? coordinates = topology["coordinates"];

  objects = topology["objects"]; // for garbage collection
  topology["bbox"] = bbox;
  topology["arcs"] = (topology["arcs"] as List<Arc>).asMap().entries.map((e) {
    var arc = e.value;
    indexByArc[arc] = e.key;
    return coordinates!.sublist(arc.start, arc.end + 1);
  }).toList();

  topology.remove("coordinates");
  coordinates = null;

  List<int> indexArcs(Arc arc) {
    var indexes = <int>[];
    Arc? next = arc;
    do {
      var index = indexByArc[next!]!;
      indexes.add(next.start < next.end ? index : ~index);
    } while ((next = next.next) != null);
    return indexes;
  }

  List<List<int>> indexMultiArcs(List<Arc> arcs) =>
      arcs.map(indexArcs).toList();

  void indexGeometry(Map<String?, dynamic>? o) {
    if (o != null) {
      switch (o["type"]) {
        case "GeometryCollection":
          for (final Map<String?, dynamic> geometry in o["geometries"]) {
            indexGeometry(geometry);
          }
          break;
        case "LineString":
          o["arcs"] = indexArcs(o["arcs"]);
          break;
        case "MultiLineString":
          o["arcs"] = (o["arcs"] as List<Arc>).map(indexArcs).toList();
          break;
        case "Polygon":
          o["arcs"] = (o["arcs"] as List<Arc>).map(indexArcs).toList();
          break;
        case "MultiPolygon":
          o["arcs"] =
              (o["arcs"] as List<List<Arc>>).map(indexMultiArcs).toList();
          break;
      }
    }
  }

  for (final o in objects.values) {
    indexGeometry(o);
  }

  if (transform != null) {
    topology["transform"] = transform;
    topology["arcs"] = delta(topology["arcs"]);
  }

  return topology;
}
