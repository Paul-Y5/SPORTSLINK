import 'package:flutter/material.dart';
import 'package:sports_link/models/arrendador.dart';
import 'package:sports_link/models/campo.dart';
import 'package:sports_link/models/ponto.dart';

class CampoPriv extends Campo {
  int idArrendador;
  Arrendador arrendador;
  double preco = 0.0;
  List<String> diasFuncionamento = [];

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
    required super.imagem,
    required this.preco,
    required this.diasFuncionamento,
  }) : arrendador = Arrendador.defaultInstance();

  factory CampoPriv.fromJson(Map<String, dynamic> json) {
    return CampoPriv(
      id: json['ID'] as int,
      imagem: Image.network(json['Imagem'] != null ? json['Imagem'] as String : 'https://example.com/default_image.png'),
      idArrendador: json['ID_Arrendador'] as int,
      idPonto: json['ID_Ponto'] as int,
      ponto: json['Ponto'] != null ? Ponto.fromJson(json['Ponto']) : Ponto.defaultInstance(),
      idMapa: json['ID_Mapa'] as int,
      nome: json['Nome'] as String,
      comprimento: (json['Comprimento'] as num).toDouble(),
      largura: (json['Largura'] as num).toDouble(),
      descricao: json['Descricao'] as String,
      preco: (json['Preco'] as num).toDouble(),
      diasFuncionamento: (json['DiasFuncionamento'] as List<dynamic>).map((e) => e as String).toList(),
      ocupado: json['ocupado'] == 1,
    );
  }

  @override
  Map<String, dynamic> toJson() {
    final base = super.toJson();
    base['ID_Arrendador'] = idArrendador;
    return base;
  }

  @override
  String toString() {
    return 'CampoPriv(${super.toString()}, idArrendador: $idArrendador)';
  }
}
