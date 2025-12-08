import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:rebuild/screen/report_details_screen.dart';
import 'package:rebuild/utils/constants.dart';

class HomeMapWidget extends StatelessWidget {
  final List<Map<String, dynamic>> reports;

  const HomeMapWidget({super.key, required this.reports});

  @override
  Widget build(BuildContext context) {
    const minLat = 32.0;
    const maxLat = 37.5;
    const minLng = 35.5;
    const maxLng = 42.0;

    final validReports = reports.where((r) {
      final lat = double.tryParse(r['latitude'].toString());
      final lng = double.tryParse(r['longitude'].toString());
      if (lat == null || lng == null) return false;
      return lat >= minLat && lat <= maxLat && lng >= minLng && lng <= maxLng;
    }).toList();

    if (validReports.isEmpty) {
      return Container(
        height: 120,
        decoration: BoxDecoration(
          color: AppColors.greyLight,
          borderRadius: BorderRadius.circular(16),
        ),
        child: const Center(
          child: Text("لا توجد مواقع لعرضها على الخريطة حالياً"),
        ),
      );
    }

    final Map<String, int> countMap = {};
    for (var r in validReports) {
      final lat = double.parse(r['latitude'].toString());
      final lng = double.parse(r['longitude'].toString());
      final key = '$lat,$lng';
      countMap[key] = (countMap[key] ?? 0) + 1;
    }

    String mostKey = countMap.entries
        .reduce((a, b) => a.value >= b.value ? a : b)
        .key;
    final parts = mostKey.split(',');
    final centerLat = double.parse(parts[0]);
    final centerLng = double.parse(parts[1]);

    final markers = validReports.map((r) {
      final lat = double.parse(r['latitude'].toString());
      final lng = double.parse(r['longitude'].toString());
      return Marker(
        point: LatLng(lat, lng),
        width: 40,
        height: 40,
        child: GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => ReportDetailsScreen(report: r)),
            );
          },
          child: const Icon(Icons.location_on, color: Colors.red, size: 35),
        ),
      );
    }).toList();

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: SizedBox(
          height: 200,
          child: FlutterMap(
            options: MapOptions(
              initialCenter: LatLng(centerLat, centerLng),
              minZoom: 6,
              maxZoom: 18,
            ),
            children: [
              TileLayer(
                urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                userAgentPackageName: 'com.example.rebuild_app',
              ),
              MarkerLayer(markers: markers),
            ],
          ),
        ),
      ),
    );
  }
}
