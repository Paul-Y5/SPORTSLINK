import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:sports_link/models/campo.dart';
import 'package:sports_link/models/campo_priv.dart'; // CampoPriv
import 'package:sports_link/screens/campo_details.dart'; // CampoDetails


class MapView extends StatefulWidget {
  final List<Campo> campos;
  final LatLng userLocation;
  final Function(Campo) onCampoSelected;

  const MapView({
    super.key,
    required this.campos,
    required this.userLocation,
    required this.onCampoSelected,
  });

  @override
  State<MapView> createState() => _MapViewState();
}

class _MapViewState extends State<MapView> {
  Campo? selectedCampo;

  @override
  Widget build(BuildContext context) {
    return FlutterMap(
      options: MapOptions(
        initialCenter: widget.userLocation,
        initialZoom: 14.0,
        maxZoom: 18.0,
        minZoom: 5.0,
        interactionOptions: const InteractionOptions(
          flags: InteractiveFlag.all,
        ),
        onTap: (tapPosition, point) {
          setState(() {
            selectedCampo = null;
          });
        },
      ),
      children: [
        TileLayer(
          urlTemplate: "https://tile.openstreetmap.org/{z}/{x}/{y}.png",
        ),
        MarkerLayer(
          markers: [
            Marker(
              point: widget.userLocation,
              width: 50,
              height: 50,
              child: const Icon(
                Icons.my_location,
                color: Colors.blue,
                size: 30,
              ),
            ),
            ...widget.campos.map((campo) {
              return Marker(
                point: LatLng(campo.ponto.latitude, campo.ponto.longitude),
                width: 60,
                height: 60,
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      selectedCampo = campo;
                    });
                  },
                  child: Icon(
                    Icons.location_pin,
                    color: campo is CampoPriv ? Colors.orange : Colors.green,
                    size: 40,
                  ),
                ),
              );
            }),
          ],
        ),
        if (selectedCampo != null)
          MarkerLayer(
            markers: [
              Marker(
                point: LatLng(
                  selectedCampo!.ponto.latitude,
                  selectedCampo!.ponto.longitude,
                ),
                width: 200,
                height: 120,
                child: Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  color: Colors.white,
                  child: Column(
                    children: [
                      Expanded(
                        child: ClipRRect(
                          borderRadius: const BorderRadius.vertical(
                            top: Radius.circular(12),
                          ),
                          child: SizedBox(
                            width: double.infinity,
                            child: Image.asset(
                              selectedCampo!.imagem,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        child: Column(
                          children: [
                            Text(
                              selectedCampo!.nome,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                            TextButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder:
                                        (_) =>
                                            CampoDetails(campo: selectedCampo!),
                                  ),
                                );
                              },
                              child: const Text('Ver detalhes', 
                                  style: TextStyle(
                                    color: Colors.orange,
                                  )),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
      ],
    );
  }
}
