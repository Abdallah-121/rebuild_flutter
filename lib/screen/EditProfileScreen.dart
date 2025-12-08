// ignore_for_file: invalid_use_of_visible_for_testing_member, use_build_context_synchronously

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:rebuild/Api/AuthServiceDart.dart';
import '../Cubits/Login-Cubit/Auth Cubit Dart.dart';
import '../utils/constants.dart';
import '../Model/CityModel.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final _formKey = GlobalKey<FormState>();

  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _currentPasswordController = TextEditingController();
  final _newPasswordController = TextEditingController();

  bool _changePassword = false;

  List<City> _cities = [];
  City? _selectedCity;

  @override
  void initState() {
    super.initState();
    _loadUserData();
    _fetchCities();
  }

  void _loadUserData() {
    final currentUser = context.read<AuthCubit>().state.user;
    if (currentUser != null) {
      final fullName = currentUser['fullName'] ?? '';
      final parts = fullName.split(' ');
      _firstNameController.text = parts.isNotEmpty ? parts[0] : '';
      _lastNameController.text = parts.length > 1
          ? parts.sublist(1).join(' ')
          : '';
      _phoneController.text = currentUser['phone'] ?? '';
    }
  }

  Future<void> _fetchCities() async {
    try {
      final response = await http.get(
        Uri.parse("http://216.126.239.86:5000/api/City"),
      );
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body) as List;
        setState(() {
          _cities = data.map((e) => City.fromJson(e)).toList();
          final userCityId =
              context.read<AuthCubit>().state.user?['cityId'] ?? 0;
          _selectedCity = _cities.firstWhere(
            (c) => c.id == userCityId,
            orElse: () => _cities.first,
          );
        });
      }
    } catch (e) {
      debugPrint("Failed to load cities: $e");
    }
  }

  void _saveChanges() async {
    if (!_formKey.currentState!.validate()) return;

    final cubit = context.read<AuthCubit>();
    final user = cubit.state.user!;
    final authService = AuthService(); // لا حاجة لتمرير token

    bool updated = await authService.updateUser(
      id: user['userId'],
      email: user['email'], // خليه كما هو

      firstName: _firstNameController.text,
      lastName: _lastNameController.text,
      cityId: _selectedCity?.id ?? 0,
      phoneNumber: _phoneController.text,
    );

    bool passwordChanged = true;

    if (_changePassword &&
        _currentPasswordController.text.isNotEmpty &&
        _newPasswordController.text.isNotEmpty) {
      passwordChanged = await authService.changePassword(
        currentPassword: _currentPasswordController.text,
        newPassword: _newPasswordController.text,
      );
    }

    if (updated && passwordChanged) {
      cubit.emit(
        cubit.state.copyWith(
          user: {
            ...user,
            'fullName':
                '${_firstNameController.text} ${_lastNameController.text}',
            'phone': _phoneController.text,
            'cityId': _selectedCity?.id ?? 0,
          },
        ),
      );

      warningMessage(context, 'تم تحديث الحساب بنجاح');
      Navigator.pop(context);
    } else if (!passwordChanged) {
      warningMessage(context, 'فشل تغيير كلمة المرور');
    } else {
      warningMessage(context, 'فشل تحديث الحساب');
    }
  }

  void _deleteAccount() async {
    final cubit = context.read<AuthCubit>();
    final user = cubit.state.user!;
    final authService = AuthService();

    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('تأكيد حذف الحساب'),
        content: const Text(
          'هل أنت متأكد أنك تريد حذف الحساب؟ لا يمكن التراجع عن هذا الإجراء.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('إلغاء'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('حذف', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );

    if (confirm == true) {
      final success = await authService.deleteUser(id: user['userId']);
      if (success) {
        cubit.logout();
        Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);
      } else {
        warningMessage(context, 'فشل حذف الحساب');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'تعديل الحساب',
          style: GoogleFonts.cairo(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: AppColors.primary,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              // الاسم الأول
              TextFormField(
                controller: _firstNameController,
                decoration: InputDecoration(
                  labelText: 'الاسم الأول',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  prefixIcon: const Icon(Icons.person),
                ),
                validator: (value) => value == null || value.isEmpty
                    ? 'يرجى إدخال الاسم الأول'
                    : null,
              ),
              const SizedBox(height: 15),

              // الاسم الأخير
              TextFormField(
                controller: _lastNameController,
                decoration: InputDecoration(
                  labelText: 'الاسم الأخير',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  prefixIcon: const Icon(Icons.person_outline),
                ),
                validator: (value) => value == null || value.isEmpty
                    ? 'يرجى إدخال الاسم الأخير'
                    : null,
              ),
              const SizedBox(height: 15),

              // اختيار المدينة
              DropdownButtonFormField<City>(
                value: _selectedCity,
                items: _cities.map((city) {
                  return DropdownMenuItem(
                    value: city,
                    child: Text(city.name, style: GoogleFonts.cairo()),
                  );
                }).toList(),
                onChanged: (city) {
                  setState(() {
                    _selectedCity = city;
                  });
                },
                decoration: InputDecoration(
                  labelText: 'المدينة',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  prefixIcon: const Icon(Icons.location_city),
                ),
              ),
              const SizedBox(height: 15),

              // رقم الهاتف
              TextFormField(
                controller: _phoneController,
                keyboardType: TextInputType.phone,
                decoration: InputDecoration(
                  labelText: 'رقم الهاتف',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  prefixIcon: const Icon(Icons.phone),
                ),
                validator: (value) => value == null || value.isEmpty
                    ? 'يرجى إدخال رقم الهاتف'
                    : null,
              ),
              const SizedBox(height: 15),

              // تبديل إظهار حقول كلمة المرور
              CheckboxListTile(
                value: _changePassword,
                onChanged: (val) =>
                    setState(() => _changePassword = val ?? false),
                title: const Text('تغيير كلمة المرور'),
              ),

              if (_changePassword) ...[
                // كلمة المرور الحالية
                TextFormField(
                  controller: _currentPasswordController,
                  obscureText: true,
                  decoration: InputDecoration(
                    labelText: 'كلمة المرور الحالية',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    prefixIcon: const Icon(Icons.lock),
                  ),
                  validator: (value) {
                    if (_changePassword && (value == null || value.isEmpty)) {
                      return 'يرجى إدخال كلمة المرور الحالية';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 15),

                // كلمة المرور الجديدة
                TextFormField(
                  controller: _newPasswordController,
                  obscureText: true,
                  decoration: InputDecoration(
                    labelText: 'كلمة المرور الجديدة',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    prefixIcon: const Icon(Icons.lock_outline),
                  ),
                  validator: (value) {
                    if (_changePassword && (value == null || value.isEmpty)) {
                      return 'يرجى إدخال كلمة المرور الجديدة';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 15),
              ],

              const SizedBox(height: 20),

              // زر حفظ التعديلات
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: _saveChanges,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  icon: const Icon(Icons.save),
                  label: Text(
                    'حفظ التعديلات',
                    style: GoogleFonts.cairo(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 15),

              // زر حذف الحساب
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: _deleteAccount,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.redAccent,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  icon: const Icon(Icons.delete_forever),
                  label: Text(
                    'حذف الحساب',
                    style: GoogleFonts.cairo(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
