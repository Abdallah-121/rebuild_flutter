import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:rebuild/Widgets/SignUp%20Widget/signup_header.dart';
import 'package:rebuild/Widgets/SignUp%20Widget/signup_step_indicator.dart';
import 'package:rebuild/Widgets/SignUp%20Widget/signup_step_one.dart';
import 'package:rebuild/Widgets/SignUp%20Widget/signup_step_two.dart';
import 'package:rebuild/screen/signup_screen.dart';

class SignupCard extends StatelessWidget {
  const SignupCard({super.key});

  @override
  Widget build(BuildContext context) {
    final state = context.findAncestorStateOfType<SignUpScreenState>()!;

    return SafeArea(
      child: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(28),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 16, sigmaY: 16),
              child: Container(
                constraints: const BoxConstraints(maxWidth: 460),
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.95),
                  borderRadius: BorderRadius.circular(28),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    const SignupHeader(),
                    const SizedBox(height: 16),
                    StepIndicator(step: state.step),
                    const SizedBox(height: 20),
                    state.step == 1 ? StepOneForm(state) : StepTwoForm(state),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
