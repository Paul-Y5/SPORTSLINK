import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';
import 'package:sports_link/utils/location_service.dart'; // Import da classe utilitária
import 'package:sports_link/models/ponto.dart';
import 'package:sports_link/styles/carouselbg.dart';
import 'package:sports_link/models/campo_pub.dart';
import 'package:sports_link/data/mock_data.dart';
import 'package:sports_link/utils/abrir_mapa.dart';

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

  @override
  void initState() {
    super.initState();
    _initializeLocation();
  }

  Future<void> _initializeLocation() async {
    final location = await LocationService.getCurrentLocation();
    setState(() {
      selectedLocation = location;
      if (location != null) {
        latitudeController.text = location.latitude.toString();
        longitudeController.text = location.longitude.toString();
      }
    });
  }

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
                      const SizedBox(height: 16),
                      TextField(
                        controller: campoPriceController,
                        decoration: InputDecoration(
                          labelText: 'Entidade Pública Responsável',
                          labelStyle: const TextStyle(
                            color: Color.fromARGB(255, 0, 0, 0),
                          ),
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
                      TextField(
                        controller: campoDescriptionController,
                        decoration: InputDecoration(
                          labelText: 'Descrição',
                          labelStyle: const TextStyle(
                            color: Color.fromARGB(255, 0, 0, 0),
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: const BorderSide(color: Colors.orange),
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        maxLines: 3,
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