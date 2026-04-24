import 'package:flutter_exam/features/tracking/data/datasources/tracking_remote_datasource.dart';
import 'package:flutter_exam/features/tracking/data/repositories/tracking_repository_impl.dart';
import 'package:flutter_exam/features/tracking/domain/repositories/tracking_repository.dart';
import 'package:flutter_exam/features/tracking/domain/usecases/get_target_location_usecase.dart';
import 'package:flutter_exam/features/tracking/presentation/cubit/tracking_cubit.dart';
import 'package:flutter_modular/flutter_modular.dart';

class AppModule extends Module {
  @override
  void binds(Injector i) {
    i
      ..addSingleton<TrackingRemoteDatasource>(TrackingRemoteDatasourceImpl.new)
      ..addSingleton<TrackingRepository>(TrackingRepositoryImpl.new)
      ..addSingleton<GetTargetLocationUsecase>(GetTargetLocationUsecase.new)
      ..addSingleton<TrackingCubit>(TrackingCubit.new);
  }
}
