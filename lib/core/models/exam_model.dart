/// Representa uma alternativa de questão.
class OptionItem {
  final String letter; // 'A', 'B', 'C', 'D'
  final String text;

  const OptionItem({
    required this.letter,
    required this.text,
  });
}

/// Representa uma questão da prova.
class QuestionItem {
  final int id;
  final int number;
  final String statement;
  final List<OptionItem> options;

  const QuestionItem({
    required this.id,
    required this.number,
    required this.statement,
    required this.options,
  });
}

/// Status de uma prova no dashboard.
enum ExamStatus {
  available, // Disponível para realizar
  upcoming,  // Em breve (bloqueada até o horário)
  completed, // Já realizada e com nota
}

/// Representa uma prova institucional completa.
class ExamItem {
  final String id;
  final String code; // Ex: AED-301
  final ExamStatus status;
  final String title;
  final String scheduleText; // Ex: "Hoje · 14:00"
  final int durationMinutes;
  final int totalQuestions;
  final double? grade; // Nota se já concluída (Ex: 8.5)
  final bool isEncrypted;
  final bool isOffline;
  final List<QuestionItem> questions;

  const ExamItem({
    required this.id,
    required this.code,
    required this.status,
    required this.title,
    required this.scheduleText,
    required this.durationMinutes,
    required this.totalQuestions,
    this.grade,
    this.isEncrypted = true,
    this.isOffline = true,
    this.questions = const [],
  });
}
