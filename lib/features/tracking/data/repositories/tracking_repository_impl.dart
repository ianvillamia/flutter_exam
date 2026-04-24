import 'package:flutter_exam/features/tracking/data/datasources/tracking_remote_datasource.dart';
import 'package:flutter_exam/features/tracking/data/models/target_location_model.dart';
import 'package:flutter_exam/features/tracking/domain/entities/target_location_entity.dart';
import 'package:flutter_exam/features/tracking/domain/repositories/tracking_repository.dart';

class TrackingRepositoryImpl implements TrackingRepository {
  const TrackingRepositoryImpl(this._datasource);

  final TrackingRemoteDatasource _datasource;

  @override
  Future<TargetLocationEntity> getTargetLocation() async {
    final json = await _datasource.getTargetLocation();
    return TargetLocationModel.fromJson(json);
  }
}
