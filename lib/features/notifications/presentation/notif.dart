import 'package:flutter/material.dart';

class NotificationPage extends StatefulWidget {
  const NotificationPage({super.key});

  @override
  NotificationPageState createState() => NotificationPageState();
}

class NotificationPageState extends State<NotificationPage> {
  // Données de notifications
  final List<Map<String, dynamic>> _notifications = [
    {
      'title': 'Nouvelle formation disponible',
      'description':
      'Une nouvelle formation "Développement Flutter avancé" est maintenant disponible.',
      'isRead': false,
      'type': 'contenu',
      'date': '2024-10-18'
    },
    {
      'title': 'Mise à jour du contenu',
      'description':
      'La formation "Business pour startups" a été mise à jour avec de nouveaux modules.',
      'isRead': false,
      'type': 'contenu',
      'date': '2024-10-17'
    },
    {
      'title': 'Rappel: Abonnement à renouveler',
      'description':
      'Votre abonnement expire dans 3 jours. Renouvelez-le pour continuer l\'accès à vos formations.',
      'isRead': true,
      'type': 'abonnement',
      'date': '2024-10-15'
    },
    {
      'title': 'Rappel: Formation incomplète',
      'description':
      'Vous n\'avez pas terminé la formation "Créer votre première application". Reprenez où vous vous êtes arrêté.',
      'isRead': false,
      'type': 'rappel',
      'date': '2024-10-14'
    },
  ];

  String _filterOption = 'Tous'; // Filtre par défaut

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notifications'),
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: _showFilterDialog,
          ),
        ],
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(8.0),
        itemCount: _filteredNotifications().length,
        itemBuilder: (context, index) {
          final notification = _filteredNotifications()[index];
          return _buildNotificationCard(notification);
        },
      ),
    );
  }

  // Filtrer les notifications en fonction du type
  List<Map<String, dynamic>> _filteredNotifications() {
    if (_filterOption == 'Tous') {
      return _notifications;
    }
    return _notifications
        .where((notification) => notification['type'] == _filterOption.toLowerCase())
        .toList();
  }

  // Widget pour construire chaque carte de notifications
  Widget _buildNotificationCard(Map<String, dynamic> notification) {
    // Déterminer l'icône et la couleur en fonction du type de notifications
    IconData iconData;
    Color iconColor;
    switch (notification['type']) {
      case 'contenu':
        iconData = Icons.book;
        iconColor = Colors.blue;
        break;
      case 'abonnement':
        iconData = Icons.payment;
        iconColor = Colors.green;
        break;
      case 'rappel':
        iconData = Icons.access_time;
        iconColor = Colors.orange;
        break;
      default:
        iconData = Icons.notifications;
        iconColor = Colors.grey;
    }

    return Card(
      elevation: 4,
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
      ),
      color: notification['isRead'] ? Colors.white : Colors.grey[100],
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: iconColor.withOpacity(0.1),
          child: Icon(iconData, color: iconColor),
        ),
        title: Text(
          notification['title'],
          style: TextStyle(
            fontWeight: notification['isRead'] ? FontWeight.normal : FontWeight.bold,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              notification['description'],
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 4.0),
            Text(
              notification['date'],
              style: const TextStyle(fontSize: 12, color: Colors.grey),
            ),
          ],
        ),
        trailing: IconButton(
          icon: Icon(
            notification['isRead'] ? Icons.mark_email_read : Icons.mark_email_unread,
            color: notification['isRead'] ? Colors.green : Colors.grey,
          ),
          onPressed: () {
            setState(() {
              notification['isRead'] = !notification['isRead'];
            });
          },
        ),
        onTap: () {
          // Action lors du tap sur la notifications
          setState(() {
            notification['isRead'] = true;
          });
          // Vous pouvez naviguer vers une page de détails si nécessaire
        },
      ),
    );
  }

  // Boîte de dialogue pour sélectionner le type de notifications à filtrer
  void _showFilterDialog() {
    showDialog(
      context: context,
      builder: (context) {
        String tempFilterOption = _filterOption;
        return AlertDialog(
          title: const Text('Filtrer les notifications'),
          content: StatefulBuilder(
            builder: (context, setState) {
              return DropdownButton<String>(
                value: tempFilterOption,
                onChanged: (value) {
                  setState(() {
                    tempFilterOption = value!;
                  });
                },
                items: ['Tous', 'Abonnement', 'Contenu', 'Rappel']
                    .map<DropdownMenuItem<String>>((String category) {
                  return DropdownMenuItem<String>(
                    value: category,
                    child: Text(category),
                  );
                }).toList(),
              );
            },
          ),
          actions: [
            TextButton(
              child: const Text('Annuler'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            ElevatedButton(
              child: const Text('Appliquer'),
              onPressed: () {
                setState(() {
                  _filterOption = tempFilterOption;
                });
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
