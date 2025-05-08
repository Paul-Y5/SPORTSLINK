// ignore_for_file: public_member_api_docs, sort_constructors_first
class Utilizador {
  // Atributos
  final int id;
  String nome;
  String email;
  int numTele;
  String password;
  String nacionalidade;
  double nivel = 1.0;

  List<String> notificacoes = [];

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
    required this.nivel,
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
      createDate: json['createDate'] != null ? DateTime.parse(json['createDate']) : null, nivel: json['nivel'] as double,
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

}