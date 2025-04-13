// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:sports_link/models/jogador.dart';

class Arrendador extends Jogador {
  // Atributos específicos do Arrendador
  int noCampos;
  int iban;

  Arrendador({
    required this.noCampos,
    required this.iban,
    required super.id,
    required super.nome,
    required super.email,
    required super.numTele,
    required super.password,
    required super.nacionalidade,
    required super.idade,
    required super.descricao, required super.utilizador, required super.createDate,
  });

  factory Arrendador.fromJson(Map<String, dynamic> json) {
    return Arrendador(
      id: json['id'] as int,
      nome: json['nome'] as String,
      email: json['email'] as String,
      numTele: json['numTele'] as int,
      password: json['password'] as String,
      nacionalidade: json['nacionalidade'] as String,
      idade: json['idade'] as int,
      descricao: json['descricao'] as String,
      noCampos: json['noCampos'] as int,
      iban: json['iban'] as int, 
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
      'noCampos': noCampos,
      'iban': iban,
    };
  }

  @override
  String toString() {
    return 'Arrendador{id: $id, nome: $nome, email: $email, numTele: $numTele, password: $password, nacionalidade: $nacionalidade, idade: $idade, descricao: $descricao, noCampos: $noCampos, iban: $iban}';
  }

}
