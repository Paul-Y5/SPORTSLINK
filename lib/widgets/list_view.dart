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
