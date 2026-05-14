import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:store/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:store/features/auth/presentation/bloc/auth_event.dart';
import 'package:store/features/auth/presentation/pages/forgot_pass.dart';
import 'package:store/presentation/widgets/custom_button.dart';
import 'package:store/presentation/widgets/custom_textfield.dart';

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
  Timer? debounceTimer;

  @override
  void initState() {
    super.initState();
    emailController.addListener(validateEmailDebounced);
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
      final valid = RegExp(r'^[\w-\.]+@[\w-]+\.[a-z]{2,4}$').hasMatch(email);
      isEmailValid.value = valid;
    });
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
            builder: (context, valid, child) {
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
                Navigator.push(
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
          CustomBtn(
            textbtn: 'Login',
            onPressed: (_) async {
              context.read<AuthBloc>().add(
                LoginRequested(
                  emailController.text.trim(),
                  passwordController.text.trim(),
                ),
              );
            },
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
