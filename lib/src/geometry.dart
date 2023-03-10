// Given a hash of GeoJSON objects, returns a hash of GeoJSON geometry objects.
// Any null input geometry objects are represented as {type: null} in the
// output. Any feature.{id,properties,bbox} are transferred to the output
// geometry object. Each output geometry object is a shallow copy of the input
// (e.g., properties, coordinates)!
Map<String?, Map<String?, dynamic>> geometry(Map<String?, dynamic> inputs) {
  var outputs = <String?, Map<String?, dynamic>>{};
  for (final i in inputs.entries) {
    outputs[i.key] = _geomifyObject(i.value);
  }
  return outputs;
}

Map<String?, dynamic> _geomifyObject(Map<String?, dynamic>? input) =>
    input == null
        ? {"type": null}
        : (input["type"] == "FeatureCollection"
            ? _geomifyFeatureCollection
            : input["type"] == "Feature"
                ? _geomifyFeature
                : _geomifyGeometry)(input);

Map<String?, dynamic> _geomifyFeatureCollection(Map<String?, dynamic> input) {
  var output = {
    "type": "GeometryCollection",
    "geometries":
        (List.castFrom<dynamic, Map<String?, dynamic>>(input["features"]))
            .map(_geomifyFeature)
            .toList()
  };
  if (input["bbox"] != null) output["bbox"] = input["bbox"];
  return output;
}

Map<String?, dynamic> _geomifyFeature(Map<String?, dynamic> input) {
  var output = _geomifyGeometry(input["geometry"]);
  Map? properties = input["properties"];
  if (input["id"] != null) output["id"] = input["id"];
  if (input["bbox"] != null) output["bbox"] = input["bbox"];
  if (properties != null && properties.isNotEmpty) {
    output["properties"] = properties;
  }
  return output;
}

Map<String?, dynamic> _geomifyGeometry(Map<String?, dynamic>? input) {
  if (input == null) return {"type": null};
  var output = input["type"] == "GeometryCollection"
      ? {
          "type": "GeometryCollection",
          "geometries": (List.castFrom<dynamic, Map<String?, dynamic>?>(
                  input["geometries"]))
              .map(_geomifyGeometry)
              .toList()
        }
      : input["type"] == "Point" || input["type"] == "MultiPoint"
          ? {"type": input["type"], "coordinates": input["coordinates"]}
          : {
              "type": input["type"],
              "arcs": input["coordinates"]
            }; // TODO Check for unknown types?
  if (input["bbox"] != null) output["bbox"] = input["bbox"];
  return output;
}
