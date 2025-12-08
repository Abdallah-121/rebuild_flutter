// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rebuild/Cubits/AdminCubit/UserCubit.dart';
import 'package:rebuild/Cubits/AdminCubit/UserState.dart';
import 'package:rebuild/Widgets/Admin/User%20Management%20widget/UserCard.dart';
import 'package:rebuild/Widgets/Admin/User%20Management%20widget/UserFilterMenu.dart';
import 'package:rebuild/Widgets/Admin/User%20Management%20widget/UserSearchBar.dart';

class UsersManagementScreen extends StatefulWidget {
  const UsersManagementScreen({super.key});

  @override
  State<UsersManagementScreen> createState() => _UsersManagementScreenState();
}

class _UsersManagementScreenState extends State<UsersManagementScreen> {
  String search = "";
  String filterRole = "الكل";

  @override
  void initState() {
    super.initState();
    context.read<UsersCubit>().fetchUsers();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // 🔍 شريط البحث
            UserSearchBar(onChanged: (val) => setState(() => search = val)),
            const SizedBox(height: 10),

            // 🔽 فلترة حسب الدور
            UserFilterMenu(
              selectedRole: filterRole,
              onChanged: (val) => setState(() => filterRole = val),
            ),
            const SizedBox(height: 10),

            // 👇 قائمة المستخدمين
            Expanded(
              child: BlocBuilder<UsersCubit, UsersState>(
                builder: (context, state) {
                  if (state is UsersLoading) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (state is UsersError) {
                    return Center(child: Text(state.message));
                  }

                  if (state is UsersLoaded) {
                    final users = state.users.where((user) {
                      final matchSearch =
                          user.fullName.contains(search) ||
                          user.email.contains(search);

                      final matchRole =
                          (filterRole == "الكل") || (user.role == filterRole);

                      return matchSearch && matchRole;
                    }).toList();

                    if (users.isEmpty) {
                      return const Center(child: Text("لا يوجد مستخدمين"));
                    }

                    return ListView.builder(
                      itemCount: users.length,
                      itemBuilder: (context, index) {
                        final u = users[index];

                        return UserCard(
                          userId: u.userId,
                          name: u.fullName,
                          email: u.email,
                          phone: u.phoneNumber,
                          city: u.cityName,
                          isBanned: u.isBanned,
                          onBanToggle: () =>
                              context.read<UsersCubit>().toggleBan(u.userId),
                          onDelete: () =>
                              _confirmDelete(context, u.userId, u.fullName),
                        );
                      },
                    );
                  }

                  return const SizedBox();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  // 🗑 نافذة تأكيد حذف المستخدم
  void _confirmDelete(BuildContext context, int id, String name) {
    showDialog(
      context: context,
      builder: (_) {
        return AlertDialog(
          title: const Text("حذف مستخدم"),
          content: Text("هل تريد حذف المستخدم \"$name\"؟"),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("إلغاء"),
            ),
            ElevatedButton(
              onPressed: () {
                context.read<UsersCubit>().deleteUser(id, context);
                Navigator.pop(context);
              },
              child: const Text("حذف"),
            ),
          ],
        );
      },
    );
  }
}
