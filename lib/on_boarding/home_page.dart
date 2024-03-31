import 'package:flutter/material.dart';

class MyHomePage01 extends StatefulWidget {
  const MyHomePage01({super.key});

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage01> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  bool _isDrawerOpen = false;
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
      reverseDuration: const Duration(milliseconds: 500),
    );

    // _slideAnimation = Tween<Offset>(
    //   begin: const Offset(0.0, 0.0),
    //   end: const Offset(2.8, 0.0),
    // ).animate(CurvedAnimation(
    //   parent: _animationController,
    //   curve: Curves.easeInOut,
    // ));
  }

  @override
  void dispose() {
    if(mounted) {
      _animationController.dispose();
    }
    super.dispose();
  }

  void _toggleDrawer() {
    setState(() {
      _isDrawerOpen = !_isDrawerOpen;
      if (_isDrawerOpen) {
        _animationController.forward();
      } else {
        _animationController.reverse();
      }
    });
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Row(
            children: [
              AnimatedContainer(
                duration: const Duration(milliseconds: 3000),
                child: Drawer(
                  width: _isDrawerOpen ? 220 : 60,
                  child: ListView(
                  padding: EdgeInsets.zero,
                    children: <Widget>[
                      FloatingActionButton(
                        onPressed: _toggleDrawer,
                        child: Icon(_isDrawerOpen ? Icons.arrow_back : Icons.menu),
                      ),
                    if (_isDrawerOpen)
                      const DrawerHeader(
                        padding: EdgeInsets.zero,
                        decoration: BoxDecoration(
                          color: Color.fromARGB(255, 91, 50, 162),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          //crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            CircleAvatar(
                              radius: 30,
                              child: Icon(Icons.person),
                            ),
                            //SizedBox(height: 10),
                            Text(
                              'Nome do Usuário',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                              ),
                            ),
                          ],
                        ),
                      ),
                    if (_isDrawerOpen)
                      ListTile(
                        title: const Text('Página 1'),
                        onTap: () {
                          _onItemTapped(0);
                        },
                      ),
                    if (_isDrawerOpen)
                      ListTile(
                        title: const Text('Página 2'),
                        onTap: () {
                          _onItemTapped(1);
                        },
                      ),
                    if (_isDrawerOpen)
                      ListTile(
                        title: const Text('Página 3'),
                        onTap: () {
                          _onItemTapped(2);
                        },
                      ),
                    ],
                  ),
                ),
              ),
              Expanded(
                child: Container(
                  color: Colors.grey[200],
                  child: _buildPageContent(_selectedIndex),
                ),
              ),
            ],
          ),
          // Positioned(
          //   bottom: 16.0,
          //   child: SlideTransition(
          //     position: _slideAnimation,
          //     child: FloatingActionButton(
          //       onPressed: _toggleDrawer,
          //       child: Icon(_isDrawerOpen ? Icons.arrow_back : Icons.menu),
          //     ),
          //   ),
          // ),
        ],
      ),
    );
  }

  Widget _buildPageContent(int index) {
    switch (index) {
      case 0:
        return Container(
          color: Colors.red,
          child: const Center(
            child: Text(
              'Conteúdo da Página 1',
              style: TextStyle(fontSize: 24, color: Colors.white),
            ),
          ),
        );
      case 1:
        return Container(
          color: Colors.green,
          child: const Center(
            child: Text(
              'Conteúdo da Página 2',
              style: TextStyle(fontSize: 24, color: Colors.white),
            ),
          ),
        );
      case 2:
        return Container(
          color: Colors.blue,
          child: const Center(
            child: Text(
              'Conteúdo da Página 3',
              style: TextStyle(fontSize: 24, color: Colors.white),
            ),
          ),
        );
      default:
        return Container(); // Caso de fallback, não deveria ser alcançado.
    }
  }
}
