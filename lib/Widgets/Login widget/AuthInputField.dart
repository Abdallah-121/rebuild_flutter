import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../utils/constants.dart';

class AuthInputField extends StatelessWidget {
  final IconData icon;
  final String hint;
  final TextEditingController controller;
  final bool obscure;
  final Widget? suffixIcon;

  const AuthInputField({
    super.key,
    required this.icon,
    required this.hint,
    required this.controller,
    this.obscure = false,
    this.suffixIcon,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: TextField(
        controller: controller,
        obscureText: obscure,
        textDirection: TextDirection.rtl,
        style: GoogleFonts.cairo(color: AppColors.textPrimary, fontSize: 14),
        decoration: InputDecoration(
          prefixIcon: Icon(icon, color: AppColors.primaryDark),
          suffixIcon: suffixIcon,
          hintText: hint,
          hintStyle: GoogleFonts.cairo(
            color: Colors.grey.shade600,
            fontSize: 14,
          ),

          // ✅ أهم 3 أسطر
          filled: true,
          fillColor: Colors.white,

          contentPadding: const EdgeInsets.symmetric(
            horizontal: 14,
            vertical: 14,
          ),

          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide(color: Colors.grey.shade300),
          ),

          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide(color: Colors.grey.shade300),
          ),

          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: const BorderSide(
              color: AppColors.primaryDark,
              width: 1.3,
            ),
          ),
        ),
      ),
    );
  }
}
