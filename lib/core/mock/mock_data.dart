import '../models/exam_model.dart';

class MockData {
  static final List<ExamItem> exams = [
    ExamItem(
      id: 'aed-301',
      code: 'AED-301',
      status: ExamStatus.available,
      title: 'Algoritmos e Estruturas de Dados',
      scheduleText: 'Hoje · 14:00',
      durationMinutes: 90,
      totalQuestions: 3,
      isEncrypted: true,
      isOffline: true,
      questions: [
        const QuestionItem(
          id: 1,
          number: 1,
          statement:
              'Qual é a complexidade de tempo do algoritmo de busca binária no pior caso?',
          options: [
            OptionItem(letter: 'A', text: 'O(n)'),
            OptionItem(letter: 'B', text: 'O(log n)'),
            OptionItem(letter: 'C', text: 'O(n log n)'),
            OptionItem(letter: 'D', text: 'O(n²)'),
          ],
        ),
        const QuestionItem(
          id: 2,
          number: 2,
          statement:
              'Qual estrutura de dados opera estritamente sob o princípio LIFO (Last In, First Out)?',
          options: [
            OptionItem(letter: 'A', text: 'Fila (Queue)'),
            OptionItem(letter: 'B', text: 'Pilha (Stack)'),
            OptionItem(letter: 'C', text: 'Lista Encadeada (LinkedList)'),
            OptionItem(letter: 'D', text: 'Grafo (Graph)'),
          ],
        ),
        const QuestionItem(
          id: 3,
          number: 3,
          statement:
              'Em uma Árvore Binária de Busca (BST) balanceada, onde os nós com valores menores que a raiz são alocados?',
          options: [
            OptionItem(letter: 'A', text: 'Na subárvore esquerda'),
            OptionItem(letter: 'B', text: 'Na subárvore direita'),
            OptionItem(letter: 'C', text: 'Em qualquer folha aleatória'),
            OptionItem(letter: 'D', text: 'No nível mais profundo exclusivamente'),
          ],
        ),
      ],
    ),
    const ExamItem(
      id: 'eng-204',
      code: 'ENG-204',
      status: ExamStatus.upcoming,
      title: 'Engenharia de Software',
      scheduleText: 'Amanhã · 10:00',
      durationMinutes: 60,
      totalQuestions: 15,
      isEncrypted: true,
      isOffline: true,
    ),
    const ExamItem(
      id: 'bdi-102',
      code: 'BDI-102',
      status: ExamStatus.upcoming,
      title: 'Banco de Dados',
      scheduleText: '22/08/2026 · 16:00',
      durationMinutes: 120,
      totalQuestions: 25,
      isEncrypted: true,
      isOffline: true,
    ),
    const ExamItem(
      id: 'mat-101',
      code: 'MAT-101',
      status: ExamStatus.completed,
      title: 'Cálculo I',
      scheduleText: '19/08/2026 · 08:00',
      durationMinutes: 90,
      totalQuestions: 10,
      grade: 8.5,
      isEncrypted: true,
      isOffline: true,
    ),
  ];
}
