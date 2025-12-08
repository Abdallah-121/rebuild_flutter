// ignore_for_file: avoid_print, curly_braces_in_flow_control_structures

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rebuild/Api/AuthServiceDart.dart';
import 'package:rebuild/Api/report_service.dart';
import 'package:rebuild/Model/CategoryMode.dart';
import 'package:rebuild/Model/CityModel.dart';
import 'package:rebuild/Model/report_request.dart';
import 'report_state.dart';

class ReportCubit extends Cubit<ReportState> {
  final ReportService service;
  final AuthService authService;

  List<Category> categories = [];
  List<City> cities = [];

  ReportCubit(this.service, this.authService) : super(ReportInitial());

  Future<void> loadCategories() async {
    emit(CategoriesLoading());
    try {
      categories = await service.getCategories();
      emit(CategoriesLoaded(categories));
    } catch (_) {
      emit(ReportError("فشل تحميل التصنيفات"));
    }
  }

  Future<void> updateReportStatus(int reportId, String status) async {
    emit(ReportLoading());
    try {
      final ok = await service.updateReportStatus(reportId, status);
      if (ok) {
        final index = allReportsFallback.indexWhere(
          (r) => r['reportId'] == reportId,
        );
        if (index != -1) {
          allReportsFallback[index]['status'] = status;
          emit(MyReportsLoaded([...allReportsFallback]));
        } else {
          await loadMyReportsWithImages();
        }
      } else {
        emit(ReportError("فشل تحديث حالة البلاغ"));
      }
    } catch (e) {
      emit(ReportError("حدث خطأ أثناء تحديث الحالة"));
    }
  }

  Future<void> loadTopReportsByLikes() async {
    emit(ReportLoading());
    try {
      final allReports = await service.getAllReports();
      final allImages = await service.getReportImages();

      final reportsWithImages = allReports.map((report) {
        final images = allImages
            .where((img) => img['reportId'] == report['reportId'])
            .map((img) => img['imageUrl'] as String)
            .toList();
        return {...report, "images": images};
      }).toList();

      reportsWithImages.sort(
        (a, b) => (b['likesCount'] ?? 0).compareTo(a['likesCount'] ?? 0),
      );

      final top100 = reportsWithImages.take(100).toList();
      emit(AllReportsLoaded(top100));
    } catch (e) {
      emit(ReportError("فشل تحميل البلاغات الأعلى إعجابًا"));
    }
  }

  Future<void> loadCities() async {
    emit(CitiesLoading());
    try {
      cities = await authService.getCities();
      emit(CitiesLoaded(cities));
    } catch (_) {
      emit(ReportError("فشل تحميل المدن"));
    }
  }

  Future<void> createReport(ReportRequest req) async {
    emit(ReportLoading());
    try {
      final currentUser = await authService.getCurrentUserFull();
      if (currentUser == null) {
        emit(ReportError("تعذر التحقق من المستخدم الحالي"));
        return;
      }

      if (currentUser.isBanned) {
        emit(ReportError("تم حظرك، لا يمكنك إرسال بلاغ"));
        return;
      }

      final ok = await service.createReportWithToken(req);
      if (ok)
        emit(ReportSuccess());
      else
        emit(ReportError("فشل إرسال البلاغ"));
    } catch (_) {
      emit(ReportError("حدث خطأ أثناء إرسال البلاغ"));
    }
  }

  Future<void> loadMyReports() async {
    emit(ReportLoading());
    try {
      final myReports = await service.getMyReports();
      emit(MyReportsLoaded(myReports));
    } catch (e) {
      print("ERROR loadMyReports => $e");
      emit(ReportError("فشل تحميل البلاغات الخاصة بك"));
    }
  }

  List<Map<String, dynamic>> allReportsFallback = [];

  Future<void> loadAllReportsWithImages() async {
    emit(ReportLoading());

    try {
      final allReports = await service.getAllReports();
      final allImages = await service.getReportImages();
      final currentUserId = await authService.getUserIdFromToken();

      final reportsWithImages = await Future.wait(
        allReports.map((report) async {
          final reportId = report['reportId'];

          final images = allImages
              .where((img) => img['reportId'] == reportId)
              .map((img) => img['imageUrl'] as String)
              .toList();

          // ✅ جلب لايكات البلاغ
          final likeUserIds = await service.getReportLikeUserIds(reportId);

          return {
            ...report,
            "images": images,
            "isLiked": likeUserIds.contains(currentUserId),
          };
        }),
      );

      allReportsFallback = reportsWithImages;
      emit(AllReportsLoaded(reportsWithImages));
    } catch (e) {
      print("ERROR loadAllReportsWithImages => $e");
      emit(ReportError("فشل تحميل جميع البلاغات"));
    }
  }

  Future<void> loadMyReportsWithImages() async {
    emit(ReportLoading());

    try {
      final myReports = await service.getMyReports();
      final allImages = await service.getReportImages();
      final currentUserId = await authService.getUserIdFromToken();

      final reportsWithImages = await Future.wait(
        myReports.map((report) async {
          final reportId = report['reportId'];

          final images = allImages
              .where((img) => img['reportId'] == reportId)
              .map((img) => img['imageUrl'] as String)
              .toList();

          // ✅ جلب لايكات هذا البلاغ
          final likeUserIds = await service.getReportLikeUserIds(reportId);

          return {
            ...report,
            "images": images,
            "isLiked": likeUserIds.contains(currentUserId),
          };
        }),
      );

      emit(MyReportsLoaded(reportsWithImages));
    } catch (e) {
      print("ERROR loadMyReportsWithImages => $e");
      emit(ReportError("فشل تحميل البلاغات الخاصة بك"));
    }
  }

  Future<void> deleteReport(int reportId) async {
    emit(ReportLoading());
    try {
      final ok = await service.deleteReportWithToken(reportId);
      if (ok) {
        print("DELETE SUCCESS");
        emit(DeleteSuccess());
        await loadMyReportsWithImages();
      } else {
        print("DELETE FAILED");
        emit(ReportError("فشل حذف البلاغ"));
      }
    } catch (e) {
      print("DELETE ERROR => $e");
      emit(ReportError("خطأ أثناء حذف البلاغ"));
    }
  }

  loadReportById(int reportId) {}
}
