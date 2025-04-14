import 'package:flutter/material.dart';

class MainPage1 extends StatefulWidget {
  const MainPage1({super.key});

  @override
  State<MainPage1> createState() => _MainPage1State();
}

class _MainPage1State extends State<MainPage1> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Main Page 1'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            Navigator.pushNamed(context, '/main_page_2');
          },
          child: const Text('Go to Main Page 2'),
        ),
      ),
    );
  }
}