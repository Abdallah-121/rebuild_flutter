// ignore_for_file: file_names

import 'package:flutter/material.dart';

class UserFilterMenu extends StatelessWidget {
  final String selectedRole;
  final ValueChanged<String> onChanged;

  const UserFilterMenu({
    super.key,
    required this.selectedRole,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Text("الفرز حسب الدور:  "),
        DropdownButton<String>(
          value: selectedRole,
          items: const [
            DropdownMenuItem(value: "الكل", child: Text("الكل")),
            DropdownMenuItem(value: "User", child: Text("مستخدم")),
            DropdownMenuItem(value: "Admin", child: Text("مشرف")),
          ],
          onChanged: (val) {
            if (val != null) onChanged(val);
          },
        ),
      ],
    );
  }
}
