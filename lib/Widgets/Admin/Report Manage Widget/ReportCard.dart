// ignore_for_file: file_names

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:rebuild/Widgets/Admin/Report%20Manage%20Widget/ActionButtons.dart';

class ReportCard extends StatelessWidget {
  final Map<String, dynamic> report;
  final VoidCallback onUpdate;

  const ReportCard({super.key, required this.report, required this.onUpdate});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (report['image'] != null)
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.file(
                  File(report['image']),
                  height: 160,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),
            const SizedBox(height: 8),
            Text(
              report['title'] ?? 'بدون عنوان',
              style: GoogleFonts.cairo(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              report['desc'] ?? '',
              style: GoogleFonts.cairo(color: Colors.grey[700]),
            ),
            const SizedBox(height: 6),
            Row(
              children: [
                const Icon(Icons.place, size: 18, color: Colors.red),
                const SizedBox(width: 4),
                Text(
                  report['area'] ?? 'غير محددة',
                  style: GoogleFonts.cairo(fontSize: 14),
                ),
              ],
            ),
            const SizedBox(height: 10),
            ActionButtons(report: report, onUpdate: onUpdate),
          ],
        ),
      ),
    );
  }
}
