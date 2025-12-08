import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:rebuild/Cubits/report-cubit/report_cubit.dart';
import 'package:rebuild/Cubits/report-cubit/report_state.dart';
import 'package:rebuild/utils/constants.dart';

class ReportAdminStatusSection extends StatefulWidget {
  final int reportId;
  final String initialStatus;
  final ValueChanged<String> onStatusSaved; // ✅ جديد

  const ReportAdminStatusSection({
    super.key,
    required this.reportId,
    required this.initialStatus,
    required this.onStatusSaved,
  });

  @override
  State<ReportAdminStatusSection> createState() =>
      _ReportAdminStatusSectionState();
}

class _ReportAdminStatusSectionState extends State<ReportAdminStatusSection> {
  late String selectedStatus;

  /// 🔒 هذا بيعتمد على حالة البلاغ "الحقيقية" (اللي من السيرفر)
  /// مو على الاختيار الحالي قبل الحفظ
  bool isDoneLocked = false;

  @override
  void initState() {
    super.initState();
    selectedStatus = widget.initialStatus;
    isDoneLocked = widget.initialStatus == 'Done';
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ReportCubit, ReportState>(
      listener: (context, state) async {
        if (state is ReportError) {
          warningMessage(context, "فشل تحديث حالة البلاغ");
        }

        if (state is AllReportsLoaded || state is MyReportsLoaded) {
          // 🔔 تم التحديث بنجاح
          warningMessage(context, "تم تحديث حالة البلاغ");

          // إذا الحالة اللي حفظناها هي 'Done' → نقفل التعديل نهائياً
          if (selectedStatus == 'Done' && !isDoneLocked) {
            setState(() {
              isDoneLocked = true;
            });
          }
        }
      },
      builder: (context, state) {
        final bool isLoading = state is ReportLoading;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              "تغيير حالة البلاغ",
              style: GoogleFonts.cairo(
                fontSize: 16,
                fontWeight: FontWeight.w700,
              ),
              textAlign: TextAlign.right,
            ),
            const SizedBox(height: 8),

            Row(
              children: [
                Expanded(
                  child: DropdownButtonFormField<String>(
                    value: selectedStatus,
                    isExpanded: true,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.grey.shade50,
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 10,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                    items: const [
                      DropdownMenuItem(
                        value: 'Pending',
                        child: Text('قيد الانتظار'),
                      ),
                      DropdownMenuItem(
                        value: 'InProgress',
                        child: Text('قيد المعالجة'),
                      ),
                      DropdownMenuItem(value: 'Done', child: Text('منجزة')),
                    ],

                    /// ⚠️ نمنع التغيير فقط إذا البلاغ "مقفول فعلاً" من السيرفر
                    onChanged: isDoneLocked
                        ? null
                        : (val) {
                            if (val != null) {
                              setState(() => selectedStatus = val);
                            }
                          },
                  ),
                ),

                const SizedBox(width: 12),

                ElevatedButton(
                  onPressed: isDoneLocked || isLoading
                      ? null
                      : () async {
                          await context.read<ReportCubit>().updateReportStatus(
                            widget.reportId,
                            selectedStatus,
                          );

                          /// ✅ خبر صفحة التفاصيل فوراً
                          widget.onStatusSaved(selectedStatus);
                        },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryDark,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 22,
                      vertical: 14,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  child: isLoading
                      ? const SizedBox(
                          width: 18,
                          height: 18,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                      : Text(
                          "حفظ",
                          style: GoogleFonts.cairo(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                ),
              ],
            ),

            if (isDoneLocked) ...[
              const SizedBox(height: 6),
              Text(
                "تم إغلاق البلاغ ولا يمكن تعديل حالته.",
                style: GoogleFonts.cairo(
                  fontSize: 12,
                  color: Colors.grey.shade600,
                ),
                textAlign: TextAlign.right,
              ),
            ],
          ],
        );
      },
    );
  }
}
