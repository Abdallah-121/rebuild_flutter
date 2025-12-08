import 'dart:async';
import 'package:flutter/material.dart';

class HomeSliderSection extends StatefulWidget {
  const HomeSliderSection({super.key});

  @override
  State<HomeSliderSection> createState() => _HomeSliderSectionState();
}

class _HomeSliderSectionState extends State<HomeSliderSection> {
  final PageController _controller = PageController();
  int _currentIndex = 0;

  final List<String> _images = const [
    "assets/images/onboarding3.png",
    "assets/images/onboarding2.png",
    "assets/images/onboarding1.png",
  ];

  Timer? _timer;

  @override
  void initState() {
    super.initState();

    // ✅ تغيير تلقائي كل 4 ثواني
    _timer = Timer.periodic(const Duration(seconds: 4), (_) {
      if (_controller.hasClients) {
        _currentIndex = (_currentIndex + 1) % _images.length;
        _controller.animateToPage(
          _currentIndex,
          duration: const Duration(milliseconds: 450),
          curve: Curves.easeInOut,
        );
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 150,
      child: Stack(
        children: [
          PageView.builder(
            controller: _controller,
            itemCount: _images.length,
            onPageChanged: (index) {
              setState(() => _currentIndex = index);
            },
            itemBuilder: (_, index) {
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(18),
                  child: Image.asset(
                    _images[index],
                    fit: BoxFit.cover,
                    width: double.infinity,
                  ),
                ),
              );
            },
          ),

          // ✅ Indicators
          Positioned(
            bottom: 10,
            left: 0,
            right: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                _images.length,
                (index) => AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  margin: const EdgeInsets.symmetric(horizontal: 3),
                  width: _currentIndex == index ? 18 : 6,
                  height: 6,
                  decoration: BoxDecoration(
                    color: _currentIndex == index
                        ? Colors.white
                        : Colors.white.withOpacity(0.4),
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
