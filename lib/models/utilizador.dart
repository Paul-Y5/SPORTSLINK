// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:sports_link/models/avaliation.dart';
import 'package:sports_link/models/desportos.dart';
import 'package:sports_link/models/partida.dart';

class Utilizador {
  // Atributos
  final int id;
  String nome;
  String email;
  int numTele;
  String password;
  String nacionalidade;

  List<Desportos> desportos = [];
  List<Utilizador> amigos = [];
  List<Utilizador> pedidosAmizade = [];
  List<Avaliation> avaliacoes = [];
  int numAvaliacoes = 0;
  double mediaAvaliacoes = 0.0;

  List<Partida> partidas = [];
  
  // URL da imagem de perfil
  // Se não houver imagem vai ser definido uma imagem padrão
  String? urlIMG = 'img/iconDefault.png';

  // About Utilizador
  String utilizador;
  DateTime? createDate;
  DateTime? lastLogin;

  Utilizador({
    required this.id,
    required this.nome,
    required this.email,
    required this.numTele,
    required this.password,
    required this.nacionalidade,
    this.urlIMG,
    required this.utilizador,
    required this.createDate,
    this.lastLogin,
  });

  factory Utilizador.fromJson(Map<String, dynamic> json) {
    return Utilizador(
      id: json['id'] as int,
      nome: json['nome'] as String,
      email: json['email'] as String,
      numTele: json['numTele'] as int,
      password: json['password'] as String,
      nacionalidade: json['nacionalidade'] as String, 
      utilizador: '', 
      createDate: json['createDate'] != null ? DateTime.parse(json['createDate']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nome': nome,
      'email': email,
      'numTele': numTele,
      'password': password,
      'nacionalidade': nacionalidade,
    };
  }

  @override
  String toString() {
    return 'Utilizador{id: $id, nome: $nome, email: $email, numTele: $numTele, password: $password, nacionalidade: $nacionalidade}';
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
