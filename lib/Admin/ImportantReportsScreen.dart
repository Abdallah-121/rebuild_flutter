import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rebuild/Cubits/report-cubit/report_cubit.dart';
import 'package:rebuild/Cubits/report-cubit/report_state.dart';
import 'package:rebuild/Widgets/Home%20Screen%20Wedget/ReportsList.dart';

class ImportantReportsScreen extends StatelessWidget {
  const ImportantReportsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final reportCubit = context.read<ReportCubit>();
    // تحميل أعلى البلاغات عند فتح الصفحة
    reportCubit.loadTopReportsByLikes();

    return Scaffold(
      body: BlocBuilder<ReportCubit, ReportState>(
        builder: (context, state) {
          if (state is ReportLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is AllReportsLoaded) {
            final reports = state.reports;
            return ReportsList(
              reports: reports.map((r) {
                return {
                  "reportId": r['reportId'],
                  "title": r['title'] ?? '',
                  "description": r['description'] ?? '',
                  "cityName": r['cityName'] ?? '',
                  "categoryName": r['categoryName'] ?? '',
                  "images": r['images'] ?? [],
                  "likesCount": r['likesCount'] ?? 0,
                  "isLiked": r['isLiked'] ?? false,
                  "commentCount": r['commentCount'] ?? 0,
                };
              }).toList(),
              useExpanded: false,
            );
          } else if (state is ReportError) {
            return Center(child: Text(state.message));
          }
          return const SizedBox();
        },
      ),
    );
  }
}
