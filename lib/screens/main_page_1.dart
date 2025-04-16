import 'package:flutter/material.dart';
import 'package:sports_link/data/my_user.dart';
import 'package:sports_link/models/utilizador.dart';
import 'package:sports_link/styles/carouselbg.dart';
import 'package:sports_link/utils/weather_fetch.dart';
import 'package:sports_link/widgets/weather_info.dart';
import 'package:sports_link/styles/custom_appbar.dart';
import 'package:sports_link/widgets/notification_dropdown.dart' as notification_dropdown;
import 'package:sports_link/widgets/menu_card.dart';

class MainPage1 extends StatefulWidget {
  const MainPage1({super.key});

  @override
  State<MainPage1> createState() => _MainPage1State();
}

class _MainPage1State extends State<MainPage1> {
  late Utilizador currentUser;
  int notificationCount = 3;
  bool isDropdownOpen = false;
  String weatherStatus = '';
  String weatherFeedback = '';
  String currentCity = '';
  final WeatherFetch weatherService = WeatherFetch();
  final GlobalKey notificationButtonKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    currentUser = getMyUser();
    fetchWeatherData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      extendBodyBehindAppBar: true,
      body: Stack(
        children: [
          const Carouselbg(), // Fundo
          if (isDropdownOpen)
            ModalBarrier(
              color: const Color.fromARGB(128, 0, 0, 0),
              dismissible: false,
            ),
          Scaffold(
            backgroundColor: Colors.transparent,
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
            body: LayoutBuilder(
              builder: (context, constraints) {
                return SingleChildScrollView(
                  child: ConstrainedBox(
                    constraints: BoxConstraints(minHeight: constraints.maxHeight),
                    child: IntrinsicHeight(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16.0,
                          vertical: 100,
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            // Informações do clima
                            WeatherInfo(
                              city: currentCity,
                              weatherStatus: weatherStatus,
                              weatherFeedback: weatherFeedback,
                            ),
                            const SizedBox(height: 20),
                            // Menu de opções
                            Row(
                              children: [
                                Expanded(
                                  child: MenuCard(
                                    icon: Icons.sports_soccer,
                                    text: 'Criar\nPartida',
                                    color: Colors.orange,
                                    fullWidth: false,
                                    onPressed:() => _showNavigationPopup(context),
                                  ),
                                ),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: MenuCard(
                                    icon: Icons.search,
                                    text: 'Encontrar\nPartida Aberta',
                                    color: Colors.blue,
                                    fullWidth: false,
                                    onPressed: () {
                                      // Lógica para encontrar partidas
                                    },
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 20),
                            MenuCard(
                              icon: Icons.add_location_alt,
                              text: 'Adicionar Campo',
                              color: Colors.green,
                              fullWidth: true,
                              onPressed: () {
                                // Lógica para adicionar campo
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  //Lógica da página

  // Método para abrir o menu suspenso
  void _toggleDropdownOverlay(BuildContext context, List<PopupMenuEntry<String>> items) {
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

  // Método para mostrar o menu de notificações
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

  // Método para mostrar o popup de navegação
  void _showNavigationPopup(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: const Text('Escolha uma opção'),
          content: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  MenuCard(
                    icon: Icons.lock,
                    text: 'Reservar\nCampo Privado',
                    color: Colors.orange,
                    fullWidth: false,
                  ),
                  MenuCard(
                    icon: Icons.public,
                    text: 'Jogar em\nCampo Público',
                    color: Colors.blue,
                    fullWidth: false,
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  // Método para pesquisar os dados do clima
  Future<void> fetchWeatherData() async {
    final weatherData = await weatherService.getLocationAndFetchWeather();
    setState(() {
      weatherStatus = weatherData['weatherStatus']!;
      weatherFeedback = weatherData['weatherFeedback']!;
      currentCity = weatherData['city'] ?? 'Cidade desconhecida';
    });
  }


}

