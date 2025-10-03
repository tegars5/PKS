part of 'tracking_bloc.dart';

abstract class TrackingEvent extends Equatable {
  const TrackingEvent();

  @override
  List<Object> get props => [];
}

class GetTrackingByOrderId extends TrackingEvent {
  final String orderId;

  const GetTrackingByOrderId(this.orderId);

  @override
  List<Object> get props => [orderId];
}

class CreateTracking extends TrackingEvent {
  final TrackingModel tracking;

  const CreateTracking(this.tracking);

  @override
  List<Object> get props => [tracking];
}

class UpdateTracking extends TrackingEvent {
  final TrackingModel tracking;

  const UpdateTracking(this.tracking);

  @override
  List<Object> get props => [tracking];
}

class GetTrackingByDriverId extends TrackingEvent {
  final String driverId;

  const GetTrackingByDriverId(this.driverId);

  @override
  List<Object> get props => [driverId];
}