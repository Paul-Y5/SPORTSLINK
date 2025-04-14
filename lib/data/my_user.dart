import 'package:sports_link/models/utilizador.dart';

Utilizador getMyUser() {
  int id = 1;
  return Utilizador(
    id: id, 
    nome: "Paulo", 
    email: "user@example.com", 
    numTele: 999999999, 
    password: "password123", 
    nacionalidade: "PT", 
    utilizador: "paulo${String.fromCharCode(id)}", 
    createDate: DateTime.now(),
    lastLogin: DateTime.now(),
    urlIMG: "img/iconDefault.png",
  );

}