import 'package:flutter/material.dart';

class CurrentLocationButton extends StatelessWidget {
  final bool isLoading;
  final VoidCallback onPressed;

  const CurrentLocationButton({
    super.key,
    required this.isLoading,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        onPressed: isLoading ? null : onPressed,
        icon: isLoading
            ? const SizedBox(
                width: 18,
                height: 18,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: Colors.white,
                ),
              )
            : const Icon(Icons.my_location),
        label: Text(isLoading ? "جاري تحديد الموقع..." : "تحديد موقعي الحالي"),
      ),
    );
  }
}
