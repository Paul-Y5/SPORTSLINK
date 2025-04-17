// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:sports_link/models/campo_priv.dart';
import 'package:sports_link/models/jogador.dart';
import 'package:sports_link/models/reserva.dart';

class Arrendador extends Jogador {
  // Atributos específicos do Arrendador
  int noCampos;
  int iban;

  List<CampoPriv> camposPrivados = [];
  List<Reserva> reservas = [];

  // Mapa de métodos de pagamento
  Map<String, dynamic> metodosPagamento;

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
    required super.descricao,
    required super.utilizador,
    required super.createDate,
  }) : metodosPagamento = {
         'metodo1': 'Cartão de Crédito',
         'metodo2': 'PayPal',
         'metodo3': 'Transferência Bancária',
       };

  // Adicionar novo método de pagamento
  void adicionarMetodoPagamento(String chave, String metodo) {
    metodosPagamento[chave] = metodo;
  }

  // Remover um método de pagamento
  void removerMetodoPagamento(String chave) {
    metodosPagamento.remove(chave);
  }

  // Obter um método de pagamento pelo nome (chave)
  List obterMetodoPagamento() {
    return metodosPagamento.values.toList();
  }

  // Convertendo para JSON
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

  static defaultInstance() {
    return Arrendador(
      id: 0,
      nome: 'default',
      email: 'default',
      numTele: 0,
      password: 'default',
      nacionalidade: 'default',
      idade: 0,
      descricao: 'default',
      noCampos: 0,
      iban: 0,
      utilizador: '',
      createDate: null,
    );
  }
}
