import 'package:flutter/material.dart';
import 'package:flutter_carousel_intro/flutter_carousel_intro.dart';
import 'package:flutter_carousel_intro/slider_item_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class IntroScreen extends StatefulWidget {
  const IntroScreen({super.key});

  @override
  _IntroScreenState createState() => _IntroScreenState();
}

class _IntroScreenState extends State<IntroScreen> {
  int _currentIndex = 0;
  final PageController _controller = PageController();

  final List<SliderItem> _slides = [
    SliderItem(
      title: 'Bem-vindo!',
      subtitle: const Text('Explore nossa academia e atinja seus objetivos.'),
      widget: Image.asset('assets/images/academia_esteira.png'),
    ),
    SliderItem(
      title: 'Treinamentos',
      subtitle: const Text('Acompanhe seus treinos e evolua com a gente.'),
      widget: Image.asset('assets/images/academia_pesos.png'),
    ),
    SliderItem(
      title: 'Conquistas',
      subtitle: const Text('Mantenha o foco e conquiste seus resultados!'),
      widget: Image.asset('assets/images/academia_agenda.png'),
    ),
  ];

  @override
  void initState() {
    super.initState();
    _controller.addListener(() {
      setState(() {
        _currentIndex = _controller.page?.round() ?? 0;
      });
    });
  }

  Future<void> _setIntroSeen() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('introSeen', true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: FlutterCarouselIntro(
              slides: _slides,
              controller: _controller,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(25.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                if (_currentIndex > 0)
                  IconButton(
                    icon: const Icon(Icons.arrow_back),
                    onPressed: () {
                      _controller.previousPage(
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.ease,
                      );
                    },
                  ),
                if (_currentIndex == _slides.length - 1)
                  Expanded(
                    child: Align(
                      alignment: Alignment.centerRight,
                      child: ElevatedButton(
                        onPressed: () {
                          _setIntroSeen();
                          Navigator.pushReplacementNamed(context, '/');
                        },
                        child: const Text('Concluir'),
                      ),
                    ),
                  )
                else
                  Expanded(
                    child: Align(
                      alignment: Alignment.centerRight,
                      child: IconButton(
                        icon: const Icon(Icons.arrow_forward),
                        onPressed: () {
                          _controller.nextPage(
                            duration: const Duration(milliseconds: 300),
                            curve: Curves.ease,
                          );
                        },
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
