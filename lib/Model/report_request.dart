class ReportRequest {
  final String title;
  final String description;
  final int categoryId;
  final int cityId;
  final int? estimatedCost;
  final double? latitude;
  final double? longitude;
  final List<String> imagesBase64;

  ReportRequest({
    required this.title,
    required this.description,
    required this.categoryId,
    required this.cityId,
    this.estimatedCost,
    this.latitude,
    this.longitude,
    required this.imagesBase64,
  });

  Map<String, dynamic> toJson() {
    return {
      "title": title,
      "description": description,
      "estimatedCost": estimatedCost ?? 0,
      "categoryId": categoryId,
      "cityId": cityId,
      "latitude": latitude ?? 0,
      "longitude": longitude ?? 0,
      "imagesBase64": imagesBase64,
    };
  }
}
