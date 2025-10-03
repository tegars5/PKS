import '../../../../models/tracking_model.dart';

abstract class TrackingRepository {
  Future<List<TrackingModel>> getTrackingByOrderId(String orderId);
  Future<TrackingModel> createTracking(TrackingModel tracking);
  Future<TrackingModel> updateTracking(TrackingModel tracking);
  Future<List<TrackingModel>> getTrackingByDriverId(String driverId);
}