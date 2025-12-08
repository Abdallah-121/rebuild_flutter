// ignore_for_file: file_names, deprecated_member_use, avoid_print, use_build_context_synchronously

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:http/http.dart' as http;
import 'package:rebuild/Api/AuthServiceDart.dart';
import 'package:rebuild/screen/report_details_screen.dart';
import '../../utils/constants.dart';

class ReportsList extends StatelessWidget {
  final List<Map<String, dynamic>> reports;
  final Function(int reportId)? onDelete;
  final Function(int reportId)? onCommentTap;
  final bool useExpanded;
  final bool shrinkWrap;
  final ScrollPhysics? physics;

  const ReportsList({
    super.key,
    required this.reports,
    this.onDelete,
    this.onCommentTap,
    this.useExpanded = true,
    this.shrinkWrap = false,
    this.physics,
  });

  String formatImageUrl(String url) {
    if (url.startsWith("http")) return url;
    if (url.startsWith("data:image")) return url;
    return "http://216.126.239.86:5000$url";
  }

  @override
  Widget build(BuildContext context) {
    if (reports.isEmpty) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(20),
          child: Text(
            "لا يوجد بلاغات بعد",
            style: TextStyle(fontSize: 18, color: Colors.grey),
          ),
        ),
      );
    }

    Widget listView = ListView.builder(
      shrinkWrap: shrinkWrap,
      physics: physics ?? const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.symmetric(vertical: 4),
      itemCount: reports.length,
      itemBuilder: (context, index) {
        final report = reports[index];
        return ReportCard(
          report: report,
          onCommentTap: onCommentTap,
          onDelete: onDelete,
          formatImageUrl: formatImageUrl,
        );
      },
    );

    return useExpanded ? Expanded(child: listView) : listView;
  }
}

class ReportCard extends StatefulWidget {
  final Map<String, dynamic> report;
  final Function(int reportId)? onCommentTap;
  final Function(int reportId)? onDelete;
  final String Function(String url) formatImageUrl;

  const ReportCard({
    super.key,
    required this.report,
    this.onCommentTap,
    this.onDelete,
    required this.formatImageUrl,
  });

  @override
  State<ReportCard> createState() => _ReportCardState();
}

class _ReportCardState extends State<ReportCard> {
  late bool isLiked;
  late int likesCount;

  @override
  void initState() {
    super.initState();
    isLiked = widget.report['isLiked'] ?? false;
    likesCount = widget.report['likesCount'] ?? 0;
  }

