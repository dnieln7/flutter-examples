part of 'location_bloc.dart';

@immutable
abstract class LocationEvent {}

@immutable
class FromGps extends LocationEvent {
  final double x;
  final double y;
  final double z;

  FromGps(this.x, this.y, this.z);

  @override
  String toString() {
    return 'FromGps{x: $x, y: $y, z: $z}';
  }
}

@immutable
class FromWifi extends LocationEvent {
  final String rawCoordinates;

  FromWifi(this.rawCoordinates);

  @override
  String toString() {
    return 'FromWifi{rawCoordinates: $rawCoordinates}';
  }
}
