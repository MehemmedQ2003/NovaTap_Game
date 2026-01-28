import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants.dart';
import '../../logic/auth_provider.dart';
import '../../logic/theme_provider.dart';
import '../../data/services/badge_service.dart';
import '../components/avatar_selector.dart';
import '../components/badge_widget.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  bool _isEditing = false;
  bool _isSaving = false;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_isEditing) {
      final user = context.read<AuthProvider>().currentUser;
      if (user != null) {
        _nameController.text = user.name;
        _emailController.text = user.email;
      }
    }
  }

  void _toggleEditing(AuthProvider auth) {
    if (_isEditing) {
      setState(() => _isEditing = false);
      return;
    }

    final user = auth.currentUser;
    _nameController.text = user?.name ?? '';
    _emailController.text = user?.email ?? '';
    setState(() => _isEditing = true);
  }

  Future<void> _saveProfile(AuthProvider auth) async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isSaving = true);
    await auth.updateProfile(
      name: _nameController.text.trim(),
      email: _emailController.text.trim(),
    );
    if (!mounted) return;

    setState(() {
      _isSaving = false;
      _isEditing = false;
    });

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Profil güncellendi')));
  }

  Widget _buildEditCard(bool isDark) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? AppColors.cardBackgroundDark : Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'Profil Bilgilerini Güncelle',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
              color: isDark ? AppColors.textLight : AppColors.textDark,
            ),
          ),
          const SizedBox(height: 12),
          TextFormField(
            controller: _nameController,
            decoration: InputDecoration(
              labelText: 'Ad Soyad',
              filled: true,
              fillColor: isDark
                  ? AppColors.surfaceDark
                  : AppColors.neutralLight,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(
                  color: isDark
                      ? AppColors.neutralDark
                      : AppColors.neutralLight,
                ),
              ),
            ),
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return 'Ad soyad boş olamaz';
              }
              return null;
            },
          ),
          const SizedBox(height: 12),
          TextFormField(
            controller: _emailController,
            keyboardType: TextInputType.emailAddress,
            autofillHints: const [AutofillHints.email],
            decoration: InputDecoration(
              labelText: 'E-posta',
              filled: true,
              fillColor: isDark
                  ? AppColors.surfaceDark
                  : AppColors.neutralLight,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(
                  color: isDark
                      ? AppColors.neutralDark
                      : AppColors.neutralLight,
                ),
              ),
            ),
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return 'E-posta boş olamaz';
              }
              if (!value.contains('@')) {
                return 'Geçerli e-posta giriniz';
              }
              return null;
            },
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();
    final user = auth.currentUser;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    if (user == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Profil')),
        body: const Center(child: Text('Lütfen giriş yapın')),
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
              icon: Icon(_isEditing ? Icons.close : Icons.edit),
              onPressed: () => _toggleEditing(auth),
            ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              _ProfileHeader(user: user),
              if (!user.isGuest)
                Container(
                  margin: const EdgeInsets.only(top: 12),
                  child: OutlinedButton.icon(
                    onPressed: () => _showEditAvatarDialog(context, auth),
                    icon: const Icon(Icons.edit, size: 18),
                    label: const Text('Avatarı Değiştir'),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.white,
                      side: const BorderSide(color: Colors.white70),
                      padding: const EdgeInsets.symmetric(
                        vertical: 12,
                        horizontal: 20,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ),
              const SizedBox(height: 24),
              if (_isEditing) _buildEditCard(isDark),
              if (_isEditing)
                Padding(
                  padding: const EdgeInsets.only(top: 16, bottom: 24),
                  child: SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      onPressed: _isSaving ? null : () => _saveProfile(auth),
                      child: _isSaving
                          ? const SizedBox(
                              height: 18,
                              width: 18,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Colors.white,
                              ),
                            )
                          : const Text(
                              'Tamamla',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                    ),
                  ),
                ),
              const SizedBox(height: 24),
              _StatisticsSection(user: user),
              const SizedBox(height: 24),
              _BadgesSection(
                unlockedBadges: unlockedBadges,
                lockedBadges: lockedBadges,
              ),
              const SizedBox(height: 24),
              _ThemeSection(),
              const SizedBox(height: 24),
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
                      'Çıkış Yap',
                      style: TextStyle(color: AppColors.failure),
                    ),
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: AppColors.failure),
                      padding: const EdgeInsets.all(16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ),
            ],
          ),
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
          title: const Text('Avatar Değiştir'),
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
              child: const Text('İptal'),
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
          colors: [AppColors.primary, AppColors.primary.withValues(alpha: 0.7)],
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
          'İstatistikler',
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
                value: '',
                color: AppColors.primary,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _StatCard(
                icon: Icons.emoji_events,
                label: 'Kazanılan',
                value: '',
                color: AppColors.success,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _StatCard(
                icon: Icons.star,
                label: 'En Yüksek',
                value: '',
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
            style: const TextStyle(fontSize: 12, color: AppColors.neutral),
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
              '/',
              style: const TextStyle(fontSize: 14, color: AppColors.neutral),
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
          'Görünüm',
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
                  label: 'Açık',
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
                  : (isDark
                        ? AppColors.textSecondaryDark
                        : AppColors.textSecondary),
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
                    : (isDark
                          ? AppColors.textSecondaryDark
                          : AppColors.textSecondary),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
