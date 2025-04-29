import 'package:flutter/material.dart';
import 'screens/home_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: '/home',  /* /home para app funcionar a partir da página de login */
      routes: {
        '/home': (context) => HomePage(),
      },
      home: Scaffold(
        body: const HomePage(),
        backgroundColor: Colors.black,
      ),
    );
  }
}
