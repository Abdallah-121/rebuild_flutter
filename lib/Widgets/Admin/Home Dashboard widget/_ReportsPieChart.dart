// ignore_for_file: file_names

import 'package:flutter/material.dart';

class ReportsPieChart extends StatelessWidget {
  final List<Map<String, dynamic>> data;

  const ReportsPieChart({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 200,
      child: CustomPaint(painter: _PieChartPainter(data: data)),
    );
  }
}

class _PieChartPainter extends CustomPainter {
  final List<Map<String, dynamic>> data;

  _PieChartPainter({required this.data});

  @override
  void paint(Canvas canvas, Size size) {
    final total = data.fold<double>(
      0,
      (sum, e) => sum + (e['value'] as double),
    );
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width < size.height ? size.width / 2 : size.height / 2;
    final paint = Paint()..style = PaintingStyle.fill;

    double startRadian = -3.1415926535 / 2; // البداية من الأعلى

    for (var d in data) {
      final sweepRadian = ((d['value'] as double) / total) * 2 * 3.1415926535;
      paint.color = d['color'] as Color;
      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius),
        startRadian,
        sweepRadian,
        true,
        paint,
      );
      startRadian += sweepRadian;
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

final exampleData = [
  {'value': 45.0, 'color': Colors.green},
  {'value': 60.0, 'color': Colors.orange},
  {'value': 15.0, 'color': Colors.red},
];
