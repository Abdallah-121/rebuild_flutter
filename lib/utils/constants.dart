// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// 🎨 الألوان الأساسية لتطبيق إعادة إعمار
class AppColors {
  static const Color primary = Color(0xFF2F8F83); // Teal Green
  static const Color primaryDark = Color(0xFF1E6F68); // Deep Teal
  static const Color secondary = Color(0xFF4A6FA5); // Soft Indigo Blue
  static const Color accent = Color(0xFFE2B46D); // Muted Gold
  static const Color background = Color(0xFFF8FAF9); // Soft Off-White
  static const Color darkBackground = Color(0xFF121517); // Dark Mode BG
  static const Color textPrimary = Color(0xFF1F1F1F);
  static const Color textSecondary = Color(0xFF6A6A6A);
  static const Color greyLight = Color(0xFFE6E8E7);
  static const Color grey = Color(0xFF8A8F8D);
  static const Color greyDark = Color(0xFF4A4E4C);
  static const Color error = Color(0xFFE45858);
}

class AppTheme {
  static ThemeData lightTheme = ThemeData(
    brightness: Brightness.light,
    scaffoldBackgroundColor: AppColors.background,
    primaryColor: AppColors.primary,
    colorScheme: ColorScheme.light(
      primary: AppColors.primary,
      secondary: AppColors.secondary,
      background: AppColors.background,
    ),
    textTheme: const TextTheme(
      bodyLarge: TextStyle(
        fontSize: 16,
        color: AppColors.textPrimary,
        fontFamily: 'Cairo',
      ),
      bodyMedium: TextStyle(
        fontSize: 14,
        color: AppColors.textSecondary,
        fontFamily: 'Cairo',
      ),
      titleLarge: TextStyle(
        fontSize: 22,
        color: AppColors.primaryDark,
        fontWeight: FontWeight.bold,
        fontFamily: 'Cairo',
      ),
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: AppColors.primary,
      foregroundColor: Colors.white,
      elevation: 0,
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        padding: EdgeInsets.symmetric(horizontal: 28, vertical: 14),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      ),
    ),
  );

  static ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,
    scaffoldBackgroundColor: AppColors.darkBackground,
    primaryColor: AppColors.primaryDark,
    colorScheme: ColorScheme.dark(
      primary: AppColors.primaryDark,
      secondary: AppColors.accent,
      background: AppColors.darkBackground,
    ),
    textTheme: const TextTheme(
      bodyLarge: TextStyle(
        fontSize: 16,
        color: Colors.white,
        fontFamily: 'Cairo',
      ),
      bodyMedium: TextStyle(
        fontSize: 14,
        color: Colors.white70,
        fontFamily: 'Cairo',
      ),
      titleLarge: TextStyle(
        fontSize: 22,
        color: Colors.white,
        fontWeight: FontWeight.bold,
        fontFamily: 'Cairo',
      ),
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: AppColors.primaryDark,
      elevation: 0,
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.primaryDark,
        foregroundColor: Colors.white,
        padding: EdgeInsets.symmetric(horizontal: 28, vertical: 14),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      ),
    ),
  );
}

void warningMessage(BuildContext context, String message) {
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
}

Future<void> logout(BuildContext context) async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.remove('auth_token');
  await prefs.remove('remember_me');
  await prefs.remove('user_role');
  await prefs.remove('current_user'); // لو خزنت بيانات المستخدم كاملة

  // إعادة التوجيه لشاشة تسجيل الدخول ومسح كل الروترات السابقة
  Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);
}
