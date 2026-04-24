import 'package:equatable/equatable.dart';

class LocationReadingEntity extends Equatable {
  const LocationReadingEntity({
    required this.timestamp,
    required this.lat,
    required this.lng,
    required this.distanceMeters,
  });

  final DateTime timestamp;
  final double lat;
  final double lng;
  final double distanceMeters;

  @override
  List<Object?> get props => [timestamp, lat, lng, distanceMeters];
}
