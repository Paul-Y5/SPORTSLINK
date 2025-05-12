import 'package:sports_link/models/campo.dart';
import 'package:sports_link/models/ponto.dart';

class CampoPub extends Campo {
  String entidadePublicaResp;
  bool partidaEmCurso;

  CampoPub({
    required this.entidadePublicaResp,
    this.partidaEmCurso = false,
    required super.id,
    required super.idPonto,
    required super.idMapa,
    required super.nome,
    required super.comprimento,
    required super.largura,
    required super.ocupado,
    required super.descricao,
    required super.ponto,
    super.imagem,
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
      imagem: json['Imagem'] as String?,
      entidadePublicaResp: json['Entidade_publica_resp'] as String,
      ponto: json['Ponto'] != null
          ? Ponto.fromJson(json['Ponto'])
          : Ponto.defaultInstance(),
      partidaEmCurso: json['Partida_em_curso'] == true,
    );
  }

  @override
  Map<String, dynamic> toJson() {
    final base = super.toJson();
    base['Entidade_publica_resp'] = entidadePublicaResp;
    base['Partida_em_curso'] = partidaEmCurso;
    return base;
  }

  @override
  String toString() {
    return 'CampoPub(${super.toString()}, entidadePublicaResp: $entidadePublicaResp, partidaEmCurso: $partidaEmCurso)';
  }
}
