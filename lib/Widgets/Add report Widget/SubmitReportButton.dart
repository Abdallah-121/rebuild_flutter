import 'package:flutter/material.dart';

class SubmitReportButton extends StatelessWidget {
  final bool isLoading;
  final VoidCallback onPressed;

  const SubmitReportButton({
    super.key,
    required this.isLoading,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 50,
      child: ElevatedButton(
        onPressed: isLoading ? null : onPressed,
        child: isLoading
            ? const CircularProgressIndicator(color: Colors.white)
            : const Text(
                "إرسال البلاغ",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
      ),
    );
  }
}
