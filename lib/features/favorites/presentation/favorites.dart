import 'package:flutter/material.dart';

import '../../../core/widgets/appbar.dart';
import '../../audio_courses/widgets/card.dart';


class FavoritesPage extends StatefulWidget {
  const FavoritesPage({super.key});

  @override
  FavoritesPageState createState() => FavoritesPageState();
}

class FavoritesPageState extends State<FavoritesPage> {
  // Exemple de liste de formations favorites
  final List<Map<String, String>> favoriteFormations = [
    {
      'title': 'Apprendre Flutter',
      'description': 'Un guide complet pour développer des applications Flutter.',
      'rating': '4.9',
    },
    {
      'title': 'Data Science en Python',
      'description': 'Analyse de données avec Python.',
      'rating': '4.7',
    },
    {
      'title': 'Masterclass en SEO',
      'description': 'Optimisez votre site web pour les moteurs de recherche.',
      'rating': '4.8',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mes Favoris'),
        actions: const [CustomAppBarActions()],
      ),
      body: favoriteFormations.isNotEmpty
          ? Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Formations Favorites',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Expanded(
              child: FormationGrid(
                formations: favoriteFormations,
                isHorizontal: false, // Scroller vertical
              ),
            ),
          ],
        ),
      )
          : const Center(
        child: Text(
          'Aucune formation ajoutée aux favoris',
          style: TextStyle(fontSize: 18, fontStyle: FontStyle.italic),
        ),
      ),
    );
  }
}
