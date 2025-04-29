import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';
import 'package:sports_link/data/mock_data.dart';
import 'package:sports_link/models/arrendador.dart';
import 'package:sports_link/models/campo.dart';
import 'package:sports_link/models/campo_priv.dart';
import 'package:sports_link/models/campo_pub.dart';
import 'package:sports_link/screens/page_reserva.dart';
import 'package:sports_link/screens/perfil_page.dart';
import 'package:sports_link/styles/carouselbg.dart';
import 'package:sports_link/widgets/menu_card.dart';

class CampoDetails extends StatefulWidget {
  final Campo campo;

  const CampoDetails({super.key, required this.campo});

  @override
  State<CampoDetails> createState() => _CampoDetailsState();
}

class _CampoDetailsState extends State<CampoDetails> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      extendBodyBehindAppBar: true,
      backgroundColor: Colors.transparent,
      body: Stack(
        children: [
          const Carouselbg(), // Fundo dinâmico
          Scaffold(
            backgroundColor: Colors.transparent,
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

                    // Imagem do campo
                    ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: Image.asset(widget.campo.imagem),
                    ),
                    const SizedBox(height: 20),

                    // Localização com mini mapa
                    MenuCard(
                      icon: Icons.location_on,
                      text: 'Localização',
                      color: Colors.orange,
                      fullWidth: true,
                      onPressed: _openMap,
                    ),
                    const SizedBox(height: 10),

                    // Card de Informações
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

                          // Informações específicas para CampoPriv
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
                                  vertical: 16,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(16),
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

                          // Informações específicas para CampoPub
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

  // Métodos auxiliares:
  String _getNomeArrendador() {
    if (widget.campo is CampoPriv) {
      final arrendadorCampo = (widget.campo as CampoPriv).idArrendador;
      for (var arrendador in mockUsers.values) {
        if (arrendador.id == arrendadorCampo) {
          return arrendador.nome;
        }
      }
    }
    return 'Entidade Pública';
  }

  String _getMetodosPagamento() {
    if (widget.campo is CampoPriv) {
      final arrendadorCampo = (widget.campo as CampoPriv).idArrendador;
      for (var arrendador in mockUsers.values) {
        arrendador as Arrendador;
        if (arrendador.id == arrendadorCampo) {
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
        builder: (context) => PageReserva(campo: widget.campo as CampoPriv),
      ),
    );
  }

  void _openArrendadorProfile() {
    if (widget.campo is CampoPriv) {
      final idArrendador = (widget.campo as CampoPriv).idArrendador;
      final arrendador = mockUsers.values.firstWhere(
        (a) => a.id == idArrendador,
      );

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => PerfilPage(user: arrendador),
        ),
      );
    }
  }
}
