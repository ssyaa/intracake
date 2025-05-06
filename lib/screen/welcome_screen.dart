import 'package:flutter/material.dart';
import 'package:intracake/screen/login_screen.dart'; // Pastikan path sesuai

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  final List<String> _titles = [
    'Selamat datang di Intracake',
    'Di Intracake, Anda bisa mencoba resep kue tradisional apapun',
    'Anda juga dapat membagikan resep rahasia Anda',
  ];

  void _goToLogin() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const LoginScreen()),
    );
  }

  Widget buildDots() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(_titles.length, (index) {
        return AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          margin: const EdgeInsets.symmetric(horizontal: 6),
          width: _currentPage == index ? 12 : 8,
          height: _currentPage == index ? 12 : 8,
          decoration: BoxDecoration(
            color: _currentPage == index ? Colors.pink : Colors.pink.shade100,
            shape: BoxShape.circle,
          ),
        );
      }),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          PageView.builder(
            controller: _pageController,
            onPageChanged: (index) {
              setState(() {
                _currentPage = index;
              });
            },
            itemCount: _titles.length,
            itemBuilder: (context, index) {
              return Container(
                padding: const EdgeInsets.all(32),
                alignment: Alignment.center,
                child: Text(
                  _titles[index],
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.pink,
                    fontFamily: 'Alata',
                  ),
                  textAlign: TextAlign.center,
                ),
              );
            },
          ),
          Positioned(
            bottom: 100,
            left: 0,
            right: 0,
            child: buildDots(),
          ),
          if (_currentPage == _titles.length - 1)
            Positioned(
              bottom: 32,
              right: 32,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.pink,
                ),
                onPressed: _goToLogin,
                child: const Text(
                    'Login',
                style: const TextStyle(
                    fontFamily: 'Alata'),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
