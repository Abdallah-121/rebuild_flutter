import 'package:flutter/material.dart';
import 'package:rebuild/Widgets/Login%20widget/AuthInputField.dart';
import 'package:rebuild/Widgets/SignUp%20Widget/auth_action_button.dart';
import 'package:rebuild/screen/signup_screen.dart';
import 'package:rebuild/utils/constants.dart';

class StepTwoForm extends StatelessWidget {
  final SignUpScreenState s;
  const StepTwoForm(this.s, {super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        AuthInputField(
          icon: Icons.email,
          hint: "البريد الإلكتروني",
          controller: s.emailController,
        ),
        AuthInputField(
          icon: Icons.lock,
          hint: "كلمة المرور",
          controller: s.passwordController,
          obscure: !s.showPassword,
          suffixIcon: IconButton(
            icon: Icon(
              s.showPassword ? Icons.visibility : Icons.visibility_off,
            ),
            onPressed: () => s.setState(() => s.showPassword = !s.showPassword),
          ),
        ),
        AuthInputField(
          icon: Icons.lock,
          hint: "تأكيد كلمة المرور",
          controller: s.confirmPasswordController,
          obscure: !s.showConfirm,
          suffixIcon: IconButton(
            icon: Icon(s.showConfirm ? Icons.visibility : Icons.visibility_off),
            onPressed: () => s.setState(() => s.showConfirm = !s.showConfirm),
          ),
        ),
        const SizedBox(height: 20),
        AuthActionButton(
          isLogin: false,
          isLoading: s.isSubmitting,
          onPressed: s.createAccount,
        ),
        TextButton(
          onPressed: () => s.setState(() => s.step = 1),
          child: const Text("العودة"),
        ),

        const SizedBox(height: 12),

        TextButton(
          onPressed: () {
            Navigator.pushReplacementNamed(context, '/login');
          },
          child: const Text(
            "لديك حساب بالفعل؟ تسجيل دخول",
            style: TextStyle(
              fontSize: 14,
              color: AppColors.primaryDark,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }
}
