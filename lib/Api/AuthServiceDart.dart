// ignore_for_file: file_names, avoid_print, unnecessary_null_comparison

import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:rebuild/Model/CityModel.dart';
import 'package:rebuild/Model/UserModel.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:jwt_decoder/jwt_decoder.dart';

class AuthService {
  final String baseUrl = "http://216.126.239.86:5000";

  static const _keyToken = 'auth_token';
  static const _keyRefreshToken = 'refresh_token';
  static const _keyExpiresOn = 'expires_on';

  // -------------------------
  // 🔹 حفظ بيانات Auth (token + refreshToken + expiresOn)
  // -------------------------
  Future<void> saveAuthData({
    required String token,
    required String refreshToken,
    required String expiresOn,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyToken, token);
    await prefs.setString(_keyRefreshToken, refreshToken);
    await prefs.setString(_keyExpiresOn, expiresOn);
  }

  Future<void> clearAuthData() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_keyToken);
    await prefs.remove(_keyRefreshToken);
    await prefs.remove(_keyExpiresOn);
  }

  /// دالة ديباغ: تطبع التوكن والـ decoded map في الـ console
  Future<void> debugPrintDecodedToken() async {
    final token = await getTokenRaw();
    debugPrint('--- DEBUG JWT token start ---');
    debugPrint('token: $token');
    if (token.isEmpty) {
      debugPrint('token is empty');
      debugPrint('--- DEBUG JWT token end ---');
      return;
    }

    try {
      final decoded = JwtDecoder.decode(token);
      debugPrint('decoded token keys and values:');
      decoded.forEach((k, v) => debugPrint('  $k : $v'));
    } catch (e) {
      debugPrint('Failed to decode token: $e');
    }
    debugPrint('--- DEBUG JWT token end ---');
  }

  Future<String> getUserNameFromToken() async {
    final token = await getToken();
    if (token.isEmpty) return 'UNKNOWN USER';

    Map<String, dynamic> decoded;
    try {
      decoded = JwtDecoder.decode(token);
    } catch (e) {
      return 'UNKNOWN USER';
    }

    final possibleKeys = [
      'name',
      'Name',
      'username',
      'userName',
      'UserName',
      'unique_name',
      'email',
      'given_name',
      'family_name',
      'givenName',
      'givenname',
      'fullName',
      'full_name',
      'fullname',
      'http://schemas.xmlsoap.org/ws/2005/05/identity/claims/name',
      'http://schemas.xmlsoap.org/ws/2005/05/identity/claims/nameidentifier',
      'http://schemas.microsoft.com/ws/2008/06/identity/claims/windowsaccountname',
      'sub',
    ];

    for (final key in possibleKeys) {
      if (decoded.containsKey(key)) {
        final val = decoded[key];
        if (val != null) {
          final s = val.toString().trim();
          if (s.isNotEmpty) return s;
        }
      }
    }

    for (final entry in decoded.entries) {
      final v = entry.value;
      if (v is String && v.trim().isNotEmpty) return v.trim();
      if (v is Map) {
        for (final inner in v.entries) {
          final iv = inner.value;
          if (iv is String && iv.trim().isNotEmpty) return iv.trim();
        }
      }
    }

    try {
      final id = await getUserIdFromToken();
      if (id != 0) {
        final user = await getUserById(id);
        if (user != null) {
          final name = user.fullName;
          if (name.isNotEmpty) return name;
        }
      }
    } catch (_) {}

    return 'UNKNOWN USER';
  }

  Future<String> _getStoredRefreshToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_keyRefreshToken) ?? '';
  }

  Future<String> _getStoredExpiresOn() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_keyExpiresOn) ?? '';
  }

  // --------------------- API: Cities ---------------------
  Future<List<City>> getCities() async {
    final response = await http.get(Uri.parse("$baseUrl/api/City"));
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body) as List;
      return data.map((e) => City.fromJson(e)).toList();
    } else {
      throw Exception("Failed to load cities");
    }
  }

  // --------------------- API: User by Id ---------------------
  Future<UserModel?> getUserById(int userId) async {
    final token = await getToken();
    if (token.isEmpty) return null;

    final response = await http.get(
      Uri.parse("$baseUrl/api/User/$userId"),
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $token",
      },
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return UserModel.fromJson(data);
    }

    return null;
  }

  /// مسح التوكن (موجودة للتوافق مع الكود القديم)
  Future<void> clearToken() async => clearAuthData();

  // --------------------- API: SignUp ---------------------
  Future<bool> signUp({
    required String firstName,
    required String lastName,
    required String email,
    required String password,
    required int cityId,
    required String phone,
  }) async {
    final url = Uri.parse("$baseUrl/api/Auth/register");
    final body = {
      "firstName": firstName,
      "lastName": lastName,
      "email": email,
      "password": password,
      "cityId": cityId,
      "role": "User",
      "phoneNumber": phone,
    };

    final response = await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(body),
    );

    return response.statusCode == 200 || response.statusCode == 201;
  }

  // --------------------- API: Login ---------------------
  Future<Map<String, dynamic>> login({
    required String email,
    required String password,
  }) async {
    final url = Uri.parse("$baseUrl/api/Auth/login");
    final body = {"email": email, "password": password};

    final response = await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(body),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);

      if (data['token'] != null &&
          data['refreshToken'] != null &&
          data['expiresOn'] != null) {
        await saveAuthData(
          token: data['token'],
          refreshToken: data['refreshToken'],
          expiresOn: data['expiresOn'],
        );
      }

      return data;
    } else {
      throw Exception(response.body);
    }
  }

  // --------------------- API: Refresh Token ---------------------
  Future<bool> refreshAuthToken() async {
    final refreshToken = await _getStoredRefreshToken();
    final token = await getTokenRaw();
    if (refreshToken.isEmpty) return false;

    final url = Uri.parse("$baseUrl/api/Auth/refresh-token");
    final payload = {
      "refreshToken": refreshToken,
      if (token.isNotEmpty) "token": token,
      if (token.isNotEmpty) "accessToken": token,
    };

    final response = await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(payload),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);

      final newToken = (data['token'] ?? data['accessToken'] ?? '').toString();
      final newRefreshToken =
          (data['refreshToken'] ?? data['newRefreshToken'] ?? '').toString();
      final newExpiresOn =
          (data['expiresOn'] ?? data['expiration'] ?? '').toString();

      if (newToken.isNotEmpty &&
          newRefreshToken.isNotEmpty &&
          newExpiresOn.isNotEmpty) {
        await saveAuthData(
          token: newToken,
          refreshToken: newRefreshToken,
          expiresOn: newExpiresOn,
        );
        return true;
      }
    }

    // نمسح الجلسة فقط لو السيرفر رفض بشكل صريح (Unauthorized/Forbidden)
    if (response.statusCode == 401 || response.statusCode == 403) {
      await clearAuthData();
    }

    return false;
  }

  // --------------------- Token Helpers ---------------------
  /// يرجع التوكن كما هو من التخزين بدون أي فحص أو ريفرش
  Future<String> getTokenRaw() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_keyToken) ?? '';
  }


  bool isTokenExpired(String token) {
    if (token.isEmpty) return true;
    try {
      return JwtDecoder.isExpired(token);
    } catch (_) {
      return true;
    }
  }

  /// جلب التوكن (مع تجديد تلقائي إذا انتهت صلاحيته)
  Future<String> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString(_keyToken) ?? '';
    if (token.isEmpty) return '';

    final isExpired = JwtDecoder.isExpired(token);
    if (!isExpired) return token;

    final refreshed = await refreshAuthToken();
    if (!refreshed) return '';

    return (await SharedPreferences.getInstance()).getString(_keyToken) ?? '';
  }

  Future<int> getUserIdFromToken() async {
    final token = await getToken();
    if (token.isEmpty) return 0;

    final decoded = JwtDecoder.decode(token);
    return int.tryParse(
          decoded["http://schemas.xmlsoap.org/ws/2005/05/identity/claims/nameidentifier"] ??
              '',
        ) ??
        0;
  }

  // --------------------- API: Current User ---------------------
  Future<UserModel?> getCurrentUserFull() async {
    final token = await getToken();
    if (token.isEmpty) return null;

    final decoded = JwtDecoder.decode(token);
    final userId =
        int.tryParse(
          decoded["http://schemas.xmlsoap.org/ws/2005/05/identity/claims/nameidentifier"] ??
              '',
        ) ??
        0;

    if (userId == 0) return null;

    final response = await http.get(
      Uri.parse("$baseUrl/api/User/$userId"),
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $token",
      },
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return UserModel.fromJson(data);
    }

    return null;
  }

  // --------------------- API: Update User ---------------------
  Future<bool> updateUser({
    required int id,
    required String firstName,
    required String lastName,
    required String email,
    required int cityId,
    required String phoneNumber,
  }) async {
    final token = await getToken();
    if (token.isEmpty) return false;

    final response = await http.put(
      Uri.parse('$baseUrl/api/User/$id'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode({
        'firstName': firstName,
        'lastName': lastName,
        'email': email,
        'cityId': cityId,
        'phoneNumber': phoneNumber,
      }),
    );

    return response.statusCode == 204;
  }

  // --------------------- API: Delete User ---------------------
  Future<bool> deleteUser({required int id}) async {
    final token = await getToken();
    if (token.isEmpty) return false;

    final response = await http.delete(
      Uri.parse('$baseUrl/api/User/$id'),
      headers: {'Authorization': 'Bearer $token'},
    );

    return response.statusCode == 204;
  }

  // --------------------- API: Change Password ---------------------
  Future<bool> changePassword({
    required String currentPassword,
    required String newPassword,
  }) async {
    final token = await getToken();
    if (token.isEmpty) return false;

    final response = await http.post(
      Uri.parse('$baseUrl/api/User/change-password'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode({
        'currentPassword': currentPassword,
        'newPassword': newPassword,
      }),
    );

    print('ChangePassword Status: ${response.statusCode}');
    print('ChangePassword Body: ${response.body}');

    return response.statusCode >= 200 && response.statusCode < 300;
  }
}
