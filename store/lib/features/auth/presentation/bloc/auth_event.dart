import 'package:equatable/equatable.dart';

abstract class AuthEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class LoginRequested extends AuthEvent {
  final String email;
  final String password;
  LoginRequested(this.email, this.password);
  @override
  List<Object?> get props => [email, password];
}

class RegisterRequested extends AuthEvent {
  final String email;
  final String password;
  final String firstName;
  final String lastName;
  RegisterRequested(this.email, this.password, this.firstName, this.lastName);
  @override
  List<Object?> get props => [email, password, firstName, lastName];
}

class LogoutRequested extends AuthEvent {}

class AuthCheckRequested extends AuthEvent {}
