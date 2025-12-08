// ignore_for_file: avoid_print, file_names

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rebuild/Api/AuthServiceDart.dart';
import 'package:rebuild/Api/report_service.dart';
import 'package:rebuild/Cubits/AdminCubit/AdminReportState.dart';

class AdminReportCubit extends Cubit<AdminReportState> {
  final ReportService reportService;
  final AuthService authService;

  List<Map<String, dynamic>> allReports = [];

  AdminReportCubit({required this.reportService, required this.authService})
    : super(AdminReportInitial());

  /// تحميل كل البلاغات مع الصور
  Future<void> loadAllReports() async {
    emit(AdminReportLoading());
    try {
      final reports = await reportService.getAllReports();
      final images = await reportService.getReportImages();

      final reportsWithImages = reports.map((report) {
        final reportImages = images
            .where((img) => img['reportId'] == report['reportId'])
            .map((img) => img['imageUrl'] as String)
            .toList();

        return {...report, "images": reportImages};
      }).toList();

      allReports = reportsWithImages;

      // حساب البلاغات حسب الحالة
      final Map<String, int> statusCounts = {};
      for (var r in reportsWithImages) {
        final status = r['status'] ?? "Unknown";
        statusCounts[status] = (statusCounts[status] ?? 0) + 1;
      }

      emit(AdminReportLoaded(reportsWithImages, statusCounts));
    } catch (e) {
      print("ERROR loadAllReports => $e");
      emit(AdminReportError("فشل تحميل جميع البلاغات"));
    }
  }

  /// حذف بلاغ محدد
  Future<void> deleteReport(int reportId) async {
    emit(AdminReportLoading());
    try {
      final success = await reportService.deleteReportWithToken(reportId);

      if (success) {
        allReports.removeWhere((r) => r['reportId'] == reportId);

        // إعادة حساب البلاغات حسب الحالة بعد الحذف
        final Map<String, int> statusCounts = {};
        for (var r in allReports) {
          final status = r['status'] ?? "Unknown";
          statusCounts[status] = (statusCounts[status] ?? 0) + 1;
        }

        emit(AdminReportDeleteSuccess());
        emit(AdminReportLoaded(allReports, statusCounts));
      } else {
        emit(AdminReportError("فشل حذف البلاغ"));
      }
    } catch (e) {
      emit(AdminReportError("خطأ أثناء حذف البلاغ"));
    }
  }
}
