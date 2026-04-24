part of 'tracking_cubit.dart';

enum TrackingStatus {
  initial,
  loading,
  permissionDenied,
  active,
  stopped,
  error,
}

final class TrackingState extends Equatable {
  const TrackingState({
    this.isTracking = false,
    this.readings = const [],
    this.filterCount = 10,
    this.status = TrackingStatus.initial,
    this.errorMessage,
  });

  final bool isTracking;
  final List<LocationReadingEntity> readings;
  final int filterCount;
  final TrackingStatus status;
  final String? errorMessage;

  List<LocationReadingEntity> get filteredReadings =>
      readings.take(filterCount).toList();

  TrackingState copyWith({
    bool? isTracking,
    List<LocationReadingEntity>? readings,
    int? filterCount,
    TrackingStatus? status,
    String? errorMessage,
  }) =>
      TrackingState(
        isTracking: isTracking ?? this.isTracking,
        readings: readings ?? this.readings,
        filterCount: filterCount ?? this.filterCount,
        status: status ?? this.status,
        errorMessage: errorMessage ?? this.errorMessage,
      );

  @override
  List<Object?> get props =>
      [isTracking, readings, filterCount, status, errorMessage];
}
