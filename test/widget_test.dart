import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_application/main.dart';

void main() {
  testWidgets('EduSecureApp smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(const EduSecureApp());
    expect(find.text('PROVAS DISPONÍVEIS'), findsOneWidget);
    expect(find.text('Lucas Ferreira'), findsOneWidget);
  });
}
