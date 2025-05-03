import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';
import 'package:provider/provider.dart';
import 'package:sports_link/controllers/controller_dropdown.dart' as dpd;
import 'package:sports_link/data/mock_data.dart';
import 'package:sports_link/controllers/user_provider.dart';
import 'package:sports_link/models/arrendador.dart';
import 'package:sports_link/models/campo.dart';
import 'package:sports_link/models/campo_priv.dart';
import 'package:sports_link/models/campo_pub.dart';
import 'package:sports_link/models/jogador.dart';
import 'package:sports_link/screens/page_reserva.dart';
import 'package:sports_link/screens/partida_page.dart';
import 'package:sports_link/screens/perfil_page.dart';
import 'package:sports_link/styles/carouselbg.dart';
import 'package:sports_link/styles/custom_appbar.dart';
import 'package:sports_link/widgets/menu_card.dart';

class CampoDetails extends StatefulWidget {
  final Campo campo;

  const CampoDetails({super.key, required this.campo});

  @override
  State<CampoDetails> createState() => _CampoDetailsState();
}

class _CampoDetailsState extends State<CampoDetails> {
  bool isDropdownOpen = false; // Variável para controlar o estado do dropdown
  final GlobalKey notificationButtonKey = GlobalKey(); // Chave para o botão de notificações

