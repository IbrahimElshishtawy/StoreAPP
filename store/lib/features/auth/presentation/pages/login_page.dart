import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:store/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:store/features/auth/presentation/bloc/auth_state.dart';
import 'package:store/features/auth/presentation/bloc/auth_event.dart';
import 'package:store/features/auth/presentation/widgets/login_form.dart';
import 'package:store/core/util/responsive_layout.dart';

class LoginPage extends StatelessWidget {
  static String id = 'loginPage';
  const LoginPage({super.key});

  void _show2FADialog(BuildContext context, String verificationId) {
    final codeController = TextEditingController();
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) => AlertDialog(
        title: const Text("أدخل رمز التحقق الثنائي"),
        content: TextField(
          controller: codeController,
          keyboardType: TextInputType.number,
          decoration: const InputDecoration(hintText: "123456"),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text("إلغاء"),
          ),
          ElevatedButton(
            onPressed: () {
              context.read<AuthBloc>().add(
                    VerifyTwoFactorCodeRequested(
                      verificationId,
                      codeController.text.trim(),
                    ),
                  );
              Navigator.pop(dialogContext);
            },
            child: const Text("تحقق"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: BlocListener<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is Authenticated) {
            Navigator.pushReplacementNamed(context, '/home');
          } else if (state is TwoFactorAuthRequired) {
            _show2FADialog(context, state.verificationId);
          } else if (state is AuthError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message), backgroundColor: Colors.red),
            );
          }
        },
        child: BlocBuilder<AuthBloc, AuthState>(
          builder: (context, state) {
            if (state is AuthLoading) {
              return const Center(child: CircularProgressIndicator());
            }
            return ResponsiveLayout(
              mobile: const WidgetLogin(),
              tablet: Center(
                child: SizedBox(
                  width: 500,
                  child: Card(
                    elevation: 4,
                    margin: const EdgeInsets.all(32),
                    child: const WidgetLogin(),
                  ),
                ),
              ),
              desktop: Center(
                child: SizedBox(
                  width: 600,
                  child: Card(
                    elevation: 8,
                    margin: const EdgeInsets.all(64),
                    child: const WidgetLogin(),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
