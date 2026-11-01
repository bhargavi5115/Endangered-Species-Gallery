class UserModel {
  final String userId;
  final String displayName;
  final String email;
  final String? profileImage;
  final DateTime createdAt;
  final bool isGuest;

  const UserModel({
    required this.userId,
    required this.displayName,
    required this.email,
    this.profileImage,
    required this.createdAt,
    this.isGuest = false,
  });

  UserModel copyWith({
    String? userId,
    String? displayName,
    String? email,
    String? profileImage,
    DateTime? createdAt,
    bool? isGuest,
  }) {
    return UserModel(
      userId: userId ?? this.userId,
      displayName: displayName ?? this.displayName,
      email: email ?? this.email,
      profileImage: profileImage ?? this.profileImage,
      createdAt: createdAt ?? this.createdAt,
      isGuest: isGuest ?? this.isGuest,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'displayName': displayName,
      'email': email,
      'profileImage': profileImage,
      'createdAt': createdAt.toIso8601String(),
      'isGuest': isGuest,
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      userId: map['userId'] ?? '',
      displayName: map['displayName'] ?? 'Wildlife Supporter',
      email: map['email'] ?? '',
      profileImage: map['profileImage'],
      createdAt: map['createdAt'] != null
          ? DateTime.tryParse(map['createdAt']) ?? DateTime.now()
          : DateTime.now(),
      isGuest: map['isGuest'] == true,
    );
  }

  factory UserModel.guest() {
    return UserModel(
      userId: 'guest_user',
      displayName: 'Conservation Guest',
      email: 'guest@wildlife.org',
      createdAt: DateTime.now(),
      isGuest: true,
    );
  }
}
