import 'package:flutter/material.dart';
import 'package:sports_link/data/my_user.dart';
import 'package:sports_link/models/jogador.dart';
import 'package:sports_link/models/utilizador.dart';
import 'package:sports_link/screens/add_campo.dart';
import 'package:sports_link/screens/list_campos.dart';
import 'package:sports_link/screens/list_partidas.dart';
import 'package:sports_link/styles/carousel_bar.dart';
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
    currentUser = getMyUser(1);


    WidgetsBinding.instance.addPostFrameCallback((_) {
      fetchWeatherData();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      extendBodyBehindAppBar: true,
      body: Stack(
        children: [
          const Carouselbg(), // Fundo dinâmico
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
              }, user: currentUser as Jogador, // Adicione o usuário atual aqui
            ),
            body: LayoutBuilder(
              builder: (context, constraints) {
                return SingleChildScrollView(
                  child: ConstrainedBox(
                    constraints: BoxConstraints(minHeight: constraints.maxHeight),
                    child: IntrinsicHeight(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          // Informações do clima ocupando toda a largura
                          WeatherInfo(
                            currentUser: currentUser,
                            city: currentCity,
                            weatherStatus: weatherStatus,
                            weatherFeedback: weatherFeedback
                          ),
                          const SizedBox(height: 20),
                          // Menu de opções
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                            child: Row(
                              children: [
                                Expanded(
                                  child: MenuCard(
                                    icon: Icons.sports_soccer,
                                    text: 'Criar\nPartida',
                                    color: Colors.orange,
                                    fullWidth: false,
                                    onPressed: () => _showNavigationPopup(context),
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
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => const ListPartidas(),
                                        ),
                                      );
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 10),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 0),
                            child: MenuCard(
                              icon: Icons.add_location_alt,
                              text: 'Adicionar Campo',
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
                          const SizedBox(height: 120),
                          CarouselBar(
                            newsItems: [
                              '🔥 Novas funcionalidades disponíveis!',
                              '⚽ Partidas abertas neste fim de semana!',
                              '📢 Atualize seu perfil e ganhe recompensas!',
                            ],
                          ),
                        ],
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
                      Navigator.pop(context); // Fecha o popup primeiro
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const ListCampos(),
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
                          builder: (context) => const ListCampos(),
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

