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
      debugShowCheckedModeBanner: false, // Optional: removes the debug banner
      home: Scaffold(
        body: const HomePage(),
        backgroundColor: Colors.black,
        bottomNavigationBar: BottomAppBar(
          color: Colors.black,
          child: SizedBox(
            height: 25,
            child: const Center(
              child: Text(
                '© 2025 All rights reserved to PAULO&RAFAEL - IHC',
                style: TextStyle(color: Colors.orange, fontSize: 12),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
