// ignore_for_file: use_build_context_synchronously, avoid_print, use_rethrow_when_possible, depend_on_referenced_packages, file_names

import 'dart:convert';
import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:rebuild/Api/AuthServiceDart.dart';
import 'package:rebuild/Cubits/AdminCubit/UserState.dart';
import 'package:rebuild/Model/UserModel.dart';
import 'package:rebuild/utils/constants.dart';

class UsersCubit extends Cubit<UsersState> {
  UsersCubit(this.authService) : super(UsersInitial());
  final AuthService authService;

  final String api = "http://216.126.239.86:5000/api/User";

  // ============================================
  // 🔹 1) جلب المستخدمين مع التوكن
  // ============================================
  Future<void> fetchUsers() async {
    emit(UsersLoading());

    try {
      final token = await authService.getToken();

      final response = await http.get(
        Uri.parse(api),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token",
        },
      );

      if (response.statusCode == 200) {
        final List data = jsonDecode(response.body);

        final users = data
            .map((e) => UserModel.fromJson(e as Map<String, dynamic>))
            .toList();

        emit(UsersLoaded(users));
      } else {
        emit(
          UsersError("فشل في تحميل المستخدمين (كود: ${response.statusCode})"),
        );
      }
    } catch (e) {
      emit(UsersError("خطأ في الاتصال بالسيرفر"));
    }
  }

  // ============================================
  // 🔹 2) حظر / فك حظر المستخدم
  // ============================================
  Future<void> toggleBan(int userId) async {
    if (state is! UsersLoaded) return;

    try {
      final token = await authService.getToken();
      final response = await http.patch(
        Uri.parse("$api/ban"),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token",
        },
        body: jsonEncode({"targetUserId": userId, "reason": "إدارة النظام"}),
      );

      if (response.statusCode == 200) {
        print("BAN SUCCESS: ${response.body}");
        // جلب المستخدمين من السيرفر بعد التغيير لضمان تحديث الحالة
        await fetchUsers();
      } else {
        print("BAN FAILED: ${response.statusCode} | ${response.body}");
      }
    } catch (e) {
      print("BAN ERROR: $e");
    }
  }

  // ============================================
  // 🔹 3) حذف المستخدم نهائياً
  // ============================================
  Future<void> deleteUser(int userId, [BuildContext? context]) async {
    if (state is! UsersLoaded) return;

    final current = (state as UsersLoaded).users;
    final token = await authService.getToken();

    try {
      final response = await http.delete(
        Uri.parse("$api/$userId"),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token",
        },
      );

      if (response.statusCode == 200 || response.statusCode == 204) {
        current.removeWhere((u) => u.userId == userId);
        emit(UsersLoaded(List.from(current)));
      } else {
        if (context != null && response.statusCode == 403) {
          warningMessage(context, "ليس لديك الصلاحيات الكافية لحذف المستخدم");
        }
      }
    } catch (e) {
      print("DELETE USER ERROR: $e");
    }
  }

  // 🔹 4) ترقية المستخدم إلى Admin
  Future<void> updateUserRole(int userId, String newRole) async {
    if (state is! UsersLoaded) return;

    try {
      final token = await authService.getToken();
      final response = await http.patch(
        Uri.parse("$api/update-role"),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token",
        },
        body: jsonEncode({"targetUserId": userId, "newRole": newRole}),
      );

      if (response.statusCode == 200) {
        print("ROLE UPDATE SUCCESS: ${response.body}");
        // جلب المستخدمين من السيرفر لضمان تحديث الواجهة
        await fetchUsers();
      } else {
        print("ROLE UPDATE FAILED: ${response.statusCode} | ${response.body}");
        throw Exception("فشل ترقية المستخدم");
      }
    } catch (e) {
      print("ROLE UPDATE ERROR: $e");
      throw e;
    }
  }

  // 🔹 5) إزالة صلاحية Admin وإرجاع المستخدم إلى User
  Future<void> downgradeAdminToUser(int userId) async {
    if (state is! UsersLoaded) return;

    try {
      final token = await authService.getToken();
      final response = await http.patch(
        Uri.parse("$api/update-role"),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token",
        },
        body: jsonEncode({"targetUserId": userId, "newRole": "User"}),
      );

      if (response.statusCode == 200) {
        print("ROLE DOWNGRADE SUCCESS: ${response.body}");
        await fetchUsers(); // تحديث الواجهة بعد التغيير
      } else {
        print(
          "ROLE DOWNGRADE FAILED: ${response.statusCode} | ${response.body}",
        );
        throw Exception("فشل إعادة المستخدم إلى User");
      }
    } catch (e) {
      print("ROLE DOWNGRADE ERROR: $e");
      throw e;
    }
  }
}
