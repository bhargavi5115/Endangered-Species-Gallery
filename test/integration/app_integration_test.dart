import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:endangered_species_gallery/core/theme/app_theme.dart';
import 'package:endangered_species_gallery/features/home/screens/main_shell_screen.dart';
import 'package:endangered_species_gallery/services/local_storage_service.dart';
import 'package:endangered_species_gallery/features/home/providers/app_providers.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('Full User Workflow: Home, Explore, Learn, Dashboard navigation', (tester) async {
    // Setup mock preferences
    SharedPreferences.setMockInitialValues({});
    final storage = await LocalStorageService.init();

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          localStorageServiceProvider.overrideWithValue(storage),
        ],
        child: MaterialApp(
          theme: AppTheme.lightTheme,
          home: const MainShellScreen(),
        ),
      ),
    );

    await tester.pump();
    await tester.pump(const Duration(milliseconds: 300));

    // Verify Home Screen elements
    expect(find.text('Species Gallery'), findsOneWidget);
    expect(find.text('Animal Categories'), findsOneWidget);

    // Navigate to Explore
    await tester.tap(find.text('Explore'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 300));

    expect(find.text('Explore Biodiversity'), findsOneWidget);

    // Navigate to Saved Favorites
    await tester.tap(find.text('Saved'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 300));

    expect(find.text('My Saved Species'), findsOneWidget);

    // Navigate to Learn
    await tester.tap(find.text('Learn'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 300));

    expect(find.text('Conservation Knowledge'), findsOneWidget);

    // Navigate to Dashboard
    await tester.tap(find.text('Dashboard'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 300));

    expect(find.text('Conservation Dashboard'), findsOneWidget);
    expect(find.text('Total Cataloged'), findsOneWidget);

    // Navigate to Profile
    await tester.tap(find.text('Profile'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 300));

    expect(find.text('Account & Preferences'), findsOneWidget);
    expect(find.text('Appearance & Display'), findsOneWidget);
  });
}
