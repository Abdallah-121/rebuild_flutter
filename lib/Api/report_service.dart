import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:rebuild/Api/AuthServiceDart.dart';
import 'package:rebuild/Model/CategoryMode.dart';
import 'package:rebuild/Model/report_request.dart';

class ReportService {
  static const String baseUrl = "";
  final AuthService authService;

  ReportService({required this.authService});

  /// GET CATEGORIES (لا تحتاج توكن)
  Future<List<Category>> getCategories() async {
    final url = Uri.parse("");
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final List data = jsonDecode(response.body);
      return data.map((e) => Category.fromJson(e)).toList();
    } else {
      throw Exception("فشل جلب التصنيفات");
    }
  }

  /// GET REPORT LIKE USER IDS
Future<List<int>> getReportLikeUserIds(int reportId) async {
  final token = await authService.getToken();
  final url = Uri.parse("");

  final response = await http.get(
    url,
    headers: {
      "Content-Type": "application/json",
      "Authorization": "Bearer $token",
    },
  );

  if (response.statusCode == 200) {
    final List data = jsonDecode(response.body);
    return data.map((e) => e as int).toList();
  } else {
    throw Exception("فشل جلب لايكات البلاغ");
  }
}


  /// تحديث حالة البلاغ
  Future<bool> updateReportStatus(int reportId, String status) async {
    final token = await authService.getToken();
    final url = Uri.parse("");
    final response = await http.patch(
      url,
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $token",
      },
      body: jsonEncode({"status": status}),
    );
    return response.statusCode == 200 || response.statusCode == 204;
  }

  /// إنشاء بلاغ مع توكن
  Future<bool> createReportWithToken(ReportRequest request) async {
    final token = await authService.getToken();
    final url = Uri.parse("");

    final response = await http.post(
      url,
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $token",
      },
      body: jsonEncode(request.toJson()),
    );

    return response.statusCode == 200 || response.statusCode == 201;
  }

  /// GET ALL REPORTS
  Future<List<Map<String, dynamic>>> getAllReports() async {
    final token = await authService.getToken();
    final url = Uri.parse("$/Report/all");
    final response = await http.get(
      url,
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $token",
      },
    );

    if (response.statusCode == 200) {
      final List data = jsonDecode(response.body);
      return data.map((e) => e as Map<String, dynamic>).toList();
    } else {
      throw Exception("فشل جلب البلاغات");
    }
  }

  /// GET SINGLE REPORT BY ID
  Future<Map<String, dynamic>> getReportById(int reportId) async {
    final token = await authService.getToken();
    final url = Uri.parse("$/Report/$reportId");
    final response = await http.get(
      url,
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $token",
      },
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> report = jsonDecode(response.body);

      // جلب الصور
      final imagesUrl = Uri.parse("$/ReportImage");
      final imagesResponse = await http.get(
        imagesUrl,
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token",
        },
      );

      if (imagesResponse.statusCode == 200) {
        final List allImages = jsonDecode(imagesResponse.body);
        final reportImages = allImages
            .where((img) => img['reportId'] == reportId)
            .map((img) => img['imageUrl'] as String)
            .toList();
        report['images'] = reportImages;
      } else {
        report['images'] = [];
      }

      return report;
    } else {
      throw Exception("فشل جلب البلاغ بالمعرف $reportId");
    }
  }

  /// DELETE REPORT
  Future<bool> deleteReportWithToken(int id) async {
    final token = await authService.getToken();
    final url = Uri.parse("$baseUrl/Report/$id");

    final response = await http.delete(
      url,
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $token",
      },
    );

    return response.statusCode == 200 || response.statusCode == 204;
  }

  /// GET MY REPORTS
  Future<List<Map<String, dynamic>>> getMyReports() async {
    final token = await authService.getToken();

    print("MY REPORTS TOKEN => $token");

    final response = await http.get(
      Uri.parse("$baseUrl/Report/my-reports"),
      headers: {"Authorization": "Bearer $token"},
    );

    print("MY REPORTS STATUS => ${response.statusCode}");
    print("MY REPORTS BODY => ${response.body}");

    if (response.statusCode == 200) {
      return List<Map<String, dynamic>>.from(jsonDecode(response.body));
    } else {
      throw Exception("FAILED");
    }
  }

  /// GET REPORT IMAGES
  Future<List<Map<String, dynamic>>> getReportImages() async {
    final token = await authService.getToken();
    final url = Uri.parse("$baseUrl/ReportImage");
    final response = await http.get(
      url,
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $token",
      },
    );

    if (response.statusCode == 200) {
      final List data = jsonDecode(response.body);
      return data.map((e) => e as Map<String, dynamic>).toList();
    } else {
      throw Exception("فشل جلب صور البلاغات");
    }
  }

  /// إنشاء بلاغ بدون توكن
  Future<bool> createReport(ReportRequest request) async {
    final url = Uri.parse("$baseUrl/Report");
    final response = await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(request.toJson()),
    );
    return response.statusCode == 200 || response.statusCode == 201;
  }
}
