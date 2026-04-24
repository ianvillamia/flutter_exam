import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_exam/features/tracking/domain/entities/target_location_entity.dart';
import 'package:flutter_exam/features/tracking/domain/usecases/get_target_location_usecase.dart';

part 'tracking_state.dart';

class TrackingCubit extends Cubit<TrackingState> {
  TrackingCubit(this._getTargetLocationUsecase)
      : super(const TrackingInitial());

  final GetTargetLocationUsecase _getTargetLocationUsecase;

  Future<void> fetchTargetLocation() async {
    emit(const TrackingLoading());
    try {
      final result = await _getTargetLocationUsecase();
      emit(TrackingLoaded(result));
    } on Exception catch (e) {
      emit(TrackingError(e.toString()));
    }
  }
}
