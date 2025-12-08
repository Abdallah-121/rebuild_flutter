import 'package:flutter/material.dart';

class ReportActionsSection extends StatelessWidget {
  final int reportId;
  const ReportActionsSection({super.key, required this.reportId});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: OutlinedButton.icon(
            icon: const Icon(Icons.comment),
            label: const Text("التعليقات"),
            onPressed: () {},
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: ElevatedButton.icon(
            icon: const Icon(Icons.volunteer_activism),
            label: const Text("تبرع"),
            onPressed: () {},
          ),
        ),
      ],
    );
  }
}
