import 'package:flutter/material.dart';
import 'package:sports_link/models/arrendador.dart';
import 'package:sports_link/models/campo.dart';
import 'package:sports_link/models/ponto.dart';

class CampoPriv extends Campo {
  int idArrendador;
  Arrendador arrendador;
  double preco;
  Map<String, List<TimeOfDay>> diasFuncionamento;

  CampoPriv({
    required this.idArrendador,
    required super.id,
    required super.idPonto,
    required super.idMapa,
    required super.nome,
    required super.comprimento,
    required super.largura,
    required super.ocupado,
    required super.descricao,
    required super.ponto,
    super.imagem, // Permite null, mas o valor padrão será tratado na classe base
    required this.preco,
    required this.diasFuncionamento,
  })  : arrendador = Arrendador.defaultInstance();

  factory CampoPriv.fromJson(Map<String, dynamic> json) {
    return CampoPriv(
      id: json['ID'] as int,
      idArrendador: json['ID_Arrendador'] as int,
      idPonto: json['ID_Ponto'] as int,
      idMapa: json['ID_Mapa'] as int,
      nome: json['Nome'] as String,
      comprimento: (json['Comprimento'] as num).toDouble(),
      largura: (json['Largura'] as num).toDouble(),
      ocupado: json['ocupado'] == 1,
      descricao: json['Descricao'] as String,
      ponto: json['Ponto'] != null
          ? Ponto.fromJson(json['Ponto'])
          : Ponto.defaultInstance(),
      imagem: json['Imagem'] != null && json['Imagem'].isNotEmpty
          ? json['Imagem'] as String
          : 'img/icon_campo.jpg', // Valor padrão para imagem
      preco: (json['Preco'] as num).toDouble(),
      diasFuncionamento: (json['DiasFuncionamento'] as Map<String, dynamic>).map(
        (key, value) => MapEntry(
          key,
          (value as List<dynamic>).map((e) {
            final dateTime = DateTime.parse(e as String);
            return TimeOfDay(hour: dateTime.hour, minute: dateTime.minute);
          }).toList(),
        ),
      ),
    );
  }

  @override
  Map<String, dynamic> toJson() {
    final base = super.toJson();
    base['ID_Arrendador'] = idArrendador;
    base['Preco'] = preco;
    base['DiasFuncionamento'] = diasFuncionamento.map(
      (key, value) => MapEntry(
        key,
        value.map((time) {
          final now = DateTime.now();
          final dateTime = DateTime(
            now.year,
            now.month,
            now.day,
            time.hour,
            time.minute,
          );
          return dateTime.toIso8601String();
        }).toList(),
      ),
    );
    return base;
  }

  @override
  String toString() {
    return 'CampoPriv(${super.toString()}, idArrendador: $idArrendador, preco: $preco, diasFuncionamento: $diasFuncionamento)';
  }
}
