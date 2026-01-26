class UserModel {
  final String name;
  final String email;
  final bool isGuest;
  final int avatarIndex;
  final int gamesPlayed;
  final int gamesWon;
  final int highScore;
  final List<String> badges;

  UserModel({
    required this.name,
    required this.email,
    this.isGuest = false,
    this.avatarIndex = 0,
    this.gamesPlayed = 0,
    this.gamesWon = 0,
    this.highScore = 0,
    this.badges = const [],
  });

  factory UserModel.guest() {
    return UserModel(
      name: "Misafir",
      email: "",
      isGuest: true,
      avatarIndex: 0,
    );
  }

  UserModel copyWith({
    String? name,
    String? email,
    bool? isGuest,
    int? avatarIndex,
    int? gamesPlayed,
    int? gamesWon,
    int? highScore,
    List<String>? badges,
  }) {
    return UserModel(
      name: name ?? this.name,
      email: email ?? this.email,
      isGuest: isGuest ?? this.isGuest,
      avatarIndex: avatarIndex ?? this.avatarIndex,
      gamesPlayed: gamesPlayed ?? this.gamesPlayed,
      gamesWon: gamesWon ?? this.gamesWon,
      highScore: highScore ?? this.highScore,
      badges: badges ?? this.badges,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'email': email,
      'isGuest': isGuest,
      'avatarIndex': avatarIndex,
      'gamesPlayed': gamesPlayed,
      'gamesWon': gamesWon,
      'highScore': highScore,
      'badges': badges,
    };
  }

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      name: json['name'] as String,
      email: json['email'] as String,
      isGuest: json['isGuest'] as bool? ?? false,
      avatarIndex: json['avatarIndex'] as int? ?? 0,
      gamesPlayed: json['gamesPlayed'] as int? ?? 0,
      gamesWon: json['gamesWon'] as int? ?? 0,
      highScore: json['highScore'] as int? ?? 0,
      badges: (json['badges'] as List<dynamic>?)?.cast<String>() ?? [],
    );
  }
}
