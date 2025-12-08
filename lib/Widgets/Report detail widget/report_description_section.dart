import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:rebuild/utils/constants.dart';

class ReportDescriptionSection extends StatelessWidget {
  final String description;

  const ReportDescriptionSection({super.key, required this.description});

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch, // مهم
        children: [
          Align(
            alignment: Alignment.centerRight,
            child: Text(
              "الوصف",
              textAlign: TextAlign.right,
              style: GoogleFonts.cairo(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: AppColors.textPrimary,
              ),
            ),
          ),
          const SizedBox(height: 8),
          Align(
            alignment: Alignment.centerRight,
            child: Text(
              description,
              textAlign: TextAlign.right,
              style: GoogleFonts.cairo(
                fontSize: 15,
                height: 1.6,
                color: AppColors.textPrimary,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
