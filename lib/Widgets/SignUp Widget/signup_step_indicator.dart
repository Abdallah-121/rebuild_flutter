import 'package:flutter/material.dart';
import 'package:rebuild/utils/constants.dart';

class StepIndicator extends StatelessWidget {
  final int step;
  const StepIndicator({super.key, required this.step});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [_dot(step == 1), const SizedBox(width: 8), _dot(step == 2)],
    );
  }

  Widget _dot(bool active) {
    return Container(
      width: 10,
      height: 10,
      decoration: BoxDecoration(
        color: active ? AppColors.primaryDark : Colors.grey.shade300,
        shape: BoxShape.circle,
      ),
    );
  }
}
