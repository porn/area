import 'package:area/area.dart';

main() {
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

  print("The world area is: ${area(world)} m²");
}
