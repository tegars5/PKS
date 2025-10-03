import 'package:supabase_flutter/supabase_flutter.dart' as supabase;
import 'dart:io';

import '../../domain/repositories/profile_repository.dart';
import '../../../../models/user_model.dart';
import '../../../../core/exceptions/app_exceptions.dart';

class ProfileRepositoryImpl implements ProfileRepository {
  final supabase.SupabaseClient _supabaseClient;

  ProfileRepositoryImpl(this._supabaseClient);

  @override
  Future<UserModel> getProfile(String userId) async {
    try {
      print('=== GET PROFILE DEBUG START ===');
      print('Getting profile for user ID: $userId');
      
      final response = await _supabaseClient
          .from('profiles')
          .select()
          .eq('id', userId)
          .single();

      print('Profile response: $response');
      
      if (response != null) {
        final userModel = UserModel.fromJson(response);
        print('Profile successfully parsed: ${userModel.fullName}');
        print('=== GET PROFILE DEBUG END ===');
        return userModel;
      } else {
        print('Profile not found for user ID: $userId');
        print('=== GET PROFILE DEBUG END ===');
        throw const ServerException('Profile not found');
      }
    } on supabase.PostgrestException catch (e) {
      print('PostgrestException in getProfile: ${e.message}');
      print('Code: ${e.code}');
      print('Details: ${e.details}');
      print('=== GET PROFILE DEBUG END ===');
      throw ServerException('Database error: ${e.message}');
    } catch (e) {
      print('Unexpected error in getProfile: $e');
      print('Error type: ${e.runtimeType}');
      print('=== GET PROFILE DEBUG END ===');
      throw ServerException('An unexpected error occurred: $e');
    }
  }

  @override
  Future<UserModel> updateProfile(UserModel profile) async {
    try {
      print('=== UPDATE PROFILE DEBUG START ===');
      print('Updating profile for user ID: ${profile.id}');
      print('Profile data: ${profile.toJson()}');
      
      final response = await _supabaseClient
          .from('profiles')
          .update(profile.toJson())
          .eq('id', profile.id)
          .select()
          .single();

      print('Update response: $response');
      
      if (response != null) {
        final userModel = UserModel.fromJson(response);
        print('Profile successfully updated: ${userModel.fullName}');
        print('=== UPDATE PROFILE DEBUG END ===');
        return userModel;
      } else {
        print('Failed to update profile for user ID: ${profile.id}');
        print('=== UPDATE PROFILE DEBUG END ===');
        throw const ServerException('Failed to update profile');
      }
    } on supabase.PostgrestException catch (e) {
      print('PostgrestException in updateProfile: ${e.message}');
      print('Code: ${e.code}');
      print('Details: ${e.details}');
      print('=== UPDATE PROFILE DEBUG END ===');
      throw ServerException('Database error: ${e.message}');
    } catch (e) {
      print('Unexpected error in updateProfile: $e');
      print('Error type: ${e.runtimeType}');
      print('=== UPDATE PROFILE DEBUG END ===');
      throw ServerException('An unexpected error occurred: $e');
    }
  }

  @override
  Future<void> uploadProfileImage(String userId, String imagePath) async {
    try {
      final file = File(imagePath);
      await supabase.Supabase.instance.client.storage
          .from('profile_images')
          .upload('public/$userId.jpg', file);
    } on supabase.StorageException catch (e) {
      throw ServerException('Storage error: ${e.message}');
    } catch (e) {
      throw ServerException('An unexpected error occurred: $e');
    }
  }

  @override
  Future<String> getProfileImageUrl(String userId) async {
    try {
      final imageUrl = supabase.Supabase.instance.client.storage
          .from('profile_images')
          .getPublicUrl('public/$userId.jpg');

      return imageUrl;
    } on supabase.StorageException catch (e) {
      throw ServerException('Storage error: ${e.message}');
    } catch (e) {
      throw ServerException('An unexpected error occurred: $e');
    }
  }
}