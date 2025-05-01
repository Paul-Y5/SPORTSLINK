import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sports_link/screens/home_page.dart';
import 'package:sports_link/controllers/user_provider.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => UserProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: '/home',
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
