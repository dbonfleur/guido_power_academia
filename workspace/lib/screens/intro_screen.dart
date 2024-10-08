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
      if (mounted) {
        setState(() {
          _currentIndex = _controller.page?.round() ?? 0;
        });
      }
    });
  }

  Future<void> _setIntroSeen() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('introSeen', true);
  }

  void _navigate(BuildContext context, String routeName) {
    Navigator.pushReplacementNamed(context, routeName);
  }

  @override
  void dispose() {
    super.dispose();
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
              showIndicators: false,
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(
              _slides.length,
              (index) => GestureDetector(
                onTap: () {
                  if (mounted && _controller.positions.isNotEmpty) {
                    _controller.animateToPage(
                      index,
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.ease,
                    );
                  }
                },
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 5.0),
                  width: 14.0,
                  height: 14.0,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Theme.of(context).colorScheme.primary.withOpacity(
                      _currentIndex == index ? 0.9 : 0.4,
                    ),
                  ),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(25.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                if (_currentIndex == 0)
                  TextButton(
                    onPressed: () {
                      _setIntroSeen();
                      _navigate(context, '/');
                    },
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Theme.of(context).buttonTheme.colorScheme?.onPrimary, 
                      backgroundColor: Theme.of(context).buttonTheme.colorScheme?.primary, 
                    ),
                    child: const Text('Pular'),
                  ),
                if (_currentIndex > 0)
                  IconButton(
                    icon: const Icon(Icons.arrow_back),
                    onPressed: () {
                      if (mounted && _controller.positions.isNotEmpty) {
                        _controller.previousPage(
                          duration: const Duration(milliseconds: 300),
                          curve: Curves.ease,
                        );
                      }
                    },
                    color: Theme.of(context).buttonTheme.colorScheme?.primary,
                  ),
                if (_currentIndex == _slides.length - 1)
                  ElevatedButton(
                    onPressed: () {
                      _setIntroSeen();
                      _navigate(context, '/');
                    },
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Theme.of(context).colorScheme.onPrimary, 
                      backgroundColor: Theme.of(context).colorScheme.primary, 
                    ),
                    child: const Text('Concluir'),
                  )
                else
                  IconButton(
                    icon: const Icon(Icons.arrow_forward),
                    onPressed: () {
                      if (mounted && _controller.positions.isNotEmpty) {
                        _controller.nextPage(
                          duration: const Duration(milliseconds: 300),
                          curve: Curves.ease,
                        );
                      }
                    },
                    color: Theme.of(context).buttonTheme.colorScheme?.primary,
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
