import 'package:flutter/material.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import 'styles.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'SportsLink',
      theme: ThemeData(
        primarySwatch: Colors.orange,
        visualDensity: VisualDensity.adaptivePlatformDensity,
        scaffoldBackgroundColor: Colors.white,
        appBarTheme: const AppBarTheme(
          backgroundColor: Color.fromARGB(255, 0, 0, 0),
          titleTextStyle: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      home: const HomePage(),
    );
  }
}

// Página Inicial
class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('SportsLink'), centerTitle: true),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(5.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const LoginPage()),
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
      appBar: AppBar(title: const Text('Login'), centerTitle: true),
      body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextFormField(
                controller: emailController,
                decoration: inputDecoration(labelText: 'Email'),
                keyboardType: TextInputType.emailAddress,
                cursorColor: Colors.black, // Set the cursor color here
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: passwordController,
                obscureText: true,
                decoration: inputDecoration(labelText: 'Password'),
                cursorColor: Colors.black, // Set the cursor color here
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  if (emailController.text.isEmpty ||
                      passwordController.text.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Por favor, preencha todos os campos'),
                      ),
                    );
                  } else {
                    // Implementar lógica de login
                  }
                },
                style: customButtonStyleForms(context), // Estilo atualizado
                child: const Text('Login'),
              ),
              TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const RegisterPage()),
                  );
                },
                child: const Text('Não tens uma conta? Regista-te!', 
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 16,
                    )),
              ),
            ],
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
      appBar: AppBar(title: const Text('Registo'), centerTitle: true),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextFormField(
              controller: nameController,
              decoration: inputDecoration(labelText: 'Nome'),
              cursorColor: Colors.black, // Set the cursor color here
            ),
            const SizedBox(height: 10),
            TextFormField(
              controller: emailController,
              decoration: inputDecoration(labelText: 'Email'),
              cursorColor: Colors.black, // Set the cursor color here
              keyboardType: TextInputType.emailAddress,
            ),
            const SizedBox(height: 10),
            DropdownButtonFormField<String>(
              decoration: inputDecoration(labelText: 'Nacionalidade'),
              value: 'Portugal',
              icon: const Icon(Icons.arrow_drop_down),
              iconSize: 24,
              items:
                  countryCodes.keys.map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
              onChanged: (String? newValue) {
                updatePhoneNumberSelector(newValue!); // Atualizar o código de telefone
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
              inputDecoration: inputDecoration(labelText: 'Número de Telemóvel'),
              cursorColor: Colors.black, // Set the cursor color here
            ),
            const SizedBox(height: 10),
            TextFormField(
              controller: passwordController,
              obscureText: true,
              decoration: inputDecoration(labelText: 'Password'),
              cursorColor: Colors.black, // Set the cursor color here
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                if (nameController.text.isEmpty ||
                    emailController.text.isEmpty ||
                    passwordController.text.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Por favor, preencha todos os campos'),
                    ),
                  );
                } else {
                  // Implementar lógica de registro
                }
              },
              style: customButtonStyleForms(context), // Estilo atualizado
              child: const Text('Register'),
            ),
          ],
        ),
      ),
    );
  }
}
