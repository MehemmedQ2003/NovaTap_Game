import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants.dart';
import '../../logic/auth_provider.dart';
import '../../logic/theme_provider.dart';
import '../../data/services/badge_service.dart';
import '../components/avatar_selector.dart';
import '../components/badge_widget.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();
    final user = auth.currentUser;

    if (user == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Profil')),
        body: const Center(
          child: Text('Lutfen giris yapin'),
        ),
      );
    }

    final badgeService = BadgeService();
    final unlockedBadges = badgeService.getUnlockedBadges(user.badges);
    final lockedBadges = badgeService.getLockedBadges(user.badges);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Profil'),
        actions: [
          if (!user.isGuest)
            IconButton(
              icon: const Icon(Icons.edit),
              onPressed: () => _showEditAvatarDialog(context, auth),
            ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Profile Header
            _ProfileHeader(user: user),

            const SizedBox(height: 24),

            // Statistics
            _StatisticsSection(user: user),

            const SizedBox(height: 24),

            // Badges Section
            _BadgesSection(
              unlockedBadges: unlockedBadges,
              lockedBadges: lockedBadges,
            ),

            const SizedBox(height: 24),

            // Theme Settings
            _ThemeSection(),

            const SizedBox(height: 24),

            // Logout Button
            if (!user.isGuest)
              SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  onPressed: () {
                    auth.logout();
                    Navigator.popUntil(context, (route) => route.isFirst);
                  },
                  icon: const Icon(Icons.logout, color: AppColors.failure),
                  label: const Text(
                    'Cikis Yap',
                    style: TextStyle(color: AppColors.failure),
                  ),
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: AppColors.failure),
                    padding: const EdgeInsets.all(16),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  void _showEditAvatarDialog(BuildContext context, AuthProvider auth) {
    int selectedAvatar = auth.currentUser?.avatarIndex ?? 0;

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          title: const Text('Avatar Degistir'),
          content: AvatarSelector(
            selectedIndex: selectedAvatar,
            onSelected: (index) {
              setState(() {
                selectedAvatar = index;
              });
            },
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Iptal'),
            ),
            ElevatedButton(
              onPressed: () {
                auth.updateAvatar(selectedAvatar);
                Navigator.pop(context);
              },
              child: const Text('Kaydet'),
            ),
          ],
        ),
      ),
    );
  }
}

class _ProfileHeader extends StatelessWidget {
  final dynamic user;

  const _ProfileHeader({required this.user});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppColors.primary,
            AppColors.primary.withValues(alpha: 0.7),
          ],
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          AvatarWidget(
            avatarIndex: user.avatarIndex,
            size: 80,
            showBorder: true,
          ),
          const SizedBox(height: 16),
          Text(
            user.name,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          if (!user.isGuest)
            Text(
              user.email,
              style: TextStyle(
                fontSize: 14,
                color: Colors.white.withValues(alpha: 0.8),
              ),
            ),
          if (user.isGuest)
            Container(
              margin: const EdgeInsets.only(top: 8),
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Text(
                'Misafir Hesap',
                style: TextStyle(color: Colors.white, fontSize: 12),
              ),
            ),
        ],
      ),
    );
  }
}

class _StatisticsSection extends StatelessWidget {
  final dynamic user;

  const _StatisticsSection({required this.user});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Istatistikler',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Theme.of(context).textTheme.bodyLarge?.color,
          ),
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: _StatCard(
                icon: Icons.games,
                label: 'Oynanan',
                value: '${user.gamesPlayed}',
                color: AppColors.primary,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _StatCard(
                icon: Icons.emoji_events,
                label: 'Kazanilan',
                value: '${user.gamesWon}',
                color: AppColors.success,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _StatCard(
                icon: Icons.star,
                label: 'En Yuksek',
                value: '${user.highScore}',
                color: AppColors.accent,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _StatCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color color;

  const _StatCard({
    required this.icon,
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 28),
          const SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          Text(
            label,
            style: const TextStyle(
              fontSize: 12,
              color: AppColors.neutral,
            ),
          ),
        ],
      ),
    );
  }
}

class _BadgesSection extends StatelessWidget {
  final List unlockedBadges;
  final List lockedBadges;

  const _BadgesSection({
    required this.unlockedBadges,
    required this.lockedBadges,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Rozetler',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).textTheme.bodyLarge?.color,
              ),
            ),
            Text(
              '${unlockedBadges.length}/${unlockedBadges.length + lockedBadges.length}',
              style: const TextStyle(
                fontSize: 14,
                color: AppColors.neutral,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        BadgeGrid(
          unlockedBadges: unlockedBadges.cast(),
          lockedBadges: lockedBadges.cast(),
        ),
      ],
    );
  }
}

class _ThemeSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final themeProvider = context.watch<ThemeProvider>();
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Gorunum',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Theme.of(context).textTheme.bodyLarge?.color,
          ),
        ),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.all(4),
          decoration: BoxDecoration(
            color: isDark ? AppColors.surfaceDark : AppColors.neutralLight,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            children: [
              Expanded(
                child: _ThemeOptionButton(
                  icon: Icons.light_mode,
                  label: 'Acik',
                  isSelected: themeProvider.isLightMode,
                  onTap: () => themeProvider.setThemeMode(ThemeMode.light),
                ),
              ),
              Expanded(
                child: _ThemeOptionButton(
                  icon: Icons.dark_mode,
                  label: 'Koyu',
                  isSelected: themeProvider.isDarkMode,
                  onTap: () => themeProvider.setThemeMode(ThemeMode.dark),
                ),
              ),
              Expanded(
                child: _ThemeOptionButton(
                  icon: Icons.settings_suggest,
                  label: 'Sistem',
                  isSelected: themeProvider.isSystemMode,
                  onTap: () => themeProvider.setThemeMode(ThemeMode.system),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _ThemeOptionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _ThemeOptionButton({
    required this.icon,
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: isSelected
              ? (isDark ? AppColors.primaryDarkTheme : AppColors.primary)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          children: [
            Icon(
              icon,
              color: isSelected
                  ? Colors.white
                  : (isDark ? AppColors.textSecondaryDark : AppColors.textSecondary),
              size: 22,
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                color: isSelected
                    ? Colors.white
                    : (isDark ? AppColors.textSecondaryDark : AppColors.textSecondary),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
