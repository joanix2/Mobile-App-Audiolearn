import 'package:flutter/material.dart';
import '../data/certification.dart';

class CertificationsPage extends StatelessWidget {
  CertificationsPage({super.key});

  // Liste d'exemple de certifications obtenues
  final List<Certification> certifications = [
    Certification(
      title: 'Certification Flutter Avancé',
      description: 'Certification obtenue après avoir terminé le cours audio "Maîtriser Flutter".',
      dateObtained: '2024-10-20',
      imageUrl: 'https://example.com/images/flutter_certification.png',
    ),
    Certification(
      title: 'Certification en Data Science',
      description: 'Certification obtenue après avoir suivi le cours audio "Introduction à la Data Science".',
      dateObtained: '2024-09-15',
      imageUrl: 'https://example.com/images/data_science_certification.png',
    ),
    // Ajoutez plus de certifications ici
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mes Certifications'),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(8.0),
        itemCount: certifications.length,
        itemBuilder: (context, index) {
          final certification = certifications[index];
          return _buildCertificationCard(certification);
        },
      ),
    );
  }

  // Méthode pour construire chaque carte de certifications
  Widget _buildCertificationCard(Certification certification) {
    return Card(
      elevation: 4,
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: ListTile(
        leading: ClipRRect(
          borderRadius: BorderRadius.circular(8.0),
          child: Image.network(
            certification.imageUrl,
            width: 60,
            height: 60,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) {
              return Container(
                width: 60,
                height: 60,
                color: Colors.grey[300],
                child: const Icon(Icons.image_not_supported, color: Colors.grey),
              );
            },
          ),
        ),
        title: Text(
          certification.title,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        subtitle: Text(certification.description),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.calendar_today, size: 16, color: Colors.grey),
            const SizedBox(height: 4.0),
            Text(
              certification.dateObtained,
              style: const TextStyle(fontSize: 12, color: Colors.grey),
            ),
          ],
        ),
        onTap: () {
          // Action lors du tap sur une certifications
          // Vous pouvez afficher les détails de la certifications ou l'ouvrir dans une nouvelle page
        },
      ),
    );
  }
}
