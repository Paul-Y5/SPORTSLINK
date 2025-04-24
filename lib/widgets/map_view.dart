import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

class MapView extends StatelessWidget {
  final List<LatLng> campos; // Lista de localizações dos campos
  final LatLng userLocation; // Localização inicial do usuário
  final Function(LatLng) onCampoSelected; // Callback ao selecionar um campo

  const MapView({
    super.key,
    required this.campos,
    required this.userLocation,
    required this.onCampoSelected,
  });

  @override
  Widget build(BuildContext context) {
    return FlutterMap(
      options: MapOptions(
        initialCenter: userLocation, // Centraliza no usuário
        maxZoom: 24.0, // Zoom máximo
        minZoom: 12.0, // Zoom mínimo
        onTap: (_, point) {
          debugPrint("Mapa clicado em: $point");
        },
      ),
      children: [
        // Camada de tiles do mapa
        TileLayer(
          urlTemplate: "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
          subdomains: ['a', 'b', 'c'],
        ),
        // Marcadores dos campos
        MarkerLayer(
          markers: [
            // Marcador para a localização do usuário
            Marker(
              point: userLocation,
              child: const Icon(
                Icons.my_location,
                color: Colors.blue,
                size: 30,
              ),
            ),
            // Marcadores para os campos
            ...campos.map(
              (campo) => Marker(
                point: campo,
                child: GestureDetector(
                  onTap: () => onCampoSelected(campo),
                  child: const Icon(
                    Icons.location_pin,
                    color: Colors.orange,
                    size: 40,
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}