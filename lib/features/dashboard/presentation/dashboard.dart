import 'package:flutter/material.dart';

import '../../certifications/presentation/certif.dart';
import '../../favorites/presentation/favorites.dart';

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Section Formations en cours
            const Text(
              'Formations en Cours',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            _buildOngoingCoursesSection(),

            const SizedBox(height: 20),

            // Section Recommandations
            const Text(
              'Recommandations Personnalisées',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            _buildRecommendationsSection(),

            const SizedBox(height: 20),

            // Section Statistiques
            const Text(
              'Statistiques',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            _buildStatisticsSection(),

            const SizedBox(height: 20),

            // Section Raccourcis (Favoris et Certifications)
            const Text(
              'Raccourcis',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            _buildShortcutsSection(context),
          ],
        ),
      ),
    );
  }

  // Section Formations en cours
  Widget _buildOngoingCoursesSection() {
    final List<Map<String, dynamic>> ongoingCourses = [
      {'title': 'Développement Flutter', 'progress': 0.6},
      {'title': 'Business pour startups', 'progress': 0.8},
    ];

    return Column(
      children: ongoingCourses.map((course) {
        return Card(
          child: ListTile(
            title: Text(course['title']),
            subtitle: LinearProgressIndicator(
              value: course['progress'],
              backgroundColor: Colors.grey[300],
              color: Colors.blue,
            ),
            trailing: Text('${(course['progress'] * 100).toStringAsFixed(0)}%'),
          ),
        );
      }).toList(),
    );
  }

  // Section Recommandations
  Widget _buildRecommendationsSection() {
    final List<Map<String, String>> recommendedCourses = [
      {
        'title': 'Introduction à Python',
        'description': 'Apprenez Python dès aujourd\'hui'
      },
      {
        'title': 'UX/UI Design',
        'description': 'Maîtrisez les concepts de design'
      },
    ];

    return Column(
      children: recommendedCourses.map((course) {
        return Card(
          child: ListTile(
            title: Text(course['title']!),
            subtitle: Text(course['description']!),
            trailing: const Icon(Icons.arrow_forward),
            onTap: () {
              // Action pour afficher plus d'informations sur le cours recommandé
            },
          ),
        );
      }).toList(),
    );
  }

  // Section Statistiques
  Widget _buildStatisticsSection() {
    final Map<String, dynamic> stats = {
      'Temps passé': '25h',
      'Formations complétées': 5,
    };

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: stats.entries.map((stat) {
        return Column(
          children: [
            Text(
              stat.value.toString(),
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 4),
            Text(stat.key),
          ],
        );
      }).toList(),
    );
  }

  // Section Raccourcis (Favoris et Certifications)
  Widget _buildShortcutsSection(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _buildShortcutCard(
          Icons.favorite,
          'Favoris',
              () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (
                    context) => const FavoritesPage(), // Remplacez par votre page Favoris
              ),
            );
          },
        ),
        _buildShortcutCard(
          Icons.verified,
          'Certifications',
              () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) =>
                    CertificationsPage(), // Remplacez par votre page Certifications
              ),
            );
          },
        ),
      ],
    );
  }

// Carte pour chaque raccourci
  Widget _buildShortcutCard(IconData icon, String label, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          CircleAvatar(
            radius: 30,
            backgroundColor: Colors.blue,
            child: Icon(icon, color: Colors.white),
          ),
          const SizedBox(height: 8),
          Text(label),
        ],
      ),
    );
  }
}