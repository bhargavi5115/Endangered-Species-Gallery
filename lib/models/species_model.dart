import '../core/constants/conservation_status.dart';

class SpeciesModel {
  final String speciesId;
  final String commonName;
  final String scientificName;
  final String category;
  final ConservationStatus conservationStatus;
  final String imageUrl;
  final String imageAttribution;
  final String habitat;
  final String geographicRange;
  final String population;
  final List<String> threats;
  final List<String> conservationActions;
  final String source;
  final String assessmentDate;
  final String lastUpdated;

  // Taxonomy
  final String kingdom;
  final String phylum;
  final String classTaxon;
  final String order;
  final String family;
  final String genus;

  // Additional educational details
  final String diet;
  final String physicalCharacteristics;
  final List<String> interestingFacts;
  final Map<String, String> referenceLinks;
  final int? gbifTaxonKey;
  final int? occurrenceCount;
  final bool isFeatured;

  const SpeciesModel({
    required this.speciesId,
    required this.commonName,
    required this.scientificName,
    required this.category,
    required this.conservationStatus,
    required this.imageUrl,
    required this.imageAttribution,
    required this.habitat,
    required this.geographicRange,
    required this.population,
    required this.threats,
    required this.conservationActions,
    required this.source,
    required this.assessmentDate,
    required this.lastUpdated,
    this.kingdom = 'Animalia',
    this.phylum = 'Chordata',
    this.classTaxon = '',
    this.order = '',
    this.family = '',
    this.genus = '',
    this.diet = 'Information under field review',
    this.physicalCharacteristics = 'Information under field review',
    this.interestingFacts = const [],
    this.referenceLinks = const {},
    this.gbifTaxonKey,
    this.occurrenceCount,
    this.isFeatured = false,
  });

  SpeciesModel copyWith({
    String? speciesId,
    String? commonName,
    String? scientificName,
    String? category,
    ConservationStatus? conservationStatus,
    String? imageUrl,
    String? imageAttribution,
    String? habitat,
    String? geographicRange,
    String? population,
    List<String>? threats,
    List<String>? conservationActions,
    String? source,
    String? assessmentDate,
    String? lastUpdated,
    String? kingdom,
    String? phylum,
    String? classTaxon,
    String? order,
    String? family,
    String? genus,
    String? diet,
    String? physicalCharacteristics,
    List<String>? interestingFacts,
    Map<String, String>? referenceLinks,
    int? gbifTaxonKey,
    int? occurrenceCount,
    bool? isFeatured,
  }) {
    return SpeciesModel(
      speciesId: speciesId ?? this.speciesId,
      commonName: commonName ?? this.commonName,
      scientificName: scientificName ?? this.scientificName,
      category: category ?? this.category,
      conservationStatus: conservationStatus ?? this.conservationStatus,
      imageUrl: imageUrl ?? this.imageUrl,
      imageAttribution: imageAttribution ?? this.imageAttribution,
      habitat: habitat ?? this.habitat,
      geographicRange: geographicRange ?? this.geographicRange,
      population: population ?? this.population,
      threats: threats ?? this.threats,
      conservationActions: conservationActions ?? this.conservationActions,
      source: source ?? this.source,
      assessmentDate: assessmentDate ?? this.assessmentDate,
      lastUpdated: lastUpdated ?? this.lastUpdated,
      kingdom: kingdom ?? this.kingdom,
      phylum: phylum ?? this.phylum,
      classTaxon: classTaxon ?? this.classTaxon,
      order: order ?? this.order,
      family: family ?? this.family,
      genus: genus ?? this.genus,
      diet: diet ?? this.diet,
      physicalCharacteristics: physicalCharacteristics ?? this.physicalCharacteristics,
      interestingFacts: interestingFacts ?? this.interestingFacts,
      referenceLinks: referenceLinks ?? this.referenceLinks,
      gbifTaxonKey: gbifTaxonKey ?? this.gbifTaxonKey,
      occurrenceCount: occurrenceCount ?? this.occurrenceCount,
      isFeatured: isFeatured ?? this.isFeatured,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'speciesId': speciesId,
      'commonName': commonName,
      'scientificName': scientificName,
      'category': category,
      'conservationStatus': conservationStatus.code,
      'imageUrl': imageUrl,
      'imageAttribution': imageAttribution,
      'habitat': habitat,
      'geographicRange': geographicRange,
      'population': population,
      'threats': threats,
      'conservationActions': conservationActions,
      'source': source,
      'assessmentDate': assessmentDate,
      'lastUpdated': lastUpdated,
      'kingdom': kingdom,
      'phylum': phylum,
      'classTaxon': classTaxon,
      'order': order,
      'family': family,
      'genus': genus,
      'diet': diet,
      'physicalCharacteristics': physicalCharacteristics,
      'interestingFacts': interestingFacts,
      'referenceLinks': referenceLinks,
      'gbifTaxonKey': gbifTaxonKey,
      'occurrenceCount': occurrenceCount,
      'isFeatured': isFeatured,
    };
  }

  factory SpeciesModel.fromMap(Map<String, dynamic> map) {
    return SpeciesModel(
      speciesId: map['speciesId']?.toString() ?? '',
      commonName: map['commonName']?.toString() ?? 'Unknown Species',
      scientificName: map['scientificName']?.toString() ?? 'N/A',
      category: map['category']?.toString() ?? 'Mammals',
      conservationStatus: ConservationStatus.fromString(map['conservationStatus']?.toString()),
      imageUrl: map['imageUrl']?.toString() ?? '',
      imageAttribution: map['imageAttribution']?.toString() ?? 'Licensed under CC / Public Domain',
      habitat: map['habitat']?.toString() ?? 'Habitat data pending',
      geographicRange: map['geographicRange']?.toString() ?? 'Geographic range pending',
      population: map['population']?.toString() ?? 'Verified population figure pending scientific consensus',
      threats: map['threats'] != null ? List<String>.from(map['threats']) : [],
      conservationActions: map['conservationActions'] != null ? List<String>.from(map['conservationActions']) : [],
      source: map['source']?.toString() ?? 'IUCN Red List / GBIF',
      assessmentDate: map['assessmentDate']?.toString() ?? 'Recent Assessment',
      lastUpdated: map['lastUpdated']?.toString() ?? '2024-2026',
      kingdom: map['kingdom']?.toString() ?? 'Animalia',
      phylum: map['phylum']?.toString() ?? 'Chordata',
      classTaxon: map['classTaxon']?.toString() ?? '',
      order: map['order']?.toString() ?? '',
      family: map['family']?.toString() ?? '',
      genus: map['genus']?.toString() ?? '',
      diet: map['diet']?.toString() ?? 'Specific dietary profile under field review',
      physicalCharacteristics: map['physicalCharacteristics']?.toString() ?? 'Biometric traits documented in field studies',
      interestingFacts: map['interestingFacts'] != null ? List<String>.from(map['interestingFacts']) : [],
      referenceLinks: map['referenceLinks'] != null ? Map<String, String>.from(map['referenceLinks']) : {},
      gbifTaxonKey: map['gbifTaxonKey'] as int?,
      occurrenceCount: map['occurrenceCount'] as int?,
      isFeatured: map['isFeatured'] == true,
    );
  }
}
