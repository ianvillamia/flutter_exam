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
  void onCreate(BlocBase<dynamic> bloc) {
    super.onCreate(bloc);
    developer.log('[CREATE] ${bloc.runtimeType}');
  }

  @override
  void onClose(BlocBase<dynamic> bloc) {
    super.onClose(bloc);
    developer.log('[CLOSE]  ${bloc.runtimeType}');
  }

  @override
  void onChange(BlocBase<dynamic> bloc, Change<dynamic> change) {
    super.onChange(bloc, change);
    developer.log(
      '[CHANGE] ${bloc.runtimeType}\n'
      '  current : ${change.currentState}\n'
      '  next    : ${change.nextState}',
    );
  }

  @override
  void onTransition(
    Bloc<dynamic, dynamic> bloc,
    Transition<dynamic, dynamic> transition,
  ) {
    super.onTransition(bloc, transition);
    developer.log(
      '[TRANSITION] ${bloc.runtimeType}\n'
      '  event   : ${transition.event}\n'
      '  current : ${transition.currentState}\n'
      '  next    : ${transition.nextState}',
    );
  }

  @override
  void onError(BlocBase<dynamic> bloc, Object error, StackTrace stackTrace) {
    developer.log('[ERROR]  ${bloc.runtimeType} — $error', error: error);
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
