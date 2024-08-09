import 'package:flutter/material.dart';
import '../widgets/app_bar.dart';
import '../widgets/drawer_menu.dart';

class HomeScreen extends StatelessWidget {
  final String? userImage;

  const HomeScreen({super.key, this.userImage});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      appBar: CustomAppBar(),
      drawer: DrawerMenu(),
      body: Center(
        child: Text('Welcome to Guido Power Academia'),
      ),
    );
  }
}
