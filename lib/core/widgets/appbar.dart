import 'package:flutter/material.dart';
import '../../features/favorites/presentation/favorites.dart';
import '../../features/notifications/presentation/notif.dart';

class CustomAppBarActions extends StatelessWidget {
  const CustomAppBarActions({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        // Icone de favoris (coeur)
        IconButton(
          icon: const Icon(Icons.favorite), // Icône de cœur
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const FavoritesPage(), // Naviguer vers la page de favoris
              ),
            );
          },
        ),

        // Icone de notifications
        NamedIcon(
          iconData: Icons.notifications,
          notificationCount: 11,
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const NotificationPage(),
              ),
            );
          },
        ),
      ],
    );
  }
}

class NamedIcon extends StatelessWidget {
  final IconData iconData;
  final String? text;
  final VoidCallback? onTap;
  final int notificationCount;

  const NamedIcon({
    super.key,
    this.onTap,
    this.text,
    required this.iconData,
    this.notificationCount = 0,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        width: 72,
        padding: const EdgeInsets.symmetric(horizontal: 8),
        child: Stack(
          alignment: Alignment.center,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Icon(iconData),
                if (text != null && text!.isNotEmpty) // Si le texte n'est pas null et non vide
                  Text(
                    text!,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(color: Colors.white), // Texte en blanc
                  ),
              ],
            ),
            if (notificationCount > 0) // Afficher le badge seulement si notificationCount > 0
              Positioned(
                top: 8,
                right: 3,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: const BoxDecoration(shape: BoxShape.circle, color: Colors.red),
                  alignment: Alignment.center,
                  child: Text(
                    '$notificationCount',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              )
          ],
        ),
      ),
    );
  }
}
