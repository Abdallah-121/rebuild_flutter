// ignore_for_file: file_names

import 'package:rebuild/Model/UserModel.dart';

abstract class UsersState {}

class UsersInitial extends UsersState {}

class UsersLoading extends UsersState {}

class UsersLoaded extends UsersState {
  final List<UserModel> users;

  UsersLoaded(this.users);
}

class UsersError extends UsersState {
  final String message;

  UsersError(this.message);
}
