import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_exam/features/tracking/domain/entities/location_reading_entity.dart';
import 'package:flutter_exam/features/tracking/domain/entities/target_location_entity.dart';
import 'package:flutter_exam/features/tracking/domain/repositories/tracking_repository.dart';
import 'package:flutter_exam/features/tracking/domain/usecases/get_target_location_usecase.dart';

part 'tracking_state.dart';

class TrackingCubit extends Cubit<TrackingState> {
  TrackingCubit(this._getTargetLocationUsecase, this._repository)
      : super(const TrackingState()) {
    unawaited(_loadPersistedReadings());
  }

  final GetTargetLocationUsecase _getTargetLocationUsecase;
  final TrackingRepository _repository;

  static const _pollInterval = Duration(seconds: 5);

  Timer? _timer;
  TargetLocationEntity? _target;
  bool _isPolling = false;

  Future<void> _loadPersistedReadings() async {
    final readings = await _repository.getSavedReadings();
    if (readings.isNotEmpty && !isClosed) {
      emit(state.copyWith(readings: readings));
    }
  }

  Future<void> toggleTracking() async {
    if (state.isTracking) {
      _stopTracking();
    } else {
      await _startTracking();
    }
  }

  Future<void> _startTracking() async {
    emit(state.copyWith(status: TrackingStatus.loading));

    final hasPermission = await _repository.requestLocationPermission();
    if (!hasPermission) {
      emit(state.copyWith(status: TrackingStatus.permissionDenied));
      return;
    }

    try {
      _target = await _getTargetLocationUsecase();
    } on Exception catch (e) {
      emit(state.copyWith(
        status: TrackingStatus.error,
        errorMessage: e.toString(),
      ));
      return;
    }

    emit(state.copyWith(isTracking: true, status: TrackingStatus.active));
    await _tick();
    _timer = Timer.periodic(_pollInterval, (_) => _tick());
  }

  void _stopTracking() {
    _timer?.cancel();
    _timer = null;
    emit(state.copyWith(isTracking: false, status: TrackingStatus.stopped));
  }

  Future<void> _tick() async {
    if (_isPolling || _target == null || isClosed) return;
    _isPolling = true;
    try {
      final reading = await _repository.getLocationReading(_target!);
      if (!isClosed) {
        emit(state.copyWith(readings: [reading, ...state.readings]));
      }
    } on Exception catch (e) {
      if (!isClosed) emit(state.copyWith(errorMessage: e.toString()));
    } finally {
      _isPolling = false;
    }
  }

  void updateFilter(int count) => emit(state.copyWith(filterCount: count));

  @override
  Future<void> close() {
    _timer?.cancel();
    return super.close();
  }
}
