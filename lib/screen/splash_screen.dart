// ignore_for_file: depend_on_referenced_packages

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();

    // الانتقال التلقائي بعد 3 ثواني
    Timer(const Duration(seconds: 3), () {
      Navigator.pushReplacementNamed(context, '/onboarding');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFFFFF),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // شعار أو أيقونة
            Image.asset(
              'assets/images/splash_logo.jpg',
              width: 300,
              height: 300,
            ),
            const SizedBox(height: 20),
            // اسم التطبيق
            Text(
              "إعادة إعمار",
              style: GoogleFonts.cairo(
                textStyle: const TextStyle(
                  fontSize: 28,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 10),
            Text(
              "Rebuild App",
              style: GoogleFonts.poppins(
                textStyle: const TextStyle(fontSize: 16, color: Colors.white70),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
