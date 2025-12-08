import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:rebuild/Api/AuthServiceDart.dart';
import 'package:rebuild/Model/comment_model.dart';

class CommentService {
  final String baseUrl = "http://216.126.239.86:5000";
  final AuthService authService = AuthService();

  Future<List<CommentModel>> getCommentsByReport(int reportId) async {
    final response = await http.get(
      Uri.parse("$baseUrl/api/Comment/report/$reportId"),
    );

    if (response.statusCode == 200) {
      final List data = jsonDecode(response.body);
      return data.map((c) => CommentModel.fromJson(c)).toList();
    } else {
      throw ("لا يوجد تعليقات بعد");
    }
  }

  /// إضافة تعليق جديد (تستخدم توكن مع تجديد تلقائي)
  Future<CommentModel> addComment({
    required int reportId,
    required String commentText,
  }) async {
    final token = await authService.getToken();
    final body = {"commentText": commentText, "reportId": reportId};

    final response = await http.post(
      Uri.parse("$baseUrl/api/Comment"),
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $token",
      },
      body: jsonEncode(body),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      return CommentModel.fromJson(jsonDecode(response.body));
    } else {
      throw Exception("Failed to add comment");
    }
  }

  /// تعديل تعليق
  Future<bool> updateComment(int commentId, String newText) async {
    final token = await authService.getToken();

    final response = await http.put(
      Uri.parse("$baseUrl/api/Comment/$commentId"),
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $token",
      },
      body: jsonEncode({"commentText": newText}),
    );

    return response.statusCode == 200;
  }

  /// حذف تعليق
  Future<bool> deleteComment(int commentId) async {
    final token = await authService.getToken();

    final response = await http.delete(
      Uri.parse("$baseUrl/api/Comment/$commentId"),
      headers: {"Authorization": "Bearer $token"},
    );

    if (response.statusCode == 200 || response.statusCode == 204) {
      return true;
    } else {
      throw Exception("فشل حذف التعليق: ${response.statusCode}");
    }
  }
}
