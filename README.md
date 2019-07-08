# Area

Calculate the area (in square meters) of a [GeoJSON](https://geojson.org/) polygon or multipolygon.

## Usage

```
import 'package:area/area.dart';

const world = {
  'type': 'Polygon',
  'coordinates': [
    [
      [-180, -90],
      [-180, 90],
      [180, 90],
      [180, -90],
      [-180, -90]
    ]
  ]
};

print(area(world));
```

## Tests

Just run:

```
$ pub run test/area_test.dart
```

## Credit
- [area](https://github.com/scisco/area)
- [geojson-area](https://github.com/mapbox/geojson-area)
