import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:geolocator/geolocator.dart';
import 'package:sports_link/models/campo_priv.dart';
import 'package:supercluster/supercluster.dart';

class MapView extends StatefulWidget {
  final List<CampoPriv> campos;
  final Function(CampoPriv) onCampoSelected;
  final double latitude;
  final double longitude;

  const MapView({
    super.key,
    required this.campos,
    required this.onCampoSelected,
    required this.latitude,
    required this.longitude,
  });

  @override
  State<MapView> createState() => _MapViewState();
}

class _MapViewState extends State<MapView> {
  final MapController _mapController = MapController();
  LatLng? _userLocation;
  bool _hasMovedMap = false;
  late SuperclusterMutable<CampoPriv> _supercluster;
  List<Marker> _clusterMarkers = [];
  final TextEditingController _searchController = TextEditingController();
  List<CampoPriv> _searchResults = [];

  @override
  void initState() {
    super.initState();
    _initializeSupercluster();
    _getUserLocation().then((_) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _updateMapBounds();
        _updateClusters(13);
      });
    });
  }

  void _initializeSupercluster() {
    _supercluster = SuperclusterMutable<CampoPriv>(
      getX: (campo) => campo.ponto.longitude,
      getY: (campo) => campo.ponto.latitude,
      extractClusterData: (campo) => CampoClusterData(campo.nome),
      minPoints: 5,
      radius: 40,
      maxZoom: 16,
      minZoom: 12,
    );
    _supercluster.load(widget.campos);
  }

  void _updateClusters(double zoom) {
    final center = _userLocation ?? LatLng(widget.latitude, widget.longitude);
    final bounds = LatLngBounds(
      LatLng(center.latitude - 0.1, center.longitude - 0.1),
      LatLng(center.latitude + 0.1, center.longitude + 0.1),
    );

    final clusters = _supercluster.getClusters(
      bounds.west,
      bounds.south,
      bounds.east,
      bounds.north,
      zoom.toInt(),
    );

    setState(() {
      _clusterMarkers =
          clusters.map((cluster) {
            if (cluster.isCluster) {
              return Marker(
                point: LatLng(cluster.latitude, cluster.longitude),
                width: 60,
                height: 60,
                child: GestureDetector(
                  onTap: () {
                    _mapController.move(
                      LatLng(cluster.latitude, cluster.longitude),
                      zoom + 2,
                    );
                  },
                  child: Container(
                    alignment: Alignment.center,
                    decoration: const BoxDecoration(
                      color: Colors.orange,
                      shape: BoxShape.circle,
                    ),
                    child: Text(
                      cluster.numPoints.toString(),
                      style: const TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              );
            } else {
              final campo = cluster.originalPoint!;
              return Marker(
                point: LatLng(campo.ponto.latitude, campo.ponto.longitude),
                width: 60,
                height: 60,
                child: GestureDetector(
                  onTap: () {
                    widget.onCampoSelected(campo);
                  },
                  child: Container(
                    alignment: Alignment.center,
                    decoration: const BoxDecoration(
                      color: Colors.blue,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.sports_soccer, color: Colors.white),
                  ),
                ),
              );
            }
          }).toList();
    });
  }

  Future<void> _getUserLocation() async {
    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) return;

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied ||
            permission == LocationPermission.deniedForever) {
          return;
        }
      }

      final position = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.high,
        ),
      );

      setState(() {
        _userLocation = LatLng(position.latitude, position.longitude);
      });

      if (!_hasMovedMap) {
        _mapController.move(_userLocation!, 13);
        _hasMovedMap = true;
      }
    } catch (e) {
      debugPrint("Erro ao obter localização: $e");
    }
  }

  void _updateMapBounds() {
    final bounds = LatLngBounds(
      LatLng(widget.latitude, widget.longitude),
      LatLng(widget.latitude, widget.longitude),
    );

    if (_userLocation != null) bounds.extend(_userLocation!);
    for (var campo in widget.campos) {
      bounds.extend(LatLng(campo.ponto.latitude, campo.ponto.longitude));
    }

    if (bounds.southWest != bounds.northEast) {
      final center = bounds.center;
      const zoom = 13.0;
      _mapController.move(center, zoom);
      _hasMovedMap = true;
    }
  }

  void _searchCampos(String query) {
    final results =
        widget.campos
            .where(
              (campo) => campo.nome.toLowerCase().contains(query.toLowerCase()),
            )
            .toList();
    setState(() {
      _searchResults = results;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_userLocation == null) {
      return const Center(child: CircularProgressIndicator());
    }

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            children: [
              TextField(
                controller: _searchController,
                decoration: const InputDecoration(
                  hintText: 'Pesquisar campo...',
                  prefixIcon: Icon(Icons.search),
                  border: OutlineInputBorder(),
                ),
                onChanged: _searchCampos,
              ),
              if (_searchResults.isNotEmpty)
                Container(
                  height: 200,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: ListView.builder(
                    itemCount: _searchResults.length,
                    itemBuilder: (context, index) {
                      final campo = _searchResults[index];
                      return ListTile(
                        title: Text(campo.nome),
                        onTap: () {
                          final pos = LatLng(
                            campo.ponto.latitude,
                            campo.ponto.longitude,
                          );
                          _mapController.move(pos, 16);
                          widget.onCampoSelected(campo);
                          setState(() {
                            _searchResults.clear();
                            _searchController.clear();
                          });
                        },
                      );
                    },
                  ),
                ),
            ],
          ),
        ),
        Expanded(
          child: Container(
            margin: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.white),
              borderRadius: BorderRadius.circular(12),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Stack(
                children: [
                  FlutterMap(
                    mapController: _mapController,
                    options: MapOptions(
                      initialCenter: _userLocation!,
                      initialZoom: 13,
                      minZoom: 12,
                      maxZoom: 18,
                      onPositionChanged: (pos, _) => _updateClusters(pos.zoom),
                    ),
                    children: [
                      TileLayer(
                        urlTemplate:
                            "https://tile.openstreetmap.org/{z}/{x}/{y}.png",
                        userAgentPackageName: 'com.example.sports_link',
                      ),
                      MarkerLayer(markers: _clusterMarkers),
                    ],
                  ),
                  Positioned(
                    bottom: 10,
                    right: 10,
                    child: FloatingActionButton(
                      onPressed: _getUserLocation,
                      backgroundColor: Colors.orange,
                      mini: true,
                      child: const Icon(Icons.my_location, color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}

extension on SuperclusterMutable<CampoPriv> {
  getClusters(double west, double south, double east, double north, int int) {}
}

// Classe auxiliar para supercluster
class CampoClusterData extends ClusterDataBase {
  final String nome;

  CampoClusterData(this.nome);

  @override
  ClusterDataBase combine(covariant ClusterDataBase data) {
    if (data is CampoClusterData) {
      return CampoClusterData('$nome + ${data.nome}');
    } else {
      return this;
    }
  }
}