  @override
  Widget build(BuildContext context) {
    // Obter o utilizador atual do Provider
    final currentUser = Provider.of<UserProvider>(context).user;

    return Scaffold(
      extendBody: true,
      extendBodyBehindAppBar: true,
      backgroundColor: Colors.transparent,
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
                setState(() {
                  isDropdownOpen = !isDropdownOpen;
                });
                dpd.toggleDropdownOverlay(context, items);
              },
              user: currentUser as Jogador,
            ),
            body: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 40,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Center(
                      child: Text(
                        widget.campo.nome,
                        style: const TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: Colors.orange,
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: Image.asset(widget.campo.imagem),
                    ),
                    const SizedBox(height: 20),
                    MenuCard(
                      icon: Icons.location_on,
                      text: 'Localização',
                      color: Colors.orange,
                      fullWidth: true,
                      onPressed: _openMap,
                    ),
                    const SizedBox(height: 10),
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Informações',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                          const SizedBox(height: 10),

                          if (widget.campo is CampoPriv) ...[
                            GestureDetector(
                              onTap: _openArrendadorProfile,
                              child: Text(
                                'Responsável: ${_getNomeArrendador()}',
                                style: const TextStyle(
                                  fontSize: 16,
                                  color: Colors.blue,
                                  decoration: TextDecoration.underline,
                                ),
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Preço: ${(widget.campo as CampoPriv).preco.toStringAsFixed(2)}€/h',
                              style: const TextStyle(fontSize: 16),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Métodos de Pagamento: ${_getMetodosPagamento()}',
                              style: const TextStyle(fontSize: 16),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Horários: ${_getHorariosFuncionamento()}',
                              style: const TextStyle(fontSize: 16),
                            ),
                            const SizedBox(height: 20),
                            ElevatedButton(
                              onPressed: _scheduleReservation,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.orange,
                                padding: const EdgeInsets.symmetric(
                                  vertical: 12,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              child: const Text(
                                'Agendar Reserva',
                                style: TextStyle(
                                  fontSize: 18,
                                  color: Colors.black,
                                ),
                              ),
                            ),
                          ],

                          if (widget.campo is CampoPub) ...[
                            Text(
                              'Entidade Responsável: ${(widget.campo as CampoPub).entidadePublicaResp}',
                              style: const TextStyle(fontSize: 16),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Estado: ${(widget.campo as CampoPub).ocupado ? "Ocupado" : "Disponível"}',
                              style: const TextStyle(fontSize: 16),
                            ),
                            const SizedBox(height: 20),
                            ElevatedButton(
                              onPressed: (widget.campo as CampoPub).ocupado
                                  ? null // Desabilitar o botão se o campo estiver ocupado
                                  : _showStartMatchPopup, // Função para abrir o popup
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.orange,
                                padding: const EdgeInsets.symmetric(
                                  vertical: 12,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              child: const Text(
                                'Começar Partida',
                                style: TextStyle(
                                  fontSize: 18,
                                  color: Colors.black,
                                ),
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _getNomeArrendador() {
    if (widget.campo is CampoPriv) {
      final idArrendador = (widget.campo as CampoPriv).idArrendador;
      for (var arrendador in mockUsers.values) {
        if (arrendador.id == idArrendador) {
          return arrendador.nome;
        }
      }
    }
    return 'Entidade Pública';
  }

  String _getMetodosPagamento() {
    if (widget.campo is CampoPriv) {
      final idArrendador = (widget.campo as CampoPriv).idArrendador;
      for (var arrendador in mockUsers.values) {
        arrendador as Arrendador;
        if (arrendador.id == idArrendador) {
          return arrendador.metodosPagamento.values.join(', ');
        }
      }
    }
    return 'Gratuito';
  }

  String _getHorariosFuncionamento() {
    if (widget.campo is CampoPriv) {
      final campoPriv = widget.campo as CampoPriv;
      return campoPriv.diasFuncionamento.entries
          .map(
            (entry) =>
                '${entry.key}: ${entry.value[0].format(context)} - ${entry.value[1].format(context)}',
          )
          .join(', ');
    }
    return 'Horário não disponível';
  }

  void _openMap() async {
    final userPosition = await Geolocator.getCurrentPosition(
      locationSettings: const LocationSettings(accuracy: LocationAccuracy.high),
    );

    final startPoint = LatLng(userPosition.latitude, userPosition.longitude);
    final endPoint = LatLng(
      widget.campo.ponto.latitude,
      widget.campo.ponto.longitude,
    );

    showDialog(
      // ignore: use_build_context_synchronously
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: const Center(
            child: Text(
              "Localização do Campo",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          content: SizedBox(
            height: 300,
            width: 300,
            child: FlutterMap(
              options: MapOptions(
                initialCenter: endPoint,
                minZoom: 13.0,
                maxZoom: 20.0,
                interactionOptions: const InteractionOptions(
                  flags: InteractiveFlag.pinchZoom | InteractiveFlag.drag,
                ),
              ),
              children: [
                TileLayer(
                  urlTemplate:
                      "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
                  subdomains: ['a', 'b', 'c'],
                ),
                MarkerLayer(
                  markers: [
                    Marker(
                      point: startPoint,
                      child: const Icon(
                        Icons.person_pin_circle,
                        color: Colors.blue,
                        size: 40,
                      ),
                    ),
                    Marker(
                      point: endPoint,
                      child: const Icon(
                        Icons.location_pin,
                        color: Colors.orange,
                        size: 40,
                      ),
                    ),
                  ],
                ),
                PolylineLayer(
                  polylines: [
                    Polyline(
                      points: [startPoint, endPoint],
                      strokeWidth: 4.0,
                      color: Colors.orange,
                    ),
                  ],
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Fechar'),
            ),
          ],
        );
      },
    );
  }

  void _scheduleReservation() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder:
            (context) =>
                PageReserva(campo: widget.campo as CampoPriv, user: Provider.of<UserProvider>(context).user as Jogador),
      ),
    );
  }

  void _openArrendadorProfile() {
    if (widget.campo is CampoPriv) {
      final idArrendador = (widget.campo as CampoPriv).idArrendador;
      final arrendador =
          mockUsers.values.firstWhere((a) => a.id == idArrendador)
              as Arrendador;

      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => PerfilPage(user: arrendador)),
      );
    }
  }

  void _showStartMatchPopup() {
  final TextEditingController tempoEsperaController = TextEditingController();
  final TextEditingController minJogadoresController = TextEditingController();
  CampoPub? campoSelecionado;

  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text('Configurar Partida'),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Tempo de Espera (minutos):',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              TextField(
                controller: tempoEsperaController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  hintText: 'Ex: 10',
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'Número Mínimo de Jogadores:',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              TextField(
                controller: minJogadoresController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  hintText: 'Ex: 4',
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'Selecionar Campo Público Disponível:',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              DropdownButton<CampoPub>(
                isExpanded: true,
                value: campoSelecionado,
                hint: const Text('Selecione um campo'),
                items: mockCampos
                    .whereType<CampoPub>()
                    .where((campo) => !campo.ocupado)
                    .map((campo) {
                  return DropdownMenuItem<CampoPub>(
                    value: campo,
                    child: Text(campo.nome),
                  );
                }).toList(),
                onChanged: (CampoPub? novoCampo) {
                  setState(() {
                    campoSelecionado = novoCampo;
                  });
                },
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () {
              if (tempoEsperaController.text.isEmpty ||
                  minJogadoresController.text.isEmpty ||
                  campoSelecionado == null) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Preencha todos os campos!'),
                  ),
                );
                return;
              }

              // Confirmar informações e redirecionar para a página da partida
              Navigator.of(context).pop();
              _startMatch(
                int.parse(tempoEsperaController.text),
                int.parse(minJogadoresController.text),
                campoSelecionado!,
              );
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.orange),
            child: const Text('Confirmar'),
          ),
        ],
      );
    },
  );
}

  void _startMatch(int tempoEspera, int minJogadores, CampoPub campoSelecionado) {
    setState(() {
      campoSelecionado.ocupado = true; // Atualizar o estado do campo para ocupado
    });

    // Exibir mensagem de sucesso
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Partida iniciada no campo ${campoSelecionado.nome}!',
        ),
      ),
    );

    // Redirecionar para a página da partida
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PartidaPage(
          campo: campoSelecionado,
          tempoEspera: tempoEspera,
          minJogadores: minJogadores,
        ),
      ),
    );
  }
}
