import 'package:flutter/material.dart';

class StatusDot extends StatelessWidget {
  final String status;
  const StatusDot(this.status);

  @override
  Widget build(BuildContext context) {
    late Color color;

    switch (status) {
      case "Done":
        color = Colors.green;
        break;
      case "InProgress":
        color = Colors.orange;
        break;
      default:
        color = Colors.grey;
    }

    return Column(
      children: [
        Container(
          width: 14,
          height: 14,
          decoration: BoxDecoration(shape: BoxShape.circle, color: color),
        ),
        Container(width: 2, height: 90, color: color.withOpacity(.3)),
      ],
    );
  }
}
