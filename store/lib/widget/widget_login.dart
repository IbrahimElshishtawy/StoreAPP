// ignore_for_file: curly_braces_in_flow_control_structures

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:store/widget/custom_btn.dart';
import 'package:store/widget/custom_textfeld.dart';

class WidgetLogin extends StatefulWidget {
  const WidgetLogin({super.key});

  @override
  State<WidgetLogin> createState() => _WidgetLoginState();
}

class _WidgetLoginState extends State<WidgetLogin> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  bool isPasswordVisible = false;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    loadSavedLogin();
  }

  Future<void> loadSavedLogin() async {
    final prefs = await SharedPreferences.getInstance();
    emailController.text = prefs.getString('saved_email') ?? '';
    passwordController.text = prefs.getString('saved_password') ?? '';
    // ignore: avoid_print
    print("📦 Loaded saved email: ${emailController.text}");
  }

  Future<void> loginUser() async {
    final email = emailController.text.trim();
    final password = passwordController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      showMessage('Please fill in all fields');
      return;
    }

    setState(() => isLoading = true);
    // ignore: avoid_print
    print("🔐 Attempting login for $email");

    try {
      final authResult = await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      final user = authResult.user;
      if (user == null) throw Exception("User is null after sign in");

      // ignore: avoid_print
      print("✅ Logged in. UID: ${user.uid}");

      final doc = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .get();

      if (!doc.exists || doc.data() == null) {
        await FirebaseAuth.instance.signOut();
        // ignore: avoid_print
        print("❌ Firestore document not found for UID: ${user.uid}");
        showMessage('User data not found in Firestore');
        return;
      }

      if (kDebugMode) {
        print("📄 Firestore data: ${doc.data()}");
      }

      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('saved_email', email);
      await prefs.setString('saved_password', password);
      if (kDebugMode) {
        print("💾 Saved credentials locally");
      }

      if (!mounted) return;

      Navigator.pushReplacementNamed(context, '/home', arguments: doc.data());
    } on FirebaseAuthException catch (e) {
      String msg = 'Login failed';
      if (e.code == 'user-not-found')
        msg = 'Email not registered';
      else if (e.code == 'wrong-password')
        msg = 'Incorrect password';
      else if (e.code == 'too-many-requests')
        msg = 'Too many login attempts. Try again later.';
      else
        msg = e.message ?? msg;

      // ignore: avoid_print
      print("⚠ FirebaseAuthException: ${e.code} → $msg");
      showMessage(msg);
    } catch (e) {
      // ignore: avoid_print
      print("❗ Unexpected error: $e");
      showMessage('Unexpected error: $e');
    } finally {
      if (mounted) setState(() => isLoading = false);
    }
  }

  void showMessage(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final emailText = emailController.text.trim();
    final isEmailValid = RegExp(r'^[\w-\.]+@gmail\.com$').hasMatch(emailText);

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 40),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          SizedBox(height: size.height * 0.12),
          Image.asset('assets/image/images.png', height: 150),
          const SizedBox(height: 24),
          const Text(
            'Welcome to Store App',
            style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          const Text('Please login to continue'),
          const SizedBox(height: 30),

          const Align(
            alignment: Alignment.centerLeft,
            child: Text('Email', style: TextStyle(fontWeight: FontWeight.w600)),
          ),
          const SizedBox(height: 8),

          CustomTextField(
            controller: emailController,
            hintext: 'Enter your email',
            labeltext: 'Email',
            obscureText: false,
            suffixIcon: emailText.isEmpty
                ? const Icon(Icons.email_outlined, color: Colors.grey)
                : Icon(
                    isEmailValid ? Icons.check_circle : Icons.cancel,
                    color: isEmailValid ? Colors.green : Colors.red,
                  ),
          ),

          const SizedBox(height: 20),
          const Align(
            alignment: Alignment.centerLeft,
            child: Text(
              'Password',
              style: TextStyle(fontWeight: FontWeight.w600),
            ),
          ),
          const SizedBox(height: 8),

          CustomTextField(
            controller: passwordController,
            hintext: 'Enter your password',
            labeltext: 'Password',
            obscureText: !isPasswordVisible,
            suffixIcon: IconButton(
              icon: Icon(
                isPasswordVisible ? Icons.visibility : Icons.visibility_off,
                color: Colors.grey,
              ),
              onPressed: () =>
                  setState(() => isPasswordVisible = !isPasswordVisible),
            ),
          ),

          const SizedBox(height: 30),

          isLoading
              ? const CircularProgressIndicator()
              : CustomBtn(
                  textbtn: 'Login',
                  onPressed: (_) => loginUser(),
                  data: const {},
                ),

          const SizedBox(height: 15),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text("Don't have an account?"),
              TextButton(
                onPressed: () => Navigator.pushNamed(context, '/register'),
                child: const Text(
                  'Sign Up',
                  style: TextStyle(
                    color: Color(0xFF2B9FD9),
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
