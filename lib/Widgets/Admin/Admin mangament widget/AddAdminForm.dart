// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:rebuild/utils/constants.dart';

class AddAdminForm extends StatefulWidget {
  final Function(String) onAdd;

  const AddAdminForm({required this.onAdd, super.key});

  @override
  State<AddAdminForm> createState() => _AddAdminFormState();
}

class _AddAdminFormState extends State<AddAdminForm> {
  final TextEditingController _controller = TextEditingController();

  void _submit() {
    final name = _controller.text.trim();
    if (name.isNotEmpty) {
      widget.onAdd(name);
      _controller.clear();
      warningMessage(context, 'تم إضافة مشرف جديد ✅');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _controller,
              decoration: InputDecoration(
                hintText: "اسم المشرف الجديد",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ),
          const SizedBox(width: 10),
          ElevatedButton(
            onPressed: _submit,
            style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
            child: const Text("إضافة"),
          ),
        ],
      ),
    );
  }
}
