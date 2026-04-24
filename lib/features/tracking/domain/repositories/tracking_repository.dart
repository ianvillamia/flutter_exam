import 'package:flutter_exam/features/tracking/domain/entities/target_location_entity.dart';

// ignore: one_member_abstracts, clean architecture contract — more methods will be added as the feature grows
abstract class TrackingRepository {
  Future<TargetLocationEntity> getTargetLocation();
}
