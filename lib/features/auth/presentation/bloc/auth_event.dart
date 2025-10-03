part of 'auth_bloc.dart';

abstract class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object> get props => [];
}

class CheckAuthStatus extends AuthEvent {
  const CheckAuthStatus();
}

class SignIn extends AuthEvent {
  final String email;
  final String password;

  const SignIn(this.email, this.password);

  @override
  List<Object> get props => [email, password];
}

class SignUp extends AuthEvent {
  final String email;
  final String password;
  final String fullName;
  final String role;

  const SignUp(this.email, this.password, this.fullName, this.role);

  @override
  List<Object> get props => [email, password, fullName, role];
}

class SignOut extends AuthEvent {
  const SignOut();
}

class ResetPassword extends AuthEvent {
  final String email;

  const ResetPassword(this.email);

  @override
  List<Object> get props => [email];
}