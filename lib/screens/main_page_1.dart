import 'package:flutter/material.dart';
import 'package:sports_link/data/mock_data.dart';
import 'package:sports_link/data/my_user.dart';
import 'package:sports_link/models/arrendador.dart';
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
import 'package:sports_link/controllers/controller_dropdown.dart' as dpd;
import 'package:sports_link/widgets/menu_card.dart';

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
      body: Stack(
        children: [
          const Carouselbg(),
          if (isDropdownOpen)
            const ModalBarrier(
              color: Color.fromARGB(128, 0, 0, 0),
              dismissible: false,
            ),
          Scaffold(
            backgroundColor: Colors.transparent,
            appBar: CustomAppBar(
              notificationButtonKey: notificationButtonKey,
              onNotificationPressed: (context) {
                dpd.showNotificationDropdown(context, notificationButtonKey, currentUser);
              },
              onMenuPressed: (context, items) {
                dpd.toggleDropdownOverlay(context, items);
              },
            ),
            body: LayoutBuilder(
              builder: (context, constraints) {
                return SingleChildScrollView(
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
                          if (currentUser is Jogador &&
                              currentUser is! Arrendador)
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                              ),
                              child: MenuCard(
                                icon: Icons.face_retouching_natural_rounded,
                                text: 'Tornar-me Arrendador',
                                color: Colors.red,
                                fullWidth: true,
                                onPressed:
                                    () => showArrendadorFormPopup(context),
                              ),
                            ),
                          const SizedBox(height: 0),
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
                );
              },
            ),
          ),
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

  void showArrendadorFormPopup(BuildContext context) {
    final TextEditingController ibanController = TextEditingController();
    final formKey = GlobalKey<FormState>();
    bool termosAceites = false;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              title: const Text('Tornar-me Arrendador'),
              content: Form(
                key: formKey,
                child: SizedBox(
                  width: 300,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      TextFormField(
                        controller: ibanController,
                        decoration: const InputDecoration(labelText: 'IBAN'),
                        validator: (value) {
                          if (value == null || value.length < 15 || value.length > 34 || !RegExp(r'^[A-Z]{2}\d{2}[A-Z0-9]{1,30}$').hasMatch(value)) {
                            return 'IBAN inválido.';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          Checkbox(
                            value: termosAceites,
                            onChanged: (value) {
                              setState(() {
                                termosAceites = value ?? false;
                              });
                            },
                          ),
                          const Expanded(
                            child: Text(
                              'Aceito os Termos e Condições',
                              style: TextStyle(fontSize: 14),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              actions: [
                TextButton(
                  style: TextButton.styleFrom(
                    foregroundColor: Colors.red,
                  ),
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text('Cancelar', style: TextStyle(color: Colors.black)),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: termosAceites ? Colors.orange : Colors.grey,
                    disabledBackgroundColor: Colors.grey,
                  ),
                  onPressed:
                      termosAceites
                          ? () {
                            if (formKey.currentState!.validate()) {
                              Navigator.of(context).pop();
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text(
                                    'A tua conta de arrendador foi criada com sucesso!\nTerás acesso a novas funcionalidades depois das informações serem validadas.',
                                    style: TextStyle(color: Colors.black),
                                  ),
                                ),
                              );
                              if (currentUser is Jogador) {
                                final jogador = currentUser as Jogador;
                              mockUsers[widget.id] = Arrendador(
                                id: widget.id,
                                nivel: currentUser.nivel,
                                nome: jogador.nome,
                                email: jogador.email,
                                iban: ibanController.text, 
                                noCampos: 0,
                                numTele: jogador.numTele,
                                password: jogador.password,
                                nacionalidade: jogador.nacionalidade,
                                idade: jogador.idade,
                                descricao: jogador.descricao,
                                utilizador: jogador.utilizador,
                                createDate: jogador.createDate,
                              );}
                            }
                          }
                          : null,
                  child: const Text('Submeter', style: TextStyle(color: Colors.black)),
                ),
              ],
            );
          },
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
