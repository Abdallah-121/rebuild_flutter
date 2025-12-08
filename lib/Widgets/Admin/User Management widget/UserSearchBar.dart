// ignore_for_file: file_names

import 'package:flutter/material.dart';

class UserSearchBar extends StatelessWidget {
  final ValueChanged<String> onChanged;

  const UserSearchBar({super.key, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return TextField(
      decoration: InputDecoration(
        hintText: "بحث عن مستخدم...",
        prefixIcon: const Icon(Icons.search),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        filled: true,
        fillColor: Colors.white,
      ),
      onChanged: onChanged,
    );
  }
}
