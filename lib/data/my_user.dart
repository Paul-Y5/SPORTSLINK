import 'package:sports_link/data/mock_data.dart';
import 'package:sports_link/models/utilizador.dart';


Utilizador getMyUser(int id) {
  return mockUsers.values.firstWhere((user) => user.id == id);
}