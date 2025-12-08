// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AdminsList extends StatelessWidget {
  final List<String> admins;
  final Function(String) onRemove;

  const AdminsList({required this.admins, required this.onRemove, super.key});

  @override
  Widget build(BuildContext context) {
    if (admins.isEmpty) {
      return Center(
        child: Text(
          "لا يوجد مشرفون بعد",
          style: GoogleFonts.cairo(fontSize: 16),
        ),
      );
    }

    return ListView.builder(
      itemCount: admins.length,
      itemBuilder: (context, index) {
        final admin = admins[index];
        return Card(
          margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 12),
          child: ListTile(
            leading: const Icon(Icons.admin_panel_settings, color: Colors.blue),
            title: Text(admin, style: GoogleFonts.cairo()),
            trailing: IconButton(
              icon: const Icon(Icons.delete, color: Colors.red),
              onPressed: () => onRemove(admin),
            ),
          ),
        );
      },
    );
  }
}
