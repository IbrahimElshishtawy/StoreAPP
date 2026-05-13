import 'package:firebase_messaging/firebase_messaging.dart';

class PushNotificationService {
  final FirebaseMessaging _fcm = FirebaseMessaging.instance;

  Future<void> initialize() async {
    await _fcm.requestPermission();

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      // Handle foreground message
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      // Handle app opened from notification
    });
  }

  Future<String?> getToken() async {
    return await _fcm.getToken();
  }
}
