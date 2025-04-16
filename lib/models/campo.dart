import 'package:sports_link/models/ponto.dart';

class Campo {
  int id;
  int idPonto;
  int idMapa;
  String nome;
  double comprimento;
  double largura;
  bool ocupado;
  String descricao;

  Ponto? ponto;

  Campo({
    required this.id,
    required this.idPonto,
    required this.idMapa,
    required this.nome,
    required this.comprimento,
    required this.largura,
    required this.ocupado,
    required this.descricao,
    this.ponto,
  });

  factory Campo.fromJson(Map<String, dynamic> json) {
    return Campo(
      id: json['ID'] as int,
      idPonto: json['ID_Ponto'] as int,
      idMapa: json['ID_Mapa'] as int,
      nome: json['Nome'] as String,
      comprimento: (json['Comprimento'] as num).toDouble(),
      largura: (json['Largura'] as num).toDouble(),
      ocupado: json['ocupado'] == 1,
      descricao: json['Descricao'] as String,
      ponto: json['Ponto'] != null ? Ponto.fromJson(json['Ponto']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'ID': id,
      'ID_Ponto': idPonto,
      'ID_Mapa': idMapa,
      'Nome': nome,
      'Comprimento': comprimento,
      'Largura': largura,
      'ocupado': ocupado ? 1 : 0,
      'Descricao': descricao,
      'Ponto': ponto?.toJson(),
    };
  }

  @override
  String toString() {
    return 'Campo{id: $id, idPonto: $idPonto, idMapa: $idMapa, nome: $nome, comprimento: $comprimento, largura: $largura, ocupado: $ocupado, descricao: $descricao}';
  }
}

