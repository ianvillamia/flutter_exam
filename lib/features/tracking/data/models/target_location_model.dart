import 'package:flutter_exam/features/tracking/domain/entities/target_location_entity.dart';

class TargetLocationModel extends TargetLocationEntity {
  const TargetLocationModel({
    required super.id,
    required super.targetLat,
    required super.targetLng,
  });

  factory TargetLocationModel.fromJson(Map<String, dynamic> json) {
    return TargetLocationModel(
      id: json['id'] as String,
      targetLat: (json['target_lat'] as num).toDouble(),
      targetLng: (json['target_lng'] as num).toDouble(),
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'target_lat': targetLat,
        'target_lng': targetLng,
      };
}
