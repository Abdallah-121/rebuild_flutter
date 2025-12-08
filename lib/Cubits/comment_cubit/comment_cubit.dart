import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rebuild/Api/comment_service.dart';
import 'package:rebuild/Cubits/comment_cubit/comment_state.dart';
import 'package:rebuild/Model/comment_model.dart';

class CommentCubit extends Cubit<CommentState> {
  final CommentService commentService;

  int currentUserId;
  String currentUserName;

  final Map<int, List<CommentModel>> _commentsByReport = {};

  CommentCubit({
    required this.commentService,
    this.currentUserId = 0,
    this.currentUserName = "UNKNOWN USER",
  }) : super(CommentInitial());

  Future<void> loadComments(int reportId) async {
    emit(CommentLoading());
    try {
      final comments = await commentService.getCommentsByReport(reportId);
      _commentsByReport[reportId] = comments;
      emit(CommentLoaded(_commentsByReport[reportId]!));
    } catch (e) {
      emit(CommentError(e.toString()));
    }
  }

  List<CommentModel> getCommentsForReport(int reportId) {
    return _commentsByReport[reportId] ?? [];
  }

  Future<void> addComment(int reportId, String text) async {
    try {
      final newCommentFromServer = await commentService.addComment(
        reportId: reportId,
        commentText: text,
      );

      // استخدم اسم المستخدم الحالي مباشرة
      final newComment = CommentModel(
        commentId: newCommentFromServer.commentId,
        commentText: newCommentFromServer.commentText,
        createdAt: newCommentFromServer.createdAt,
        userId: currentUserId,
        userName: currentUserName,
        reportId: reportId,
      );

      _commentsByReport.putIfAbsent(reportId, () => []);
      _commentsByReport[reportId]!.insert(0, newComment);

      emit(CommentLoaded(_commentsByReport[reportId]!));
    } catch (e) {
      emit(CommentError(e.toString()));
    }
  }

  Future<void> updateComment(int reportId, int commentId, String text) async {
    try {
      final ok = await commentService.updateComment(commentId, text);
      if (ok && _commentsByReport.containsKey(reportId)) {
        final index = _commentsByReport[reportId]!.indexWhere(
          (c) => c.commentId == commentId,
        );
        if (index != -1) {
          final old = _commentsByReport[reportId]![index];
          _commentsByReport[reportId]![index] = CommentModel(
            commentId: commentId,
            commentText: text,
            createdAt: old.createdAt,
            userId: old.userId,
            userName: old.userName,
            reportId: old.reportId,
          );
          emit(CommentLoaded(_commentsByReport[reportId]!));
        }
      }
    } catch (e) {
      emit(CommentError(e.toString()));
    }
  }

  Future<void> deleteComment(int reportId, int commentId) async {
    try {
      final ok = await commentService.deleteComment(commentId);
      if (ok && _commentsByReport.containsKey(reportId)) {
        _commentsByReport[reportId]!.removeWhere(
          (c) => c.commentId == commentId,
        );
        emit(CommentLoaded(_commentsByReport[reportId]!));
      }
    } catch (e) {
      emit(CommentError(e.toString()));
    }
  }
}
