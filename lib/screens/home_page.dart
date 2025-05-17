import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sports_link/data/mock_data.dart';
import 'package:sports_link/controllers/user_provider.dart';
import 'package:sports_link/models/jogador.dart';
import 'package:sports_link/screens/main_page_1.dart';
import 'package:sports_link/styles/carouselbg.dart';
import 'package:sports_link/styles/styles_btn.dart';
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
          automaticallyImplyLeading: false,
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
                        blurRadius: 1.0,
                        offset: Offset(2.0, 2.0),
                        color: Color.fromARGB(200, 0, 0, 0),
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

      StringBuffer userIdBuffer = StringBuffer();
      final result = verificarLogin(email, password, userId: userIdBuffer);
      if (result == LoginResult.success) {
        final user = mockUsers[int.parse(userIdBuffer.toString())]!;
        Provider.of<UserProvider>(context, listen: false).setUser(user);
        
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('A autenticação está a ser processada...'),
            backgroundColor: Colors.blue,
            duration: Duration(seconds: 2),
          ),
        );

        (user as Jogador).isOnline = true;
        user.lastLogin = DateTime.now();

        Future.delayed(const Duration(seconds: 2), () {
          if (!mounted) return;

          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Login bem-sucedido!'),
              duration: Duration(seconds: 2),
              backgroundColor: Colors.green,
            ),
          );

          Future.delayed(const Duration(seconds: 1), () {
            if (!mounted) return;
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => MainPage1(id: int.parse(userIdBuffer.toString())),
              ),
            );
          });
        });
      } else {
        String errorMessage =
            result == LoginResult.wrongPassword || result == LoginResult.userNotFound
                ? 'palavra-passe incorreta. Tente novamente.'
                : 'Email não encontrado. Verifique novamente.';

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(errorMessage),
            backgroundColor: Colors.red,
            duration: Duration(seconds: 2),
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

                      // Campo de palavra-passe
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
  final TextEditingController anoNascimentoController = TextEditingController();

  String selectedCountry = 'Portugal';
  String selectedCountryCode = 'PT';
  PhoneNumber phoneNumber = PhoneNumber(isoCode: 'PT');
  String parsedPhone = '';
  DateTime? dataNascimento;

  final Map<String, String> countryCodes = {
    'Portugal': 'PT',
    'Espanha': 'ES',
    'França': 'FR',
    'Alemanha': 'DE',
  };

  void updatePhoneNumberSelector(String country) {
    setState(() {
      selectedCountry = country;
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
                        value: selectedCountry,
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

                      // Telemóvel com intl_phone_number_input
                      InternationalPhoneNumberInput(
                        onInputChanged: (PhoneNumber number) {
                          parsedPhone = number.phoneNumber ?? '';
                        },
                        initialValue: phoneNumber,
                        selectorConfig: const SelectorConfig(
                          selectorType: PhoneInputSelectorType.DROPDOWN,
                        ),
                        selectorTextStyle: const TextStyle(color: Colors.white),
                        inputDecoration: inputDecoration(labelText: 'Número de Telemóvel'),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Por favor, insira o seu número de telemóvel';
                          }
                          // Validação simples: pelo menos 9 dígitos
                          final digits = value.replaceAll(RegExp(r'\D'), '');
                          if (digits.length < 9) {
                            return 'Número de telemóvel inválido';
                          }
                          return null;
                        },
                        textStyle: const TextStyle(color: Colors.white),
                        keyboardType: TextInputType.phone,
                        autoValidateMode: AutovalidateMode.onUserInteraction,
                      ),
                      const SizedBox(height: 10),

                      // Ano de Nascimento
                      TextFormField(
                        controller: anoNascimentoController,
                        decoration: inputDecoration(labelText: 'Ano de Nascimento'),
                        keyboardType: TextInputType.number,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Por favor, insira o ano de nascimento';
                          }
                          final ano = int.tryParse(value);
                          final anoAtual = DateTime.now().year;
                          if (ano == null || ano < 1900 || ano > anoAtual) {
                            return 'Ano inválido';
                          }
                          return null;
                        },
                        cursorColor: Colors.white,
                        style: const TextStyle(color: Colors.white),
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
                          if (value.length < 6) {
                            return 'A password deve ter pelo menos 6 caracteres';
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
                              phoneController,
                              anoNascimentoController, // passa o controller do ano
                              selectedCountry,
                              _formKey,
                              parsedPhone: parsedPhone,
                            );
                          }
                        },
                        style: customButtonStyleForms(context),
                        child: const Text('Register'),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const LoginPage(),
                            ),
                          );
                        },
                        child: const Text(
                          'Tens uma conta? Entra!',
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

class RegisterValidate {
  void handleRegister(
    BuildContext context,
    TextEditingController nameController,
    TextEditingController emailController,
    TextEditingController passwordController,
    TextEditingController phoneController,
    TextEditingController anoNascimentoController, // agora recebe o controller do ano
    String selectedNationality,
    GlobalKey<FormState> formKey,
    {String? parsedPhone}
  ) {
    final name = nameController.text.trim();
    final email = emailController.text.trim();
    final password = passwordController.text;
    final phone = (parsedPhone ?? phoneController.text.trim());
    final nacionalidade = selectedNationality;
    final anoNascimento = int.tryParse(anoNascimentoController.text.trim());

    // Validação extra para garantir que o número é válido
    final digits = phone.replaceAll(RegExp(r'\D'), '');
    if (digits.length < 9) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Número de telemóvel inválido!'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    if (anoNascimento == null || anoNascimento < 1900 || anoNascimento > DateTime.now().year) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Por favor, insira um ano de nascimento válido!'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    final newId = mockUsers.keys.isEmpty ? 1 : (mockUsers.keys.reduce((a, b) => a > b ? a : b) + 1);

    final novoJogador = Jogador(
      id: newId,
      nome: name,
      email: email,
      numTele: int.tryParse(digits) ?? 0,
      password: password,
      nacionalidade: nacionalidade,
      idade: DateTime.now().year - anoNascimento,
      isInPartida: false,
      isOnline: false,
      descricao: '',
      utilizador: name,
      createDate: DateTime.now(),
      nivel: 1,
    );

    mockUsers[newId] = novoJogador;

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Registo efetuado com sucesso!'),
        backgroundColor: Colors.green,
      ),
    );

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const LoginPage()),
    );
  }
}
