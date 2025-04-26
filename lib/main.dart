import 'package:flutter/material.dart';
import 'package:sports_link/screens/main_page_1.dart';
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
      initialRoute: '/main',  /* /home para app funcionar a partir da página de login */
      routes: {
        '/home': (context) => HomePage(),
        '/main': (context) => MainPage1(),
      },
      home: Scaffold(
        body: const HomePage(),
        backgroundColor: Colors.black,
      ),
    );
  }
}
