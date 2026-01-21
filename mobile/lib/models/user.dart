class AppUser {
  final String id;
  final String? email;
  final String? displayName;
  final String? photoUrl;
  final DateTime? createdAt;

  AppUser({
    required this.id,
    this.email,
    this.displayName,
    this.photoUrl,
    this.createdAt,
  });

  factory AppUser.fromJson(Map<String, dynamic> json) {
    return AppUser(
      id: json['id'] as String,
      email: json['email'] as String?,
      displayName: json['displayName'] as String?,
      photoUrl: json['photoUrl'] as String?,
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'] as String)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'displayName': displayName,
      'photoUrl': photoUrl,
      'createdAt': createdAt?.toIso8601String(),
    };
  }

  String get initials {
    if (displayName == null || displayName!.isEmpty) {
      return email?.substring(0, 1).toUpperCase() ?? '?';
    }
    final names = displayName!.split(' ');
    if (names.length >= 2) {
      return '${names[0][0]}${names[1][0]}'.toUpperCase();
    }
    return displayName![0].toUpperCase();
  }

  AppUser copyWith({
    String? id,
    String? email,
    String? displayName,
    String? photoUrl,
    DateTime? createdAt,
  }) {
    return AppUser(
      id: id ?? this.id,
      email: email ?? this.email,
      displayName: displayName ?? this.displayName,
      photoUrl: photoUrl ?? this.photoUrl,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
