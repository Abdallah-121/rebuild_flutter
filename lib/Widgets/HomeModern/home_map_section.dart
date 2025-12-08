import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:rebuild/screen/report_details_screen.dart';

class HomeMapSection extends StatelessWidget {
  final List<Map<String, dynamic>> reports;

  const HomeMapSection({super.key, required this.reports});

  @override
  Widget build(BuildContext context) {
    if (reports.isEmpty) return const SizedBox.shrink();

    final valid = reports.where((r) {
      final lat = double.tryParse(r['latitude'].toString());
      final lng = double.tryParse(r['longitude'].toString());
      return lat != null && lng != null;
    }).toList();

    if (valid.isEmpty) return const SizedBox.shrink();

    final first = valid.first;
    final mapController = MapController();

    final markers = valid.map((r) {
      final lat = double.parse(r['latitude'].toString());
      final lng = double.parse(r['longitude'].toString());
      return Marker(
        point: LatLng(lat, lng),
        width: 40,
        height: 40,
        child: GestureDetector(
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => ReportDetailsScreen(report: r)),
          ),
          child: const Icon(Icons.location_on, color: Colors.red, size: 35),
        ),
      );
    }).toList();

    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: SizedBox(
        height: 200,
        child: FlutterMap(
          mapController: mapController,
          options: MapOptions(
            initialCenter: LatLng(
              double.parse(first['latitude'].toString()),
              double.parse(first['longitude'].toString()),
            ),
            minZoom: 6,
            maxZoom: 18,
          ),
          children: [
            TileLayer(
              urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
              userAgentPackageName: 'com.example.rebuild',
            ),
            MarkerLayer(markers: markers),
          ],
        ),
      ),
    );
  }
}
