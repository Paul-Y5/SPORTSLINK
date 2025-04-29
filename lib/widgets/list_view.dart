import 'package:flutter/material.dart';
import 'package:sports_link/models/campo.dart';
import 'package:sports_link/widgets/card_campo.dart';

Widget buildListView(List<Campo> camposFiltrados) {
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
  List<Campo> camposFiltrados,
  int camposVisiveis,
  VoidCallback onLoadMore,
) {
  final bool mostrarBotao = camposFiltrados.length > camposVisiveis;
  final int itemCount =
      mostrarBotao ? camposVisiveis + 1 : camposFiltrados.length;

  return camposFiltrados.isEmpty
      ? const Center(
        child: Text(
          'Nenhum campo encontrado.',
          style: TextStyle(color: Colors.white),
        ),
      )
      : ListView.builder(
        padding: const EdgeInsets.symmetric(horizontal: 12),
        itemCount: itemCount,
        itemBuilder: (context, index) {
          if (mostrarBotao && index == camposVisiveis) {
            return Center(
              child: IconButton(
                icon: const Icon(
                  Icons.arrow_drop_down_sharp,
                  size: 32,
                  color: Colors.orange,
                ),
                onPressed: onLoadMore,
              ),
            );
          }
          return CardCampo(campo: camposFiltrados[index]);
        },
      );
}
