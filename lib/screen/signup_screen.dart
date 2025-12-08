// ignore_for_file: use_build_context_synchronously, unused_element, prefer_const_literals_to_create_immutables, prefer_const_constructors
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:rebuild/Cubits/Login-Cubit/Auth Cubit Dart.dart';
import 'package:rebuild/Api/AuthServiceDart.dart';
import 'package:rebuild/Model/CityModel.dart';
import 'package:rebuild/Widgets/SignUp%20Widget/SignupBackground.dart';
import 'package:rebuild/Widgets/SignUp%20Widget/signup_card.dart.dart';
import 'package:rebuild/utils/constants.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => SignUpScreenState();
}

class SignUpScreenState extends State<SignUpScreen> {
  int step = 1;
  bool isSubmitting = false;

  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();
  final phoneController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  List<City> cities = [];
  int? selectedCityId;

  bool showPassword = false;
  bool showConfirm = false;

  final AuthService service = AuthService();

  @override
  void initState() {
    super.initState();
    loadCities();
  }

  Future<void> loadCities() async {
    try {
      final list = await service.getCities();

      if (!mounted) return;

      setState(() {
        cities = list;
        selectedCityId = cities.isNotEmpty ? cities.first.id : null;
      });
    } catch (e) {
      warningMessage(context, "فشل تحميل المدن");
    }
  }

  void nextStep() {
    final first = firstNameController.text.trim();
    final last = lastNameController.text.trim();
    final phone = phoneController.text.trim();

    if (first.isEmpty) {
      warningMessage(context, "الاسم الأول فارغ");
      return;
    }

    if (last.isEmpty) {
      warningMessage(context, "الاسم الأخير فارغ");
      return;
    }

    if (phone.isEmpty) {
      warningMessage(context, "رقم الهاتف فارغ");
      return;
    }

    if (phone.length != 10) {
      warningMessage(context, "رقم الهاتف يجب أن يكون 10 أرقام");
      return;
    }

    if (selectedCityId == null) {
      warningMessage(context, "يرجى اختيار المدينة");
      return;
    }

    setState(() => step = 2);
  }

  Future<void> createAccount() async {
    if (isSubmitting) return;

    final email = emailController.text.trim();
    final password = passwordController.text.trim();
    final confirmPassword = confirmPasswordController.text.trim();

    final emailRegex = RegExp(r'^[\w.+-]+@gmail\.com$');

    if (email.isEmpty) {
      warningMessage(context, "البريد الإلكتروني فارغ");
      return;
    }

    if (!emailRegex.hasMatch(email)) {
      warningMessage(context, "البريد الإلكتروني يجب أن يكون @gmail.com");
      return;
    }

    if (password.isEmpty) {
      warningMessage(context, "كلمة المرور فارغة");
      return;
    }

    if (password.length < 7) {
      warningMessage(context, "كلمة المرور يجب أن تكون 7 أحرف على الأقل");
      return;
    }

    if (confirmPassword.isEmpty) {
      warningMessage(context, "تأكيد كلمة المرور فارغ");
      return;
    }

    if (password != confirmPassword) {
      warningMessage(context, "كلمة المرور وتأكيدها غير متطابقين");
      return;
    }

    setState(() => isSubmitting = true);

    final authCubit = context.read<AuthCubit>();

    try {
      await authCubit.signUp(
        first: firstNameController.text.trim(),
        last: lastNameController.text.trim(),
        email: email,
        password: password,
        phone: phoneController.text.trim(),
        cityId: selectedCityId!,
      );

      if (!mounted) return;

      warningMessage(context, "✅ تم إنشاء الحساب بنجاح");
      Navigator.pushReplacementNamed(context, '/login');
    } catch (_) {
      warningMessage(context, "فشل إنشاء الحساب");
    } finally {
      if (mounted) setState(() => isSubmitting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: Stack(children: [SignupBackground(), SignupCard()]));
  }
}
