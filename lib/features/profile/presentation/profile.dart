import 'package:pocaudiolearn/features/faq/presentation/faq.dart';
import 'package:flutter/material.dart';

import '../../audio_courses/audio_courses_search/presentation/search.dart';
import '../../dashboard/presentation/dashboard.dart';
import '../../favorites/presentation/favorites.dart';

class UserProfilePage extends StatefulWidget {
  const UserProfilePage({super.key});

  @override
  UserProfilePageState createState() => UserProfilePageState();
}

class UserProfilePageState extends State<UserProfilePage> {
  bool _emailNotifications = true;
  bool _pushNotifications = false;

  // Sample user data
  final Map<String, String> _userInfo = {
    'name': 'John Doe',
    'email': 'johndoe@example.com',
    'profileImage': 'https://example.com/profile.jpg',
  };

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // User Info Section
          _buildUserInfoSection(),

          const SizedBox(height: 20),

          // Course Section
          _buildCourseSection(),

          const SizedBox(height: 20),

          // Notification Preferences
          _buildNotificationPreferences(),

          const SizedBox(height: 20),

          // Account Settings Section
          _buildAccountSettings(),

          const SizedBox(height: 20),

          // Privacy Settings Section
          _buildPrivacySettings(),

          const SizedBox(height: 20),

          _buildFAQSection()
        ],
      ),
    );
  }

  // Build User Info Section
  Widget _buildUserInfoSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            // Profile Picture
            CustomCircleAvatar(
              imageUrl: _userInfo['profileImage'],
            ),
            const SizedBox(width: 20),
            // Name and Email
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _userInfo['name']!,
                  style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 5),
                Text(_userInfo['email']!),
              ],
            ),
          ],
        ),
        const SizedBox(height: 10),
        ElevatedButton(
          onPressed: () {
            // Logic to change profile picture
          },
          child: const Text('Modifier la photo de profil'),
        ),
      ],
    );
  }

  // Build Course Section
  Widget _buildCourseSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Formations',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        ListTile(
          title: const Text('Historique des Formations Suivies'),
          trailing: const Icon(Icons.arrow_forward_ios),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const DashboardPage(),
              ),
            );
          },
        ),
        ListTile(
          title: const Text('Mes Favoris'),
          trailing: const Icon(Icons.arrow_forward_ios),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const FavoritesPage(),
              ),
            );
          },
        ),
        ListTile(
          title: const Text('Rechercher une formation'),
          trailing: const Icon(Icons.arrow_forward_ios),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const FormationListPage(),
              ),
            );
          },
        ),
      ],
    );
  }

  // Build Notification Preferences Section
  Widget _buildNotificationPreferences() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Préférences de Notification',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        ListTile(
          title: const Text('Mes Notifications'),
          trailing: const Icon(Icons.arrow_forward_ios),
          onTap: () {
            // Logic for privacy settings
          },
        ),
        SwitchListTile(
          title: const Text('Notifications Push'),
          value: _pushNotifications,
          onChanged: (bool value) {
            setState(() {
              _pushNotifications = value;
            });
          },
        ),
        SwitchListTile(
          title: const Text('Notifications par Email'),
          value: _emailNotifications,
          onChanged: (bool value) {
            setState(() {
              _emailNotifications = value;
            });
          },
        ),
      ],
    );
  }

  // Build Account Settings Section
  Widget _buildAccountSettings() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Paramètres du Compte',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        ListTile(
          title: const Text('Modifier le Mot de Passe'),
          trailing: const Icon(Icons.arrow_forward_ios),
          onTap: () {
            // Logic to change password
          },
        ),
        ListTile(
          title: const Text('Modifier les Informations du Compte'),
          trailing: const Icon(Icons.arrow_forward_ios),
          onTap: () {
            // Logic to update user info
          },
        ),
      ],
    );
  }

  // Build Privacy Settings Section
  Widget _buildPrivacySettings() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ListTile(
          title: const Text('Paramètres de confidentialité',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)
          ),
          trailing: const Icon(Icons.arrow_forward_ios),
          onTap: () {
            // Logic for privacy settings
          },
        ),
      ],
    );
  }

  // Build Course Section
  Widget _buildFAQSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ListTile(
          title: const Text('FAQ',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)
          ),
          trailing: const Icon(Icons.arrow_forward_ios),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const FAQPage(),
              ),
            );
          },
        ),
      ],
    );
  }

}

class CustomCircleAvatar extends StatelessWidget {
  final String? imageUrl;

  const CustomCircleAvatar({super.key, this.imageUrl});

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      radius: 40,
      child: imageUrl != null && imageUrl!.isNotEmpty
          ? Image.network(
        imageUrl!,
        fit: BoxFit.cover,  // L'image couvre l'espace sans distorsion
        errorBuilder: (context, error, stackTrace) {
          // Affiche une icône d'image cassée si l'image ne se charge pas
          return const Center(
            child: Icon(Icons.person, size: 32, color: Colors.grey),
          );
        },
      )
          : const Center(
        child: Icon(Icons.person, size: 32, color: Colors.grey),
      ), // Affiche une icône utilisateur si l'URL est null ou vide
    );
  }
}

