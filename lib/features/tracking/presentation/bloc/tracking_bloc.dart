import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../domain/repositories/tracking_repository.dart';
import '../../../../models/tracking_model.dart';
import '../../../../core/exceptions/app_exceptions.dart';

part 'tracking_event.dart';
part 'tracking_state.dart';

class TrackingBloc extends Bloc<TrackingEvent, TrackingState> {
  final TrackingRepository _trackingRepository;

  TrackingBloc({
    required TrackingRepository trackingRepository,
  })  : _trackingRepository = trackingRepository,
        super(TrackingInitial()) {
    on<GetTrackingByOrderId>(_onGetTrackingByOrderId);
    on<CreateTracking>(_onCreateTracking);
    on<UpdateTracking>(_onUpdateTracking);
    on<GetTrackingByDriverId>(_onGetTrackingByDriverId);
  }

  Future<void> _onGetTrackingByOrderId(
    GetTrackingByOrderId event,
    Emitter<TrackingState> emit,
  ) async {
    emit(TrackingLoading());
    try {
      final trackingList = await _trackingRepository.getTrackingByOrderId(event.orderId);
      emit(TrackingLoaded(trackingList));
    } on AppException catch (e) {
      emit(TrackingError(e.message));
    } catch (e) {
      emit(TrackingError('An unexpected error occurred: $e'));
    }
  }

  Future<void> _onCreateTracking(
    CreateTracking event,
    Emitter<TrackingState> emit,
  ) async {
    emit(TrackingLoading());
    try {
      await _trackingRepository.createTracking(event.tracking);
      emit(const TrackingOperationSuccess('Tracking created successfully'));
    } on AppException catch (e) {
      emit(TrackingError(e.message));
    } catch (e) {
      emit(TrackingError('An unexpected error occurred: $e'));
    }
  }

  Future<void> _onUpdateTracking(
    UpdateTracking event,
    Emitter<TrackingState> emit,
  ) async {
    emit(TrackingLoading());
    try {
      await _trackingRepository.updateTracking(event.tracking);
      emit(const TrackingOperationSuccess('Tracking updated successfully'));
    } on AppException catch (e) {
      emit(TrackingError(e.message));
    } catch (e) {
      emit(TrackingError('An unexpected error occurred: $e'));
    }
  }

  Future<void> _onGetTrackingByDriverId(
    GetTrackingByDriverId event,
    Emitter<TrackingState> emit,
  ) async {
    emit(TrackingLoading());
    try {
      final trackingList = await _trackingRepository.getTrackingByDriverId(event.driverId);
      emit(TrackingLoaded(trackingList));
    } on AppException catch (e) {
      emit(TrackingError(e.message));
    } catch (e) {
      emit(TrackingError('An unexpected error occurred: $e'));
    }
  }
}