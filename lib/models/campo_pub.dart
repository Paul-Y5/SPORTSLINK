import 'package:sports_link/models/campo.dart';
import 'package:sports_link/models/ponto.dart';

class CampoPub extends Campo {
  String entidadePublicaResp;

  CampoPub({
    required this.entidadePublicaResp,
    required super.id,
    required super.idPonto,
    required super.idMapa,
    required super.nome,
    required super.comprimento,
    required super.largura,
    required super.ocupado,
    required super.descricao,
    super.ponto,
  });

  factory CampoPub.fromJson(Map<String, dynamic> json) {
    return CampoPub(
      id: json['ID'] as int,
      idPonto: json['ID_Ponto'] as int,
      idMapa: json['ID_Mapa'] as int,
      nome: json['Nome'] as String,
      comprimento: (json['Comprimento'] as num).toDouble(),
      largura: (json['Largura'] as num).toDouble(),
      ocupado: json['ocupado'] == 1,
      descricao: json['Descricao'] as String,
      entidadePublicaResp: json['Entidade_publica_resp'] as String,
      ponto: json['Ponto'] != null ? Ponto.fromJson(json['Ponto']) : null,
    );
  }

  @override
  Map<String, dynamic> toJson() {
    final base = super.toJson();
    base['Entidade_publica_resp'] = entidadePublicaResp;
    return base;
  }

  @override
  String toString() {
    return 'CampoPub(${super.toString()}, entidadePublicaResp: $entidadePublicaResp)';
  }
}
