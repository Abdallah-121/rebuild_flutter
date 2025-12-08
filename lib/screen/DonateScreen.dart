// ignore_for_file: file_names, deprecated_member_use

import 'dart:math';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../utils/constants.dart';

class DonateScreen extends StatelessWidget {
  const DonateScreen({super.key});

  // توليد أكواد عشوائية تجريبية
  List<String> generateCodes() {
    const chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
    Random rnd = Random();
    return List.generate(
      6,
      (_) => List.generate(9, (_) => chars[rnd.nextInt(chars.length)]).join(),
    );
  }

  Widget paymentCard(String title, Color color) {
    final codes = generateCodes();

    return Card(
      elevation: 6,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: GoogleFonts.cairo(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
            const SizedBox(height: 12),
            const Text(
              "اختر أحد الأكواد لإتمام الدفع:",
              style: TextStyle(fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 10),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: codes
                  .map(
                    (code) => Chip(
                      label: Text(
                        code,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                      backgroundColor: color.withOpacity(0.2),
                    ),
                  )
                  .toList(),
            ),
            const SizedBox(height: 12),
            TextField(
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: "أدخل المبلغ",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("صفحة التبرع", style: GoogleFonts.cairo()),
        backgroundColor: AppColors.primary,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          children: [
            const SizedBox(height: 16),

            // كروت الدفع
            paymentCard("شام كاش", Colors.orange),
            paymentCard("سيرياتيل كاش", Colors.blue),
            paymentCard("إم تي إن كاش", Colors.green),

            const SizedBox(height: 20),

            // نص توضيحي
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                "بعد جمع مبلغ معين للبناء، سيتم إعلام المستخدمين بالمبنى الذي سيتم البدء فيه. "
                "يمكنك متابعة الأخبار والإشعارات بعد التبرع.",
                style: GoogleFonts.cairo(fontSize: 16, height: 1.5),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 20),

            // زر إرسال
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: ElevatedButton(
                onPressed: () {
                  // هنا يمكن إضافة المنطق لمعالجة التبرع
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("تم إرسال التبرع بنجاح!")),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 50,
                    vertical: 14,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 5,
                ),
                child: Text(
                  "إرسال",
                  style: GoogleFonts.cairo(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }
}
