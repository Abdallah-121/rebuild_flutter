import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:rebuild/utils/constants.dart';

class LoginForm extends StatelessWidget {
  final TextEditingController emailController;
  final TextEditingController passwordController;
  final bool showPassword;
  final bool loading;
  final VoidCallback onTogglePassword;
  final VoidCallback onLogin;

  const LoginForm({
    super.key,
    required this.emailController,
    required this.passwordController,
    required this.showPassword,
    required this.loading,
    required this.onTogglePassword,
    required this.onLogin,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _input("البريد الإلكتروني", Icons.email_outlined, emailController),
        const SizedBox(height: 16),
        TextField(
          controller: passwordController,
          obscureText: !showPassword,
          textAlign: TextAlign.right,
          decoration: InputDecoration(
            labelText: "كلمة المرور",
            prefixIcon: const Icon(Icons.lock_outline),
            suffixIcon: IconButton(
              icon: Icon(
                showPassword ? Icons.visibility : Icons.visibility_off,
              ),
              onPressed: onTogglePassword,
            ),
            filled: true,
            fillColor: Colors.grey.shade50,
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
          ),
        ),
        const SizedBox(height: 30),
        SizedBox(
          width: double.infinity,
          height: 52,
          child: ElevatedButton.icon(
            onPressed: loading ? null : onLogin,
            icon: loading
                ? const SizedBox(
                    width: 18,
                    height: 18,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: Colors.white,
                    ),
                  )
                : const Icon(Icons.login),
            label: Text(
              loading ? "جارٍ الدخول..." : "دخول",
              style: GoogleFonts.cairo(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primaryDark,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(18),
              ),
            ),
          ),
        ),
        const SizedBox(height: 14),
        TextButton(
          onPressed: () => Navigator.pushReplacementNamed(context, '/signup'),
          child: Text(
            "إنشاء حساب جديد",
            style: GoogleFonts.cairo(
              fontWeight: FontWeight.w700,
              color: AppColors.primaryDark,
            ),
          ),
        ),
      ],
    );
  }

  Widget _input(String label, IconData icon, TextEditingController controller) {
    return TextField(
      controller: controller,
      textAlign: TextAlign.right,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon),
        filled: true,
        fillColor: Colors.grey.shade50,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
      ),
    );
  }
}
