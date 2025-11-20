import 'package:flutter/material.dart';
import 'catalog.dart';
import 'history.dart';
import 'profile.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int idx = 0;
  final pages = const [CatalogScreen(), HistoryScreen(), ProfileScreen()];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: pages[idx],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: idx,
        onTap: (i) => setState(() => idx = i),
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.book), label: 'Catálogo'),
          BottomNavigationBarItem(
              icon: Icon(Icons.history), label: 'Historial'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Perfil'),
        ],
      ),
    );
  }
}
