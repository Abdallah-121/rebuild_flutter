import 'package:rebuild/Model/SupportTicketModel.dart';

abstract class AdminTicketState {}

class AdminTicketInitial extends AdminTicketState {}

class AdminTicketLoading extends AdminTicketState {}

class AdminTicketLoaded extends AdminTicketState {
  final List<SupportTicket> tickets;
  AdminTicketLoaded(this.tickets);
}

class AdminTicketError extends AdminTicketState {}
