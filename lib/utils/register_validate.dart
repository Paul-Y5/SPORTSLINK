import 'package:flutter/material.dart';

class RegisterValidate {
  void handleRegister(
    BuildContext context,
    TextEditingController nameController,
    TextEditingController emailController,
    TextEditingController passwordController,
    GlobalKey<FormState> formKey,
  ) {
    // Se o formulário for válido, continua
    if (formKey.currentState!.validate()) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Registo bem-sucedido!')),
      );
    }
  }
}