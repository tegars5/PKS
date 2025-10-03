part of 'tracking_bloc.dart';

abstract class TrackingState extends Equatable {
  const TrackingState();

  @override
  List<Object> get props => [];
}

class TrackingInitial extends TrackingState {}

class TrackingLoading extends TrackingState {}

class TrackingLoaded extends TrackingState {
  final List<TrackingModel> trackingList;

  const TrackingLoaded(this.trackingList);

  @override
  List<Object> get props => [trackingList];
}

class TrackingOperationSuccess extends TrackingState {
  final String message;

  const TrackingOperationSuccess(this.message);

  @override
  List<Object> get props => [message];
}

class TrackingError extends TrackingState {
  final String message;

  const TrackingError(this.message);

  @override
  List<Object> get props => [message];
}