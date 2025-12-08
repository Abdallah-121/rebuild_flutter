// AdminsManagementScreen.dart
// ignore_for_file: use_build_context_synchronously, file_names

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rebuild/utils/constants.dart';
import '../../Cubits/AdminCubit/UserCubit.dart';
import '../../Cubits/AdminCubit/UserState.dart';
import '../../Model/UserModel.dart';
import '../../Widgets/Admin/User Management widget/UserCard.dart';

class AdminsManagementScreen extends StatefulWidget {
  const AdminsManagementScreen({super.key});

  @override
  State<AdminsManagementScreen> createState() => _AdminsManagementScreenState();
}

class _AdminsManagementScreenState extends State<AdminsManagementScreen> {
  final TextEditingController _userIdController = TextEditingController();

  void _addAdminById(UsersCubit cubit, int userId) async {
    if (cubit.state is! UsersLoaded) return;

    final users = (cubit.state as UsersLoaded).users;
    final user = users.firstWhere(
      (u) => u.userId == userId,
      orElse: () => UserModel(
        userId: -1,
        fullName: '',
        email: '',
        phoneNumber: '',
        cityName: '',
        role: '',
        isBanned: false,
        reportsCount: 0,
        commentsCount: 0,
        donationsCount: 0,
      ),
    );

    if (user.userId == -1) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("المستخدم غير موجود")));
      return;
    }

    try {
      await cubit.updateUserRole(userId, "Admin"); // نرسل التغيير للسيرفر
      user.role = "Admin"; // تحديث محلي
      setState(() {});
      _userIdController.clear();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("${user.fullName} تمت ترقيته إلى Admin")),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(" ليس لديك الصلاحية لترقية هذا الحساب ")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<UsersCubit, UsersState>(
      builder: (context, state) {
        if (state is UsersLoading) {
          return const Center(child: CircularProgressIndicator());
        }
        if (state is UsersError) {
          return Center(child: Text(state.message));
        }
        if (state is UsersLoaded) {
          final admins = state.users.where((u) => u.role == "Admin").toList();

          return Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                // 🔹 إضافة Admin برقم المستخدم
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _userIdController,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          hintText: "أدخل رقم المستخدم لترقيته إلى Admin",
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    ElevatedButton(
                      onPressed: () {
                        final userId = int.tryParse(
                          _userIdController.text.trim(),
                        );
                        if (userId != null) {
                          _addAdminById(context.read<UsersCubit>(), userId);
                        } else {
                          warningMessage(context, "يرجى إدخال رقم مستخدم صالح");
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.black54,
                      ),
                      child: const Text("إضافة Admin"),
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                // 🔹 قائمة المشرفين
                Expanded(
                  child: ListView.builder(
                    itemCount: admins.length,
                    itemBuilder: (context, index) {
                      final admin = admins[index];
                      return UserCard(
                        userId: admin.userId,
                        name: admin.fullName,
                        email: admin.email,
                        phone: admin.phoneNumber,
                        city: admin.cityName,
                        isBanned: admin.isBanned,
                        onBanToggle: () =>
                            context.read<UsersCubit>().toggleBan(admin.userId),
                        onDelete: () => context
                            .read<UsersCubit>()
                            .downgradeAdminToUser(admin.userId),
                      );
                    },
                  ),
                ),
              ],
            ),
          );
        }

        return const SizedBox();
      },
    );
  }
}
