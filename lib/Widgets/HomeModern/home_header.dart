import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:rebuild/utils/constants.dart';

class HomeHeader extends StatelessWidget {
  final String? name;

  const HomeHeader({super.key, this.name});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                "مرحباً، ${name ?? 'ضيف'}",
                style: GoogleFonts.cairo(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  color: AppColors.primaryDark,
                ),
                textAlign: TextAlign.right,
              ),
              const SizedBox(height: 4),
              Text(
                "تابع البلاغات وساهم في إعادة الإعمار.",
                style: GoogleFonts.cairo(
                  fontSize: 13,
                  color: AppColors.textSecondary,
                ),
                textAlign: TextAlign.right,
              ),
            ],
          ),
        ),
        const SizedBox(width: 12),
        CircleAvatar(
          radius: 24,
          backgroundColor: AppColors.primary.withOpacity(0.12),
          child: const Icon(Icons.person, color: AppColors.primaryDark),
        ),
      ],
    );
  }
}
