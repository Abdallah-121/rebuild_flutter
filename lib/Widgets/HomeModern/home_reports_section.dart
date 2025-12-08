import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../Widgets/Home Screen Wedget/ReportsList.dart';
import '../../screen/comments_screen.dart';

class HomeReportsSection extends StatelessWidget {
  final List<Map<String, dynamic>> reports;

  const HomeReportsSection({super.key, required this.reports});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Text(
          "البلاغات الأخيرة",
          style: GoogleFonts.cairo(fontSize: 16, fontWeight: FontWeight.w700),
        ),
        const SizedBox(height: 10),

        ReportsList(
          reports: reports,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          useExpanded: false,
          onCommentTap: (id) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => CommentsScreen(reportId: id)),
            );
          },
        ),
      ],
    );
  }
}
