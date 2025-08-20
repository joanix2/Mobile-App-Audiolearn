import 'package:flutter/material.dart';

import '../../../../core/widgets/appbar.dart';
import '../../widgets/card.dart';

class FormationListPage extends StatefulWidget {
  const FormationListPage({super.key});

  @override
  FormationListPageState createState() => FormationListPageState();
}

class FormationListPageState extends State<FormationListPage> {
  String _searchText = '';
  String _filterCategory = 'All';
  String _sortOption = 'Popularité';
  final List<String> _categories = ['All', 'Business', 'Tech', 'Design'];
  final List<String> _sortOptions = ['Popularité', 'Pertinence', 'Nouveautés'];

  final List<Map<String, String>> _formations = [
    {
      'title': 'Créer votre première application',
      'description': 'Apprenez les bases du développement mobile.',
      'rating': '4.5'
    },
    {
      'title': 'Business pour startups',
      'description': 'Stratégies pour un lancement réussi.',
      'rating': '4.7'
    },
    // Ajoutez plus de formations ici
  ];

  List<Map<String, String>> get _filteredFormations {
    return _formations.where((formation) {
      return formation['title']!.toLowerCase().contains(
          _searchText.toLowerCase());
    }).toList();
  }

  void _showFilterAndSortDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Filtrer et Trier'),
          content: Column(
            mainAxisSize: MainAxisSize.min, // Adjusts size based on content
            children: [
              // Dropdown for filtering categories
              DropdownButton<String>(
                value: _filterCategory,
                onChanged: (value) {
                  setState(() {
                    _filterCategory = value!;
                  });
                },
                items: _categories.map<DropdownMenuItem<String>>((String category) {
                  return DropdownMenuItem<String>(
                    value: category,
                    child: Text(category),
                  );
                }).toList(),
                hint: const Text('Sélectionner une catégorie'),
              ),
              const SizedBox(height: 20), // Space between dropdowns
              // Dropdown for sorting options
              DropdownButton<String>(
                value: _sortOption,
                onChanged: (value) {
                  setState(() {
                    _sortOption = value!;
                  });
                },
                items: _sortOptions.map<DropdownMenuItem<String>>((String option) {
                  return DropdownMenuItem<String>(
                    value: option,
                    child: Text(option),
                  );
                }).toList(),
                hint: const Text('Sélectionner une option de tri'),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: const Text('Annuler'),
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  // Apply the filter and sort options
                });
                Navigator.of(context).pop(); // Close the dialog
              },
              child: const Text('Appliquer'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Liste des Formations'),
        actions: const [CustomAppBarActions()]
      ),
      body: Column(
        children: [
          Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      decoration: const InputDecoration(
                        labelText: 'Rechercher',
                        prefixIcon: Icon(Icons.search),
                        border: OutlineInputBorder(),
                      ),
                      onChanged: (value) {
                        setState(() {
                          _searchText = value;
                        });
                      },
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.filter_list),
                    onPressed: _showFilterAndSortDialog,
                  ),
                ],
              )
          ),
          Expanded(
              child: FormationGrid(formations: _filteredFormations, isHorizontal: false,)
          )
        ],
      ),
    );
  }
}