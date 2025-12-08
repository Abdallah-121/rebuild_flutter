import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rebuild/Cubits/Login-Cubit/Auth Cubit Dart.dart';
import 'package:rebuild/Cubits/report-cubit/report_cubit.dart';
import 'package:rebuild/Widgets/Report detail widget/report_actions_section.dart';
import 'package:rebuild/Widgets/Report detail widget/report_admin_status_section.dart';
import 'package:rebuild/Widgets/Report detail widget/report_description_section.dart';
import 'package:rebuild/Widgets/Report detail widget/report_images_header.dart';
import 'package:rebuild/Widgets/Report detail widget/report_map_section.dart';
import 'package:rebuild/Widgets/Report detail widget/report_meta_row.dart';
import 'package:rebuild/Widgets/Report detail widget/report_title_section.dart';
import 'package:rebuild/utils/constants.dart';

class ReportDetailsScreen extends StatefulWidget {
  final Map<String, dynamic> report;

  const ReportDetailsScreen({super.key, required this.report});

  @override
  State<ReportDetailsScreen> createState() => _ReportDetailsScreenState();
}

class _ReportDetailsScreenState extends State<ReportDetailsScreen> {
  String localStatus = 'Pending';
  @override
  void initState() {
    super.initState();
    localStatus = widget.report['status'] ?? 'Pending';
  }

  @override
  Widget build(BuildContext context) {
    final int reportId = widget.report['reportId'];
    final role = context.watch<AuthCubit>().state.user?['role'] ?? 'User';

    final reportCubit = context.watch<ReportCubit>();

    final report = reportCubit.allReportsFallback.firstWhere(
      (r) => r['reportId'] == reportId,
      orElse: () => widget.report,
    );

    return Scaffold(
      backgroundColor: AppColors.background,
      body: CustomScrollView(
        slivers: [
          ReportImagesHeader(images: report['images'] ?? []),

          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  /// العنوان + الحالة ✅ محدثة دائماً
                  ReportTitleSection(
                    title: report['title'],
                    status: localStatus,
                  ),

                  const SizedBox(height: 12),

                  ReportMetaRow(
                    type: report['categoryName'],
                    cityName: report['cityName'],
                    date: report['createdAt'],
                  ),

                  const Divider(height: 32),

                  ReportDescriptionSection(description: report['description']),

                  const Divider(height: 32),

                  if (report['latitude'] != null && report['longitude'] != null)
                    MapCard(lat: report['latitude'], lng: report['longitude']),

                  const SizedBox(height: 20),

                  ReportActionsSection(reportId: reportId),

                  const SizedBox(height: 24),

                  /// ✅ الإدمن: الحالة مرتبطة بالحالة الحقيقية
                  if (role == 'Admin' || role == 'SuperAdmin')
                    ReportAdminStatusSection(
                      reportId: reportId,
                      initialStatus: localStatus,
                      onStatusSaved: (newStatus) {
                        setState(() {
                          localStatus = newStatus; // ✅ تحديث فوري
                        });
                      },
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
