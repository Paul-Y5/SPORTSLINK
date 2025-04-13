import 'package:sports_link/models/utilizador.dart';

class Jogador extends Utilizador {
  // Atributos específicos do Jogador
  int idade;
  String descricao;

  Jogador({
    required super.id,
    required super.nome,
    required super.email,
    required super.numTele,
    required super.password,
    required super.nacionalidade,
    required this.idade,
    required this.descricao,
  });

  factory Jogador.fromJson(Map<String, dynamic> json) {
    return Jogador(
      id: json['id'] as int,
      nome: json['nome'] as String,
      email: json['email'] as String,
      numTele: json['numTele'] as int,
      password: json['password'] as String,
      nacionalidade: json['nacionalidade'] as String,
      idade: json['idade'] as int,
      descricao: json['descricao'] as String,
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nome': nome,
      'email': email,
      'numTele': numTele,
      'password': password,
      'nacionalidade': nacionalidade,
      'idade': idade,
      'descricao': descricao,
    };
  }

  @override
  String toString() {
    return 'Jogador{id: $id, nome: $nome, email: $email, numTele: $numTele, password: $password, nacionalidade: $nacionalidade, idade: $idade, descricao: $descricao}';
  }

}