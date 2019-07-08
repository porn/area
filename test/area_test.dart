import 'dart:convert';
import 'dart:io';

import 'package:area/area.dart';
import 'package:test/test.dart';

const illinois_area = 145978332359.36746;
const world_area = 511207893395811.06;

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

void main() {
  String illinoisString() {
    // hack test path to work from command line as well as from IDE
    String testDir = Directory.current.path;
    if (!testDir.endsWith('/test')) {
      testDir += '/test';
    }
    return File('$testDir/illinois.json').readAsStringSync();
  }

  test('test area illinois with string', () {
    expect(area(illinoisString()), illinois_area);
  });

  test('test area illinois', () {
    final illinois = jsonDecode(illinoisString());
    expect(area(illinois), illinois_area);
  });

  test('test area world', () {
    expect(area(world), world_area);
  });

  test('test point area', () {
    expect(
        area({
          'type': 'Point',
          'coordinates': [0, 0]
        }),
        0);
  });

  test('test linestring area', () {
    expect(
        area({
          'type': 'LineString',
          'coordinates': [
            [0, 0],
            [1, 1]
          ]
        }),
        0);
  });

  test('test geometry collection area', () {
    final illinois = jsonDecode(illinoisString());
    expect(
        area({
          'type': 'GeometryCollection',
          'geometries': [world, illinois]
        }),
        world_area + illinois_area);
  });
}
