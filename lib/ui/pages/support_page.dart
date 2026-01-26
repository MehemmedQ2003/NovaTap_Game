import 'package:flutter/material.dart';
import '../../core/constants.dart';
import 'contact_page.dart';

class SupportPage extends StatelessWidget {
  const SupportPage({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return DefaultTabController(
      length: 4,
      child: Scaffold(
        backgroundColor: isDark
            ? AppColors.backgroundDark
            : AppColors.background,
        appBar: AppBar(
          backgroundColor: isDark ? AppColors.surfaceDark : AppColors.primary,
          title: const Text('Destek'),
          bottom: TabBar(
            isScrollable: true,
            indicatorColor: AppColors.accent,
            indicatorWeight: 3,
            labelColor: Colors.white,
            unselectedLabelColor: Colors.white70,
            labelStyle: const TextStyle(fontWeight: FontWeight.bold),
            tabs: const [
              Tab(text: 'Nasıl Oynanır'),
              Tab(text: 'SSS'),
              Tab(text: 'İletişim'),
              Tab(text: 'Hakkında'),
            ],
          ),
        ),
        body: const TabBarView(
          children: [_HowToPlayTab(), _FaqTab(), _ContactTab(), _AboutTab()],
        ),
      ),
    );
  }
}

class _HowToPlayTab extends StatelessWidget {
  const _HowToPlayTab();

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: const [
        _SectionCard(
          icon: Icons.play_circle_outline,
          title: 'Oyunun Amacı',
          content:
              'Verilen ipucuna göre gizli kelimeyi harfleri tahmin ederek bulmaktır.',
        ),
        _SectionCard(
          icon: Icons.touch_app,
          title: 'Nasıl Oynanır',
          content: '''1. Ekrandaki ipucunu okuyun
2. Türkçe klavyeden harfleri seçin
3. Doğru harfler açılır, yanlış harfler can kaybettirir
4. Tüm harfleri süre bitmeden bulun''',
        ),
        _SectionCard(
          icon: Icons.lightbulb_outline,
          title: 'Joker Hakları',
          content: '''- Arkadaşı Ara: Doğru bir harfi gösterir
- 50/50: Yanlış 2 harfi eler
- Pas Geç: Soruyu atlar (puan kaybı yok)

Her joker oyun başına 1 kez kullanılabilir.''',
        ),
        _SectionCard(
          icon: Icons.star_outline,
          title: 'Puan Sistemi',
          content: '''- Her doğru harf: +10 puan
- Joker ile bulunan harf: +5 puan
- Kazanma bonusu: Kalan süre + Can x 10
- Zorluk çarpanı: Kolay x1, Normal x2, Zor x3
- Kaybetme: -50 puan''',
        ),
        _SectionCard(
          icon: Icons.favorite_outline,
          title: 'Can Sistemi',
          content:
              'Her oyunda 3 canınız var. Yanlış tahmin veya süre dolması can kaybettirir.',
        ),
        _SectionCard(
          icon: Icons.timer_outlined,
          title: 'Süre Sistemi',
          content: '''- Kolay: 90 saniye
- Normal: 60 saniye
- Zor: 30 saniye''',
        ),
        _SectionCard(
          icon: Icons.emoji_events_outlined,
          title: 'Rozetler',
          content:
              'Özel başarılara ulaşarak rozetler kazanın! Profil sayfanızdan kazandığınız rozetleri görebilirsiniz.',
        ),
      ],
    );
  }
}

class _FaqTab extends StatefulWidget {
  const _FaqTab();

  @override
  State<_FaqTab> createState() => _FaqTabState();
}