  Future<void> toggleLike() async {
    final authService = AuthService();
    final reportId = widget.report['reportId'];
    if (reportId == null) return;

    setState(() {
      if (isLiked) {
        isLiked = false;
        likesCount--;
      } else {
        isLiked = true;
        likesCount++;
      }
    });

    try {
      final token = await authService.getToken();
      final url = Uri.parse(
        "http://216.126.239.86:5000/api/ReportLikes/$reportId/like",
      );

      http.Response response;
      if (isLiked) {
        response = await http.post(
          url,
          headers: {
            "Content-Type": "application/json",
            "Authorization": "Bearer $token",
          },
        );
      } else {
        response = await http.delete(
          url,
          headers: {
            "Content-Type": "application/json",
            "Authorization": "Bearer $token",
          },
        );
      }

      if (response.statusCode >= 400) {
        setState(() {
          if (isLiked) {
            isLiked = false;
            likesCount--;
          } else {
            isLiked = true;
            likesCount++;
          }
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              "فشل تحديث الإعجاب. رمز الخطأ: ${response.statusCode}",
            ),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      setState(() {
        if (isLiked) {
          isLiked = false;
          likesCount--;
        } else {
          isLiked = true;
          likesCount++;
        }
      });
      print("خطأ في اللايك: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    final report = widget.report;
    final title = report['title'] ?? "بدون عنوان";
    final description = report['description'] ?? "";
    final cityName = report['cityName'] ?? "";
    final categoryName = report['categoryName'] ?? "";
    final rawImages = report['images'] as List<dynamic>? ?? [];
    final commentCount = report['commentCount'] ?? 0;

    final images = rawImages
        .where((img) => img != null && img.toString().isNotEmpty)
        .map((img) => img.toString())
        .toList();

    final displayImage = images.isNotEmpty ? images.first : null;

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(18),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => ReportDetailsScreen(report: report),
            ),
          );
        },
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            children: [
              // header: category + city
              // header: user name (يمين) + category/city (يسار)
              Row(
                children: [
                  // ⬅️ يسار: النوع + المدينة
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.primary.withOpacity(0.08),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text(
                          categoryName,
                          style: GoogleFonts.cairo(
                            fontSize: 11,
                            color: AppColors.primaryDark,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      if (cityName.isNotEmpty) ...[
                        const SizedBox(width: 6),
                        const Icon(
                          Icons.location_on,
                          size: 14,
                          color: Colors.redAccent,
                        ),
                        const SizedBox(width: 2),
                        Text(
                          cityName,
                          style: GoogleFonts.cairo(
                            fontSize: 11,
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ],
                  ),

                  const Spacer(),

                  // ➡️ يمين: اسم المستخدم
                  Row(
                    children: [
                      const Icon(
                        Icons.person_outline,
                        size: 15,
                        color: Colors.grey,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        report['userName'] ?? 'مستخدم مجهول',
                        style: GoogleFonts.aBeeZee(
                          fontSize: 12.5,
                          color: Colors.grey.shade700,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ],
              ),

              const SizedBox(height: 10),

              Row(
                children: [
                  if (displayImage != null)
                    ClipRRect(
                      borderRadius: BorderRadius.circular(14),
                      child: SizedBox(
                        width: 95,
                        height: 95,
                        child: displayImage.startsWith("data:image")
                            ? Image.memory(
                                base64Decode(
                                  displayImage.contains(',')
                                      ? displayImage.split(',')[1]
                                      : displayImage,
                                ),
                                fit: BoxFit.cover,
                              )
                            : CachedNetworkImage(
                                imageUrl: widget.formatImageUrl(displayImage),
                                fit: BoxFit.cover,
                                placeholder: (_, __) => Container(
                                  color: Colors.grey.shade200,
                                  child: const Center(
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                    ),
                                  ),
                                ),
                                errorWidget: (_, __, ___) => Container(
                                  color: Colors.grey.shade300,
                                  child: const Icon(
                                    Icons.broken_image,
                                    size: 34,
                                    color: Colors.grey,
                                  ),
                                ),
                              ),
                      ),
                    ),
                  if (displayImage != null) const SizedBox(width: 12),

                  // النص
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          title,
                          style: GoogleFonts.cairo(
                            fontWeight: FontWeight.w700,
                            fontSize: 15.5,
                          ),
                          textAlign: TextAlign.right,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          description,
                          style: GoogleFonts.cairo(
                            color: Colors.grey.shade700,
                            fontSize: 13,
                            height: 1.4,
                          ),
                          maxLines: 3,
                          overflow: TextOverflow.ellipsis,
                          textAlign: TextAlign.right,
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 10),

              Row(
                children: [
                  // like
                  InkWell(
                    borderRadius: BorderRadius.circular(20),
                    onTap: toggleLike,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 6,
                        vertical: 4,
                      ),
                      child: Row(
                        children: [
                          Icon(
                            isLiked ? Icons.favorite : Icons.favorite_border,
                            size: 20,
                            color: isLiked
                                ? Colors.redAccent
                                : Colors.grey[700],
                          ),
                          const SizedBox(width: 4),
                          Text(
                            "$likesCount",
                            style: GoogleFonts.cairo(
                              fontSize: 13,
                              color: Colors.grey[800],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(width: 10),

                  // comments
                  InkWell(
                    borderRadius: BorderRadius.circular(20),
                    onTap: () {
                      if (widget.onCommentTap != null) {
                        widget.onCommentTap!(report['reportId']);
                      }
                    },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 6,
                        vertical: 4,
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.comment_outlined, size: 20),
                          const SizedBox(width: 4),
                          Text(
                            "$commentCount تعليق",
                            style: GoogleFonts.cairo(fontSize: 13),
                          ),
                        ],
                      ),
                    ),
                  ),

                  const Spacer(),

                  // تفاصيل
                  TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => ReportDetailsScreen(report: report),
                        ),
                      );
                    },
                    child: Text(
                      "عرض التفاصيل",
                      style: GoogleFonts.cairo(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: AppColors.secondary,
                      ),
                    ),
                  ),

                  if (widget.onDelete != null) ...[
                    const SizedBox(width: 4),
                    IconButton(
                      onPressed: () {
                        final id = report['reportId'];
                        if (id == null) return;

                        showDialog(
                          context: context,
                          builder: (_) => AlertDialog(
                            title: const Text("تأكيد الحذف"),
                            content: const Text("هل تريد حذف هذا البلاغ؟"),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.pop(context),
                                child: const Text("إلغاء"),
                              ),
                              TextButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                  widget.onDelete!(id);
                                },
                                child: const Text("حذف"),
                              ),
                            ],
                          ),
                        );
                      },
                      icon: const Icon(
                        Icons.delete_forever_rounded,
                        color: Colors.redAccent,
                      ),
                    ),
                  ],
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
