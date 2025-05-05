import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:sports_link/models/ponto.dart';
import 'package:sports_link/styles/carouselbg.dart'; // Import do carousel de imagens de fundo
import 'package:sports_link/models/campo_pub.dart'; // Modelo de Campo Público
import 'package:sports_link/data/mock_data.dart'; // Mock data para armazenar os campos

class AddCampo extends StatefulWidget {
  const AddCampo({super.key});

  @override
  State<AddCampo> createState() => _AddCampoState();
}

class _AddCampoState extends State<AddCampo> {
  final TextEditingController campoNameController = TextEditingController();
  final TextEditingController campoPriceController = TextEditingController();
  final TextEditingController campoDescriptionController = TextEditingController();
  final TextEditingController latitudeController = TextEditingController();
  final TextEditingController longitudeController = TextEditingController();
  final TextEditingController comprimentoController = TextEditingController();
  final TextEditingController larguraController = TextEditingController();

  LatLng? selectedLocation; // Localização selecionada no mapa

  void _abrirMapa() async {
    final LatLng? resultado = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => SelecionarLocalizacaoMapa(
          initialLocation: selectedLocation ?? LatLng(0.0, 0.0),
        ),
      ),
    );

    if (resultado != null) {
      setState(() {
        selectedLocation = resultado;
        latitudeController.text = resultado.latitude.toString();
        longitudeController.text = resultado.longitude.toString();
      });
    }
  }

  void _adicionarCampo() {
    // Criar um novo ponto com latitude e longitude fornecidos
    final novoPonto = Ponto(
      id: DateTime.now().millisecondsSinceEpoch, // Gerar um ID único
      idMapa: 0, // Exemplo de ID do mapa
      latitude: double.tryParse(latitudeController.text) ?? 0.0,
      longitude: double.tryParse(longitudeController.text) ?? 0.0,
    );

    // Criar um novo campo público com os dados fornecidos
    final novoCampo = CampoPub(
      id: DateTime.now().millisecondsSinceEpoch, // Gerar um ID único
      nome: campoNameController.text,
      ponto: novoPonto,
      entidadePublicaResp: campoPriceController.text,
      descricao: campoDescriptionController.text,
      ocupado: false,
      idPonto: novoPonto.id,
      idMapa: 0,
      comprimento: double.tryParse(comprimentoController.text) ?? 0.0,
      largura: double.tryParse(larguraController.text) ?? 0.0,
    );

    // Adicionar o campo ao array de campos públicos
    setState(() {
      mockCampos.add(novoCampo);
    });

    // Mostrar popup de confirmação
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Campo Adicionado'),
          content: const Text('O campo será confirmado e adicionado à lista de campos públicos.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Fechar o popup
                Navigator.of(context).pop(); // Voltar para a página anterior
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Adicionar Campo'),
        backgroundColor: Colors.orange, // Cor consistente com o tema da aplicação
      ),
      body: Stack(
        children: [
          // Fundo com o carousel
          const Carouselbg(),
          SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: const Color.fromARGB(200, 255, 255, 255),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Adicionar Novo Campo',
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Colors.orange,
                        ),
                      ),
                      const SizedBox(height: 16),
                      TextField(
                        controller: campoNameController,
                        decoration: InputDecoration(
                          labelText: 'Nome do Campo',
                          labelStyle: const TextStyle(color: Color.fromARGB(255, 0, 0, 0)),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: const BorderSide(color: Colors.orange),
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      GestureDetector(
                        onTap: _abrirMapa,
                        child: AbsorbPointer(
                          child: TextField(
                            controller: latitudeController,
                            decoration: InputDecoration(
                              labelText: 'Localização (clique para selecionar no mapa)',
                              labelStyle: const TextStyle(color: Color.fromARGB(255, 0, 0, 0)),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide: const BorderSide(color: Colors.orange),
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      TextField(
                        controller: comprimentoController,
                        decoration: InputDecoration(
                          labelText: 'Comprimento (opcional)',
                          labelStyle: const TextStyle(color: Color.fromARGB(255, 0, 0, 0)),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: const BorderSide(color: Colors.orange),
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        keyboardType: TextInputType.number,
                      ),
                      const SizedBox(height: 16),
                      TextField(
                        controller: larguraController,
                        decoration: InputDecoration(
                          labelText: 'Largura (opcional)',
                          labelStyle: const TextStyle(color: Color.fromARGB(255, 0, 0, 0)),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: const BorderSide(color: Colors.orange),
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        keyboardType: TextInputType.number,
                      ),
                      const SizedBox(height: 20),
                      Center(
                        child: ElevatedButton(
                          onPressed: _adicionarCampo, // Chamar a função ao clicar
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.orange,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 24,
                              vertical: 12,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child: const Text(
                            'Adicionar Campo',
                            style: TextStyle(fontSize: 16, color: Colors.black),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class SelecionarLocalizacaoMapa extends StatefulWidget {
  final LatLng initialLocation;

  const SelecionarLocalizacaoMapa({super.key, required this.initialLocation});

  @override
  State<SelecionarLocalizacaoMapa> createState() => _SelecionarLocalizacaoMapaState();
}

class _SelecionarLocalizacaoMapaState extends State<SelecionarLocalizacaoMapa> {
  LatLng? _selectedLocation;

  @override
  void initState() {
    super.initState();
    _selectedLocation = widget.initialLocation;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Selecionar Localização'),
        backgroundColor: Colors.orange,
      ),
      body: FlutterMap(
        options: MapOptions(
          initialCenter: _selectedLocation ?? LatLng(0.0, 0.0),
          minZoom: 15.0,
          maxZoom: 20.0,
          onTap: (tapPosition, LatLng location) {
            setState(() {
              _selectedLocation = location;
            });
          },
        ),
        children: [
          TileLayer(
            urlTemplate: "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
            subdomains: ['a', 'b', 'c'],
          ),
          if (_selectedLocation != null)
            MarkerLayer(
              markers: [
                Marker(
                  point: _selectedLocation!,
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
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pop(context, _selectedLocation);
        },
        backgroundColor: Colors.orange,
        child: const Icon(Icons.check, color: Colors.white),
      ),
    );
  }
}