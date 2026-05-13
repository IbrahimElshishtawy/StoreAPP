import 'dart:math';

class TwoFactorAuthService {
  String? _currentCode;

  Future<String> generateCode() async {
    _currentCode = (Random().nextInt(900000) + 100000).toString();
    print("2FA Code Generated: $_currentCode");
    return _currentCode!;
  }

  bool verifyCode(String code) {
    return _currentCode == code;
  }
}
