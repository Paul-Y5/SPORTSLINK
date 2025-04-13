import 'package:flutter/material.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import 'package:sports_link/styles/carouselbg.dart';
import 'package:sports_link/styles/styles_btn.dart';

// Página Inicial
class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(
          100,
        ), // Define uma altura menor para a AppBar
        // AppBar personalizada
        child: AppBar(
          backgroundColor: const Color.fromARGB(255, 0, 0, 0), // Deixa o AppBar transparente
          elevation: 0, // Remove a sombra do AppBar
          flexibleSpace: Padding(
            padding: const EdgeInsets.only(
              top: 50.0,
            ), // Ajusta o espaçamento para baixo
            child: Image.asset(
              'img/SPORTSLINK.png', // Caminho da imagem do logo
              fit: BoxFit.cover, // Faz a imagem ocupar toda a AppBar
            ),
          ),
        ),
      ),

      body: Stack(
        fit: StackFit.expand,
        children: [
          const Carouselbg(),
          Center(
            child: Padding(
              padding: const EdgeInsets.all(5.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const LoginPage(),
                        ),
                      );
                    },
                    style: customButtonStyle(context),
                    child: const Text('Login'),
                  ),
                  const SizedBox(height: 50),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const RegisterPage(),
                        ),
                      );
                    },
                    style: customButtonStyle(context),
                    child: const Text('Register'),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// Página de Login
class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    final TextEditingController emailController = TextEditingController();
    final TextEditingController passwordController = TextEditingController();

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(
          100,
        ), // Define uma altura menor para a AppBar
        // AppBar personalizada
        child: AppBar(
          backgroundColor: Colors.transparent, // Deixa o AppBar transparente
          elevation: 0, // Remove a sombra do AppBar
          flexibleSpace: Padding(
            padding: const EdgeInsets.only(
              top: 50.0,
            ), // Ajusta o espaçamento para baixo
            child: Image.asset(
              'img/SPORTSLINK.png', // Caminho da imagem do logo
              fit: BoxFit.cover, // Faz a imagem ocupar toda a AppBar
            ),
          ),
        ),
      ),

      body: Stack(
        fit: StackFit.expand,
        children: [
          const Carouselbg(),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(height: 80),
                  TextFormField(
                    controller: emailController,
                    decoration: inputDecoration(labelText: 'Email'),
                    keyboardType: TextInputType.emailAddress,
                    cursorColor: Colors.black,
                  ),
                  const SizedBox(height: 10),
                  TextFormField(
                    controller: passwordController,
                    obscureText: true,
                    decoration: inputDecoration(labelText: 'Password'),
                    cursorColor: Colors.black,
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      if (emailController.text.isEmpty ||
                          passwordController.text.isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text(
                              'Por favor, preencha todos os campos',
                            ),
                          ),
                        );
                      } else {
                        // Implementar lógica de login
                      }
                    },
                    style: customButtonStyleForms(context),
                    child: const Text('Login'),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const RegisterPage(),
                        ),
                      );
                    },
                    child: const Text(
                      'Não tens uma conta? Regista-te!',
                      style: TextStyle(color: Colors.black, fontSize: 16),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// Página de Registo
class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  String selectedCountryCode = 'PT'; // Valor inicial da nacionalidade

  final Map<String, String> countryCodes = {
    'Portugal': 'PT',
    'Espanha': 'ES',
    'França': 'FR',
    'Alemanha': 'DE',
  };

  // Função para atualizar o código do telefone com base na nacionalidade
  void updatePhoneNumberSelector(String country) {
    setState(() {
      selectedCountryCode = countryCodes[country] ?? 'PT';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(
          100,
        ), // Define uma altura menor para a AppBar
        // AppBar personalizada
        child: AppBar(
          backgroundColor: Colors.transparent, // Deixa o AppBar transparente
          elevation: 0, // Remove a sombra do AppBar
          flexibleSpace: Padding(
            padding: const EdgeInsets.only(
              top: 50.0,
            ), // Ajusta o espaçamento para baixo
            child: Image.asset(
              'img/SPORTSLINK.png', // Caminho da imagem do logo
              fit: BoxFit.cover, // Faz a imagem ocupar toda a AppBar
            ),
          ),
        ),
      ),

      body: Stack(
        fit: StackFit.expand,
        children: [
          const Carouselbg(),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(height: 80),
                  TextFormField(
                    controller: nameController,
                    decoration: inputDecoration(labelText: 'Nome'),
                    cursorColor: Colors.black,
                  ),
                  const SizedBox(height: 10),
                  TextFormField(
                    controller: emailController,
                    decoration: inputDecoration(labelText: 'Email'),
                    keyboardType: TextInputType.emailAddress,
                    cursorColor: Colors.black,
                  ),
                  const SizedBox(height: 10),
                  DropdownButtonFormField<String>(
                    decoration: inputDecoration(labelText: 'Nacionalidade'),
                    value: 'Portugal',
                    icon: const Icon(Icons.arrow_drop_down),
                    items:
                        countryCodes.keys.map((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                    onChanged: (String? newValue) {
                      updatePhoneNumberSelector(newValue!);
                    },
                  ),
                  const SizedBox(height: 10),
                  InternationalPhoneNumberInput(
                    onInputChanged: (PhoneNumber number) {
                      phoneController.text = number.phoneNumber ?? '';
                    },
                    initialValue: PhoneNumber(isoCode: selectedCountryCode),
                    selectorConfig: const SelectorConfig(
                      selectorType: PhoneInputSelectorType.DIALOG,
                    ),
                    inputDecoration: inputDecoration(
                      labelText: 'Número de Telemóvel',
                    ),
                    cursorColor: Colors.black,
                  ),
                  const SizedBox(height: 10),
                  TextFormField(
                    controller: passwordController,
                    obscureText: true,
                    decoration: inputDecoration(labelText: 'Password'),
                    cursorColor: Colors.black,
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      if (nameController.text.isEmpty ||
                          emailController.text.isEmpty ||
                          passwordController.text.isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text(
                              'Por favor, preencha todos os campos',
                            ),
                          ),
                        );
                      } else {
                        // Implementar lógica de registro
                      }
                    },
                    style: customButtonStyleForms(context),
                    child: const Text('Register'),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
