import 'package:flutter/material.dart';

class CarouselBar extends StatefulWidget {
  final List<String> newsItems;

  const CarouselBar({super.key, required this.newsItems});

  @override
  State<CarouselBar> createState() => _CarouselBarState();
}

class _CarouselBarState extends State<CarouselBar> {
  late PageController _pageController;
  int currentIndex = 0;
  bool isAnimating = false;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: currentIndex);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _onPageChanged(int index) async {
    if (isAnimating) return; // Previne várias chamadas

    setState(() => isAnimating = true);

    // Delay antes de atualizar lógica
    await Future.delayed(const Duration(milliseconds: 300));

    // Se estiver no fim e deslizar para frente, volta ao início
    if (index >= widget.newsItems.length) {
      _pageController.jumpToPage(0);
      index = 0;
    }

    // Se estiver no início e deslizar para trás, vai ao fim
    if (index < 0) {
      _pageController.jumpToPage(widget.newsItems.length - 1);
      index = widget.newsItems.length - 1;
    }

    setState(() {
      currentIndex = index;
      isAnimating = false;
    });

  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 0.0, vertical: 0.0),
      child: Container(
        height: 50,
        width: double.infinity,
        decoration: BoxDecoration(color: const Color.fromARGB(128, 0, 0, 0)),
        child: Column(
          children: [
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                onPageChanged: _onPageChanged,
                itemBuilder: (context, index) {
                  final realIndex = index % widget.newsItems.length;
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4.0),
                      child: Center(
                        child: Text(
                          widget.newsItems[realIndex],
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                  );
                },
                itemCount: widget.newsItems.length + 1,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
