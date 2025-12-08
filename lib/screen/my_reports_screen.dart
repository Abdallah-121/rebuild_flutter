import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:rebuild/Cubits/report-cubit/report_cubit.dart';
import 'package:rebuild/Cubits/report-cubit/report_state.dart';
import 'package:rebuild/Widgets/Myreport%20widget/EmptyState.dart';
import 'package:rebuild/Widgets/Myreport%20widget/MyReportTimelineItem.dart';
import 'package:rebuild/utils/constants.dart';

class MyReportsScreen extends StatefulWidget {
  const MyReportsScreen({super.key});

  @override
  State<MyReportsScreen> createState() => _MyReportsScreenState();
}

class _MyReportsScreenState extends State<MyReportsScreen> {
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    context.read<ReportCubit>().loadMyReportsWithImages();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text("بلاغاتي"),
        centerTitle: true,
        backgroundColor: AppColors.primaryDark,
      ),
      body: BlocBuilder<ReportCubit, ReportState>(
        builder: (context, state) {
          if (state is ReportLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is ReportError) {
            return Center(child: Text(state.message));
          }

          if (state is MyReportsLoaded) {
            if (state.reports.isEmpty) return const EmptySmartState();

            return ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: state.reports.length,
              itemBuilder: (context, i) {
                return MyReportTimelineItem(report: state.reports[i]);
              },
            );
          }

          return const SizedBox();
        },
      ),
    );
  }
}

class IconCount extends StatelessWidget {
  final IconData icon;
  final int count;

  const IconCount(this.icon, this.count);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 18, color: Colors.grey),
        const SizedBox(width: 4),
        Text("$count", style: GoogleFonts.cairo(fontSize: 12)),
      ],
    );
  }
}
