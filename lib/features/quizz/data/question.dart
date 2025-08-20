enum QuestionType {
  singleChoice,
  multipleChoice,
}

class Question {
  final String text;
  final List<String> options;
  final List<int> correctAnswers; // Index(es) des bonnes réponses
  final QuestionType type;

  Question({
    required this.text,
    required this.options,
    required this.correctAnswers,
    required this.type,
  });
}
