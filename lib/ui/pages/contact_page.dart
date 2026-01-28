import 'package:flutter/material.dart';
import '../../core/constants.dart';

class ContactPage extends StatefulWidget {
  const ContactPage({super.key});

  @override
  State<ContactPage> createState() => _ContactPageState();
}

class _ContactPageState extends State<ContactPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _messageController = TextEditingController();
  bool _isSending = false;

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isSending = true);
    await Future.delayed(const Duration(milliseconds: 400));
    if (!mounted) return;

    setState(() => _isSending = false);
    _nameController.clear();
    _emailController.clear();
    _messageController.clear();

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Mesajınız alındı, en kısa sürede size döneceğiz.'),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _messageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final borderColor = isDark
        ? AppColors.cardBackgroundDark
        : AppColors.neutral;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: isDark ? AppColors.surfaceDark : AppColors.primary,
        title: const Text('İletişim'),
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
        children: [
          Text(
            'Bize ulaşın',
            style: TextStyle(
              fontSize: 26,
              fontWeight: FontWeight.bold,
              color: isDark ? AppColors.textLight : AppColors.textDark,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Her türlü soru, öneri veya şikayetinizi aşağıdaki formdan iletebilirsiniz.',
            style: TextStyle(
              color: isDark ? AppColors.textSecondaryDark : AppColors.neutral,
              height: 1.4,
            ),
          ),
          const SizedBox(height: 24),
          Form(
            key: _formKey,
            child: Column(
              children: [
                TextFormField(
                  controller: _nameController,
                  decoration: InputDecoration(
                    labelText: 'Adınız',
                    prefixIcon: const Icon(Icons.person_outline),
                    filled: true,
                    fillColor: isDark
                        ? AppColors.cardBackgroundDark
                        : Colors.white.withValues(alpha: 0.8),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: borderColor),
                    ),
                  ),
                  validator: (value) =>
                      (value ?? '').trim().isEmpty ? 'Adınızı giriniz.' : null,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _emailController,
                  decoration: InputDecoration(
                    labelText: 'E-posta',
                    prefixIcon: const Icon(Icons.email_outlined),
                    filled: true,
                    fillColor: isDark
                        ? AppColors.cardBackgroundDark
                        : Colors.white.withValues(alpha: 0.8),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: borderColor),
                    ),
                  ),
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) {
                    final email = (value ?? '').trim();
                    if (email.isEmpty) {
                      return 'E-posta adresinizi yazınız.';
                    }
                    if (!email.contains('@')) {
                      return 'Geçerli bir e-posta giriniz.';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _messageController,
                  decoration: InputDecoration(
                    labelText: 'Mesajınız',
                    alignLabelWithHint: true,
                    prefixIcon: const Icon(Icons.message_outlined),
                    filled: true,
                    fillColor: isDark
                        ? AppColors.cardBackgroundDark
                        : Colors.white.withValues(alpha: 0.8),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: borderColor),
                    ),
                  ),
                  maxLines: 5,
                  validator: (value) => (value ?? '').trim().isEmpty
                      ? 'Lütfen bir mesaj yazın.'
                      : null,
                ),
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: isDark
                          ? AppColors.primaryDarkTheme
                          : AppColors.primary,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    onPressed: _isSending ? null : _submit,
                    child: Text(
                      _isSending ? 'Gönderiliyor...' : 'Gönder',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
