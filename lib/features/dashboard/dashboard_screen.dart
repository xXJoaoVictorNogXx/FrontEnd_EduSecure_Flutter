import 'package:flutter/material.dart';
import '../../core/models/exam_model.dart';
import '../../core/mock/mock_data.dart';
import '../../core/theme/app_colors.dart';
import '../exam/exam_taking_screen.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildUserHeader(),
              const SizedBox(height: 20),
              _buildSecurityStatusBanner(),
              const SizedBox(height: 28),
              _buildSectionTitle('PROVAS DISPONÍVEIS'),
              const SizedBox(height: 14),
              _buildExamList(context),
            ],
          ),
        ),
      ),
    );
  }

  /// Cabeçalho com dados do aluno e avatar com as iniciais LF.
  Widget _buildUserHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            Text(
              'Bem-vindo de volta',
              style: TextStyle(
                color: AppColors.textMuted,
                fontSize: 13,
                fontWeight: FontWeight.w400,
              ),
            ),
            SizedBox(height: 2),
            Text(
              'Lucas Ferreira',
              style: TextStyle(
                color: AppColors.textWhite,
                fontSize: 22,
                fontWeight: FontWeight.bold,
                letterSpacing: -0.5,
              ),
            ),
            SizedBox(height: 2),
            Text(
              'RA-2024-0817',
              style: TextStyle(
                color: AppColors.textMuted,
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
        // Avatar circular roxo com as iniciais "LF"
        Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            color: const Color(0xFF5B4DFF),
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF5B4DFF).withValues(alpha: 0.3),
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          alignment: Alignment.center,
          child: const Text(
            'LF',
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }

  /// Card de integridade e segurança do dispositivo (modo institucional).
  Widget _buildSecurityStatusBanner() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: AppColors.successGreenBg.withValues(alpha: 0.6),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.successGreenBorder, width: 1.2),
      ),
      child: Row(
        children: [
          const Icon(
            Icons.shield_outlined,
            color: AppColors.successGreen,
            size: 24,
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text(
                  'Dispositivo autenticado e seguro',
                  style: TextStyle(
                    color: AppColors.successGreen,
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 2),
                Text(
                  'Identidade verificada · Integridade OK',
                  style: TextStyle(
                    color: Color(0xFF4ADE80),
                    fontSize: 11,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ],
            ),
          ),
          Container(
            width: 8,
            height: 8,
            decoration: const BoxDecoration(
              color: AppColors.successGreen,
              shape: BoxShape.circle,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        color: Color(0xFF6B7280),
        fontSize: 12,
        fontWeight: FontWeight.w700,
        letterSpacing: 1.2,
      ),
    );
  }

  Widget _buildExamList(BuildContext context) {
    return Column(
      children: MockData.exams.map((exam) {
        return _buildExamCard(context, exam);
      }).toList(),
    );
  }

  Widget _buildExamCard(BuildContext context, ExamItem exam) {
    final isAvailable = exam.status == ExamStatus.available;
    final isCompleted = exam.status == ExamStatus.completed;

    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      decoration: BoxDecoration(
        color: AppColors.cardSurface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isAvailable ? const Color(0xFF232A3E) : AppColors.cardBorder,
          width: 1,
        ),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: isAvailable
              ? () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => ExamTakingScreen(exam: exam),
                    ),
                  );
                }
              : null,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Linha Superior: Código + Status + Ação/Seta
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        // Código da Disciplina (Ex: AED-301)
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: const Color(0xFF1E2235),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            exam.code,
                            style: const TextStyle(
                              color: Color(0xFF8B9BB4),
                              fontSize: 11,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        // Badge de Status
                        _buildStatusBadge(exam.status),
                      ],
                    ),
                    if (isAvailable)
                      const Icon(
                        Icons.chevron_right,
                        color: Color(0xFF4B5565),
                        size: 20,
                      )
                    else if (isCompleted)
                      const Icon(
                        Icons.check_circle_outline,
                        color: AppColors.successGreen,
                        size: 20,
                      ),
                  ],
                ),
                const SizedBox(height: 12),

                // Título da Prova
                Text(
                  exam.title,
                  style: const TextStyle(
                    color: AppColors.textWhite,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 10),

                // Metadados (Data, Tempo, Questões)
                Row(
                  children: [
                    const Icon(Icons.calendar_today_outlined,
                        color: Color(0xFF7E8B9F), size: 14),
                    const SizedBox(width: 5),
                    Text(
                      exam.scheduleText,
                      style: const TextStyle(
                        color: Color(0xFF94A3B8),
                        fontSize: 12,
                      ),
                    ),
                    const SizedBox(width: 14),
                    const Icon(Icons.access_time,
                        color: Color(0xFF7E8B9F), size: 14),
                    const SizedBox(width: 5),
                    Text(
                      '${exam.durationMinutes} min',
                      style: const TextStyle(
                        color: Color(0xFF94A3B8),
                        fontSize: 12,
                      ),
                    ),
                    const SizedBox(width: 14),
                    const Icon(Icons.menu_book_outlined,
                        color: Color(0xFF7E8B9F), size: 14),
                    const SizedBox(width: 5),
                    Text(
                      '${exam.totalQuestions} questões',
                      style: const TextStyle(
                        color: Color(0xFF94A3B8),
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 14),

                // Tags de Segurança (Cifrada & Offline) + Nota (se houver)
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        // Tag Cifrada
                        _buildTag(
                          icon: Icons.lock_outline,
                          label: 'Cifrada',
                          textColor: const Color(0xFFA78BFA),
                          bgColor: const Color(0xFF2E234D),
                        ),
                        const SizedBox(width: 8),
                        // Tag Offline
                        _buildTag(
                          icon: Icons.wifi_off,
                          label: 'Offline',
                          textColor: const Color(0xFFFBBF24),
                          bgColor: const Color(0xFF3B2F17),
                        ),
                      ],
                    ),
                    if (exam.grade != null)
                      Text(
                        exam.grade!.toStringAsFixed(1),
                        style: const TextStyle(
                          color: Color(0xFF22C55E),
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStatusBadge(ExamStatus status) {
    switch (status) {
      case ExamStatus.available:
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: const Color(0xFF1D3557),
            borderRadius: BorderRadius.circular(6),
          ),
          child: const Text(
            'Disponível',
            style: TextStyle(
              color: Color(0xFF60A5FA),
              fontSize: 11,
              fontWeight: FontWeight.w600,
            ),
          ),
        );
      case ExamStatus.upcoming:
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: const Color(0xFF23283B),
            borderRadius: BorderRadius.circular(6),
          ),
          child: const Text(
            'Em breve',
            style: TextStyle(
              color: Color(0xFF94A3B8),
              fontSize: 11,
              fontWeight: FontWeight.w600,
            ),
          ),
        );
      case ExamStatus.completed:
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: const Color(0xFF134E35),
            borderRadius: BorderRadius.circular(6),
          ),
          child: const Text(
            'Concluída',
            style: TextStyle(
              color: Color(0xFF4ADE80),
              fontSize: 11,
              fontWeight: FontWeight.w600,
            ),
          ),
        );
    }
  }

  Widget _buildTag({
    required IconData icon,
    required String label,
    required Color textColor,
    required Color bgColor,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: textColor, size: 12),
          const SizedBox(width: 4),
          Text(
            label,
            style: TextStyle(
              color: textColor,
              fontSize: 11,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
