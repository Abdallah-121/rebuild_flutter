import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class IconCount extends StatelessWidget {
  final IconData icon;
  final int count;

  const IconCount(this.icon, this.count);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 18, color: Colors.grey),
        const SizedBox(width: 4),
        Text("$count", style: GoogleFonts.cairo(fontSize: 12)),
      ],
    );
  }
}
