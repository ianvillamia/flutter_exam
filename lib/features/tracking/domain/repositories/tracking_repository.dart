import 'package:flutter_exam/features/tracking/domain/entities/location_reading_entity.dart';
import 'package:flutter_exam/features/tracking/domain/entities/target_location_entity.dart';

abstract class TrackingRepository {
  Future<TargetLocationEntity> getTargetLocation();
  Future<bool> requestLocationPermission();
  Future<LocationReadingEntity> getLocationReading(TargetLocationEntity target);
}
