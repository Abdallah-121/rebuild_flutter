// ignore_for_file: file_names

class SupportMessage {
  final int id;
  final int ticketId;
  final int senderId;
  final String message;
  final bool isFromAdmin;

  SupportMessage({
    required this.id,
    required this.ticketId,
    required this.senderId,
    required this.message,
    required this.isFromAdmin,
  });

  factory SupportMessage.fromJson(Map<String, dynamic> json) {
    return SupportMessage(
      id: json['id'],
      ticketId: json['ticketId'],
      senderId: json['senderId'],
      message: json['message'],
      isFromAdmin: json['isFromAdmin'],
    );
  }
}
