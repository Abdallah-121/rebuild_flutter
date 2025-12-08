import 'package:flutter/material.dart';
import 'package:rebuild/Widgets/Login%20widget/AuthInputField.dart';
import 'package:rebuild/Widgets/SignUp%20Widget/auth_action_button.dart';
import 'package:rebuild/screen/signup_screen.dart';
import 'package:rebuild/utils/constants.dart';

class StepOneForm extends StatelessWidget {
  final SignUpScreenState s;
  const StepOneForm(this.s, {super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        AuthInputField(
          icon: Icons.person,
          hint: "الاسم الأول",
          controller: s.firstNameController,
        ),
        AuthInputField(
          icon: Icons.person,
          hint: "الاسم الأخير",
          controller: s.lastNameController,
        ),
        AuthInputField(
          icon: Icons.call,
          hint: "رقم الهاتف (09XXXXXXXX)",
          controller: s.phoneController,
        ),
        DropdownButtonFormField<int>(
          value: s.selectedCityId,
          items: s.cities
              .map((c) => DropdownMenuItem(value: c.id, child: Text(c.name)))
              .toList(),
          onChanged: (v) => s.setState(() => s.selectedCityId = v),
          decoration: const InputDecoration(labelText: "المدينة"),
        ),
        const SizedBox(height: 20),
        AuthActionButton(
          isLogin: false,
          isLoading: false,
          onPressed: s.nextStep,
        ),
        const SizedBox(height: 12),

        TextButton(
          onPressed: () {
            Navigator.pushReplacementNamed(context, '/login');
          },
          child: const Text(
            "لديك حساب؟ تسجيل دخول",
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
