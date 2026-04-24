// ignore: one_member_abstracts, clean architecture contract — more methods will be added as the feature grows
abstract class TrackingRemoteDatasource {
  Future<Map<String, dynamic>> getTargetLocation();
}

class TrackingRemoteDatasourceImpl implements TrackingRemoteDatasource {
  const TrackingRemoteDatasourceImpl();

  @override
  Future<Map<String, dynamic>> getTargetLocation() async {
    // TODO(dean): replace with real HTTP call (e.g. via Dio)
    return {
      'id': '001',
      'target_lat': 1.265,
      'target_lng': 103.695,
    };
  }
}
