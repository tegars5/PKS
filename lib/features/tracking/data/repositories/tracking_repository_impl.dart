import 'package:supabase_flutter/supabase_flutter.dart' as supabase;

import '../../domain/repositories/tracking_repository.dart';
import '../../../../models/tracking_model.dart';
import '../../../../core/exceptions/app_exceptions.dart';

class TrackingRepositoryImpl implements TrackingRepository {
  final supabase.SupabaseClient _supabaseClient;

  TrackingRepositoryImpl(this._supabaseClient);

  @override
  Future<List<TrackingModel>> getTrackingByOrderId(String orderId) async {
    try {
      print('=== GET TRACKING BY ORDER ID DEBUG START ===');
      print('Getting tracking for order: $orderId');
      
      final response = await _supabaseClient
          .from('tracking')
          .select()
          .eq('order_id', orderId)
          .order('created_at', ascending: false);

      print('Tracking response: $response');
      
      List<TrackingModel> trackingList = [];
      for (var item in response) {
        trackingList.add(TrackingModel.fromJson(item));
      }
      
      print('Tracking parsed successfully: ${trackingList.length} items');
      print('=== GET TRACKING BY ORDER ID DEBUG END ===');
      return trackingList;
    } on supabase.PostgrestException catch (e) {
      print('PostgrestException in getTrackingByOrderId: ${e.message}');
      print('=== GET TRACKING BY ORDER ID DEBUG END ===');
      throw ServerException('Database error: ${e.message}');
    } catch (e) {
      print('Unexpected error in getTrackingByOrderId: $e');
      print('=== GET TRACKING BY ORDER ID DEBUG END ===');
      throw ServerException('An unexpected error occurred: $e');
    }
  }

  @override
  Future<TrackingModel> createTracking(TrackingModel tracking) async {
    try {
      print('=== CREATE TRACKING DEBUG START ===');
      print('Creating tracking for order: ${tracking.orderId}');
      
      final response = await _supabaseClient
          .from('tracking')
          .insert(tracking.toJson())
          .select()
          .single();

      print('Create tracking response: $response');
      
      final newTracking = TrackingModel.fromJson(response);
      print('Tracking created successfully: ${newTracking.id}');
      print('=== CREATE TRACKING DEBUG END ===');
      return newTracking;
    } on supabase.PostgrestException catch (e) {
      print('PostgrestException in createTracking: ${e.message}');
      print('=== CREATE TRACKING DEBUG END ===');
      throw ServerException('Database error: ${e.message}');
    } catch (e) {
      print('Unexpected error in createTracking: $e');
      print('=== CREATE TRACKING DEBUG END ===');
      throw ServerException('An unexpected error occurred: $e');
    }
  }

  @override
  Future<TrackingModel> updateTracking(TrackingModel tracking) async {
    try {
      print('=== UPDATE TRACKING DEBUG START ===');
      print('Updating tracking: ${tracking.id}');
      
      final response = await _supabaseClient
          .from('tracking')
          .update(tracking.toJson())
          .eq('id', tracking.id)
          .select()
          .single();

      print('Update tracking response: $response');
      
      final updatedTracking = TrackingModel.fromJson(response);
      print('Tracking updated successfully: ${updatedTracking.id}');
      print('=== UPDATE TRACKING DEBUG END ===');
      return updatedTracking;
    } on supabase.PostgrestException catch (e) {
      print('PostgrestException in updateTracking: ${e.message}');
      print('=== UPDATE TRACKING DEBUG END ===');
      throw ServerException('Database error: ${e.message}');
    } catch (e) {
      print('Unexpected error in updateTracking: $e');
      print('=== UPDATE TRACKING DEBUG END ===');
      throw ServerException('An unexpected error occurred: $e');
    }
  }

  @override
  Future<List<TrackingModel>> getTrackingByDriverId(String driverId) async {
    try {
      print('=== GET TRACKING BY DRIVER ID DEBUG START ===');
      print('Getting tracking for driver: $driverId');
      
      final response = await _supabaseClient
          .from('tracking')
          .select()
          .eq('driver_id', driverId)
          .order('created_at', ascending: false);

      print('Tracking by driver response: $response');
      
      List<TrackingModel> trackingList = [];
      for (var item in response) {
        trackingList.add(TrackingModel.fromJson(item));
      }
      
      print('Tracking by driver parsed successfully: ${trackingList.length} items');
      print('=== GET TRACKING BY DRIVER ID DEBUG END ===');
      return trackingList;
    } on supabase.PostgrestException catch (e) {
      print('PostgrestException in getTrackingByDriverId: ${e.message}');
      print('=== GET TRACKING BY DRIVER ID DEBUG END ===');
      throw ServerException('Database error: ${e.message}');
    } catch (e) {
      print('Unexpected error in getTrackingByDriverId: $e');
      print('=== GET TRACKING BY DRIVER ID DEBUG END ===');
      throw ServerException('An unexpected error occurred: $e');
    }
  }
}