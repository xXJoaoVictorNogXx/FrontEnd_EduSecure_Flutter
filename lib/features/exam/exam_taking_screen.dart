import 'dart:async';
import 'package:flutter/material.dart';
import '../../core/models/exam_model.dart';
import '../../core/theme/app_colors.dart';
import 'exam_review_screen.dart';
import 'exam_completed_screen.dart';

class ExamTakingScreen extends StatefulWidget {
  final ExamItem exam;

  const ExamTakingScreen({super.key, required this.exam});

  @override
  State<ExamTakingScreen> createState() => _ExamTakingScreenState();
}

class _ExamTakingScreenState extends State<ExamTakingScreen>
    with WidgetsBindingObserver {
  late int _currentQuestionIndex;
  late int _remainingSeconds;
  Timer? _timer;

  // Mapa de respostas: questionId -> optionLetter (ex: 1 -> 'B')
  final Map<int, String> _answers = {};

  // Conjunto de questões marcadas para revisão (pelo ID da questão)
  final Set<int> _flaggedForReview = {};

  // Contador de infrações de segurança (sair do app / perda de foco)
  int _securityInfractions = 0;

  @override
  void initState() {
    super.initState();
    // Registra o observador de ciclo de vida do Flutter (Kiosk Mode / Anti-cola)
    WidgetsBinding.instance.addObserver(this);

    _currentQuestionIndex = 0;
    // Duração inicial em segundos (ex: 90 min * 60 = 5400s)
    _remainingSeconds = widget.exam.durationMinutes * 60;
    _startTimer();
  }

  @override
  void dispose() {
    // Cancela o timer e desregistra o observador para evitar vazamento de memória
    _timer?.cancel();
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  /// Monitoramento de Segurança nativo do Flutter (Camada de Aplicação do Kiosk Mode)
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.inactive ||
        state == AppLifecycleState.paused) {
      _securityInfractions++;
      _showSecurityWarningDialog();
    }
  }

  void _showSecurityWarningDialog() {
    if (!mounted) return;
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (dialogCtx) => AlertDialog(
        backgroundColor: const Color(0xFF1F1215),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: const BorderSide(color: AppColors.warningRed, width: 1.5),
        ),
        title: Row(
          children: const [
            Icon(Icons.warning_amber_rounded,
                color: AppColors.warningRed, size: 28),
            SizedBox(width: 10),
            Text(
              'Violação de Segurança',
              style: TextStyle(
                color: AppColors.textWhite,
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
          ],
        ),
        content: Text(
          'O aplicativo perdeu o foco ou foi minimizado. Este evento foi registrado nos logs institucionais de auditoria.\n\nTotal de advertências: $_securityInfractions',
          style: const TextStyle(
            color: Color(0xFFE2E8F0),
            fontSize: 14,
            height: 1.4,
          ),
        ),
        actions: [
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.warningRed,
              foregroundColor: Colors.white,
            ),
            onPressed: () => Navigator.of(dialogCtx).pop(),
            child: const Text('Entendi e Retornar à Prova'),
          ),
        ],
      ),
    );
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_remainingSeconds > 0) {
        setState(() {
          _remainingSeconds--;
        });
      } else {
        _timer?.cancel();
        _autoSubmitExam();
      }
    });
  }

  void _autoSubmitExam() {
    if (!mounted) return;
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (context) => ExamCompletedScreen(
          totalQuestions: widget.exam.questions.length,
          answeredQuestions: _answers.length,
        ),
      ),
    );
  }

  String _formatTimer(int totalSeconds) {
    final minutes = totalSeconds ~/ 60;
    final seconds = totalSeconds % 60;
    final minStr = minutes.toString().padLeft(2, '0');
    final secStr = seconds.toString().padLeft(2, '0');
    return '$minStr:$secStr';
  }

  @override
  Widget build(BuildContext context) {
    final questions = widget.exam.questions;
    final totalQuestions = questions.length;
    final currentQuestion = questions[_currentQuestionIndex];
    final selectedOption = _answers[currentQuestion.id];
    final isFlagged = _flaggedForReview.contains(currentQuestion.id);

    return PopScope(
      canPop: false, // Bloqueia o botão/gesto voltar durante a prova
      child: Scaffold(
        backgroundColor: AppColors.background,
        body: SafeArea(
          child: Column(
            children: [
              // 1. Banner Superior de Segurança e Conectividade
              _buildOfflineSecurityBanner(),

              // 2. Cabeçalho com Timer Circular e Barra de Progresso
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                child: _buildHeaderProgress(totalQuestions),
              ),

              // 3. Área Central Rolável (Questão e Alternativas)
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Card do Enunciado da Questão
                      _buildQuestionCard(currentQuestion),
                      const SizedBox(height: 18),

                      // Lista de Alternativas (A, B, C, D)
                      ...currentQuestion.options.map((option) {
                        final isSelected = selectedOption == option.letter;
                        return _buildOptionItem(
                          letter: option.letter,
                          text: option.text,
                          isSelected: isSelected,
                          onTap: () {
                            setState(() {
                              _answers[currentQuestion.id] = option.letter;
                            });
                          },
                        );
                      }),
                      const SizedBox(height: 24),
                    ],
                  ),
                ),
              ),

              // 4. Barra de Ações Inferior
              _buildBottomActionBar(totalQuestions, currentQuestion.id, isFlagged),
            ],
          ),
        ),
      ),
    );
  }

  /// Banner Superior Vermelho: STATUS: OFFLINE — REDE BLOQUEADA
  Widget _buildOfflineSecurityBanner() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: const BoxDecoration(
        color: Color(0xFF261013),
        border: Border(
          bottom: BorderSide(color: Color(0xFF4A181D), width: 1),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: const [
              Icon(Icons.lock_outline, color: Color(0xFFEF4444), size: 16),
              SizedBox(width: 6),
              Icon(Icons.wifi_off, color: Color(0xFFEF4444), size: 16),
              SizedBox(width: 8),
              Text(
                'STATUS: OFFLINE — REDE BLOQUEADA',
                style: TextStyle(
                  color: Color(0xFFEF4444),
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 0.8,
                ),
              ),
            ],
          ),
          const Icon(
            Icons.warning_amber_rounded,
            color: Color(0xFFEF4444),
            size: 18,
          ),
        ],
      ),
    );
  }

  /// Cabeçalho com o Timer Circular e Progresso da Prova
  Widget _buildHeaderProgress(int totalQuestions) {
    final answeredCount = _answers.length;
    final progressFraction = (_currentQuestionIndex + 1) / totalQuestions;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        // Timer Circular
        Container(
          width: 78,
          height: 78,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: const Color(0xFF131728),
            border: Border.all(
              color: const Color(0xFF2563EB),
              width: 3.5,
            ),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF2563EB).withValues(alpha: 0.2),
                blurRadius: 10,
                spreadRadius: 1,
              ),
            ],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                _formatTimer(_remainingSeconds),
                style: const TextStyle(
                  color: AppColors.textWhite,
                  fontSize: 17,
                  fontWeight: FontWeight.bold,
                  letterSpacing: -0.5,
                ),
              ),
              const Text(
                'restantes',
                style: TextStyle(
                  color: Color(0xFF7E8B9F),
                  fontSize: 10,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: 16),

        // Dados da Questão, Título e Barra Linear de Progresso
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Questão ${_currentQuestionIndex + 1} de $totalQuestions',
                    style: const TextStyle(
                      color: AppColors.textWhite,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    '$answeredCount respondidas',
                    style: const TextStyle(
                      color: Color(0xFF7E8B9F),
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 4),
              Text(
                widget.exam.title,
                style: const TextStyle(
                  color: Color(0xFF6B7280),
                  fontSize: 12,
                  fontWeight: FontWeight.w400,
                ),
              ),
              const SizedBox(height: 10),
              // Barra de Progresso Azul
              ClipRRect(
                borderRadius: BorderRadius.circular(4),
                child: LinearProgressIndicator(
                  value: progressFraction,
                  minHeight: 4,
                  backgroundColor: const Color(0xFF1E2438),
                  valueColor:
                      const AlwaysStoppedAnimation<Color>(Color(0xFF2563EB)),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  /// Card do Enunciado
  Widget _buildQuestionCard(QuestionItem question) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: const Color(0xFF141724),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFF23283B), width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'QUESTÃO ${question.number}',
            style: const TextStyle(
              color: Color(0xFF7E8B9F),
              fontSize: 11,
              fontWeight: FontWeight.w700,
              letterSpacing: 1.0,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            question.statement,
            style: const TextStyle(
              color: AppColors.textWhite,
              fontSize: 15,
              fontWeight: FontWeight.w600,
              height: 1.45,
            ),
          ),
        ],
      ),
    );
  }

  /// Card de cada Alternativa (A, B, C, D)
  Widget _buildOptionItem({
    required String letter,
    required String text,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: isSelected ? const Color(0xFF1A233A) : const Color(0xFF131622),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: isSelected ? const Color(0xFF2563EB) : const Color(0xFF222638),
          width: isSelected ? 1.5 : 1.0,
        ),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(14),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
            child: Row(
              children: [
                // Badge com a Letra (A, B, C, D)
                Container(
                  width: 34,
                  height: 34,
                  decoration: BoxDecoration(
                    color: isSelected
                        ? const Color(0xFF2563EB)
                        : const Color(0xFF1E2235),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    letter,
                    style: TextStyle(
                      color: isSelected ? Colors.white : const Color(0xFF8E9BB0),
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(width: 14),
                // Texto da Alternativa
                Expanded(
                  child: Text(
                    text,
                    style: TextStyle(
                      color: isSelected ? Colors.white : const Color(0xFFCBD5E1),
                      fontSize: 14,
                      fontWeight:
                          isSelected ? FontWeight.w600 : FontWeight.w400,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// Barra Inferior de Navegação
  Widget _buildBottomActionBar(
      int totalQuestions, int currentQuestionId, bool isFlagged) {
    final isLast = _currentQuestionIndex == totalQuestions - 1;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
      decoration: const BoxDecoration(
        color: Color(0xFF0F121C),
        border: Border(
          top: BorderSide(color: Color(0xFF1E2336), width: 1),
        ),
      ),
      child: Row(
        children: [
          // Botão Anterior (se não for a primeira questão)
          if (_currentQuestionIndex > 0) ...[
            IconButton(
              icon: const Icon(Icons.arrow_back, color: Color(0xFF8E9BB0)),
              onPressed: () {
                setState(() {
                  _currentQuestionIndex--;
                });
              },
            ),
            const SizedBox(width: 6),
          ],

          // Botão Marcar para Revisão (Bandeira)
          IconButton(
            tooltip: 'Marcar para revisão',
            icon: Icon(
              isFlagged ? Icons.flag : Icons.outlined_flag,
              color: isFlagged
                  ? AppColors.warningAmber
                  : const Color(0xFF6B7280),
            ),
            onPressed: () {
              setState(() {
                if (isFlagged) {
                  _flaggedForReview.remove(currentQuestionId);
                } else {
                  _flaggedForReview.add(currentQuestionId);
                }
              });
            },
          ),

          // Botão Abrir Tela de Revisão Geral
          IconButton(
            tooltip: 'Visão Geral / Revisão',
            icon: const Icon(Icons.grid_view, color: Color(0xFF6B7280)),
            onPressed: _openReviewScreen,
          ),

          const SizedBox(width: 10),

          // Botão Principal: "Próxima Questão >" ou "Revisar Prova"
          Expanded(
            child: SizedBox(
              height: 48,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF1E2E4A),
                  foregroundColor: const Color(0xFF60A5FA),
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                    side: const BorderSide(
                        color: Color(0xFF2563EB), width: 1.0),
                  ),
                ),
                onPressed: () {
                  if (isLast) {
                    _openReviewScreen();
                  } else {
                    setState(() {
                      _currentQuestionIndex++;
                    });
                  }
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      isLast ? 'Revisar Prova' : 'Próxima Questão',
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(width: 6),
                    const Icon(Icons.chevron_right, size: 18),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _openReviewScreen() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => ExamReviewScreen(
          exam: widget.exam,
          answers: _answers,
          flaggedForReview: _flaggedForReview,
          onNavigateToQuestion: (index) {
            setState(() {
              _currentQuestionIndex = index;
            });
          },
        ),
      ),
    );
  }
}
