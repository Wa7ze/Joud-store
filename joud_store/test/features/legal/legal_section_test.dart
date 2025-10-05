import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sy_store/features/legal/widgets/legal_section.dart';

void main() {
  group('LegalSection Widget Tests', () {
    testWidgets('renders legal section with title and content', (WidgetTester tester) async {
      const title = 'Test Title';
      const content = 'Test Content';

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Column(
              children: [
                LegalSection(
                  title: title,
                  content: content,
                ),
              ],
            ),
          ),
        ),
      );

      expect(find.text(title), findsOneWidget);
      expect(find.text(content), findsOneWidget);
    });
  });
}
