import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:sports_link/models/campo.dart';
import 'package:sports_link/models/campo_priv.dart';
import 'package:sports_link/models/campo_pub.dart';

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
      appBar: AppBar(
        title: Text(widget.campo.nome),
        backgroundColor: Colors.orange,
      ),
      body: SingleChildScrollView(
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

              // Mapa Miniatura
              SizedBox(
                height: 200,
                child: FlutterMap(
                  options: MapOptions(
                    onTap: (tapPosition, point) {
                      // Handle tap event here if needed
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
              const SizedBox(height: 16),

              // Exibição condicional para campos públicos ou privados
              widget.campo is CampoPriv
                  ? _buildPrivateFieldDetails()
                  : _buildPublicFieldDetails(),

              const SizedBox(height: 16),

              // Botões de ação
              ElevatedButton(
                onPressed: () {
                  // Lógica para adicionar
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orange,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: const Text('Adicionar', style: TextStyle(fontSize: 16)),
              ),
              const SizedBox(height: 8),
              OutlinedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: Colors.black),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: const Text(
                  'Cancelar',
                  style: TextStyle(fontSize: 16, color: Colors.black),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Método para abrir o mapa em tela cheia ao clicar na localização
  void _openMap() {
    // Aqui você pode implementar a lógica para abrir o mapa em uma nova tela
    // ou em um modal, se preferir
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

  // Widget para detalhes de campos privados
  Widget _buildPrivateFieldDetails() {
    CampoPriv campoPriv = widget.campo as CampoPriv;
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Responsável
          Text(
            'Responsável: ${campoPriv.idArrendador}',
            style: const TextStyle(
              fontSize: 14,
              color: Colors.blue,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          // Outros detalhes do campo privado...
        ],
      ),
    );
  }

  // Widget para detalhes de campos públicos
  Widget _buildPublicFieldDetails() {
    CampoPub campoPub = widget.campo as CampoPub;
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Entidade pública responsável
          const Text(
            'Entidade Pública Responsável:',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          Text(
            campoPub.entidadePublicaResp,
            style: const TextStyle(
              fontSize: 14,
              color: Colors.blue,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
