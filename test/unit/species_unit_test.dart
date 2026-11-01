import 'package:flutter_test/flutter_test.dart';
import 'package:endangered_species_gallery/core/constants/conservation_status.dart';
import 'package:endangered_species_gallery/models/species_model.dart';
import 'package:endangered_species_gallery/repositories/species_repository.dart';

void main() {
  group('ConservationStatus parsing tests', () {
    test('Correctly parses official status codes', () {
      expect(ConservationStatus.fromString('CR'), ConservationStatus.cr);
      expect(ConservationStatus.fromString('EN'), ConservationStatus.en);
      expect(ConservationStatus.fromString('VU'), ConservationStatus.vu);
      expect(ConservationStatus.fromString('NT'), ConservationStatus.nt);
      expect(ConservationStatus.fromString('LC'), ConservationStatus.lc);
      expect(ConservationStatus.fromString('EW'), ConservationStatus.ew);
      expect(ConservationStatus.fromString('EX'), ConservationStatus.ex);
      expect(ConservationStatus.fromString('DD'), ConservationStatus.dd);
      expect(ConservationStatus.fromString('NE'), ConservationStatus.ne);
    });

    test('Correctly parses descriptive status strings', () {
      expect(ConservationStatus.fromString('Critically Endangered'), ConservationStatus.cr);
      expect(ConservationStatus.fromString('Endangered'), ConservationStatus.en);
      expect(ConservationStatus.fromString('Vulnerable'), ConservationStatus.vu);
      expect(ConservationStatus.fromString('Least Concern'), ConservationStatus.lc);
      expect(ConservationStatus.fromString('Unknown'), ConservationStatus.ne);
      expect(ConservationStatus.fromString(null), ConservationStatus.ne);
    });

    test('Identifies threatened species accurately', () {
      expect(ConservationStatus.cr.isThreatened, isTrue);
      expect(ConservationStatus.en.isThreatened, isTrue);
      expect(ConservationStatus.vu.isThreatened, isTrue);
      expect(ConservationStatus.lc.isThreatened, isFalse);
      expect(ConservationStatus.nt.isThreatened, isFalse);
    });
  });

  group('SpeciesModel serialization tests', () {
    test('Serializes to and from Map accurately without data loss', () {
      const species = SpeciesModel(
        speciesId: 'test-001',
        commonName: 'Bengal Tiger',
        scientificName: 'Panthera tigris tigris',
        category: 'Mammals',
        conservationStatus: ConservationStatus.en,
        imageUrl: 'https://example.com/tiger.jpg',
        imageAttribution: 'CC BY 2.0',
        habitat: 'Tropical rainforests and mangroves',
        geographicRange: 'India and Bangladesh',
        population: 'Estimated ~3,000 individuals',
        threats: ['Poaching', 'Habitat Loss'],
        conservationActions: ['Project Tiger reserves'],
        source: 'IUCN Red List',
        assessmentDate: '2023-01-01',
        lastUpdated: '2024',
        kingdom: 'Animalia',
        phylum: 'Chordata',
        classTaxon: 'Mammalia',
        order: 'Carnivora',
        family: 'Felidae',
        genus: 'Panthera',
        occurrenceCount: 520,
        isFeatured: true,
      );

      final map = species.toMap();
      expect(map['speciesId'], 'test-001');
      expect(map['commonName'], 'Bengal Tiger');
      expect(map['conservationStatus'], 'EN');
      expect(map['occurrenceCount'], 520);
      expect(map['isFeatured'], isTrue);

      final restored = SpeciesModel.fromMap(map);
      expect(restored.speciesId, species.speciesId);
      expect(restored.commonName, species.commonName);
      expect(restored.conservationStatus, ConservationStatus.en);
      expect(restored.threats.length, 2);
      expect(restored.occurrenceCount, 520);
    });
  });

  group('SpeciesRepository filtering and search tests', () {
    late SpeciesRepository repository;

    setUp(() {
      repository = SpeciesRepository();
    });

    test('Returns all cataloged species by default', () {
      final species = repository.getSpecies();
      expect(species.isNotEmpty, isTrue);
      expect(species.length, greaterThanOrEqualTo(15));
    });

    test('Filters by Category correctly', () {
      final mammals = repository.getSpecies(category: 'Mammals');
      expect(mammals.isNotEmpty, isTrue);
      for (final s in mammals) {
        expect(s.category, 'Mammals');
      }

      final birds = repository.getSpecies(category: 'Birds');
      expect(birds.isNotEmpty, isTrue);
      for (final s in birds) {
        expect(s.category, 'Birds');
      }
    });

    test('Filters by ConservationStatus accurately', () {
      final crSpecies = repository.getSpecies(status: ConservationStatus.cr);
      expect(crSpecies.isNotEmpty, isTrue);
      for (final s in crSpecies) {
        expect(s.conservationStatus, ConservationStatus.cr);
      }
    });

    test('Performs case-insensitive search by common and scientific names', () {
      final leopardSearch = repository.getSpecies(searchQuery: 'leopard');
      expect(leopardSearch.isNotEmpty, isTrue);
      expect(leopardSearch.any((s) => s.commonName.toLowerCase().contains('leopard')), isTrue);

      final scientificSearch = repository.getSpecies(searchQuery: 'panthera');
      expect(scientificSearch.isNotEmpty, isTrue);
      for (final s in scientificSearch) {
        expect(
          s.scientificName.toLowerCase().contains('panthera') || s.commonName.toLowerCase().contains('panthera'),
          isTrue,
        );
      }
    });

    test('Sorts correctly by Threat Level', () {
      final sorted = repository.getSpecies(sortBy: 'Threat Level (Highest)');
      expect(sorted.first.conservationStatus.index, lessThanOrEqualTo(sorted.last.conservationStatus.index));
    });

    test('Generates verified statistical calculations over dataset', () {
      final stats = repository.getStatistics();
      expect(stats.totalCount, greaterThan(0));
      expect(stats.byCategory.isNotEmpty, isTrue);
      expect(stats.byStatus.isNotEmpty, isTrue);
      expect(stats.threatenedCount, greaterThan(0));
      expect(stats.threatenedPercentage, greaterThan(0.0));
      expect(stats.threatenedPercentage, lessThanOrEqualTo(100.0));
    });
  });
}
