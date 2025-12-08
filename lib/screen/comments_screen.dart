// ignore_for_file: use_build_context_synchronously, unnecessary_brace_in_string_interps

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rebuild/Api/AuthServiceDart.dart';
import 'package:rebuild/Cubits/comment_cubit/comment_cubit.dart';
import 'package:rebuild/Cubits/comment_cubit/comment_state.dart';
import 'package:rebuild/Model/comment_model.dart';
import 'package:rebuild/Widgets/CommentWidgets/CommentCard.dart';
import 'package:rebuild/Widgets/CommentWidgets/CommentInput.dart';
import 'package:rebuild/utils/constants.dart';

class CommentsScreen extends StatefulWidget {
  final int reportId;

  const CommentsScreen({super.key, required this.reportId});

  @override
  State<CommentsScreen> createState() => _CommentsScreenState();
}

class _CommentsScreenState extends State<CommentsScreen> {
  int currentUserId = 0;
  bool _loadingUser = true;

  @override
  void initState() {
    super.initState();
    _initData();
  }

  Future<void> _initData() async {
    final auth = AuthService();

    currentUserId = await auth.getUserIdFromToken();
    final username = await auth.getUserNameFromToken();

    // 🔥 حدّث الـ Cubit بالقيم الصحيحة
    final cubit = context.read<CommentCubit>();
    cubit.currentUserId = currentUserId;
    cubit.currentUserName = username;

    _loadingUser = false;

    await cubit.loadComments(widget.reportId);
    if (mounted) setState(() {});
  }

  String _timeAgo(String isoDate) {
    try {
      final date = DateTime.parse(isoDate).toUtc().toLocal();
      final diff = DateTime.now().difference(date);

      if (diff.inSeconds < 60) return "قبل ثوانٍ";
      if (diff.inMinutes < 60)
        return "قبل ${diff.inMinutes} دقيقة${diff.inMinutes > 1 ? 'ات' : ''}";
      if (diff.inHours < 24)
        return "قبل ${diff.inHours} ساع${diff.inHours > 1 ? 'ات' : ''}";
      if (diff.inDays < 7)
        return "قبل ${diff.inDays} يوم${diff.inDays > 1 ? 'ان' : ''}";
      if (diff.inDays < 30) {
        final weeks = (diff.inDays / 7).floor();
        return "قبل ${weeks} أسبوع${weeks > 1 ? 'ان' : ''}";
      }
      if (diff.inDays < 365) {
        final months = (diff.inDays / 30).floor();
        return "قبل ${months} شهر${months > 1 ? 'ان' : ''}";
      }
      final years = (diff.inDays / 365).floor();
      return "قبل ${years} سنة${years > 1 ? 'وات' : ''}";
    } catch (_) {
      return isoDate;
    }
  }

  void _showEditDialog(CommentModel comment) {
    final controller = TextEditingController(text: comment.commentText);

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('تعديل التعليق'),
        content: TextField(
          controller: controller,
          maxLines: 3,
          decoration: const InputDecoration(hintText: 'أدخل التعليق'),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('إلغاء'),
          ),
          ElevatedButton(
            onPressed: () {
              context.read<CommentCubit>().updateComment(
                widget.reportId,
                comment.commentId,
                controller.text,
              );
              Navigator.pop(context);
            },
            child: const Text('تحديث'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        title: const Text("التعليقات"),
        centerTitle: true,
        elevation: 1,
      ),
      body: Column(
        children: [
          Expanded(
            child: BlocBuilder<CommentCubit, CommentState>(
              builder: (context, state) {
                final comments = context
                    .read<CommentCubit>()
                    .getCommentsForReport(widget.reportId);

                if (_loadingUser ||
                    state is CommentLoading && comments.isEmpty) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (state is CommentError) {
                  return const Center(
                    child: Text(
                      "لا يوجد اتصال بالانترنت",
                      style: TextStyle(color: Colors.red),
                    ),
                  );
                }

                if (comments.isEmpty) {
                  return const Center(
                    child: Text(
                      "لا توجد تعليقات بعد",
                      style: TextStyle(fontSize: 16, color: Colors.grey),
                    ),
                  );
                }

                return ListView.separated(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 12,
                  ),
                  itemCount: comments.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 4),
                  itemBuilder: (_, index) {
                    final comment = comments[index];
                    final isMine = comment.userId == currentUserId;

                    return CommentCard(
                      comment: comment,
                      isMine: isMine,
                      timeAgo: _timeAgo,
                      onEdit: isMine ? () => _showEditDialog(comment) : null,
                      onDelete: isMine
                          ? () async {
                              final confirm = await showDialog<bool>(
                                context: context,
                                builder: (context) => AlertDialog(
                                  title: const Text('تأكيد الحذف'),
                                  content: const Text(
                                    'هل أنت متأكد أنك تريد حذف هذا التعليق؟',
                                  ),
                                  actions: [
                                    TextButton(
                                      onPressed: () =>
                                          Navigator.pop(context, false),
                                      child: const Text('إلغاء'),
                                    ),
                                    ElevatedButton(
                                      onPressed: () =>
                                          Navigator.pop(context, true),
                                      child: const Text('نعم'),
                                    ),
                                  ],
                                ),
                              );

                              if (confirm == true) {
                                await context
                                    .read<CommentCubit>()
                                    .deleteComment(
                                      widget.reportId,
                                      comment.commentId,
                                    );
                              }
                            }
                          : null,
                    );
                  },
                );
              },
            ),
          ),
          CommentInput(reportId: widget.reportId),
        ],
      ),
    );
  }
}
