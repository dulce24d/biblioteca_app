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
  // índice seleccionado del BottomNavigationBar
  int idx = 0;
  // páginas correspondientes a cada pestaña (Catálogo, Historial, Perfil)
  final pages = const [CatalogScreen(), HistoryScreen(), ProfileScreen()];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // body muestra la página actual según idx
      body: pages[idx],
      // barra inferior que permite cambiar idx y por tanto la página mostrada
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
