import 'package:flutter/material.dart';

class FAQPage extends StatefulWidget {
  const FAQPage({super.key});

  @override
  FAQPageState createState() => FAQPageState();
}

class FAQPageState extends State<FAQPage> {
  String _searchText = '';
  final List<Map<String, String>> _faqList = [
    {
      'question': 'Comment s’abonner ?',
      'answer': 'Pour vous abonner, cliquez sur le bouton Abonnement dans les paramètres de votre profil.',
    },
    {
      'question': 'Comment réinitialiser mon mot de passe ?',
      'answer': 'Accédez à la page de connexion et cliquez sur "Mot de passe oublié".',
    },
    {
      'question': 'Puis-je changer de plan d’abonnement ?',
      'answer': 'Oui, vous pouvez changer de plan à tout moment depuis les paramètres du compte.',
    },
    {
      'question': 'Comment contacter le support ?',
      'answer': 'Vous pouvez nous contacter via chat en direct ou par email à support@exemple.com.',
    },
  ];

  List<Map<String, String>> get _filteredFAQ {
    if (_searchText.isEmpty) {
      return _faqList;
    } else {
      return _faqList.where((faq) {
        return faq['question']!.toLowerCase().contains(_searchText.toLowerCase());
      }).toList();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('FAQ - Assistance'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Barre de recherche
              TextField(
                decoration: const InputDecoration(
                  labelText: 'Rechercher une question',
                  prefixIcon: Icon(Icons.search),
                  border: OutlineInputBorder(),
                ),
                onChanged: (value) {
                  setState(() {
                    _searchText = value;
                  });
                },
              ),
              const SizedBox(height: 20),

              // Liste des questions fréquentes filtrées
              const Text(
                'Questions fréquentes',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              _buildFAQList(),

              const SizedBox(height: 20),

              // Section Support
              const Text(
                'Support',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              _buildSupportSection(),

              const SizedBox(height: 20),

              // Section Tutoriels vidéo
              const Text(
                'Tutoriels Vidéo & Guides d\'Utilisation',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              _buildTutorialSection(),

              const SizedBox(height: 20),

              // Section Communauté
              const Text(
                'Communauté',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              _buildCommunitySection(),
            ],
          ),
        ),
      ),
    );
  }

  // Construction de la liste FAQ
  Widget _buildFAQList() {
    return Column(
      children: _filteredFAQ.map((faq) {
        return ExpansionTile(
          title: Text(faq['question']!),
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Text(faq['answer']!),
            ),
          ],
        );
      }).toList(),
    );
  }

  // Section de support avec Chat et Email
  Widget _buildSupportSection() {
    return Column(
      children: [
        ListTile(
          leading: const Icon(Icons.chat),
          title: const Text('Chat en direct'),
          onTap: () {
            // Action pour ouvrir le chat en direct
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Chat en direct bientôt disponible !')),
            );
          },
        ),
        ListTile(
          leading: const Icon(Icons.email),
          title: const Text('Contacter par Email'),
          onTap: () {
            // Action pour envoyer un email
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Email : support@exemple.com')),
            );
          },
        ),
      ],
    );
  }

  // Section des tutoriels
  Widget _buildTutorialSection() {
    return Column(
      children: [
        ListTile(
          leading: const Icon(Icons.video_library),
          title: const Text('Tutoriels Vidéo'),
          onTap: () {
            // Action pour ouvrir les tutoriels vidéo
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Tutoriels vidéo bientôt disponibles !')),
            );
          },
        ),
        ListTile(
          leading: const Icon(Icons.book),
          title: const Text('Guides d\'utilisation'),
          onTap: () {
            // Action pour ouvrir les guides d'utilisation
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Guides d\'utilisation bientôt disponibles !')),
            );
          },
        ),
      ],
    );
  }

  // Section Communauté
  Widget _buildCommunitySection() {
    return ListTile(
      leading: const Icon(Icons.people),
      title: const Text('Rejoindre la Communauté'),
      onTap: () {
        // Action pour rejoindre la communauté
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Lien vers la communauté bientôt disponible !')),
        );
      },
    );
  }
}
