import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

class SelecionarLocalizacaoMapa extends StatefulWidget {
  final LatLng initialLocation;

  const SelecionarLocalizacaoMapa({super.key, required this.initialLocation});

  @override
  State<SelecionarLocalizacaoMapa> createState() =>
      _SelecionarLocalizacaoMapaState();
}

class _SelecionarLocalizacaoMapaState extends State<SelecionarLocalizacaoMapa> {
  LatLng? _selectedLocation;

  @override
  void initState() {
    super.initState();
    _selectedLocation = widget.initialLocation;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Selecionar Localização'),
        backgroundColor: Colors.orange,
      ),
      body: FlutterMap(
        options: MapOptions(
          initialCenter: _selectedLocation ?? LatLng(-23.5505, -46.6333),
          initialZoom: 14.0,
          minZoom: 15.0,
          maxZoom: 20.0,
          onTap: (tapPosition, LatLng location) {
            setState(() {
              _selectedLocation = location;
            });
          },
        ),
        children: [
          TileLayer(
            urlTemplate: "https://tile.openstreetmap.org/{z}/{x}/{y}.png",
            userAgentPackageName: 'com.example.sportslink',
          ),
          if (_selectedLocation != null)
            MarkerLayer(
              markers: [
                Marker(
                  point: _selectedLocation!,
                  child: const Icon(
                    Icons.location_pin,
                    color: Colors.orange,
                    size: 40,
                  ),
                ),
              ],
            ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pop(context, _selectedLocation);
        },
        backgroundColor: Colors.orange,
        child: const Icon(Icons.check, color: Colors.white),
      ),
    );
  }
}
