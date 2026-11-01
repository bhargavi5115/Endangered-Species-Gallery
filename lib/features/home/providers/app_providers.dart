import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/constants/conservation_status.dart';
import '../../../models/species_model.dart';
import '../../../models/user_model.dart';
import '../../../models/educational_content_model.dart';
import '../../../data/educational_dataset.dart';
import '../../../repositories/species_repository.dart';
import '../../../repositories/favorites_repository.dart';
import '../../../services/auth_service.dart';
import '../../../services/favorites_service.dart';
import '../../../services/gbif_service.dart';
import '../../../services/iucn_service.dart';
import '../../../services/local_storage_service.dart';

// --- SERVICE PROVIDERS ---
final localStorageServiceProvider = Provider<LocalStorageService>((ref) {
  throw UnimplementedError('localStorageServiceProvider must be initialized in main');
});

final gbifServiceProvider = Provider<GbifService>((ref) => GbifService());

final iucnServiceProvider = Provider<IucnService>((ref) => IucnService());

final speciesRepositoryProvider = Provider<SpeciesRepository>((ref) {
  final gbif = ref.watch(gbifServiceProvider);
  final iucn = ref.watch(iucnServiceProvider);
  return SpeciesRepository(gbifService: gbif, iucnService: iucn);
});

final favoritesServiceProvider = Provider<FavoritesService>((ref) {
  final storage = ref.watch(localStorageServiceProvider);
  return FavoritesService(storage);
});

final favoritesRepositoryProvider = Provider<FavoritesRepository>((ref) {
  final favService = ref.watch(favoritesServiceProvider);
  final speciesRepo = ref.watch(speciesRepositoryProvider);
  return FavoritesRepository(
    favoritesService: favService,
    speciesRepository: speciesRepo,
  );
});

final authServiceProvider = Provider<AuthService>((ref) {
  final storage = ref.watch(localStorageServiceProvider);
  return AuthService(storage);
});

// --- THEME PROVIDER ---
class ThemeModeNotifier extends StateNotifier<ThemeMode> {
  final LocalStorageService _storage;

  ThemeModeNotifier(this._storage) : super(_storage.getThemeMode());

  Future<void> setThemeMode(ThemeMode mode) async {
    state = mode;
    await _storage.saveThemeMode(mode);
  }

  void toggleTheme() {
    if (state == ThemeMode.dark) {
      setThemeMode(ThemeMode.light);
    } else {
      setThemeMode(ThemeMode.dark);
    }
  }
}

final themeModeProvider = StateNotifierProvider<ThemeModeNotifier, ThemeMode>((ref) {
  final storage = ref.watch(localStorageServiceProvider);
  return ThemeModeNotifier(storage);
});

// --- AUTH PROVIDER ---
class AuthNotifier extends StateNotifier<UserModel?> {
  final AuthService _authService;
  final FavoritesRepository _favRepo;

  AuthNotifier(this._authService, this._favRepo) : super(_authService.currentUser) {
    _authService.authStateChanges.listen((user) {
      state = user;
      if (user != null && !user.isGuest) {
        _favRepo.syncWithCloud(user.userId);
      }
    });
  }

  Future<void> signIn(String email, String password) async {
    final user = await _authService.signInWithEmailPassword(email, password);
    state = user;
  }

  Future<void> register(String name, String email, String password) async {
    final user = await _authService.registerWithEmailPassword(
      displayName: name,
      email: email,
      password: password,
    );
    state = user;
  }

  Future<void> continueAsGuest() async {
    final guest = await _authService.signInAsGuest();
    state = guest;
  }

  Future<void> sendPasswordReset(String email) async {
    await _authService.sendPasswordReset(email);
  }

  Future<void> signOut() async {
    await _authService.signOut();
    state = null;
  }
}

final authProvider = StateNotifierProvider<AuthNotifier, UserModel?>((ref) {
  final authService = ref.watch(authServiceProvider);
  final favRepo = ref.watch(favoritesRepositoryProvider);
  return AuthNotifier(authService, favRepo);
});

// --- FILTER & SEARCH PROVIDERS ---
final selectedCategoryProvider = StateProvider<String>((ref) => 'All Categories');
final selectedStatusProvider = StateProvider<ConservationStatus?>((ref) => null);
final searchQueryProvider = StateProvider<String>((ref) => '');
final sortOptionProvider = StateProvider<String>((ref) => 'Threat Level (Highest)');

// --- SPECIES DATA PROVIDERS ---
final speciesListProvider = Provider<List<SpeciesModel>>((ref) {
  final repo = ref.watch(speciesRepositoryProvider);
  final category = ref.watch(selectedCategoryProvider);
  final status = ref.watch(selectedStatusProvider);
  final query = ref.watch(searchQueryProvider);
  final sort = ref.watch(sortOptionProvider);

  return repo.getSpecies(
    category: category,
    status: status,
    searchQuery: query,
    sortBy: sort,
  );
});

final featuredSpeciesProvider = Provider<List<SpeciesModel>>((ref) {
  final repo = ref.watch(speciesRepositoryProvider);
  return repo.getFeaturedSpecies();
});

// --- FAVORITES NOTIFIER ---
class FavoritesNotifier extends StateNotifier<Set<String>> {
  final FavoritesRepository _repository;
  final Ref _ref;

  FavoritesNotifier(this._repository, this._ref)
      : super(_repository.getFavoriteSpecies().map((s) => s.speciesId).toSet());

  Future<bool> toggle(String speciesId) async {
    final user = _ref.read(authProvider);
    final isFav = await _repository.toggleFavorite(speciesId, user);
    if (isFav) {
      state = {...state, speciesId};
    } else {
      final updated = Set<String>.from(state)..remove(speciesId);
      state = updated;
    }
    return isFav;
  }

  void refresh() {
    state = _repository.getFavoriteSpecies().map((s) => s.speciesId).toSet();
  }
}

final favoritesProvider = StateNotifierProvider<FavoritesNotifier, Set<String>>((ref) {
  final repo = ref.watch(favoritesRepositoryProvider);
  return FavoritesNotifier(repo, ref);
});

final favoriteSpeciesListProvider = Provider<List<SpeciesModel>>((ref) {
  final favoriteIds = ref.watch(favoritesProvider);
  final repo = ref.watch(speciesRepositoryProvider);
  return favoriteIds
      .map((id) => repo.getSpeciesById(id))
      .whereType<SpeciesModel>()
      .toList();
});

// --- DASHBOARD STATISTICS PROVIDER ---
final dashboardStatisticsProvider = Provider<SpeciesStatistics>((ref) {
  final repo = ref.watch(speciesRepositoryProvider);
  // Re-evaluates when species dataset is viewed
  return repo.getStatistics();
});

// --- EDUCATIONAL CONTENT PROVIDER ---
final educationalArticlesProvider = Provider<List<EducationalContentModel>>((ref) {
  return educationalArticlesDataset;
});

// --- SPECIES DETAILS (WITH LIVE GBIF ENRICHMENT) ---
final speciesDetailFutureProvider = FutureProvider.family<SpeciesModel, String>((ref, speciesId) async {
  final repo = ref.watch(speciesRepositoryProvider);
  final species = repo.getSpeciesById(speciesId);
  if (species == null) {
    throw Exception('Species with ID $speciesId was not found.');
  }
  // Enriches with live GBIF occurrence counts & taxonomy
  return await repo.enrichSpeciesWithLiveGbif(species);
});
