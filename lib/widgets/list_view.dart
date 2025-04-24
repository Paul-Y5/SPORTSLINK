import 'package:flutter/material.dart';
import 'package:sports_link/models/campo_priv.dart';
import 'package:sports_link/widgets/card_campo.dart';

Widget buildListView(List<CampoPriv> camposFiltrados) {
  return camposFiltrados.isEmpty
      ? const Center(
        child: Text(
          'Nenhum campo encontrado.',
          style: TextStyle(color: Colors.white),
        ),
      )
      : ListView.builder(
        padding: const EdgeInsets.symmetric(horizontal: 12),
        itemCount: camposFiltrados.length,
        itemBuilder: (context, index) {
          return CardCampo(campo: camposFiltrados[index]);
        },
      );
      
}

Widget buildListViewWithLoadMore(
  List<CampoPriv> camposFiltrados,
  int camposVisiveis,
  Function onLoadMore,
) {
  return camposFiltrados.isEmpty
      ? const Center(
          child: Text(
            'Nenhum campo encontrado.',
            style: TextStyle(color: Colors.white),
          ),
        )
      : ListView.builder(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          itemCount: camposFiltrados.length > camposVisiveis
              ? camposVisiveis + 1
              : camposFiltrados.length,
          itemBuilder: (context, index) {
            if (index == camposVisiveis) {
              // Botão para carregar mais campos
              return Center(
                child: IconButton(
                  icon: const Icon(Icons.arrow_drop_down_sharp, size: 32, color: Colors.orange),
                  onPressed: () => onLoadMore(),
                ),
              );
            }
            // Exibe os campos visíveis
            return CardCampo(campo: camposFiltrados[index]);
          },
        );
}

Widget buildCampoCard(CampoPriv campo) {
  return CardCampo(campo: campo);
}
