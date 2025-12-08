// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:rebuild/Cubits/AdminCubit/AdminReportCubit.dart';
import 'package:rebuild/Cubits/AdminCubit/AdminReportState.dart';
import 'package:rebuild/Widgets/Home%20Screen%20Wedget/ReportsList.dart';
import 'package:rebuild/utils/constants.dart';

class ReportsManagementScreen extends StatefulWidget {
  const ReportsManagementScreen({super.key});

  @override
  State<ReportsManagementScreen> createState() =>
      _ReportsManagementScreenState();
}

class _ReportsManagementScreenState extends State<ReportsManagementScreen> {
  String searchQuery = "";
  String selectedStatus = "all"; // 🔥 فلتر الحالة

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,

      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          children: [
            // مربع البحث
            TextField(
              decoration: InputDecoration(
                hintText: "ابحث باسم البلاغ...",
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                filled: true,
                fillColor: Colors.white,
              ),
              onChanged: (val) {
                setState(() {
                  searchQuery = val;
                });
              },
            ),

            const SizedBox(height: 12),

            // 🔥 Dropdown تحت شريط البحث
            Row(
              children: [
                const Text(
                  "فلترة حسب الحالة: ",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(width: 12),
                DropdownButton<String>(
                  value: selectedStatus,
                  items: const [
                    DropdownMenuItem(value: "all", child: Text("الكل")),
                    DropdownMenuItem(
                      value: "Pending",
                      child: Text("قيد الانتظار"),
                    ),
                    DropdownMenuItem(value: "InProgress", child: Text("جارية")),
                    DropdownMenuItem(value: "Done", child: Text("منجزة")),
                  ],
                  onChanged: (value) {
                    setState(() {
                      selectedStatus = value!;
                    });
                  },
                ),
              ],
            ),

            const SizedBox(height: 12),

            Expanded(
              child: BlocBuilder<AdminReportCubit, AdminReportState>(
                builder: (context, state) {
                  if (state is AdminReportLoading ||
                      state is AdminReportInitial) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (state is AdminReportError) {
                    return Center(
                      child: Text(
                        state.message,
                        style: GoogleFonts.cairo(fontSize: 16),
                      ),
                    );
                  }

                  if (state is AdminReportLoaded) {
                    var data = state.reports;

                    // 🔥 1) فلترة حسب البحث
                    data = data.where((r) {
                      final title = r['title']?.toString() ?? '';
                      return title.toLowerCase().contains(
                        searchQuery.toLowerCase(),
                      );
                    }).toList();

                    // 🔥 2) فلترة حسب الحالة المختارة
                    if (selectedStatus != "all") {
                      data = data
                          .where((r) => r['status'] == selectedStatus)
                          .toList();
                    }

                    return ReportsList(
                      reports: data,
                      useExpanded: false,
                      shrinkWrap: false,
                      onDelete: (reportId) {
                        context.read<AdminReportCubit>().deleteReport(reportId);
                      },
                      onCommentTap: (reportId) {
                        Navigator.pushNamed(
                          context,
                          '/comments',
                          arguments: reportId,
                        );
                      },
                    );
                  }

                  return const SizedBox();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
