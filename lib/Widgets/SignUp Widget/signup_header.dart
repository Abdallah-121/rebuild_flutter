import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:rebuild/utils/constants.dart';

class SignupHeader extends StatelessWidget {
  const SignupHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        CircleAvatar(
          radius: 22,
          backgroundColor: AppColors.primary.withOpacity(0.1),
          child: const Icon(Icons.person_add, size: 26),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                "إنشاء حساب جديد",
                style: GoogleFonts.cairo(
                  fontSize: 22,
                  fontWeight: FontWeight.w800,
                ),
              ),
              Text(
                "انضم إلى منصة إعادة الإعمار",
                style: GoogleFonts.cairo(fontSize: 13),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
