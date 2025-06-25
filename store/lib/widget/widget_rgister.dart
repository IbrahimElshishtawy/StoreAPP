// ignore_for_file: override_on_non_overriding_member, use_build_context_synchronously, sized_box_for_whitespace, avoid_print

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
  bool isPasswordMatch = true;

  late final List<TextEditingController> controllers = [
    firstNameController,
    lastNameController,
    addressController,
    emailController,
    phoneController,
    passwordController,
    confirmPasswordController,
  ];

  late final VoidCallback _listener;

  @override
  void initState() {
    super.initState();

    _listener = () {
      if (mounted) setState(() {});
    };

    for (var controller in controllers) {
      controller.addListener(_listener);
    }

    confirmPasswordController.addListener(checkPasswordMatch);
    passwordController.addListener(checkPasswordMatch);
  }

  void checkPasswordMatch() {
    setState(() {
      isPasswordMatch =
          passwordController.text == confirmPasswordController.text;
    });
  }

  @override
  void dispose() {
    for (var controller in controllers) {
      controller.removeListener(_listener);
      controller.dispose();
    }
    super.dispose();
  }

  void showSnack(String message, {Color? backgroundColor}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: backgroundColor),
    );
  }

  void showLoading(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => const Center(child: CircularProgressIndicator()),
    );
  }

  void hideLoading(BuildContext context) {
    Navigator.of(context, rootNavigator: true).pop();
  }

  Color getIconColor(String text) {
    return text.trim().isEmpty ? Colors.grey : Colors.green;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      child: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
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
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 20),

                    // frist name
                    CustomTextField(
                      controller: firstNameController,
                      hintext: 'Enter your first name',
                      labeltext: 'First Name',
                      obscureText: false,
                      suffixIcon: Icon(
                        Icons.check_circle,
                        color: getIconColor(firstNameController.text),
                      ),
                    ),
                    const SizedBox(height: 15),

                    // last name
                    CustomTextField(
                      controller: lastNameController,
                      hintext: 'Enter your last name',
                      labeltext: 'Last Name',
                      obscureText: false,
                      suffixIcon: Icon(
                        Icons.check_circle,
                        color: getIconColor(lastNameController.text),
                      ),
                    ),
                    const SizedBox(height: 15),

                    // address
                    CustomTextField(
                      controller: addressController,
                      hintext: 'Enter your address',
                      labeltext: 'Address',
                      obscureText: false,
                      suffixIcon: Icon(
                        Icons.check_circle,
                        color: getIconColor(addressController.text),
                      ),
                    ),
                    const SizedBox(height: 15),

                    // Email
                    CustomTextField(
                      controller: emailController,
                      hintext: 'Enter your email',
                      labeltext: 'Email',
                      obscureText: false,
                      suffixIcon: Icon(
                        Icons.check_circle,
                        color: getIconColor(emailController.text),
                      ),
                    ),
                    const SizedBox(height: 15),

                    // phone number
                    CustomTextField(
                      controller: phoneController,
                      hintext: 'Enter your phone number',
                      labeltext: 'Phone Number',
                      obscureText: false,
                      suffixIcon: Icon(
                        Icons.check_circle,
                        color: getIconColor(phoneController.text),
                      ),
                    ),
                    const SizedBox(height: 15),

                    // password
                    CustomTextField(
                      controller: passwordController,
                      hintext: 'Enter your password',
                      labeltext: 'Password',
                      obscureText: !showPassword,
                      suffixIcon: IconButton(
                        icon: Icon(
                          showPassword
                              ? Icons.visibility
                              : Icons.visibility_off,
                          color: getIconColor(passwordController.text),
                        ),
                        onPressed: () =>
                            setState(() => showPassword = !showPassword),
                      ),
                    ),
                    const SizedBox(height: 15),

                    // confirm password
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
                          color: isPasswordMatch
                              ? Colors.green
                              : Colors.redAccent,
                        ),
                        onPressed: () => setState(
                          () => showConfirmPassword = !showConfirmPassword,
                        ),
                      ),
                    ),
                    const SizedBox(height: 25),

                    // Register
                    CustomBtn(
                      textbtn: 'Register',
                      onPressed: (Map<String, dynamic> data) async {
                        if (!_formKey.currentState!.validate()) return;

                        final email = emailController.text.trim();
                        final password = passwordController.text.trim();
                        final confirmPassword = confirmPasswordController.text
                            .trim();

                        if (password != confirmPassword) {
                          showSnack('Passwords do not match');
                          return;
                        }

                        try {
                          showLoading(context);

                          final userCredential = await FirebaseAuth.instance
                              .createUserWithEmailAndPassword(
                                email: email,
                                password: password,
                              );

                          final uid = userCredential.user!.uid;

                          await FirebaseFirestore.instance
                              .collection('users')
                              .doc(uid)
                              .set({
                                'uid': uid,
                                'firstName': firstNameController.text.trim(),
                                'lastName': lastNameController.text.trim(),
                                'email': email,
                                'phone': phoneController.text.trim(),
                                'address': addressController.text.trim(),
                                'createdAt': Timestamp.now(),
                              });

                          hideLoading(context);
                          showSnack(
                            "Registration successful",
                            backgroundColor: Colors.green,
                          );

                          Navigator.pushReplacementNamed(
                            context,
                            '/home',
                            arguments: {
                              'uid': uid,
                              'firstName': firstNameController.text.trim(),
                              'lastName': lastNameController.text.trim(),
                              'email': email,
                              'phone': phoneController.text.trim(),
                              'address': addressController.text.trim(),
                            },
                          );

                          if (mounted) {
                            for (var controller in controllers) {
                              controller.clear();
                            }
                          }
                        } on FirebaseAuthException catch (e) {
                          hideLoading(context);
                          showSnack(
                            e.code == 'email-already-in-use'
                                ? 'Email already in use'
                                : 'Registration error: ${e.message}',
                            backgroundColor: Colors.red,
                          );
                        }
                      },
                      data: {},
                    ),

                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          'Already have an account?',
                          style: TextStyle(fontSize: 15),
                        ),
                        TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: const Text(
                            'Login',
                            style: TextStyle(
                              color: Color(0xFF14A0E6),
                              fontSize: 15,
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
        ),
      ),
    );
  }
}
