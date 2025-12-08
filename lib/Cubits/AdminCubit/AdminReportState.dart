// ignore_for_file: file_names

abstract class AdminReportState {}

class AdminReportInitial extends AdminReportState {}

class AdminReportLoading extends AdminReportState {}

class AdminReportError extends AdminReportState {
  final String message;
  AdminReportError(this.message);
}

class AdminReportLoaded extends AdminReportState {
  final List<Map<String, dynamic>> reports;
  final Map<String, int> statusCounts; // عدد البلاغات لكل حالة
  AdminReportLoaded(this.reports, this.statusCounts);
}

class AdminReportDeleteSuccess extends AdminReportState {}
