import 'package:rebuild/Model/comment_model.dart';

abstract class CommentState {}

class CommentInitial extends CommentState {}

class CommentLoading extends CommentState {}

class CommentLoaded extends CommentState {
  final List<CommentModel> comments;
  CommentLoaded(this.comments);
}

class CommentAdded extends CommentState {
  final CommentModel newComment;
  CommentAdded(this.newComment);
}

class CommentUpdated extends CommentState {}

class CommentDeleted extends CommentState {}

class CommentError extends CommentState {
  final String message;
  CommentError(this.message);
}
