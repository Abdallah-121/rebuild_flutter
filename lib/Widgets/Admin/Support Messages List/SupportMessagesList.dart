// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SupportMessagesList extends StatelessWidget {
  final List<Map<String, dynamic>> messages;
  final Function(Map<String, dynamic>) onReply;

  const SupportMessagesList({
    required this.messages,
    required this.onReply,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    if (messages.isEmpty) {
      return Center(
        child: Text(
          "لا توجد رسائل حالياً",
          style: GoogleFonts.cairo(fontSize: 16),
        ),
      );
    }

    return ListView.builder(
      itemCount: messages.length,
      itemBuilder: (context, index) {
        final msg = messages[index];
        return Card(
          margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 12),
          child: ListTile(
            leading: const Icon(Icons.message, color: Colors.blue),
            title: Text(
              msg['subject'] ?? "بدون عنوان",
              style: GoogleFonts.cairo(),
            ),
            subtitle: Text(msg['content'] ?? "", style: GoogleFonts.cairo()),
            trailing: ElevatedButton(
              onPressed: () => onReply(msg),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: Text("رد", style: GoogleFonts.cairo(fontSize: 14)),
            ),
          ),
        );
      },
    );
  }
}
