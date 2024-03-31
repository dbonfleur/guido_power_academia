
import 'package:flutter/material.dart';
import 'package:flutter_carousel_intro/flutter_carousel_intro.dart';
import 'package:flutter_carousel_intro/slider_item_model.dart';
import 'package:flutter_carousel_intro/utils/enums.dart';
import 'on_boarding/home_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Guido Power Academia',
      theme: ThemeData(useMaterial3: true),
      debugShowCheckedModeBanner: false,
      home: const IntrodPage(),
    );
  }
}

class IntrodPage extends StatelessWidget {
  const IntrodPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: MySlideShow(),
      backgroundColor: Color.fromARGB(255, 255, 255, 255),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: MyHomePage01(),
    );
  }
}

class MySlideShow extends StatelessWidget {
  const MySlideShow({super.key});

  void _navigateToHomePage(BuildContext context) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const MyHomePage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: FlutterCarouselIntro(
        animatedRotateX: true,
        animatedRotateZ: true,
        scale: true,
        autoPlay: true,
        animatedOpacity: true,
        autoPlaySlideDuration: const Duration(seconds: 9),
        autoPlaySlideDurationTransition: const Duration(milliseconds: 1100),
        primaryColor: const Color.fromARGB(255, 59, 23, 95),
        secondaryColor: Colors.grey,
        scrollDirection: Axis.vertical,
        // indicatorAlign: IndicatorAlign.bottom,
        indicatorEffect: IndicatorEffects.worm,
        showIndicators: true,
        slides: [
          SliderItem(
            title: 'Bem-vindo à Guido Power Academia!',
            titleTextStyle: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 24,
              height: 2,
              color: Color.fromARGB(255, 65, 36, 114), // Sublinhar o texto
            ),
            subtitle: const Text(
              'Entre, treine e transforme-se conosco. Estamos aqui para ajudá-lo a alcançar seus objetivos de forma dedicada e motivadora.',
              style: TextStyle(
                fontSize: 16,
                color: Colors.black,
              ),
            ),
            widget: Image.asset("academia_pesos.png"),
          ),
          SliderItem(
            title: 'Serviços Oferecidos!',
            titleTextStyle: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 24,
              //height: -7,
              color: Color.fromARGB(255, 65, 36, 114), 
            ),
            subtitle: const Text(
              '1.Musculação\n2.Cardio\n3.Aulas em Grupo (Zumba, Pilates, Box)\n4.Personal Trainer',
              style: TextStyle(
                fontSize: 16,
                color: Colors.black,
              ),
            ),
            widget: Image.asset(
              "academia_esteira.png",
              alignment: Alignment.topCenter,
            ),
          ),
          SliderItem(
            title: 'Vamos começar!',
            titleTextStyle: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 24,
              //height: -7,
              color: Color.fromARGB(255, 65, 36, 114), 
            ),
            widget: Image.asset("academia_agenda.png"),
            subtitle: Column(
              children: [
                ElevatedButton(
                  onPressed: () {
                      _navigateToHomePage(context);
                  },
                  child: const Text("Pular"),
                ),
              ],
            )
          ),
        ],
      ),
    );
  }
}