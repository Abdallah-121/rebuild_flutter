import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

class LocationPickerMap extends StatelessWidget {
  final LatLng selectedLocation;
  final ValueChanged<LatLng> onLocationChanged;

  const LocationPickerMap({
    super.key,
    required this.selectedLocation,
    required this.onLocationChanged,
  });

  bool _insideSyria(LatLng p) {
    return p.latitude >= 32.0 &&
        p.latitude <= 37.5 &&
        p.longitude >= 35.5 &&
        p.longitude <= 42.0;
  }

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: SizedBox(
        height: 220,
        child: FlutterMap(
          options: MapOptions(
            initialCenter: selectedLocation,
            onTap: (_, point) {
              if (_insideSyria(point)) {
                onLocationChanged(point);
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text("⚠️ الرجاء اختيار موقع داخل سوريا فقط"),
                  ),
                );
              }
            },
          ),
          children: [
            TileLayer(
              urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
              userAgentPackageName: 'com.example.rebuild',
            ),
            MarkerLayer(
              markers: [
                Marker(
                  point: selectedLocation,
                  width: 40,
                  height: 40,
                  child: const Icon(
                    Icons.location_pin,
                    color: Colors.red,
                    size: 36,
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
