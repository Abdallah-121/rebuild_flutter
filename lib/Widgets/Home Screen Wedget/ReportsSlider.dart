// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:google_fonts/google_fonts.dart';

class ReportsSlider extends StatelessWidget {
  final List<String> sliderImages;

  const ReportsSlider({super.key, required this.sliderImages});

  @override
  Widget build(BuildContext context) {
    if (sliderImages.isEmpty) return const SizedBox.shrink();

    return CarouselSlider(
      options: CarouselOptions(
        height: 150,
        autoPlay: true,
        enlargeCenterPage: true,
        viewportFraction: 0.9,
      ),
      items: sliderImages.map((img) {
        return Stack(
          fit: StackFit.expand,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: CachedNetworkImage(
                imageUrl: img,
                fit: BoxFit.cover,
                placeholder: (_, __) => Container(
                  color: Colors.grey.shade200,
                  child: const Center(child: CircularProgressIndicator()),
                ),
                errorWidget: (_, __, ___) =>
                    const Icon(Icons.broken_image, size: 40),
              ),
            ),
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                gradient: LinearGradient(
                  colors: [Colors.black.withOpacity(0.4), Colors.transparent],
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                ),
              ),
            ),
            Positioned(
              right: 16,
              bottom: 16,
              left: 16,
              child: Text(
                "ساهم في إعادة إعمار مدينتك عبر الإبلاغ أو التبرع",
                style: GoogleFonts.cairo(
                  color: Colors.white,
                  fontWeight: FontWeight.w700,
                  fontSize: 14,
                ),
                textAlign: TextAlign.right,
              ),
            ),
          ],
        );
      }).toList(),
    );
  }
}
