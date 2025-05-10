import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';
import 'package:provider/provider.dart';
import 'package:sports_link/controllers/user_provider.dart';
import 'package:sports_link/models/campo_priv.dart';
import 'package:sports_link/screens/campo_details.dart';
import 'package:sports_link/styles/carouselbg.dart';
import 'package:geolocator/geolocator.dart';
import 'package:sports_link/data/mock_data.dart';
import 'package:sports_link/models/campo.dart';
import 'package:sports_link/styles/custom_appbar.dart';
import 'package:sports_link/controllers/controller_dropdown.dart' as dpd;
import 'package:sports_link/widgets/map_view.dart' as map_view;
import 'package:sports_link/widgets/list_view.dart' as list_view;
import 'package:sports_link/utils/filter_campos.dart' as filter_campos;

class ListCampos extends StatefulWidget {
  final String filtroTipo;

  const ListCampos({super.key, required this.filtroTipo});

  @override
  State<ListCampos> createState() => _ListCamposState();
}

class _ListCamposState extends State<ListCampos> {
  bool isDropdownOpen = false;
  final GlobalKey notificationButtonKey = GlobalKey();

  final List<Campo> campos = mockCampos;
  final TextEditingController searchController = TextEditingController();

  bool isAscending = true;
  bool isMapView = false;
  int camposVisiveis = 5;

  double latitude = 0.0;
  double longitude = 0.0;

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
  }

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
      debugPrint('Erro ao obter localização: $e');
    }

    setState(() {
      latitude = 40.6405;
      longitude = -8.6538;
    });
  }

  @override
  Widget build(BuildContext context) {
    // Obter o utilizador atual do Provider
    final currentUser = Provider.of<UserProvider>(context).user;

    final List<Campo> camposFiltrados = filter_campos.filterCampos(
      campos: campos,
      query: searchController.text,
      isAscending: isAscending,
      filtroTipo: widget.filtroTipo,
    ).where((campo) {
      // Exclui os campos do arrendador atual
      if (campo is CampoPriv && campo.idArrendador == currentUser?.id) {
        return false;
      }
      return true;
    }).toList();

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
              onNotificationPressed: (context) {
                dpd.showNotificationDropdown(
                    context, notificationButtonKey, currentUser!);
              },
              onMenuPressed: (context, items) {
                dpd.toggleDropdownOverlay(context, items);
              },
            ),
            body: SafeArea(
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Expanded(
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
                            const SizedBox(width: 8),
                            IconButton(
                              icon: Icon(
                                isMapView ? Icons.view_list : Icons.map,
                              ),
                              color: const Color.fromARGB(255, 255, 152, 0),
                              onPressed: () {
                                setState(() {
                                  isMapView = !isMapView;
                                });
                              },
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                      ],
                    ),
                  ),
                  Expanded(
                    child: isMapView
                        ? map_view.MapView(
                            campos: camposFiltrados,
                            userLocation: LatLng(latitude, longitude),
                            onCampoSelected: (campo) {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => CampoDetails(campo: campo),
                                ),
                              );
                            },
                          )
                        : list_view.buildListViewWithLoadMore(
                            camposFiltrados,
                            camposVisiveis,
                            () {
                              setState(() {
                                camposVisiveis += 5;
                              });
                            },
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
}
