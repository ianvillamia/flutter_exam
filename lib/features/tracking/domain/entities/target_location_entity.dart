import 'package:equatable/equatable.dart';

class TargetLocationEntity extends Equatable {
  const TargetLocationEntity({
    required this.id,
    required this.targetLat,
    required this.targetLng,
  });

  final String id;
  final double targetLat;
  final double targetLng;

  @override
  List<Object?> get props => [id, targetLat, targetLng];
}
