import 'package:flutter/material.dart';

import '../core/widgets/appbar.dart';
import '../features/audio_courses/audio_courses_home/presentation/home.dart';
import '../features/auth/presentation/login.dart';
import '../features/dashboard/presentation/dashboard.dart';
import '../features/profile/presentation/profile.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: LoginPage()
      // home: HomeScreen(),
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  HomeScreenState createState() => HomeScreenState();
}

class HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0; // Index de la page actuellement sélectionnée

  // Liste des widgets correspondant à chaque page
  final List<Widget> _pages = [
    const HomePage(),
    const DashboardPage(),
    const UserProfilePage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: const [CustomAppBarActions()],
      ),
      body: _pages[_currentIndex], // Affiche la page correspondant à l'index actuel
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex, // Met à jour l'index actuellement sélectionné
        onTap: (int index) {
          setState(() {
            _currentIndex = index; // Met à jour l'index et rafraîchit l'interface
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.dashboard),
            label: 'Dashboard',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profil',
          ),
        ],
      ),
    );
  }
}
