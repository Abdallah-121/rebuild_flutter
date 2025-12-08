// ignore_for_file: file_names, use_build_context_synchronously

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ActionButtons extends StatelessWidget {
  final Map<String, dynamic> report;
  final VoidCallback onUpdate;

  const ActionButtons({
    super.key,
    required this.report,
    required this.onUpdate,
  });

  Future<void> _updateReportStatus(
    BuildContext context,
    String newStatus,
  ) async {
    final prefs = await SharedPreferences.getInstance();
    final List<String> allReports = prefs.getStringList('reports') ?? [];

    final updatedReports = allReports.map((r) {
      final decoded = jsonDecode(r);
      if (decoded['date'] == report['date']) {
        decoded['status'] = newStatus;
      }
      return jsonEncode(decoded);
    }).toList();

    await prefs.setStringList('reports', updatedReports);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          newStatus == 'منجزة' ? '✅ تم قبول البلاغ بنجاح' : '❌ تم رفض البلاغ',
          style: GoogleFonts.cairo(),
        ),
        backgroundColor: newStatus == 'منجزة' ? Colors.green : Colors.red,
      ),
    );

    onUpdate();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            onPressed: () => _updateReportStatus(context, 'منجزة'),
            icon: const Icon(Icons.check),
            label: Text("موافقة", style: GoogleFonts.cairo()),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            onPressed: () => _updateReportStatus(context, 'مرفوض'),
            icon: const Icon(Icons.close),
            label: Text("رفض", style: GoogleFonts.cairo()),
          ),
        ),
      ],
    );
  }
}
