import 'package:equatable/equatable.dart';

class AuthUser extends Equatable {
  final String id;
  final String email;
  final String? fullName;
  final String? phoneNumber;
  final String? address;
  final String? role;
  final bool isEmailVerified;

  const AuthUser({
    required this.id,
    required this.email,
    this.fullName,
    this.phoneNumber,
    this.address,
    this.role,
    this.isEmailVerified = false,
  });

  @override
  List<Object?> get props => [
        id,
        email,
        fullName,
        phoneNumber,
        address,
        role,
        isEmailVerified,
      ];

  AuthUser copyWith({
    String? id,
    String? email,
    String? fullName,
    String? phoneNumber,
    String? address,
    String? role,
    bool? isEmailVerified,
  }) {
    return AuthUser(
      id: id ?? this.id,
      email: email ?? this.email,
      fullName: fullName ?? this.fullName,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      address: address ?? this.address,
      role: role ?? this.role,
      isEmailVerified: isEmailVerified ?? this.isEmailVerified,
    );
  }
}