part of 'location_bloc.dart';

@immutable
class LocationState {
  final double x;
  final double y;
  final double z;
  final double accuracy;

  const LocationState(this.x, this.y, this.z, this.accuracy);

  @override
  String toString() {
    return 'LocationState{x: $x, y: $y, z: $z, accuracy: $accuracy}';
  }
}
