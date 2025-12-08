// _ImportantReportsList.dart
// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ImportantReportsList extends StatelessWidget {
  final List<Map<String, dynamic>> reports;
  final Function(Map<String, dynamic>) onTap;

  const ImportantReportsList({
    required this.reports,
    required this.onTap,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    if (reports.isEmpty) {
      return Center(
        child: Text(
          "لا توجد بلاغات مهمة حالياً",
          style: GoogleFonts.cairo(fontSize: 16),
        ),
      );
    }

    return ListView.builder(
      itemCount: reports.length,
      itemBuilder: (context, index) {
        final report = reports[index];
        return Card(
          margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 12),
          child: ListTile(
            leading: const Icon(Icons.report, color: Colors.orange),
            title: Text(
              report['title'] ?? "بلاغ بدون عنوان",
              style: GoogleFonts.cairo(),
            ),
            subtitle: Text(
              "عدد الإعجابات: ${report['likes'] ?? 0}",
              style: GoogleFonts.cairo(),
            ),
            trailing: const Icon(Icons.star, color: Colors.yellow),
            onTap: () => onTap(report),
          ),
        );
      },
    );
  }
}
