library area;

import 'dart:convert';
import "dart:math" show pi, sin;

const WGS84_RADIUS = 6378137;

/// convert degrees to radians
num rad(num value) => value * pi / 180;

/// Calculate the approximate _area of the polygon were it projected onto
///     the earth.  Note that this _area will be positive if ring is oriented
///     clockwise, otherwise it will be negative.
///
/// Reference:
///     Robert. G. Chamberlain and William H. Duquette, "Some Algorithms for
///     Polygons on a Sphere", JPL Publication 07-03, Jet Propulsion
///     Laboratory, Pasadena, CA, June 2007 http://trs-new.jpl.nasa.gov/dspace/handle/2014/40409
///
/// Returns:
///
/// {num} The approximate signed geodesic _area of the polygon in square meters.
num ringArea(List coordinates) {
  assert(coordinates is List);

  num _area = 0;

  if (coordinates.length > 2) {
    for (int i = 0; i < coordinates.length; i++) {
      var lowerIndex = i;
      var middleIndex = i + 1;
      var upperIndex = i + 2;

      if (i == coordinates.length - 2) {
        lowerIndex = coordinates.length - 2;
        middleIndex = coordinates.length - 1;
        upperIndex = 0;
      } else if (i == coordinates.length - 1) {
        lowerIndex = coordinates.length - 1;
        middleIndex = 0;
        upperIndex = 1;
      }

      var p1 = coordinates[lowerIndex];
      var p2 = coordinates[middleIndex];
      var p3 = coordinates[upperIndex];

      _area += (rad(p3[0]) - rad(p1[0])) * sin(rad(p2[1]));
    }

    _area = _area * WGS84_RADIUS * WGS84_RADIUS / 2;
  }

  return _area;
}

num polygonArea(List coordinates) {
  assert(coordinates is List);

  num _area = 0;

  if (coordinates.isNotEmpty) {
    _area += ringArea(coordinates[0]).abs();
    for (var hole in coordinates.getRange(1, coordinates.length)) {
      _area -= ringArea(hole).abs();
    }
  }

  return _area;
}

/// Return area (in sqm) of given GeoJSON geometry
num area(geometry) {
  if (geometry is String) {
    geometry = jsonDecode(geometry);
  }

  assert(geometry is Map);

  num _area = 0;

  if (geometry['type'] == 'Polygon') {
    return polygonArea(geometry['coordinates']);
  } else if (geometry['type'] == 'MultiPolygon') {
    for (var polygon_coords in geometry['coordinates']) {
      _area += polygonArea(polygon_coords);
    }
  } else if (geometry['type'] == 'GeometryCollection') {
    for (var geom in geometry['geometries']) {
      _area += area(geom);
    }
  }

  return _area;
}

