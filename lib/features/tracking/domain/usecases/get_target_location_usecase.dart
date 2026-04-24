import 'package:flutter_exam/features/tracking/domain/entities/target_location_entity.dart';
import 'package:flutter_exam/features/tracking/domain/repositories/tracking_repository.dart';

class GetTargetLocationUsecase {
  const GetTargetLocationUsecase(this._repository);

  final TrackingRepository _repository;

  Future<TargetLocationEntity> call() => _repository.getTargetLocation();
}
