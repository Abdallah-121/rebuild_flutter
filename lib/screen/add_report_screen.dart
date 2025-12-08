// ignore_for_file: use_build_context_synchronously

import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:latlong2/latlong.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:geolocator/geolocator.dart';

import 'package:rebuild/Api/AuthServiceDart.dart';
import 'package:rebuild/Api/report_service.dart';
import 'package:rebuild/Cubits/report-cubit/report_cubit.dart';
import 'package:rebuild/Cubits/report-cubit/report_state.dart';
import 'package:rebuild/Model/report_request.dart';
import 'package:rebuild/Widgets/Add report Widget/location_picker.dart';
import 'package:rebuild/Widgets/Add%20report%20Widget/image_picker_field.dart';
import 'package:rebuild/utils/constants.dart';

class AddReportScreen extends StatefulWidget {
  const AddReportScreen({super.key});

  @override
  State<AddReportScreen> createState() => _AddReportScreenState();
}

class _AddReportScreenState extends State<AddReportScreen> {
  final _formKey = GlobalKey<FormState>();

  final titleController = TextEditingController();
  final descriptionController = TextEditingController();

  int? selectedCategoryId;
  int? selectedCityId;
  List<String> imagesBase64 = [];

  LatLng selectedLocation = const LatLng(33.5148, 36.2777); // دمشق
  bool isUpdatingLocation = false;

  late ReportCubit cubit;

  @override
  void initState() {
    super.initState();
    cubit = ReportCubit(
      ReportService(authService: AuthService()),
      AuthService(),
    );
    cubit.loadCategories();
    cubit.loadCities();
  }

  // ================= LOCATION =================

  Future<void> _updateCurrentLocation() async {
    setState(() => isUpdatingLocation = true);

    try {
      final pos = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
      setState(() {
        selectedLocation = LatLng(pos.latitude, pos.longitude);
      });
    } catch (_) {
      warningMessage(context, "فشل تحديد الموقع الحالي");
    } finally {
      setState(() => isUpdatingLocation = false);
    }
  }

  // ================= SUBMIT =================

  void submitReport() {
    if (!_formKey.currentState!.validate()) return;

    if (selectedCategoryId == null ||
        selectedCityId == null ||
        imagesBase64.isEmpty) {
      warningMessage(
        context,
        "يرجى اختيار الفئة، المدينة، وإضافة صورة واحدة على الأقل",
      );
      return;
    }

    final request = ReportRequest(
      title: titleController.text.trim(),
      description: descriptionController.text.trim(),
      categoryId: selectedCategoryId!,
      cityId: selectedCityId!,
      latitude: selectedLocation.latitude,
      longitude: selectedLocation.longitude,
      imagesBase64: imagesBase64,
    );

    cubit.createReport(request);
  }

