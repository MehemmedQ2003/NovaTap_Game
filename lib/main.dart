import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'core/theme.dart';
import 'logic/game_provider.dart';
import 'logic/auth_provider.dart';
import 'ui/pages/welcome_page.dart';

void main() {
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
      ],
      child: MaterialApp(
        title: 'Quran Word',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.lightTheme,
        home: const WelcomePage(),
      ),
    );
  }
}
