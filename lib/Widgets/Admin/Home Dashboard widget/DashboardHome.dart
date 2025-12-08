import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:rebuild/Cubits/AdminCubit/AdminReportCubit.dart';
import 'package:rebuild/Cubits/AdminCubit/AdminReportState.dart';
import 'package:rebuild/Cubits/AdminCubit/AdminTicketCubit.dart';
import 'package:rebuild/Cubits/AdminCubit/AdminTicketState.dart';
import 'package:rebuild/Cubits/AdminCubit/UserCubit.dart';
import 'package:rebuild/Cubits/AdminCubit/UserState.dart';
import 'package:rebuild/Widgets/Admin/Home%20Dashboard%20widget/_StatCard.dart';

class DashboardHome extends StatelessWidget {
  const DashboardHome({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AdminReportCubit, AdminReportState>(
      builder: (context, state) {
        if (state is AdminReportLoading || state is AdminReportInitial)
          return const Center(child: CircularProgressIndicator());

        if (state is AdminReportError)
          return Center(
            child: Text(
              state.message,
              style: GoogleFonts.cairo(fontSize: 16, color: Colors.red),
            ),
          );

        if (state is AdminReportLoaded) {
          final reports = state.reports;

          // ⚡ الإحصائيات
          final totalReports = reports.length;
          final pendingReport = reports
              .where((r) => r['status'] == "Pending")
              .length;
          final doneReports = reports
              .where((r) => r['status'] == "Done")
              .length;
          final inProgressReports = reports
              .where((r) => r['status'] == "InProgress")
              .length;

          return RefreshIndicator(
            onRefresh: () async {
              // إعادة تحميل جميع Cubits
              await context.read<AdminReportCubit>().loadAllReports();
              await context.read<AdminTicketCubit>().loadTickets();
            },
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 🔹 شريط الإحصائيات
                  GridView.count(
                    shrinkWrap: true,
                    crossAxisCount: 2,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                    childAspectRatio: 1.5,
                    physics: const NeverScrollableScrollPhysics(),
                    children: [
                      StatCard(
                        title: "قيد الانتظار",
                        value: "$pendingReport",
                        color: Colors.blueGrey,
                      ),
                      StatCard(
                        title: "جارية",
                        value: "$inProgressReports",
                        color: Colors.orange,
                      ),
                      StatCard(
                        title: "منجزة",
                        value: "$doneReports",
                        color: Colors.green,
                      ),
                      StatCard(
                        title: "إجمالي البلاغات",
                        value: "$totalReports",
                        color: Colors.blue,
                      ),
                    ],
                  ),

                  const SizedBox(height: 25), // 🔹 الخريطة (تتحدث عند أي تغير)
                  BlocBuilder<AdminReportCubit, AdminReportState>(
                    builder: (context, reportState) {
                      if (reportState is AdminReportLoaded) {
                        final markers = reportState.reports
                            .where(
                              (r) =>
                                  r['latitude'] != null &&
                                  r['longitude'] != null,
                            )
                            .map(
                              (r) => Marker(
                                point: LatLng(
                                  (r['latitude'] as num).toDouble(),
                                  (r['longitude'] as num).toDouble(),
                                ),
                                width: 40,
                                height: 40,
                                child: Icon(
                                  Icons.location_pin,
                                  color: r['status'] == "Pending"
                                      ? Colors.blueGrey
                                      : r['status'] == "Done"
                                      ? Colors.green
                                      : Colors.blue,
                                  size: 30,
                                ),
                              ),
                            )
                            .toList();

                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "خريطة البلاغات",
                              style: GoogleFonts.cairo(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 10),
                            SizedBox(
                              height: 300,
                              child: FlutterMap(
                                options: MapOptions(
                                  initialCenter: LatLng(36.2021, 37.1343),
                                  maxZoom: 12,
                                ),
                                children: [
                                  TileLayer(
                                    urlTemplate:
                                        'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                                    userAgentPackageName:
                                        'com.example.rebuild_app',
                                  ),
                                  MarkerLayer(markers: markers),
                                ],
                              ),
                            ),
                          ],
                        );
                      }
                      return const SizedBox.shrink();
                    },
                  ),

                  const SizedBox(height: 25),

                  // 🔹 مركز التنبيهات (تتحدث فورًا)
                  Text(
                    "مركز التنبيهات",
                    style: GoogleFonts.cairo(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 12),
                  BlocBuilder<AdminReportCubit, AdminReportState>(
                    builder: (context, reportState) {
                      return BlocBuilder<AdminTicketCubit, AdminTicketState>(
                        builder: (context, ticketState) {
                          return BlocBuilder<UsersCubit, UsersState>(
                            builder: (context, userState) {
                              if (reportState is AdminReportLoading ||
                                  ticketState is AdminTicketLoading ||
                                  userState is UsersLoading) {
                                return const Center(
                                  child: CircularProgressIndicator(),
                                );
                              }

                              if (reportState is AdminReportError ||
                                  ticketState is AdminTicketError ||
                                  userState is UsersError) {
                                return const Text(
                                  "حدث خطأ أثناء تحميل مركز التنبيهات",
                                  style: TextStyle(color: Colors.red),
                                );
                              }

                              final notifications = <Map<String, dynamic>>[];

                              // 🟦 بلاغ جديد
                              if (reportState is AdminReportLoaded &&
                                  reportState.reports.isNotEmpty) {
                                final latest = reportState.reports.last;
                                notifications.add({
                                  "icon": Icons.report,
                                  "color": Colors.blue,
                                  "text":
                                      "تم إضافة بلاغ جديد من ${latest['userName'] ?? 'مستخدم'}",
                                });
                              }

                              // 🟧 تحديث حالة البلاغ
                              if (reportState is AdminReportLoaded) {
                                final updatedReports = reportState.reports
                                    .where(
                                      (r) => r['updatedAt'] != r['createdAt'],
                                    )
                                    .toList();
                                if (updatedReports.isNotEmpty) {
                                  final updated = updatedReports.last;
                                  notifications.add({
                                    "icon": Icons.update,
                                    "color": Colors.orange,
                                    "text":
                                        "تم تحديث حالة البلاغ رقم ${updated['reportId']} إلى: ${updated['status']}",
                                  });
                                }
                              }

                              // 🟥 البلاغات المهمة
                              if (reportState is AdminReportLoaded) {
                                final important = reportState.reports
                                    .where((r) => r['isImportant'] == true)
                                    .length;
                                if (important > 0) {
                                  notifications.add({
                                    "icon": Icons.priority_high,
                                    "color": Colors.red,
                                    "text":
                                        "$important بلاغات بحاجة لمعالجة فورية",
                                  });
                                }
                              }

                              // 🟩 مستخدم جديد
                              if (userState is UsersLoaded &&
                                  userState.users.isNotEmpty) {
                                final latestUser = userState.users.last;
                                notifications.add({
                                  "icon": Icons.person_add,
                                  "color": Colors.green,
                                  "text":
                                      "مستخدم جديد سجّل: ${latestUser.fullName}",
                                });
                              }

                              // 🟪 تذكرة دعم جديدة
                              if (ticketState is AdminTicketLoaded &&
                                  ticketState.tickets.isNotEmpty) {
                                final latestTicket = ticketState.tickets.last;
                                notifications.add({
                                  "icon": Icons.support_agent,
                                  "color": Colors.purple,
                                  "text":
                                      "طلب دعم جديد من ${latestTicket.userName ?? 'مستخدم'}",
                                });
                              }

                              if (notifications.isEmpty) {
                                return Text(
                                  "لا توجد تنبيهات حالياً",
                                  style: GoogleFonts.cairo(color: Colors.grey),
                                );
                              }

                              return Container(
                                padding: const EdgeInsets.all(16),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(12),
                                  boxShadow: const [
                                    BoxShadow(
                                      color: Colors.black12,
                                      blurRadius: 6,
                                      offset: Offset(0, 3),
                                    ),
                                  ],
                                ),
                                child: Column(
                                  children: notifications.map((n) {
                                    return Padding(
                                      padding: const EdgeInsets.symmetric(
                                        vertical: 6,
                                      ),
                                      child: Row(
                                        children: [
                                          Icon(
                                            n['icon'],
                                            color: n['color'],
                                            size: 26,
                                          ),
                                          const SizedBox(width: 12),
                                          Expanded(
                                            child: Text(
                                              n['text'],
                                              style: GoogleFonts.cairo(
                                                fontSize: 14,
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    );
                                  }).toList(),
                                ),
                              );
                            },
                          );
                        },
                      );
                    },
                  ),
                ],
              ),
            ),
          );
        }

        return const Center(
          child: Text(
            "حدث خطأ غير متوقع.",
            style: TextStyle(color: Colors.red),
          ),
        );
      },
    );
  }
}
