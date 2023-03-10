Convert GeoJSON objects to TopoJSON topology and quantize it to increase
quality.

The **topo_server** module provides tools for converting GeoJSON to
[TopoJSON](https://github.com/topojson). See
[How to Infer Topology](https://bost.ocks.org/mike/topology/) for details on
how the topology is constructed.

See
[shapefile](https://pub.dev/documentation/shapefile/latest/shapefile/shapefile-library.html)
for converting ESRI
shapefiles to GeoJSON, [ndjson-cli](https://github.com/mbostock/ndjson-cli)
for manipulating newline-delimited JSON streams,
[d3-geo-projection](https://github.com/d3/d3-geo-projection) for
manipulating GeoJSON, and
[topo_client](https://pub.dev/documentation/topo_client/latest/topo_client/topo_client-library.html)
for manipulating TopoJSON and converting it back to GeoJSON. See also
[us-atlas](https://github.com/topojson/us-atlas) and
[world-atlas](https://github.com/topojson/world-atlas) for pre-built
TopoJSON.
