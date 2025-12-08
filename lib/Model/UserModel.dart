// ignore_for_file: file_names

class UserModel {
  final int userId;
  final String fullName;
  final String email;
  final String phoneNumber;
  String role;
  final String cityName;
  final int reportsCount;
  final int commentsCount;
  final int donationsCount;

  bool isBanned; // رح نضيفها للواجهة فقط

  UserModel({
    required this.userId,
    required this.fullName,
    required this.email,
    required this.phoneNumber,
    required this.role,
    required this.cityName,
    required this.reportsCount,
    required this.commentsCount,
    required this.donationsCount,
    this.isBanned = false,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      userId: json['userId'],
      fullName: json['fullName'],
      email: json['email'],
      phoneNumber: json['phoneNumber'] ?? "",
      role: json['role'],
      cityName: json['cityName'] ?? "",
      reportsCount: json['reportsCount'] ?? 0,
      commentsCount: json['commentsCount'] ?? 0,
      donationsCount: json['donationsCount'] ?? 0,
      isBanned: json['isBanned'] ?? false,
    );
  }
}
