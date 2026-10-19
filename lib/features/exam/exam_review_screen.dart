import 'package:flutter/material.dart';
import '../../core/models/exam_model.dart';
import '../../core/theme/app_colors.dart';
import 'exam_completed_screen.dart';

class ExamReviewScreen extends StatelessWidget {
  final ExamItem exam;
  final Map<int, String> answers; // questionId -> optionLetter (ex: 1 -> 'B')
  final Set<int> flaggedForReview; // questionIds marcadas para revisão
  final Function(int questionIndex) onNavigateToQuestion;

  const ExamReviewScreen({
    super.key,
    required this.exam,
    required this.answers,
    required this.flaggedForReview,
    required this.onNavigateToQuestion,
  });

  @override
  Widget build(BuildContext context) {
    final totalQuestions = exam.questions.length;
    final answeredCount = answers.length;
    final unAnsweredCount = totalQuestions - answeredCount;
    final flaggedCount = flaggedForReview.length;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.textWhite),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Revisão da Prova',
              style: TextStyle(
                color: AppColors.textWhite,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              exam.title,
              style: const TextStyle(
                color: AppColors.textMuted,
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Resumo de Métricas (Respondidas, Pendentes, Marcadas para Revisão)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              child: Row(
                children: [
                  _buildMetricCard(
                    title: 'Respondidas',
                    value: '$answeredCount / $totalQuestions',
                    color: AppColors.successGreen,
                    bgColor: AppColors.successGreenBg,
                  ),
                  const SizedBox(width: 10),
                  _buildMetricCard(
                    title: 'Em Branco',
                    value: '$unAnsweredCount',
                    color: unAnsweredCount > 0
                        ? AppColors.warningRed
                        : AppColors.textMuted,
                    bgColor: unAnsweredCount > 0
                        ? AppColors.warningRedBg
                        : AppColors.cardSurface,
                  ),
                  const SizedBox(width: 10),
                  _buildMetricCard(
                    title: 'Para Revisar',
                    value: '$flaggedCount',
                    color: AppColors.warningAmber,
                    bgColor: AppColors.warningAmberBg,
                  ),
                ],
              ),
            ),
            const Divider(color: AppColors.cardBorder, height: 1),

            // Lista detalhada de questões
            Expanded(
              child: ListView.separated(
                padding: const EdgeInsets.all(20),
                itemCount: exam.questions.length,
                separatorBuilder: (context, index) => const SizedBox(height: 12),
                itemBuilder: (context, index) {
                  final question = exam.questions[index];
                  final isAnswered = answers.containsKey(question.id);
                  final selectedLetter = answers[question.id];
                  final isFlagged = flaggedForReview.contains(question.id);

                  return _buildQuestionReviewCard(
                    context: context,
                    questionIndex: index,
                    question: question,
                    isAnswered: isAnswered,
                    selectedLetter: selectedLetter,
                    isFlagged: isFlagged,
                  );
                },
              ),
            ),

            // Botão Inferior de Entrega da Prova
            Container(
              padding: const EdgeInsets.all(20),
              decoration: const BoxDecoration(
                color: AppColors.cardSurface,
                border: Border(
                  top: BorderSide(color: AppColors.cardBorder, width: 1),
                ),
              ),
              child: SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF2563EB),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onPressed: () => _confirmSubmission(context, unAnsweredCount),
                  child: const Text(
                    'Finalizar e Entregar Prova',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMetricCard({
    required String title,
    required String value,
    required Color color,
    required Color bgColor,
  }) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 10),
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: color.withValues(alpha: 0.3), width: 1),
        ),
        child: Column(
          children: [
            Text(
              value,
              style: TextStyle(
                color: color,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              title,
              style: const TextStyle(
                color: AppColors.textMuted,
                fontSize: 11,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuestionReviewCard({
    required BuildContext context,
    required int questionIndex,
    required QuestionItem question,
    required bool isAnswered,
    required String? selectedLetter,
    required bool isFlagged,
  }) {
    return InkWell(
      borderRadius: BorderRadius.circular(14),
      onTap: () {
        // Volta para a tela da prova exatamente na questão clicada
        Navigator.of(context).pop();
        onNavigateToQuestion(questionIndex);
      },
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.cardSurface,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: isFlagged
                ? AppColors.warningAmber.withValues(alpha: 0.6)
                : isAnswered
                    ? AppColors.cardBorder
                    : AppColors.warningRedBorder,
            width: 1.2,
          ),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Indicador de Número da Questão
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: isAnswered
                    ? const Color(0xFF1D3557)
                    : const Color(0xFF23283B),
                borderRadius: BorderRadius.circular(8),
              ),
              alignment: Alignment.center,
              child: Text(
                '${questionIndex + 1}',
                style: TextStyle(
                  color: isAnswered ? const Color(0xFF60A5FA) : Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
            ),
            const SizedBox(width: 14),

            // Enunciado Resumido + Status
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    question.statement,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: AppColors.textWhite,
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                      height: 1.3,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      if (isAnswered)
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 3),
                          decoration: BoxDecoration(
                            color: AppColors.successGreenBg,
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            'Marcada: Opção $selectedLetter',
                            style: const TextStyle(
                              color: AppColors.successGreen,
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        )
                      else
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 3),
                          decoration: BoxDecoration(
                            color: AppColors.warningRedBg,
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: const Text(
                            'Não Respondida',
                            style: TextStyle(
                              color: AppColors.warningRed,
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      if (isFlagged) ...[
                        const SizedBox(width: 8),
                        const Icon(
                          Icons.flag,
                          color: AppColors.warningAmber,
                          size: 14,
                        ),
                        const SizedBox(width: 3),
                        const Text(
                          'Revisar',
                          style: TextStyle(
                            color: AppColors.warningAmber,
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(width: 8),
            const Icon(
              Icons.chevron_right,
              color: AppColors.textMuted,
              size: 20,
            ),
          ],
        ),
      ),
    );
  }

  void _confirmSubmission(BuildContext context, int unAnsweredCount) {
    showDialog(
      context: context,
      builder: (dialogCtx) => AlertDialog(
        backgroundColor: AppColors.cardSurface,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text(
          'Entregar Avaliação?',
          style: TextStyle(
            color: AppColors.textWhite,
            fontWeight: FontWeight.bold,
          ),
        ),
        content: Text(
          unAnsweredCount > 0
              ? 'Atenção: Você possui $unAnsweredCount questão(ões) em branco! Deseja realmente finalizar e entregar suas respostas agora?'
              : 'Você respondeu todas as questões. Ao confirmar, suas respostas serão registradas e a prova será concluída.',
          style: const TextStyle(color: Color(0xFFCBD5E1), fontSize: 14),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogCtx).pop(),
            child: const Text(
              'Continuar Revisando',
              style: TextStyle(color: AppColors.textMuted),
            ),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: unAnsweredCount > 0
                  ? AppColors.warningRed
                  : const Color(0xFF2563EB),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            onPressed: () {
              Navigator.of(dialogCtx).pop(); // fecha modal
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(
                  builder: (context) => ExamCompletedScreen(
                    totalQuestions: exam.questions.length,
                    answeredQuestions: answers.length,
                  ),
                ),
              );
            },
            child: const Text(
              'Confirmar Entrega',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
