import 'package:flutter/material.dart';
import 'package:sports_link/screens/main_page_1.dart';
import 'package:sports_link/styles/carouselbg.dart';
import 'package:sports_link/styles/styles_btn.dart';
import 'package:sports_link/utils/register_validate.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';

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
            padding: const EdgeInsets.only(top: 180),
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


class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  LoginPageState createState() => LoginPageState();
}

class LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>(); // Chave do formulário
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  void validateAndLogin() {
    if (_formKey.currentState!.validate()) {
      final email = emailController.text.trim();
      final password = passwordController.text;

      // Simular credenciais válidas (substitir por lógica real de autenticação)
      const validEmail = 'user@example.com';
      const validPassword = 'password123';

      if (email == validEmail && password == validPassword) {
        // Messagem de sucesso e esperar 2 segundos (depois será o tempo de autenticação real)
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('A autenticação está a ser processada...'),
            backgroundColor: Colors.blue,
          ),
        );
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Login bem-sucedido!'),
            backgroundColor: Colors.green,
          ),
        );
        Future.delayed(const Duration(seconds: 2), () {
          if (!mounted) return;
          // adicionar a lógica de navegação para a página principal
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const MainPage1()),
          );
        });
      } else {
        // Credenciais inválidas
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Email ou password inválidos'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        automaticallyImplyLeading: false,
        flexibleSpace: GestureDetector(
          onTap: () => Navigator.pop(context),
          child: Center(
            child: Padding(
              padding: const EdgeInsets.only(top: 50),
              child: Image.asset('img/SPORTSLINK.png', fit: BoxFit.contain),
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
                child: Form(
                  key: _formKey, // Adiciona o formulário
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  child: Column(
                    children: [
                      const SizedBox(height: 100),

                      // Campo de Email
                      TextFormField(
                        controller: emailController,
                        decoration: inputDecoration(labelText: 'Email'),
                        keyboardType: TextInputType.emailAddress,
                        cursorColor: Colors.white,
                        style: const TextStyle(color: Colors.white),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Por favor, insira o seu email';
                          }
                          if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
                            return 'Email inválido';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 10),

                      // Campo de Senha
                      TextFormField(
                        controller: passwordController,
                        obscureText: true,
                        decoration: inputDecoration(labelText: 'Password'),
                        cursorColor: Colors.white,
                        style: const TextStyle(color: Colors.white),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Por favor, insira a sua password';
                          }
                          if (value.length < 6) {
                            return 'A password deve ter pelo menos 6 caracteres';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 20),

                      // Botão de Login
                      ElevatedButton(
                        onPressed: validateAndLogin, // Chama a função de validação
                        style: customButtonStyleForms(context),
                        child: const Text('Login'),
                      ),

                      // Botão para Registro
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



class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  RegisterPageState createState() => RegisterPageState();
}

class RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();
  final RegisterValidate validator = RegisterValidate();

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
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        automaticallyImplyLeading: false,
        flexibleSpace: GestureDetector(
          onTap: () {
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => const HomePage()),
              (route) => false,
            );
          },
          child: Center(
            child: Padding(
              padding: const EdgeInsets.only(top: 50),
              child: Image.asset('img/SPORTSLINK.png', fit: BoxFit.contain),
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
                child: Form(
                  key: _formKey,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  child: Column(
                    children: [
                      const SizedBox(height: 120),

                      // Nome
                      TextFormField(
                        controller: nameController,
                        decoration: inputDecoration(labelText: 'Nome'),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Por favor, insira o seu nome';
                          }
                          return null;
                        },
                        cursorColor: Colors.white,
                        style: const TextStyle(color: Colors.white),
                      ),
                      const SizedBox(height: 10),

                      // Email
                      TextFormField(
                        controller: emailController,
                        decoration: inputDecoration(labelText: 'Email'),
                        keyboardType: TextInputType.emailAddress,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Por favor, insira o seu email';
                          }
                          if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
                            return 'Email inválido';
                          }
                          return null;
                        },
                        cursorColor: Colors.white,
                        style: const TextStyle(color: Colors.white),
                      ),
                      const SizedBox(height: 10),

                      // Nacionalidade
                      DropdownButtonFormField<String>(
                        decoration: inputDecoration(labelText: 'Nacionalidade'),
                        value: 'Portugal',
                        icon: const Icon(Icons.arrow_drop_down, color: Colors.white),
                        items: countryCodes.keys.map((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                        onChanged: (String? newValue) {
                          updatePhoneNumberSelector(newValue!);
                          phoneController.clear(); 
                        },
                        dropdownColor: const Color.fromARGB(150, 6, 6, 6),
                        style: const TextStyle(color: Colors.white, fontSize: 16),
                      ),
                      const SizedBox(height: 10),

                      // Telemóvel
                      InternationalPhoneNumberInput(
                        onInputChanged: (PhoneNumber number) {
                          phoneController.text = number.phoneNumber ?? '';
                        },
                        initialValue: PhoneNumber(isoCode: selectedCountryCode),
                        selectorConfig: const SelectorConfig(
                          selectorType: PhoneInputSelectorType.DIALOG,
                        ),
                        selectorTextStyle: const TextStyle(color: Colors.white),
                        inputDecoration: inputDecoration(
                          labelText: 'Número de Telemóvel',
                        ),
                        cursorColor: Colors.white,
                        textStyle: const TextStyle(
                          color: Colors.white,
                        ), // <- torna o texto branco
                      ),
                      const SizedBox(height: 10),

                      // Password
                      TextFormField(
                        controller: passwordController,
                        obscureText: true,
                        decoration: inputDecoration(labelText: 'Password'),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Por favor, insira uma password';
                          }
                          return null;
                        },
                        cursorColor: Colors.white,
                        style: const TextStyle(color: Colors.white),
                      ),
                      const SizedBox(height: 20),

                      // Botão de Registo
                      ElevatedButton(
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            validator.handleRegister(
                              context,
                              nameController,
                              emailController,
                              passwordController,
                              _formKey,
                            );
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
                  color: Colors.white,
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
