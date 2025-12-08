import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:rebuild/Model/comment_model.dart';

class CommentCard extends StatelessWidget {
  final CommentModel comment;
  final bool isMine;
  final void Function()? onEdit;
  final void Function()? onDelete;
  final String Function(String) timeAgo;

  const CommentCard({
    super.key,
    required this.comment,
    required this.isMine,
    required this.timeAgo,
    this.onEdit,
    this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final firstChar = (comment.userName.isNotEmpty)
        ? comment.userName.trim()[0].toUpperCase()
        : "?";

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 6,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // header: avatar, name, menu, time
          Row(
            children: [
              CircleAvatar(
                radius: 18,
                backgroundColor: Colors.blue.shade700,
                child: Text(
                  firstChar,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      comment.userName,
                      style: GoogleFonts.cairo(
                        fontWeight: FontWeight.w700,
                        fontSize: 14,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      timeAgo(comment.createdAt),
                      style: GoogleFonts.cairo(
                        fontSize: 12,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
              ),
              if (isMine)
                PopupMenuButton<String>(
                  onSelected: (value) {
                    if (value == 'edit') {
                      if (onEdit != null) onEdit!();
                    } else if (value == 'delete') {
                      if (onDelete != null) onDelete!();
                    }
                  },
                  itemBuilder: (_) => const [
                    PopupMenuItem(value: 'edit', child: Text('تعديل')),
                    PopupMenuItem(value: 'delete', child: Text('حذف')),
                  ],
                ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            comment.commentText,
            style: GoogleFonts.cairo(
              fontSize: 15,
              color: Colors.black87,
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }
}
