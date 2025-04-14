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
      extendBody: true,
      extendBodyBehindAppBar: true,

      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(280),
        child: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          flexibleSpace: Padding(
            padding: const EdgeInsets.only(top: 200),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Image.asset(
                  'img/SPORTSLINK.png',
                  height: 40,
                  fit: BoxFit.contain,
                ),
                const SizedBox(height: 25),
                const Text(
                  'Never play alone',
                  style: TextStyle(
                    color: Color.fromARGB(200, 255, 255, 255),
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Roboto',
                    letterSpacing: 1.5,
                    decorationStyle: TextDecorationStyle.solid,
                    shadows: [
                      Shadow(
                        blurRadius: 1.0, // Desfoque do contorno
                        offset: Offset(2.0, 2.0), // Deslocamento do contorno
                        color: Color.fromARGB(200, 0, 0, 0), // Cor do contorno
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),

      body: Stack(
        fit: StackFit.expand,
        children: [
          const Carouselbg(), // Imagem do carrossel que cobre toda a tela
          Center(
            child: Padding(
              padding: const EdgeInsets.only(top: 100.0), // Ajuste para centralizar os botões
              child: Container( // Container para envolver a AppBar e botões
                alignment: Alignment.center,
                padding: const EdgeInsets.symmetric(horizontal: 20), // Ajuste para os botões ficarem mais centrados
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center, // Centraliza os botões verticalmente
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
                    const SizedBox(height: 40),
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
          ),
        ],
      ),

      bottomNavigationBar: Container(
        color: Colors.transparent,
        child: const BottomAppBar(
          elevation: 0,
          padding: EdgeInsets.only(top: 25), // Ajuste do padding
          color: Colors.transparent, // Fundo transparente para o rodapé
          child: SizedBox(
            child: Center(
              child: Text(
                '© 2025 All rights reserved to PAULO&RAFAEL - IHC',
                style: TextStyle(
                  color: Color.fromARGB(255, 255, 255, 255),
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Roboto',
                  letterSpacing: 1.5,
                  shadows: [
                    Shadow(
                      blurRadius: 2.0, // Desfoque do contorno
                      offset: Offset(2.0, 2.0), // Deslocamento do contorno
                      color: Colors.black, // Cor do contorno
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
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
      extendBody: true,
      extendBodyBehindAppBar: true,

      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(280),
        child: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          flexibleSpace: Padding(
            padding: const EdgeInsets.only(top: 100),
            child: GestureDetector(
              onTap: () {
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => const HomePage()),
                  (route) => false,
                );
              },
              child: Center(
                child: Image.asset(
                  'img/SPORTSLINK.png',
                  height: 40,
                  fit: BoxFit.contain,
                ),
              ),
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
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    const SizedBox(height: 100),
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
                          // TODO: lógica de login
                        }
                      },
                      style: customButtonStyleForms(context),
                      child: const Text('Login'),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const RegisterPage(),
                          ),
                        );
                      },
                      child: const Text(
                        'Não tens uma conta? Regista-te!',
                        style: TextStyle(
                          color: Colors.orange,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Roboto',
                          letterSpacing: 1.5,
                          shadows: [
                            Shadow(
                              blurRadius: 1.0,
                              offset: Offset(2.0, 2.0),
                              color: Color.fromARGB(200, 0, 0, 0),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),

      bottomNavigationBar: Container(
        color: Colors.transparent,
        child: const BottomAppBar(
          elevation: 0,
          padding: EdgeInsets.only(top: 25),
          color: Colors.transparent,
          child: SizedBox(
            child: Center(
              child: Text(
                '© 2025 All rights reserved to PAULO&RAFAEL - IHC',
                style: TextStyle(
                  color: Color.fromARGB(255, 255, 255, 255),
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Roboto',
                  letterSpacing: 1.5,
                  shadows: [
                    Shadow(
                      blurRadius: 2.0,
                      offset: Offset(2.0, 2.0),
                      color: Colors.black,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
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
  String selectedCountryCode = 'PT';

  final Map<String, String> countryCodes = {
    'Portugal': 'PT',
    'Espanha': 'ES',
    'França': 'FR',
    'Alemanha': 'DE',
  };

  void updatePhoneNumberSelector(String country) {
    setState(() {
      selectedCountryCode = countryCodes[country] ?? 'PT';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      extendBodyBehindAppBar: true,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(200),
        child: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          flexibleSpace: Padding(
            padding: const EdgeInsets.only(top: 50),
            child: GestureDetector(
              onTap: () {
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => const HomePage()),
                  (route) => false,
                );
              },
              child: Center(
                child: Image.asset(
                  'img/SPORTSLINK.png',
                  height: 40,
                  fit: BoxFit.contain,
                ),
              ),
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
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    const SizedBox(height: 100),
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
                          // Lógica de registro
                        }
                      },
                      style: customButtonStyleForms(context),
                      child: const Text('Register'),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: Container(
        color: Colors.transparent,
        child: const BottomAppBar(
          elevation: 0,
          padding: EdgeInsets.only(top: 25),
          color: Colors.transparent,
          child: SizedBox(
            child: Center(
              child: Text(
                '© 2025 All rights reserved to PAULO&RAFAEL - IHC',
                style: TextStyle(
                  color: Color.fromARGB(255, 255, 255, 255),
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Roboto',
                  letterSpacing: 1.5,
                  shadows: [
                    Shadow(
                      blurRadius: 2.0,
                      offset: Offset(2.0, 2.0),
                      color: Colors.black,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
