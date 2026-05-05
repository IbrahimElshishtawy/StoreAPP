import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

/// -----------------------------------------------
/// Fake / Demo Users Seeder
/// استخدم الدالة دي مرة واحدة بس لإنشاء البيانات
/// -----------------------------------------------
class FakeUserSeeder {
  static final _auth = FirebaseAuth.instance;
  static final _firestore = FirebaseFirestore.instance;

  /// بيانات المستخدمين الوهميين
  static const List<Map<String, String>> _fakeUsers = [
    {
      'email': 'user@store.com',
      'password': 'User@1234',
      'firstName': 'Ahmed',
      'lastName': 'Hassan',
      'phoneNumber': '+201001234567',
    },
    {
      'email': 'seller@store.com',
      'password': 'Seller@1234',
      'firstName': 'Mohamed',
      'lastName': 'Ali',
      'phoneNumber': '+201009876543',
    },
    {
      'email': 'admin@store.com',
      'password': 'Admin@1234',
      'firstName': 'Sara',
      'lastName': 'Khaled',
      'phoneNumber': '+201112223334',
    },
  ];

  /// شغّل الدالة دي مرة واحدة لإنشاء المستخدمين الوهميين
  static Future<void> seedUsers() async {
    for (final userData in _fakeUsers) {
      try {
        // إنشاء المستخدم في Firebase Auth
        final credential = await _auth.createUserWithEmailAndPassword(
          email: userData['email']!,
          password: userData['password']!,
        );

        final uid = credential.user!.uid;

        // حفظ بيانات المستخدم في Firestore
        await _firestore.collection('users').doc(uid).set({
          'email': userData['email'],
          'firstName': userData['firstName'],
          'lastName': userData['lastName'],
          'phoneNumber': userData['phoneNumber'],
          'imageUrl': null,
          'createdAt': FieldValue.serverTimestamp(),
        });

        // تسجيل الخروج بعد كل مستخدم
        await _auth.signOut();

        print('✅ تم إنشاء المستخدم: ${userData['email']}');
      } on FirebaseAuthException catch (e) {
        if (e.code == 'email-already-in-use') {
          print('⚠️ المستخدم موجود مسبقاً: ${userData['email']}');
        } else {
          print('❌ خطأ عند إنشاء ${userData['email']}: ${e.message}');
        }
      } catch (e) {
        print('❌ خطأ غير متوقع: $e');
      }
    }

    print('\n--- بيانات تسجيل الدخول ---');
    for (final u in _fakeUsers) {
      print('👤 ${u['firstName']} ${u['lastName']}');
      print('   Email:    ${u['email']}');
      print('   Password: ${u['password']}');
      print('');
    }
  }
}
