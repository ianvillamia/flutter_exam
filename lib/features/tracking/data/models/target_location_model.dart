import 'package:dart_mappable/dart_mappable.dart';
import 'package:flutter_exam/features/tracking/domain/entities/target_location_entity.dart';

part 'target_location_model.mapper.dart';

@MappableClass(
  caseStyle: CaseStyle.snakeCase,
  generateMethods: GenerateMethods.encode |
      GenerateMethods.decode |
      GenerateMethods.copy |
      GenerateMethods.stringify,
)
class TargetLocationModel extends TargetLocationEntity
    with TargetLocationModelMappable {
  const TargetLocationModel({
    required super.id,
    required super.targetLat,
    required super.targetLng,
  });
}
