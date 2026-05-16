import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:store/features/auth/data/models/user_model.dart';

abstract class AuthRemoteDataSource {
  Future<UserModel> login(String email, String password);
  Future<UserModel> register(String email, String password, String firstName, String lastName);
  Future<void> logout();
  Future<UserModel?> getCurrentUser();
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final FirebaseAuth firebaseAuth;
  final FirebaseFirestore firestore;
  final SharedPreferences sharedPreferences;

  AuthRemoteDataSourceImpl(this.firebaseAuth, this.firestore, this.sharedPreferences);

  @override
  Future<UserModel> login(String email, String password) async {
    final credential = await firebaseAuth.signInWithEmailAndPassword(email: email, password: password);
    final userDoc = await firestore.collection('users').doc(credential.user!.uid).get();

    // Simulate JWT token persistence
    final token = await credential.user!.getIdToken();
    if (token != null) {
      await sharedPreferences.setString('jwt_token', token);
    }

    return UserModel.fromFirestore(userDoc.data()!, credential.user!.uid);
  }

  @override
  Future<UserModel> register(String email, String password, String firstName, String lastName) async {
    final credential = await firebaseAuth.createUserWithEmailAndPassword(email: email, password: password);
    final userModel = UserModel(
      id: credential.user!.uid,
      email: email,
      firstName: firstName,
      lastName: lastName,
    );
    await firestore.collection('users').doc(credential.user!.uid).set(userModel.toJson());

    // Simulate JWT token persistence
    final token = await credential.user!.getIdToken();
    if (token != null) {
      await sharedPreferences.setString('jwt_token', token);
    }

    return userModel;
  }

  @override
  Future<void> logout() async {
    await firebaseAuth.signOut();
    await sharedPreferences.remove('jwt_token');
  }

  @override
  Future<UserModel?> getCurrentUser() async {
    final user = firebaseAuth.currentUser;
    if (user != null) {
      final userDoc = await firestore.collection('users').doc(user.uid).get();
      if (userDoc.exists) {
        return UserModel.fromFirestore(userDoc.data()!, user.uid);
      }
    }
    return null;
  }
}
