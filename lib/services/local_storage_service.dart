import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../core/constants/app_constants.dart';

class LocalStorageService {
  final SharedPreferences _prefs;

  LocalStorageService(this._prefs);

  static Future<LocalStorageService> init() async {
    final prefs = await SharedPreferences.getInstance();
    return LocalStorageService(prefs);
  }

  // Favorites
  Set<String> getFavoriteSpeciesIds() {
    final list = _prefs.getStringList(AppConstants.prefsFavoritesKey) ?? [];
    return list.toSet();
  }

  Future<bool> saveFavoriteSpeciesIds(Set<String> ids) async {
    return _prefs.setStringList(AppConstants.prefsFavoritesKey, ids.toList());
  }

  Future<bool> addFavorite(String speciesId) async {
    final current = getFavoriteSpeciesIds();
    current.add(speciesId);
    return saveFavoriteSpeciesIds(current);
  }

  Future<bool> removeFavorite(String speciesId) async {
    final current = getFavoriteSpeciesIds();
    current.remove(speciesId);
    return saveFavoriteSpeciesIds(current);
  }

  bool isFavorite(String speciesId) {
    final current = getFavoriteSpeciesIds();
    return current.contains(speciesId);
  }

  // Theme Mode
  ThemeMode getThemeMode() {
    final modeString = _prefs.getString(AppConstants.prefsThemeKey);
    switch (modeString) {
      case 'dark':
        return ThemeMode.dark;
      case 'light':
        return ThemeMode.light;
      default:
        return ThemeMode.system;
    }
  }

  Future<bool> saveThemeMode(ThemeMode mode) async {
    String value = 'system';
    if (mode == ThemeMode.dark) value = 'dark';
    if (mode == ThemeMode.light) value = 'light';
    return _prefs.setString(AppConstants.prefsThemeKey, value);
  }

  // Guest session status
  bool isGuestUser() {
    return _prefs.getBool(AppConstants.prefsGuestUserKey) ?? true;
  }

  Future<bool> setGuestUser(bool isGuest) async {
    return _prefs.setBool(AppConstants.prefsGuestUserKey, isGuest);
  }

  // Clear all data
  Future<void> clear() async {
    await _prefs.clear();
  }
}
