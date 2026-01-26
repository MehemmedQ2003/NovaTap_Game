import 'package:flutter/material.dart';

class BadgeModel {
  final String id;
  final String name;
  final String description;
  final IconData icon;
  final Color color;

  const BadgeModel({
    required this.id,
    required this.name,
    required this.description,
    required this.icon,
    required this.color,
  });
}

class AppBadges {
  static const List<BadgeModel> all = [
    BadgeModel(
      id: 'first_win',
      name: 'Ilk Zafer',
      description: 'Ilk oyununu kazan',
      icon: Icons.emoji_events,
      color: Color(0xFFFFD700),
    ),
    BadgeModel(
      id: 'speed_demon',
      name: 'Hizli Parmak',
      description: '30 saniyenin altinda bitir',
      icon: Icons.speed,
      color: Color(0xFFFF5722),
    ),
    BadgeModel(
      id: 'wise_one',
      name: 'Bilge',
      description: '10 oyun kazan',
      icon: Icons.school,
      color: Color(0xFF9C27B0),
    ),
    BadgeModel(
      id: 'perfectionist',
      name: 'Mukemmeliyetci',
      description: 'Hic hata yapmadan bitir',
      icon: Icons.stars,
      color: Color(0xFF4CAF50),
    ),
    BadgeModel(
      id: 'dedicated',
      name: 'Kararli',
      description: '5 gun ust uste oyna',
      icon: Icons.local_fire_department,
      color: Color(0xFFE91E63),
    ),
    BadgeModel(
      id: 'master',
      name: 'Usta',
      description: 'Zor seviyede 5 oyun kazan',
      icon: Icons.workspace_premium,
      color: Color(0xFF00BCD4),
    ),
    BadgeModel(
      id: 'scholar',
      name: 'Alim',
      description: '50 oyun oyna',
      icon: Icons.menu_book,
      color: Color(0xFF795548),
    ),
    BadgeModel(
      id: 'champion',
      name: 'Sampiyon',
      description: '1000 puan topla',
      icon: Icons.military_tech,
      color: Color(0xFF3F51B5),
    ),
  ];

  static BadgeModel? getById(String id) {
    try {
      return all.firstWhere((badge) => badge.id == id);
    } catch (e) {
      return null;
    }
  }
}
