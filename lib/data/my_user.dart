import 'package:sports_link/data/mock_data.dart';
import 'package:sports_link/models/arrendador.dart';
import 'package:sports_link/models/utilizador.dart';


Utilizador getMyUser(int id) {
  if (mockUsers.isEmpty) {
    throw Exception('No users found in mock data.');
  }

  if (mockUsers[id] is Arrendador) {
    return mockUsers[id] as Arrendador;
  } else if (mockUsers[id] is Utilizador) {
    return mockUsers[id] as Utilizador;
  } else {
    throw Exception('User with ID $id is not defined.');
  }
}