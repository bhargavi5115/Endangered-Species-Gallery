import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:endangered_species_gallery/core/constants/conservation_status.dart';
import 'package:endangered_species_gallery/widgets/status_badge.dart';
import 'package:endangered_species_gallery/widgets/empty_state.dart';
import 'package:endangered_species_gallery/widgets/category_filter.dart';
import 'package:endangered_species_gallery/widgets/search_widget.dart';
import 'package:endangered_species_gallery/services/local_storage_service.dart';
import 'package:endangered_species_gallery/features/home/providers/app_providers.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('Widget Tests for Species Gallery Components', () {
    testWidgets('StatusBadge renders code and full name correctly', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: StatusBadge(
              status: ConservationStatus.cr,
              showFullName: true,
            ),
          ),
        ),
      );

      expect(find.text('CR'), findsOneWidget);
      expect(find.text('• Critically Endangered'), findsOneWidget);
    });

    testWidgets('EmptyStateWidget renders title, message and responds to action button', (tester) async {
      bool actionTriggered = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: EmptyStateWidget(
              title: 'No Animals Found',
              message: 'Check your spelling or reset filters.',
              actionLabel: 'Reset Now',
              onAction: () {
                actionTriggered = true;
              },
            ),
          ),
        ),
      );

      expect(find.text('No Animals Found'), findsOneWidget);
      expect(find.text('Check your spelling or reset filters.'), findsOneWidget);
      expect(find.text('Reset Now'), findsOneWidget);

      await tester.tap(find.text('Reset Now'));
      await tester.pump();
      expect(actionTriggered, isTrue);
    });

    testWidgets('CategoryFilter renders all category chips', (tester) async {
      SharedPreferences.setMockInitialValues({});
      final storage = await LocalStorageService.init();

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            localStorageServiceProvider.overrideWithValue(storage),
          ],
          child: const MaterialApp(
            home: Scaffold(
              body: CategoryFilter(),
            ),
          ),
        ),
      );

      expect(find.text('All Categories'), findsOneWidget);
      expect(find.text('Mammals'), findsOneWidget);
      expect(find.text('Birds'), findsOneWidget);
    });

    testWidgets('SearchWidget allows input and reflects query state', (tester) async {
      SharedPreferences.setMockInitialValues({});
      final storage = await LocalStorageService.init();

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            localStorageServiceProvider.overrideWithValue(storage),
          ],
          child: const MaterialApp(
            home: Scaffold(
              body: SearchWidget(),
            ),
          ),
        ),
      );

      final textFieldFinder = find.byType(TextField);
      expect(textFieldFinder, findsOneWidget);

      await tester.enterText(textFieldFinder, 'Gorilla');
      await tester.pump();

      expect(find.text('Gorilla'), findsOneWidget);
      expect(find.byIcon(Icons.clear), findsOneWidget);

      // Tap clear button
      await tester.tap(find.byIcon(Icons.clear));
      await tester.pump();
      expect(find.text('Gorilla'), findsNothing);
    });
  });
}
