// ignore_for_file: use_build_context_synchronously

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:store/widget/custom_btn.dart';
import 'package:store/widget/custom_textfeld.dart';

class WidgetRgister extends StatefulWidget {
  const WidgetRgister({super.key});

  @override
  State<WidgetRgister> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<WidgetRgister> {
  final _formKey = GlobalKey<FormState>();

  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();
  final addressController = TextEditingController();
  final emailController = TextEditingController();
  final phoneController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  bool showPassword = false;
  bool showConfirmPassword = false;

  bool get isPasswordMatch =>
      passwordController.text == confirmPasswordController.text;

  Color getIconColor(String text) {
    return text.trim().isEmpty ? Colors.grey : Colors.green;
  }

  void showSnack(String message, {Color color = Colors.red}) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message), backgroundColor: color));
  }

  void showLoading() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => const Center(child: CircularProgressIndicator()),
    );
  }

  void hideLoading() => Navigator.of(context, rootNavigator: true).pop();

  Future<void> registerUser() async {
    if (!_formKey.currentState!.validate()) return;

    final email = emailController.text.trim();
    final password = passwordController.text.trim();

    if (!RegExp(r'^[\w-\.]+@gmail\.com$').hasMatch(email)) {
      showSnack("Please enter a valid Gmail address");
      return;
    }

    if (!isPasswordMatch) {
      showSnack("Passwords do not match");
      return;
    }

    try {
      showLoading();

      final userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);

      final uid = userCredential.user!.uid;

      final userData = {
        'uid': uid,
        'firstName': firstNameController.text.trim(),
        'lastName': lastNameController.text.trim(),
        'email': email,
        'phone': phoneController.text.trim(),
        'address': addressController.text.trim(),
        'createdAt': Timestamp.now(),
      };

      await FirebaseFirestore.instance
          .collection('users')
          .doc(uid)
          .set(userData);

      hideLoading();

      showSnack("✅ Registration successful", color: Colors.green);

      Navigator.pushReplacementNamed(context, '/home', arguments: userData);
    } on FirebaseAuthException catch (e) {
      hideLoading();
      final msg = e.code == 'email-already-in-use'
          ? 'This email is already registered'
          : e.message ?? 'Registration error';
      showSnack(msg);
    }
  }

  @override
  void dispose() {
    firstNameController.dispose();
    lastNameController.dispose();
    addressController.dispose();
    emailController.dispose();
    phoneController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        elevation: 10,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                const Icon(
                  Icons.person_add_alt_1,
                  size: 70,
                  color: Color(0xFF2C688E),
                ),
                const SizedBox(height: 10),
                const Text(
                  'Create Account',
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 20),

                CustomTextField(
                  controller: firstNameController,
                  hintext: 'Enter your first name',
                  labeltext: 'First Name',
                  suffixIcon: Icon(
                    Icons.check_circle,
                    color: getIconColor(firstNameController.text),
                  ),
                ),
                const SizedBox(height: 15),

                CustomTextField(
                  controller: lastNameController,
                  hintext: 'Enter your last name',
                  labeltext: 'Last Name',
                  suffixIcon: Icon(
                    Icons.check_circle,
                    color: getIconColor(lastNameController.text),
                  ),
                ),
                const SizedBox(height: 15),

                CustomTextField(
                  controller: addressController,
                  hintext: 'Enter your address',
                  labeltext: 'Address',
                  suffixIcon: Icon(
                    Icons.check_circle,
                    color: getIconColor(addressController.text),
                  ),
                ),
                const SizedBox(height: 15),

                CustomTextField(
                  controller: emailController,
                  hintext: 'Enter your email',
                  labeltext: 'Email',
                  keyboardType: TextInputType.emailAddress,
                  suffixIcon: Icon(
                    Icons.check_circle,
                    color: getIconColor(emailController.text),
                  ),
                ),
                const SizedBox(height: 15),

                CustomTextField(
                  controller: phoneController,
                  hintext: 'Enter your phone number',
                  labeltext: 'Phone Number',
                  keyboardType: TextInputType.phone,
                  suffixIcon: Icon(
                    Icons.check_circle,
                    color: getIconColor(phoneController.text),
                  ),
                ),
                const SizedBox(height: 15),

                CustomTextField(
                  controller: passwordController,
                  hintext: 'Enter your password',
                  labeltext: 'Password',
                  obscureText: !showPassword,
                  suffixIcon: IconButton(
                    icon: Icon(
                      showPassword ? Icons.visibility : Icons.visibility_off,
                      color: getIconColor(passwordController.text),
                    ),
                    onPressed: () =>
                        setState(() => showPassword = !showPassword),
                  ),
                ),
                const SizedBox(height: 15),

                CustomTextField(
                  controller: confirmPasswordController,
                  hintext: 'Confirm your password',
                  labeltext: 'Confirm Password',
                  obscureText: !showConfirmPassword,
                  suffixIcon: IconButton(
                    icon: Icon(
                      showConfirmPassword
                          ? Icons.visibility
                          : Icons.visibility_off,
                      color: isPasswordMatch ? Colors.green : Colors.red,
                    ),
                    onPressed: () => setState(
                      () => showConfirmPassword = !showConfirmPassword,
                    ),
                  ),
                ),
                const SizedBox(height: 25),

                CustomBtn(
                  textbtn: 'Register',
                  onPressed: (_) => registerUser(),
                  data: const {},
                ),

                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text('Already have an account?'),
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text(
                        'Login',
                        style: TextStyle(
                          color: Color(0xFF14A0E6),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
