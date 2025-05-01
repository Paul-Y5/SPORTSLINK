import 'package:flutter/material.dart';
import 'package:sports_link/models/utilizador.dart';

class UserProvider with ChangeNotifier {
  Utilizador? _user;

  Utilizador? get user => _user;

  void setUser(Utilizador user) {
    _user = user;
    notifyListeners();
  }

  void clearUser() {
    _user = null;
    notifyListeners();
  }

  bool isLoggedIn() {
    return _user != null;
  }

  String getUserName() {
    return _user?.nome ?? 'Visitante';
  }

  String getUserEmail() {
    return _user?.email ?? '';
  }

  String getUserPhone() {
    return _user?.numTele.toString() ?? '';
  }

  String getUserNationality() {
    return _user?.nacionalidade ?? '';
  }

  String getUserImage() {
    return _user?.urlIMG ?? 'img/iconDefault.png';
  }

  String getUserUtilizador() {
    return _user?.utilizador ?? '';
  }

  DateTime? getUserCreateDate() {
    return _user?.createDate;
  }

  DateTime? getUserLastLogin() {
    return _user?.lastLogin;
  }

  void setUserImage(String url) {
    if (_user != null) {
      _user!.urlIMG = url;
      notifyListeners();
    }
  }
  void setUserName(String name) {
    if (_user != null) {
      _user!.nome = name;
      notifyListeners();
    }
  }

  void setUserEmail(String email) {
    if (_user != null) {
      _user!.email = email;
      notifyListeners();
    }
  }

  void setUserPhone(String phone) {
    if (_user != null) {
      _user!.numTele = int.parse(phone);
      notifyListeners();
    }
  }
  
}
