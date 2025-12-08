import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

class MapCard extends StatelessWidget {
  final double? lat;
  final double? lng;

  const MapCard({super.key, this.lat, this.lng});

  @override
  Widget build(BuildContext context) {
    if (lat == null || lng == null) return const SizedBox();

    return Container(
      height: 220,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: Colors.white,
        boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 5)],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: FlutterMap(
          options: MapOptions(
            initialCenter: LatLng(lat!, lng!),
            initialZoom: 15,
          ),
          children: [
            TileLayer(
              urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
              userAgentPackageName: 'com.example.rebuild_app',
            ),
            MarkerLayer(
              markers: [
                Marker(
                  point: LatLng(lat!, lng!),
                  width: 40,
                  height: 40,
                  child: const Icon(
                    Icons.location_on,
                    color: Colors.red,
                    size: 35,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
