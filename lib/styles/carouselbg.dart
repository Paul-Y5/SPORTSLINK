import 'dart:ui';
import 'package:flutter/material.dart';

class Carouselbg extends StatefulWidget {
  const Carouselbg({super.key});

  @override
  _CarouselbgState createState() => _CarouselbgState();
}

class _CarouselbgState extends State<Carouselbg> {
  final List<String> imagePaths = const [
    'img/bg1.jpg',
    'img/bg2.jpg',
    'img/bg3.jpg',
    'img/bg4.jpg',
    'img/bg5.jpg',
  ];

  int _currentIndex = 0;

  void _startAutoPlay() {
    Future.delayed(const Duration(seconds: 5), () {
      setState(() {
        _currentIndex = (_currentIndex + 1) % imagePaths.length;
      });
      _startAutoPlay(); // continua o ciclo
    });
  }

  @override
  void initState() {
    super.initState();
    _startAutoPlay(); // Inicia o autoplay quando o widget for carregado
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        AnimatedSwitcher(
          duration: const Duration(seconds: 1),
          switchInCurve: Curves.easeIn,
          switchOutCurve: Curves.easeOut,
          child: Image.asset(
            imagePaths[_currentIndex],
            key: ValueKey<String>(imagePaths[_currentIndex]),
            fit: BoxFit.cover,
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
          ),
        ),
        // Filtro de desfoque
        Container(
          color: const Color.fromARGB(50, 0, 0, 0),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 1.5, sigmaY: 1.5),
            child: Container(color: Colors.transparent),
          ),
        ),
      ],
    );
  }
}
