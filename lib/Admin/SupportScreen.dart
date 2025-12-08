// ignore_for_file: file_names, no_leading_underscores_for_local_identifiers

import 'package:flutter/material.dart';
import 'package:rebuild/Widgets/Admin/Support%20Messages%20List/SupportMessagesList.dart';

class SupportScreen extends StatefulWidget {
  const SupportScreen({super.key});

  @override
  State<SupportScreen> createState() => _SupportScreenState();
}

class _SupportScreenState extends State<SupportScreen> {
  final List<Map<String, dynamic>> _messages = [
    {"subject": "مشكلة في التطبيق", "content": "الخرائط لا تعمل عندي"},
    {"subject": "اقتراح", "content": "إضافة ميزة التبرع التلقائي"},
  ]; // مثال بيانات مؤقتة

  void _replyToMessage(Map<String, dynamic> msg) {
    // يمكن فتح Dialog للرد لاحقًا
    showDialog(
      context: context,
      builder: (context) {
        final TextEditingController _replyController = TextEditingController();
        return AlertDialog(
          title: Text(
            "الرد على: ${msg['subject']}",
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          content: TextField(
            controller: _replyController,
            decoration: const InputDecoration(hintText: "اكتب ردك هنا..."),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("إلغاء"),
            ),
            ElevatedButton(
              onPressed: () {
                // هنا يمكن إرسال الرد للباك إند لاحقًا
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text("تم إرسال الرد: ${_replyController.text}"),
                  ),
                );
                Navigator.pop(context);
              },
              child: const Text("إرسال"),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return SupportMessagesList(messages: _messages, onReply: _replyToMessage);
  }
}
