import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

// Services
import 'package:rebuild/Api/AuthServiceDart.dart';
import 'package:rebuild/Api/SupportService.dart';
import 'package:rebuild/Api/comment_service.dart';
import 'package:rebuild/Api/report_service.dart';

// Main Cubits
import 'package:rebuild/Cubits/Login-Cubit/Auth Cubit Dart.dart';
import 'package:rebuild/Cubits/report-cubit/report_cubit.dart';
import 'package:rebuild/Cubits/comment_cubit/comment_cubit.dart';

// Admin Cubits
import 'package:rebuild/Cubits/AdminCubit/AdminReportCubit.dart';
import 'package:rebuild/Cubits/AdminCubit/AdminTicketCubit.dart';
import 'package:rebuild/Cubits/AdminCubit/UserCubit.dart';
import 'package:rebuild/screen/RootScreen.dart';
import 'package:rebuild/screen/signup_screen.dart';

// Screens
import 'package:rebuild/screen/splash_screen.dart';
import 'package:rebuild/screen/onboarding_screen.dart';
import 'package:rebuild/screen/login_screen.dart';
import 'package:rebuild/screen/home_screen.dart';
import 'package:rebuild/screen/add_report_screen.dart';
import 'package:rebuild/screen/my_reports_screen.dart';
import 'package:rebuild/screen/profile_screen.dart';
import 'package:rebuild/screen/settings_screen.dart';
import 'package:rebuild/screen/EditProfileScreen.dart';
import 'package:rebuild/screen/DonateScreen.dart';
import 'package:rebuild/screen/comments_screen.dart';
import 'package:rebuild/screen/report_details_screen.dart';
import 'package:rebuild/screen/SupportChatScreen.dart';

// Admin Screens
import 'package:rebuild/Admin/AdminDashboard.dart';
import 'package:rebuild/Admin/ReportsManagementScreen.dart';
import 'package:rebuild/Admin/UsersManagementScreen.dart';
import 'package:rebuild/Admin/AdminTicketListPage.dart';

import 'utils/constants.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // الحصول على بيانات المستخدم
  final authService = AuthService();
  final currentUserId = await authService.getUserIdFromToken();
  final currentUserName = await authService.getUserNameFromToken();

  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => AuthCubit(authService)),
        BlocProvider(
          create: (_) =>
              ReportCubit(ReportService(authService: authService), authService),
        ),
        BlocProvider(
          create: (_) => CommentCubit(
            commentService: CommentService(),
            currentUserId: currentUserId,
            currentUserName: currentUserName,
          ),
        ),
      ],
      child: const RebuildApp(),
    ),
  );
}

class RebuildApp extends StatelessWidget {
  const RebuildApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'إعادة إعمار',
      theme: AppTheme.lightTheme,
      builder: (context, child) =>
          Directionality(textDirection: TextDirection.rtl, child: child!),

      initialRoute: '/',

      routes: {
        '/': (_) => const RootScreen(),
        '/splash': (_) => const SplashScreen(),
        '/onboarding': (_) => const OnboardingScreen(),
        '/signup': (_) => const SignUpScreen(),
        '/login': (_) => const LoginScreen(),
        '/home': (_) => const HomeScreenMaterialModern(),
        '/add-report': (_) => const AddReportScreen(),
        '/my-reports': (_) => const MyReportsScreen(),
        '/profile': (_) => const ProfileScreen(),
        '/settings': (_) => const SettingsScreen(),
        '/editProfile': (_) => const EditProfileScreen(),
        '/donate': (_) => const DonateScreen(),
        '/support-chat': (_) => const SupportChatPage(),

        // ------------------------------
        // 🔥 لوحة التحكم — أهم شيء هنا
        // ------------------------------
        '/admin-dashboard': (_) => MultiBlocProvider(
          providers: [
            BlocProvider(
              create: (_) => AdminReportCubit(
                reportService: ReportService(authService: AuthService()),
                authService: AuthService(),
              )..loadAllReports(),
            ),
            BlocProvider(
              create: (_) => UsersCubit(AuthService())..fetchUsers(),
            ),
            BlocProvider(
              create: (_) => AdminTicketCubit(
                SupportService(
                  baseUrl: 'http://216.126.239.86:5000',
                  authService: AuthService(),
                ),
              )..loadTickets(),
            ),
          ],
          child: const AdminDashboard(),
        ),

        //---------------------------------------------------
        // هذه الصفحات ترث الـ Cubits من AdminDashboard
        //---------------------------------------------------
        '/reports-management': (_) => const ReportsManagementScreen(),
        '/users-management': (_) => const UsersManagementScreen(),
        '/admin-tickets': (_) => const AdminTicketListPage(),
      },

      //-------------------------------------------------------------------
      // شاشات لها arguments فحطيناها بـ onGenerateRoute
      //-------------------------------------------------------------------
      onGenerateRoute: (settings) {
        if (settings.name == '/report-details') {
          final data = settings.arguments as Map<String, dynamic>?;
          if (data != null) {
            return MaterialPageRoute(
              builder: (_) => ReportDetailsScreen(report: data),
            );
          }
        }

        if (settings.name == '/comments') {
          final reportId = settings.arguments as int;
          return MaterialPageRoute(
            builder: (_) => CommentsScreen(reportId: reportId),
          );
        }

        return null;
      },
    );
  }
}
