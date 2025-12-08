import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:rebuild/utils/constants.dart';

class ReportMetaRow extends StatelessWidget {
  final String type;
  final String cityName;
  final String date;

  const ReportMetaRow({
    super.key,
    required this.type,
    required this.cityName,
    required this.date,
  });

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Row(
        children: [
          Expanded(
            child: _MetaItem(icon: Icons.category_outlined, label: type),
          ),
          Expanded(
            child: _MetaItem(icon: Icons.location_on_outlined, label: cityName),
          ),
          Expanded(
            child: _MetaItem(
              icon: Icons.event_outlined,
              label: _formatDate(date),
            ),
          ),
        ],
      ),
    );
  }

  /// ✅ تنسيق التاريخ (بدون T و UTC)
  String _formatDate(String raw) {
    if (raw.isEmpty) return "—";
    try {
      final dt = DateTime.parse(raw).toLocal();
      return "${dt.day.toString().padLeft(2, '0')}/"
          "${dt.month.toString().padLeft(2, '0')}/"
          "${dt.year}";
    } catch (_) {
      return raw;
    }
  }
}

class _MetaItem extends StatelessWidget {
  final IconData icon;
  final String label;

  const _MetaItem({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Icon(icon, size: 18, color: AppColors.textSecondary),
        const SizedBox(width: 6),
        Expanded(
          child: Text(
            label,
            overflow: TextOverflow.ellipsis,
            style: GoogleFonts.cairo(
              fontSize: 13,
              color: AppColors.textSecondary,
            ),
          ),
        ),
      ],
    );
  }
}
