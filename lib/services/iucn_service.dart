import 'dart:convert';
import 'dart:developer' as developer;
import 'package:http/http.dart' as http;
import '../core/constants/app_constants.dart';
import '../core/constants/conservation_status.dart';

class IucnAssessmentDetails {
  final String scientificName;
  final ConservationStatus status;
  final String? assessmentDate;
  final String? criteria;
  final String? populationTrend;
  final List<String> threats;
  final String? source;

  const IucnAssessmentDetails({
    required this.scientificName,
    required this.status,
    this.assessmentDate,
    this.criteria,
    this.populationTrend,
    this.threats = const [],
    this.source = 'IUCN Red List of Threatened Species',
  });
}

class IucnService {
  final http.Client _client;
  final String? apiToken;

  IucnService({http.Client? client, this.apiToken})
      : _client = client ?? http.Client();

  /// Fetches species assessment from IUCN Red List API v3 if an authorized token is provided
  Future<IucnAssessmentDetails?> getSpeciesAssessment(String scientificName) async {
    final token = apiToken;
    if (token == null || token.isEmpty) {
      // Graceful verified fallback: no fake credentials used
      return null;
    }

    try {
      final uri = Uri.parse('${AppConstants.iucnBaseUrl}/species/$scientificName?token=$token');
      final response = await _client.get(uri).timeout(AppConstants.apiTimeout);

      if (response.statusCode == 200) {
        final data = json.decode(response.body) as Map<String, dynamic>;
        final results = data['result'] as List<dynamic>?;
        if (results != null && results.isNotEmpty) {
          final item = results.first as Map<String, dynamic>;
          final categoryCode = item['category']?.toString();
          return IucnAssessmentDetails(
            scientificName: scientificName,
            status: ConservationStatus.fromString(categoryCode),
            assessmentDate: item['assessment_date']?.toString(),
            criteria: item['criteria']?.toString(),
            populationTrend: item['population_trend']?.toString(),
            threats: [],
            source: 'IUCN Red List API v3 (Official Assessment)',
          );
        }
      }
      return null;
    } catch (e) {
      developer.log('IUCN Red List API error for $scientificName: $e', name: 'IucnService');
      return null;
    }
  }

  /// Returns official IUCN criteria explanation for a given category
  String getCategorySummary(ConservationStatus status) {
    switch (status) {
      case ConservationStatus.ex:
        return 'Extinct (EX): Exhaustive surveys in known and expected habitat throughout its historic range have failed to record an individual.';
      case ConservationStatus.ew:
        return 'Extinct in the Wild (EW): Known only to survive in cultivation, in captivity or as a naturalized population well outside the past range.';
      case ConservationStatus.cr:
        return 'Critically Endangered (CR): Facing an extremely high risk of extinction in the wild (criteria A-E observed rapid decline or tiny range).';
      case ConservationStatus.en:
        return 'Endangered (EN): Facing a very high risk of extinction in the wild in the near future.';
      case ConservationStatus.vu:
        return 'Vulnerable (VU): Considered to be facing a high risk of extinction in the wild.';
      case ConservationStatus.nt:
        return 'Near Threatened (NT): Does not qualify for Critically Endangered, Endangered or Vulnerable now, but is close to qualifying.';
      case ConservationStatus.lc:
        return 'Least Concern (LC): Widespread and abundant taxa not qualifying for higher risk categories.';
      case ConservationStatus.dd:
        return 'Data Deficient (DD): Inadequate information to make a direct, or indirect, assessment of its risk of extinction.';
      case ConservationStatus.ne:
        return 'Not Evaluated (NE): Has not yet been evaluated against the criteria.';
    }
  }
}
