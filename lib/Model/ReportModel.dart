// ignore_for_file: file_names

class ReportModel {
  final int reportId;
  final String title;
  final String description;
  final int estimatedCost;
  final String status;
  final DateTime createdAt;
  final double? latitude;
  final double? longitude;
  final int likesCount;
  final int userId;
  final String userName;
  final String categoryName;
  final String cityName;
  final int commentCount;
  final List<String> images;
  final int totalCollectedAmount;
  final bool hasDonationCase;

  ReportModel({
    required this.reportId,
    required this.title,
    required this.description,
    required this.estimatedCost,
    required this.status,
    required this.createdAt,
    this.latitude,
    this.longitude,
    required this.likesCount,
    required this.userId,
    required this.userName,
    required this.categoryName,
    required this.cityName,
    required this.commentCount,
    required this.images,
    required this.totalCollectedAmount,
    required this.hasDonationCase,
  });

  factory ReportModel.fromJson(Map<String, dynamic> json) {
    return ReportModel(
      reportId: json['reportId'],
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      estimatedCost: json['estimatedCost'] ?? 0,
      status: json['status'] ?? '',
      createdAt: DateTime.parse(json['createdAt']),
      latitude: json['latitude'] != null
          ? (json['latitude'] as num).toDouble()
          : null,
      longitude: json['longitude'] != null
          ? (json['longitude'] as num).toDouble()
          : null,
      likesCount: json['likesCount'] ?? 0,
      userId: json['userId'] ?? 0,
      userName: json['userName'] ?? '',
      categoryName: json['categoryName'] ?? '',
      cityName: json['cityName'] ?? '',
      commentCount: json['commentCount'] ?? 0,
      images: (json['images'] ?? []).map<String>((e) => e.toString()).toList(),
      totalCollectedAmount: json['totalCollectedAmount'] ?? 0,
      hasDonationCase: json['hasDonationCase'] ?? false,
    );
  }
}
