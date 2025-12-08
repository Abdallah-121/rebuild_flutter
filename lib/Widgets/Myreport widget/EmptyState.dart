import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class EmptySmartState extends StatelessWidget {
  const EmptySmartState();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.inbox, size: 64, color: Colors.grey),
          const SizedBox(height: 12),
          Text(
            "لم تقم بإضافة أي بلاغ بعد",
            style: GoogleFonts.cairo(fontSize: 16),
          ),
        ],
      ),
    );
  }
}
