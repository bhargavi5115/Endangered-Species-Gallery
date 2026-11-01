import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'app.dart';
import 'features/home/providers/app_providers.dart';
import 'services/firebase_service.dart';
import 'services/local_storage_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Local Storage Service (SharedPreferences)
  final storageService = await LocalStorageService.init();

  // Initialize Firebase (safely with fallback for unconfigured environments)
  await FirebaseService.initialize();

  runApp(
    ProviderScope(
      overrides: [
        localStorageServiceProvider.overrideWithValue(storageService),
      ],
      child: const EndangeredSpeciesApp(),
    ),
  );
}
