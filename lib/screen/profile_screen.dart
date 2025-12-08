import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:rebuild/Cubits/Login-Cubit/Auth Cubit Dart.dart';
import 'package:rebuild/Cubits/Login-Cubit/Auth State Dart.dart';
import 'package:rebuild/utils/constants.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthCubit, AuthState>(
      builder: (context, state) {
        if (state.isLoading) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        final user = state.user;
        if (user == null) {
          return const Scaffold(
            body: Center(child: Text("تعذر تحميل بيانات الحساب")),
          );
        }

        final fullName = user['fullName'] ?? "مستخدم";
        final email = user['email'] ?? "-";
        final phone = user['phone'] ?? "-";

        return Scaffold(
          backgroundColor: AppColors.background,
          body: Stack(
            children: [
              _headerBackground(),
              SafeArea(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.fromLTRB(16, 90, 16, 24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      _profileCard(fullName, email),
                      const SizedBox(height: 24),
                      _infoSection(fullName, email, phone),
                      const SizedBox(height: 24),
                      _actions(context),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  /* -------------------------------------------------------------------------- */
  /*                                   HEADER                                   */
  /* -------------------------------------------------------------------------- */

  Widget _headerBackground() {
    return Container(
      height: 220,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF1E88E5), Color(0xFF2E7D32)],
          begin: Alignment.topRight,
          end: Alignment.bottomLeft,
        ),
      ),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(color: Colors.black.withOpacity(.05)),
      ),
    );
  }

  /* -------------------------------------------------------------------------- */
  /*                                PROFILE CARD                                */
  /* -------------------------------------------------------------------------- */

  Widget _profileCard(String name, String email) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(.06),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          CircleAvatar(
            radius: 42,
            backgroundColor: AppColors.primaryDark,
            child: Text(
              name.isNotEmpty ? name[0] : "?",
              style: GoogleFonts.cairo(
                fontSize: 36,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
          const SizedBox(height: 14),
          Text(
            name,
            style: GoogleFonts.cairo(
              fontSize: 20,
              fontWeight: FontWeight.w800,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            email,
            style: GoogleFonts.cairo(
              fontSize: 14,
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }

  /* -------------------------------------------------------------------------- */
  /*                                INFO SECTION                                 */
  /* -------------------------------------------------------------------------- */

  Widget _infoSection(String name, String email, String phone) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        _infoTile(Icons.person_outline, "الاسم الكامل", name),
        _infoTile(Icons.email_outlined, "البريد الإلكتروني", email),
        _infoTile(Icons.phone_outlined, "رقم الهاتف", phone),
      ],
    );
  }

  Widget _infoTile(IconData icon, String label, String value) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(.04),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Icon(icon, color: AppColors.primaryDark),
          const Spacer(),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                label,
                style: GoogleFonts.cairo(
                  fontSize: 12,
                  color: AppColors.textSecondary,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                value,
                style: GoogleFonts.cairo(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  /* -------------------------------------------------------------------------- */
  /*                                   ACTIONS                                  */
  /* -------------------------------------------------------------------------- */

  Widget _actions(BuildContext context) {
    return Column(
      children: [
        _actionButton(
          icon: Icons.edit_outlined,
          label: "تعديل الحساب",
          color: AppColors.primary,
          onTap: () => Navigator.pushNamed(context, '/editProfile'),
        ),
        const SizedBox(height: 12),
        _actionButton(
          icon: Icons.logout,
          label: "تسجيل الخروج",
          color: Colors.redAccent,
          onTap: () {
            context.read<AuthCubit>().logout();
            Navigator.pushReplacementNamed(context, '/login');
          },
        ),
      ],
    );
  }

  Widget _actionButton({
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    return SizedBox(
      width: double.infinity,
      height: 52,
      child: ElevatedButton.icon(
        onPressed: onTap,
        icon: Icon(icon),
        label: Text(
          label,
          style: GoogleFonts.cairo(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
          ),
        ),
      ),
    );
  }
}
