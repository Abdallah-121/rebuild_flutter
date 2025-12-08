import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:rebuild/utils/constants.dart';

class LoginHeader extends StatelessWidget {
  const LoginHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        CircleAvatar(
          radius: 22,
          backgroundColor: AppColors.primary.withOpacity(0.1),
          child: const Icon(
            Icons.lock_outline,
            color: AppColors.primaryDark,
            size: 26,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                "تسجيل الدخول",
                style: GoogleFonts.cairo(
                  fontSize: 22,
                  fontWeight: FontWeight.w800,
                ),
              ),
              Text(
                "منصة إعادة الإعمار – حساب المستخدم",
                style: GoogleFonts.cairo(
                  fontSize: 13,
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
