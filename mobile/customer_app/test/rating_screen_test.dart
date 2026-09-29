import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:customer_app/features/request/presentation/rating_screen.dart';

void main() {
  group('RatingScreen Tests', () {
    testWidgets('Displays stars and handles selection', (WidgetTester tester) async {
      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(
            home: RatingScreen(requestId: 'req-1', saathiId: 'saathi-1'),
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.text('How was your experience?'), findsOneWidget);
      expect(find.byType(IconButton), findsNWidgets(5));
      expect(find.text('Submit Rating'), findsOneWidget);

      final submitButton = tester.widget<ElevatedButton>(find.byType(ElevatedButton));
      expect(submitButton.onPressed, isNull, reason: 'Submit button should be disabled when stars is 0');

      // Tap 3rd star
      await tester.tap(find.byType(IconButton).at(2));
      await tester.pumpAndSettle();

      final updatedSubmitButton = tester.widget<ElevatedButton>(find.byType(ElevatedButton));
      expect(updatedSubmitButton.onPressed, isNotNull, reason: 'Submit button should be enabled when stars > 0');
    });
  });
}
