import 'dart:convert';
import 'dart:developer' as developer;
import 'package:http/http.dart' as http;
import '../core/constants/app_constants.dart';

class GbifTaxonInfo {
  final int usageKey;
  final String scientificName;
  final String? canonicalName;
  final String? kingdom;
  final String? phylum;
  final String? classTaxon;
  final String? order;
  final String? family;
  final String? genus;
  final String? rank;
  final String? status;
  final int? confidence;

  const GbifTaxonInfo({
    required this.usageKey,
    required this.scientificName,
    this.canonicalName,
    this.kingdom,
    this.phylum,
    this.classTaxon,
    this.order,
    this.family,
    this.genus,
    this.rank,
    this.status,
    this.confidence,
  });

  factory GbifTaxonInfo.fromJson(Map<String, dynamic> json) {
    return GbifTaxonInfo(
      usageKey: json['usageKey'] ?? json['key'] ?? 0,
      scientificName: json['scientificName'] ?? '',
      canonicalName: json['canonicalName'],
      kingdom: json['kingdom'],
      phylum: json['phylum'],
      classTaxon: json['class'],
      order: json['order'],
      family: json['family'],
      genus: json['genus'],
      rank: json['rank'],
      status: json['status'],
      confidence: json['confidence'],
    );
  }
}

class GbifService {
  final http.Client _client;

  GbifService({http.Client? client}) : _client = client ?? http.Client();

  /// Matches a species scientific name against GBIF Backbone Taxonomy
  Future<GbifTaxonInfo?> matchSpecies(String scientificName) async {
    try {
      final uri = Uri.parse('${AppConstants.gbifBaseUrl}/species/match').replace(
        queryParameters: {'name': scientificName, 'verbose': 'false'},
      );

      final response = await _client.get(uri).timeout(AppConstants.apiTimeout);

      if (response.statusCode == 200) {
        final data = json.decode(response.body) as Map<String, dynamic>;
        if (data['matchType'] != 'NONE' && (data['usageKey'] != null || data['key'] != null)) {
          return GbifTaxonInfo.fromJson(data);
        }
      }
      return null;
    } catch (e) {
      developer.log('GBIF matchSpecies error for $scientificName: $e', name: 'GbifService');
      return null;
    }
  }

  /// Fetches real-time occurrence record count for a taxonKey
  Future<int?> getOccurrenceCount(int taxonKey) async {
    try {
      final uri = Uri.parse('${AppConstants.gbifBaseUrl}/occurrence/search').replace(
        queryParameters: {
          'taxonKey': taxonKey.toString(),
          'limit': '0',
        },
      );

      final response = await _client.get(uri).timeout(AppConstants.apiTimeout);

      if (response.statusCode == 200) {
        final data = json.decode(response.body) as Map<String, dynamic>;
        return data['count'] as int?;
      }
      return null;
    } catch (e) {
      developer.log('GBIF getOccurrenceCount error for taxon $taxonKey: $e', name: 'GbifService');
      return null;
    }
  }

  /// Suggests species names as the user types
  Future<List<Map<String, dynamic>>> suggestSpecies(String query) async {
    if (query.trim().length < 2) return [];
    try {
      final uri = Uri.parse('${AppConstants.gbifBaseUrl}/species/suggest').replace(
        queryParameters: {
          'q': query,
          'limit': '6',
        },
      );

      final response = await _client.get(uri).timeout(AppConstants.apiTimeout);

      if (response.statusCode == 200) {
        final list = json.decode(response.body) as List<dynamic>;
        return list.map((item) => item as Map<String, dynamic>).toList();
      }
      return [];
    } catch (e) {
      developer.log('GBIF suggestSpecies error for "$query": $e', name: 'GbifService');
      return [];
    }
  }
}
