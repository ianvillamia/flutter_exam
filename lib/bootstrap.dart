import 'dart:async';
import 'dart:developer' as developer;

import 'package:bloc/bloc.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_exam/features/tracking/data/local/models/location_reading_hive_model.dart';
import 'package:flutter_exam/features/tracking/data/local/services/tracking_storage_service.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:nb_utils/nb_utils.dart';

class AppBlocObserver extends BlocObserver {
  const AppBlocObserver();

  @override
  void onChange(BlocBase<dynamic> bloc, Change<dynamic> change) {
    super.onChange(bloc, change);
    developer.log('onChange(${bloc.runtimeType}, $change)');
  }

  @override
  void onError(BlocBase<dynamic> bloc, Object error, StackTrace stackTrace) {
    developer.log(
      'onError(${bloc.runtimeType}, $error, $stackTrace)',
    );
    super.onError(bloc, error, stackTrace);
  }
}

Future<void> bootstrap(FutureOr<Widget> Function() builder) async {
  WidgetsFlutterBinding.ensureInitialized();

  await Hive.initFlutter();
  Hive.registerAdapter(LocationReadingHiveModelAdapter());
  await Hive.openBox<LocationReadingHiveModel>(
    HiveTrackingStorageService.boxName,
  );

  await initialize();

  FlutterError.onError = (details) {
    developer.log(details.exceptionAsString());
  };

  Bloc.observer = const AppBlocObserver();

  runApp(await builder());
}
