import '../entities/auth_user.dart';

abstract class AuthRepository {
  Future<AuthUser?> signInWithEmailPassword(String email, String password);
  Future<AuthUser?> signUpWithEmailPassword(
    String email,
    String password,
    String fullName,
    String role,
  );
  Future<void> signOut();
  Future<AuthUser?> getCurrentUser();
  Stream<AuthUser?> get authStateChanges;
  Future<void> resetPassword(String email);
}