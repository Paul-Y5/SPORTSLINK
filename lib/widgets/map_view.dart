import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:sports_link/models/campo_priv.dart';
import 'package:sports_link/screens/campo_details.dart';

class MapView extends StatelessWidget {
  final List<CampoPriv> campos;
  final double latitude;
  final double longitude;

  const MapView({
    super.key,
    required this.campos,
    required this.latitude,
    required this.longitude,
  });

  @override
  Widget build(BuildContext context) {
    if (campos.isEmpty) {
      return const Center(
        child: Text(
          'Nenhum campo encontrado.',
          style: TextStyle(color: Colors.white),
        ),
      );
    }

    return Container(
      height: 300,
      margin: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.white),
        borderRadius: BorderRadius.circular(12),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: FlutterMap(
          options: MapOptions(
            initialCenter: LatLng(latitude, longitude),
            minZoom: 12.0,
            maxZoom: 18.0,
          ),
          children: [
            TileLayer(
              urlTemplate: "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
              subdomains: ['a', 'b', 'c'],
            ),
            MarkerLayer(
              markers:
                  campos.map((campo) {
                    return Marker(
                      width: 80.0,
                      height: 80.0,
                      point: LatLng(
                        campo.ponto.latitude,
                        campo.ponto.longitude,
                      ),
                      child: GestureDetector(
                        onTap:
                            () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder:
                                    (context) => CampoDetails(campo: campo),
                              ),
                            ),
                        child: const Icon(
                          Icons.location_on,
                          color: Colors.orange,
                          size: 40.0,
                        ),
                      ),
                    );
                  }).toList(),
            ),
          ],
        ),
      ),
    );
  }
}
