import 'package:pocaudiolearn/features/quizz/presentation/quizz.dart';
import 'package:flutter/material.dart';
import 'package:pocaudiolearn/core/sound_player.dart';

import '../../../quizz/data/question.dart';
import '../../../quizz/data/quiz.dart';
import '../../audio_courses_player/presentation/player_page.dart';


class FormationDetailPage extends StatefulWidget {
  final Map<String, String> formation;

  const FormationDetailPage({super.key, required this.formation});

  @override
  FormationDetailPageState createState() => FormationDetailPageState();
}

class FormationDetailPageState extends State<FormationDetailPage> {
  // final AudioPlayer _audioPlayer = AudioPlayer();
  bool _isPlaying = false;
  final double _progress = 0.0;  // Progress indicator

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.formation['title']!),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Title and description
            Text(
              widget.formation['title']!,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            Text(widget.formation['description']!),
            const SizedBox(height: 20),

            // Audio player section
            // AudioLessonPlayer(lessonId: 1, client: null,),

            const SizedBox(height: 20),

            // Modules preview (static for now)
            _buildModulesPreview(),

            const SizedBox(height: 20),

            // Progress indicator
            _buildProgressIndicator(),

            const SizedBox(height: 20),

            // Comments and reviews
            _buildCommentsSection(),

            const SizedBox(height: 20),

            // Resources (static for now)
            _buildResourcesSection(),

            const SizedBox(height: 20),

            // Start/Resume button
            _buildStartOrResumeButton(),

            const SizedBox(height: 20),

            // Quiz button
            _buildQuizButton(),
          ],
        ),
      ),
    );
  }

  void _toggleAudio() {
    /* if (_isPlaying) {
      _audioPlayer.pause();
    } else {
      _audioPlayer.play(UrlSource('https://example.com/audio_sample.mp3'));
    } */
    setState(() {
      _isPlaying = !_isPlaying;
    });
  }

  // Modules preview
  Widget _buildModulesPreview() {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Aperçu des Modules', style: TextStyle(fontSize: 18)),
        SizedBox(height: 10),
        Text('- Module 1: Introduction'),
        Text('- Module 2: Concepts avancés'),
        Text('- Module 3: Exemples pratiques'),
      ],
    );
  }

  // Progress indicator
  Widget _buildProgressIndicator() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Votre progression', style: TextStyle(fontSize: 18)),
        const SizedBox(height: 10),
        LinearProgressIndicator(
          value: _progress,
          backgroundColor: Colors.grey[300],
          color: Colors.blue,
          minHeight: 8.0,
        ),
        const SizedBox(height: 10),
        Text('${(_progress * 100).toStringAsFixed(0)}% complété'),
      ],
    );
  }

  // Comments and reviews
  Widget _buildCommentsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Commentaires et Avis', style: TextStyle(fontSize: 18)),
        const SizedBox(height: 10),
        _buildComment('Utilisateur A', 'Super formation, très utile!', 4.5),
        _buildComment('Utilisateur B', 'Bonne qualité de contenu.', 4.0),
        const SizedBox(height: 10),
        ElevatedButton(
          onPressed: () {
            // Show form to submit review
          },
          child: const Text('Donner un avis'),
        ),
      ],
    );
  }

  Widget _buildComment(String user, String comment, double rating) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(user, style: const TextStyle(fontWeight: FontWeight.bold)),
            const Spacer(),
            Row(
              children: List.generate(
                rating.toInt(),
                    (index) => const Icon(Icons.star, color: Colors.yellow),
              ),
            ),
            Text(' ${rating.toString()}'),
          ],
        ),
        const SizedBox(height: 5),
        Text(comment),
        const SizedBox(height: 10),
      ],
    );
  }

  // Resources section
  Widget _buildResourcesSection() {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Ressources supplémentaires', style: TextStyle(fontSize: 18)),
        SizedBox(height: 10),
        Text('- PDF Guide complet'),
        Text('- Vidéos tutoriels'),
      ],
    );
  }

  // Start or resume button
  Widget _buildStartOrResumeButton() {

    return Center(
      child: ElevatedButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const AudioPlayerPage(),
            ),
          );
        },
        child: const Text('Commencer / Reprendre la Formation'),
      ),
    );
  }

  Widget _buildQuizButton() {

    // Créons un quiz d'exemple
    final quiz = Quiz(
      questions: [
        Question(
          text: 'Quelle est la capitale de la France ?',
          options: ['Paris', 'Londres', 'Berlin', 'Madrid'],
          correctAnswers: [0],
          type: QuestionType.singleChoice,
        ),
        Question(
          text: 'Sélectionnez les langages de programmation.',
          options: ['HTML', 'Python', 'CSS', 'Java'],
          correctAnswers: [1, 3],
          type: QuestionType.multipleChoice,
        ),
        Question(
          text: 'Flutter est basé sur quel langage ?',
          options: ['Java', 'Dart', 'Kotlin', 'Swift'],
          correctAnswers: [1],
          type: QuestionType.singleChoice,
        ),
        // Ajoutez plus de questions ici
      ],
    );

    return Center(
      child: ElevatedButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => QuizPage(quiz: quiz,),
            ),
          );
        },
        child: const Text('Lancer le Quiz'),
      ),
    );
  }
}