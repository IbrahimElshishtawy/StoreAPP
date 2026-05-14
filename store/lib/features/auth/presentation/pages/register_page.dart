// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:store/features/auth/presentation/widgets/register_form.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(body: WidgetRgister());
  }
}
