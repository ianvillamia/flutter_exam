part of 'tracking_cubit.dart';

sealed class TrackingState extends Equatable {
  const TrackingState();

  @override
  List<Object?> get props => [];
}

final class TrackingInitial extends TrackingState {
  const TrackingInitial();
}

final class TrackingLoading extends TrackingState {
  const TrackingLoading();
}

final class TrackingLoaded extends TrackingState {
  const TrackingLoaded(this.targetLocation);

  final TargetLocationEntity targetLocation;

  @override
  List<Object?> get props => [targetLocation];
}

final class TrackingError extends TrackingState {
  const TrackingError(this.message);

  final String message;

  @override
  List<Object?> get props => [message];
}
