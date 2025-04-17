import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart'; 
import 'package:geolocator/geolocator.dart'; 
import 'package:sports_link/data/mock_data.dart';
import 'package:sports_link/data/my_user.dart';
import 'package:sports_link/models/campo.dart';
import 'package:sports_link/models/campo_priv.dart';
import 'package:sports_link/models/utilizador.dart';
import 'package:sports_link/screens/campo_details.dart';
import 'package:sports_link/styles/custom_appbar.dart';
import 'package:sports_link/widgets/card_campo.dart';
import 'package:sports_link/widgets/notification_dropdown.dart'as notification_dropdown;
import 'package:sports_link/styles/carouselbg.dart';

class ListCampos extends StatefulWidget {
  const ListCampos({super.key});

  @override
  State<ListCampos> createState() => _ListCamposState();
}

class _ListCamposState extends State<ListCampos> {
  late Utilizador currentUser;
  int notificationCount = 3;
  bool isDropdownOpen = false;
  final GlobalKey notificationButtonKey = GlobalKey();

  final List<Campo> campos = mockCampos;
  final TextEditingController searchController = TextEditingController();

  bool isAscending = true;
  bool isGridView = false;
  bool isMapView = false; // Controla a exibição do mapa
  int camposVisiveis = 10;

  double latitude = 51.509865; // Valor inicial (exemplo: Londres)
  double longitude = -0.118092; // Valor inicial (exemplo: Londres)

  @override
  void initState() {
    super.initState();
    currentUser = getMyUser();
    _getCurrentLocation(); // Obter a localização atual do usuário
  }

  // Método para obter a localização atual do usuário
  Future<void> _getCurrentLocation() async {
    LocationPermission permission = await Geolocator.requestPermission();

    if (permission == LocationPermission.always ||
        permission == LocationPermission.whileInUse) {
      Position position = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.high,
        ),
      );
      
      setState(() {
        latitude = position.latitude;
        longitude = position.longitude;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final List<CampoPriv> camposFiltrados = _filtrarCampos();

    return Scaffold(
      extendBody: true,
      extendBodyBehindAppBar: true,
      body: Stack(
        children: [
          const Carouselbg(),
          Scaffold(
            backgroundColor: const Color.fromARGB(0, 0, 0, 0),
            appBar: CustomAppBar(
              notificationButtonKey: notificationButtonKey,
              notificationCount: notificationCount,
              onNotificationPressed: (context) {
                _showNotificationDropdown(context);
              },
              onMenuPressed: (context, items) {
                _toggleDropdownOverlay(context, items);
              },
            ),
            body: SafeArea(
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: TextField(
                      controller: searchController,
                      onChanged: (_) => setState(() {}),
                      decoration: InputDecoration(
                        hintText: 'Pesquisar campos...',
                        prefixIcon: const Icon(Icons.search),
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide.none,
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16,
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        ElevatedButton.icon(
                          onPressed: () {
                            setState(() {
                              isAscending = !isAscending;
                            });
                          },
                          icon: Icon(
                            isAscending
                                ? Icons.arrow_upward
                                : Icons.arrow_downward,
                          ),
                          label: Text("Ordenar"),
                        ),
                        IconButton(
                          icon: Icon(isMapView ? Icons.view_list : Icons.map),
                          color: Colors.white,
                          onPressed: () {
                            setState(() {
                              isMapView = !isMapView;
                            });
                          },
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child:
                        isMapView
                            ? _buildMapView(camposFiltrados)
                            : _buildListView(camposFiltrados),
                  ),
                  if (_filtrarCampos(semLimite: true).length > camposVisiveis)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 16.0),
                      child: ElevatedButton(
                        onPressed: () {
                          setState(() {
                            camposVisiveis += 10;
                          });
                        },
                        child: const Text('Ver mais'),
                      ),
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Retorna uma lista de até 10 campos privados filtrados pelo nome
  List<CampoPriv> _filtrarCampos({bool semLimite = false}) {
    String query = searchController.text.toLowerCase();

    List<CampoPriv> filtrados =
        campos
            .whereType<CampoPriv>()
            .where((campo) => campo.nome.toLowerCase().contains(query))
            .toList();

    filtrados.sort(
      (a, b) =>
          isAscending ? a.nome.compareTo(b.nome) : b.nome.compareTo(a.nome),
    );

    return semLimite ? filtrados : filtrados.take(camposVisiveis).toList();
  }

  // Método para exibir a ListView
  Widget _buildListView(List<CampoPriv> camposFiltrados) {
    return camposFiltrados.isEmpty
        ? const Center(
          child: Text(
            'Nenhum campo encontrado.',
            style: TextStyle(color: Colors.white),
          ),
        )
        : ListView.builder(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          itemCount: camposFiltrados.length,
          itemBuilder: (context, index) {
            return CardCampo(campo: camposFiltrados[index]);
          },
        );
  }

  // Método para exibir o MapView
  Widget _buildMapView(List<CampoPriv> camposFiltrados) {
    return camposFiltrados.isEmpty
        ? const Center(
          child: Text(
            'Nenhum campo encontrado.',
            style: TextStyle(color: Colors.white),
          ),
        )
        : FlutterMap(
          options: MapOptions(
            initialCenter: LatLng(latitude, longitude), // Localização inicial
            minZoom: 12.0,
            maxZoom: 18.0,
          ),
          children: [
            TileLayer(
              urlTemplate: "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
              subdomains: ['a', 'b', 'c'],
            ),
            MarkerLayer(
              markers: camposFiltrados.map((campo) {
                // Criação de um marcador para cada campo
                return Marker(
                  width: 80.0,
                  height: 80.0,
                  point: LatLng(
                    campo.ponto.latitude, // Latitude do modelo Ponto
                    campo.ponto.longitude, // Longitude do modelo Ponto
                  ),
                  child: GestureDetector(
                    onTap: () {
                      // Navega para a página de detalhes do campo
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => CampoDetails(campo: campo),
                        ),
                      );
                    },
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
        );
  }

  void _toggleDropdownOverlay(
    BuildContext context,
    List<PopupMenuEntry<String>> items,
  ) {
    setState(() {
      isDropdownOpen = true;
    });

    showMenu(
      context: context,
      position: const RelativeRect.fromLTRB(0, 80, 0, 0),
      items: items,
    ).then((_) {
      setState(() {
        isDropdownOpen = false;
      });
    });
  }

  void _showNotificationDropdown(BuildContext context) {
    notification_dropdown.showNotificationDropdown(
      context: context,
      notificationButtonKey: notificationButtonKey,
      onClose: () {
        setState(() {
          isDropdownOpen = false;
        });
      },
    );
  }
}
