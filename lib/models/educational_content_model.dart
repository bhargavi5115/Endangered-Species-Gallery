class EducationalContentModel {
  final String contentId;
  final String title;
  final String subtitle;
  final String description;
  final String imageUrl;
  final String category;
  final String source;
  final String lastUpdated;
  final int readTimeMinutes;
  final List<String> keyPoints;
  final List<String> howToHelp;

  const EducationalContentModel({
    required this.contentId,
    required this.title,
    required this.subtitle,
    required this.description,
    required this.imageUrl,
    required this.category,
    required this.source,
    required this.lastUpdated,
    this.readTimeMinutes = 4,
    this.keyPoints = const [],
    this.howToHelp = const [],
  });

  Map<String, dynamic> toMap() {
    return {
      'contentId': contentId,
      'title': title,
      'subtitle': subtitle,
      'description': description,
      'imageUrl': imageUrl,
      'category': category,
      'source': source,
      'lastUpdated': lastUpdated,
      'readTimeMinutes': readTimeMinutes,
      'keyPoints': keyPoints,
      'howToHelp': howToHelp,
    };
  }

  factory EducationalContentModel.fromMap(Map<String, dynamic> map) {
    return EducationalContentModel(
      contentId: map['contentId'] ?? '',
      title: map['title'] ?? '',
      subtitle: map['subtitle'] ?? '',
      description: map['description'] ?? '',
      imageUrl: map['imageUrl'] ?? '',
      category: map['category'] ?? 'General Conservation',
      source: map['source'] ?? 'WWF / IUCN / UNEP',
      lastUpdated: map['lastUpdated'] ?? '2025',
      readTimeMinutes: map['readTimeMinutes'] ?? 4,
      keyPoints: map['keyPoints'] != null ? List<String>.from(map['keyPoints']) : [],
      howToHelp: map['howToHelp'] != null ? List<String>.from(map['howToHelp']) : [],
    );
  }
}
