import 'package:flutter/material.dart';
import '../data/quiz.dart';
import '../data/question.dart';

class QuizPage extends StatefulWidget {
  final Quiz quiz;

  const QuizPage({super.key, required this.quiz});

  @override
  QuizPageState createState() => QuizPageState();
}

class QuizPageState extends State<QuizPage> {
  int _currentQuestionIndex = 0;
  Map<int, List<int>> _userAnswers = {}; // Map question index to list of selected option indexes

  @override
  Widget build(BuildContext context) {
    final question = widget.quiz.questions[_currentQuestionIndex];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Quiz'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text(
              'Question ${_currentQuestionIndex + 1}/${widget.quiz.questions.length}',
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16.0),
            Text(
              question.text,
              style: const TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 16.0),
            Expanded(
              child: _buildOptionsList(question),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                if (_currentQuestionIndex > 0)
                  ElevatedButton(
                    onPressed: _previousQuestion,
                    child: const Text('Précédent'),
                  ),
                if (_currentQuestionIndex < widget.quiz.questions.length - 1)
                  ElevatedButton(
                    onPressed: _nextQuestion,
                    child: const Text('Suivant'),
                  ),
                if (_currentQuestionIndex == widget.quiz.questions.length - 1)
                  ElevatedButton(
                    onPressed: _finishQuiz,
                    child: const Text('Terminer'),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOptionsList(Question question) {
    final selectedOptions = _userAnswers[_currentQuestionIndex] ?? [];

    return ListView.builder(
      itemCount: question.options.length,
      itemBuilder: (context, index) {
        final optionText = question.options[index];
        final isSelected = selectedOptions.contains(index);

        return ListTile(
          leading: question.type == QuestionType.singleChoice
              ? Radio<int>(
            value: index,
            groupValue: selectedOptions.isNotEmpty ? selectedOptions.first : -1,
            onChanged: (value) {
              _onOptionSelected(index);
            },
          )
              : Checkbox(
            value: isSelected,
            onChanged: (value) {
              _onOptionSelected(index);
            },
          ),
          title: Text(optionText),
          onTap: () {
            _onOptionSelected(index);
          },
        );
      },
    );
  }

  void _onOptionSelected(int index) {
    final question = widget.quiz.questions[_currentQuestionIndex];

    setState(() {
      if (question.type == QuestionType.singleChoice) {
        _userAnswers[_currentQuestionIndex] = [index];
      } else {
        final selectedOptions = _userAnswers[_currentQuestionIndex] ?? [];
        if (selectedOptions.contains(index)) {
          selectedOptions.remove(index);
        } else {
          selectedOptions.add(index);
        }
        _userAnswers[_currentQuestionIndex] = selectedOptions;
      }
    });
  }

  void _nextQuestion() {
    setState(() {
      _currentQuestionIndex++;
    });
  }

  void _previousQuestion() {
    setState(() {
      _currentQuestionIndex--;
    });
  }

  void _finishQuiz() {
    // Calculer le score et afficher les résultats
    int score = 0;
    for (int i = 0; i < widget.quiz.questions.length; i++) {
      final question = widget.quiz.questions[i];
      final userAnswer = _userAnswers[i] ?? [];
      if (_areListsEqual(question.correctAnswers, userAnswer)) {
        score++;
      }
    }

    final totalQuestions = widget.quiz.questions.length;

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Résultats du Quiz'),
          content: Text('Vous avez obtenu $score sur $totalQuestions.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.of(context).pop(); // Retour à la page précédente
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  bool _areListsEqual(List<int> list1, List<int> list2) {
    final set1 = Set.from(list1);
    final set2 = Set.from(list2);
    return set1.difference(set2).isEmpty && set2.difference(set1).isEmpty;
  }
}
