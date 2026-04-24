import 'package:flutter_exam/features/tracking/data/local/models/location_reading_hive_model.dart';
import 'package:flutter_exam/features/tracking/domain/entities/location_reading_entity.dart';
import 'package:hive_flutter/hive_flutter.dart';

abstract class TrackingStorageService {
  Future<void> saveReading(LocationReadingEntity reading);
  Future<List<LocationReadingEntity>> getAllReadings();
  Future<void> clearAll();
}

class HiveTrackingStorageService implements TrackingStorageService {
  static const boxName = 'location_readings';

  Box<LocationReadingHiveModel> get _box =>
      Hive.box<LocationReadingHiveModel>(boxName);

  @override
  Future<void> saveReading(LocationReadingEntity reading) =>
      _box.add(LocationReadingHiveModel.fromEntity(reading));

  @override
  Future<List<LocationReadingEntity>> getAllReadings() async =>
      _box.values.map((m) => m.toEntity()).toList().reversed.toList();

  @override
  Future<void> clearAll() => _box.clear();
}
