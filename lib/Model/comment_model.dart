class CommentModel {
  final int commentId;
  final String commentText;
  final String createdAt;
  final int userId;
  final String userName;
  final int reportId;

  CommentModel({
    required this.commentId,
    required this.commentText,
    required this.createdAt,
    required this.userId,
    required this.userName,
    required this.reportId,
  });

  factory CommentModel.fromJson(Map<String, dynamic> json) {
    return CommentModel(
      commentId: json["commentId"],
      commentText: json["commentText"],
      createdAt: DateTime.parse(
        json["createdAt"],
      ).toUtc().toLocal().toIso8601String(),
      userId: json["userId"],
      userName: json["userName"],
      reportId: json["reportId"],
    );
  }
}
