import 'package:flutter/material.dart';
import 'package:sports_link/models/campo_priv.dart';
import 'dart:math';

import 'package:sports_link/models/desportos.dart';

class FilterWidget extends StatefulWidget {
  final List<dynamic> campos; // Lista de campos a ser filtrada
  final double minhaLatitude;
  final double minhaLongitude;
  final Function(List<dynamic>) onApplyFilters; // Callback para retornar os campos filtrados
  final bool exibirFiltroPreco; // Flag para exibir ou ocultar o filtro de preço

  const FilterWidget({
    super.key,
    required this.campos,
    required this.minhaLatitude,
    required this.minhaLongitude,
    required this.onApplyFilters,
    this.exibirFiltroPreco = false, // Por padrão, o filtro de preço não será exibido
  });

  @override
  State<FilterWidget> createState() => _FilterWidgetState();
}

class _FilterWidgetState extends State<FilterWidget> {
  double precoMin = 0;
  double precoMax = 100;
  double distanciaMax = 50; // Distância máxima em km
  List<String> desportosSelecionados = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // Fundo branco
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Filtros',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.black, // Texto preto
              ),
            ),
            const SizedBox(height: 16),

            // Filtro por Preço (exibido apenas se exibirFiltroPreco for true)
            if (widget.exibirFiltroPreco) ...[
              const Text(
                'Preço (€/h)',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.black, // Texto preto
                ),
              ),
              RangeSlider(
                values: RangeValues(precoMin, precoMax),
                min: 0,
                max: 200,
                divisions: 20,
                activeColor: Colors.orange,
                inactiveColor: const Color.fromARGB(125, 158, 158, 158), // Cor do fundo do slider
                labels: RangeLabels('${precoMin.toInt()}€', '${precoMax.toInt()}€'),
                onChanged: (values) {
                  setState(() {
                    precoMin = values.start;
                    precoMax = values.end;
                  });
                },
              ),
              const SizedBox(height: 16),
            ],

            // Filtro por Distância
            const Text(
              'Distância (km)',
              style: TextStyle(
                fontSize: 16,
                color: Colors.black, // Texto preto
              ),
            ),
            Slider(
              value: distanciaMax,
              min: 0,
              max: 100,
              divisions: 20,
              activeColor: Colors.orange,
              inactiveColor: const Color.fromARGB(125, 158, 158, 158), // Cor do fundo do slider
              label: '${distanciaMax.toInt()} km',
              onChanged: (value) {
                setState(() {
                  distanciaMax = value;
                });
              },
            ),

            const SizedBox(height: 16),

            // Filtro por Desportos
            const Text(
              'Desportos',
              style: TextStyle(
                fontSize: 16,
                color: Colors.black, // Texto preto
              ),
            ),
            Wrap(
              spacing: 8,
              children: Desportos.values.map((desporto) {
                return FilterChip(
                  label: Text(
                    desporto.name,
                    style: const TextStyle(color: Colors.black), // Texto preto
                  ),
                  selected: desportosSelecionados.contains(desporto.name),
                  selectedColor: const Color.fromARGB(150, 255, 153, 0), // Fundo laranja claro ao selecionar
                  onSelected: (selected) {
                    setState(() {
                      if (selected) {
                        desportosSelecionados.add(desporto.name);
                      } else {
                        desportosSelecionados.remove(desporto.name);
                      }
                    });
                  },
                );
              }).toList(),
            ),

            const SizedBox(height: 20),

            // Botão para Aplicar os Filtros
            ElevatedButton(
              onPressed: () {
                final camposFiltrados = _aplicarFiltros();
                widget.onApplyFilters(camposFiltrados);
                Navigator.pop(context);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.orange, // Botão laranja
                foregroundColor: const Color.fromARGB(255, 0, 0, 0), // Texto preto no botão
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text('Aplicar Filtros'),
            ),
          ],
        ),
      ),
    );
  }

  List<dynamic> _aplicarFiltros() {
    // Filtra os campos usando a lógica básica de `filterCampos`
    List<dynamic> filtrados = widget.campos.where((campo) {
      // Filtro por tipo (privado ou público)
      final tipoValido = !widget.exibirFiltroPreco || (campo is CampoPriv);

      // Filtro por nome (caso tenha uma barra de pesquisa)
      final nomeValido = campo.nome.toLowerCase().contains('');

      return tipoValido && nomeValido;
    }).toList();

    // Aplica os filtros adicionais (preço, distância e desportos)
    filtrados = filtrados.where((campo) {
      // Filtro por preço (aplicado apenas para campos privados)
      final dentroDoPreco = !widget.exibirFiltroPreco ||
          (campo is CampoPriv && campo.preco >= precoMin && campo.preco <= precoMax);

      // Filtro por distância (aplicado apenas se o campo tiver latitude e longitude)
      final dentroDaDistancia = (campo is CampoPriv)
          ? _calcularDistancia(campo.ponto.latitude, campo.ponto.longitude, widget.minhaLatitude, widget.minhaLongitude) <= distanciaMax
          : true;

      // Filtro por desportos
      final contemDesportos = desportosSelecionados.isEmpty ||
          desportosSelecionados.any((desporto) => campo.desportos.contains(desporto));

      return dentroDoPreco && dentroDaDistancia && contemDesportos;
    }).toList();

    return filtrados;
  }

  double _calcularDistancia(double lat1, double lon1, double lat2, double lon2) {
    const double raioTerra = 6371; // Raio da Terra em km
    final double dLat = (lat2 - lat1) * pi / 180;
    final double dLon = (lon2 - lon1) * pi / 180;

    final double a = sin(dLat / 2) * sin(dLat / 2) +
        cos(lat1 * pi / 180) * cos(lat2 * pi / 180) *
            sin(dLon / 2) * sin(dLon / 2);

    final double c = 2 * atan2(sqrt(a), sqrt(1 - a));
    return raioTerra * c;
  }
}