class _FaqTabState extends State<_FaqTab> {
  final faqs = [
    {
      "q": "Skorlarım kaydediliyor mu?",
      "a": "Evet, en yüksek 10 skorunuz cihazınızda saklanır.",
    },
    {
      "q": "Misafir olarak oynarsam skorlarım kaydedilir mi?",
      "a": "Evet, misafir oyunu sırasında da skorlarınız cihazınızda tutulur.",
    },
    {
      "q": "Hesabımı nasıl silebilirim?",
      "a":
          "Profil sayfasından çıkış yaptıktan sonra uygulamayı kaldırıp yeniden yükleyerek kayıtlı verilerinizi silebilirsiniz.",
    },
    {
      "q": "İnternet bağlantısı gerekli mi?",
      "a": "Hayır, oyun tamamen çevrimdışı çalışır.",
    },
    {
      "q": "Yeni kelimeler ekleniyor mu?",
      "a": "Güncellemelerle yeni soru setleri eklenebilmektedir.",
    },
    {
      "q": "Çok oyunculu mod nasıl çalışır?",
      "a":
          "Sırasıyla iki oyuncu aynı cihazda oynar ve tur başına en çok puanı toplayana kazanır.",
    },
    {
      "q": "Rozetleri nasıl kazanırım?",
      "a":
          "Hızlı ve doğru hamleleriniz, kazandığınız seviyelere göre rozet kilitlerini açar.",
    },
    {
      "q": "Şikayet veya geri bildirimimi nereye yazmalıyım?",
      "a":
          "Destek sayfasındaki iletişim formunu kullanarak şikayetinizi bize ulaştırabilirsiniz, ekip en kısa sürede döner.",
    },
  ];

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: ExpansionPanelList.radio(
        expandedHeaderPadding: const EdgeInsets.symmetric(vertical: 4),
        elevation: 0,
        children: faqs.asMap().entries.map((entry) {
          final index = entry.key;
          final faq = entry.value;

          return ExpansionPanelRadio(
            value: index,
            canTapOnHeader: true,
            headerBuilder: (context, isExpanded) {
              return ListTile(
                leading: CircleAvatar(
                  backgroundColor: isDark
                      ? AppColors.primaryDarkTheme.withValues(alpha: 0.2)
                      : AppColors.primary.withValues(alpha: 0.1),
                  child: Text(
                    '${index + 1}',
                    style: TextStyle(
                      color: isDark
                          ? AppColors.primaryDarkTheme
                          : AppColors.primary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                title: Text(
                  faq['q']!,
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    color: isDark ? AppColors.textLight : AppColors.textDark,
                  ),
                ),
              );
            },
            body: Container(
              width: double.infinity,
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
              decoration: BoxDecoration(
                color: isDark ? AppColors.cardBackgroundDark : Colors.white,
                borderRadius: const BorderRadius.vertical(
                  bottom: Radius.circular(12),
                ),
              ),
              child: Text(
                faq['a']!,
                style: TextStyle(
                  color: isDark
                      ? AppColors.textSecondaryDark
                      : AppColors.neutral,
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}

class _ContactTab extends StatelessWidget {
  const _ContactTab();

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        const _SectionCard(
          icon: Icons.email_outlined,
          title: 'E-posta',
          content: 'destek@dinikelimeavcisi.com',
        ),
        const _SectionCard(
          icon: Icons.bug_report_outlined,
          title: 'Hata Bildirimi',
          content:
              'Uygulamada bir hata bulduysanız lütfen e-posta ile bize bildirin.',
        ),
        const _SectionCard(
          icon: Icons.lightbulb_outline,
          title: 'Öneri',
          content:
              'Yeni kelime önerileri veya özellik istekleri için bize ulaşın.',
        ),
        const SizedBox(height: 24),
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: isDark
                ? AppColors.primaryDarkTheme.withValues(alpha: 0.15)
                : AppColors.primary.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: isDark
                  ? AppColors.primaryDarkTheme.withValues(alpha: 0.3)
                  : AppColors.primary.withValues(alpha: 0.3),
            ),
          ),
          child: Column(
            children: [
              const Icon(Icons.favorite, color: AppColors.failure, size: 48),
              const SizedBox(height: 12),
              Text(
                'Uygulamayı Değerlendir',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: isDark ? AppColors.textLight : AppColors.textDark,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Uygulamamızı beğendiyseniz lütfen değerlendirin!',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: isDark
                      ? AppColors.textSecondaryDark
                      : AppColors.neutral,
                ),
              ),
              const SizedBox(height: 16),
              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: isDark
                      ? AppColors.primaryDarkTheme
                      : AppColors.primary,
                ),
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: const Text(
                        'Teşekkürler! Değerlendirmeniz bizim için önemli.',
                      ),
                      backgroundColor: AppColors.success,
                      behavior: SnackBarBehavior.floating,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  );
                },
                icon: const Icon(Icons.star),
                label: const Text('Değerlendir'),
              ),
              const SizedBox(height: 12),
              OutlinedButton.icon(
                style: OutlinedButton.styleFrom(
                  foregroundColor: isDark
                      ? AppColors.primaryDarkTheme
                      : AppColors.primary,
                  side: BorderSide(
                    color: isDark
                        ? AppColors.primaryDarkTheme.withValues(alpha: 0.6)
                        : AppColors.primary.withValues(alpha: 0.6),
                  ),
                  padding: const EdgeInsets.symmetric(
                    vertical: 12,
                    horizontal: 16,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const ContactPage()),
                ),
                icon: const Icon(Icons.send),
                label: const Text('İletişim Formu'),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _AboutTab extends StatelessWidget {
  const _AboutTab();

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        // App Logo & Info
        Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: isDark
                  ? [AppColors.primaryDarkTheme, AppColors.primaryDarkDarkTheme]
                  : [AppColors.primary, AppColors.primaryDark],
            ),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.2),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.mosque, size: 48, color: Colors.white),
              ),
              const SizedBox(height: 16),
              const Text(
                'Dini Kelime Avcısı',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'Versiyon 1.0.0',
                style: TextStyle(color: Colors.white.withValues(alpha: 0.8)),
              ),
            ],
          ),
        ),

        const SizedBox(height: 24),

        const _SectionCard(
          icon: Icons.info_outline,
          title: 'Uygulama Hakkında',
          content:
              'Dini Kelime Avcısı, dini terimleri eğitici ve eğlenceli bir şekilde öğrenmenizi sağlayan bir kelime tahmin oyunudur.',
        ),

        const _SectionCard(
          icon: Icons.people_outline,
          title: 'Geliştirici',
          content:
              'Bu uygulama, kullanıcıların dini bilgilerini artırmak amacıyla geliştirilmiştir.',
        ),

        // Privacy Policy
        Card(
          margin: const EdgeInsets.only(bottom: 12),
          color: isDark ? AppColors.cardBackgroundDark : Colors.white,
          child: ExpansionTile(
            leading: Icon(
              Icons.privacy_tip_outlined,
              color: isDark ? AppColors.primaryDarkTheme : AppColors.primary,
            ),
            title: Text(
              'Gizlilik Politikası',
              style: TextStyle(
                fontWeight: FontWeight.w600,
                color: isDark ? AppColors.textLight : AppColors.textDark,
              ),
            ),
            iconColor: isDark ? AppColors.primaryDarkTheme : AppColors.primary,
            collapsedIconColor: isDark
                ? AppColors.textSecondaryDark
                : AppColors.neutral,
            children: [
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Veri Toplama',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: isDark
                            ? AppColors.textLight
                            : AppColors.textDark,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Bu uygulama sadece cihazınızda yerel olarak veri saklar. Hiçbir kişisel veriniz sunuculara gönderilmez.',
                      style: TextStyle(
                        color: isDark
                            ? AppColors.textSecondaryDark
                            : AppColors.neutral,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Saklanan Veriler',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: isDark
                            ? AppColors.textLight
                            : AppColors.textDark,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '- Kullanıcı adı ve tercihleri\n- Oyun skorları\n- Kazanılan rozetler',
                      style: TextStyle(
                        color: isDark
                            ? AppColors.textSecondaryDark
                            : AppColors.neutral,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Veri Silme',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: isDark
                            ? AppColors.textLight
                            : AppColors.textDark,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Uygulamayı kaldırarak tüm verilerinizi silebilirsiniz.',
                      style: TextStyle(
                        color: isDark
                            ? AppColors.textSecondaryDark
                            : AppColors.neutral,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),

        // Terms
        Card(
          margin: const EdgeInsets.only(bottom: 12),
          color: isDark ? AppColors.cardBackgroundDark : Colors.white,
          child: ExpansionTile(
            leading: Icon(
              Icons.description_outlined,
              color: isDark ? AppColors.primaryDarkTheme : AppColors.primary,
            ),
            title: Text(
              'Kullanım Şartları',
              style: TextStyle(
                fontWeight: FontWeight.w600,
                color: isDark ? AppColors.textLight : AppColors.textDark,
              ),
            ),
            iconColor: isDark ? AppColors.primaryDarkTheme : AppColors.primary,
            collapsedIconColor: isDark
                ? AppColors.textSecondaryDark
                : AppColors.neutral,
            children: [
              Padding(
                padding: const EdgeInsets.all(16),
                child: Text(
                  'Bu uygulamayı kullanarak aşağıdaki şartları kabul etmiş sayılırsınız:\n\n'
                  '1. Uygulama sadece eğitim amaçlı kullanılmalıdır.\n'
                  '2. İçerikler genel bilgi amaçlıdır, fetva niteliği taşımaz.\n'
                  '3. Uygulama "olduğu gibi" sunulmaktadır.',
                  style: TextStyle(
                    color: isDark
                        ? AppColors.textSecondaryDark
                        : AppColors.neutral,
                  ),
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 24),

        Center(
          child: Text(
            '© 2024 Dini Kelime Avcısı. Tüm hakları saklıdır.',
            style: TextStyle(
              fontSize: 12,
              color: isDark
                  ? AppColors.textSecondaryDark.withValues(alpha: 0.7)
                  : AppColors.neutral.withValues(alpha: 0.7),
            ),
          ),
        ),
      ],
    );
  }
}

class _SectionCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String content;

  const _SectionCard({
    required this.icon,
    required this.title,
    required this.content,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      color: isDark ? AppColors.cardBackgroundDark : Colors.white,
      elevation: isDark ? 2 : 1,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: isDark
                    ? AppColors.primaryDarkTheme.withValues(alpha: 0.2)
                    : AppColors.primary.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(
                icon,
                color: isDark ? AppColors.primaryDarkTheme : AppColors.primary,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: isDark ? AppColors.textLight : AppColors.textDark,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    content,
                    style: TextStyle(
                      color: isDark
                          ? AppColors.textSecondaryDark
                          : AppColors.neutral,
                      height: 1.4,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
