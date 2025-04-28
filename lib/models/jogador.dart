import 'package:flutter/material.dart';
import 'package:sports_link/models/conquista.dart';
import 'package:sports_link/models/utilizador.dart';

class Jogador extends Utilizador {
  // Atributos específicos do Jogador
  int idade;
  double altura = 0.0;
  double peso = 0.0;
  String descricao;
  final List<Conquista> conquistas = [];

  Jogador({
    required super.id,
    required super.nome,
    required super.email,
    required super.numTele,
    required super.password,
    required super.nacionalidade,
    required this.idade,
    required this.descricao, required super.utilizador, required super.createDate,
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
      utilizador: '', 
      createDate: null,
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

  // Método para adicionar uma conquista
  void adicionarConquista(Conquista conquista) {
    conquistas.add(conquista);
  }

  void desbloquearConquista(String nomeConquista) {
    for (var conquista in conquistas) {
      if (conquista.nome == nomeConquista) {
        conquista.desbloquear();
      }
    }
  }

  void mostrarConquistas() {
    for (var conquista in conquistas) {
      String status = conquista.desbloqueada ? "Desbloqueada" : "Bloqueada";
      debugPrint('- ${conquista.nome} ($status)');
    }
  }

  void listarallConquistas() {
    for (var conquista in conquistas) {
      String status = conquista.desbloqueada ? "Desbloqueada" : "Bloqueada";
      debugPrint('- ${conquista.nome} ($status)');
    }
  }
}
