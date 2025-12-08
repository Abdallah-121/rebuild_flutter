import 'package:rebuild/Api/SupportService.dart';
import 'package:rebuild/Cubits/AdminCubit/AdminTicketState.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AdminTicketCubit extends Cubit<AdminTicketState> {
  final SupportService service;
  AdminTicketCubit(this.service) : super(AdminTicketInitial());

  Future<void> loadTickets() async {
    emit(AdminTicketLoading());
    try {
      final tickets = await service
          .getMyTickets(); // إذا كان ادمن يرجع كل التذاكر
      emit(AdminTicketLoaded(tickets));
    } catch (e) {
      emit(AdminTicketError());
    }
  }
}
