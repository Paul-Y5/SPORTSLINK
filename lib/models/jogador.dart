import 'package:flutter/material.dart';
import 'package:sports_link/models/avaliation.dart';
import 'package:sports_link/models/conquista.dart';
import 'package:sports_link/models/desportos.dart';
import 'package:sports_link/models/partida.dart';
import 'package:sports_link/models/utilizador.dart';

class Jogador extends Utilizador {
  // Atributos específicos do Jogador
  int idade;
  double altura = 0.0;
  double peso = 0.0;
  String descricao;

  List<Desportos> desportos = [];
  List<Utilizador> amigos = [];
  List<Utilizador> pedidosAmizade = [];
  List<Avaliation> avaliacoes = [];
  int numAvaliacoes = 0;
  double mediaAvaliacoes = 0.0;

  List<Partida> partidas = [];
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

  // Setters
Jogador setAltura(double altura) {
    this.altura = altura;
    return this;
  }

  Jogador setPeso(double peso) {
    this.peso = peso;
    return this;
  }

  Jogador setDescricao(String descricao) {
    this.descricao = descricao;
    return this;
  }

  Jogador setIdade(int idade) {
    this.idade = idade;
    return this;
  }

  Jogador setNacionalidade(String nacionalidade) {
    this.nacionalidade = nacionalidade;
    return this;
  }

  Jogador setUtilizador(String utilizador) {
    this.utilizador = utilizador;
    return this;
  }

  Jogador setCreateDate(DateTime createDate) {
    this.createDate = createDate;
    return this;
  }

  Jogador setNumTele(int numTele) {
    this.numTele = numTele;
    return this;
  }

  Jogador setEmail(String email) {
    this.email = email;
    return this;
  }

  Jogador setNome(String nome) {
    this.nome = nome;
    return this;
  }

  // Método para adicionar um amigo
  void adicionarAmigo(Utilizador amigo) {
    amigos.add(amigo);
  }

  // Método para remover um amigo
  void removerAmigo(Utilizador amigo) {
    amigos.remove(amigo);
  }

  // Método para adicionar uma partida
  void adicionarPartida(Partida partida) {
    partidas.add(partida);
  }

  // Método para remover uma partida
  void removerPartida(Partida partida) {
    partidas.remove(partida);
  }


  // Método para adicionar um desporto
  void adicionarDesporto(Desportos desporto) {
    if (!desportos.contains(desporto)) {
      desportos.add(desporto);
    } else {
      debugPrint('Desporto já adicionado!');
    }
  }

  // Método para remover um desporto
  void removerDesporto(Desportos desporto) {
    if (desportos.contains(desporto)) {
      desportos.remove(desporto);
    } else {
      debugPrint('Desporto não encontrado!');
    }
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

  // Método para adicionar um amigo
  void addFriend(Utilizador amigo) {
    amigos.add(amigo);
  }

  // Método para remover um amigo
  void removeFriend(Utilizador amigo) {
    amigos.remove(amigo);
  }

  // Método para adicionar um pedido de amizade
  void addFriendRequest(Utilizador amigo) {
    pedidosAmizade.add(amigo);
  }

  // Método para remover um pedido de amizade
  void removeFriendRequest(Utilizador amigo) {
    pedidosAmizade.remove(amigo);
  }

  // Método para adicionar uma avaliação
  void addAvaliation(Avaliation avaliacao) {
    avaliacoes.add(avaliacao);
    numAvaliacoes++;
    mediaAvaliacoes = (mediaAvaliacoes * (numAvaliacoes - 1) + avaliacao.rating) / numAvaliacoes;
  }

  // Método para remover uma avaliação
  void removeAvaliation(Avaliation avaliacao) {
    avaliacoes.remove(avaliacao);
    numAvaliacoes--;
    if (numAvaliacoes > 0) {
      mediaAvaliacoes = (mediaAvaliacoes * (numAvaliacoes + 1) - avaliacao.rating) / numAvaliacoes;
    } else {
      mediaAvaliacoes = 0.0;
    }
  }

}
