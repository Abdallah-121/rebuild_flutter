// ignore_for_file: file_names

class SupportTicket {
  final int id;
  final String title;
  final String status;
  final int userId;
  final int? cityId;
  final String? userName;
  final String? cityName;
  final String? phoneNumber;

  SupportTicket({
    required this.id,
    required this.title,
    required this.status,
    required this.userId,
    this.cityId,
    this.userName,
    this.cityName,
    this.phoneNumber,
  });

  factory SupportTicket.fromJson(Map<String, dynamic> json) {
    return SupportTicket(
      id: json['id'] ?? 0,
      title: json['title'] ?? 'غير معروف',
      status: json['status'] ?? 'غير معروف',
      userId: json['userId'] ?? 0,
      cityId: json['cityId'] != null ? json['cityId'] as int : null,
      userName: json['userName']?.toString(),
      cityName: json['cityName']?.toString(),
      phoneNumber: json['phoneNumber']?.toString(),
    );
  }
}
