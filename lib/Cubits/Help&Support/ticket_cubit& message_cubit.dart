import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rebuild/Api/SupportService.dart';
import 'package:rebuild/Cubits/Help&Support/support_states.dart';
import 'package:rebuild/Model/SupportMessageModel.dart';

class TicketCubit extends Cubit<TicketState> {
  final SupportService service;
  TicketCubit(this.service) : super(TicketInitial());

  Future<void> loadTicket(int id) async {
    emit(TicketLoading());
    try {
      final data = await service.getTicket(id);
      emit(TicketLoaded(data));
    } catch (e) {
      emit(TicketError());
    }
  }
}

class MessageCubit extends Cubit<MessageState> {
  final SupportService service;
  MessageCubit(this.service) : super(MessageInitial());

  Future<void> loadMessages(int ticketId) async {
    emit(MessageLoading());
    try {
      final msgs = await service.getMessages(ticketId);
      emit(MessagesLoaded(msgs));
    } catch (e) {
      emit(MessageError());
    }
  }

  Future<void> send(int ticketId, String msg) async {
    if (state is MessagesLoaded) {
      final currentMessages = (state as MessagesLoaded).messages;
      final newMessage = SupportMessage(
        id: 0, // مؤقت قبل ما يرد السيرفر
        ticketId: ticketId,
        message: msg,
        senderId: 0, // ممكن تحط userId الحقيقي
        isFromAdmin: false,
      );

      // أضف الرسالة مباشرة للـ UI قبل الإرسال
      emit(MessagesLoaded(List.from(currentMessages)..add(newMessage)));

      try {
        // أرسل الرسالة للسيرفر
        final sentMessage = await service.sendMessage(ticketId, msg);

        // استبدال الرسالة المؤقتة بالرسالة من السيرفر
        if (state is MessagesLoaded) {
          final updatedMessages = (state as MessagesLoaded).messages.map((m) {
            if (m == newMessage) return sentMessage;
            return m;
          }).toList();
          emit(MessagesLoaded(updatedMessages));
        }
      } catch (e) {
        emit(MessageError());
      }
    } else {
      await loadMessages(ticketId);
    }
  }
}
