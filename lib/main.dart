import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'core/theme.dart';
import 'logic/game_provider.dart';
import 'logic/auth_provider.dart';
import 'logic/theme_provider.dart';
import 'ui/pages/welcome_page.dart';

void main() {
  runApp(const KelimeOyunuApp());
}

class KelimeOyunuApp extends  StatelessWidget {
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
            home: const WelcomePage(),
          );
        },
      ),
    );
  }
}
