import 'package:flutter/material.dart';

class ReportTitleSection extends StatelessWidget {
  final String? title;
  final String? status;

  const ReportTitleSection({super.key, this.title, this.status});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        StatusChip(status: status),
        const Spacer(),
        Expanded(
          flex: 4,
          child: Text(
            title ?? "بلاغ بدون عنوان",
            textAlign: TextAlign.right,
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
        ),
      ],
    );
  }
}

/// ✅ هذا كان ناقص
class StatusChip extends StatelessWidget {
  final String? status;
  const StatusChip({super.key, this.status});

  @override
  Widget build(BuildContext context) {
    Color color;
    String text;

    switch (status) {
      case 'Done':
        color = Colors.green;
        text = 'منجزة';
        break;
      case 'InProgress':
        color = Colors.orange;
        text = 'قيد المعالجة';
        break;
      default:
        color = Colors.blue;
        text = 'قيد الانتظار';
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: color.withOpacity(0.15),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: color,
          fontWeight: FontWeight.bold,
          fontSize: 13,
        ),
      ),
    );
  }
}
