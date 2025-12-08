import 'package:rebuild/Model/SupportMessageModel.dart';
import 'package:rebuild/Model/SupportTicketModel.dart';

abstract class TicketState {}

class TicketInitial extends TicketState {}

class TicketLoading extends TicketState {}

class TicketLoaded extends TicketState {
  final SupportTicket ticket;
  TicketLoaded(this.ticket);
}

class TicketError extends TicketState {}

abstract class MessageState {}

class MessageInitial extends MessageState {}

class MessageLoading extends MessageState {}

class MessagesLoaded extends MessageState {
  final List<SupportMessage> messages;
  MessagesLoaded(this.messages);
}

class SendingMessage extends MessageState {}

class MessageSent extends MessageState {}

class MessageError extends MessageState {}
