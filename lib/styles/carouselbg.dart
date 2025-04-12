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

  late PageController _pageController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    _startAutoPlay();
  }

  void _startAutoPlay() {
    Future.delayed(const Duration(seconds: 5), () {
      if (_pageController.hasClients) {
        final nextPage = (_pageController.page?.toInt() ?? 0) + 1;
        if (nextPage >= imagePaths.length) {
          _pageController.jumpToPage(0); // Go back to the first image
        } else {
          _pageController.animateToPage(
            nextPage,
            duration: const Duration(seconds: 1),
            curve: Curves.easeInOut,
          );
        }
      }
      _startAutoPlay(); // Recurse to keep the auto-play going
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        // Carousel de imagens
        PageView.builder(
          controller: _pageController,
          itemCount: imagePaths.length,
          itemBuilder: (context, index) {
            return AnimatedSwitcher(
              duration: const Duration(seconds: 1),
              child: Image.asset(
                imagePaths[index],
                key: ValueKey<String>(imagePaths[index]),
                fit: BoxFit.cover, // Garantir que a imagem ocupe todo o espaço
              ),
            );
          },
        ),
        // Camada de filtro de desfoque (com opacidade ajustada)
        Container(
          color: const Color.fromARGB(50, 0, 0, 0),
          child: BackdropFilter(
            filter: ImageFilter.blur(
              sigmaX: 1.5,
              sigmaY: 1.5,
            ), // Ajuste do desfoque
            child: Container(color: Colors.transparent),
          ),
        ),
      ],
    );
  }
}
