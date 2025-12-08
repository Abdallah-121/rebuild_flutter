// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:rebuild/utils/constants.dart';

class HomeSearchBar extends StatelessWidget {
  final ValueChanged<String> onChanged;

  const HomeSearchBar({super.key, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return TextField(
      textDirection: TextDirection.rtl,
      onChanged: onChanged, // ✅ هون المهم
      decoration: InputDecoration(
        prefixIcon: const Icon(Icons.search),
        hintText: "ابحث باسم البلاغ أو المدينة...",
        hintStyle: GoogleFonts.cairo(fontSize: 14),
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.symmetric(horizontal: 12),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: AppColors.greyLight),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: AppColors.greyLight),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(
            color: AppColors.primaryDark,
            width: 1.3,
          ),
        ),
      ),
    );
  }
}