  // ================= UI =================

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: cubit,
      child: Scaffold(
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          title: Text("إضافة بلاغ", style: GoogleFonts.cairo()),
          centerTitle: true,
        ),
        body: Stack(children: [_background(), _body()]),
        bottomNavigationBar: _submitButton(),
      ),
    );
  }

  Widget _background() {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF1E88E5), Color(0xFF2E7D32)],
          begin: Alignment.topRight,
          end: Alignment.bottomLeft,
        ),
      ),
    );
  }

  Widget _body() {
    return BlocConsumer<ReportCubit, ReportState>(
      listener: (context, state) {
        if (state is ReportSuccess) {
          warningMessage(context, "✅ تم إرسال البلاغ بنجاح");
          Navigator.pushNamedAndRemoveUntil(context, '/home', (_) => false);
        }
        if (state is ReportError) {
          warningMessage(context, state.message);
        }
      },
      builder: (context, state) {
        return SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 120),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(28),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 16, sigmaY: 16),
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.95),
                    borderRadius: BorderRadius.circular(28),
                  ),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        _header(),
                        const SizedBox(height: 12),

                        _title("عنوان البلاغ", titleController),
                        const SizedBox(height: 12),

                        _dropdown(
                          "نوع البلاغ",
                          cubit.categories,
                          selectedCategoryId,
                          (v) => setState(() => selectedCategoryId = v),
                        ),
                        const SizedBox(height: 12),

                        _dropdown(
                          "المدينة",
                          cubit.cities,
                          selectedCityId,
                          (v) => setState(() => selectedCityId = v),
                        ),

                        const SizedBox(height: 16),
                        _sectionTitle("الوصف"),
                        _description(),

                        const SizedBox(height: 20),
                        _sectionTitle("الموقع"),
                        const SizedBox(height: 8),

                        ClipRRect(
                          borderRadius: BorderRadius.circular(18),
                          child: LocationPickerMap(
                            selectedLocation: selectedLocation,
                            onLocationChanged: (loc) {
                              setState(() => selectedLocation = loc);
                            },
                          ),
                        ),

                        const SizedBox(height: 10),
                        _currentLocationButton(),

                        const SizedBox(height: 20),
                        _sectionTitle("الصور"),
                        const SizedBox(height: 8),

                        ImagePickerWithProgress(
                          onChanged: (list) => imagesBase64 = list,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  // ================= COMPONENTS =================

  Widget _sectionTitle(String t) => Text(
    t,
    style: GoogleFonts.cairo(fontSize: 15, fontWeight: FontWeight.w700),
    textAlign: TextAlign.right,
  );

  Widget _title(String label, TextEditingController controller) {
    return TextFormField(
      controller: controller,
      validator: (v) => v == null || v.isEmpty ? "حقل مطلوب" : null,
      textAlign: TextAlign.right,
      decoration: InputDecoration(
        labelText: label,
        filled: true,
        fillColor: Colors.grey.shade50,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
      ),
    );
  }

  Widget _description() {
    return TextFormField(
      controller: descriptionController,
      maxLines: 5,
      validator: (v) => v == null || v.isEmpty ? "اكتب وصفاً واضحاً" : null,
      textAlign: TextAlign.right,
      decoration: InputDecoration(
        hintText: "اشرح المشكلة بالتفصيل...",
        filled: true,
        fillColor: Colors.grey.shade50,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
      ),
    );
  }

  Widget _dropdown(
    String label,
    List items,
    int? value,
    ValueChanged<int?> onChanged,
  ) {
    return DropdownButtonFormField<int>(
      value: value,
      isExpanded: true,
      decoration: InputDecoration(
        labelText: label,
        filled: true,
        fillColor: Colors.grey.shade50,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
      ),
      items: items
          .map<DropdownMenuItem<int>>(
            (e) => DropdownMenuItem<int>(value: e.id, child: Text(e.name)),
          )
          .toList(),
      onChanged: onChanged,
      validator: (v) => v == null ? "مطلوب" : null,
    );
  }

  Widget _currentLocationButton() {
    return ElevatedButton.icon(
      onPressed: isUpdatingLocation ? null : _updateCurrentLocation,
      icon: isUpdatingLocation
          ? const SizedBox(
              width: 16,
              height: 16,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                color: Colors.white,
              ),
            )
          : const Icon(Icons.my_location),
      label: Text(
        isUpdatingLocation ? "جارٍ تحديد الموقع..." : "تحديد موقعي الحالي",
      ),
      style: ElevatedButton.styleFrom(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      ),
    );
  }

  Widget _submitButton() {
    return BlocBuilder<ReportCubit, ReportState>(
      builder: (context, state) {
        final loading = state is ReportLoading;

        return SafeArea(
          minimum: const EdgeInsets.all(16),
          child: SizedBox(
            height: 52,
            child: ElevatedButton.icon(
              onPressed: loading ? null : submitReport,
              icon: loading
                  ? const SizedBox(
                      width: 18,
                      height: 18,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.white,
                      ),
                    )
                  : const Icon(Icons.send),
              label: Text(
                loading ? "جارٍ الإرسال..." : "إرسال البلاغ",
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
        );
      },
    );
  }
}

Widget _header() {
  return Row(
    children: [
      CircleAvatar(
        radius: 22,
        backgroundColor: AppColors.primary.withOpacity(0.1),
        child: const Icon(Icons.report, color: AppColors.primaryDark, size: 26),
      ),
      const SizedBox(width: 12),
      Expanded(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              "بلاغ جديد",
              style: GoogleFonts.cairo(
                fontSize: 20,
                fontWeight: FontWeight.w800,
              ),
            ),
            Text(
              "املأ البيانات وساهم بإعادة الإعمار",
              style: GoogleFonts.cairo(
                fontSize: 12,
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ),
      ),
    ],
  );
}
