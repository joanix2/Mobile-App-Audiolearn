
import 'package:flutter/material.dart';

import '../../widgets/card.dart';
import '../../audio_courses_search/presentation/search.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  HomePageState createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  final List<Map<String, String>> ongoingFormations = [
    {
      'title': 'Créer votre première application',
      'description': 'Apprenez les bases du développement mobile.',
      'rating': '4.5',
    },
    {
      'title': 'Business pour startups',
      'description': 'Stratégies pour un lancement réussi.',
      'rating': '4.7',
    },
  ];

  final List<Map<String, String>> recommendedFormations = [
    {
      'title': 'Apprendre le design UX/UI',
      'description': 'Concevez des interfaces utilisateurs modernes.',
      'rating': '4.8',
    },
    {
      'title': 'Programmation en Python',
      'description': 'Maîtrisez les bases et avancées de Python.',
      'rating': '4.9',
    },
  ];

  // Liste des formations les plus populaires
  final List<Map<String, String>> popularFormations = [
    {
      'title': 'Masterclass en Intelligence Artificielle',
      'description': 'Découvrez les avancées de l\'IA et du machine learning.',
      'rating': '5.0',
    },
    {
      'title': 'Marketing Digital Avancé',
      'description': 'Maîtrisez les stratégies de marketing digital.',
      'rating': '4.9',
    },
    {
      'title': 'Blockchain et Cryptomonnaies',
      'description': 'Comprenez la technologie blockchain et son impact.',
      'rating': '4.8',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Section Formations en cours
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: Text(
                'Formations en cours',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
            SizedBox(
              height: 500,
              child: FormationGrid(formations: ongoingFormations, isHorizontal: true),
            ),

            // Section Formations recommandées
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: Text(
                'Formations recommandées',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
            SizedBox(
              height: 500,
              child: FormationGrid(formations: recommendedFormations, isHorizontal: true),
            ),

            // Nouvelle section : Formations les plus populaires
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: Text(
                'Formations les plus populaires',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
            SizedBox(
              height: 500,
              child: FormationGrid(formations: popularFormations, isHorizontal: true),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const FormationListPage(),
            ),
          );
        },
        child: const Icon(Icons.search),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
}
