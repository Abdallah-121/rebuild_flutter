import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../utils/constants.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("الإعدادات", style: GoogleFonts.cairo()),
        backgroundColor: AppColors.primary,
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.help_outline),
            onPressed: () => _showSupportDialog(context),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // المساعدة والدعم
          ListTile(
            leading: const Icon(Icons.help),
            title: Text("المساعدة والدعم", style: GoogleFonts.cairo()),
            onTap: () => _showSupportDialog(context),
          ),
          const Divider(),

          // سياسة الخصوصية والشروط
          ListTile(
            leading: const Icon(Icons.privacy_tip),
            title: Text("سياسة الخصوصية والشروط", style: GoogleFonts.cairo()),
            onTap: () {
              // هنا ممكن تفتح صفحة جديدة أو WebView
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: Text("سياسة الخصوصية", style: GoogleFonts.cairo()),
                  content: Text(
                    "سياسة الخصوصية والشروط الخاصة بالتطبيق...",
                    style: GoogleFonts.cairo(),
                  ),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: Text("حسناً", style: GoogleFonts.cairo()),
                    ),
                  ],
                ),
              );
            },
          ),
          const Divider(),

          // اقتراحات وملاحظات
          ListTile(
            leading: const Icon(Icons.feedback),
            title: Text("اقتراحات وملاحظات", style: GoogleFonts.cairo()),
            onTap: () {
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: Text("اقتراحات وملاحظات", style: GoogleFonts.cairo()),
                  content: TextField(
                    decoration: InputDecoration(
                      hintText: "اكتب اقتراحك هنا...",
                      hintStyle: GoogleFonts.cairo(),
                    ),
                    maxLines: 4,
                  ),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: Text("إرسال", style: GoogleFonts.cairo()),
                    ),
                  ],
                ),
              );
            },
          ),
          const Divider(),

          // تسجيل الخروج
          ListTile(
            leading: const Icon(Icons.logout),
            title: Text("تسجيل الخروج", style: GoogleFonts.cairo()),
            onTap: () {
              // تنفيذ تسجيل الخروج
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: Text("تأكيد تسجيل الخروج", style: GoogleFonts.cairo()),
                  content: Text(
                    "هل أنت متأكد من تسجيل الخروج؟",
                    style: GoogleFonts.cairo(),
                  ),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: Text("إلغاء", style: GoogleFonts.cairo()),
                    ),
                    TextButton(
                      onPressed: () {
                        // مثال: العودة لشاشة تسجيل الدخول
                        Navigator.popUntil(context, (route) => route.isFirst);
                      },
                      child: Text("تأكيد", style: GoogleFonts.cairo()),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  void _showSupportDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("المساعدة والدعم", style: GoogleFonts.cairo()),
        content: Text(
          "لأي استفسار أو دعم، راسلنا على:\nsupport@rebuild.com",
          style: GoogleFonts.cairo(),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text("حسناً", style: GoogleFonts.cairo()),
          ),
        ],
      ),
    );
  }
}
