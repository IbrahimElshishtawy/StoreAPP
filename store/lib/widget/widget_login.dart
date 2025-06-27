// ignore_for_file: use_build_context_synchronously, unnecessary_underscores, unused_local_variable

import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:store/screen/forgot_pass.dart';
import 'package:store/widget/custom_btn.dart';
import 'package:store/widget/custom_textfeld.dart';

class WidgetLogin extends StatefulWidget {
  const WidgetLogin({super.key});

  @override
  State<WidgetLogin> createState() => _WidgetLoginState();
}

class _WidgetLoginState extends State<WidgetLogin> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  final ValueNotifier<bool> isEmailValid = ValueNotifier(false);
  bool isPasswordVisible = false;
  bool isLoading = false;
  Timer? debounceTimer;

  @override
  void initState() {
    super.initState();
    emailController.addListener(validateEmailDebounced);
    loadSavedLogin();
  }

  @override
  void dispose() {
    emailController.removeListener(validateEmailDebounced);
    emailController.dispose();
    passwordController.dispose();
    debounceTimer?.cancel();
    isEmailValid.dispose();
    super.dispose();
  }

  void validateEmailDebounced() {
    if (debounceTimer?.isActive ?? false) debounceTimer!.cancel();
    debounceTimer = Timer(const Duration(milliseconds: 300), () {
      final email = emailController.text.trim();
      final valid = RegExp(r'^[\w-\.]+@gmail\.com$').hasMatch(email);
      isEmailValid.value = valid;
    });
  }

  Future<void> loadSavedLogin() async {
    final prefs = await SharedPreferences.getInstance();
    emailController.text = prefs.getString('saved_email') ?? '';
    passwordController.text = prefs.getString('saved_password') ?? '';
  }

  Future<void> loginUser() async {
    final email = emailController.text.trim();
    final password = passwordController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      showMessage('Please fill in all fields');
      return;
    }

    setState(() => isLoading = true);

    try {
      final authResult = await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      final user = authResult.user;
      if (user == null) throw Exception("User is null after sign in");

      final doc = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .get();

      if (!doc.exists || doc.data() == null) {
        await FirebaseAuth.instance.signOut();
        showMessage('User data not found');
        return;
      }

      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('saved_email', email);
      await prefs.setString('saved_password', password);

      if (!mounted) return;

      Navigator.pushReplacementNamed(context, '/home', arguments: doc.data());
    } on FirebaseAuthException catch (e) {
      String msg = switch (e.code) {
        'user-not-found' => 'Email is not registered',
        'wrong-password' => 'Incorrect password',
        'too-many-requests' => 'Too many login attempts. Try again later.',
        _ => e.message ?? 'Login failed',
      };

      showMessage(msg);
    } catch (_) {
      showMessage('Unexpected error occurred');
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

          ValueListenableBuilder<bool>(
            valueListenable: isEmailValid,
            builder: (_, valid, __) {
              return CustomTextField(
                controller: emailController,
                hintext: 'Enter your email',
                labeltext: 'Email',
                obscureText: false,
                suffixIcon: emailController.text.trim().isEmpty
                    ? const Icon(Icons.email_outlined, color: Colors.grey)
                    : Icon(
                        valid ? Icons.check_circle : Icons.cancel,
                        color: valid ? Colors.green : Colors.red,
                      ),
              );
            },
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

          const SizedBox(height: 10),
          Align(
            alignment: Alignment.centerRight,
            child: TextButton(
              onPressed: () {
                // في routes أو Navigator.push
                var push = Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const ForgetPasswordPage()),
                );
              },
              child: const Text(
                'Forgot Password?',
                style: TextStyle(color: Colors.blue),
              ),
            ),
          ),

          const SizedBox(height: 20),
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
