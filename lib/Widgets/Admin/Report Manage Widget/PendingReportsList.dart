// ignore_for_file: file_names

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:rebuild/Widgets/Admin/Report%20Manage%20Widget/ReportCard.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PendingReportsList extends StatefulWidget {
  const PendingReportsList({super.key});

  @override
  State<PendingReportsList> createState() => _PendingReportsListState();
}

class _PendingReportsListState extends State<PendingReportsList> {
  List<Map<String, dynamic>> pendingReports = [];

  @override
  void initState() {
    super.initState();
    _loadPendingReports();
  }

  Future<void> _loadPendingReports() async {
    final prefs = await SharedPreferences.getInstance();
    final List<String> allReports = prefs.getStringList('reports') ?? [];

    setState(() {
      pendingReports = allReports
          .map((r) => jsonDecode(r) as Map<String, dynamic>)
          .where((r) => r['status'] == "قيد المعالجة")
          .toList();
    });
  }

  void _refresh() => _loadPendingReports();

  @override
  Widget build(BuildContext context) {
    if (pendingReports.isEmpty) {
      return Center(
        child: Text(
          "لا توجد بلاغات بانتظار المراجعة 🚫",
          style: GoogleFonts.cairo(fontSize: 16),
        ),
      );
    }

    return ListView.builder(
      itemCount: pendingReports.length,
      itemBuilder: (context, index) {
        final report = pendingReports[index];
        return ReportCard(report: report, onUpdate: _refresh);
      },
    );
  }
}
