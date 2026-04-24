import 'package:flutter_exam/features/tracking/domain/entities/location_reading_entity.dart';
import 'package:hive_flutter/hive_flutter.dart';

class LocationReadingHiveModel extends HiveObject {
  LocationReadingHiveModel({
    required this.timestampMs,
    required this.latitude,
    required this.longitude,
    required this.distance,
  });

  factory LocationReadingHiveModel.fromEntity(LocationReadingEntity entity) =>
      LocationReadingHiveModel(
        timestampMs: entity.timestamp.millisecondsSinceEpoch,
        latitude: entity.lat,
        longitude: entity.lng,
        distance: entity.distanceMeters,
      );

  int timestampMs;
  double latitude;
  double longitude;
  double distance;

  LocationReadingEntity toEntity() => LocationReadingEntity(
        timestamp: DateTime.fromMillisecondsSinceEpoch(timestampMs),
        lat: latitude,
        lng: longitude,
        distanceMeters: distance,
      );
}

class LocationReadingHiveModelAdapter
    extends TypeAdapter<LocationReadingHiveModel> {
  @override
  final int typeId = 0;

  @override
  LocationReadingHiveModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (var i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return LocationReadingHiveModel(
      timestampMs: fields[0] as int,
      latitude: fields[1] as double,
      longitude: fields[2] as double,
      distance: fields[3] as double,
    );
  }

  @override
  void write(BinaryWriter writer, LocationReadingHiveModel obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.timestampMs)
      ..writeByte(1)
      ..write(obj.latitude)
      ..writeByte(2)
      ..write(obj.longitude)
      ..writeByte(3)
      ..write(obj.distance);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is LocationReadingHiveModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
