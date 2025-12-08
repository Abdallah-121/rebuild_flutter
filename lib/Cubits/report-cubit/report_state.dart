abstract class ReportState {}

class ReportInitial extends ReportState {}

class CategoriesLoading extends ReportState {}

class CategoriesLoaded extends ReportState {
  final List categories;
  CategoriesLoaded(this.categories);
}

class CitiesLoading extends ReportState {}

class CitiesLoaded extends ReportState {
  final List cities;
  CitiesLoaded(this.cities);
}

class ReportLoading extends ReportState {}

class ReportSuccess extends ReportState {}

class ReportError extends ReportState {
  final String message;
  ReportError(this.message);
}

class MyReportsLoaded extends ReportState {
  final List reports;
  MyReportsLoaded(this.reports);
}

class DeleteSuccess extends ReportState {}

class AllReportsLoaded extends ReportState {
  final List<Map<String, dynamic>> reports;
  AllReportsLoaded(this.reports);
}
