import 'package:flutter/material.dart';
import '../../features/audio_courses/audio_courses_details/presentation/audio_details.dart';

class FormationGrid extends StatelessWidget {
  final List<Map<String, String>> formations;
  final bool isHorizontal; // Paramètre pour l'orientation des cartes et du scroller

  const FormationGrid({super.key, required this.formations, this.isHorizontal = true});

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      scrollDirection: isHorizontal ? Axis.horizontal : Axis.vertical, // Scroller horizontal ou vertical
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 1, // Nombre de colonnes (2 pour les cartes verticales)
        childAspectRatio: isHorizontal ? 16 / 9 : 2 / 1, // Ratio des cartes
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
      ),
      padding: const EdgeInsets.all(8.0),
      itemCount: formations.length,
      itemBuilder: (context, index) {
        final formation = formations[index];
        return FormationCard(formation: formation, isHorizontal: isHorizontal);
      },
    );
  }
}

class FormationCard extends StatefulWidget {
  final Map<String, String> formation;
  final bool isHorizontal; // Orientation des cartes

  const FormationCard({super.key, required this.formation, required this.isHorizontal});

  @override
  FormationCardState createState() => FormationCardState();
}

class FormationCardState extends State<FormationCard> {
  bool isFavorite = false; // État du favori

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => FormationDetailPage(formation: widget.formation),
          ),
        );
      },
      child: Card(
        child: widget.isHorizontal
            ? Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CustomImageWidget(imageUrl: widget.formation['imageUrl']),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.formation['title']!,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8.0),
                    Text(widget.formation['description']!),
                    const Spacer(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // Icône étoile à gauche
                        Row(
                          children: [
                            const Icon(Icons.star, color: Colors.yellow),
                            Text(widget.formation['rating']!),
                          ],
                        ),
                        // Icône cœur à droite
                        IconButton(
                          icon: Icon(
                            isFavorite ? Icons.favorite : Icons.favorite_border,
                            color: isFavorite ? Colors.red : Colors.grey,
                          ),
                          onPressed: () {
                            setState(() {
                              isFavorite = !isFavorite;
                              // Ajouter la logique pour sauvegarder le statut favori
                            });
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        )
            : Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                CustomImageWidget(imageUrl: widget.formation['imageUrl']),
                Positioned(
                  top: 8,
                  right: 8,
                  child: IconButton(
                    icon: Icon(
                      isFavorite ? Icons.favorite : Icons.favorite_border,
                      color: isFavorite ? Colors.red : Colors.grey,
                    ),
                    onPressed: () {
                      setState(() {
                        isFavorite = !isFavorite;
                        // Ajouter la logique pour sauvegarder le statut favori
                      });
                    },
                  ),
                ),
              ],
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.formation['title']!,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8.0),
                    Text(widget.formation['description']!),
                    const Spacer(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        const Icon(Icons.star, color: Colors.yellow),
                        Text(widget.formation['rating']!),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class CustomImageWidget extends StatelessWidget {
  final String? imageUrl;

  const CustomImageWidget({super.key, this.imageUrl});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(16.0),
      child: AspectRatio(
        aspectRatio: 1, // Maintient le ratio 1:1 pour l'image
        child: Container(
          color: Colors.grey[300],
          child: imageUrl != null && imageUrl!.isNotEmpty
              ? Image.network(
            imageUrl!,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) {
              return const Center(
                child: Icon(Icons.broken_image, size: 64, color: Colors.grey),
              );
            },
          )
              : const Center(
            child: Icon(Icons.broken_image, size: 64, color: Colors.grey),
          ),
        ),
      ),
    );
  }
}
