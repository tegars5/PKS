import 'package:supabase_flutter/supabase_flutter.dart' as supabase;

import '../../domain/entities/auth_user.dart';
import '../../domain/repositories/auth_repository.dart';
import '../../../../core/exceptions/app_exceptions.dart';
import '../../../../core/constants.dart';

class AuthRepositoryImpl implements AuthRepository {
  final supabase.SupabaseClient _supabaseClient;

  AuthRepositoryImpl(this._supabaseClient);

  @override
  Future<AuthUser?> signInWithEmailPassword(
    String email,
    String password,
  ) async {
    try {
      print('=== LOGIN DEBUG START ===');
      print('Attempting login for email: $email');
      
      final response = await _supabaseClient.auth.signInWithPassword(
        email: email,
        password: password,
      );

      print('Login response received');
      print('User exists: ${response.user != null}');
      
      if (response.user != null) {
        print('User ID: ${response.user!.id}');
        print('User email: ${response.user!.email}');
        print('User metadata: ${response.user!.userMetadata}');
        print('User email confirmed: ${response.user!.emailConfirmedAt}');
        
        final user = AuthUser(
          id: response.user!.id,
          email: response.user!.email ?? '',
          fullName: response.user!.userMetadata?['full_name'],
          role: response.user!.userMetadata?['role'],
          isEmailVerified: response.user!.emailConfirmedAt != null,
        );
        
        print('AuthUser created successfully');
        print('User role: ${user.role}');
        print('=== LOGIN DEBUG END ===');
        return user;
      } else {
        print('Login failed: User is null');
        print('=== LOGIN DEBUG END ===');
        throw const AuthenticationException(
          'Login failed. Please check your credentials.',
        );
      }
    } on supabase.AuthException catch (e) {
      print('AuthException during login: ${e.message}');
      print('=== LOGIN DEBUG END ===');
      throw AuthenticationException(e.message);
    } catch (e) {
      print('Unexpected error during login: $e');
      print('Error type: ${e.runtimeType}');
      print('=== LOGIN DEBUG END ===');
      throw ServerException('An unexpected error occurred: $e');
    }
  }

  @override
  Future<AuthUser?> signUpWithEmailPassword(
    String email,
    String password,
    String fullName,
    String role,
  ) async {
    try {
      print('=== REGISTRATION DEBUG START ===');
      print('Starting registration for email: $email, role: $role, name: $fullName');
      print('Supabase URL: ${AppConstants.supabaseUrl}');
      
      final response = await _supabaseClient.auth.signUp(
        email: email,
        password: password,
        data: {
          'full_name': fullName,
          'role': role,
        },
        emailRedirectTo: null, // Disable email confirmation for now
      );

      print('Response received: ${response.user != null ? "SUCCESS" : "FAILED"}');
      
      if (response.user != null) {
        print('User created successfully: ${response.user!.id}');
        print('User email: ${response.user!.email}');
        print('User metadata: ${response.user!.userMetadata}');
        
        // Wait a moment for the trigger to create the profile
        await Future.delayed(const Duration(seconds: 1));
        
        // Manually create profile entry to ensure it exists
        try {
          print('Attempting to create profile manually...');
          final profileResult = await _supabaseClient.from('profiles').upsert({
            'id': response.user!.id,
            'full_name': fullName,
            'email': email,
            'role': role,
            'updated_at': DateTime.now().toIso8601String(),
          }).select();
          print('Profile created/updated successfully: $profileResult');
        } catch (profileError) {
          print('Error creating profile: $profileError');
          print('Profile error type: ${profileError.runtimeType}');
          // Don't throw here as the trigger should handle it
        }
        
        // Verify profile was created
        try {
          final profileCheck = await _supabaseClient
              .from('profiles')
              .select()
              .eq('id', response.user!.id)
              .single();
          print('Profile verification successful: $profileCheck');
        } catch (checkError) {
          print('Profile verification failed: $checkError');
        }
        
        final user = AuthUser(
          id: response.user!.id,
          email: response.user!.email ?? '',
          fullName: fullName,
          role: role,
          isEmailVerified: true, // Set to true since we're bypassing email verification
        );
        print('=== REGISTRATION DEBUG END ===');
        return user;
      } else {
        print('Registration failed: User is null');
        throw const AuthenticationException(
          'Registration failed. Please try again.',
        );
      }
    } on supabase.AuthException catch (e) {
      print('AuthException during registration: ${e.message}');
      print('AuthException details: ${e.toString()}');
      print('=== REGISTRATION DEBUG END ===');
      throw AuthenticationException(e.message);
    } catch (e) {
      print('Unexpected error during registration: $e');
      print('Error type: ${e.runtimeType}');
      print('=== REGISTRATION DEBUG END ===');
      throw ServerException('An unexpected error occurred: $e');
    }
  }

  @override
  Future<void> signOut() async {
    try {
      await _supabaseClient.auth.signOut();
    } on supabase.AuthException catch (e) {
      throw AuthenticationException(e.message);
    } catch (e) {
      throw ServerException('An unexpected error occurred: $e');
    }
  }

  @override
  Future<AuthUser?> getCurrentUser() async {
    try {
      final currentUser = _supabaseClient.auth.currentUser;
      
      if (currentUser != null) {
        final user = AuthUser(
          id: currentUser.id,
          email: currentUser.email ?? '',
          fullName: currentUser.userMetadata?['full_name'],
          role: currentUser.userMetadata?['role'],
          isEmailVerified: currentUser.emailConfirmedAt != null,
        );
        return user;
      } else {
        return null;
      }
    } catch (e) {
      throw ServerException('An unexpected error occurred: $e');
    }
  }

  @override
  Stream<AuthUser?> get authStateChanges {
    return _supabaseClient.auth.onAuthStateChange
        .map((data) => data.session?.user)
        .map((user) {
      if (user != null) {
        return AuthUser(
          id: user.id,
          email: user.email ?? '',
          fullName: user.userMetadata?['full_name'],
          role: user.userMetadata?['role'],
          isEmailVerified: user.emailConfirmedAt != null,
        );
      }
      return null;
    });
  }

  @override
  Future<void> resetPassword(String email) async {
    try {
      await _supabaseClient.auth.resetPasswordForEmail(email);
    } on supabase.AuthException catch (e) {
      throw AuthenticationException(e.message);
    } catch (e) {
      throw ServerException('An unexpected error occurred: $e');
    }
  }
}