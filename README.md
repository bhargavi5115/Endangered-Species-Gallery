# 🌿 Endangered Species Gallery
### *A Real-World Wildlife Conservation and Biodiversity Information Platform*

[![Flutter](https://img.shields.io/badge/Flutter-3.47.7-02569B?logo=flutter)](https://flutter.dev)
[![Dart](https://img.shields.io/badge/Dart-3.13.5-0175C2?logo=dart)](https://dart.dev)
[![State Management](https://img.shields.io/badge/State%20Management-Riverpod%202.6-purple)](https://riverpod.dev)
[![Backend](https://img.shields.io/badge/Backend-Firebase%20Auth%20%7C%20Firestore-orange?logo=firebase)](https://firebase.google.com)
[![APIs](https://img.shields.io/badge/External%20APIs-GBIF%20%7C%20IUCN%20%7C%20Wikimedia-green)](https://www.gbif.org)
[![Tests](https://img.shields.io/badge/Tests-15%2F15%20Passing-brightgreen)](#testing-strategy)
[![Builds](https://img.shields.io/badge/Builds-APK%20%7C%20AAB%20%7C%20Web-success)](#production-build-artifacts)

---

## 📖 1. Project Vision & Architecture

**Endangered Species Gallery** is an interactive, full-stack biodiversity education and wildlife awareness platform built with **Flutter 3.47** and **Dart 3.13**. It bridges the gap between scientific taxonomies and accessible public conservation education. 

Rather than presenting static mockups or invented data, this platform combines:
- **Verified Biodiversity Datasets:** Accurate taxonomy, IUCN Red List threat classifications, habitat boundaries, and verified population estimates.
- **Real-Time GBIF API Integration:** Live taxonomic validation and occurrence observation counts via the Global Biodiversity Information Facility.
- **Official IUCN Red List Framework:** Full coverage of all 9 IUCN assessment statuses (EX, EW, CR, EN, VU, NT, LC, DD, NE).
- **Legally Licensed Wildlife Photography:** High-resolution Wikimedia Commons and public-domain imagery with explicit copyright attribution.
- **Firebase Authentication & Cloud Firestore:** Multi-tier synchronization for both authenticated users and offline guest explorers.

---

## 🎨 2. Design System & Nature Visual Identity

The interface is built around a nature-inspired palette complying with WCAG AAA accessibility standards:

| Color Role | Hex Code | Purpose |
|---|---|---|
| **Primary Forest Green** | `#1B4332` | Primary brand tone, app bars, key interactive actions |
| **Deep Green** | `#081C15` | Hero sections, strong headings, dark accents |
| **Emerald Green** | `#2D6A4F` | Secondary badges, progress indicators, highlights |
| **Sage Green** | `#52B788` | Icons, accents, search indicators |
| **Light Green** | `#D8F3DC` | Active chips, background highlights, badges |
| **Background Light** | `#F8FAF7` | Clean nature canvas |
| **Background Dark** | `#0D1B14` | Deep night-mode conservation theme |
| **IUCN Status Colors** | *Official Palette* | EX (`#1A1A1A`), EW (`#4A2810`), CR (`#D90429`), EN (`#E85D04`), VU (`#F48C06`), NT (`#0077B6`), LC (`#2D6A4F`), DD (`#6C757D`), NE (`#9E9E9E`) |

---

## 📱 3. Screen-by-Screen Tour

The application provides a seamless 9-screen flow:

1. **Splash Screen (`SplashScreen`):**
   - Animated nature icon, glowing pulse effect, preloading of persistent preferences and cached data.
2. **Home Screen (`HomeScreen`):**
   - Wildlife hero banner with greeting and mission statement.
   - Live search bar with instant autocomplete.
   - Priority Spotlight Endangered Species horizontal carousel.
   - Conservation awareness banner (global extinction crisis facts).
   - Category filter chips (Mammals, Birds, Reptiles, Amphibians, Marine Animals, Insects).
   - IUCN Red List status selector bar.
   - Responsive `GridView.builder` with species count indicator.
3. **Explore Screen (`ExploreScreen`):**
   - Advanced multi-criteria search and discovery.
   - Dynamic sorting: Threat Level (Highest first), Alphabetical (A-Z, Z-A), Recently Assessed.
   - Clear filter shortcuts and empty-state recovery.
4. **Species Details Screen (`SpeciesDetailsScreen`):**
   - Parallax SliverAppBar with hero wildlife photography.
   - Attribution badge detailing photographer and Creative Commons license.
   - Full IUCN Assessment alert banner with official criteria description.
   - Real-time GBIF Occurrence count badge (museum and field records indexed).
   - Comprehensive taxonomy classification table (Kingdom, Phylum, Class, Order, Family, Genus, Species).
   - Natural habitat and geographic distribution cards.
   - Verified population statistics (never fabricated or confused with occurrence records).
   - Major survival threats list with risk icons.
   - Conservation initiatives and active recovery programs.
   - Interesting biological facts.
   - Clickable scientific reference links (GBIF, IUCN Red List).
   - Native sharing functionality (`share_plus`) and favorite bookmarking.
5. **Favorites Screen (`FavoritesScreen`):**
   - Bookmarked species collection with badge counter.
   - Offline-to-Cloud sync status pill:
     - *Guest Mode:* Saved locally in `SharedPreferences`.
     - *Member Mode:* Synced to Firebase Firestore (`users/{userId}/favorites/{speciesId}`).
   - Empty state with direct route to exploration.
6. **Learn Screen (`LearnScreen`):**
   - Expandable conservation masterclasses:
     - *Biodiversity & The Web of Life*
     - *Demystifying the IUCN Red List Criteria*
     - *Combating the Illegal Wildlife Trade & CITES*
     - *Climate Change & Marine Life Resilience*
   - Bulleted scientific takeaways and actionable citizen-conservation steps.
7. **Conservation Dashboard (`DashboardScreen`):**
   - Interactive FlChart pie chart showing distribution across IUCN risk categories.
   - Taxonomic representation progress bars.
   - Metric overview cards (Total Cataloged, Threatened Taxa, High-Risk Share).
   - **Data Accuracy Transparency Note:** Clear disclaimer distinguishing gallery catalog records from global population estimates.
8. **Authentication Screens (`LoginScreen`, `RegisterScreen`, `ForgotPasswordScreen`):**
   - Email/password validation and login.
   - User account registration with display name.
   - Password reset workflow.
   - "Continue as Guest" instant bypass for frictionless access.
9. **Profile Screen (`ProfileScreen`):**
   - User profile status (Verified Conservationist vs Guest Explorer).
   - Appearance mode selector (System Default, Light Mode, Dark Mode).
   - Data Accuracy and Integrity Charter dialog.
   - About app dialog and secure sign-out.

---

## 🌐 4. Real-Time API Integration

### 4.1 GBIF API (Global Biodiversity Information Facility)
- **Base URL:** `https://api.gbif.org/v1`
- **Species Match:** `/species/match?name={scientificName}` (Backbone Taxonomy match)
- **Occurrences Count:** `/occurrence/search?taxonKey={key}&limit=0`
- **Auto-Suggestions:** `/species/suggest?q={query}&limit=6`
- **Resilience:** Handled with a 12-second timeout and graceful fallback to offline cataloged values.

### 4.2 IUCN Red List API v3
- **Base URL:** `https://apiv3.iucnredlist.org/api/v3`
- Supports authorized API token ingestion without hardcoding credentials in client code.
- Fully compatible with the IUCN API terms of service.
- Provides built-in criteria explanations for all categories (EX, EW, CR, EN, VU, NT, LC, DD, NE).

### 4.3 Wikimedia Commons Wildlife Media
- High-resolution, legally licensed photography from Wikimedia Commons.
- Cached on device memory and disk using `cached_network_image`.
- Complete with author attributions and Creative Commons / Public Domain credits.

---

## 🔥 5. Firebase Architecture & Security

### 5.1 Collections Schema
```
users/
  {userId}/
    displayName: String
    email: String
    createdAt: Timestamp
    profileImage: String (optional)
    
    favorites/
      {speciesId}/
        speciesId: String
        userId: String
        addedAt: Timestamp

species/
  {speciesId}/
    commonName: String
    scientificName: String
    category: String
    conservationStatus: String
    imageUrl: String
    imageAttribution: String
    habitat: String
    geographicRange: String
    population: String
    threats: Array<String>
    conservationActions: Array<String>
    source: String
    assessmentDate: String

educational_content/
  {contentId}/
    title: String
    description: String
    category: String
    source: String
    lastUpdated: String
```

### 5.2 Firestore Security Rules (`firestore.rules`)
```javascript
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    match /users/{userId} {
      allow read, write: if request.auth != null && request.auth.uid == userId;
      match /favorites/{speciesId} {
        allow read, write, delete: if request.auth != null && request.auth.uid == userId;
      }
    }
    match /species/{speciesId} {
      allow read: if true;
      allow write: if request.auth != null && request.auth.token.admin == true;
    }
    match /educational_content/{contentId} {
      allow read: if true;
      allow write: if request.auth != null && request.auth.token.admin == true;
    }
  }
}
```

---

## 🧪 6. Testing Strategy & Validation

Run all automated tests using:
```bash
flutter test
```

### Test Results
```
00:00 +0: loading C:/Users/somaraju/OneDrive/Desktop/flut pro/test/integration/app_integration_test.dart
00:00 +1: ConservationStatus parsing tests - Correctly parses official status codes
00:00 +2: ConservationStatus parsing tests - Correctly parses descriptive status strings
00:00 +3: ConservationStatus parsing tests - Identifies threatened species accurately
00:00 +4: SpeciesModel serialization tests - Serializes to and from Map accurately without data loss
00:00 +5: SpeciesRepository - Returns all cataloged species by default
00:00 +6: SpeciesRepository - Filters by Category correctly
00:00 +7: SpeciesRepository - Filters by ConservationStatus accurately
00:00 +8: SpeciesRepository - Performs case-insensitive search by common and scientific names
00:00 +9: SpeciesRepository - Sorts correctly by Threat Level
00:00 +10: SpeciesRepository - Generates verified statistical calculations over dataset
00:07 +11: Full User Workflow - Home, Explore, Learn, Dashboard navigation
00:07 +12: StatusBadge renders code and full name correctly
00:07 +13: EmptyStateWidget renders title, message and responds to action button
00:07 +14: CategoryFilter renders all category chips
00:08 +15: SearchWidget allows input and reflects query state
00:09 +15: All tests passed!
```

Static Code Analysis:
```bash
flutter analyze
# Output: No issues found! (Exit code: 0)
```

---

## 📦 7. Production Build Artifacts

All production releases have been compiled and verified:

1. **Flutter Web Production Build:**
   - **Path:** `build/web/`
   - Ready for immediate deployment to Firebase Hosting, Cloudflare Pages, or Netlify.
2. **Android Release APK:**
   - **Path:** `build/app/outputs/flutter-apk/app-release.apk`
   - **Size:** 55.5 MB
   - Ready for sideloading and Android device testing.
3. **Android Release App Bundle (AAB):**
   - **Path:** `build/app/outputs/bundle/release/app-release.aab`
   - **Size:** 55.3 MB
   - Optimized for Google Play Store publishing.

---

## 🚀 8. Build & Deployment Instructions

### 8.1 Running Locally
```bash
# 1. Install dependencies
flutter pub get

# 2. Run analysis
flutter analyze

# 3. Execute test suite
flutter test

# 4. Launch on Web / Desktop / Device
flutter run -d chrome
# or
flutter run -d windows
```

### 8.2 Building for Android
```bash
# Build universal Release APK
flutter build apk --release

# Build Google Play App Bundle
flutter build appbundle --release
```

### 8.3 Deploying to Firebase Hosting
```bash
# 1. Build the web release
flutter build web --release

# 2. Log in to Firebase CLI
firebase login

# 3. Deploy hosting & firestore rules
firebase deploy --only hosting,firestore:rules
```

---

## 📋 9. Verification & Compliance Checklist

- [x] Responsive layout with `GridView.builder` adaptive columns (Mobile: 2, Tablet: 3, Desktop: 4+).
- [x] Riverpod state management for species, filters, search, favorites, auth, and theme.
- [x] Real GBIF API integration for taxon match and occurrence counts.
- [x] Complete IUCN Red List status support (EX, EW, CR, EN, VU, NT, LC, DD, NE).
- [x] High-resolution Wikimedia Commons images with verified attributions.
- [x] Zero fabricated population figures; transparent data disclaimers.
- [x] Offline mode with local persistence for guest explorers.
- [x] Firebase Authentication and Cloud Firestore synchronization for logged-in users.
- [x] Interactive FlChart conservation dashboard.
- [x] Native share feature and external reference link launching.
- [x] 15/15 unit, widget, and integration tests passing.
- [x] Android APK, Android AAB, and Web release builds compiled successfully.
