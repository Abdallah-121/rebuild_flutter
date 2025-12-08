// ignore_for_file: unused_field, use_build_context_synchronously, file_names

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:rebuild/Cubits/Login-Cubit/Auth Cubit Dart.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RootScreen extends StatefulWidget {
  const RootScreen({super.key});

  @override
  State<RootScreen> createState() => _RootScreenState();
}

class _RootScreenState extends State<RootScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 2), _navigateNextSafe);
  }

  Future<void> _navigateNextSafe() async {
    try {
      await navigateNext();
    } catch (e) {
      if (!mounted) return;
      Navigator.pushReplacementNamed(context, '/login');
    }
  }

  Future<void> navigateNext() async {
    final prefs = await SharedPreferences.getInstance();
    final seenOnboarding = prefs.getBool('seenOnboarding') ?? false;
    final rememberMe = prefs.getBool('remember_me') ?? false;

    if (!seenOnboarding) {
      if (!mounted) return;
      Navigator.pushReplacementNamed(context, '/onboarding');
      return;
    }

    if (rememberMe) {
      final authCubit = context.read<AuthCubit>();

      // 🔹 نحاول نعمل ريفرش للـ token
      final ok = await authCubit.refreshTokenIfNeeded();
      if (!ok) {
        // الريفريش فشل → نمسح تذكّرني و نروح لوجين
        await prefs.remove('remember_me');
        await prefs.remove('user_role');
        if (!mounted) return;
        Navigator.pushReplacementNamed(context, '/login');
        return;
      }

      // 🔹 جلب بيانات المستخدم
      await authCubit.loadCurrentUser();
      final user = authCubit.state.user;

      if (user != null) {
        if (!mounted) return;

        final role = user['role'];
        if (role == 'Admin' || role == 'SuperAdmin') {
          Navigator.pushReplacementNamed(context, '/admin-dashboard');
        } else {
          Navigator.pushReplacementNamed(context, '/home');
        }
        return;
      }
    }

    if (!mounted) return;
    Navigator.pushReplacementNamed(context, '/login');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.white,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                'assets/images/splash_logo.jpg',
                width: 200,
                height: 200,
              ),
              const SizedBox(height: 20),
              Text(
                "إعادة إعمار",
                style: GoogleFonts.cairo(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF2E7D32),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
