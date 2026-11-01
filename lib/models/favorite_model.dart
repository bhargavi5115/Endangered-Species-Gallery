class FavoriteModel {
  final String speciesId;
  final String userId;
  final DateTime addedAt;

  const FavoriteModel({
    required this.speciesId,
    required this.userId,
    required this.addedAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'speciesId': speciesId,
      'userId': userId,
      'addedAt': addedAt.toIso8601String(),
    };
  }

  factory FavoriteModel.fromMap(Map<String, dynamic> map) {
    return FavoriteModel(
      speciesId: map['speciesId'] ?? '',
      userId: map['userId'] ?? '',
      addedAt: map['addedAt'] != null
          ? DateTime.tryParse(map['addedAt']) ?? DateTime.now()
          : DateTime.now(),
    );
  }
}
