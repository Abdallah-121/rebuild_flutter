// ignore_for_file: unused_local_variable

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rebuild/Api/AuthServiceDart.dart';
import 'package:rebuild/Cubits/Help&Support/support_states.dart';
import 'package:rebuild/Api/SupportService.dart';
import 'package:rebuild/Cubits/Help&Support/ticket_cubit&%20message_cubit.dart';
import 'package:rebuild/Model/SupportMessageModel.dart';
import 'package:rebuild/Widgets/Help&SupportWidets/MessageInputWidget.dart';
import 'package:rebuild/utils/constants.dart';

class SupportChatPage extends StatefulWidget {
  final int? ticketId;
  final bool isAdmin; // لتحديد إن كان المستخدم ادمن
  final String? userName; // اسم المستخدم إذا الادمن

  const SupportChatPage({
    super.key,
    this.ticketId,
    this.isAdmin = false,
    this.userName,
  });

  @override
  State<SupportChatPage> createState() => _SupportChatPageState();
}

class _SupportChatPageState extends State<SupportChatPage> {
  late final SupportService _service;
  late final TicketCubit _ticketCubit;
  late final MessageCubit _messageCubit;
  int? _ticketId;
  int? _currentUserId; // معرف المستخدم الحالي لتحديد الرسائل على اليمين

  @override
  void initState() {
    super.initState();
    _initCubits();
    _loadTicket();
  }

  void _initCubits() {
    final authService = AuthService();
    _service = SupportService(
      baseUrl: 'http://216.126.239.86:5000',
      authService: authService,
    );
    _ticketCubit = TicketCubit(_service);
    _messageCubit = MessageCubit(_service);

    // نفترض أن authService يعطي معرف المستخدم الحالي
    authService.getUserIdFromToken().then((id) {
      _currentUserId = id;
      setState(() {});
    });
  }

  void _loadTicket() async {
    try {
      if (widget.ticketId != null) {
        _ticketId = widget.ticketId!;
        _messageCubit.loadMessages(_ticketId!);
      } else {
        final tickets = await _service.getMyTickets();
        if (tickets.isNotEmpty) {
          _ticketId = tickets.first.id;
          _messageCubit.loadMessages(_ticketId!);
        } else {
          final ticket = await _service.createTicket('تذكرة دعم تلقائية', 1);
          _ticketId = ticket.id;
          _messageCubit.loadMessages(_ticketId!);
        }
      }
      setState(() {});
    } catch (e) {
      // ممكن تعرض خطأ هنا
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_ticketId == null || _currentUserId == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return MultiBlocProvider(
      providers: [
        BlocProvider.value(value: _ticketCubit),
        BlocProvider.value(value: _messageCubit),
      ],
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text(
            widget.isAdmin ? (widget.userName ?? 'مستخدم') : 'المساعدة والدعم',
          ),
          backgroundColor: AppColors.primary,
        ),
        body: Column(
          children: [
            Expanded(
              child: BlocBuilder<MessageCubit, MessageState>(
                builder: (context, state) {
                  List<SupportMessage> messages = [];
                  if (state is MessagesLoaded) {
                    messages = state.messages;
                  } else if (state is MessageLoading) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (state is MessageError) {
                    return const Center(
                      child: Text('حدث خطأ أثناء تحميل الرسائل'),
                    );
                  }

                  return ListView.builder(
                    reverse: true,
                    padding: const EdgeInsets.symmetric(
                      vertical: 10,
                      horizontal: 8,
                    ),
                    itemCount: messages.length,
                    itemBuilder: (context, index) {
                      final msg = messages[messages.length - 1 - index];

                      // الرسائل المرسلة من المستخدم الحالي تظهر على اليمين
                      final isFromCurrentUser = msg.senderId == _currentUserId;

                      return Container(
                        alignment: isFromCurrentUser
                            ? Alignment.centerRight
                            : Alignment.centerLeft,
                        margin: const EdgeInsets.symmetric(vertical: 4),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 10,
                          ),
                          constraints: BoxConstraints(
                            maxWidth: MediaQuery.of(context).size.width * 0.75,
                          ),
                          decoration: BoxDecoration(
                            color: isFromCurrentUser
                                ? Colors.blueAccent
                                : Colors.grey.shade200,
                            borderRadius: BorderRadius.only(
                              topLeft: const Radius.circular(12),
                              topRight: const Radius.circular(12),
                              bottomLeft: Radius.circular(
                                isFromCurrentUser ? 12 : 0,
                              ),
                              bottomRight: Radius.circular(
                                isFromCurrentUser ? 0 : 12,
                              ),
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.1),
                                blurRadius: 3,
                                offset: const Offset(1, 2),
                              ),
                            ],
                          ),
                          child: Text(
                            msg.message,
                            style: TextStyle(
                              color: isFromCurrentUser
                                  ? Colors.white
                                  : Colors.black87,
                              fontSize: 15,
                            ),
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
            if (_ticketId != null) MessageInput(ticketId: _ticketId!),
          ],
        ),
      ),
    );
  }
}
