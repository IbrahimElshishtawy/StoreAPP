abstract class AuthEvent {}

class AuthCheckRequested extends AuthEvent {}

class LoginRequested extends AuthEvent {
  final String email;
  final String password;
  LoginRequested(this.email, this.password);
}

class RegisterRequested extends AuthEvent {
  final String email;
  final String password;
  final String firstName;
  final String lastName;
  RegisterRequested({
    required this.email,
    required this.password,
    required this.firstName,
    required this.lastName,
  });
}

class LogoutRequested extends AuthEvent {}

class TwoFactorAuthRequested extends AuthEvent {
  final String phoneNumber;
  TwoFactorAuthRequested(this.phoneNumber);
}

class VerifyTwoFactorCodeRequested extends AuthEvent {
  final String verificationId;
  final String smsCode;
  VerifyTwoFactorCodeRequested(this.verificationId, this.smsCode);
}
