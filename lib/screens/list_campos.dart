import 'package:flutter/material.dart';
import 'package:sports_link/styles/carouselbg.dart';
import 'package:geolocator/geolocator.dart'; 
import 'package:sports_link/data/mock_data.dart';
import 'package:sports_link/data/my_user.dart';
import 'package:sports_link/models/campo.dart';
import 'package:sports_link/models/campo_priv.dart';
import 'package:sports_link/models/utilizador.dart';
import 'package:sports_link/styles/custom_appbar.dart';
import 'package:sports_link/widgets/notification_dropdown.dart' as notification_dropdown;
import 'package:sports_link/widgets/map_view.dart' as map_view;
import 'package:sports_link/widgets/list_view.dart' as list_view;
import 'package:sports_link/utils/filter_campos.dart' as filter_campos;

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

  double latitude = 0.0;
  double longitude = 0.0;

  @override
  void initState() {
    super.initState();
    currentUser = getMyUser();
    _getCurrentLocation(); // Obter a localização atual do utilizador
  }

  // Método para obter a localização atual do utilizador
  Future<void> _getCurrentLocation() async {
    try {
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
        return;
      }
    } catch (e) {
      // Caso ocorra um erro, a localização será definida como Aveiro
      debugPrint('Erro ao obter localização: $e');
    }

    // Localização padrão: Aveiro
    setState(() {
      latitude = 40.6405;
      longitude = -8.6538;
    });
  }

  @override
  Widget build(BuildContext context) {
    final List<CampoPriv> camposFiltrados = filter_campos.filterCampos(
      campos: campos,
      query: searchController.text,
      isAscending: isAscending,
    );

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
                    child: isMapView
                        ? map_view.MapView(
                            campos: camposFiltrados,
                            latitude: latitude,
                            longitude: longitude,
                          )
                        : list_view.buildListView(camposFiltrados),
                  ),
                  if (filter_campos.filterCampos(
                          campos: campos,
                          query: searchController.text,
                          isAscending: isAscending)
                      .length >
                      camposVisiveis)
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
