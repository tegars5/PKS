import '../../../../models/user_model.dart';

abstract class ProfileRepository {
  Future<UserModel> getProfile(String userId);
  Future<UserModel> updateProfile(UserModel profile);
  Future<void> uploadProfileImage(String userId, String imagePath);
  Future<String> getProfileImageUrl(String userId);
}