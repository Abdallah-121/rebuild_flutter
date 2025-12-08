import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:rebuild/Cubits/report-cubit/report_cubit.dart';
import 'package:rebuild/Widgets/Myreport%20widget/StatusDot.dart';
import 'package:rebuild/screen/my_reports_screen.dart';

class MyReportTimelineItem extends StatelessWidget {
  final Map<String, dynamic> report;
  const MyReportTimelineItem({super.key, required this.report});

  @override
  Widget build(BuildContext context) {
    final status = report['status'] ?? "Pending";
    final likes = report['likesCount'] ?? 0;
    final comments = report['commentCount'] ?? 0;
    final images = report['images'] as List? ?? [];

    return Dismissible(
      key: ValueKey(report['reportId']),
      direction: DismissDirection.startToEnd,
      confirmDismiss: (_) => _confirmDelete(context),
      background: _deleteBackground(),
      child: Container(
        margin: const EdgeInsets.only(bottom: 20),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            StatusDot(status),
            const SizedBox(width: 12),
            Expanded(
              child: Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(.05),
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _thumbnail(images),
                    const SizedBox(width: 10),
                    Expanded(child: _content(context, status, likes, comments)),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /* ---------------- THUMBNAIL ---------------- */

  Widget _thumbnail(List images) {
    if (images.isEmpty) {
      return const CircleAvatar(
        radius: 26,
        backgroundColor: Colors.grey,
        child: Icon(Icons.image_not_supported, color: Colors.white),
      );
    }

    return CircleAvatar(
      radius: 26,
      backgroundImage: NetworkImage(
        "http://216.126.239.86:5000${images.first}",
      ),
      backgroundColor: Colors.grey.shade200,
    );
  }

  /* ---------------- CONTENT ---------------- */

  Widget _content(
    BuildContext context,
    String status,
    int likes,
    int comments,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Text(
          report['title'] ?? '',
          textAlign: TextAlign.right,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: GoogleFonts.cairo(fontSize: 15, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 6),
        Text(
          report['description'] ?? '',
          textAlign: TextAlign.right,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(color: Colors.grey.shade700),
        ),
        const SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                IconCount(Icons.favorite_border, likes),
                const SizedBox(width: 12),
                IconCount(Icons.comment_outlined, comments),
              ],
            ),
            TextButton(
              onPressed: () {
                Navigator.pushNamed(
                  context,
                  '/report-details',
                  arguments: report,
                );
              },
              child: const Text("التفاصيل"),
            ),
          ],
        ),
      ],
    );
  }

  /* ---------------- DELETE ---------------- */

  Widget _deleteBackground() {
    return Container(
      alignment: Alignment.centerRight,
      padding: const EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
        color: Colors.redAccent,
        borderRadius: BorderRadius.circular(16),
      ),
      child: const Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Icon(Icons.delete, color: Colors.white),
          SizedBox(width: 6),
          Text(
            "حذف",
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  Future<bool?> _confirmDelete(BuildContext context) {
    return showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("حذف البلاغ"),
        content: const Text("هل تريد حذف هذا البلاغ نهائياً؟"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text("إلغاء"),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.redAccent),
            onPressed: () {
              context.read<ReportCubit>().deleteReport(report['reportId']);
              Navigator.pop(context, true);
            },
            child: const Text("حذف"),
          ),
        ],
      ),
    );
  }
}
