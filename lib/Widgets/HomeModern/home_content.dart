// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:rebuild/Cubits/report-cubit/report_cubit.dart';
import 'package:rebuild/Cubits/report-cubit/report_state.dart';
import 'package:rebuild/Widgets/HomeModern/home_categories_section.dart';
import 'package:rebuild/Widgets/HomeModern/home_header.dart';
import 'package:rebuild/Widgets/HomeModern/home_map_section.dart';
import 'package:rebuild/Widgets/HomeModern/home_search_bar.dart';
import 'package:rebuild/Widgets/HomeModern/home_slider_section.dart';
import 'package:rebuild/screen/comments_screen.dart';

import '../../utils/constants.dart';
import '../../Widgets/Home Screen Wedget/ReportsList.dart';

class HomeContent extends StatefulWidget {
  final Map<String, dynamic>? user;

  const HomeContent({super.key, required this.user});

  @override
  State<HomeContent> createState() => _HomeContentState();
}

class _HomeContentState extends State<HomeContent> {
  String searchQuery = "";

  String selectedCategory = "الكل";

  final List<String> categories = const [
    "الكل",
    "بيت",
    "مدرسة",
    "شارع",
    "رصيف",
    "مشفى",
    "جسر",
    "كهرباء",
    "مياه",
    "حديقة",
    "تراكم قمامة",
  ];

  final List<String> sliderImages = const [
    "https://images.unsplash.com/photo-1600585154340-be6161a56a0c",
    "https://images.unsplash.com/photo-1596495577886-d920f1fb7238",
    "https://images.unsplash.com/photo-1596495577886-d920f1fb7238",
  ];

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    context.read<ReportCubit>().loadAllReportsWithImages();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ReportCubit, ReportState>(
      builder: (context, state) {
        final cubit = context.read<ReportCubit>();
        final reports = cubit.allReportsFallback;

        final filtered = reports.where((r) {
          final title = (r["title"] ?? "").toString().toLowerCase();
          final city = (r["cityName"] ?? "").toString().toLowerCase();
          final query = searchQuery.toLowerCase();

          // ✅ فلترة حسب الفئة
          final matchesCategory =
              selectedCategory == "الكل" ||
              r["categoryName"] == selectedCategory;

          // ✅ فلترة حسب اسم البلاغ أو المدينة
          final matchesSearch =
              query.isEmpty || title.contains(query) || city.contains(query);

          return matchesCategory && matchesSearch;
        }).toList();

        return RefreshIndicator(
          onRefresh: () => cubit.loadAllReportsWithImages(),
          child: ListView(
            padding: const EdgeInsets.all(16),
            physics: BouncingScrollPhysics(),
            children: [
              HomeHeader(name: widget.user?['fullName']),
              SizedBox(height: 16),
              HomeSearchBar(
                onChanged: (value) {
                  setState(() {
                    searchQuery = value;
                  });
                },
              ),
              SizedBox(height: 16),
              HomeMapSection(reports: filtered),
              SizedBox(height: 16),
              HomeSliderSection(),
              SizedBox(height: 20),
              HomeCategoriesSection(
                categories: categories,
                selectedCategory: selectedCategory,
                onCategorySelected: (c) => setState(() => selectedCategory = c),
                count: filtered.length,
              ),
              SizedBox(height: 16),
              Text(
                "آخر البلاغات",
                style: GoogleFonts.cairo(
                  fontWeight: FontWeight.w700,
                  fontSize: 16,
                  color: AppColors.textPrimary,
                ),
                textAlign: TextAlign.right,
              ),
              ReportsList(
                reports: filtered,
                useExpanded: false,
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                onCommentTap: (id) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => CommentsScreen(reportId: id),
                    ),
                  ).then((_) => cubit.loadAllReportsWithImages());
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
