import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rebuild/Api/AuthServiceDart.dart';
import 'package:rebuild/Api/SupportService.dart';
import 'package:rebuild/Cubits/AdminCubit/AdminTicketCubit.dart';
import 'package:rebuild/Cubits/AdminCubit/AdminTicketState.dart';
import 'package:rebuild/screen/SupportChatScreen.dart';
import 'package:rebuild/utils/constants.dart';

class AdminTicketListPage extends StatelessWidget {
  const AdminTicketListPage({super.key});

  @override
  Widget build(BuildContext context) {
    final supportService = SupportService(
      baseUrl: 'http://216.126.239.86:5000',
      authService: AuthService(),
    );

    return BlocProvider(
      create: (_) => AdminTicketCubit(supportService)..loadTickets(),
      child: Scaffold(
        body: BlocBuilder<AdminTicketCubit, AdminTicketState>(
          builder: (context, state) {
            if (state is AdminTicketLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is AdminTicketError) {
              return const Center(child: Text('حدث خطأ أثناء تحميل التذاكر'));
            } else if (state is AdminTicketLoaded) {
              final tickets = state.tickets;
              if (tickets.isEmpty) {
                return const Center(child: Text('لا توجد تذاكر'));
              }

              return ListView.separated(
                padding: const EdgeInsets.all(16),
                itemCount: tickets.length,
                separatorBuilder: (_, __) => const SizedBox(height: 12),
                itemBuilder: (context, index) {
                  final ticket = tickets[index];

                  return Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 6,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: ListTile(
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                      leading: CircleAvatar(
                        radius: 28,
                        backgroundColor: AppColors.primary,
                        child: Text(
                          ticket.userName != null && ticket.userName!.isNotEmpty
                              ? ticket.userName![0].toUpperCase()
                              : '?',
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
                      ),
                      title: Text(
                        ticket.userName ?? 'غير معروف',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 6),
                          Text(
                            'المدينة: ${ticket.cityName ?? 'غير محددة'}',
                            style: const TextStyle(fontSize: 14),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'رقم الهاتف: ${ticket.phoneNumber ?? '-'}',
                            style: const TextStyle(fontSize: 14),
                          ),
                        ],
                      ),
                      trailing: const Icon(
                        Icons.arrow_forward_ios,
                        size: 18,
                        color: Colors.grey,
                      ),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => SupportChatPage(
                              ticketId: ticket.id,
                              isAdmin: true,
                              userName: ticket.userName,
                            ),
                          ),
                        );
                      },
                    ),
                  );
                },
              );
            }

            return Container();
          },
        ),
        backgroundColor: const Color(0xFFF8F8F8),
      ),
    );
  }
}
