import 'package:flutter/material.dart';

class RegisterValidate {
  // Função para realizar as validações do formulário
  void handleRegister(
    BuildContext context,
    TextEditingController nameController,
    TextEditingController emailController,
    TextEditingController passwordController,
    GlobalKey<FormState> formKey, // Chave global para o formulário
  ) {
    String name = nameController.text;
    String email = emailController.text;
    String password = passwordController.text;

    bool isValid = true;

    // Validação para o campo de nome
    if (name.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Por favor, insira o seu nome.')),
      );
      isValid = false;
    }

    // Validação para o campo de email
    if (email.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Por favor, insira o seu email.')),
      );
      isValid = false;
    }

    // Validação do formato do email
    if (!RegExp(
      r"^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$",
    ).hasMatch(email)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Por favor, insira um email válido.')),
      );
      isValid = false;
    }

    // Validação para o campo password
    if (password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Por favor, insira a sua senha.')),
      );
      isValid = false;
    }

    // Validação para a senha ter pelo menos 6 caracteres
    // e não conter espaços em branco e tem de ter pelo menos 1 númmero e 1 caracter especial
    if (password.length < 6 &&
        !password.contains(' ') &&
        !RegExp(r'[0-9]').hasMatch(password) &&
        !RegExp(r'[!@#$%^&*(),.?":{}|<>]').hasMatch(password)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Password deve ter pelo menos 6 caracteres e 1 número e 1 caracter especial.',
          ),
        ),
      );
      isValid = false;
    }

    // Se todas as validações passarem
    if (isValid) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Registo bem-sucedido!')));
      // lógica de registo, como enviar os dados para o servidor
    }
    // Se o formulário não for válido, pode usar a chave global para exibir erros
    if (!formKey.currentState!.validate()) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Por favor, preencha todos os campos corretamente.'),
        ),
      );
    } else {
      // Se o formulário for válido, pode continuar com a lógica de registo
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Registro bem-sucedido!')));
    }

    // lógica de registo, como enviar os dados para o servidor
  }
}
