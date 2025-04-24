import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';
import 'package:sports_link/models/ponto.dart';
import 'package:sports_link/screens/campo_details.dart';
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
  bool isMapView = false; // Controla a exibição do mapa
  int camposVisiveis = 5;

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
                  // Barra de pesquisa e botão de alternância
                  Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Row(
                      children: [
                        // Barra de pesquisa
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
                        // Botão de alternância de visualização
                        IconButton(
                          icon: Icon(isMapView ? Icons.view_list : Icons.map),
                          color: const Color.fromARGB(255, 255, 152, 0),
                          onPressed: () {
                            setState(() {
                              isMapView = !isMapView;
                            });
                          },
                        ),
                      ],
                    ),
                  ),
                  // Conteúdo principal
                  Expanded(
                    child: isMapView
                        ? map_view.MapView(
                            campos: camposFiltrados.map((campo) => LatLng(campo.ponto.latitude, campo.ponto.longitude)).toList(),
                            userLocation: LatLng(latitude, longitude),
                            onCampoSelected: (selectedCampoLocation) {
                              // Encontra o campo correspondente à localização selecionada
                              final selectedCampo = camposFiltrados.firstWhere(
                                (campo) =>
                                    campo.ponto.latitude == selectedCampoLocation.latitude &&
                                    campo.ponto.longitude == selectedCampoLocation.longitude,
                                orElse: () => CampoPriv(
                                  id: 0,
                                  nome: 'Default Campo',
                                  ponto: Ponto(id: 0, idMapa: 0, latitude: latitude, longitude: longitude),
                                  descricao: 'Default description',
                                  idArrendador: 0,
                                  idPonto: 0,
                                  idMapa: 0,
                                  comprimento: 0.0,
                                  largura: 0.0,
                                  ocupado: false,
                                  imagem: Image.asset('assets/images/placeholder.png'),
                                  preco: 0.0,
                                  diasFuncionamento: <String, List<TimeOfDay>>{},
                                ),
                              );

                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => CampoDetails(campo: selectedCampo),
                                ),
                              );
                                                        },
                          )
                        : list_view.buildListViewWithLoadMore(
                            camposFiltrados,
                            camposVisiveis,
                            () {
                              setState(() {
                                camposVisiveis += 5; // Carregar mais 5 campos
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

  // Método para alternar o menu suspenso
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
