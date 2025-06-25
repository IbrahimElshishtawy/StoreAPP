// ignore_for_file: override_on_non_overriding_member, use_build_context_synchronously, sized_box_for_whitespace, avoid_print, unnecessary_import

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
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
  }

  @override
  void dispose() {
    for (var controller in controllers) {
      controller.removeListener(_listener);
      controller.dispose();
    }
    super.dispose();
  }

  void hideLoading(BuildContext context) {
    Navigator.of(context, rootNavigator: true).pop();
  }

  void showLoading(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => const Center(child: CircularProgressIndicator()),
    );
  }

  void showSnack(String message, {Color? backgroundColor}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: backgroundColor),
    );
  }

  Color getIconColor(String text) {
    return text.trim().isEmpty
        ? const Color.fromARGB(255, 150, 150, 150)
        : Colors.green;
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
                  mainAxisSize: MainAxisSize.min,
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

                    CustomTextField(
                      controller: passwordController,
                      hintext: 'Enter your password',
                      labeltext: 'Password',
                      obscureText: true,
                      suffixIcon: Icon(
                        Icons.check_circle,
                        color: getIconColor(passwordController.text),
                      ),
                    ),
                    const SizedBox(height: 15),

                    CustomTextField(
                      controller: confirmPasswordController,
                      hintext: 'Confirm your password',
                      labeltext: 'Confirm Password',
                      obscureText: true,
                      suffixIcon: Icon(
                        Icons.check_circle,
                        color: getIconColor(confirmPasswordController.text),
                      ),
                    ),
                    const SizedBox(height: 25),

                    CustomBtn(
                      textbtn: 'Register',
                      onPressed: (Map<String, dynamic> data) async {
                        if (!_formKey.currentState!.validate()) return;

                        final email = emailController.text.trim();
                        final password = passwordController.text.trim();
                        final confirmPassword = confirmPasswordController.text
                            .trim();
                        final firstName = firstNameController.text.trim();
                        final lastName = lastNameController.text.trim();
                        final address = addressController.text.trim();
                        final phone = phoneController.text.trim();

                        if ([
                          email,
                          password,
                          confirmPassword,
                          firstName,
                          lastName,
                          address,
                          phone,
                        ].any((e) => e.isEmpty)) {
                          showSnack('Please fill all fields');
                          return;
                        }

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
                                'firstName': firstName,
                                'lastName': lastName,
                                'email': email,
                                'phone': phone,
                                'address': address,
                                'createdAt': Timestamp.now(),
                              });

                          print('✅ بيانات المستخدم تم إرسالها إلى Firestore');
                          print('First Name: $firstName');
                          print('Last Name: $lastName');
                          print('Email: $email');
                          print('Phone: $phone');
                          print('Address: $address');
                          print('UID: $uid');

                          if (!mounted) return;
                          hideLoading(context);
                          showSnack(
                            'Registration successful!',
                            backgroundColor: Colors.green,
                          );

                          // الانتقال إلى صفحة HomePage بعد التسجيل
                          Navigator.pushReplacementNamed(
                            context,
                            '/home', // تأكد أن هذا هو اسم الـ route في main.dart
                            arguments: {
                              'uid': uid,
                              'firstName': firstName,
                              'lastName': lastName,
                              'email': email,
                              'phone': phone,
                              'address': address,
                            },
                          );
                          print('🔥🔥🔥 تم الحفظ في Firestore');
                          if (mounted) {
                            for (var controller in controllers) {
                              controller.clear();
                            }
                          }
                        } on FirebaseAuthException catch (e) {
                          hideLoading(context);
                          String message = 'Registration failed';
                          if (e.code == 'email-already-in-use') {
                            message = 'This email is already in use.';
                          } else if (e.code == 'weak-password') {
                            message = 'Password is too weak.';
                          } else if (e.code == 'invalid-email') {
                            message = 'Invalid email format.';
                          }
                          showSnack(message);
                        } catch (e) {
                          hideLoading(context);
                          showSnack('An error occurred. Please try again.');
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
