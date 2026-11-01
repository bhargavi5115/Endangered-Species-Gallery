import 'dart:async';
import 'dart:developer' as developer;
import '../data/authentic_species_dataset.dart';
import '../models/species_model.dart';
import '../core/constants/conservation_status.dart';
import '../services/gbif_service.dart';
import '../services/iucn_service.dart';

class SpeciesStatistics {
  final int totalCount;
  final Map<String, int> byCategory;
  final Map<ConservationStatus, int> byStatus;
  final int threatenedCount;

  const SpeciesStatistics({
    required this.totalCount,
    required this.byCategory,
    required this.byStatus,
    required this.threatenedCount,
  });

  double get threatenedPercentage => totalCount == 0 ? 0.0 : (threatenedCount / totalCount) * 100;
}

class SpeciesRepository {
  final GbifService _gbifService;
  final IucnService _iucnService;
  final List<SpeciesModel> _speciesCache = List.from(authenticSpeciesDataset);

  SpeciesRepository({
    GbifService? gbifService,
    IucnService? iucnService,
  })  : _gbifService = gbifService ?? GbifService(),
        _iucnService = iucnService ?? IucnService();

  IucnService get iucnService => _iucnService;

  /// Retrieves filtered and sorted species
  List<SpeciesModel> getSpecies({
    String? category,
    ConservationStatus? status,
    String? searchQuery,
    String? sortBy,
  }) {
    List<SpeciesModel> result = List.from(_speciesCache);

    // Category filter
    if (category != null && category.isNotEmpty && category != 'All Categories') {
      result = result.where((s) => s.category.toLowerCase() == category.toLowerCase()).toList();
    }

    // Status filter
    if (status != null) {
      result = result.where((s) => s.conservationStatus == status).toList();
    }

    // Search query (common name, scientific name, category, habitat)
    if (searchQuery != null && searchQuery.trim().isNotEmpty) {
      final q = searchQuery.trim().toLowerCase();
      result = result.where((s) {
        return s.commonName.toLowerCase().contains(q) ||
            s.scientificName.toLowerCase().contains(q) ||
            s.category.toLowerCase().contains(q) ||
            s.habitat.toLowerCase().contains(q);
      }).toList();
    }

    // Sorting
    if (sortBy != null) {
      switch (sortBy) {
        case 'Threat Level (Highest)':
          // Sort order: EX -> EW -> CR -> EN -> VU -> NT -> LC -> DD -> NE
          result.sort((a, b) => a.conservationStatus.index.compareTo(b.conservationStatus.index));
          break;
        case 'Alphabetical (A-Z)':
          result.sort((a, b) => a.commonName.compareTo(b.commonName));
          break;
        case 'Alphabetical (Z-A)':
          result.sort((a, b) => b.commonName.compareTo(a.commonName));
          break;
        case 'Recently Updated':
          result.sort((a, b) => b.assessmentDate.compareTo(a.assessmentDate));
          break;
      }
    }

    return result;
  }

  /// Get featured species for homepage hero / carousel
  List<SpeciesModel> getFeaturedSpecies() {
    return _speciesCache.where((s) => s.isFeatured).toList();
  }

  /// Find species by ID
  SpeciesModel? getSpeciesById(String id) {
    try {
      return _speciesCache.firstWhere((s) => s.speciesId == id);
    } catch (_) {
      return null;
    }
  }

  /// Enriches a species with real-time occurrence and taxonomy data from GBIF
  Future<SpeciesModel> enrichSpeciesWithLiveGbif(SpeciesModel species) async {
    try {
      final gbifTaxon = await _gbifService.matchSpecies(species.scientificName);
      if (gbifTaxon != null) {
        final occurrenceCount = await _gbifService.getOccurrenceCount(gbifTaxon.usageKey);

        final enriched = species.copyWith(
          gbifTaxonKey: gbifTaxon.usageKey,
          occurrenceCount: occurrenceCount ?? species.occurrenceCount,
          kingdom: gbifTaxon.kingdom ?? species.kingdom,
          phylum: gbifTaxon.phylum ?? species.phylum,
          classTaxon: gbifTaxon.classTaxon ?? species.classTaxon,
          order: gbifTaxon.order ?? species.order,
          family: gbifTaxon.family ?? species.family,
          genus: gbifTaxon.genus ?? species.genus,
        );

        // Update in-memory cache
        final idx = _speciesCache.indexWhere((s) => s.speciesId == species.speciesId);
        if (idx != -1) {
          _speciesCache[idx] = enriched;
        }

        return enriched;
      }
    } catch (e) {
      developer.log('Failed to enrich species ${species.commonName}: $e', name: 'SpeciesRepository');
    }
    return species;
  }

  /// Calculates statistics over current gallery dataset
  SpeciesStatistics getStatistics() {
    final Map<String, int> byCategory = {};
    final Map<ConservationStatus, int> byStatus = {};
    int threatenedCount = 0;

    for (final s in _speciesCache) {
      // Category count
      byCategory[s.category] = (byCategory[s.category] ?? 0) + 1;

      // Status count
      byStatus[s.conservationStatus] = (byStatus[s.conservationStatus] ?? 0) + 1;

      if (s.conservationStatus.isThreatened) {
        threatenedCount++;
      }
    }

    return SpeciesStatistics(
      totalCount: _speciesCache.length,
      byCategory: byCategory,
      byStatus: byStatus,
      threatenedCount: threatenedCount,
    );
  }
}
