import 'package:flutter/material.dart';
import 'package:sports_link/data/my_user.dart';
import 'package:sports_link/models/arrendador.dart';
import 'package:sports_link/models/utilizador.dart';
import 'package:sports_link/screens/add_campo.dart';
import 'package:sports_link/screens/arr_campos_list.dart';
import 'package:sports_link/screens/list_campos.dart';
import 'package:sports_link/screens/list_partidas.dart';
import 'package:sports_link/styles/carousel_bar.dart';
import 'package:sports_link/styles/carouselbg.dart';
import 'package:sports_link/utils/weather_fetch.dart';
import 'package:sports_link/widgets/weather_info.dart';
import 'package:sports_link/styles/custom_appbar.dart';
import 'package:sports_link/controllers/controller_dropdown.dart' as dpd;
import 'package:sports_link/widgets/menu_card.dart';

import 'package:sports_link/widgets/movable_fab.dart';

class MainPage1 extends StatefulWidget {
  final int id;
  const MainPage1({super.key, required this.id});

  @override
  State<MainPage1> createState() => _MainPage1State();
}

class _MainPage1State extends State<MainPage1> {
  late Utilizador currentUser;
  bool isDropdownOpen = false;
  String weatherStatus = '';
  String weatherFeedback = '';
  String currentCity = '';
  final WeatherFetch weatherService = WeatherFetch();
  final GlobalKey notificationButtonKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    currentUser = getMyUser(widget.id);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      fetchWeatherData();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      extendBodyBehindAppBar: true,
      appBar: CustomAppBar(
        notificationButtonKey: notificationButtonKey,
        onNotificationPressed: (context) {
          dpd.showNotificationDropdown(context, notificationButtonKey, currentUser);
        },
        onMenuPressed: (context, items) {
          dpd.toggleDropdownOverlay(context, items);
        },
      ),
      body: Stack(
        children: [
          const Carouselbg(),
          if (isDropdownOpen)
            const ModalBarrier(
              color: Color.fromARGB(128, 0, 0, 0),
              dismissible: false,
            ),
          LayoutBuilder(
            builder: (context, constraints) {
              return SafeArea(
                child: SingleChildScrollView(
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      minHeight: constraints.maxHeight,
                    ),
                    child: IntrinsicHeight(
                      child: Column(
                        children: [
                          WeatherInfo(
                            currentUser: currentUser,
                            city: currentCity,
                            weatherStatus: weatherStatus,
                            weatherFeedback: weatherFeedback,
                          ),
                          const SizedBox(height: 20),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 10,
                            ),
                            child: Row(
                              children: [
                                Expanded(
                                  child: MenuCard(
                                    icon: Icons.sports_soccer,
                                    text: 'Criar\nPartida',
                                    color: Colors.orange,
                                    fullWidth: false,
                                    onPressed:
                                        () => _showNavigationPopup(context),
                                  ),
                                ),
                                const SizedBox(width: 20),
                                Expanded(
                                  child: MenuCard(
                                    icon: Icons.search,
                                    text: 'Encontrar\nPartida Aberta',
                                    color: Colors.blue,
                                    fullWidth: false,
                                    onPressed: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder:
                                              (context) => const ListPartidas(),
                                        ),
                                      );
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 20),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            child: MenuCard(
                              icon: Icons.add_location_alt,
                              text: 'Adicionar Campo Público',
                              color: Colors.green,
                              fullWidth: true,
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => const AddCampo(),
                                  ),
                                );
                              },
                            ),
                          ),
                          const SizedBox(height: 10),
                          if (currentUser is Arrendador) ...[
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                              ),
                              child: MenuCard(
                                icon: Icons.sports_soccer,
                                text: 'Gerir\nOs Meus Campos',
                                color: Colors.blue,
                                fullWidth: true,
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => const ArrCamposList(),
                                    ),
                                  );
                                },
                              ),
                            ),
                            const SizedBox(height: 10),
                          ],
                          Column(
                            children: [
                              Container(
                                height: 100,
                                color: const Color.fromARGB(0, 0, 0, 0),
                              ),
                              CarouselBar(
                                newsItems: [
                                  '🔥 Novas funcionalidades disponíveis!',
                                  '⚽ Partidas abertas neste fim de semana!',
                                  '📢 Atualiza o teu perfil e ganha recompensas!',
                                ],
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
          MovableFab(currentUser: currentUser),
        ],
      ),
    );
  }

  void _showNavigationPopup(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          backgroundColor: const Color.fromARGB(255, 255, 255, 255),
          title: const Center(
            child: Text(
              'Escolha uma opção',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
          content: SizedBox(
            width: 300,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: MenuCard(
                    icon: Icons.lock,
                    text: 'Reservar\nCampo Privado',
                    color: Colors.orange,
                    fullWidth: true,
                    onPressed: () {
                      Navigator.pop(context);
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder:
                              (context) =>
                                  const ListCampos(filtroTipo: 'privado'),
                        ),
                      );
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: MenuCard(
                    icon: Icons.public,
                    text: 'Jogar num\nCampo Público',
                    color: Colors.blue,
                    fullWidth: true,
                    onPressed: () {
                      Navigator.pop(context);
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder:
                              (context) =>
                                  const ListCampos(filtroTipo: 'publico'),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> fetchWeatherData() async {
    final weatherData = await weatherService.getLocationAndFetchWeather();
    setState(() {
      weatherStatus = weatherData['weatherStatus'] ?? '';
      weatherFeedback = weatherData['weatherFeedback'] ?? '';
      currentCity = weatherData['city'] ?? 'Cidade desconhecida';
    });
  }
}
