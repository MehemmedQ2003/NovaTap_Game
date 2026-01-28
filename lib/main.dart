import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'core/theme.dart';
import 'logic/game_provider.dart';
import 'logic/auth_provider.dart';
import 'logic/theme_provider.dart';
import 'ui/pages/welcome_page.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const KelimeOyunuApp());
}

class KelimeOyunuApp extends StatelessWidget {
  const KelimeOyunuApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => GameProvider()),
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
      ],
      child: Consumer<ThemeProvider>(
        builder: (context, themeProvider, child) {
          return MaterialApp(
            title: 'Quran Word',
            debugShowCheckedModeBanner: false,
            theme: AppTheme.lightTheme,
            darkTheme: AppTheme.darkTheme,
            themeMode: themeProvider.themeMode,
            home: const SessionWrapper(),
          );
        },
      ),
    );
  }
}

class SessionWrapper extends StatefulWidget {
  const SessionWrapper({super.key});

  @override
  State<SessionWrapper> createState() => _SessionWrapperState();
}

class _SessionWrapperState extends State<SessionWrapper> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _setupSessionListener();
    });
  }

  void _setupSessionListener() {
    final auth = context.read<AuthProvider>();
    auth.addListener(_onAuthChanged);
  }

  void _onAuthChanged() {
    final auth = context.read<AuthProvider>();
    if (auth.isSessionExpired) {
      _showSessionExpiredDialog();
    }
  }

  void _showSessionExpiredDialog() {
    if (!mounted) return;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: const Row(
          children: [
            Icon(Icons.timer_off, color: Colors.orange),
            SizedBox(width: 10),
            Text('Oturum Süresi Doldu'),
          ],
        ),
        content: const Text(
          'Güvenliğiniz için oturumunuz sonlandırıldı. Devam etmek için lütfen tekrar giriş yapın.',
        ),
        actions: [
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(builder: (_) => const WelcomePage()),
                (route) => false,
              );
            },
            child: const Text('Giriş Yap'),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    final auth = context.read<AuthProvider>();
    auth.removeListener(_onAuthChanged);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return const WelcomePage();
  }
}
