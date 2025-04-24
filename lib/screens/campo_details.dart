import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:sports_link/data/mock_data.dart';
import 'package:sports_link/models/campo.dart';
import 'package:sports_link/models/campo_priv.dart';
import 'package:sports_link/models/campo_pub.dart';
import 'package:sports_link/screens/page_reserva.dart';
import 'package:sports_link/styles/carouselbg.dart';

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
      appBar: AppBar(
        title: Text(
          widget.campo.nome,
          style: const TextStyle(color: Colors.orange),
        ),
        backgroundColor: const Color.fromARGB(255, 6, 6, 6),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.orange),
          onPressed: () {
            Navigator.pop(context); // Volta para a página anterior
          },
        ),
      ),
      body: Stack(
        children: [
          const Carouselbg(), // Fundo com o Carousel
          SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Título
                  Text(
                    widget.campo.nome,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.orange,
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Imagem do campo
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: widget.campo.imagem,
                  ),
                  const SizedBox(height: 16),

                  // Localização com mapa
                  Row(
                    children: [
                      const Icon(Icons.location_on, color: Colors.orange),
                      const SizedBox(width: 8),
                      Expanded(
                        child: GestureDetector(
                          onTap: _openMap, // Método para abrir o mapa
                          child: Text(
                            '${widget.campo.ponto.latitude}, ${widget.campo.ponto.longitude}',
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // Mapa Miniatura com borda
                  Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.orange, width: 2),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: SizedBox(
                      height: 200,
                      child: FlutterMap(
                        options: MapOptions(
                          onTap: (tapPosition, point) {
                            _openMap(); // Abre o mapa em tela cheia ao clicar
                          },
                          minZoom: 15.0,
                          maxZoom: 18.0,
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
                                point: LatLng(
                                  widget.campo.ponto.latitude,
                                  widget.campo.ponto.longitude,
                                ),
                                child: const Icon(
                                  Icons.location_pin,
                                  color: Colors.orange,
                                  size: 40,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Descrição com fundo branco e texto preto
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Descrição',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                        const SizedBox(height: 8),

                        // Informações específicas para CampoPriv
                        if (widget.campo is CampoPriv) ...[
                          Text(
                            'Responsável: ${_getNomeArrendador()}',
                            style: const TextStyle(
                              fontSize: 16,
                              color: Colors.black,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Preço: ${(widget.campo as CampoPriv).preco.toStringAsFixed(2)}€/h',
                            style: const TextStyle(
                              fontSize: 16,
                              color: Colors.black,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Métodos de Pagamento: ${_getMetodosPagamento()}',
                            style: const TextStyle(
                              fontSize: 16,
                              color: Colors.black,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Horários de Funcionamento: ${_getHorariosFuncionamento()}',
                            style: const TextStyle(
                              fontSize: 16,
                              color: Colors.black,
                            ),
                          ),
                        ],

                        // Informações específicas para CampoPub
                        if (widget.campo is CampoPub) ...[
                          Text(
                            'Entidade Responsável: ${(widget.campo as CampoPub).entidadePublicaResp}',
                            style: const TextStyle(
                              fontSize: 16,
                              color: Colors.black,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Estado: ${(widget.campo as CampoPub).ocupado ? "Ocupado" : "Disponível"}',
                            style: const TextStyle(
                              fontSize: 16,
                              color: Colors.black,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Botão "Agendar Reserva" (apenas para CampoPriv)
                  if (widget.campo is CampoPriv)
                    ElevatedButton(
                      onPressed: () {
                        // Lógica para agendar reserva
                        _scheduleReservation();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.orange,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                      child: const Text(
                        'Agendar Reserva',
                        style: TextStyle(
                          fontSize: 18, // Aumenta o tamanho do texto
                          color: Colors.black, // Altera a cor do texto para preto
                        ),
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

  // Método para obter o nome do arrendador
  String _getNomeArrendador() {
    if (widget.campo is CampoPriv) {
      final arrendadorCampo = (widget.campo as CampoPriv).idArrendador;
      for (var arrendador in mockArrendadores) {
        if (arrendador.id == arrendadorCampo) {
          return arrendador.nome;
        }
      }
    }
    return 'Entidade Pública';
  }

  // Método para obter os métodos de pagamento
  String _getMetodosPagamento() {
    if (widget.campo is CampoPriv) {
      final arrendadorCampo = (widget.campo as CampoPriv).idArrendador;
      for (var arrendador in mockArrendadores) {
        if (arrendador.id == arrendadorCampo) {
          return arrendador.metodosPagamento.values.join(', ');
        }
      }
    }
    return 'Gratuito';
  }

  // Método para obter os horários de funcionamento
  String _getHorariosFuncionamento() {
    if (widget.campo is CampoPriv) {
      final campoPriv = widget.campo as CampoPriv;
      return campoPriv.diasFuncionamento.entries
          .map((entry) =>
              '${entry.key}: ${entry.value[0].format(context)} - ${entry.value[1].format(context)}')
          .join(', ');
    }
    return 'Horário não disponível';
  }

  // Método para abrir o mapa em tela cheia ao clicar na localização
  void _openMap() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Localização do Campo"),
          content: SizedBox(
            height: 300,
            child: FlutterMap(
              options: MapOptions(
                initialCenter: LatLng(
                  widget.campo.ponto.latitude,
                  widget.campo.ponto.longitude,
                ),
                minZoom: 15.0,
                maxZoom: 18.0,
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
                      point: LatLng(
                        widget.campo.ponto.latitude,
                        widget.campo.ponto.longitude,
                      ),
                      child: const Icon(
                        Icons.location_pin,
                        color: Colors.orange,
                        size: 40,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Fechar'),
            ),
          ],
        );
      },
    );
  }

  // Método para agendar reserva
  void _scheduleReservation() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PageReserva(campo: widget.campo),
      ),
    );
  }
}
