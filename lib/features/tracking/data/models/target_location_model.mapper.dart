// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
// ignore_for_file: type=lint
// ignore_for_file: invalid_use_of_protected_member
// ignore_for_file: unused_element, unnecessary_cast, override_on_non_overriding_member
// ignore_for_file: strict_raw_type, inference_failure_on_untyped_parameter

part of 'target_location_model.dart';

class TargetLocationModelMapper extends ClassMapperBase<TargetLocationModel> {
  TargetLocationModelMapper._();

  static TargetLocationModelMapper? _instance;
  static TargetLocationModelMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = TargetLocationModelMapper._());
    }
    return _instance!;
  }

  @override
  final String id = 'TargetLocationModel';

  static String _$id(TargetLocationModel v) => v.id;
  static const Field<TargetLocationModel, String> _f$id = Field('id', _$id);
  static double _$targetLat(TargetLocationModel v) => v.targetLat;
  static const Field<TargetLocationModel, double> _f$targetLat = Field(
    'targetLat',
    _$targetLat,
    key: r'target_lat',
  );
  static double _$targetLng(TargetLocationModel v) => v.targetLng;
  static const Field<TargetLocationModel, double> _f$targetLng = Field(
    'targetLng',
    _$targetLng,
    key: r'target_lng',
  );

  @override
  final MappableFields<TargetLocationModel> fields = const {
    #id: _f$id,
    #targetLat: _f$targetLat,
    #targetLng: _f$targetLng,
  };

  static TargetLocationModel _instantiate(DecodingData data) {
    return TargetLocationModel(
      id: data.dec(_f$id),
      targetLat: data.dec(_f$targetLat),
      targetLng: data.dec(_f$targetLng),
    );
  }

  @override
  final Function instantiate = _instantiate;

  static TargetLocationModel fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<TargetLocationModel>(map);
  }

  static TargetLocationModel fromJson(String json) {
    return ensureInitialized().decodeJson<TargetLocationModel>(json);
  }
}

mixin TargetLocationModelMappable {
  String toJson() {
    return TargetLocationModelMapper.ensureInitialized()
        .encodeJson<TargetLocationModel>(this as TargetLocationModel);
  }

  Map<String, dynamic> toMap() {
    return TargetLocationModelMapper.ensureInitialized()
        .encodeMap<TargetLocationModel>(this as TargetLocationModel);
  }

  TargetLocationModelCopyWith<
    TargetLocationModel,
    TargetLocationModel,
    TargetLocationModel
  >
  get copyWith =>
      _TargetLocationModelCopyWithImpl<
        TargetLocationModel,
        TargetLocationModel
      >(this as TargetLocationModel, $identity, $identity);
  @override
  String toString() {
    return TargetLocationModelMapper.ensureInitialized().stringifyValue(
      this as TargetLocationModel,
    );
  }
}

extension TargetLocationModelValueCopy<$R, $Out>
    on ObjectCopyWith<$R, TargetLocationModel, $Out> {
  TargetLocationModelCopyWith<$R, TargetLocationModel, $Out>
  get $asTargetLocationModel => $base.as(
    (v, t, t2) => _TargetLocationModelCopyWithImpl<$R, $Out>(v, t, t2),
  );
}

abstract class TargetLocationModelCopyWith<
  $R,
  $In extends TargetLocationModel,
  $Out
>
    implements ClassCopyWith<$R, $In, $Out> {
  $R call({String? id, double? targetLat, double? targetLng});
  TargetLocationModelCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  );
}

class _TargetLocationModelCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, TargetLocationModel, $Out>
    implements TargetLocationModelCopyWith<$R, TargetLocationModel, $Out> {
  _TargetLocationModelCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<TargetLocationModel> $mapper =
      TargetLocationModelMapper.ensureInitialized();
  @override
  $R call({String? id, double? targetLat, double? targetLng}) => $apply(
    FieldCopyWithData({
      if (id != null) #id: id,
      if (targetLat != null) #targetLat: targetLat,
      if (targetLng != null) #targetLng: targetLng,
    }),
  );
  @override
  TargetLocationModel $make(CopyWithData data) => TargetLocationModel(
    id: data.get(#id, or: $value.id),
    targetLat: data.get(#targetLat, or: $value.targetLat),
    targetLng: data.get(#targetLng, or: $value.targetLng),
  );

  @override
  TargetLocationModelCopyWith<$R2, TargetLocationModel, $Out2>
  $chain<$R2, $Out2>(Then<$Out2, $R2> t) =>
      _TargetLocationModelCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

