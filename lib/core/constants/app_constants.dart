class AppConstants {
  static const String appName = 'Endangered Species Gallery';
  static const String appTagline = 'Wildlife Conservation & Biodiversity Platform';
  static const String appVersion = '1.0.0';

  // Categories
  static const List<String> categories = [
    'All Categories',
    'Mammals',
    'Birds',
    'Reptiles',
    'Amphibians',
    'Marine Animals',
    'Insects',
  ];

  // Primary categories without "All"
  static const List<String> primaryCategories = [
    'Mammals',
    'Birds',
    'Reptiles',
    'Amphibians',
    'Marine Animals',
    'Insects',
  ];

  // Sort Options
  static const List<String> sortOptions = [
    'Threat Level (Highest)',
    'Alphabetical (A-Z)',
    'Alphabetical (Z-A)',
    'Recently Updated',
  ];

  // API Endpoints
  static const String gbifBaseUrl = 'https://api.gbif.org/v1';
  static const String iucnBaseUrl = 'https://apiv3.iucnredlist.org/api/v3';
  static const String wikimediaCommonsBaseUrl = 'https://commons.wikimedia.org/w/api.php';

  // Local Storage Keys
  static const String prefsFavoritesKey = 'user_favorite_species_ids';
  static const String prefsThemeKey = 'user_preferred_theme_mode';
  static const String prefsGuestUserKey = 'guest_user_session';
  static const String prefsLastSyncKey = 'last_cloud_sync_timestamp';

  // Responsive Breakpoints
  static const double mobileMaxWidth = 600;
  static const double tabletMaxWidth = 1024;

  // Timeout durations
  static const Duration apiTimeout = Duration(seconds: 12);
}
