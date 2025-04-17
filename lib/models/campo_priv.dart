import 'package:sports_link/models/campo.dart';
import 'package:sports_link/models/ponto.dart';

class CampoPriv extends Campo {
  int idArrendador;

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
  });

  factory CampoPriv.fromJson(Map<String, dynamic> json) {
    return CampoPriv(
      id: json['ID'] as int,
      idPonto: json['ID_Ponto'] as int,
      idMapa: json['ID_Mapa'] as int,
      nome: json['Nome'] as String,
      comprimento: (json['Comprimento'] as num).toDouble(),
      largura: (json['Largura'] as num).toDouble(),
      ocupado: json['ocupado'] == 1,
      descricao: json['Descricao'] as String,
      idArrendador: json['ID_Arrendador'] as int,
      ponto: json['Ponto'] != null ? Ponto.fromJson(json['Ponto']) : Ponto.defaultInstance(),
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
