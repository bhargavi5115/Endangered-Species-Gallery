import 'dart:developer' as developer;
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/favorite_model.dart';
import 'firebase_service.dart';
import 'local_storage_service.dart';

class FavoritesService {
  final LocalStorageService _storage;

  FavoritesService(this._storage);

  /// Retrieves current set of favorite species IDs (local + cloud synced)
  Set<String> getLocalFavorites() {
    return _storage.getFavoriteSpeciesIds();
  }

  /// Toggles favorite status locally and syncs to Firestore if user is authenticated
  Future<bool> toggleFavorite({
    required String speciesId,
    required String? userId,
    required bool isGuest,
  }) async {
    final current = _storage.getFavoriteSpeciesIds();
    final bool willBeFavorite = !current.contains(speciesId);

    if (willBeFavorite) {
      current.add(speciesId);
      await _storage.saveFavoriteSpeciesIds(current);
      if (!isGuest && userId != null && FirebaseService.isInitialized) {
        await _addFirestoreFavorite(userId, speciesId);
      }
    } else {
      current.remove(speciesId);
      await _storage.saveFavoriteSpeciesIds(current);
      if (!isGuest && userId != null && FirebaseService.isInitialized) {
        await _removeFirestoreFavorite(userId, speciesId);
      }
    }

    return willBeFavorite;
  }

  /// Syncs Firestore favorites with local storage upon user login
  Future<Set<String>> syncUserFavorites(String userId) async {
    final localSet = _storage.getFavoriteSpeciesIds();

    if (!FirebaseService.isInitialized) {
      return localSet;
    }

    try {
      final collection = FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .collection('favorites');

      final snapshot = await collection.get();
      final cloudIds = snapshot.docs.map((d) => d.id).toSet();

      // Merge local and cloud sets to prevent data loss
      final merged = {...localSet, ...cloudIds};
      await _storage.saveFavoriteSpeciesIds(merged);

      // Upload missing items to cloud
      for (final id in merged) {
        if (!cloudIds.contains(id)) {
          await collection.doc(id).set(FavoriteModel(
            speciesId: id,
            userId: userId,
            addedAt: DateTime.now(),
          ).toMap());
        }
      }

      return merged;
    } catch (e) {
      developer.log('Cloud favorites sync warning: $e', name: 'FavoritesService');
      return localSet;
    }
  }

  Future<void> _addFirestoreFavorite(String userId, String speciesId) async {
    try {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .collection('favorites')
          .doc(speciesId)
          .set(FavoriteModel(
            speciesId: speciesId,
            userId: userId,
            addedAt: DateTime.now(),
          ).toMap());
    } catch (e) {
      developer.log('Failed to save favorite in Firestore: $e', name: 'FavoritesService');
    }
  }

  Future<void> _removeFirestoreFavorite(String userId, String speciesId) async {
    try {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .collection('favorites')
          .doc(speciesId)
          .delete();
    } catch (e) {
      developer.log('Failed to remove favorite in Firestore: $e', name: 'FavoritesService');
    }
  }
}
