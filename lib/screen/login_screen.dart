// ignore_for_file: use_build_context_synchronously
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:rebuild/Cubits/Login-Cubit/Auth Cubit Dart.dart';
import 'package:rebuild/Cubits/Login-Cubit/Auth State Dart.dart';
import 'package:rebuild/Widgets/Login%20widget/login_background.dart.dart';
import 'package:rebuild/Widgets/Login%20widget/login_card.dart.dart';
import 'package:rebuild/utils/constants.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthCubit, AuthState>(
      listener: (context, state) {
        if (state.hasError) {
          warningMessage(context, "فشل تسجيل الدخول");
        }
      },
      child: const Scaffold(
        extendBodyBehindAppBar: true,
        body: Stack(children: [LoginBackground(), LoginCard()]),
      ),
    );
  }
}
