import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:rebuild/utils/constants.dart';

class HomeCategoriesSection extends StatelessWidget {
  final List<String> categories;
  final String selectedCategory;
  final Function(String) onCategorySelected;
  final int count;

  const HomeCategoriesSection({
    super.key,
    required this.categories,
    required this.selectedCategory,
    required this.onCategorySelected,
    required this.count,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "$count بلاغ",
              style: GoogleFonts.cairo(
                fontSize: 13,
                color: AppColors.textSecondary,
              ),
            ),
            Text(
              "فئات البلاغات",
              style: GoogleFonts.cairo(
                fontSize: 16,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        SizedBox(
          height: 50,
          child: ListView.builder(
            itemCount: categories.length,
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 10),
            itemBuilder: (_, i) {
              final cat = categories[i];
              final selected = cat == selectedCategory;

              return GestureDetector(
                onTap: () => onCategorySelected(cat),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  margin: const EdgeInsets.symmetric(horizontal: 6),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 18,
                    vertical: 10,
                  ),
                  decoration: BoxDecoration(
                    color: selected
                        ? AppColors.primaryDark
                        : Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: selected ? AppColors.primaryDark : Colors.grey,
                    ),
                  ),
                  child: Center(
                    child: Text(
                      cat,
                      style: GoogleFonts.cairo(
                        color: selected ? Colors.white : Colors.black87,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
