import 'package:flutter/material.dart';
import 'package:sports_link/data/my_user.dart';
import 'package:sports_link/models/utilizador.dart';
import 'package:sports_link/styles/carouselbg.dart';
import 'package:sports_link/utils/weather_fetch.dart';
import 'package:weather_icons/weather_icons.dart';
import 'package:sports_link/styles/custom_appbar.dart';

class MainPage1 extends StatefulWidget {
  const MainPage1({super.key});

  @override
  State<MainPage1> createState() => _MainPage1State();
}

class _MainPage1State extends State<MainPage1> {
  late Utilizador currentUser;
  int notificationCount = 3;
  bool isDropdownOpen = false; // Controla o estado do dropdown
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

  Future<void> fetchWeatherData() async {
    final weatherData = await weatherService.getLocationAndFetchWeather();
    setState(() {
      weatherStatus = weatherData['weatherStatus']!;
      weatherFeedback = weatherData['weatherFeedback']!;
      currentCity = weatherData['city'] ?? 'Cidade desconhecida'; // Atualize o nome da cidade
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      body: Stack(
        children: [
          const Carouselbg(),
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
                showNotificationDropdown(
                  context: context,
                  notificationButtonKey: notificationButtonKey,
                  items: [
                    _buildNotificationItem('Reserva #1234 confirmada com sucesso'),
                    _buildNotificationItem('Nova mensagem de Rafael'),
                    _buildNotificationItem('Partida #5678 foi cancelada'),
                  ],
                  onClose: () {
                    setState(() {
                      isDropdownOpen = false;
                    });
                  },
                );
              },
              onMenuPressed: _toggleDropdownOverlay,
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
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                              child: Container(
                                padding: const EdgeInsets.all(16),
                                margin: const EdgeInsets.only(bottom: 16),
                                decoration: BoxDecoration(
                                  color: const Color.fromARGB(128, 0, 0, 0), // Fundo com transparência
                                  borderRadius: BorderRadius.circular(16),
                                  border: Border.all(color: Colors.white24),
                                ),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    // Ícone do clima
                                    Icon(
                                      _getWeatherIcon(weatherStatus), // Obtém o ícone baseado no clima
                                      color: Colors.white,
                                      size: 50,
                                    ),
                                    const SizedBox(width: 16), // Espaçamento entre o ícone e o texto
                                    // Texto com cidade, status e feedback do clima
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            '📍 $currentCity — $weatherStatus', // Exibe o nome da cidade e o status do clima
                                            style: const TextStyle(color: Colors.white, fontSize: 16),
                                          ),
                                          const SizedBox(height: 4),
                                          Text(
                                            weatherFeedback, // Exibe o feedback do clima
                                            style: const TextStyle(color: Colors.white, fontSize: 14),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Row(
                              children: [
                                Expanded(
                                  child: menuCard(
                                    Icons.sports_soccer,
                                    'Criar\nPartida',
                                    Colors.orange,
                                  ),
                                ),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: menuCard(
                                    Icons.search,
                                    'Encontrar\nPartida Aberta',
                                    Colors.blue,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 20),
                            menuCard(
                              Icons.add_location_alt,
                              'Adicionar Campo',
                              Colors.green,
                              fullWidth: true,
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
        isDropdownOpen = false; // Fecha o dropdown
      });
    });
  }


  PopupMenuItem<String> _buildNotificationItem(String text) {
    return PopupMenuItem(
      value: 'notification',
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: const Color.fromARGB(200, 0, 0, 0), // Fundo do item com transparência
        ),
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 10),
        child: Row(
          children: [
            const Icon(Icons.notifications, color: Colors.orange),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                text,
                style: const TextStyle(color: Colors.white),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget menuCard(
    IconData icon,
    String text,
    Color color, {
    bool fullWidth = false,
  }) {
    return Container(
      width: fullWidth ? double.infinity : 150,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color.fromARGB(128, 0, 0, 0), // Fundo com transparência
        borderRadius: BorderRadius.circular(20),
      ),
      margin: const EdgeInsets.symmetric(vertical: 10),
      child: Column(
        children: [
          CircleAvatar(
            backgroundColor: color,
            child: Icon(icon, color: Colors.white),
          ),
          const SizedBox(height: 8),
          Text(
            text,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  // Método para obter o ícone do clima baseado no tempo atual
  IconData _getWeatherIcon(String weatherStatus) {
    if (weatherStatus.toLowerCase().contains('clear')) {
      return WeatherIcons.day_sunny; // Ícone para clima ensolarado
    } else if (weatherStatus.toLowerCase().contains('cloud')) {
      return WeatherIcons.cloud; // Ícone para clima nublado
    } else if (weatherStatus.toLowerCase().contains('rain')) {
      return WeatherIcons.rain; // Ícone para chuva
    } else if (weatherStatus.toLowerCase().contains('snow')) {
      return WeatherIcons.snow; // Ícone para neve
    } else if (weatherStatus.toLowerCase().contains('thunderstorm')) {
      return WeatherIcons.thunderstorm; // Ícone para tempestade
    } else {
      return WeatherIcons.na; // Ícone genérico para condições desconhecidas
    }
  }
}
