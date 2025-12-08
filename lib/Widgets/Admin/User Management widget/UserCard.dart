// ignore_for_file: deprecated_member_use, file_names

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../utils/constants.dart';

class UserCard extends StatelessWidget {
  final int userId;
  final String name;
  final String email;
  final String phone;
  final String city;
  final bool isBanned;
  final VoidCallback onBanToggle;
  final VoidCallback onDelete;

  const UserCard({
    super.key,
    required this.userId,
    required this.name,
    required this.email,
    required this.phone,
    required this.city,
    required this.isBanned,
    required this.onBanToggle,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: AppColors.primary.withOpacity(0.3),
          width: 1.3,
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withOpacity(0.08),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
        gradient: LinearGradient(
          colors: [Colors.white, Colors.green.withOpacity(0.03)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 🔹 الاسم
          Row(
            children: [
              Expanded(
                child: Text(
                  name,
                  style: GoogleFonts.cairo(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: AppColors.primary,
                  ),
                ),
              ),
              Text(
                "$userId",
                style: GoogleFonts.cairo(
                  fontSize: 16,
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),

          // 🔹 الإيميل
          Row(
            children: [
              const Icon(Icons.email, color: AppColors.primary, size: 20),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  email,
                  style: GoogleFonts.cairo(
                    fontSize: 14,
                    color: AppColors.textSecondary,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),

          // 🔹 رقم الهاتف
          Row(
            children: [
              const Icon(Icons.phone, color: AppColors.primary, size: 20),
              const SizedBox(width: 6),
              Text(
                phone,
                style: GoogleFonts.cairo(
                  fontSize: 14,
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),

          // 🔹 المدينة
          Row(
            children: [
              const Icon(Icons.location_on, color: AppColors.primary, size: 20),
              const SizedBox(width: 6),
              Text(
                city,
                style: GoogleFonts.cairo(
                  fontSize: 14,
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),

          const SizedBox(height: 14),
          Divider(color: AppColors.greyLight, thickness: .8),
          const SizedBox(height: 10),

          // 🔹 الأزرار
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // زر الحظر / إلغاء الحظر
              ElevatedButton.icon(
                onPressed: onBanToggle,
                icon: Icon(isBanned ? Icons.lock_open : Icons.block, size: 18),
                label: Text(
                  isBanned ? "إلغاء الحظر" : "حظر",
                  style: GoogleFonts.cairo(fontSize: 14),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: isBanned ? Colors.orange : AppColors.primary,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),

              // زر الحذف
              ElevatedButton.icon(
                onPressed: onDelete,
                icon: const Icon(Icons.delete, size: 18),
                label: Text("حذف", style: GoogleFonts.cairo(fontSize: 14)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.redAccent,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
