import 'package:sports_link/models/jogador.dart';
import 'package:sports_link/models/utilizador.dart';

Map<String, dynamic> createUser({
  required int id,
  required String nome,
  required String email,
  required int numTele,
  required String password,
  required String nacionalidade,
  required String utilizador,
  DateTime? createDate,
  DateTime? lastLogin,
  required int idade,
  required double altura,
  required double peso,
}) {
  Utilizador user = Utilizador(
    id: id,
    nome: nome,
    email: email,
    numTele: numTele,
    password: password,
    nacionalidade: nacionalidade,
    utilizador: utilizador,
    createDate: createDate,
    lastLogin: lastLogin,
  );

  Jogador jogador = Jogador(
    id: id,
    nome: nome,
    email: email,
    numTele: numTele,
    password: password,
    nacionalidade: nacionalidade,
    utilizador: utilizador,
    createDate: createDate,
    idade: idade, 
    descricao: '',
  );

  return {'user': user, 'jogador': jogador};
}
