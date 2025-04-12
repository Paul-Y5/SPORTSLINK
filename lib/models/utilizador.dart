class Utilizador {
  final int id;
  final String nome;
  final String email;
  final int numTele;
  final String password;
  final String nacionalidade;

  Utilizador({
    required this.id,
    required this.nome,
    required this.email,
    required this.numTele,
    required this.password,
    required this.nacionalidade,
  });

  factory Utilizador.fromJson(Map<String, dynamic> json) {
    return Utilizador(
      id: json['id'] as int,
      nome: json['nome'] as String,
      email: json['email'] as String,
      numTele: json['numTele'] as int,
      password: json['password'] as String,
      nacionalidade: json['nacionalidade'] as String,
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
