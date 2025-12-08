// login_card.dart.dart
// ignore_for_file: use_build_context_synchronously

import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rebuild/Cubits/Login-Cubit/Auth Cubit Dart.dart';
import 'package:rebuild/Widgets/Login widget/AuthInputField.dart';
import 'package:rebuild/Widgets/SignUp%20Widget/auth_action_button.dart';
import 'package:rebuild/utils/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginCard extends StatefulWidget {
  const LoginCard({super.key});

  @override
  State<LoginCard> createState() => _LoginCardState();
}

class _LoginCardState extends State<LoginCard> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  bool rememberMe = false;
  bool showPassword = false;
  bool isSubmitting = false;

  Future<void> _login() async {
    if (isSubmitting) return;
    setState(() => isSubmitting = true);

    final email = emailController.text.trim();
    final password = passwordController.text.trim();

    // ✅ VALIDATION
    final emailRegex = RegExp(r'^[\w.+-]+@gmail\.com$');
    if (!emailRegex.hasMatch(email)) {
      warningMessage(context, "البريد الإلكتروني يجب أن يكون gmail.com@");
      return _stop();
    }

    if (password.length < 7) {
      warningMessage(context, "كلمة المرور لا يمكن أن تكون أقل من 7 أحرف");
      return _stop();
    }

    final cubit = context.read<AuthCubit>();

    try {
      await cubit.login(email, password);

      final token = cubit.state.token;
      final user = cubit.state.user;

      if (token == null || user == null) {
        warningMessage(context, "فشل تسجيل الدخول");
        return _stop();
      }

      // ✅ SAVE TOKEN إذا Remember Me
      if (rememberMe) {
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('auth_token', token);
        await prefs.setBool('remember_me', true);
        await prefs.setString('user_role', user['role'] ?? 'User');
      }

      // ✅ NAVIGATION
      final role = user['role'] ?? 'User';
      if (role == 'Admin' || role == 'SuperAdmin') {
        Navigator.pushReplacementNamed(context, '/admin-dashboard');
      } else {
        Navigator.pushReplacementNamed(context, '/home');
      }
    } finally {
      _stop();
    }
  }

  void _stop() {
    if (mounted) {
      setState(() => isSubmitting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(28),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 16, sigmaY: 16),
              child: Container(
                constraints: const BoxConstraints(maxWidth: 420),
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.95),
                  borderRadius: BorderRadius.circular(28),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Center(
                      child: Column(
                        children: [
                          const Icon(
                            Icons.construction_rounded,
                            size: 56,
                            color: AppColors.primaryDark,
                          ),
                          const SizedBox(height: 12),
                          Text(
                            "تسجيل الدخول",
                            style: Theme.of(context).textTheme.headlineSmall,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),

                    AuthInputField(
                      icon: Icons.email_outlined,
                      hint: "البريد الإلكتروني",
                      controller: emailController,
                    ),

                    AuthInputField(
                      icon: Icons.lock_outline,
                      hint: "كلمة المرور",
                      controller: passwordController,
                      obscure: !showPassword,
                      suffixIcon: IconButton(
                        icon: Icon(
                          showPassword
                              ? Icons.visibility
                              : Icons.visibility_off,
                        ),
                        onPressed: () =>
                            setState(() => showPassword = !showPassword),
                      ),
                    ),

                    Row(
                      children: [
                        Checkbox(
                          value: rememberMe,
                          onChanged: (v) =>
                              setState(() => rememberMe = v ?? false),
                        ),
                        const Text("تذكرني"),
                      ],
                    ),

                    const SizedBox(height: 16),

                    AuthActionButton(
                      isLogin: true,
                      isLoading: isSubmitting,
                      onPressed: _login,
                    ),

                    const SizedBox(height: 14),

                    Center(
                      child: TextButton(
                        onPressed: () =>
                            Navigator.pushNamed(context, '/signup'),
                        child: const Text("إنشاء حساب جديد"),
                      ),
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
