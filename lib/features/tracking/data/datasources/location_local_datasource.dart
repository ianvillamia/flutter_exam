import 'package:geolocator/geolocator.dart';

abstract class LocationLocalDatasource {
  Future<bool> requestPermission();
  Future<Position> getCurrentPosition();
}

class LocationLocalDatasourceImpl implements LocationLocalDatasource {
  const LocationLocalDatasourceImpl();

  @override
  Future<bool> requestPermission() async {
    var permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }
    return permission == LocationPermission.always ||
        permission == LocationPermission.whileInUse;
  }

  @override
  Future<Position> getCurrentPosition() => Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.high,
          timeLimit: Duration(seconds: 10),
        ),
      );
}
