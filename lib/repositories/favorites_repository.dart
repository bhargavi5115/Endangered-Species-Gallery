import '../models/species_model.dart';
import '../models/user_model.dart';
import '../services/favorites_service.dart';
import 'species_repository.dart';

class FavoritesRepository {
  final FavoritesService favoritesService;
  final SpeciesRepository speciesRepository;

  FavoritesRepository({
    required this.favoritesService,
    required this.speciesRepository,
  });

  /// Retrieves list of SpeciesModel that are currently favorited
  List<SpeciesModel> getFavoriteSpecies() {
    final ids = favoritesService.getLocalFavorites();
    final List<SpeciesModel> favorites = [];
    for (final id in ids) {
      final species = speciesRepository.getSpeciesById(id);
      if (species != null) {
        favorites.add(species);
      }
    }
    return favorites;
  }

  /// Check if an ID is favorited
  bool isFavorite(String speciesId) {
    return favoritesService.getLocalFavorites().contains(speciesId);
  }

  /// Toggle favorite status
  Future<bool> toggleFavorite(String speciesId, UserModel? user) async {
    return favoritesService.toggleFavorite(
      speciesId: speciesId,
      userId: user?.userId,
      isGuest: user?.isGuest ?? true,
    );
  }

  /// Sync with cloud when user logs in
  Future<void> syncWithCloud(String userId) async {
    await favoritesService.syncUserFavorites(userId);
  }
}
