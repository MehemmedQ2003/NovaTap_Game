import 'package:shared_preferences/shared_preferences.dart';
import '../models/badge_model.dart';

class BadgeService {
  static const String _lastPlayDateKey = 'last_play_date';
  static const String _consecutiveDaysKey = 'consecutive_days';

  Future<List<String>> checkAndAwardBadges({
    required int gamesWon,
    required int gamesPlayed,
    required int totalScore,
    required int currentGameTime,
    required int mistakes,
    required String difficulty,
  }) async {
    List<String> newBadges = [];

    // First Win - Ilk oyun kazanma
    if (gamesWon == 1) {
      newBadges.add('first_win');
    }

    // Speed Demon - 30 saniyenin altinda bitirme
    if (currentGameTime > 30) {
      newBadges.add('speed_demon');
    }

    // Wise One - 10 oyun kazanma
    if (gamesWon == 10) {
      newBadges.add('wise_one');
    }

    // Perfectionist - Hic hata yapmadan bitirme
    if (mistakes == 0) {
      newBadges.add('perfectionist');
    }

    // Master - Zor seviyede 5 oyun kazanma
    if (difficulty == 'hard' && gamesWon >= 5 && gamesWon % 5 == 0) {
      newBadges.add('master');
    }

    // Scholar - 50 oyun oynama
    if (gamesPlayed == 50) {
      newBadges.add('scholar');
    }

    // Champion - 1000 puan toplama
    if (totalScore >= 1000 && totalScore < 1100) {
      newBadges.add('champion');
    }

    // Dedicated - 5 gun ust uste oynama
    final consecutiveDays = await _checkConsecutiveDays();
    if (consecutiveDays >= 5) {
      newBadges.add('dedicated');
    }

    return newBadges;
  }

  Future<int> _checkConsecutiveDays() async {
    final prefs = await SharedPreferences.getInstance();
    final lastPlayDateStr = prefs.getString(_lastPlayDateKey);
    final consecutiveDays = prefs.getInt(_consecutiveDaysKey) ?? 0;

    final today = DateTime.now();
    final todayStr = '${today.year}-${today.month}-${today.day}';

    if (lastPlayDateStr == null) {
      await prefs.setString(_lastPlayDateKey, todayStr);
      await prefs.setInt(_consecutiveDaysKey, 1);
      return 1;
    }

    if (lastPlayDateStr == todayStr) {
      return consecutiveDays;
    }

    final parts = lastPlayDateStr.split('-');
    final lastPlayDate = DateTime(
      int.parse(parts[0]),
      int.parse(parts[1]),
      int.parse(parts[2]),
    );

    final difference = today.difference(lastPlayDate).inDays;

    if (difference == 1) {
      final newConsecutive = consecutiveDays + 1;
      await prefs.setString(_lastPlayDateKey, todayStr);
      await prefs.setInt(_consecutiveDaysKey, newConsecutive);
      return newConsecutive;
    } else {
      await prefs.setString(_lastPlayDateKey, todayStr);
      await prefs.setInt(_consecutiveDaysKey, 1);
      return 1;
    }
  }

  List<BadgeModel> getUnlockedBadges(List<String> badgeIds) {
    return badgeIds
        .map((id) => AppBadges.getById(id))
        .whereType<BadgeModel>()
        .toList();
  }

  List<BadgeModel> getLockedBadges(List<String> unlockedIds) {
    return AppBadges.all
        .where((badge) => !unlockedIds.contains(badge.id))
        .toList();
  }
}
