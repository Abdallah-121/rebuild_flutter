// ignore_for_file: file_names, use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:rebuild/Admin/ReportsManagementScreen.dart';
import 'package:rebuild/Admin/UsersManagementScreen.dart';
import 'package:rebuild/Admin/AdminsManagementScreen.dart';
import 'package:rebuild/Admin/ImportantReportsScreen.dart';
import 'package:rebuild/Admin/AdminTicketListPage.dart';

import 'package:rebuild/Cubits/Login-Cubit/Auth Cubit Dart.dart';
import 'package:rebuild/Widgets/Admin/Home%20Dashboard%20widget/DashboardHome.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../utils/constants.dart';

class AdminDashboard extends StatefulWidget {
  const AdminDashboard({super.key});

  @override
  State<AdminDashboard> createState() => _AdminDashboardState();
}

class _AdminDashboardState extends State<AdminDashboard> {
  int _selectedIndex = 0;

  final List<String> _pageTitles = [
    "لوحة التحكم",
    "إدارة البلاغات",
    "إدارة المستخدمين",
    "إدارة المشرفين",
    "البلاغات الأكثر أهمية",
    "المساعدة والدعم",
  ];

  late final List<Widget> _pages;

  /// هذه هي الصفحات اللي تظهر في BottomNavigationBar
  final List<int> _bottomNavPages = [0, 1, 4, 5]; // indices من _pages

  @override
  void initState() {
    super.initState();

    /// كل الصفحات
    _pages = const [
      DashboardHome(),
      ReportsManagementScreen(),
      UsersManagementScreen(),
      AdminsManagementScreen(),
      ImportantReportsScreen(),
      AdminTicketListPage(),
    ];
  }

  void _onNavTapped(int index) {
    setState(() => _selectedIndex = _bottomNavPages[index]);
  }

  @override
  Widget build(BuildContext context) {
    final currentUser = context.watch<AuthCubit>().state.user;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          _pageTitles[_selectedIndex],
          style: GoogleFonts.cairo(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: AppColors.primary,
      ),

      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(color: AppColors.primary),
              child: Center(
                child: Text(
                  currentUser != null
                      ? "مرحبًا ${currentUser['fullName']}!"
                      : "مرحبًا بك!",
                  style: GoogleFonts.cairo(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),

            /// عناصر الـ Drawer
            for (int i = 0; i < _pageTitles.length; i++)
              ListTile(
                leading: Icon(
                  i == 0
                      ? Icons.dashboard
                      : i == 1
                      ? Icons.report
                      : i == 2
                      ? Icons.people
                      : i == 3
                      ? Icons.admin_panel_settings
                      : i == 4
                      ? Icons.trending_up
                      : Icons.support_agent,
                ),
                title: Text(_pageTitles[i], style: GoogleFonts.cairo()),
                onTap: () {
                  Navigator.pop(context);
                  setState(() => _selectedIndex = i);
                },
              ),

            const Divider(),

            /// تسجيل الخروج للـ Admin
            ListTile(
              leading: const Icon(Icons.logout),
              title: Text("تسجيل الخروج", style: GoogleFonts.cairo()),
              onTap: () async {
                // مسح التوكن وبيانات المستخدم
                final prefs = await SharedPreferences.getInstance();
                await prefs.remove('auth_token');
                await prefs.remove('remember_me');
                await prefs.remove(
                  'current_user',
                ); // لو خزنت بيانات المستخدم كاملة

                // إعادة التوجيه لشاشة تسجيل الدخول ومسح كل الروترات السابقة
                Navigator.pushNamedAndRemoveUntil(
                  context,
                  '/login',
                  (route) => false,
                );

                // لو تستخدم Cubit، استدعاء logout فيه أيضًا
                context.read<AuthCubit>().logout();
              },
            ),
          ],
        ),
      ),

      body: IndexedStack(index: _selectedIndex, children: _pages),

      /// BottomNavigationBar بدون صفحات المستخدمين والمشرفين
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _bottomNavPages.contains(_selectedIndex)
            ? _bottomNavPages.indexOf(_selectedIndex)
            : 0, // إذا الصفحة ليست ضمن الـ BottomNavigationBar
        selectedItemColor: AppColors.primary,
        unselectedItemColor: Colors.grey,
        onTap: _onNavTapped,
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'الرئيسية'),
          BottomNavigationBarItem(
            icon: Icon(Icons.report),
            label: 'إدارة البلاغات',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.trending_up),
            label: 'الأهمية',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.support_agent),
            label: 'المساعدة',
          ),
        ],
      ),
    );
  }
}
