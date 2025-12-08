// ignore_for_file: file_names

class City {
  final int id;
  final String name;

  City({required this.id, required this.name});

  factory City.fromJson(Map<String, dynamic> json) {
    return City(id: json['cityId'], name: json['cityName']);
  }
}
