import 'package:flutter_exam/features/tracking/data/datasources/location_local_datasource.dart';
import 'package:flutter_exam/features/tracking/data/datasources/tracking_remote_datasource.dart';
import 'package:flutter_exam/features/tracking/data/datasources/tracking_storage_service.dart';
import 'package:flutter_exam/features/tracking/data/models/target_location_model.dart';
import 'package:flutter_exam/features/tracking/domain/entities/location_reading_entity.dart';
import 'package:flutter_exam/features/tracking/domain/entities/target_location_entity.dart';
import 'package:flutter_exam/features/tracking/domain/repositories/tracking_repository.dart';
import 'package:geolocator/geolocator.dart';

class TrackingRepositoryImpl implements TrackingRepository {
  const TrackingRepositoryImpl(
    this._remoteDatasource,
    this._localDatasource,
    this._storageService,
  );

  final TrackingRemoteDatasource _remoteDatasource;
  final LocationLocalDatasource _localDatasource;
  final TrackingStorageService _storageService;

  @override
  Future<TargetLocationEntity> getTargetLocation() async {
    final json = await _remoteDatasource.getTargetLocation();
    return TargetLocationModelMapper.fromMap(json);
  }

  @override
  Future<bool> requestLocationPermission() =>
      _localDatasource.requestPermission();

  @override
  Future<LocationReadingEntity> getLocationReading(
    TargetLocationEntity target,
  ) async {
    final position = await _localDatasource.getCurrentPosition();
    final distance = Geolocator.distanceBetween(
      position.latitude,
      position.longitude,
      target.targetLat,
      target.targetLng,
    );
    final reading = LocationReadingEntity(
      timestamp: DateTime.now(),
      lat: position.latitude,
      lng: position.longitude,
      distanceMeters: distance,
    );
    await _storageService.saveReading(reading);
    return reading;
  }

  @override
  Future<List<LocationReadingEntity>> getSavedReadings() =>
      _storageService.getAllReadings();

  @override
  Future<void> clearReadings() => _storageService.clearAll();
}
