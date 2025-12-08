// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:rebuild/Cubits/Login-Cubit/Auth Cubit Dart.dart';
import 'package:rebuild/Cubits/report-cubit/report_cubit.dart';
import 'package:rebuild/Widgets/HomeModern/home_content.dart';
import 'package:rebuild/screen/DonateScreen.dart';
import 'package:rebuild/screen/add_report_screen.dart';
import 'package:rebuild/screen/my_reports_screen.dart';
import 'package:rebuild/screen/profile_screen.dart';
import 'package:rebuild/utils/constants.dart';

class HomeScreenMaterialModern extends StatefulWidget {
  const HomeScreenMaterialModern({super.key});

  @override
  State<HomeScreenMaterialModern> createState() =>
      _HomeScreenMaterialModernState();
}

class _HomeScreenMaterialModernState extends State<HomeScreenMaterialModern> {
  int _selectedIndex = 0;

  void _onNavTapped(int index) {
    setState(() => _selectedIndex = index);

    // ✅ هون الحل
    if (index == 2) {
      context.read<ReportCubit>().loadMyReportsWithImages();
    }
  }

  @override
  Widget build(BuildContext context) {
    final currentUser = context.watch<AuthCubit>().state.user;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: _selectedIndex == 0
          ? AppBar(
              backgroundColor: AppColors.background,
              elevation: 0,
              title: Text(
                "إعادة إعمار",
                style: GoogleFonts.cairo(
                  fontSize: 22,
                  fontWeight: FontWeight.w800,
                  color: AppColors.primaryDark,
                ),
              ),
              centerTitle: false,
              leading: Builder(
                builder: (context) => IconButton(
                  icon: const Icon(Icons.menu, color: AppColors.primaryDark),
                  onPressed: () => Scaffold.of(context).openDrawer(),
                ),
              ),
            )
          : null,
      drawer: _selectedIndex == 0 ? _buildDrawer(currentUser) : null,
      body: IndexedStack(
        index: _selectedIndex,
        children: [
          HomeContent(user: currentUser),
          const AddReportScreen(),
          const MyReportsScreen(),
          const DonateScreen(),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        selectedItemColor: AppColors.primaryDark,
        unselectedItemColor: Colors.grey,
        onTap: _onNavTapped,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_rounded),
            label: "الرئيسية",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.add_circle_outline),
            label: "إضافة",
          ),
          BottomNavigationBarItem(icon: Icon(Icons.list_alt), label: "بلاغاتي"),
          BottomNavigationBarItem(
            icon: Icon(Icons.volunteer_activism),
            label: "تبرع",
          ),
        ],
      ),
    );
  }

  Drawer _buildDrawer(Map<String, dynamic>? user) {
    return Drawer(
      child: ListView(
        children: [
          DrawerHeader(
            decoration: BoxDecoration(color: AppColors.primaryDark),
            child: Align(
              alignment: Alignment.centerRight,
              child: Text(
                user != null ? "مرحبًا ${user['fullName']}!" : "مرحبًا بك!",
                style: GoogleFonts.arefRuqaa(
                  fontSize: 22,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          _drawerItem(Icons.person, "الحساب الشخصي", () {
            Navigator.pop(context);
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const ProfileScreen()),
            );
          }),
          _drawerItem(Icons.list_alt, "بلاغاتي", () => _onNavTapped(2)),
          _drawerItem(
            Icons.help_center,
            "المساعدة والدعم",
            () => Navigator.pushNamed(context, '/support-chat'),
          ),
          Divider(),
          _drawerItem(Icons.logout, "تسجيل الخروج", () => logout(context)),
        ],
      ),
    );
  }

  Widget _drawerItem(IconData icon, String title, VoidCallback onTap) {
    return ListTile(
      leading: Icon(icon),
      title: Text(title, style: GoogleFonts.cairo()),
      onTap: onTap,
    );
  }
}
